Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E59914282
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfEEV1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:27:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37858 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEV1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:27:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id e6so5432046pgc.4
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 14:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/XrBRKwAFDMT7VnxGH0FBo7HLpYORVyy8XIJ7U8J7Ko=;
        b=l7EvNtCi3Jwq1coj2Z/fAktkR8//26wa448CQixLQ05f2iqj/rlBwQ0eeF8UqRduPR
         8p9oUR38XFoX59eaHDd7oawK9nSj8ew5sMpkgh2XYw3x6yH0pHF2RfU6VwvhpJjdPFyQ
         l26pi1C/M+bBtoG8cAXrHrGJUEKfugy7YMziwTU8n/E6itZgTHN/XjwksfV+pc2zPFPa
         ri4GSWwyyVy3HMWrSUqsRycznkL6pzUqsPzQFl35s1qvjcjsBF8pNSOcsYCfGK1DSed+
         JWQ42MK8J6UiZTLZspTNE8gAeAM73WxmQmZrZlAjGcfqrQMcLmNu1RT2CSk/PgV6DHYI
         jNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/XrBRKwAFDMT7VnxGH0FBo7HLpYORVyy8XIJ7U8J7Ko=;
        b=ZXUvIVdyBUDcW41uIMe4oXniIJfa2Hs6vJf92G0d4diTbxuxfLs1QUp8nluuLbUf4S
         LPJNTBZSoutahi7O9DN/iSydV8Dnw2GQi4JQQUjiMdLeEbVS2vM/UaLDiL5aB+HKUD7x
         5a9J7lzA4N8JGdcPLO7nAf8bW0+xE5ZeCBMbvkeZi4sMJhFy7diyRMD8qZf8dD0lXRGJ
         bWwmjLPFa7+Tno5gno/Kf62GI5lVBnLGQkRAXcCARzhNzpcTtI1CTNRGDoxGDL+siL+5
         0T7vhBrdYZJ1nAWoSSzgOq5YOcKK2ybN+kO+faoC0BJnJQj1DNT0GwjV/vDFQerC6RG7
         2AVg==
X-Gm-Message-State: APjAAAXYjIS5AxEd3T2qw48v5g1hxJMhWOtIuR/b6kF5wIqG/doSRRcW
        SDcUuGU7Fz+kCwclGDC2NwBJqVy3
X-Google-Smtp-Source: APXvYqxPnl1yNtkviNtzcoa3BAXt/gq7eY96Q928ZdAhWeTevl8gJBizBGjBFwr0ntYejVG+ZwEqlw==
X-Received: by 2002:a62:460a:: with SMTP id t10mr26738849pfa.3.1557091663488;
        Sun, 05 May 2019 14:27:43 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id x6sm10333968pfm.114.2019.05.05.14.27.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:27:42 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] net: dsa: lantiq: Add VLAN aware bridge offloading
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20190505211517.25237-1-hauke@hauke-m.de>
 <20190505211517.25237-4-hauke@hauke-m.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <10cda90d-2899-62fe-425c-c2e7fdbb108e@gmail.com>
Date:   Sun, 5 May 2019 14:27:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505211517.25237-4-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 2:15 PM, Hauke Mehrtens wrote:
> The VLAN aware bridge offloading is similar to the VLAN unaware
> offloading, this makes it possible to offload the VLAN bridge
> functionalities.
> 
> The hardware supports up to 64 VLAN bridge entries, we already use one
> entry for each LAN port to prevent forwarding of packets between the
> ports when the ports are not in a bridge, so in the end we have 57
> possible VLANs.
> 
> The VLAN filtering is currently only active when the ports are in a
> bridge, VLAN filtering for ports not in a bridge is not implemented.
> 
> It is currently not possible to change between VLAN filtering and not
> filtering while the port is already in a bridge, this would make the
> driver more complicated.
> 
> The VLANs are only defined on bridge entries, so we will not add
> anything into the hardware when the port joins a bridge if it is doing
> VLAN filtering, but only when an allowed VLAN is added.

[snip]

>  	struct gswip_priv *priv = ds->priv;
> +	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
> +
> +	/* Do not allow chaning the VLAN filtering options while in bridge */

Typo: changing.

This looks fine to me, you might be able to simplify the code a little
bit if you directly used bridge_dev->ifindex as the FID and just keep a
bitmap of active FIDs such that you can manage roll-overs etc. upon
bridge device destruction/creation.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
