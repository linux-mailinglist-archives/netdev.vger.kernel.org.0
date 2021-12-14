Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FAA473C06
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhLNEew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbhLNEev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:34:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69501C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:34:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z6so12711620plk.6
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V0Kb+rPaHeO83ZFNc2mLDWKS5ys7mIEfUFuVUJPQMkU=;
        b=BeL826zJHa4rvDeCKov4ZDoMFGMmfrnUVSqUWs+PNsSkhFRIgCz7t4sejICY5/rHZ+
         ZXc35rrhar2r6NywLaHAyqQpgzsCQe26JVolvtzDxkWdDbW8zzlbyt+a6MIYd/KSGEIK
         +cERg0VN70peqMehesj4dBCAG4pvzo8QYij7H3bzy3+NlZNFIIULxx7NrQNacBozI5vM
         8W+mX2hqIsGAyvfggia+Dk51WyLz9+Xz6BNVmr68uxi40ayLHRI4bKwq0atDAm3xl8N1
         Gxbg8rH3swpwQ0TtCBHBZqJT95Zm5saRDUcXkmhRMkQ+B1hH8fyK9cA0Zwk9NG8NZoa8
         5jyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V0Kb+rPaHeO83ZFNc2mLDWKS5ys7mIEfUFuVUJPQMkU=;
        b=WU4T9VaMUbC77PbSeudF1+KOcCiplKn0A5E5/N3DEzpJPj0O4pnSZ/qUQY1lh1xNjE
         PaTMBPpgXwEEzNXEFwIxxZ4zUEicnGeWugssBjpvx5pgSkCSrupF0Oq0zEEBx6ST7DAM
         9bbCLASkYxathjV/DfDtkVXWxCOzhYNoeaMg4CKQLE9307FohqW9FsRfFGEPdSjuxG4w
         72/lrBWgqA9Y/k7gIwU5NvDHRGsrTeqXCzlILaklB2MW6/8zlvLdPFuaStPB/zNAKbx7
         su3j64o04Pm4X6+lL9TE8r8ibY3h+gYqQVdGwsU9SRjAu7r+TlRBwLzDO6NHYQUSOvgy
         fAjQ==
X-Gm-Message-State: AOAM532TUCOv0vPdCK5a7VANDHzXM5VaXfu9yCG0K+uTgLWNUUfpB9y+
        l36JNOETFuKSLLU2CYMqj4A=
X-Google-Smtp-Source: ABdhPJxoRj5CQQpKUgCQDpsu+861MbCFm/SqViksiINVIAKhCisLD7b476n3lYR5u3+gMyd0AxCK5g==
X-Received: by 2002:a17:902:be06:b0:142:5a21:9e8a with SMTP id r6-20020a170902be0600b001425a219e8amr2833960pls.17.1639456490951;
        Mon, 13 Dec 2021 20:34:50 -0800 (PST)
Received: from [192.168.2.179] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h128sm13426559pfg.212.2021.12.13.20.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 20:34:50 -0800 (PST)
Message-ID: <701ea34d-d94c-9ea7-16dc-eb066e71780f@gmail.com>
Date:   Mon, 13 Dec 2021 20:34:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: fix broken connection
 with the sja1110 tagger
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
References: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
 <20211214014536.2715578-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211214014536.2715578-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/13/2021 5:45 PM, Vladimir Oltean wrote:
> The driver was incorrectly converted assuming that "sja1105" is the only
> tagger supported by this driver. This results in SJA1110 switches
> failing to probe:
> 
> sja1105 spi1.0: Unable to connect to tag protocol "sja1110": -EPROTONOSUPPORT
> sja1105: probe of spi1.2 failed with error -93
> 
> Add DSA_TAG_PROTO_SJA1110 to the list of supported taggers by the
> sja1105 driver. The sja1105_tagger_data structure format is common for
> the two tagging protocols.
> 
> Fixes: c79e84866d2a ("net: dsa: tag_sja1105: convert to tagger-owned data")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
