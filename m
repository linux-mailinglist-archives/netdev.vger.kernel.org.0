Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97D1379D5D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 05:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhEKDHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 23:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEKDHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 23:07:03 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BD3C061574;
        Mon, 10 May 2021 20:05:57 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id c3so17696719oic.8;
        Mon, 10 May 2021 20:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JnHqVVEfRTu9JkoWKbT89biz9F5E98u3YQefU6ToVJs=;
        b=IHDqgZVX8rwjXdiEQWd77E0h7YLUDnGNSHmDHPDRPX8+EMCxTkKC32U3k1YJVV9YxG
         MmGR6aoMgrHvHafjfpNZD83B6pCe51ND0t91/NvETI/VJANZADGzAzrBKtGgW4GzwTUZ
         69CLIp2DHIK0Y/yp254IPIM/FWsL0jyTqZYif2IncazNeCpBQ9szradgdIFLUTDdw1+d
         0588UdAxo41V/3Rsikw6uwKVD5/2d9s0iANQ9emxlvgAAmmAdulVHvRFyc07a4JW7kgv
         YAGKQGMkvxZRo096wDGq5R+ad347kHBUF81JA56pnZBK8axyoeqmYv37PL0BUwCEzWqv
         x8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JnHqVVEfRTu9JkoWKbT89biz9F5E98u3YQefU6ToVJs=;
        b=MK2PCJQAILwBi5SBS7qP9clIynLp288iz0IfABTrnwbflOi7qkg4c0gSXMKAW2rktY
         hwJzdIEs1kIBeV29jlT13VMp2ZEGzAMjvLSgmprYr1XRAhgj9lXn7B5Mvzdrv+uum5Sm
         BGQEIMVWupoEmQcp2IaSqNoD4IoTKvLqI0qhWMpnDBiXUGBWV9l5ZAYzlxL58P40GPTO
         CwLuWUBergWSFCNQcpOn4gVnEsRCLWFICnjIrTc1c3ZgXstp4KqE9nq5Sh8kSTByHJFJ
         IJ6YvfEAjGh2e7x0IBqyhtlb6Wqf+QNGiW1Ompk44VK6yMdwUGkMPIjQWddUnhS1F7bP
         VTtw==
X-Gm-Message-State: AOAM533rDKjbo/rdCvmeV4ogrjKF5MwCqRwSmIpFsFQOY3WwOxurYE5H
        Zj4jcdwX9y2mteAKPr3C5EK4zmlxnvBmjg==
X-Google-Smtp-Source: ABdhPJzrxBcF+IhTlgsq620YFfreAbh7Vmr1yslK2IAm/T1PEFwxTfAN3W5RsdH60tzMIFwGNzGMcQ==
X-Received: by 2002:aca:d493:: with SMTP id l141mr1855190oig.51.1620702357025;
        Mon, 10 May 2021 20:05:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id z4sm3473871otq.65.2021.05.10.20.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 20:05:56 -0700 (PDT)
Subject: Re: [PATCH] net/ipv4/ip_fragment:fix missing Flags reserved bit set
 in iphdr
To:     meijusan <meijusan@163.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210506145905.3884-1-meijusan@163.com>
 <20210507155900.43cd8200@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1368d6c3.bd1.1795900a467.Coremail.meijusan@163.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <28dfa69f-2844-29c4-5405-421520711196@gmail.com>
Date:   Mon, 10 May 2021 21:05:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1368d6c3.bd1.1795900a467.Coremail.meijusan@163.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/10/21 7:18 PM, meijusan wrote:
> 
> At 2021-05-08 06:59:00, "Jakub Kicinski" <kuba@kernel.org> wrote:
>> On Thu,  6 May 2021 22:59:05 +0800 meijusan wrote:
>>> ip frag with the iphdr flags reserved bit set,via router,ip frag reasm or
>>> fragment,causing the reserved bit is reset to zero.
>>>
>>> Keep reserved bit set is not modified in ip frag  defrag or fragment.
>>>
>>> Signed-off-by: meijusan <meijusan@163.com>
>>
>> Could you please provide more background on why we'd want to do this?
> 
>> Preferably with references to relevant (non-April Fools' Day) RFCs.
> 
> [background]
> the Simple network usage scenarios: the one PC software<--->linux router(L3)/linux bridege(L2,bridge-nf-call-iptables)<--->the other PC software
> 1)the PC software send the ip packet with the iphdr flags reserved bit is set, when ip packet(not fragments ) via the one linux router/linux bridge,and the iphdr flags reserved bit is not modified;
> 2)but the ip fragments via router,the linux IP reassembly or fragmentation ,causing the reserved bit is reset to zero,Which leads to The other PC software depending on the reserved bit set  process the Packet failed.
> [rfc]
> RFC791
> Bit 0: reserved, must be zero
> RFC3514
> Introduction This bit , but The scene seems different from us£¬we expect Keep reserved bit set is not modified when forward the linux router
> 
> 
> 
> 
> 

Why process the packet at all? If a reserved bit must be 0 and it is
not, drop the packet.
