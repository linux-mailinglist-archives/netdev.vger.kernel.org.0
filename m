Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAC21428A
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 23:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfEEVcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 17:32:54 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39680 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEVcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 17:32:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id w22so4117736pgi.6
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 14:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DbDgApU/+s4MikjzBXonmcU/pzzf95W6AZf6rFSBfTI=;
        b=qCfBS0Knkhaod9zzXBGG6I8wZIm8p+Jm/YpJfWe653JQGMVdPLQNB2iSqA0/nrh7iQ
         6hDTGN4LHEHD5zhMw5oyUctu/1vRyn2Y1V9dDFRDtYouFBSgd4JVVltLotlP/104ua4M
         6ilcWYoF6VSw9PAEgPOKLC9rZ6TZYXpIbAzAav3qIb5G36MiXBAJ0KPdrT5z1WwiSP7L
         CZJKipJONBxbjqDO7+X94ZC7CDFiEDQ/cVb8V2pzTZ/6xDjT+HBPCu0Uq6NsJWhlV/1b
         3J9Yjq5ANTj1V1r8Hb8DfhJttiTAVHNzLRl//SeIqEyOXlA0SQ5WHTHo0pttLir1lMvG
         dzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DbDgApU/+s4MikjzBXonmcU/pzzf95W6AZf6rFSBfTI=;
        b=JFyUdCDZruB9lv8QJLa89+cvQq6iXgN1tDL+mvwjiBlOT2rFLmwKqdJ4uek4hv8ESr
         KPyZVNFr1+y7KvAWmsWs+v7tz+YaHEuKiJQLCHcBXA2Bew/+Eev3bwP8zTbL6Y4JCxYr
         j91ThCfbSr4+14xXk4QPvFZdaHje3iF7A+gV1U0+7czBXzDcJPnjWsfFxBxZwp9zleqQ
         MgFN7VV4ZIp7co+mf1qbqtLsfT1Rf8TEUvq6mUPGGM8py4PmZ7W8FMpym62/PBZNqRpD
         oNOeN+QiqUf3gwyLTVmLEEPZT/wzj4pIvRGA5DmSa3nL/CTCIbwCzJ1u6wkSCDUNKER5
         eraQ==
X-Gm-Message-State: APjAAAWl89sooeqS1/X8+MzDJnnEOEAOC+nzKrctn0hmgD6glBo4QYvk
        X9mUUPHFFfmyFPkf1GScwGa35YjN
X-Google-Smtp-Source: APXvYqxuFBP4QjFrtYrbMx4WtVAVzo2e2ikEvMuugiyBT+acUG1FhtGmcCJdbGASWu4q88CglHY8Ow==
X-Received: by 2002:a63:441c:: with SMTP id r28mr9238336pga.255.1557091972905;
        Sun, 05 May 2019 14:32:52 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id v40sm999623pgn.17.2019.05.05.14.32.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 14:32:52 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] net: dsa: lantiq: Add VLAN unaware bridge
 offloading
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
References: <20190505211517.25237-1-hauke@hauke-m.de>
 <20190505211517.25237-3-hauke@hauke-m.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <369e2a17-f4eb-6ed2-d7b5-36a0eb044960@gmail.com>
Date:   Sun, 5 May 2019 14:32:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505211517.25237-3-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 2:15 PM, Hauke Mehrtens wrote:
> This allows to offload bridges with DSA to the switch hardware and do
> the packet forwarding in hardware.
> 
> This implements generic functions to access the switch hardware tables,
> which are used to control many features of the switch.
> 
> This patch activates the MAC learning by removing the MAC address table
> lock, to prevent uncontrolled forwarding of packets between all the LAN
> ports, they are added into individual bridge tables entries with
> individual flow ids and the switch will do the MAC learning for each
> port separately before they are added to a real bridge.
> 
> Each bridge consist of an entry in the active VLAN table and the VLAN
> mapping table, table entries with the same index are matching. In the
> VLAN unaware mode we configure everything with VLAN ID 0, but we use
> different flow IDs, the switch should handle all VLANs as normal payload
> and ignore them. When the hardware looks for the port of the destination
> MAC address it only takes the entries which have the same flow ID of the
> ingress packet.
> 
> The bridges are configured with 64 possible entries with these
> information:
> Table Index, 0...63
> VLAN ID, 0...4095: VLAN ID 0 is untagged
> flow ID, 0..63: Same flow IDs share entries in MAC learning table
> port map, one bit for each port number
> tagged port map, one bit for each port number
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Reviewe-by: Florian Fainelli <f.fainelli@gmail.com>

Looks great and well explained, thanks!
-- 
Florian
