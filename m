Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6C9595763
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbiHPKCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiHPKBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0ACB05EDC5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660638208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4oG1fGIfLDR5f50kJC3AlbvxuOG5rss32LyfKjRXLI=;
        b=Iy0F1BOq0dw7xa27osJy8lOvM13Dh/r0NnzWGjGPj1BcUzn4SqvBUOItgwvPTUv/MxSunL
        L4NqbinKwPeavvSRUArbJ7EBeb+4AzMTAgH/0ZqGIjHDKHv9EdNdunBD7uXdGDTA2gUO/F
        S5pwCE+u2Z7C2FPyGMGrGJcNI67dsM4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-29-chKZdQ5PP4aLKYqkWti9Mg-1; Tue, 16 Aug 2022 04:23:27 -0400
X-MC-Unique: chKZdQ5PP4aLKYqkWti9Mg-1
Received: by mail-wr1-f72.google.com with SMTP id d18-20020adf9b92000000b0022503144f4fso1168951wrc.9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=V4oG1fGIfLDR5f50kJC3AlbvxuOG5rss32LyfKjRXLI=;
        b=WP7m8ghGrGznnenwxMdAbM43bSDzfUTRBy4aAeMgiX1RZYUPgm+nTNc3lqivwaVqgx
         duzaj1boW8ZGH8e+foYMRZDKbrKPzTwQRfGLDouh6MLYL8owB5VBiBW3Fn/1xkTeGUN1
         I51FDnYosgHjSV+OwwVk/PiUIzhD65UerylmBmXnTWGzFQK96PWxM95gTonhWO4jsajC
         lzKCAlLle9zb1ftWiIHJ/BsE576N7SqWfPRKUIa/Q9Ww5V/n7vEwMLqg2A7gBajmLwe1
         5pATezqwpOSb5ErRWiRNxgJ5M652YdMc/K0owkj36Qw0ilOmcjklddf0TfysKGSmjlN5
         Mjlw==
X-Gm-Message-State: ACgBeo0ww4EI2yVKoCy340JTkgsg1Fh4Wets15C/+EEt7uNTm7mMkjZd
        hNrvBC4XYfNOQSrI2aHZC7X9R/BJwgY5wNntvvdGzg2QzjwKOc/QJW7zYbXtTs25+I6qxtt4SDM
        Tk+9MIlsS3y2U5FuO
X-Received: by 2002:a5d:6da8:0:b0:221:7db8:de0a with SMTP id u8-20020a5d6da8000000b002217db8de0amr10846359wrs.405.1660638205979;
        Tue, 16 Aug 2022 01:23:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Be6LbtV7yTGqbSUu3sanvO4iZ86CjPJG2SNzqsNkmuRv69b6+YtLfJuQbl54PznhWVwsbJQ==
X-Received: by 2002:a5d:6da8:0:b0:221:7db8:de0a with SMTP id u8-20020a5d6da8000000b002217db8de0amr10846349wrs.405.1660638205760;
        Tue, 16 Aug 2022 01:23:25 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c191400b003a5c1e916c8sm2328119wmq.1.2022.08.16.01.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:23:25 -0700 (PDT)
Date:   Tue, 16 Aug 2022 04:23:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220816042157-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

If we can get fixes that's good. If not I can apply a revert.
I'm on vacation next week, you guys will have the time
to figure out the best plan of action.

-- 
MST

