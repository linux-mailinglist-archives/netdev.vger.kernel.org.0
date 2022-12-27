Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F196568E5
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 10:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiL0JcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 04:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiL0JcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 04:32:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFC0BF5
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672133475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XjEgqHC0TjJVZZyBA3pSEYd/RXRUNHEpnJ2isGBT+vY=;
        b=Z0mvkydKqfGdx2e8A+6lUYbDz0071csui1+X2ekl1vXeeu8wZWg+1Sm2aUVU4p4pkVxVrz
        wxoCpQJCHd+liDZtiLZSGOWs1DwWQGm7QyMbtsokT4zcFwwrwPe5nqUylAJG5AWPH2PeLz
        5VQnmh4xRtFS+CC7BsSTiH2U/87Z+1Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-193-5H5N39KoPMCQYBeJrsgmEQ-1; Tue, 27 Dec 2022 04:31:14 -0500
X-MC-Unique: 5H5N39KoPMCQYBeJrsgmEQ-1
Received: by mail-wr1-f69.google.com with SMTP id l18-20020adfa392000000b00281cba9d342so232465wrb.6
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 01:31:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjEgqHC0TjJVZZyBA3pSEYd/RXRUNHEpnJ2isGBT+vY=;
        b=hnAV788dUtvt9sJo49JrN3FMaXmpiuvhbYVR3q4j6FmegiGDFxfQocLdQR3wjjgnSl
         9y28qq3skaKmOyh2jnXQBEj8aQA9lk1ii3u4yrodLoVDlKJr2Mg4SzvpczQJ2jf6Avg+
         +UA4CAchwnbMzQRtbferlcDjr2BNz6lHjpG9qM8iYALQrR+kUllXFBWdKLIqWA3NpPxb
         vh636HRL3ts7aa7m1v5Mmfhj4ECbi/hixxohMEmbmhKW5+hH+CEQZ4q86f9JeKi++qkv
         ayYJXayCjlFLORLM61r7agIMdqP8KiDV02utKVOadXoy7Yf0f2dCMjIA4YcYF9qhlTMH
         wf/g==
X-Gm-Message-State: AFqh2krFbAgxpzfM6v1m9l7ymVbsmqHEuD/sXRzjBa2JYsNHUtzIq2d6
        EifJWGgz4GQgFLu49qT4V8+FawEPiRX2YM6Z09fH4kb/nb/B2CuIX9IcjQ4D4LUexGAoztF7kCm
        a3NVaR8k4d/oiMeG1
X-Received: by 2002:adf:e6d1:0:b0:27c:dcf5:ad52 with SMTP id y17-20020adfe6d1000000b0027cdcf5ad52mr4845015wrm.11.1672133473258;
        Tue, 27 Dec 2022 01:31:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtDqoROpQZXF0N0D/7AOnnSo+AghfYu/wxAstc5C3cls1UCZ3EJFRFCd83x4sF0qZzA1zj90A==
X-Received: by 2002:adf:e6d1:0:b0:27c:dcf5:ad52 with SMTP id y17-20020adfe6d1000000b0027cdcf5ad52mr4844997wrm.11.1672133473018;
        Tue, 27 Dec 2022 01:31:13 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id h29-20020adfaa9d000000b002368f6b56desm15219971wrc.18.2022.12.27.01.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 01:31:12 -0800 (PST)
Date:   Tue, 27 Dec 2022 04:31:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        edumazet@google.com, maxime.coquelin@redhat.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq
 command
Message-ID: <20221227042855-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-5-jasowang@redhat.com>
 <1672107557.0142956-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEvzhAFj5HCmP--9DKfCAq_4wPNwsmmg4h0Sbv6ra0+DrQ@mail.gmail.com>
 <20221227014641-mutt-send-email-mst@kernel.org>
 <1ddb2a26-cbc3-d561-6a0d-24adf206db17@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ddb2a26-cbc3-d561-6a0d-24adf206db17@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 05:17:20PM +0800, Jason Wang wrote:
> > > > In particular, we will also directly break the device.
> > > It's kind of hardening for malicious devices.
> > ATM no amount of hardening can prevent a malicious hypervisor from
> > blocking the guest. Recovering when a hardware device is broken would be
> > nice but I think if we do bother then we should try harder to recover,
> > such as by driving device reset.
> 
> 
> Probably, but as discussed in another thread, it needs co-operation in the
> upper layer (networking core).

To track all state? Yea, maybe. For sure it's doable just in virtio,
but if you can find 1-2 other drivers that do this internally
then factoring this out to net core will likely be accepted.

-- 
MST

