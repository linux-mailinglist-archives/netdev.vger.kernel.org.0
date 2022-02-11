Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEAF4B23EC
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 12:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345524AbiBKLFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 06:05:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiBKLFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 06:05:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A222DDD
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 03:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644577532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Wsvd9fQoXJkQcNH42072jBi5H+35nx8akB/ODHpesE=;
        b=XlPAiP4mwU21KZ222Wesjyv6Wp8/Csfbi215IA8Db4jxLdqI/dinSwXdxwadZkbUg2b3X4
        jdrOSXePSLqu8xqVfML8gMm2iFKr4lEsNaqktgwX2nUwZ1nnrl2Lk7XmGCjudWJ0YSS3RM
        gIFwVrbHQWPw42diMTzG6UTFEywm604=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-2GjyJKqfNBKoJhsonvfrww-1; Fri, 11 Feb 2022 06:05:31 -0500
X-MC-Unique: 2GjyJKqfNBKoJhsonvfrww-1
Received: by mail-il1-f197.google.com with SMTP id a18-20020a923312000000b002b384dccc91so5793944ilf.1
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 03:05:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9Wsvd9fQoXJkQcNH42072jBi5H+35nx8akB/ODHpesE=;
        b=SVEFqYjeoRATP+TZ7cSyEz2CWVX4f2lKQpGz1TPAvIN2HVOm/9oy4qmVmkzfDTjh1k
         ZVbyJ3LjYNFeBtMntHa7vCSDIK2amWeDIkcQEioicwX26a++xkWl5xRGelbl8ACxO5Qk
         3g3cZoVK4IUMNDjmV+33OP5wRedmPuQ7WlJdaAYn/RFXTyLr94dUNdCab2rdJqABcrn5
         T8d9Z15e2pKwnBq3z1oQXs/ssP3oiQN2fLvg/5xa7xmRpIPQRF25aAOmWogBlHrntcNi
         QqDcB9jsz+iY9H6tNup0hyrrDmltUIBqGqnklq001hqh9f2UdyGArFsFj3mM5r6sHmzq
         b5Ig==
X-Gm-Message-State: AOAM531nChfNPNoVLTJXROEljfJfW/FsI6N3G8tupXimMybe8aq9RUic
        mZ4miLUhzes3nRSAmnKJlD8pRtmE19Qhhd7qPUhI3CAKSAT5iBj62ao3fCnyn4e2gWcIXOiQUcn
        Fkt6m/rrJov+9JcqSMS3MOQx9cY4NKeNz
X-Received: by 2002:a02:cc8a:: with SMTP id s10mr470225jap.263.1644577530493;
        Fri, 11 Feb 2022 03:05:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLZwl/GF+a6YRmFyJFwKs918PwYQF77CLRSFAX63zCufOG3s/dtreidpqzBAQzoMsFDqrUS1Zg5INLSMwJR2M=
X-Received: by 2002:a02:cc8a:: with SMTP id s10mr470212jap.263.1644577530274;
 Fri, 11 Feb 2022 03:05:30 -0800 (PST)
MIME-Version: 1.0
References: <20220128151922.1016841-1-ihuguet@redhat.com> <20220128151922.1016841-2-ihuguet@redhat.com>
 <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
 <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com> <20220210082249.0e50668b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210082249.0e50668b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 11 Feb 2022 12:05:19 +0100
Message-ID: <CACT4ouepk83kxTGd6S3gVyFAjofofwQfxsmhe97vGP+twkoW1g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 5:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 10:35:53 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > On Mon, Feb 7, 2022 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Mon, 7 Feb 2022 16:03:01 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > > > I have a few busy weeks coming, but I can do this after that.
> > > >
> > > > With num_cores / 2 you divide by 2 because you're assuming 2 NUMA
> > > > nodes, or just the plain number 2?
> > >
> > > Plain number 2, it's just a heuristic which seems to work okay.
> > > One queue per core (IOW without the /2) is still way too many queues
> > > for normal DC workloads.
> >
> > Maybe it's because of being quite special workloads, but I have
> > encountered problems related to queues in different NUMA nodes in 2
> > cases: XDP performance being almost half with more RX queues because
> > of being in different node (the example in my patches) and a customer
> > losing UDP packets which was solved reducing the number of RX queues
> > so all them are in the same node.
>
> Right, no argument, NUMA tuning will still be necessary.
> I'm primarily concerned about providing a sensible default
> for workloads which are not network heavy and therefore
> nobody spends time tuning their queue configuration.
> Any network-heavy workload will likely always benefit from tuning.
>
> The status quo is that our current default returned by
> netif_get_num_default_rss_queues() is 8 which is inadequate
> for modern servers, and people end up implementing their own
> logic in the drivers.
>
> I'm fine with sfc doing its own thing (at least for now) and
> therefore your patches as they are, but for new drivers I want
> to be able to recommend netif_get_num_default_rss_queues() with
> a clear conscience.
>
> Does that make sense?
>

Totally. My comment was intended to be more like a question to see why
we should or shouldn't consider NUMA nodes in
netif_get_num_default_rss_queues. But now I understand your point
better.

However, would it make sense something like this for
netif_get_num_default_rss_queues, or it would be a bit overkill?
if the system has more than one NUMA node, allocate one queue per
physical core in local NUMA node.
else, allocate physical cores / 2

Another thing: this patch series appears in patchwork with state
"Changes Requested", but no changes have been requested, actually. Can
the state be changed so it has more visibility to get reviews?

Thanks!

--=20
=C3=8D=C3=B1igo Huguet

