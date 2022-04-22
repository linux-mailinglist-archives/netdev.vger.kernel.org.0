Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FE950B8CD
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 15:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiDVNoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 09:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiDVNoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 09:44:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AABD57140
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 06:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650634879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xPTgBo2Wg2SsrR1XREtXV36ZNQWIrw1JspysXs/uuMI=;
        b=eV2aulF2hTbgKwwBdvrOdE3gFnkolMxbr+JMax+TF+2xiCFj8ve8NF+yz9p10o/hJoC90p
        vViM3YecjpvDRjY8QN3G9Vc3YaOLrskAPlbVMwtNya+7jDTll4bYo8ZQx3mhsqeqiwHuRd
        3Ryne2ZX01TXcxNQ7+UWWNJgyARRfxY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-IkjH5RZaPZeEHV2B9Bcm4w-1; Fri, 22 Apr 2022 09:41:18 -0400
X-MC-Unique: IkjH5RZaPZeEHV2B9Bcm4w-1
Received: by mail-il1-f198.google.com with SMTP id i22-20020a056e021d1600b002cd69a8f421so2317411ila.6
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 06:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=xPTgBo2Wg2SsrR1XREtXV36ZNQWIrw1JspysXs/uuMI=;
        b=Yp5rpJ3sTih3MSEj6zLr8YodRX4YoxTj533JgaF3lhG8itXxcBI0/afIxTq7aBttRX
         +NULP1RYdUyYsxM7a30YAnfaRYSkEgd0UGWQYzZGQ6UKpYqz+LoNAKwk8I6yc+mNdKlT
         jps2woanjXNiaoP8r61/ORUAnJEZ0VaA7El4ru0QB+1MpAzT1mkkxcyxaMhx0bC0/lwF
         ST14RNf+tdRFFtAS/iIsFpvuBd1Jl8k5Fkg/qiyXOroPRs6PehXVELponZFHS+gJ695n
         ThUFSPuhpTo0h1D2p8LLbitzo6ZsgFtWwjPUqKpDG3SINDqqpbMje/QiRFV+WeOwKeqq
         ztVQ==
X-Gm-Message-State: AOAM532f9FVZhIQqJoDpV9G+ezx6yrylHzAiGKJCxEjtVLI0P5ogvyna
        WZzayuEOQnGJRH8JR+rFfDd7Vu00Ly96A2NwGnn6TooMmlygXvWhnnowRefzAm9K0z0DdkuDPAx
        W2V3ovd9tm1GIhw/zKoaaqcR58hiZjAHu
X-Received: by 2002:a92:6907:0:b0:2bc:4b18:e671 with SMTP id e7-20020a926907000000b002bc4b18e671mr1819786ilc.299.1650634877255;
        Fri, 22 Apr 2022 06:41:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+hixxVb4n0UqBn887npOqa/WtM36LXanw4r9zr7FX08Uhkxt26XUkOJSUDskVqubLN6ZNi155LVQ/UxaVxmw=
X-Received: by 2002:a92:6907:0:b0:2bc:4b18:e671 with SMTP id
 e7-20020a926907000000b002bc4b18e671mr1819772ilc.299.1650634877056; Fri, 22
 Apr 2022 06:41:17 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 22 Apr 2022 08:41:16 -0500
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210809070455.21051-1-liuhangbin@gmail.com> <162850320655.31628.17692584840907169170.git-patchwork-notify@kernel.org>
 <CAHsH6GuZciVLrn7J-DR4S+QU7Xrv422t1kfMyA7r=jADssNw+A@mail.gmail.com>
 <CALnP8ZackbaUGJ_31LXyZpk3_AVi2Z-cDhexH8WKYZjjKTLGfw@mail.gmail.com>
 <CAHsH6GvoDr5qOKsvvuShfHFi4CsCfaC-pUbxTE6OfYWhgTf9bg@mail.gmail.com> <YmE5N0aNisKVLAyt@Laptop-X1>
MIME-Version: 1.0
In-Reply-To: <YmE5N0aNisKVLAyt@Laptop-X1>
Date:   Fri, 22 Apr 2022 08:41:16 -0500
Message-ID: <CALnP8ZY9hkiWyxjrVTdq=NFA0PYjt7f9YbSEJrbt-EQoRAk6gw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, ahleihel@redhat.com,
        dcaratti@redhat.com, aconole@redhat.com, roid@nvidia.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 07:00:07PM +0800, Hangbin Liu wrote:
> Hi Eyal,
> On Tue, Apr 19, 2022 at 09:14:38PM +0300, Eyal Birger wrote:
> > > > > On Mon,  9 Aug 2021 15:04:55 +0800 you wrote:
> > > > > > When mirror/redirect a skb to a different port, the ct info should be reset
> > > > > > for reclassification. Or the pkts will match unexpected rules. For example,
> > > > > > with following topology and commands:
> > > > > >
> > > > > >     -----------
> > > > > >               |
> > > > > >        veth0 -+-------
> > > > > >               |
> > > > > >        veth1 -+-------
> > > > > >               |
> > > > > >
> > > > > > [...]
> > > > >
> > > > > Here is the summary with links:
> > > > >   - [net] net: sched: act_mirred: Reset ct info when mirror/redirect skb
> > > > >     https://git.kernel.org/netdev/net/c/d09c548dbf3b
> > > >
> > > > Unfortunately this commit breaks DNAT when performed before going via mirred
> > > > egress->ingress.
> > > >
> > > > The reason is that connection tracking is lost and therefore a new state
> > > > is created on ingress.
> > > >
> > > > This breaks existing setups.
> > > >
> > > > See below a simplified script reproducing this issue.
>
> I think we come in to a paradox state. Some user don't want to have previous
> ct info after mirror, while others would like to keep. In my understanding,
> when we receive a pkt from a interface, the skb should be clean and no ct info
> at first. But I may wrong.

Makes sense to me. Moreover, there were a couple of fixes on this on
mirred around that time frame/area (like f799ada6bf23 ("net: sched:
act_mirred: drop dst for the direction from egress to ingress")). That's
because we are seeing that mirred xmit action when switching to
ingress direction should be as close skb_scrub_packet. OVS needs this
scrubbing as well, btw. This ct information could be easily stale if
there were other packet changes after it.

Point being, if we really need the knob for backwards compatibility
here, it may have to be a broader one.

>
> Jamal, Wang Cong, Jiri, do you have any comments?
>
> > >
> > > I guess I can understand why the reproducer triggers it, but I fail to
> > > see the actual use case you have behind it. Can you please elaborate
> > > on it?
> >
> > One use case we use mirred egress->ingress redirect for is when we want to
> > reroute a packet after applying some change to the packet which would affect
> > its routing. for example consider a bpf program running on tc ingress (after
> > mirred) setting the skb->mark based on some criteria.
> >
> > So you have something like:
> >
> > packet routed to dummy device based on some criteria ->
> >   mirred redirect to ingress ->
> >     classification by ebpf logic at tc ingress ->
> >        packet routed again
> >
> > We have a setup where DNAT is performed before this flow in that case the
> > ebpf logic needs to see the packet after the NAT.
>
> Is it possible to check whether it's need to set the skb->mark before DNAT?
> So we can update it before egress and no need to re-route.
>
> Thanks
> Hangbin
>

