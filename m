Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21EE2711CA
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 04:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgITCmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 22:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITCmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 22:42:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3A0C061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:42:01 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d13so5926069pgl.6
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 19:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pO9RJu+yFNJNVbi5GzqLMiuq+EykCUOCfQJAHryTCks=;
        b=h4sq17+/kxpVw5ssnPSNYGsQ2Ad9OGyIM/o7LsqAvpY5DDlWaBEGpUg3K9xWd3fAEr
         ubJN5gc2r/3EBZbLconcvP3TRaPRJPLK7f60eNu98ntkNan8IuW/lyFIKluRimo7Ra7J
         dOcdF8Oa3A/J14ib+muNRTa9j0PPWpBlVIs5hYepB+PehsUyn4nsPYqBXXLtTt8DGA24
         Co/3JiOWKdIj6VNthqSihKtSWbJHzhvZF+trw0Orv+oj5d95Ys9S3q+OOmraVZu+pwwv
         KLE4rA+xHBKrtTBof0cbN0iDrL4K/JROwBfAmDQbQ5PxmuY7fzFUoI0vOUtPqoXDDbSG
         N9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pO9RJu+yFNJNVbi5GzqLMiuq+EykCUOCfQJAHryTCks=;
        b=AReRch1E3OAw00yupHBqWBUX7YsrRH/466WzZLfeP0DGmWxNyZiGtUGCQhHoD6bJYC
         jSvo6ZqxGimHTlUrmbYGAb2Y+pGL27bz4NsgrvgpgaUXTa6VnxObKjd2VV3a+yk/KFaf
         BYfCPb98LI3I93NAM05cElb2xmrArQF0dgZsQrBa69z/lWtwRrnuhGnBLtoU03htNhpu
         PT/t2GD/j9goorN4S5N5fDysi2lOJo7Z5sYW9CToSHqU9W2+OCtA7f8xJcOUD50hu1oh
         yvy1XgyBaK9SZtKVKiJ6gRYqvWAZMad/esVCshzlYnMEUhCqKnxSl1T2ofQHNga0jhAZ
         OEPA==
X-Gm-Message-State: AOAM532y8jwKEvoz8ZWmtTfodZKca/DSaIBIxKUKdmWUt3NUel/uVDZZ
        m/9+894Z+UhWdNgTPc6AlTU=
X-Google-Smtp-Source: ABdhPJy6tTQi6geuwVxUSPa9A+tXJ18ZOeT0O+nmsGVhDvLIcIsPjFOzW2AbKtP0Q4zdTSCWWH3zOg==
X-Received: by 2002:a63:452:: with SMTP id 79mr5641767pge.245.1600569720681;
        Sat, 19 Sep 2020 19:42:00 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 22sm8030990pfw.17.2020.09.19.19.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2020 19:42:00 -0700 (PDT)
Subject: Re: [RFC PATCH 9/9] net: dsa: tag_sja1105: add compatibility with
 hwaccel VLAN tags
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, idosch@idosch.org,
        jiri@resnulli.us, kurt.kanzenbach@linutronix.de, kuba@kernel.org
References: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
 <20200920014727.2754928-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <46d53f21-d144-a2af-2ea4-71231ec0f48a@gmail.com>
Date:   Sat, 19 Sep 2020 19:41:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920014727.2754928-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/2020 6:47 PM, Vladimir Oltean wrote:
> Check whether there is any hwaccel VLAN tag on RX, and if there is,
> treat it as the tag_8021q header.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
