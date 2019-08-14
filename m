Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB87B8DC38
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfHNRsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:48:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39783 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbfHNRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:48:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so50010729pfn.6;
        Wed, 14 Aug 2019 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JjXmk7pXQOMLxZgpEYBzHbDbsBvtUuW4FzkivJFUtz8=;
        b=lBMuvLlEHpvux9PAgI79qF01xOk4oEUbokALibaKFb7HhKQ4EWeBTFX5OCP87/aDdW
         8C2gRUf3C55DbxRUaCVtUyD3Ef6+liZAlojYpZ4QYU61T+dovMJjTXfvQ0xEnVLQ0Vkp
         9OHc7G/ZqpLHCfsSY7kf1yiQIx+CUCFuZp6AhqF6BHOv6iY6bA9/WBucvS0/W41k3VMp
         Kz+gTjbCp+GWraGRDpa8x8gKKm0GXrB6euT3wQhX1F4v1OWI3Qc2yg+dIh8ozcizn6O+
         FXpSn4hXahzFA7FsKtvg8iPRsHj8SdgehRGFjr+MMqVnLvNXcLB/DVLbj+DEiCDJMn/J
         CZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JjXmk7pXQOMLxZgpEYBzHbDbsBvtUuW4FzkivJFUtz8=;
        b=BRwJJ89VgaZjxvRlvEAc8vmNw+eq4gL7AINonMn8c34MMb/UgEGe6mAaH4JWP+lgTV
         whnPJis1bz20hqV+l0rkrNIxsDjBvWXm7u14OvKtMBhZ1hM11RFCKfbpAamzeHQWb2Yl
         AnU7tND82fqtSro3ZRCEhRIq2k+5hIOzSqyRgtFrIA+I2E8ShKRaa+RRPyN9r2RXQqmA
         ehT8HTqLy+D4ASISQIIhFr9l5RNiW/R0ejvLj9Ayn5N2c20EAj6TZYjeX4FQ9MDwkeC4
         MSy8Z7h0NTYmvEwv8G8pz9bTfMGSi/3UrS+20WQqHsej2ZKglqU6UppRQpnwG8+crY30
         nbrQ==
X-Gm-Message-State: APjAAAWf+pXlDl+NPD07qGnGUmjdo5CdWFoG8Zm+mlz7eR1Ft4Tj+rXi
        Dzux32OYQF06dQf+yRA3KmQ=
X-Google-Smtp-Source: APXvYqzfkLeKkyjIgLIPq570di138yN6m5FnJNr/6PfkVy4YtQvKN3AUSGHwtl9ryfes2NifRmMbJA==
X-Received: by 2002:a63:9e56:: with SMTP id r22mr294495pgo.221.1565804929926;
        Wed, 14 Aug 2019 10:48:49 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b14sm428475pfo.15.2019.08.14.10.48.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:48:49 -0700 (PDT)
Subject: Re: [PATCH v4 03/14] net: phy: adin: add support for interrupts
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-4-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a888c1d9-4f5d-c3fa-4526-94586fd9e242@gmail.com>
Date:   Wed, 14 Aug 2019 10:48:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-4-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> This change hooks link-status-change interrupts to phylib.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
