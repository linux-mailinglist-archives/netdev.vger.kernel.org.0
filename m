Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA3A4B918F
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbiBPTm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:42:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbiBPTmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:42:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE29DB872
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:42:40 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so7400861pjl.2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V6GvSkeMpzbMcCLsW7riDk32U5sayYXOrfohODz4Pw4=;
        b=tjR0IPdsWiGYmZfQjE8r4DP51k6mgcq3X6JpRIF3NYe6i5VB118DuZGTTHA7uPQE7p
         Pdoq7gYKbYUFPHEjzyc8ORELcEdIGxTBXvXDl0rTmVqwUxa7kPkbLoecRjoginaW5tv3
         /D1R63L9vGacUs31kAYScZyAIPIYrODo3pgovplymumUb+b5vUA+XMPr9YpCgeuHg8d0
         z4zTVUPgEAwwVuug6fkM/FQmVsFMCguCnE/4X/PIYpUF2XFDfGw1aFZemIQt5P/v5AFY
         MYYt3kNVL0MC6xEwT+Q7XGmPm1nhZmCJ6yKlLjZkTxOHvU5SNuc+pGPgjEqEK/Xks8ge
         3gfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6GvSkeMpzbMcCLsW7riDk32U5sayYXOrfohODz4Pw4=;
        b=j/F1a6LonR5WX/7X2UnkNKEnO+WPaz6qBaDq7rojBkJf4xIzbbhFmLcC+8W17YKhFL
         twdmslcnViH6BIxl37kxJwR4vfHkYjpwd+DwG98mwnWNjho4oqMxugT8kutj+7PFdzLB
         mRu7Bn00+6C7rG1pciVlEavqZWiBfZWEOAws3JUXDgXmiGWFPBVX7kx5eJYD3Plu2Y1X
         5n1ZJSuwYhR+rLJHLtVxNIYeRI/6rZR9JoNuMH1be2liIHPj+Y3Qt1cXnmI2/gsxPkJd
         kLBGdJS3+zvSlXXvslHHB9bASbILud+r+fo7tvpyCTX3c+ycRFLBYeteQ0kpp8S2K3LT
         mwqA==
X-Gm-Message-State: AOAM5305xx4snpEVfS7RLE1XJ2HiU87DvOHw7aq5FGIgBi7R5iMub5XI
        Kqd/IZRuKKzsl6nNWTsqYEbT7Deix6lkAVUU
X-Google-Smtp-Source: ABdhPJyN4tfUS58/Zkg5YTSGUgd4PC8yxTraloQYhIrQPORmsbJmf6rsXVTGB2LIOi4M5uhB0oiyCQ==
X-Received: by 2002:a17:902:b582:b0:14c:a63d:3df6 with SMTP id a2-20020a170902b58200b0014ca63d3df6mr3869984pls.51.1645040559781;
        Wed, 16 Feb 2022 11:42:39 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q12sm46874483pfk.199.2022.02.16.11.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 11:42:39 -0800 (PST)
Date:   Wed, 16 Feb 2022 11:42:36 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] lnstat: fix strdup leak in -w argument parsing
Message-ID: <20220216114236.38018b4b@hermes.local>
In-Reply-To: <5ff8631c-1c57-9bc7-4da8-ae089a7c74a6@gmail.com>
References: <20220215144901.1ba007a1@hermes.local>
        <5ff8631c-1c57-9bc7-4da8-ae089a7c74a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 22:40:58 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> On 2022-02-15 22:49 UTC, Stephen Hemminger wrote:
> > Would strdupa() be cleaner/simpler.  
> 
> strdupa will not free the allocated memory until the caller returns. In our
> case the caller is 'main', so despite valgrind will be happy, the memory
> will be wasted anyway.
> 
> However, I guess that the option is mostly used just like '-w 20', so the
> _wasted anyway_ strdupa memory is only about a few bytes in these cases,
> and from this perspective I also have no strong preference. But I don't
> know how this option is used by others.

There are not a lot of paths through the code in main, so not a bit worry.
