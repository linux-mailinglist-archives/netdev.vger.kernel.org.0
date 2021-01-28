Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75785306ACD
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhA1B42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhA1B4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:56:01 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98028C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:55:21 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w14so2971193pfi.2
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bjoVbSxF7JR3Qfc3Zqrjr7UJi1DL/0PDC9WyLXldlhQ=;
        b=hMKsvIkG+Q0WcSZRT4jcrx97LAcvPemtnZh2vtFD/jw7mgUq4ddjo/IB5h+Yk13rO2
         7gFWxDHHX8dnbnZu2TgMmE8tOXLJzpodYhufHoUpcEH+QEglgicHKYF6HJi8pvs2q/KV
         +csv86GLp0ZiTp3KQwBAjDGKrabk0iHuy7nFhCuCxpw399DqqmoniguYYSHfPQ96Tnkn
         3+X/6nXxe/fjStFe4qvtbC8hsEDyGxtq4JitaquiytjAjB51ZT1v0+cqkfutBxZGHAI4
         G1qA/LaK6V+R63HLyyAQR2a66a8UYkQTYl1ywIH3UzyYjiUuH6QutMViA1u4o6KkYBrc
         HypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bjoVbSxF7JR3Qfc3Zqrjr7UJi1DL/0PDC9WyLXldlhQ=;
        b=KhwgiQVSsc+2JgDWuesiv3pSu5zudA35VUCQf8L6xUJgsXeLnmXwaSIFMUleJWLO4j
         GbuG1PYBzzdIhlRNeDvj3bL1wOHrbDsGq8abv9wRPaIIQ7sfAUq6wDyPQHr5SIGmbtTg
         axRMieUEP2KKvikuv1NlTG120hTEWM+asJbdbNQ67ZtXAkfRJt+edurVLeMul+N5zeDw
         AXQau9fp+hcXs0pF1cscJOhqdxh5qguq34GQZU7KRSZQWB8v/BjERf9FZo8AKolah8PK
         ImXb0PTodMAdWsUx0cfHhjFgF2c/FSPO+jbgVRDFfEI/uHTc16xOv/G0QpUuAyRJwwpi
         e0WA==
X-Gm-Message-State: AOAM532WOGOSfj78JjS9xwGvF19w05xSyUM0JhbdJuZ2ZsSCF8zFRxlR
        BI0TUrDyg7lQA6UZDNmm4uQ=
X-Google-Smtp-Source: ABdhPJzWvbLCUzVtg7PwYVFwsM5tsBTc6/71Di1IF6GfH78nj2JEQefR9DQ+66ptxMzpeKXO8mnvMg==
X-Received: by 2002:a63:2262:: with SMTP id t34mr14220670pgm.166.1611798921150;
        Wed, 27 Jan 2021 17:55:21 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u126sm3601485pfu.113.2021.01.27.17.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:55:20 -0800 (PST)
Subject: Re: [PATCH net-next 0/4] Automatically manage DSA master interface
 state
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <99d4c608-d821-7f87-48c1-aa1898441194@gmail.com>
 <20210128013028.kr6jx4xjcm3irllo@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c07dcd4c-4041-0a51-759f-ab0338f95b21@gmail.com>
Date:   Wed, 27 Jan 2021 17:55:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210128013028.kr6jx4xjcm3irllo@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2021 5:30 PM, Vladimir Oltean wrote:
> On Wed, Jan 27, 2021 at 05:03:23PM -0800, Florian Fainelli wrote:
>> I really like all patches but number #2, though I don't believe there
>> are existing use cases besides you one you described where it makes
>> sense to keep a switch in an unmanaged mode being "headless" with its
>> CPU port down, while the user-facing ports are up.
> 
> So what should I do with #2? Every other stacked interface goes down
> when its lowers go down, if that brings any consolation.

I suppose it does, part of me may have just grown too used to existing
model and fear a change.
-- 
Florian
