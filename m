Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE608AE7F8
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 12:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389319AbfIJKXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 06:23:07 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41425 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbfIJKXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 06:23:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id j4so12983578lfh.8
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 03:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lGeaxF3361ZDLiRqfF69m3YDCCCGOzfp7qjSAKXwPTg=;
        b=eQS3JCRLBSiW5Mt35LrQ5+2f69gohd/Yvt8jIougG7z5DGVI1WZuwY6W/hPXPyTsth
         oxwTJdx/YhhpD+vkH7T2M9/kxF7cb53Kb+BZ/xRuCc8XAaIDLBX5VmNRgAUo8SDlCuID
         DB1rLbTklq+0pIZro1F8T5EeehSHzEmP3Fi9zAoWknKzIojzEZ0wkr0e+op5tKKxkwKy
         l2J0gqH6sQq93lagiag3PoxkwqSGdLBTEHvm1CTqD5cutL1Fx0gb/SSiqPnODDarVSCw
         xZV/TDRhPEbg/lR0nG6mNYSUYlvmuW2JbOutnXB2HjCxOVtwREvNXYd1z6ZfIzqiCWYd
         00Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lGeaxF3361ZDLiRqfF69m3YDCCCGOzfp7qjSAKXwPTg=;
        b=lXNLbXYWmAN1m+725nQp23zdwb0UYk+TB2h6hRM1aFs8XrncODXLuvLHwG6S2nSjY6
         dcYzA4cNwapMGuzeYtN6WoeGRqPkGXo4cUjxZHRlIi5reFipUqE8Gq+69IDhCNKZnaK/
         L9g+58TZl1c7CvC3svIUxXyEtRmWXRqoSIzDJOuTthPHj4TDJnGYFKCEKvCSBLFt6/de
         xl6ZCDfQ2fu3kQhFMqsXLvXk7ZQzjJXvakF8MGoINbf1HntVLMPYLWEuiOLjsyw+1D3l
         Ca57n38wd91WxAQQWx71+LmQjgeZjCWze1gK9AI0/VB0/KS0ZXBVvruqr5RkXfCbHGte
         t9Rw==
X-Gm-Message-State: APjAAAUggkDby5Ze03jGbLyZY1iYagPf9p/9o2PFXZoWRAojbquLA9Nh
        t/kcKvRBx+hFbtaWuP82XGnEpQ==
X-Google-Smtp-Source: APXvYqztvyzPBWtSL77EjwyenOIL/v0d8dvqSOCsEqtZmZvm4lpKZu/t14IHzUuXAQcJsBk8FzxIAA==
X-Received: by 2002:a19:6008:: with SMTP id u8mr16932886lfb.12.1568110984703;
        Tue, 10 Sep 2019 03:23:04 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:29f:2049:ec7c:4ff3:ee75:27b0? ([2a00:1fa0:29f:2049:ec7c:4ff3:ee75:27b0])
        by smtp.gmail.com with ESMTPSA id s5sm3722048lji.104.2019.09.10.03.23.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 03:23:04 -0700 (PDT)
Subject: Re: [PATCH net] net: sonic: replace dev_kfree_skb in
 sonic_send_packet
To:     Mao Wenan <maowenan@huawei.com>, tsbogend@alpha.franken.de,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190910085848.144780-1-maowenan@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <a48a6690-eeb4-91d2-bed8-439d14b63e2f@cogentembedded.com>
Date:   Tue, 10 Sep 2019 13:23:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190910085848.144780-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10.09.2019 11:58, Mao Wenan wrote:

> sonic_send_packet will be processed in irq or none

    s/none irq/non-irq/?

> irq context, so it would better use dev_kfree_skb_any
> instead of dev_kfree_skb.
> 
> Fixes: d9fb9f384292 ("*sonic/natsemi/ns83829: Move the National Semi-conductor drivers")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
[...]

MBR, Sergei
