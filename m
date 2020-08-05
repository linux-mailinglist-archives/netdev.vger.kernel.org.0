Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAB623C3CF
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 05:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgHEDBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 23:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHEDBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 23:01:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3D5C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 20:01:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id x6so8426247pgx.12
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 20:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LFVHvYPB5yfNOKAKwPYCA41L66u/+hsymfnshvTbxXQ=;
        b=LOcneMRZf0GagR5iH5b7KHMTCb+u3inHnHuOArCNmvCB/m8rPdo2taTyr1u91J9/eZ
         gyIh8lplxif71q86kQ8C2DxNm+hm9D5NYR6J8Dz1VuuFvwaFCyzk3CT0hJfPAMUEO0Hr
         yCUMXtBR8DjFJJJUXmZIfN6nGALDKpj1rzegCRZyns+szVlIT2ieazFXuC7HlSMDqeVw
         Iksqbym/nLQQi9NXqBkjuHeEzDZHlP2/9+TkpL78ZwOQrHBPyRP8tWSZZ31jQKEayQYo
         L91oBqxl6HHcDhYSDWC1bXYKZyf1Yw9LU1fwDs4Ln0fS9C4JBPd/kcF2tTlrx6wOoD6Q
         6vkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFVHvYPB5yfNOKAKwPYCA41L66u/+hsymfnshvTbxXQ=;
        b=HzuDezJtmoLxA8K6VTLZC92ZpER72o8ZQvGtltAoFDhI9NZTR4TKONXBbfPHRMu7QP
         rLCVSure2bTvrq/2QkE621L1NVrNGmvYL/bZX8nWS9dEzjAX9wq73bGXhxsnw4OZ7HRE
         wn7cvEvBYwbKWZlTE+kWVxJGZ0rd5pSER50b+qz0tRYuN+ZKc4xYe2RqylBxlXRYjI4g
         v5siUdXHi0PAgl0X+yAAsDeHKWpPGyfjD2acDNu1bAtKewDcz/0xNRVY+01VCLUUCgnO
         XbBQJ8u4aVxQu67fhBR7ImXVCLENDoHC4c9oVJQ8rdCOW5TnImWZW/QknITgVU3KKUMS
         XRGg==
X-Gm-Message-State: AOAM533pMGrFcnbe3+aUKImcX0DQcfGRR0bP0vrsytZRePLaQ4uUHJ08
        MvXOeCFd1zKutghaR76x06HxXjHq
X-Google-Smtp-Source: ABdhPJzogC7joXzV3ICUNtvP+epeVjwsUHe6m0nFD1CnddTEWV1ZK+SAaxREmG1/1XpxNRTAfNUKtw==
X-Received: by 2002:a62:ee03:: with SMTP id e3mr1254237pfi.10.1596596511986;
        Tue, 04 Aug 2020 20:01:51 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g8sm779136pgr.70.2020.08.04.20.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 20:01:51 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: use detected device id
 instead of DT one on mismatch
To:     David Miller <davem@davemloft.net>, olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com
References: <20200803164823.414772-1-olteanv@gmail.com>
 <20200804.155950.60471933904505919.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3d3de571-fcd3-7885-628a-432980d4999d@gmail.com>
Date:   Tue, 4 Aug 2020 20:01:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804.155950.60471933904505919.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/2020 3:59 PM, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Mon,  3 Aug 2020 19:48:23 +0300
> 
>> Although we can detect the chip revision 100% at runtime, it is useful
>> to specify it in the device tree compatible string too, because
>> otherwise there would be no way to assess the correctness of device tree
>> bindings statically, without booting a board (only some switch versions
>> have internal RGMII delays and/or an SGMII port).
>>
>> But for testing the P/Q/R/S support, what I have is a reworked board
>> with the SJA1105T replaced by a pin-compatible SJA1105Q, and I don't
>> want to keep a separate device tree blob just for this one-off board.
>> Since just the chip has been replaced, its RGMII delay setup is
>> inherently the same (meaning: delays added by the PHY on the slave
>> ports, and by PCB traces on the fixed-link CPU port).
>>
>> For this board, I'd rather have the driver shout at me, but go ahead and
>> use what it found even if it doesn't match what it's been told is there.
>>
>> [    2.970826] sja1105 spi0.1: Device tree specifies chip SJA1105T but found SJA1105Q, please fix it!
>> [    2.980010] sja1105 spi0.1: Probed switch chip: SJA1105Q
>> [    3.005082] sja1105 spi0.1: Enabled switch tagging
>>
>> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Andrew/Florian, do we really want to set a precedence for doing this
> kind of fallback in our drivers?

Not a big fan of it, and the justification is a little bit weak IMHO,
especially since one could argue that the boot agent providing the FDT
could do that check and present an appropriate compatible string to the
kernel.

That said, there is nothing obviously wrong about this proposal and at
the end of the day, what people care about is that the right model gets
picked up, whether that happens solely via compatibility strings or run
time detection can be left to the discretion of the driver.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
