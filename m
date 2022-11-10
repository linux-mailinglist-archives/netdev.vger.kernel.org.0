Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F956624162
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiKJL2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKJL2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:28:04 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9436315B;
        Thu, 10 Nov 2022 03:28:03 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-367cd2807f2so12721257b3.1;
        Thu, 10 Nov 2022 03:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eBtvbRmOjTNlNNYrnr0uoJa+eJPhqmUrF3eWNBDAcyE=;
        b=B9mKf68Yt785zBcI1HE09Ms4Qjrx18S1LVKV3TfOE/XeBeQmx3Uw4NhLW0ZYQ2tr07
         7gFtY6/LT0+EnbBMITWPAwKuD5MCMDQoMeTswz7Q0SgeRssy4Yt/SABkPFnwPLeoEutx
         99k1nDB9wjb2csRWQTdzSJl52+WhgQzJVDkzcMCmHImehAk87EYgGzTcd2YZyCMy5qBk
         6ayERXa2ZV/rKLURWfTy7NkiSEaa67z80VBb+oWbkKc0+Uz0jBA8FWJhVRzL1vqifHs9
         WnHbtFAOgz9ExAy5D+cqSLFg2O4M8s34qTQId3EUhPEpf/P5O6D894HH651U3Tp6/sZm
         mPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eBtvbRmOjTNlNNYrnr0uoJa+eJPhqmUrF3eWNBDAcyE=;
        b=rolCdbvwIvmvEb/gZ3eOo0zjcxlnuHTg5nvRiget8xe8hwFHe1cN42exdgDaXRVMGQ
         rP+UyqDCQfCktA7nP/nFhCv4WHrr7PjVmgogFhSuaQwk3vktDDiW0w1Y6TdahehyPfAm
         17KkkgHfVxlVJgFD2qd/NylQ7UDN1QtwGmwGVaroMSioxAdT+9L9GSp2qWPEam9urrLm
         y5WAXLhmvQSC/hM1ezctW5joZqICf/zrXwsNNRTvSGgcWLGcYAwU2q4hPuvb3s5txjKg
         059djvNLsB5w68HQla2ftv+K2l7ibqWps/qbD21brbzmPxtyk+Q6UxFGEP0HbIow2mEq
         xa2w==
X-Gm-Message-State: ACrzQf3YJK9F6b/3uuJ50sRAuUu4JqnKP1yY7hCtfKZcsbQzAK6HROOb
        aalutZpf2cKRolesbg2D3Tzl/R7bogOrX9M5gIU=
X-Google-Smtp-Source: AMsMyM4gYb8hJioGtOkVt/aLQ7+EWkNNm63rgBYYKdHr6JHoNLTYIzMB1SHKg6AKWIIjvYS2nbnFF6vSNXtypFTBAX8=
X-Received: by 2002:a81:7485:0:b0:369:1a99:d437 with SMTP id
 p127-20020a817485000000b003691a99d437mr61967710ywc.406.1668079683107; Thu, 10
 Nov 2022 03:28:03 -0800 (PST)
MIME-Version: 1.0
References: <20221108125254.688234-1-nashuiliang@gmail.com> <63f95025240ce6fa9d9c57ac26875d67dfd2bc71.camel@redhat.com>
In-Reply-To: <63f95025240ce6fa9d9c57ac26875d67dfd2bc71.camel@redhat.com>
From:   Chuang W <nashuiliang@gmail.com>
Date:   Thu, 10 Nov 2022 19:27:52 +0800
Message-ID: <CACueBy5zSfmK_Pm-f7FmCZ1FhgvLpp7w+qKm82WMmDb3n5ZY7w@mail.gmail.com>
Subject: Re: [PATCH v1] net: macvlan: Use built-in RCU list checking
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Nov 10, 2022 at 6:57 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Tue, 2022-11-08 at 20:52 +0800, Chuang Wang wrote:
> > hlist_for_each_entry_rcu() has built-in RCU and lock checking.
> >
> > Pass cond argument to hlist_for_each_entry_rcu() to silence false
> > lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.
> >
> > Execute as follow:
> >
> >  ip link add link eth0 type macvlan mode source macaddr add <MAC-ADDR>
> >
> > The rtnl_lock is held when macvlan_hash_lookup_source() or
> > macvlan_fill_info_macaddr() are called in the non-RCU read side section.
> > So, pass lockdep_rtnl_is_held() to silence false lockdep warning.
> >
> > Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
>
> The patch LGTM, but IMHO this should target the -net tree, as it's
> addressing an issue bothering people.

Sorry, can I sincerely ask if the -net tree is
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git or
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git ?

>
> Can you please re-submit, specifying the target tree into the subj and
> including a suitable Fixes tag?

ok, I will add a suitable Fixed tag and resubmit. Thanks.

>
> Thanks!
>
> Paolo
>
>
