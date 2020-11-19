Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189782B8A5B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKSDL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgKSDL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:11:59 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6235DC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:11:59 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b63so3055202pfg.12
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=avnDdN+26fqaMqTGvAL5oK7OsC0H4FWqEx23+8BbMO8=;
        b=fNLQ5u9cFdRkCWvp8TaKJJllAmubZtGAGrb3rdJhNx1wxjXIKIvFsRD16CEN38uozJ
         RZfTFGxqJU6I0DIqRPB51RznyGYe8VEp+Xbihuj/Ce5IGm1I0m0W7iiPuKiZWoTj0FS9
         l8Xje+qZ6naCo/F/3HZ9wBJrxJ38qZylW8j/faaU1Wx0seCY+NuthL9tceKdjB99VLQn
         CV3Sy6MwpZCBculgpYQfmoAUfaX3o14KWHLPMZnn+U11FAzMHw1tK8ejsfbQCy6IHywE
         Wh0FY2XdTD/maff4WPlVHCy4ykLg2zL1DCa84Y9Swe2/ETqlj9SsGTmqTVLcKiukSHnH
         Rc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=avnDdN+26fqaMqTGvAL5oK7OsC0H4FWqEx23+8BbMO8=;
        b=sxkPfKaSZ+0x9tD4Ps7rMNLy4mffMw+iRlVJzc3zGnoClY0HTLEAhjjkkJUorRq0jg
         YAQooxdlMV6T5vimW4KXfdGUyuRopPs9RiC3Ui09PvImKdnsZS5kWBVUdeyxPsrvZyiG
         Inru/71PD6vEuGeZdirr3ez6gvtfRSD/tMBU5E+Fm5ej7TklS4KdCWnCP3ukchTNq0gN
         Jn8GmEzRKn0VigUbOu/BqJLnn3ylqHl/238D7O4jGH8c8wW4Ni9CmKYw2SphhktOg3io
         kqPJp2qBrhc4HssacT78PnnJLfsbKPsZgYV40sL5dPcZyBxfsY6hYnjm2JLVNRkP/MpC
         EwHw==
X-Gm-Message-State: AOAM530tpPT+NAj4bcPpXN1rL9i+i7UdcH5YYFfNWE+naiV0N2a6Q2Qb
        QynWdRc3DBPw8o36NafhVCM=
X-Google-Smtp-Source: ABdhPJx58CMFdHxh3GCln6GQq788LkZgEDFPHMqjPK72sYOb7fLO/qgS3w0OpGhM3BdU++i3QCZzsg==
X-Received: by 2002:a62:f909:0:b029:18b:588d:979e with SMTP id o9-20020a62f9090000b029018b588d979emr7382661pfh.48.1605755518954;
        Wed, 18 Nov 2020 19:11:58 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a128sm27856250pfb.195.2020.11.18.19.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:11:58 -0800 (PST)
Subject: Re: [PATCH 11/11] net: dsa: microchip: ksz8795: use num_vlans where
 possible
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-12-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4fd372dd-fbb6-ebbd-c789-d15add443520@gmail.com>
Date:   Wed, 18 Nov 2020 19:11:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-12-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The value of the define VLAN_TABLE_ENTRIES can be derived from
> num_vlans. This patch is using the variable num_vlans instead and
> removes the extra define.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
