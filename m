Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AA62BD18
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 04:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfE1CCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 22:02:35 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39949 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfE1CCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 22:02:35 -0400
Received: by mail-pl1-f194.google.com with SMTP id g69so7648285plb.7
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 19:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pOlDErsGnISGABUv6kAgBBH16dgcY4KWsZdagc0IJGI=;
        b=MhTu1H0OUc+q4p6PZU2j90at33WeTymGKGrZ8aPasWUsVp8XzkkANQkglkITndEZm1
         /nvt/k+8vNvd7ShpgPRdyBwwZeg3nlFo2aoj8rC9DRf0wFl5KrFSEjc5HT1BeCcmIzW4
         l+hB4/nPh/h8vLCudm6Z/iakEVbw2/LBlyzDVfSuVskuVwhWaWLaa4DMJntTicL0Vi+m
         IAl051+BnBETobgW2T6oTmf52Ob2unNi1NKAg0Y/lwZ8qXmqz6UEh0XRPsL/JZ7tNZ08
         EANgGvWi664IF4q1AXwBf/lGBQ4F5j8uFYMMyipbQ58WcxRpSPZIUUKupFR9dttKOHKz
         elNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pOlDErsGnISGABUv6kAgBBH16dgcY4KWsZdagc0IJGI=;
        b=Ij9CJdoLc6hclt6nbiIj/mSDakknYVVo2YfHBHereO9a/EGRWFylZY5iFjaA7XkKVK
         56yetc2bC6uyQJvocYPT2pi+F0N3W9JPqYrLPmFekqIQrBrbm9NjyR3EvsH1dWIv0NzZ
         RVjJIxfbX5HSPQcsC8AadwEUX6BOudtrW5iE2RWnF7OOsbh7bQjASxbTylyzfhR4SUF5
         8hYAPo8MfZzwTy5yVEaLUgXuDMt6QiR+ugSvfi8/r+KWR6I82FM88s91mOYZebP8aDzO
         u4TusSWJKFCLbhiRsQgEYpmehnCzZNBOpHbOfcCLpfkSx3i/XBTluoDCp8YiBr6MoGam
         kVlQ==
X-Gm-Message-State: APjAAAVlmDfHImPHkmPpJ/y53JVFrgWCq4nlzGh12ciwnZp6DcRDGoxA
        3WjMBDO/L3ebHlVcPpzb76qKPQ/E
X-Google-Smtp-Source: APXvYqxX6E0E4N+ESYt9qFat2Tx3lYVOsSzhqOnrKpDRwnQda1Y9BtbEW432sHxh9BmWJiy/jXrMFw==
X-Received: by 2002:a17:902:d896:: with SMTP id b22mr118856060plz.40.1559008954417;
        Mon, 27 May 2019 19:02:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id r1sm14134153pfg.65.2019.05.27.19.02.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 19:02:33 -0700 (PDT)
Subject: Re: [PATCH 09/11] net: dsa: Move the phylink driver calls into port.c
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-10-git-send-email-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <dbdec1dc-df91-e408-81ff-6e07f3279784@gmail.com>
Date:   Mon, 27 May 2019 19:02:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1558992127-26008-10-git-send-email-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 2:22 PM, Ioana Ciornei wrote:
> In order to have a common handling of PHYLINK for the slave and non-user
> ports, the DSA core glue logic (between PHYLINK and the driver) must use
> an API that does not rely on a struct net_device.
> 
> These will also be called by the CPU-port-handling code in a further
> patch.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
