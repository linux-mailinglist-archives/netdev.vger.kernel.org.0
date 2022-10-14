Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF225FE8FE
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJNGjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJNGjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4013181C89;
        Thu, 13 Oct 2022 23:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7613CB82211;
        Fri, 14 Oct 2022 06:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A83AC43146;
        Fri, 14 Oct 2022 06:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665729549;
        bh=B3adAPBXbT2V2JKZDZY+UOzG01zwsYFzTn663zAW2/c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DcMwh4/DtW84kXki/xT2Ua7MBUnFd5D79x+NoR9upYaaEVBOnO8JJ0Jyv5FFRqCOf
         BJX9K34GABc6c3EAJX7lh9HWdcS9SbiodA5xccjf1cNoPRjgb3gCyrGXjE+MsAqZnI
         Ct01LdBKBfWx4x1G1Y6R08dmqvfX2tnbO6Y95x1kPu+ypzZEJ8lfEankp1/sjwqgAG
         lpupQ65U1D1vFIJggOkkNMFKcb2gaW4VYzo3jvOg64I7G2AFoFjShplBS65IW4Wvj3
         FrG0uRV/QGXqH6aTNAoHkVX54TwicDuyaygOljcJb0W/YGrGDm6Qvpn55l507Rw4Lt
         Y9cgaA9lq+vHQ==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-132b8f6f1b2so4835931fac.11;
        Thu, 13 Oct 2022 23:39:09 -0700 (PDT)
X-Gm-Message-State: ACrzQf0qFaNO3J1BwH+Dr/ebI5TutVotmDqsC4Tp+S5bCwz8iw1kwmmU
        qzbi0DDSc5iYxkkMjpyzpiKxJC/KKB+ReR1KJ6M=
X-Google-Smtp-Source: AMsMyM5u69ZKJiI9Ovoyien4/E0vCbsStcgbvRcUXPgWkTBdnh704VkjV8u5JqcFXDy7+52Iqa0EbUK9eabBEG1K1lk=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr7732235oah.112.1665729548233; Thu, 13
 Oct 2022 23:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-2-guoren@kernel.org>
 <20221013203544.110a143c@kernel.org>
In-Reply-To: <20221013203544.110a143c@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 14:38:56 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQyMHNHLizeU-gvUdA5hRLUWxvHXuVVqSoPg3M_WxPPdw@mail.gmail.com>
Message-ID: <CAJF2gTQyMHNHLizeU-gvUdA5hRLUWxvHXuVVqSoPg3M_WxPPdw@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        yury.norov@gmail.com, caraitto@google.com, willemb@google.com,
        jonolson@google.com, amritha.nambiar@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 11:35 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 13 Oct 2022 23:04:58 -0400 guoren@kernel.org wrote:
> > -     for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> > -          j < nr_ids;) {
> > +     for (j = -1; j < nr_ids;
> > +          j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {
>
> This does not look equivalent, have you tested it?
>
> nr_ids is unsigned, doesn't it mean we'll never enter the loop?
Yes, you are right. Any unsigned int would break the result.
(gdb) p (int)-1 < (int)2
$1 = 1
(gdb) p (int)-1 < (unsigned int)2
$2 = 0
(gdb) p (unsigned int)-1 < (int)2
$4 = 0

So it should be:
 -     for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
 -          j < nr_ids;) {
 +     for (j = -1; j < (int)nr_ids;
 +          j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {

Right? Of cause, nr_ids couldn't be 0xffffffff (-1).

>
> Can we instead revert 854701ba4c and take the larger rework Yury
> has posted a week ago into net-next?



-- 
Best Regards
 Guo Ren
