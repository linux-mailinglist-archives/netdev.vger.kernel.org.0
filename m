Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C753C4B42BD
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 08:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241214AbiBNHXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 02:23:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbiBNHXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 02:23:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 751B5593A2
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644823388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Le97n5fv3dcCWOo7tuL8CFHljuRE0qTHh9i8vGZj8do=;
        b=RLESd8lGsd5lDCB4f6Pp+yJ25kLZG75iEQ5zMc8UoJnVSRFCUphw4V6X7geHA/1prNoClS
        1RiWwI5rhVTeR9Io//K8z4hzib5EcCEqa1qCEFdF1Y5YeOPU/kjI5Gee+d4RcH71BMnrS9
        Qr9ERcOpTXVF+QO0PCkBL5e4LHW3qJM=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-Lt2UP1wrMemacMpNUfaE7A-1; Mon, 14 Feb 2022 02:23:06 -0500
X-MC-Unique: Lt2UP1wrMemacMpNUfaE7A-1
Received: by mail-io1-f71.google.com with SMTP id 193-20020a6b01ca000000b00612778c712aso9985953iob.14
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 23:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Le97n5fv3dcCWOo7tuL8CFHljuRE0qTHh9i8vGZj8do=;
        b=T3fKuXkf2w6j+Vnz6xFlSBa4u/7AktiKL4pGJd73UjrcEr/aHpMQU0vAuteYG/fH8M
         EUvHLUyMLcn9r8vz+Q79wGkjGon/pbXMpPOm4S6dQ3bDU9cPszu65ND9oPiQG3PxdIG3
         p5E1flYcoATNuJCS6cDFsk6cg4zdS9iDMHk9nDfVmAG6CSt4FN5oaaaQa9qWoNxhTqxa
         lUvpxNYcAjy7Fmlyt9MtAzpolHy/S3KrLQR84WLWZMCws4rs013sbDrX30aMY5tkgml8
         KlDuc/zQHbl3qoyYcLBZoKP9NjvhTCM3d7j65T7m63Hg8aNlt2p2OuodpJaDBnbFgoV4
         rKQg==
X-Gm-Message-State: AOAM5319sshv+9xF1+xlFmfTwFO8lb1bNH4Lhw4Ag3Zw6Ii25dDnzlEd
        bsbaWtt+CwrXFO0/W7GohE2xNP31bW/vKPf6JTm7eJvdSH6dksCsF6s9shD5Cl78SOMbBSK1k7O
        AwZN6oXYb8nm84qWeULAAFZ5VGuXPwxvz
X-Received: by 2002:a05:6e02:1d94:: with SMTP id h20mr7440346ila.312.1644823385890;
        Sun, 13 Feb 2022 23:23:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOIZ/kpb7xi7xCCWjR9fqD4lOyhvzNcKb8uaolNFzUBqSzTc/ZeliMZeDJLbkZnqjlpPyZo/miYr3CbnGJ0Q0=
X-Received: by 2002:a05:6e02:1d94:: with SMTP id h20mr7440339ila.312.1644823385646;
 Sun, 13 Feb 2022 23:23:05 -0800 (PST)
MIME-Version: 1.0
References: <20220128151922.1016841-1-ihuguet@redhat.com> <20220128151922.1016841-2-ihuguet@redhat.com>
 <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
 <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com>
 <20220210082249.0e50668b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4ouepk83kxTGd6S3gVyFAjofofwQfxsmhe97vGP+twkoW1g@mail.gmail.com> <20220211110100.5580d1ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211110100.5580d1ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 14 Feb 2022 08:22:54 +0100
Message-ID: <CACT4ouf2nuHQG+t3uFLD7iFNSwSi1aoDfdfXG0ReZcNBwWK6Cw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 8:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 11 Feb 2022 12:05:19 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > Totally. My comment was intended to be more like a question to see why
> > we should or shouldn't consider NUMA nodes in
> > netif_get_num_default_rss_queues. But now I understand your point
> > better.
> >
> > However, would it make sense something like this for
> > netif_get_num_default_rss_queues, or it would be a bit overkill?
> > if the system has more than one NUMA node, allocate one queue per
> > physical core in local NUMA node.
> > else, allocate physical cores / 2
>
> I don't have a strong opinion on the NUMA question, to be honest.
> It gets complicated pretty quickly. If there is one NIC we may or
> may not want to divide - for pure packet forwarding sure, best if
> its done on the node with the NIC, but that assumes the other node
> is idle or doing something else? How does it not need networking?
>
> If each node has a separate NIC we should definitely divide. But
> it's impossible to know the NIC count at the netdev level..
>
> So my thinking was let's leave NUMA configurations to manual tuning.
> If we don't do anything special for NUMA it's less likely someone will
> tell us we did the wrong thing there :) But feel free to implement what
> you suggested above.

Agreed, the more you try to be smart, the more less common case you
might fail to do it well.

If nobody else speaks in favor of my suggestion I will go the simpler way.

>
> One thing I'm not sure of is if anyone uses the early AMD chiplet CPUs
> in a NUMA-per-chiplet mode? IIRC they had a mode like that. And that'd
> potentially be problematic if we wanted to divide by number of nodes.
> Maybe not as much if just dividing by 2.
>
> > Another thing: this patch series appears in patchwork with state
> > "Changes Requested", but no changes have been requested, actually. Can
> > the state be changed so it has more visibility to get reviews?
>
> I think resend would be best.
>


--=20
=C3=8D=C3=B1igo Huguet

