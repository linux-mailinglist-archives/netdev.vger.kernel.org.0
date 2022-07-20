Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9DA57B15A
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbiGTHFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiGTHFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:05:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CB922183
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658300708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8YGBNjjpl2TdXtImvL+a1Jiip1bCWEsRreo24ZT4rpk=;
        b=fFN/UxB29RIWn1dvc/WgY0eXAI8Y1fyBU6U6CQIbnBCek/Diw38fvruVU1stS05HoixII1
        2yVdM7M410xUCrKxmGPIA16m5OWPECTzJYi3jBqU1sAeYBnxGZEmWcMsWASJ6Q8/m+kHtJ
        1TxXDR+IHb75Eb+J2tAYw6gujd7lHhc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-cYHBPJ15Mle0tyBP9M6raw-1; Wed, 20 Jul 2022 03:05:07 -0400
X-MC-Unique: cYHBPJ15Mle0tyBP9M6raw-1
Received: by mail-wr1-f71.google.com with SMTP id q9-20020adfb189000000b0021e3e7d3242so708198wra.19
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8YGBNjjpl2TdXtImvL+a1Jiip1bCWEsRreo24ZT4rpk=;
        b=UfC+lzmp2vB8GV0sJNdjtXKdgrFp4eJOcqEracAzLSIBBRbRWSzrap5OWeHofQZCV6
         DasIadSSz2+fvREQiC60ukLxGACsKgsGedVZnWi13lE2V0VGApI5pLihDV9mapgLK3iI
         AFShX+CCsRC4YiARGJxcfefr3oK+wEpZsweUXMRnctM2O9cnf6P6HJBueobOl+y56vXk
         PzFr2v7Bji1XFVGIUEgCRqEUb5CYiqZPLdbAf4r844hJPlu2EnNwtW08c+UCgdh0IRks
         EJPSVf+LBwgG9x+lEhVkdEmob27AFrsVcdr8eNwhE1iFQKnJmnEk8X/V7eWu+GAPUjsS
         cTiA==
X-Gm-Message-State: AJIora+f0mdbw8H6GdKKsxpAR7LGTqD8BjXaBvcvqvl3w87eQT8//sWj
        lA5cWAWrIL6n6x63SxHinSuUxCvkjKCqNlybSbakbeTUUnFH5Prto/XdfIztKCW3LFdg6lZ4gPC
        +X0CUZwH6501Ton/A
X-Received: by 2002:adf:d1c8:0:b0:21d:a082:9290 with SMTP id b8-20020adfd1c8000000b0021da0829290mr30397999wrd.246.1658300705880;
        Wed, 20 Jul 2022 00:05:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v+kZhsreNx4t/ZMQDZXCwK79VXKIhft3ishPmU6wX0WbAfS6coiD9sNOy5W2L9a49o5Rht0g==
X-Received: by 2002:adf:d1c8:0:b0:21d:a082:9290 with SMTP id b8-20020adfd1c8000000b0021da0829290mr30397970wrd.246.1658300705607;
        Wed, 20 Jul 2022 00:05:05 -0700 (PDT)
Received: from redhat.com ([2.55.25.63])
        by smtp.gmail.com with ESMTPSA id k20-20020a05600c1c9400b003a31fd05e0fsm7845864wms.2.2022.07.20.00.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 00:05:05 -0700 (PDT)
Date:   Wed, 20 Jul 2022 03:05:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220720030343-mutt-send-email-mst@kernel.org>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org>
 <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 03:02:04PM +0800, Jason Wang wrote:
> On Wed, Jul 20, 2022 at 2:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Jul 19, 2022 at 05:26:52PM -0700, Jakub Kicinski wrote:
> > > On Mon, 18 Jul 2022 12:11:02 +0300 Alvaro Karsz wrote:
> > > > New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> > > >
> > > > Control a Virtio network device notifications coalescing parameters
> > > > using the control virtqueue.
> > > >
> > > > A device that supports this fetature can receive
> > > > VIRTIO_NET_CTRL_NOTF_COAL control commands.
> > > >
> > > > - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
> > > >   Ask the network device to change the following parameters:
> > > >   - tx_usecs: Maximum number of usecs to delay a TX notification.
> > > >   - tx_max_packets: Maximum number of packets to send before a
> > > >     TX notification.
> > > >
> > > > - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
> > > >   Ask the network device to change the following parameters:
> > > >   - rx_usecs: Maximum number of usecs to delay a RX notification.
> > > >   - rx_max_packets: Maximum number of packets to receive before a
> > > >     RX notification.
> > > >
> > > > VirtIO spec. patch:
> > > > https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> > > >
> > > > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > >
> > > Waiting a bit longer for Michael's ack, so in case other netdev
> > > maintainer takes this:
> > >
> > > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> >
> > Yea was going to ack this but looking at the UAPI again we have a
> > problem because we abused tax max frames values 0 and 1 to control napi
> > in the past. technically does not affect legacy cards but userspace
> > can't easily tell the difference, can it?
> 
> The "abuse" only works for iproute2.

That's kernel/userspace API. That's what this patch affects, right?

> For uAPI we know it should follow
> the spec? (anyhow NAPI is something out of the spec)
> 
> Thanks

When you say uAPI here you mean the virtio header. I am not
worried about that just yet (maybe I should be).

> >
> > --
> > MST
> >

