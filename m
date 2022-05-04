Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA351B23B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiEDWwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiEDWv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C300527E3
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651704501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xOeJYvGSOMJD3tTL/lLoRftgg1kVko3RAGSpsjhKUO4=;
        b=HoiqYeIliOFsN7DtJzKTJzJ4pECNKcoujEMtP89awmReKGzwjDXF3geH7T5PtL5X0moG+o
        2RwEd7JUls537yx6PZFaoaZnJ8l3vF/8zP+wOXL8q7LpwN8oXGA9mpJhnPHAE0o3JKqXLI
        tSo16r92D4xBwPAq6WlcsF8+bWLCLtc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-E1w4SvlpOMakrD3mbat5vg-1; Wed, 04 May 2022 18:48:20 -0400
X-MC-Unique: E1w4SvlpOMakrD3mbat5vg-1
Received: by mail-io1-f69.google.com with SMTP id s129-20020a6b2c87000000b00657c1a3b52fso1860565ios.21
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 15:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xOeJYvGSOMJD3tTL/lLoRftgg1kVko3RAGSpsjhKUO4=;
        b=1bJPJtMfZM+ndsdYEWuAmCw9TaMmobQosvm9x4uOzeilGBLQEGS1cGHKtkSdLdjRcV
         5Xj/M/ePQQGb7grQlrToBfiLRA+cVosxcY/J85gRzqzjJzh935oOqttCt1AtnNUAk9EH
         N5SHfajcgr2hDQrAbax2Djf+a0t4FtFvDg/1WXoCzV7qQErkHNgvkuG+juQ9a9DD227L
         JuV/xW1jCjvOQ5ujC12x+aKEB8EnAhUtO+yIyGX+V09dAHy6PApe1U/GD5c9rO4PATYp
         c6JUhmUA6DdpTvTGqKc2gypi2qAHg7fnvQ5Vrz5nyRfZpvYbthylQ/aZyGTzf/na+gU8
         0H9A==
X-Gm-Message-State: AOAM533+YaEfNFSJe3DYpUoh1bJBT2VJk0tBch49mxnp7t3UoLqyfSGn
        4QfSarP+PbT2cW7RI1nXjFa81yzL7LTLyOYmGQ1PKtjEetGI/uyQZ2jEPcx0zuqCBqkBXc9B8Ij
        y6RKEn9Q/rU7M1Xtr
X-Received: by 2002:a5d:9448:0:b0:657:24e0:c0b2 with SMTP id x8-20020a5d9448000000b0065724e0c0b2mr9082791ior.167.1651704499228;
        Wed, 04 May 2022 15:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv7opUQwDW4a+DX12v3ZS3+a6b1pREiCVADRhe7RFeKSIfVEiN8HcWu3icEqj+XWft2nvRLg==
X-Received: by 2002:a5d:9448:0:b0:657:24e0:c0b2 with SMTP id x8-20020a5d9448000000b0065724e0c0b2mr9082781ior.167.1651704499005;
        Wed, 04 May 2022 15:48:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13-20020a056e0212cd00b002cde6e352cesm15508ilm.24.2022.05.04.15.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 15:48:18 -0700 (PDT)
Date:   Wed, 4 May 2022 16:48:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Message-ID: <20220504164817.348f5fd3.alex.williamson@redhat.com>
In-Reply-To: <20220504213309.GM49344@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
        <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
        <20220504141919.3bb4ee76.alex.williamson@redhat.com>
        <20220504213309.GM49344@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 18:33:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, May 04, 2022 at 02:19:19PM -0600, Alex Williamson wrote:
> 
> > > This may go apparently via your tree as a PR from mlx5-next once you'll 
> > > be fine with.  
> > 
> > As Jason noted, the net/mlx5 changes seem confined to the 2nd patch,
> > which has no other dependencies in this series.  Is there something
> > else blocking committing that via the mlx tree and providing a branch
> > for the remainder to go in through the vfio tree?  Thanks,  
> 
> Our process is to not add dead code to our non-rebasing branches until
> we have an ack on the consumer patches.
> 
> So you can get a PR from Leon with everything sorted out including the
> VFIO bits, or you can get a PR from Leon with just the shared branch,
> after you say OK.

As long as Leon wants to wait for some acks in the former case, I'm fine
with either, but I don't expect to be able to shoot down the premise of
the series.  You folks are the experts how your device works and there
are no API changes on the vfio side for me to critique here.  Thanks,

Alex

