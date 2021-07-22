Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473B3D1C8A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 05:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGVDPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 23:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhGVDPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 23:15:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359D4C061575;
        Wed, 21 Jul 2021 20:56:07 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gx2so4325785pjb.5;
        Wed, 21 Jul 2021 20:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=osmz6EY8uXQ1knNao0xDpmsxbyJi+Dvgv0W3ozo2sXQ=;
        b=mju5I/Qjw+NtbeIcS7Y38iQgQAq8F6E/DcavUTSClL9h0pMOejTBqRkiLuF2WCw2Wg
         OL5gruZ1m+ipN3l3tBlmoKwXhJx4epyrBvOzfnBwan20+YwOIz6jCalqqK14fXvZEx4t
         kr6FA42G96kBJYDzKaeUvV/8UDeZX6Gyr3r3JGkjn14xnEvG+amDZP784M9pbZ72ATqF
         Ffk4h+OBiSTk+z7Z5+R4U6Z0TrGWLXPl48VXajCrxkCQ5i2F5T7pvQZ0Jbrosg5JbaSF
         T7ST1tMakpTX7axUk4uid+bQ97/Lb0EooS1QLe0cvUT4FVoKB+C7uK+XRLIovdDpFkqw
         WxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=osmz6EY8uXQ1knNao0xDpmsxbyJi+Dvgv0W3ozo2sXQ=;
        b=X6BtenehT6+LefNgnmOQ8n9M3E+W08m581Jot8yTD7MGc8BHw0/vOMnW5xMuKF5UHZ
         aDiVHJN1Tzuq9DajYc+sTUGou6GD4LU3KQPOHHfmUldadreIo5Y4iIr/nSEovSzBv61y
         UQuUvVJXEO8F4bWkjHRMuwdIdmZJvuM/RG0l4oJ37dDSuHkKBAEHlRZs1MHtZ470FU4f
         7U+aA5dikZW7iW3llfpLRMrMzYn+GoRvPQG1ELmMcT1Ck18EJyVDAv2f+P3ZVGZn9Ybi
         sUAkbYFXwJEd9KNQqrwtzN4GKZ2qoDUKXZ3yEZ+m9lVUmEmTDpVD28HgiG1qjysi89Bi
         Csag==
X-Gm-Message-State: AOAM530CT3076/1wgsY7YDjzyh0XBqpnIzgYArhaLLCOvyWanx+JLPoT
        QKQjig8A8PtLtHtwy+9frhp3RttoCVU=
X-Google-Smtp-Source: ABdhPJwag0I+B+I3EAkXtmsfu0gL0jiGPDpzTGtG/xOSrd2MOu4twfxcMPlol7364JiU73fcODbZ/Q==
X-Received: by 2002:a17:90a:c89:: with SMTP id v9mr39147840pja.175.1626926166241;
        Wed, 21 Jul 2021 20:56:06 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f18sm1295868pjq.48.2021.07.21.20.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 20:56:05 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] net: dsa: tag_ksz: dont let the hardware process
 the layer 4 checksum
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        olteanv@gmail.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-3-LinoSanfilippo@gmx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <06583db0-ac0e-8e9d-324c-faf3f8b38ac0@gmail.com>
Date:   Wed, 21 Jul 2021 20:55:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210721215642.19866-3-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2021 2:56 PM, Lino Sanfilippo wrote:
> If the checksum calculation is offloaded to the network device (e.g due to
> NETIF_F_HW_CSUM inherited from the DSA master device), the calculated
> layer 4 checksum is incorrect. This is since the DSA tag which is placed
> after the layer 4 data is considered as being part of the daa and thus
> errorneously included into the checksum calculation.
> To avoid this, always calculate the layer 4 checksum in software.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
