Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08588FB41
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfHPGmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:42:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37413 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHPGmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 02:42:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so3182496wmf.2;
        Thu, 15 Aug 2019 23:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xp0cV1T8QqWFrsu+p890NKB7KHlB7e7qWQp1z5/R+kE=;
        b=JkMLq57/GwznBjc/mG2qaHFvngTQgo+pjkg3AHVN6fhZZPSxIwHyoGqYNTudI7R/hM
         zlfL5usg/LSCYnzYZ6H9YwwFj1hLPp6scQI+l25GXOIqTZoRW3nsxkcs3XXW3y7lwum6
         TFhK84R1P92tu0EngtMGJQdvjt79Tn6fTmclcrUvKUFX999QfHiS10BQCuDYJX4O7fZK
         847WXpI2uPUQzxjiKAlGHsHszxnGwBSob5eZDCGecMMmIU/3AXq1yupsh3fqXJcVVW5y
         gswSMJEU51MO4dapognxdwx9QQ3y4xsZunOd0IrgcHd8Ti9TGSK2lqLoBHtrR/RoWJAB
         Z0Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xp0cV1T8QqWFrsu+p890NKB7KHlB7e7qWQp1z5/R+kE=;
        b=LN8BcvSCImvj83VJD69XS0O8aZr/LPKrl8cHAcX0T5T2P9PguH7lWbw7+s3U4kcrNB
         m2gFieiFcWKa4ytJba7Oo61mf9oPwsrD53lHqCk2SGVMmj40+MuhKLL6jE3BGmsybA4i
         wIQJpRhVpwtGki7UloHm/xSq/CL1ehVBIc0D6mDbz6ilCAiCpirAHE/sq+IVG8ZKxCdq
         Fif8fQCZvstLD0k40LCTNoJZ4F0TJymSJr/0DYGV1cIm8Ftun7fp2Bt6IxMl4BVPbFWi
         7Wcr1cbIYSUqljjgkUK0vWpg8sw3l7JvRzAaxMz4tGMWuj5Lc+c3L6jqwqsiGDA8labX
         q2UQ==
X-Gm-Message-State: APjAAAXCkiNVKQIxwfQV31daaHqnF2EycU957Z2nrjeusI87n6MYrz3K
        NZ58HBlmkYUC5xhlXSN25b3fyfvU
X-Google-Smtp-Source: APXvYqx6TdU+vGHBuITzu6Wvb3E/caPa9behnY+5nhcVzyyMZLsSzwaeSnp/MKApyupCq6phr6aJ5w==
X-Received: by 2002:a1c:a909:: with SMTP id s9mr5532919wme.20.1565937757478;
        Thu, 15 Aug 2019 23:42:37 -0700 (PDT)
Received: from [192.168.8.147] (187.170.185.81.rev.sfr.net. [81.185.170.187])
        by smtp.gmail.com with ESMTPSA id u186sm6637644wmu.26.2019.08.15.23.42.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 23:42:37 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/5] r8152: support skb_add_rx_frag
To:     Hayes Wang <hayeswang@realtek.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <1394712342-15778-289-Taiwan-albertk@realtek.com>
 <1394712342-15778-295-albertk@realtek.com>
 <1394712342-15778-299-albertk@realtek.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <614e322b-fcca-fd4f-f338-76a7fbf84ad1@gmail.com>
Date:   Fri, 16 Aug 2019 08:42:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1394712342-15778-299-albertk@realtek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/13/19 5:42 AM, Hayes Wang wrote:
> Use skb_add_rx_frag() to reduce the memory copy for rx data.
> 
> Use a new list of rx_used to store the rx buffer which couldn't be
> reused yet.
> 
> Besides, the total number of rx buffer may be increased or decreased
> dynamically. And it is limited by RTL8152_MAX_RX_AGG.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>

...

>  			skb->protocol = eth_type_trans(skb, netdev);
>  			rtl_rx_vlan_tag(rx_desc, skb);
>  			if (work_done < budget) {
>  				napi_gro_receive(napi, skb);
>  				work_done++;
>  				stats->rx_packets++;
> -				stats->rx_bytes += pkt_len;
> +				stats->rx_bytes += skb->len;

use-after-free. skb is no longer in your hands after napi_gro_receive()

