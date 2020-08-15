Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2F024539B
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgHOWDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728675AbgHOVvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B448C03B3F0;
        Sat, 15 Aug 2020 02:47:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t14so9834623wmi.3;
        Sat, 15 Aug 2020 02:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rnjXjcdoa8K1T7AG+e8ZGPlTXdNLEjYT6VnAJIHsZSs=;
        b=DhC5u+7IZePPcWAY6zRSVw4d9LQe/5vxNN+unplSfogo19W/gQsHWuJWnEfjYUCWZt
         ofTFVmBSDpb39en0q7gzC9dBmnaQ7ujQ56gfikCxE/T94RZkaPyqJuPWUwzxkR5zh6RV
         2zeJYqeeaU1Q1DSdMTqqhY/LRakzcWnmcscyAO2j2jUydkp/FfzI4OzZgNMQ1L8kw/dO
         8TBIMCb35O/0iS3h0EHlOgoUzUUJzgbioSquIoMM8Z4pf3EJ44qo6Vvwwkz35YBAtxYe
         yD9YOvR1WEkLodQ5GO9kGAohvxI6l1LxEt45qDPE61B6uEJ5Kk1wekFA0TDuU9cxy1kN
         mmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnjXjcdoa8K1T7AG+e8ZGPlTXdNLEjYT6VnAJIHsZSs=;
        b=NV6Hg8WtvwFk3QnAk8ys1iWczIEc+UBuJJ7GR3dkcCgOzQ7MNNYg/t4DPPieKGbo9z
         8qNx2M0hKaelKi5zQ2JIvJGM3LpmOLHKsRWDNcAxn4VxKv/tGC8X5PuJ+Bn22FZvX41O
         1YOd8MJOl9Em7TEfH0fAyq5YGylLGDKb2PPWdkCLWR6PvT/aRThtEVDpYIa6cKenw+OS
         FHZHVs3WH2UZ+7lI0rlnMf1sw7tYRVechhZQ7C6UlKlqz+ssju7awXbPuaN89iNNDMWq
         QCBuW3QjFGinJNmSYgMv2XR02QLh2CeInGxMffjIbT2KGfD8rG9QkXwHCiDNU62HfD/h
         yGPQ==
X-Gm-Message-State: AOAM533Fa13G66x2xjuj+aSafO70eRcQlOViu7i3pDoKkOM3YGaHgxyl
        xY8vjm9JSBblmA69rxEDslw=
X-Google-Smtp-Source: ABdhPJz+QzwjIVRKxXK6BWYp+z7ISU45Y8xLUoCpZCu78YaysKfb9s+pgk2lbhYn93Jdk6qPnYy7kw==
X-Received: by 2002:a1c:448a:: with SMTP id r132mr6014057wma.158.1597484827372;
        Sat, 15 Aug 2020 02:47:07 -0700 (PDT)
Received: from [172.20.10.4] (mob-5-90-172-191.net.vodafone.it. [5.90.172.191])
        by smtp.gmail.com with ESMTPSA id 31sm21346274wrj.94.2020.08.15.02.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 02:47:06 -0700 (PDT)
Subject: Re: [PATCH] seg6: using DSCP of inner IPv4 packets
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200804074030.1147-1-ahabdels@gmail.com>
 <20200805.174049.1470539179902962793.davem@davemloft.net>
 <7f8b1def-0a65-d2a4-577e-5f928cee0617@gmail.com>
 <20200807.174342.2147963305722259387.davem@davemloft.net>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <56fb26ec-f35f-a7e9-53af-2ede1104bd28@gmail.com>
Date:   Sat, 15 Aug 2020 11:47:04 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200807.174342.2147963305722259387.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Sorry for the late reply. I'm on PTO with limited email access.

I will revise the patch in the next weeks and make outer IPv6 header 
inherit Hop limit from Inner packet for the IPv6 case.

Ahmed


On 08/08/2020 02:43, David Miller wrote:
> From: Ahmed Abdelsalam <ahabdels@gmail.com>
> Date: Thu, 6 Aug 2020 08:43:06 +0200
> 
>> SRv6 as defined in [1][2] does not mandate that the hop_limit of the
>> outer IPv6 header has to be copied from the inner packet.
> 
> This is not an issue of seg6 RFCs, but rather generic ip6 in ip6
> tunnel encapsulation.
> 
> Therefore, what the existing ip6 tunnel encap does is our guide,
> and it inherits from the inner header.
> 
> And that's what the original seg6 code almost certainly used to
> guide the decision making in this area.
> 
