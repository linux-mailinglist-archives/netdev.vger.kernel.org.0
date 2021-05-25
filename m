Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4E38F810
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhEYCZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYCZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:25:44 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7447CC061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:24:14 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q6so15950892pjj.2
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IV+Sz2tjVOzCFe61QwTfgjusgAx0TK6saE4nl1082EU=;
        b=BChqujL2OzTnSQp9PH0t+DHvJr+acHyxYeArtyJwLewNMSK06bboiDHQ0hfozc8nGk
         2r0+s9c7wH0i2olt7X876Wg1gtAEG+6uv8YqJJopa6vYwNZjhriRR1o++QgkKEIri8yR
         jKsu7NluUm6sFXc59nSpPHTx5QxdhpCQakjYwuCT6R5GTwnupOXhV0WLZ4sLZ9j5h9zX
         tn9QFxI9EIfw+0m8vD5NoROAFpjl8+X/EpJTF2NvaKtF3eiQvaRfgDV7m7mYjBSobu3F
         YKy26gRAKoprlAsBat/UYKRwSQE6+aWyhJ+AqlAw0zbqvVr9uqcLOOmnlwp5QFO1jYY+
         k5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IV+Sz2tjVOzCFe61QwTfgjusgAx0TK6saE4nl1082EU=;
        b=VtvJJ8I5kn1CTOAm7DU72QG83CbgConY1opVXPHuIlaDqnux7Iw2chEpDbQ633R9B/
         5Oj27P+zM6Ac/L/23jj4mUTEpfVAlTf+jTJ+QGz/8QRPj+qG+QCRexJfL50yWwaosnn6
         MZbEGH4N2acaW6k8p76bZSHABAVY7VE4GH8AOinXVvz3k9rLicawaOTcpkjyQfMTE28m
         E1hetbnJWNFMofTuDf72e5c0xmbHJedZOIO3pQVht9zRrqS1XK0VwmYCywNNshuvvDN1
         B2jq5+fLYfce0/2AydBARzPOSJAyfQfowX16aTxRfhLI2DF1MdQ7tWLF4iY351KgYXF7
         f52Q==
X-Gm-Message-State: AOAM533GA9SUrojpHrZVj/Ri//5EwEV3wMnwznUcFGjCpCsT7dVR/6C5
        1Iuze7qm9X7IKxK93ji7kco=
X-Google-Smtp-Source: ABdhPJzdjw5134RBGUCGf3/gbz9aOu0m/tbOcPj4zFhoB8MCS29+kfLfmHtxbDv0vlGw7Vopx39TJA==
X-Received: by 2002:a17:90b:3b86:: with SMTP id pc6mr28664631pjb.162.1621909454016;
        Mon, 24 May 2021 19:24:14 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 68sm11998235pfu.7.2021.05.24.19.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:24:13 -0700 (PDT)
Subject: Re: [PATCH net-next 07/13] net: dsa: sja1105: always keep RGMII ports
 in the MAC role
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eb3e9ba6-718b-8dda-dc97-da86ca52d9e3@gmail.com>
Date:   Mon, 24 May 2021 19:24:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In SJA1105, the xMII Mode Parameters Table field called PHY_MAC denotes
> the 'role' of the port, be it a PHY or a MAC. This makes a difference in
> the MII and RMII protocols, but RGMII is symmetric, so either PHY or MAC
> settings result in the same hardware behavior.
> 
> The SJA1110 is different, and the RGMII ports only work when configured
> in MAC mode, so keep the port roles in MAC mode unconditionally.
> 
> Why we had an RGMII port in the PHY role in the first place was because
> we wanted to have a way in the driver to denote whether RGMII delays
> should be applied based on the phy-mode property or not. This is already
> done in sja1105_parse_rgmii_delays() based on an intermediary
> struct sja1105_dt_port (which contains the port role). So it is a
> logical fallacy to use the hardware configuration as a scratchpad for
> driver data, it isn't necessary.
> 
> We can also remove the gating condition for applying RGMII delays only
> for ports in the PHY role. The .setup_rgmii_delay() method looks at
> the priv->rgmii_rx_delay[port] and priv->rgmii_tx_delay[port] properties
> which are already populated properly (in the case of a port in the MAC
> role they are false). Removing this condition generates a few more SPI
> writes for these ports (clearing the RGMII delays) which are perhaps
> useless for SJA1105P/Q/R/S, where we know that the delays are disabled
> by default. But for SJA1110, the firmware on the embedded microcontroller
> might have done something funny, so it's always a good idea to clear the
> RGMII delays if that's what Linux expects.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
