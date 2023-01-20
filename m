Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C216754D4
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjATMmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjATMmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:42:38 -0500
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627AA7288;
        Fri, 20 Jan 2023 04:42:34 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id q8so3936096wmo.5;
        Fri, 20 Jan 2023 04:42:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKZyysgUPNvqWFopfSE1dHJ7iNOImONyPzrcMggiuJc=;
        b=tnOeJ2/ST7bc4RmpFTsgHhiIxq4RD3I6TypU7FzaMP2DV1gIg1hWiXqfkfNrSpFK4t
         pF+BBVDEC6fEAiNNFaJRRFgaPsoccOt4gJhy2OEE9ONkf9yeN4sZww/jsLtRy+JxMWyD
         vpi0c1MagYGkTBLg1tW+hi2IvgLWPrfk8I0YTCnpRLPhDrxR+5VJwOCpuV+AsJSb9WzP
         mOvvH9OOuL8K65j7cr0EXStIRQBBZM/J++pJ+KV/obFr5ddmPYw8XbaEVT6nGGCCsqCe
         lZyQDChxmKXz5NT90tPv3m4U5bvjA0kqOc771fD7Ahg3gqD+13kHgKhEHd2ZSmb5UAJf
         dNmw==
X-Gm-Message-State: AFqh2koWTs6RoQP8QFKZl2PSD6/aAZcgaTgozd5cmuvCD7lDrUlF4DSX
        DMjguKwA5uzJsAq748CZwNo=
X-Google-Smtp-Source: AMrXdXtpf1blAKy5JSCCwoqiLvsfdaYzkSWfJUxJBySB4u4LThpB6hdiWSZsrCuSgL8RYE2tZGj5Ww==
X-Received: by 2002:a1c:f317:0:b0:3d0:480b:ac53 with SMTP id q23-20020a1cf317000000b003d0480bac53mr14349205wmq.12.1674218552698;
        Fri, 20 Jan 2023 04:42:32 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c181000b003d1de805de5sm2032908wmp.16.2023.01.20.04.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 04:42:32 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:42:30 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [Patch v4 00/13] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Message-ID: <Y8qMNhrhfN1JX4uA@liuwe-devbox-debian-v2>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <Y7xhLCgCq0MOsqxH@zn.tnic>
 <Y8ATN9mPCx6P4vB6@liuwe-devbox-debian-v2>
 <Y8qB5ZN5Czj9lQVK@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8qB5ZN5Czj9lQVK@zn.tnic>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 12:58:29PM +0100, Borislav Petkov wrote:
> On Thu, Jan 12, 2023 at 02:03:35PM +0000, Wei Liu wrote:
> > I can take all the patches if that's easier for you. I don't think
> > anyone else is depending on the x86 patches in this series.
> 
> But we have a bunch of changes in tip so I'd prefer if all were in one place.
> 
> > Giving me an immutable branch works too.
> 
> Yap, lemme do that after applying.
> 
Ack. Thanks!

Wei.
