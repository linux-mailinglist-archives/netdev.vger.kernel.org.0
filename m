Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9944B3B26AD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 07:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhFXFR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 01:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhFXFR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 01:17:26 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A39C061574;
        Wed, 23 Jun 2021 22:15:07 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so4391065ota.4;
        Wed, 23 Jun 2021 22:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ygVK/gHTe32gLfYg+HdMiky3oi3YqC6Bf5Vvmj5Zl+8=;
        b=sBvyWoSY43NEdsQuD2mpylbcW+pJ2OA/rEmAizwqasIEpG7j1cRvGQdQqkQOkkEPoD
         jpE3P/r6WjYYSBbhSZBQH6KGNMohNQcO6+z0iK2Y95X5k2ZgaK7/kVwW21/1M+cZLOLm
         +pn6HwIxlO4hGsf5ZyX5tUteSuhW447ykhqPhjxNjA2CpPvDIuWE0ZHcKy0SJZ4TMHSg
         xnowYIvUE235ox1gs2Dvrv6cr1JQaAvNcLP4tx15fIPWZ7xE52ILxsqbcgn65ydkxTP5
         IMNUkvi+5B9Qm7Ecw4HlIRVwE4W6ToiloA4yHh0q5xsFy3CKA58Lox3+wgbW4c+YcAHb
         UevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ygVK/gHTe32gLfYg+HdMiky3oi3YqC6Bf5Vvmj5Zl+8=;
        b=QW+0+pCUrM/1LjCNEA64uLhtEKrvZO7DLtV++B7Li2zFN1TYsxEHnwdBYJtyLgh1Nq
         H2Tw5iFsj2scwEKB6YagkEL5aw1HxHII4+lsrqPeTDRiMaGmoUhQrAj7msduIto323v6
         BI52A/sxgn3FIcCCJ25iP5Xdq9X+rsg6+1e4F0RkBzStcL8XUdJpSmT9/wn9v4WnLj/n
         avVsNo86FSNobD3443l+Pcb54yafP/MOwkZEmAbZ+eTZ0nMv+UHCgdE15QTCpnIX9yFn
         SpVC6bDUUHzj1Y/KcoKvzRuYHfx9903KnNPTIMa1y2lu+qHKmlm9LOSUd7bwfdWly0Ay
         JCaw==
X-Gm-Message-State: AOAM530fg++bvMgXNOaZt8TJx2UkWzuOnzDLtyakeyXOTTuzRP1B8gqb
        Sgz6Uz7ZFE+Q7oBjsUnLgRY=
X-Google-Smtp-Source: ABdhPJzFTXWfeFhKgI+SmmsouB3/cWaqzN1wX0lKKpc8lOfLNfz97zh7StsBeRMv+x1D6+Quas1v3Q==
X-Received: by 2002:a05:6830:4cf:: with SMTP id s15mr3108209otd.72.1624511706557;
        Wed, 23 Jun 2021 22:15:06 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id 61sm62037otl.30.2021.06.23.22.15.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 22:15:06 -0700 (PDT)
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
To:     Rocco Yue <rocco.yue@mediatek.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com
References: <YNNtN3cdDL71SiNt@kroah.com>
 <20210624033353.25636-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <020403ac-0c2a-4ad8-236b-d32e59aef772@gmail.com>
Date:   Wed, 23 Jun 2021 23:15:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624033353.25636-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/21 9:33 PM, Rocco Yue wrote:
> 
> The difference between RAWIP and PUREIP is that they generate IPv6
> link-local address and IPv6 global address in different ways.
> 
> RAWIP:
> ~~~~~~
> In the ipv6_generate_eui64() function, using RAWIP will always return 0,
> which will cause the kernel to automatically generate an IPv6 link-local
> address in EUI64 format and an IPv6 global address in EUI64 format.
> 
> PUREIP:
> ~~~~~~~
> After this patch set, when using PUREIP, kernel doesn't generate IPv6
> link-local address regardless of which IN6_ADDR_GEN_MODE is used.
> 
> @@  static void addrconf_dev_config(struct net_device *dev)
> +       if (dev->type == ARPHRD_PUREIP)
> +               return;
> 
> And after recving RA message, kernel iterates over the link-local address
> that exists for the interface and uses the low 64bits of the link-local
> address to generate the IPv6 global address.
> The general process is as follows:
> ndisc_router_discovery() -> addrconf_prefix_rcv() -> ipv6_generate_eui64() -> ipv6_inherit_eui64()
> 

please add that to the commit message.
