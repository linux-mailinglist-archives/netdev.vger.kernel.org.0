Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11DB50857E
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347063AbiDTKKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242267AbiDTKKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:10:31 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63F51D321
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:07:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 2so1490748pjw.2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 03:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jFXktsSIZPBKkXZwWuy7hfNT0EPEXZaxXoCZBEQnSaU=;
        b=nJzbYINCukkBn6qNVLGxbhUKRxs60/q+lSGAm3hBNoWZEERVU84frXgjrsrjIWvAEm
         icczdWt9/m9riHtAqS1yX9Klzx/81kX43TJzTGlNuG2LY0RLqhc0yKrV6ayaSvSXWV9T
         aEIMuSeD1piB7p6smxfVRvGu+cGFrpf+OpcQ4iIFq9O/Rc6Mv42w1O9yN41z9CnTCRI/
         GGbawU6V/EFHAO65Vwzk/YjCl8sVX7MkJlm/t7PuCiaSgAM8af5K2KlOQkNr4sYaub5J
         0I7uFH0PLD40U114KcHCSE33I5/lZuc3E1HlUtcIgmMvNGuFNSoJaLtf6xWnuQngTdbf
         w6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jFXktsSIZPBKkXZwWuy7hfNT0EPEXZaxXoCZBEQnSaU=;
        b=ntQgIGmXty2CdRGtQSuxwJwDEqxZ3nRojAsVsA2JIBlmPQhAldRAZ5yg5XMKhtuipk
         b2aTcwWBS+uPg1PZetWtrjPXPP5gT9SQPfdreRxS9lnyu+1Pue3TgG1LBdwFKgIwUXSY
         oy/wixfWnmaVMiKNjXzlKQLsD5bveBXv4SNAtzyWGb6WWRCepFe3Qk/LeHlM5hu6qXYt
         UZpnuX7JQPioZLhllaVuWgvnk4J9SQN9eO5Wj5DlT3qA17PhpNoiPE5MWzBz25b23IfU
         I1jPMyq47jluA0GAw+/076hv5nDqphR1ZzBi8Nsdku1QMPK1zb5P0rB5ATYhEv8gthsV
         0iGQ==
X-Gm-Message-State: AOAM531xE2f2mK6FlgPq2PSSTN7+WN0PxPRiqZhF71HN61KZLSwD6HXZ
        q1V8yxS6iwaCgebPSdJbFaM=
X-Google-Smtp-Source: ABdhPJwpYfJzhaR6U5PT/AZYG7gytVm02ckfK/OyO/Rf/Q6lGFNktFPg0bvVwhZXmaOP/dd3uw63Ng==
X-Received: by 2002:a17:90a:6d96:b0:1c9:c1de:ef2f with SMTP id a22-20020a17090a6d9600b001c9c1deef2fmr3473233pjk.210.1650449265369;
        Wed, 20 Apr 2022 03:07:45 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w22-20020a056a0014d600b0050a97172c4fsm6412424pfu.67.2022.04.20.03.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 03:07:44 -0700 (PDT)
Date:   Wed, 20 Apr 2022 18:07:37 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, ahleihel@redhat.com,
        dcaratti@redhat.com, aconole@redhat.com, roid@nvidia.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
Message-ID: <Yl/badQSLevmpxcr@Laptop-X1>
References: <20210809070455.21051-1-liuhangbin@gmail.com>
 <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
 <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
 <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
 <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 09:14:38PM +0300, Eyal Birger wrote:
> >
> > I guess I can understand why the reproducer triggers it, but I fail to
> > see the actual use case you have behind it. Can you please elaborate
> > on it?
> 
> One use case we use mirred egress->ingress redirect for is when we want to
> reroute a packet after applying some change to the packet which would affect
> its routing. for example consider a bpf program running on tc ingress (after
> mirred) setting the skb->mark based on some criteria.
> 
> So you have something like:
> 
> packet routed to dummy device based on some criteria ->
>   mirred redirect to ingress ->
>     classification by ebpf logic at tc ingress ->
>        packet routed again
> 
> We have a setup where DNAT is performed before this flow in that case the
> ebpf logic needs to see the packet after the NAT.

Hi Marcelo,

Thanks for taking care of this. Would you help following up this issue as
you are more familiar with net sched?

Thanks
Hangbin
