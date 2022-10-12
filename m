Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118135FC425
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 13:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJLLLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 07:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJLLLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 07:11:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CB2ABD6C
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 04:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665573075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8YiAlVcyacuAF1cXPKHrDiH+rQYQoNsO4NEHWDYYi14=;
        b=Q3/M+TrIeRpFKLA1bOdRlHyfHw/8+/6/gz3Q8d+WT6Kcs8bZt7Hp+og7mOeAEsmf04Rn5e
        nN0ckTyQFNkf6zrlU8x0prXmBY6jNrYrDUQbOQnQRwds7BlUFhc+0uF0K63SjTC/mrAy6/
        Syh0ZUe3P3L/BAhBHQ6sRaUMD8MP83s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-222-UFULx6NUOLCw0ijTq1J5-w-1; Wed, 12 Oct 2022 07:11:14 -0400
X-MC-Unique: UFULx6NUOLCw0ijTq1J5-w-1
Received: by mail-wr1-f72.google.com with SMTP id s4-20020adfbc04000000b0022e03fc10a9so4843951wrg.15
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 04:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8YiAlVcyacuAF1cXPKHrDiH+rQYQoNsO4NEHWDYYi14=;
        b=ju+aOy4lo9GU62iDrNi99DEGhl9SIzLXIxVjEWmFZKCIhe44hPVEC+1JA9N1zqAC39
         KyAE0xwOopujoF7jQE656ZjtNB4c7I5ykT3Zyn5/YkHPaDU/pUNPlIUq5FWyswqpRUU9
         mUX+5QFK4TfAluDXH4zyDiwmnFvF5waZpiJgd3VrTTaDSYOLBpagGSlwCIalMWTKm0Nw
         /QPoqPgjnmIbFVgUPEVaikomNblci3bYhbYgTFamju/kNLqJLEb1/riEjJ5PUdQWfpzl
         lc/0PmdZhRAAL23+soCgPEVcjUDL+WmVRLZJrLxXdKPgeFU49Yi2HX+eA+oVULNpt5Yr
         pfyw==
X-Gm-Message-State: ACrzQf2mYEOO8vdUEnQ1yXVSBJOSkHb840VU5YzAIHJB/jINEwb8z4if
        16VwYVl3F+Alf1nIUy1We+6G2un+vBYZH683DGFOXLcxtl2/nJ6dB7C58RxcVhXtk1j9gYZi8LW
        HB6vwWN4MEeAndwtY
X-Received: by 2002:a5d:4581:0:b0:228:a8e5:253c with SMTP id p1-20020a5d4581000000b00228a8e5253cmr16709133wrq.506.1665573072676;
        Wed, 12 Oct 2022 04:11:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4M2UeBQqsLu/YgEb0FS7XO2FtVoGI+qgl10zlKDVC740GbGZGoVVc16JkgQ8fSzCwcytvnSw==
X-Received: by 2002:a5d:4581:0:b0:228:a8e5:253c with SMTP id p1-20020a5d4581000000b00228a8e5253cmr16709111wrq.506.1665573072445;
        Wed, 12 Oct 2022 04:11:12 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id y8-20020a05600c364800b003c6bd91caa5sm1493777wmq.17.2022.10.12.04.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 04:11:11 -0700 (PDT)
Date:   Wed, 12 Oct 2022 07:11:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        wangdeming@inspur.com, xiujianfeng@huawei.com,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] virtio: fixes, features
Message-ID: <20221012070532-mutt-send-email-mst@kernel.org>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0zdmujf.fsf@mpe.ellerman.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 05:21:24PM +1100, Michael Ellerman wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> > The following changes since commit 4fe89d07dcc2804c8b562f6c7896a45643d34b2f:
> >
> >   Linux 6.0 (2022-10-02 14:09:07 -0700)
> >
> > are available in the Git repository at:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
> >
> > for you to fetch changes up to 71491c54eafa318fdd24a1f26a1c82b28e1ac21d:
> >
> >   virtio_pci: don't try to use intxif pin is zero (2022-10-07 20:00:44 -0400)
> >
> > ----------------------------------------------------------------
> > virtio: fixes, features
> >
> > 9k mtu perf improvements
> > vdpa feature provisioning
> > virtio blk SECURE ERASE support
> >
> > Fixes, cleanups all over the place.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > ----------------------------------------------------------------
> > Alvaro Karsz (1):
> >       virtio_blk: add SECURE ERASE command support
> >
> > Angus Chen (1):
> >       virtio_pci: don't try to use intxif pin is zero
> 
> This commit breaks virtio_pci for me on powerpc, when running as a qemu
> guest.
> 
> vp_find_vqs() bails out because pci_dev->pin == 0.
> 
> But pci_dev->irq is populated correctly, so vp_find_vqs_intx() would
> succeed if we called it - which is what the code used to do.
> 
> I think this happens because pci_dev->pin is not populated in
> pci_assign_irq().
> 
> I would absolutely believe this is bug in our PCI code, but I think it
> may also affect other platforms that use of_irq_parse_and_map_pci().
> 
> cheers

How about fixing this in of_irq_parse_and_map_pci then?
Something like the below maybe?

diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index 196834ed44fe..504c4d75c83f 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -446,6 +446,8 @@ static int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *
 	if (pin == 0)
 		return -ENODEV;
 
+	pdev->pin = pin;
+
 	/* Local interrupt-map in the device node? Use it! */
 	if (of_get_property(dn, "interrupt-map", NULL)) {
 		pin = pci_swizzle_interrupt_pin(pdev, pin);

