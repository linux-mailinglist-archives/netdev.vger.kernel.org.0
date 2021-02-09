Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AFF3149E9
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhBIIDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIIDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:03:16 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9022BC061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:02:35 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id f16so2134879wmq.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NlJzbZk3JSdS0LJQRCdPW8dXKNizIvDO8XomnkDw6sg=;
        b=a/XcdKoOYDA2ike8ieFfmy1VBDXLm94lMlPY4IxkAd3vXLSlYET17CMgdV/O2DKB2D
         pmbB0M55z3uPMetYs77nMVpAYDcUibkDk5XBIg/1dX7mizqQWuQRDzgc+Y8hr3tQSy6o
         msee9yeWl/h3AGmAWWsd2ujJU5R1Ax7B5CdSt5lXNu20a6oL+NT2SHNJA6xPi2AAJaB4
         RLGSA4YWyXWcNApo/M2ecLbAyuMy1yvMoFo+IIlbxS0sTjDAAYW/SL/5XSC3Op0DCxqo
         Acfq7uigmEQX3DQ9P4d16U4e1L2W3jGqUi8fUhz8z7170iupHE5Sx1UIJtk3fuUpNQUR
         z4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NlJzbZk3JSdS0LJQRCdPW8dXKNizIvDO8XomnkDw6sg=;
        b=DueiGMz8lGyXWv0B3KxOcq7phRuSecR7mWJOkCjRC1FWNhTIebm5poALWIUUfOLb3h
         i2QrCysGCcCgry0u7hoWx5SNzwOBszdGAzqYxfm5DGjUBVvxvhTbplvjM6c+81IjAqZL
         GSVv2RJMnjKBj0TP21iZq2Rr/9Y7FmyhmlIwPTrkYHnUUUcoVZgk9oiwF62Bf7MqEF4D
         sM6INBZRDEXbsSv8A4vs97W5uL2GHjzCRrQJmqSWGr9fBrCcSyeTqaAvzacb6KN5gQaK
         i74P7vCOqe1SF8ntauiiJPI1Nxqy47JLUqd/bsd9Vuy281WprnVNN7EXKfGSfNLO0Ad0
         NqZQ==
X-Gm-Message-State: AOAM531lgG6s30XwZ0bRtTUv16G2fgljQ3VcvVl6yZt/TvaV3nR66WRM
        O0i5JzHSDMHXAjEKDfsbC1o=
X-Google-Smtp-Source: ABdhPJyNNxngxxhhKYaYKSt8Vl0/fgqmQ3U2QZgtIcXDOKAMmQZA7uP9eysu4ram9BfepU9o2KXzAA==
X-Received: by 2002:a1c:2587:: with SMTP id l129mr2125668wml.13.1612857754317;
        Tue, 09 Feb 2021 00:02:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:88d8:7242:b455:4959? (p200300ea8f1fad0088d87242b4554959.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:88d8:7242:b455:4959])
        by smtp.googlemail.com with ESMTPSA id x13sm2925611wmc.27.2021.02.09.00.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:02:33 -0800 (PST)
Subject: Re: [PATCH net-next v2] cxgb4: collect serial config version from
 register
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, bhelgaas@google.com,
        rajur@chelsio.com, alexander.duyck@gmail.com
References: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <948b3615-dcff-9556-3c68-7037e05583da@gmail.com>
Date:   Tue, 9 Feb 2021 09:02:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.2021 06:52, Rahul Lakkireddy wrote:
> Collect serial config version information directly from an internal
> register, instead of explicitly resizing VPD.
> 
> v2:
> - Add comments on info stored in PCIE_STATIC_SPARE2 register.
> 
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> ---

Thanks!

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
