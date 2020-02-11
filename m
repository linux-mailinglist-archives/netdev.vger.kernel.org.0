Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0604159A08
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgBKTtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:49:03 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:56116 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbgBKTtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:49:02 -0500
Received: by mail-wm1-f48.google.com with SMTP id q9so5214312wmj.5
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 11:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=onFNEHCSqA1i45YtZX9E1GDGako99hrIyJv/gSWdOfA=;
        b=HxdX1E/qkjlS5Ho/UoGmDC42YPZ+3LPylhWRPE5Nuh64admZI1lqDRLPBSn5uS1a6a
         qG7hbGSuea0hxF9ewbLviuI9OZXmCl3oBeCEziv/bAw4JyLmdnaE9pUDEKToyHtKvEQK
         p/KV6urVn5RWW2qR/gb5bRGoPLL84mTeSTe5AC+kAVyno/mNMTce489GL42vjPvXhOtF
         yeQm6nBrm6aqExYSsl11BSLejLUV8SN//br6fd1oG6ctejcCKvPLAvrDAJJLSNOP1mf4
         sCxGN28Em5xxnCbKJvEPciRLg0NHb2lpAgXO855DTGw+XrBZwRWUH/J0mggxj+Q8yoxY
         bsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=onFNEHCSqA1i45YtZX9E1GDGako99hrIyJv/gSWdOfA=;
        b=jMgMRssXcS72LAoZKQcPKrVCvPssc2GrepqvrvGSM7FzKVok/KOIh6ZDR15L+Dy1iB
         sj8zmfpSuNCHHoUgZO5saltEPtV+E8IdiQAciNUEpg+ksV5+4wB7eMMiGsXTDgeltZsm
         KmS1VVXOSMeNJFn3bvYkMQNP4fU6tWtCqPxgzzK0zGsXz1qlOZPcRqU76/+WxBVsicfV
         9RtPTcWk3SbnNPLCLSa2phxE4HC6aq/PlBqbhkyNAo2Y209W5gM94otbyFA/Oedm9X1J
         +vUfQ2DXgwq8T7l7pdhpFmNWKtwLjOo2YkiWLaRKeu5Weow88WmYtTH09DGRETksrDXt
         ZmYQ==
X-Gm-Message-State: APjAAAWWK+1XBNkryVDoNcvLoRsjvXm01RHq5fdRArRrHOJvx0oYNm4C
        jQa/15O/5bDWrCMpZYqBjyF9lPNB
X-Google-Smtp-Source: APXvYqzpSlzfiZVuWTv7ekV7ArRj0X8n39aOEQYyxrYN7KbLfI6B8xenvyyQ9VFkIxOuOhwx+DjtjQ==
X-Received: by 2002:a05:600c:291e:: with SMTP id i30mr7754310wmd.40.1581450539894;
        Tue, 11 Feb 2020 11:48:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:680c:97fc:ed27:4abd? (p200300EA8F296000680C97FCED274ABD.dip0.t-ipconnect.de. [2003:ea:8f29:6000:680c:97fc:ed27:4abd])
        by smtp.googlemail.com with ESMTPSA id x132sm7147736wmg.0.2020.02.11.11.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 11:48:59 -0800 (PST)
To:     Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Question related to GSO6 checksum magic
Message-ID: <29eb3035-1777-8b9a-c744-f2996fc5fae1@gmail.com>
Date:   Tue, 11 Feb 2020 20:48:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few network drivers like Intel e1000e or r8169 have the following in the
GSO6 tx path:

ipv6_hdr(skb)->payload_len = 0;
tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
				       &ipv6_hdr(skb)->daddr,
				       0, IPPROTO_TCP, 0);
(partially also w/o the payload_len assignment)

This sounds like we should factor it out to a helper.
The code however leaves few questions to me, but I'm not familiar enough
with the net core low-level details to answer them:

- This code is used in a number of drivers, so is it something that
  should be moved to the core? If yes, where would it belong to?

- Is clearing payload_len needed? IOW, can it be a problem if drivers
  miss this?

Thanks, Heiner
