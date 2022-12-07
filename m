Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4D646519
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiLGX3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLGX32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:29:28 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9618AACD
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:29:26 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id k2so11129923qkk.7
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 15:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ZZkG+Qh1aym6roTCOMKJrBzIlZ6e3/h1nx0KB0nWZQ=;
        b=IRJAvdL9bJF5wa8TKb3lIIaMfcZthRa4Fc2FYH47GAAjDWMn2r1EPs/rUni0ul4bdw
         +ktgYf6lGNHZep5JAWZ2GKR/BirfY/H1W6cNn8e9zTlmor3SELgt2lwviGTfPCXXZSFW
         Na9knU0EmPNJ25f43LKjBc5MiF8+JzPDCKsRTU7BSwXFNnhYcNQDe4Ushc5+NflEC7mo
         2r43GY6fHxCmgrXjp+j3xglshE9k16ojaaLMkfROJFwXtfZ+/Pep1O0IUlBK3IA1Ta+p
         pXe5UZOSkpQYP+RYgYjGqKd1oktcdNECS6hJICcUFd6lga/9b9a8WGa4GfZeyTRy4jyn
         ZKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ZZkG+Qh1aym6roTCOMKJrBzIlZ6e3/h1nx0KB0nWZQ=;
        b=xWwMJJf+rUHhduiIZkJihgLxXFEzG8T+Eue8UPSeRGfYbuTwj6ASwmGhYOt2EVFzK7
         TT0gE5klQzbKeaEQ8tyGT8SqyhdiJhM7IrUwMCVpKjhH/LGke4UZQAHKjI3gO7kKUBAL
         ssMgDF8SqErzMZlrRnFRyHGdEPLlX+mRaDOmBVznwqhxWUovSW/et63h9yQvU79y5GkZ
         W+dTsMDlDdYBX0KCOIZ2S8tevHQyLzHV17svm+cJhq7ffC3zi48FrrBF4LEVkBKcMsMP
         V6BdnC19v2W4XDMCDXFDxAfU2+1DMqsU2KNdLIRtFQ6BPjl1kdCQNIggxgSkR3zQy0J+
         ZH+Q==
X-Gm-Message-State: ANoB5pkmNNacDmBVbY5RGui3wiiaWhC4fmxZLcxwbNuHGsKu8GYHKWld
        tdxwK/safpZIW+cCAweHImDSPw==
X-Google-Smtp-Source: AA0mqf5xHesK9HKgeRl+kujJdBiEK8wc+Z0M14t1KBrJH1kV7mMFGwyJ6QpQ3tfjCqVF+oqx4wgSuQ==
X-Received: by 2002:a05:620a:43a9:b0:6fa:18a5:376d with SMTP id a41-20020a05620a43a900b006fa18a5376dmr57362219qkp.220.1670455765571;
        Wed, 07 Dec 2022 15:29:25 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id d14-20020a05622a15ce00b0035cd6a4ba3csm14542842qty.39.2022.12.07.15.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 15:29:24 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p33qu-005Qvt-DN;
        Wed, 07 Dec 2022 19:29:24 -0400
Date:   Wed, 7 Dec 2022 19:29:24 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [RFC PATCH vfio 3/7] vfio/pds: Add VFIO live migration support
Message-ID: <Y5Eh1Doh0d98wz2v@ziepe.ca>
References: <20221207010705.35128-1-brett.creeley@amd.com>
 <20221207010705.35128-4-brett.creeley@amd.com>
 <Y5DIvM1Ca0qLNzPt@ziepe.ca>
 <a94d3456-a7cf-164c-74f1-c946883534cf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a94d3456-a7cf-164c-74f1-c946883534cf@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 01:32:34PM -0800, Brett Creeley wrote:

> > Please implement the P2P states in your device. After long discussions
> > we really want to see all VFIO migrations implementations support
> > this.
> > 
> > It is still not clear what qemu will do when it sees devices that do
> > not support P2P, but it will not be nice.
> 
> Does that mean VFIO_MIGRATION_P2P is going to be required going forward or
> do we just need to handle the P2P transitions? Can you point me to where
> this is being discussed?

It means the device has to support a state where it is not issuing any
outgoing DMA but continuing to process incoming DMA.

This is mandatory to properly support multiple VFIO devices in the
same VM, which is why we want to see all devices implementing it. If
the devices don't support it we may assume it means the device is
broken and qemu will have to actively block P2P at the IOMMU.

There was lots of long threads in around Dec 2021 if I recall, lore
could probably find them. Somewhere around here based on the search

https://lore.kernel.org/kvm/20220215155602.GB1046125@nvidia.com/

Jason
