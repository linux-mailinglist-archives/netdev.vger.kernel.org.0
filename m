Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FE8591F2F
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbiHNJAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 05:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiHNJAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 05:00:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E02E82019C
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 02:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660467600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fgWKHQAsxfiE02svIG1GlyOPzEiU/s53wr+EvIkuC5s=;
        b=J4tVZ+M0Gu7V781uzhWABohzRobapa6k8QbJgAFUOnNukpF3AoQry8sw1iOxr/eeEr70U1
        JYC83b2uIPgMjAuy8He9N0aEoeBSrEtbVygTGul+ceoPT/uWDplRXUYhgyU/yv16ofnakE
        fM5usB7+ysuB8FzCKYsVuZ76dN4tnLk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-439-7hKkii1NOR-80lyGwbsaNA-1; Sun, 14 Aug 2022 04:59:58 -0400
X-MC-Unique: 7hKkii1NOR-80lyGwbsaNA-1
Received: by mail-ed1-f70.google.com with SMTP id r12-20020a05640251cc00b00440647ec649so3147923edd.21
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 01:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fgWKHQAsxfiE02svIG1GlyOPzEiU/s53wr+EvIkuC5s=;
        b=inhr2W6aouyMya2iuBTYAFeaHZm5Ay1igwDaIEWJlnwOQRfyXcxh6wTj3jMkiHlMJ0
         PI8IJ2Qc4OsSwQiA8FnO8d/MEDB2nHmoUtWATqVKq9ddso6aoUyyeoytCTKvg1LcwDMi
         OcZYwnfIVuyKdahkJLIx9aOS2cx1g6OX9QWhMdJa+EIbNqAqgiXG3tM+0LdasrqFd3Q3
         4CqvigB/7OEaFdFPYgvnv25NnfqnIazYasfVCWP2pgBMv419jpAirx75+eDgaIWnXEMR
         eAaH1XSuUxY+1Zf9FfylLiqneTp7fYsfay4zS6b1sZBXzN1QdogJGQKopXx+OkU4hi4W
         oeXw==
X-Gm-Message-State: ACgBeo3XR33wPywgnPBFjzEzSO0H3UViNALrTcrSyJS29BTuthVm5fQH
        DkPmFbSE9K6W0bqKmd/OO/s2hbBT7MX7A+zWkCSIoRltMnn6sn1d5qXioaL1JurS76Qt4zODb2U
        zIgWd0xyHgjatjNPM
X-Received: by 2002:a17:907:8692:b0:730:b0d3:5311 with SMTP id qa18-20020a170907869200b00730b0d35311mr7626849ejc.674.1660467597651;
        Sun, 14 Aug 2022 01:59:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Jadz5kR2nLnc2rixgHWUCJWsMJ+KvMQFIq/16RUbwY2CdGtnCFdI14mOJpckbCgySblIwmg==
X-Received: by 2002:a17:907:8692:b0:730:b0d3:5311 with SMTP id qa18-20020a170907869200b00730b0d35311mr7626840ejc.674.1660467597281;
        Sun, 14 Aug 2022 01:59:57 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id hr16-20020a1709073f9000b007317ad372c0sm2717544ejc.20.2022.08.14.01.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 01:59:56 -0700 (PDT)
Date:   Sun, 14 Aug 2022 04:59:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, colin.i.king@gmail.com,
        colin.king@intel.com, dan.carpenter@oracle.com, david@redhat.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        gshan@redhat.com, hdegoede@redhat.com, hulkci@huawei.com,
        jasowang@redhat.com, jiaming@nfschina.com,
        kangjie.xu@linux.alibaba.com, lingshan.zhu@intel.com,
        liubo03@inspur.com, michael.christie@oracle.com,
        pankaj.gupta@amd.com, peng.fan@nxp.com, quic_mingxue@quicinc.com,
        robin.murphy@arm.com, sgarzare@redhat.com, suwan.kim027@gmail.com,
        syoshida@redhat.com, xieyongji@bytedance.com, xuqiang36@huawei.com
Subject: Re: [GIT PULL] virtio: fatures, fixes
Message-ID: <20220814045853-mutt-send-email-mst@kernel.org>
References: <20220812114250-mutt-send-email-mst@kernel.org>
 <20220814004522.33ecrwkmol3uz7aq@awork3.anarazel.de>
 <1660441835.6907768-1-xuanzhuo@linux.alibaba.com>
 <20220814035239.m7rtepyum5xvtu2c@awork3.anarazel.de>
 <20220814043906.xkmhmnp23bqjzz4s@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814043906.xkmhmnp23bqjzz4s@awork3.anarazel.de>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 13, 2022 at 09:39:06PM -0700, Andres Freund wrote:
> Hi,
> 
> On 2022-08-13 20:52:39 -0700, Andres Freund wrote:
> > Is there specific information you'd like from the VM? I just recreated the
> > problem and can extract.
> 
> Actually, after reproducing I seem to now hit a likely different issue. I
> guess I should have checked exactly the revision I had a problem with earlier,
> rather than doing a git pull (up to aea23e7c464b)

Looks like there's a generic memory corruption so it crashes
in random places. Would bisect be possible for you?

-- 
MST

