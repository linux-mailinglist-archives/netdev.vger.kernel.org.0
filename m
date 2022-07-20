Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4657B131
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGTGpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiGTGpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:45:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0CB1FD09
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658299542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KwYZJuMW6GMuidvnwhTLUewlByMo6MPnShkgNq/ptrE=;
        b=HiEsm8WpZbshhJ5ledhiPHQOcOCekhGlyhK3FWMrsPo9ZYEbduR4AkEgTuE/iGUKkf0qKr
        GNjvXAt/27G4ZNN118OqpUPDeAanvwnKm0QM6kPauG/X/9AjY4uDFv5yD/SJP5v2mV/Ce4
        fjgDeK6F39Q9H5RkASNQQqdAmGAcCuY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-68yx6NDzM9-vemNcjfSV3g-1; Wed, 20 Jul 2022 02:45:40 -0400
X-MC-Unique: 68yx6NDzM9-vemNcjfSV3g-1
Received: by mail-wm1-f69.google.com with SMTP id 131-20020a1c0289000000b003a32b902668so197379wmc.9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KwYZJuMW6GMuidvnwhTLUewlByMo6MPnShkgNq/ptrE=;
        b=3xRTJ+L+ReoyByFOZPh+4FoBw8Y51ilxVNIedFQd/7cKsakJjxGN6hGx+YUC4B2EQ3
         fM7gPdU7dP6PojXtfMbEmGj9g9/wIN6ZD49S1O+zzZmlgCzx/EBpc4ofLHdkjUk2pqn2
         LQB+UsdBDdlMhq2f5DgDuethjEahuEXFwVuIAtoLjB+/G4n8yU3sFuDNW8htJ530HsrE
         vIcnS2jrJplsW7c8oH4t5nsh4cYGEdaNpddxNuC2eA3w2ixTHfFLKKn6VbNYVdnKwbv0
         rCWpj7YRyY/K+1hShzYzQ6rAx+hS7Hedr5xCWrGfoYSH95+s8fVdMRtaO59bODRITIS8
         c2oQ==
X-Gm-Message-State: AJIora829LgDetEnqb9Z5acLaPw8UpqDoYgCJhLa2MQ8F4vxRhFIyWXf
        repm0ciCGRuotc8AxpDSsiB95FUdhIKXaapbU4T4/uwcWos++NHmu8hfQsEKZbZDZtR3lv8vgvN
        LSeVzCpd+Q+EY1400
X-Received: by 2002:a05:600c:1991:b0:3a1:9fc4:b67d with SMTP id t17-20020a05600c199100b003a19fc4b67dmr2384263wmq.49.1658299539816;
        Tue, 19 Jul 2022 23:45:39 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNuEje7rPskCqjX+NjqkIBiSr8DZ0YYrXUmjKNZHQmAXgwZ2/eMV9ChYWVkZsnRLOZ+zwNlQ==
X-Received: by 2002:a05:600c:1991:b0:3a1:9fc4:b67d with SMTP id t17-20020a05600c199100b003a19fc4b67dmr2384239wmq.49.1658299539579;
        Tue, 19 Jul 2022 23:45:39 -0700 (PDT)
Received: from redhat.com ([2.55.25.63])
        by smtp.gmail.com with ESMTPSA id v130-20020a1cac88000000b003a03be171b1sm1234056wme.43.2022.07.19.23.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:45:39 -0700 (PDT)
Date:   Wed, 20 Jul 2022 02:45:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220720022901-mutt-send-email-mst@kernel.org>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719172652.0d072280@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 05:26:52PM -0700, Jakub Kicinski wrote:
> On Mon, 18 Jul 2022 12:11:02 +0300 Alvaro Karsz wrote:
> > New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> > 
> > Control a Virtio network device notifications coalescing parameters
> > using the control virtqueue.
> > 
> > A device that supports this fetature can receive
> > VIRTIO_NET_CTRL_NOTF_COAL control commands.
> > 
> > - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
> >   Ask the network device to change the following parameters:
> >   - tx_usecs: Maximum number of usecs to delay a TX notification.
> >   - tx_max_packets: Maximum number of packets to send before a
> >     TX notification.
> > 
> > - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
> >   Ask the network device to change the following parameters:
> >   - rx_usecs: Maximum number of usecs to delay a RX notification.
> >   - rx_max_packets: Maximum number of packets to receive before a
> >     RX notification.
> > 
> > VirtIO spec. patch:
> > https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> > 
> > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> 
> Waiting a bit longer for Michael's ack, so in case other netdev
> maintainer takes this:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Yea was going to ack this but looking at the UAPI again we have a
problem because we abused tax max frames values 0 and 1 to control napi
in the past. technically does not affect legacy cards but userspace
can't easily tell the difference, can it?

-- 
MST

