Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B11596448
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiHPVNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHPVNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C050853D19
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660684398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AYi2WRVY0WJT21lyY1QoYwOC5FBNKCZk5dLPYuZKuSk=;
        b=aGjAZi0UIzvJAI5rhVhq5OuA03XmOQcCq1+FOQxibxY8LgW7ip7t/V03NLIsgKOTLDVlyk
        f74blQjgmoYq0ZG5iuXVwtxcxkEb/m3p0TtHR5a9D5DaY5D9W6TfAlBc/Xe92ku5FMP3LS
        Ml1MRksi+LTW4ePopXGxTRE1AMNneMY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-186-kwQkCVbWMy6PTp9-6BSNsA-1; Tue, 16 Aug 2022 17:13:16 -0400
X-MC-Unique: kwQkCVbWMy6PTp9-6BSNsA-1
Received: by mail-wm1-f69.google.com with SMTP id j22-20020a05600c485600b003a5e4420552so5335190wmo.8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=AYi2WRVY0WJT21lyY1QoYwOC5FBNKCZk5dLPYuZKuSk=;
        b=anfB5FachoSmg6o93UHZpup2kxXOByZ68Ss3tT2Gr5pVGNBlnTS/m51vV8lbwIqrZJ
         U8DKtErznUl/F3509YDZy6A9nUgsIH5TMGaN667g2cBbVe5ZcbwIN8BW/Kszv414NK0t
         FaXXPra9O1gXUqit7Xs97q+WrCRf2ubRYFjvsud2he/BivSmsRSBPJQR98AnR48Lldyi
         jzgirCbEDcLMu2G+uVJcuBU3xlu68q60ZblZ5BlRbh/UWm4ZVnJ0fOjb7whHJJodjWeG
         S1I6DCkJdTNXEdV1WZUyrwxofLzivRQSKN/Qrye0yAlw5xMMWmEamwF2T8jQpsz4TYiV
         2Wcg==
X-Gm-Message-State: ACgBeo3KLHD5jDST6Bw0mX5SWiCH1lj7Gt1tuXUrHc+s9tWtFWg6I+Fr
        zAbtMAU0R35BcB8tgcGROyh6mkXZqNQEHczpnS8tVHn3feRcOcaHZxfHOGb3cNdT0sUiJojmAkm
        wKs2D546xAQQh2MVy
X-Received: by 2002:a5d:5949:0:b0:224:e674:534 with SMTP id e9-20020a5d5949000000b00224e6740534mr9977931wri.254.1660684395168;
        Tue, 16 Aug 2022 14:13:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR55aKwS//DmXsaapDe8frvEPqPbRT1KPyjrWnb98GBtsRPDzvJ16TcKJ2nMrDKcC0LZ1eOhNg==
X-Received: by 2002:a5d:5949:0:b0:224:e674:534 with SMTP id e9-20020a5d5949000000b00224e6740534mr9977924wri.254.1660684394894;
        Tue, 16 Aug 2022 14:13:14 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id c21-20020a05600c149500b003a604a29a34sm4258950wmh.35.2022.08.16.14.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:13:14 -0700 (PDT)
Date:   Tue, 16 Aug 2022 17:13:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220816171106-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 12:41:21AM -0700, Si-Wei Liu wrote:
> Hi Michael,
> 
> I just noticed this patch got pulled to linux-next prematurely without
> getting consensus on code review, am not sure why. Hope it was just an
> oversight.
> 
> Unfortunately this introduced functionality regression to at least two cases
> so far as I see:
> 
> 1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently exposed and
> displayed in "vdpa dev config show" before feature negotiation is done.
> Noted the corresponding features name shown in vdpa tool is called
> "negotiated_features" rather than "driver_features". I see in no way the
> intended change of the patch should break this user level expectation
> regardless of any spec requirement. Do you agree on this point?
> 
> 2. There was also another implicit assumption that is broken by this patch.
> There could be a vdpa tool query of config via
> vdpa_dev_net_config_fill()->vdpa_get_config_unlocked() that races with the
> first vdpa_set_features() call from VMM e.g. QEMU. Since the S_FEATURES_OK
> blocking condition is removed, if the vdpa tool query occurs earlier than
> the first set_driver_features() call from VMM, the following code will treat
> the guest as legacy and then trigger an erroneous
> vdpa_set_features_unlocked(... , 0) call to the vdpa driver:
> 
>  374         /*
>  375          * Config accesses aren't supposed to trigger before features
> are set.
>  376          * If it does happen we assume a legacy guest.
>  377          */
>  378         if (!vdev->features_valid)
>  379                 vdpa_set_features_unlocked(vdev, 0);
>  380         ops->get_config(vdev, offset, buf, len);
> 
> Depending on vendor driver's implementation, L380 may either return invalid
> config data (or invalid endianness if on BE) or only config fields that are
> valid in legacy layout. What's more severe is that, vdpa tool query in
> theory shouldn't affect feature negotiation at all by making confusing calls
> to the device, but now it is possible with the patch. Fixing this would
> require more delicate work on the other paths involving the cf_lock
> reader/write semaphore.
> 
> Not sure what you plan to do next, post the fixes for both issues and get
> the community review? Or simply revert the patch in question? Let us know.
> 
> Thanks,
> -Siwei
> 

I'm not sure who you are asking. I didn't realize this is so
controversial. If you feel it should be reverted I suggest
you post a revert patch with a detailed motivation and this
will get the discussion going.
It will also help if you stress whether you describe theoretical
issues or something observed in practice above
discussion does not make this clear.

-- 
MST

