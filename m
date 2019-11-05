Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3EF0A18
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 00:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfKEXNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 18:13:30 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44309 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKEXNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 18:13:30 -0500
Received: by mail-pl1-f193.google.com with SMTP id q16so10450968pll.11;
        Tue, 05 Nov 2019 15:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dKC6j1jeLBICRse32jBvZlax8U2I9iS19Rhzx2V2Pmo=;
        b=HEe6mTK3U0S/2R29AAFYYzgv+qewmgsKnRPVmMNeKP/HV7EyMgJq+yoykmsId+sZuG
         ue2ZgeOuf4zUKExyg+pV3+Di3qESXQGzBoMXmBL2Fq1Uopfx9c4+uQPTn/czpVj/oP5j
         6ZVf12Er4yuf/nuSLtYAIoBmiGimFxbPPlR54vE1jbchyl7Pf29T7ujZcuYu1uWnEESS
         SvwRAC2SX3AU1DrgGwIhSHxMbfNtaxBSL6FhZSg8waOSZ6FDGvFro17nOQSOjaZiR4O4
         xBHic6xGfqxDLSLUoUFnzqPmGkEvZhXc7Qtdj6L7IV4dQKCJ3TjsN5vKF3aA8q6Z8+sH
         3icQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKC6j1jeLBICRse32jBvZlax8U2I9iS19Rhzx2V2Pmo=;
        b=QDeJjdHRydsfkfs/zX7xyPy5HUmzjbYXeWR4aUVFu7IpgFnhSIsdebgJh6B26d8Rq+
         kkH+tb/i7VWrVmPuRQHVV6xYkUfPaxF5d6RmXiCLoeoW3wBPaAzGegdT0eEsa2SHReXI
         VOspGnjr/5XyXwLo7xDuazNmvkMsbUD5S9YxAHQERzCa/owNcuhODqvgm0/YrQjij17X
         IXiCGFKMzkSB4ZqITGwYCrO+S3dHynSTDqA/ZFhKCbgst06naaxh+xGgEtqHCmNazw7m
         YoMr7gdxxqmV36ePAlkJ3Ks3mpeYRce5dHkerh7b8kQ8MtzBmpJ12migjDS4BiJiBgZP
         V1sA==
X-Gm-Message-State: APjAAAXGgjKfv+FR65Gg65oromwP1RyiSNBvP7hLUg5rygGT0cbRqDQl
        hwSZAGTIhvQceGEGJmfRDeM=
X-Google-Smtp-Source: APXvYqxd3JJWyHCYa2QCASDdou2cptpcMqEdpHIrF7040szcoefvRZa6sEzsuPMqw5aAGqUrtcpN5A==
X-Received: by 2002:a17:902:b948:: with SMTP id h8mr8198954pls.139.1572995609175;
        Tue, 05 Nov 2019 15:13:29 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s66sm10005677pfb.38.2019.11.05.15.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 15:13:28 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] hv_netvsc: record hardware hash in skb
To:     Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, haiyangz@microsoft.com, kys@microsoft.com,
        sashal@kernel.org
Cc:     netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
References: <20191101234238.23921-1-stephen@networkplumber.org>
 <20191101234238.23921-3-stephen@networkplumber.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <61195950-c09e-f31c-660c-7f9a858e5b88@gmail.com>
Date:   Tue, 5 Nov 2019 15:13:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101234238.23921-3-stephen@networkplumber.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/19 4:42 PM, Stephen Hemminger wrote:
> From: Stephen Hemminger <sthemmin@microsoft.com>
> 
> Since RSS hash is available from the host, record it in
> the skb.
>

Note that drivers are supposed to do this only if (dev->features & NETIF_F_RXHASH) is true...


