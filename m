Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93172D8640
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 12:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437354AbgLLLjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 06:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgLLLjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 06:39:31 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF867C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 03:38:50 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id 23so18118841lfg.10
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 03:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vr/ehKsC5KMehkQikZ0TuYwNtHT5OhCeJ3y1Omtjjl4=;
        b=wjSJ9pdZQUUT27Sg/rWjz5GOQj+MYUXA0KOm09ErJw14EqzXsOqihkAVFdfEtc5K+x
         8WuMZKkr1LhNjlsZli6XDeySjpg9f0YKc8OmUAo4VX7N2cm5TT6uvYfvds2ji9DoWEG8
         ZslWoEmRGgkgZHFFy15CKVmtVzoZhi6/rokklNkQaviUJ04qF8ZkzkR8fwOfQLxKMKSM
         j9JaOaQ5jNrgx38T6dzCThxmBLKSjc2Y0BBVvUZhNIPZLDmTTins0ox1CVCmOWnQLl20
         uG2pofrnS+PmhcpvMMglfUwERGXzCeUeJ69MFmFTUvoJTj45IfGTdBBxfAckB0o0Dqta
         C8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vr/ehKsC5KMehkQikZ0TuYwNtHT5OhCeJ3y1Omtjjl4=;
        b=olgVPYLyeH+EH9HX2ArtXiKPLFVFocQhDscigWkI3Cwi1qZnT8wMPvWqJ2zVUY55oh
         6yyLE3s800ILBdxZy/ZOWnCoVc03q8JwoAUcjZLBSrXsdNB94NdfhM4D3bpeCxq0uksJ
         56MiLE6DySywTzXN77poUcuk/322026fBxOhuRsO7ovpjqBbB2+ykEXbkSPIyhTrrCQ2
         iuKwpyQdMexdLvIe29jt6yB770xgJVUNmVX3CbaPg6CNW9/Tv/OPIPPTvuh/GwuOiAPW
         YZmfYGoGbjsqF/vVWZwYidpTpevmJ8B33nXadIPDwVXE8gMJihN/IGtDSJXMXhK1+m5A
         zMfA==
X-Gm-Message-State: AOAM533K12bKKKArIlalut1EniMY/TMhIja7TGP3QI4RpBhfUg8hM8Q+
        sQ4ZLnUplx8Xri4jF1rows6ZBA==
X-Google-Smtp-Source: ABdhPJw/mXyksVDW6KLjd+vhATDcqSnPLkx2hNw8BDUZ3eZInjkqw5cAD2TmYJ8wr5nXV9By61VS9Q==
X-Received: by 2002:a19:6e0e:: with SMTP id j14mr6818933lfc.374.1607773129248;
        Sat, 12 Dec 2020 03:38:49 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id t196sm1216685lff.195.2020.12.12.03.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 03:38:48 -0800 (PST)
Subject: Re: [PATCH net-next v2 04/12] gtp: drop unnecessary call to
 skb_dst_drop
To:     Harald Welte <laforge@gnumonks.org>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-5-jonas@norrbonn.se> <X9SSTS5cPaKXsv08@nataraja>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <aae73590-9554-6502-eff5-e93cd6d83581@norrbonn.se>
Date:   Sat, 12 Dec 2020 12:38:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <X9SSTS5cPaKXsv08@nataraja>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 10:50, Harald Welte wrote:
> On Fri, Dec 11, 2020 at 01:26:04PM +0100, Jonas Bonn wrote:
>> The call to skb_dst_drop() is already done as part of udp_tunnel_xmit().
> 
> I must be blind, can you please point out where exactly this happens?

It's in skb_scrub_packet() which is called by iptunnel_xmit().

/Jonas

> 
> I don't see any skb_dst_drop in udp_tunnel_xmit_skb, and
> in iptunnel_xmit() there's only a skb_dst_set (which doesn't call skb_dst_drop internally)
> 

