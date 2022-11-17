Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31C062DF6C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240250AbiKQPQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbiKQPQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:16:06 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA84B8A160
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:11:25 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id p10-20020a9d76ca000000b0066d6c6bce58so1205846otl.7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ehFA4pny3IQLJJpNultZQb7jKbS0rLL2TzD82s2n+KE=;
        b=EcIcPhc5/+57nFv8oQEQfYomtANi76zvLBP9/jEO7ueks99oU0IbMdOmQmOwiB/CLa
         BEhKMGiUVasWLAJEUT9GYUWXGfADhMR3ZdFn3icKu/nb8eUS+ro9TukHICKE0//GdNdg
         5aySxoqPe6agI+ypNQMxRGGwCClkzJXz3vmSrFicJD6yrTHdP6M/EKc3Zkl6uuQabGFn
         ncbPvrB8Eqhz8Q9/OZ+w8XxvLfbzxUaN6Kuvl9PkMhnc9miiEJXY0p0zVMgaOg1QFfii
         bDRHjDLcDHsavLwf5YYLh3qIOlfzDYEx3th2YLwu/kE72bS0n5M9AZnisc3O8KuyacRn
         mJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ehFA4pny3IQLJJpNultZQb7jKbS0rLL2TzD82s2n+KE=;
        b=qZFBJQqI51p3k9L9YJRKWRRhuPgI6ScY6CcCqCb7SrA9Sxv4RYrz6Wm0YCfJZzZEIz
         gznAtEzx1fO4wZSnPULbCC78tmAlHaxMvLKy5RobhgtWQX/v1yEI0KgB+tPkVgGFKijL
         fM+sa6eBBUw1PvUQK1qQlfknmzIUdvEKeXzEhEbcr86VNX18effCiq5fOA/uUYKuhGiJ
         RaAJ86+RmqgK/MZAC0OBGSPQ/Nftxnd6TVM1HFLZj7I0u+DNhr6BLiouSARJtjmLt0Nk
         vGMv5vBZKADGoZSZLM3o3El2HluFDCo3WAcd3lrg7Q4PzO3uVCWqW5IM81j5y1snlX3J
         R2qA==
X-Gm-Message-State: ANoB5pktP3fezHLJH0CQtwYtiRkrMwT9jS9ZtfLoFOpl0JsAzwqLvvRq
        2yJ8hCX2Cd3a7g0ZbaUyHzTd0GwsgU7EO7itI5c6Z9OCBNqmRw==
X-Google-Smtp-Source: AA0mqf5UPwKH605uQDOHNKHN9naZvLmkOEwaeo4/aTdlIMvOFzMvmAXc1Xwvokf4funiJCLzpefRgcJVdX/7eMEIAkw=
X-Received: by 2002:a05:6830:1254:b0:665:da4d:8d22 with SMTP id
 s20-20020a056830125400b00665da4d8d22mr1531490otp.295.1668697872954; Thu, 17
 Nov 2022 07:11:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1668527318.git.lucien.xin@gmail.com> <488fbfa082eb8a0ab81622a7c13c26b6fd8a0602.1668527318.git.lucien.xin@gmail.com>
 <Y3VcEiOlB5OG0XFS@salvia> <CADvbK_en1btAkbvOBm7+LuN7_G_mkU0==HD-GSTjAjhJPykPdQ@mail.gmail.com>
 <Y3YTfGZ9ZkXWUSOE@salvia>
In-Reply-To: <Y3YTfGZ9ZkXWUSOE@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 17 Nov 2022 10:10:38 -0500
Message-ID: <CADvbK_fmFybLVZwX1GXyt4zDy4_itGULOv4qp7z6ApoSkj=b5w@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: move the nat function to nf_nat_core
 for ovs and tc
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
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

On Thu, Nov 17, 2022 at 5:57 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Nov 16, 2022 at 07:51:40PM -0500, Xin Long wrote:
> > On Wed, Nov 16, 2022 at 4:54 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Nov 15, 2022 at 10:50:57AM -0500, Xin Long wrote:
> [...]
> > > I'd suggest you move this code to nf_nat_ovs.c or such so we remember
> > > these symbols are used by act_ct.c and ovs.
> >
> > Good idea, do you think we should also create nf_conntrack_ovs.c
> > to have nf_ct_helper() and nf_ct_add_helper()?
> > which were added by:
> >
> > https://lore.kernel.org/netdev/20221101150031.a6rtrgzwfd7kzknn@t14s.localdomain/T/
>
> If it is used by ovs infra, I would suggest to move there too.
OK, I will create only "nf_conntrack_ovs.c" to have the nat functions
in this patch.
and post another patch to move nf_ct_helper() and nf_ct_add_helper() there, too.

I think one file "nf_conntrack_ovs.c" should be enough to include all
these functions
used by ovs conntrack infra.

Thanks.
