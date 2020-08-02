Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B9E235A77
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHBUWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgHBUWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:22:39 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60920C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:22:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id w17so19700157ply.11
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MTZ9hBbHQ4P3BCAHY1VE+mtDE/hoSmn/YRKGd0047cs=;
        b=uvuLl7a8Q/XVaJBceOePvrjKsU90AQzLTMeYl6+r4GfebqC4ewHx4yHUBx84cvG4XC
         5ciFZm2pMgLYylV5IK3pdBb1LiaxWdCu+lNkAmxaMN3O3Y3sSw0hYCMqNok/w+qIsaRX
         GELEPJs2whiPwk4njpdCpjshKgByPkH5lOJq9w/Hns9f19hRJMFmqMZLN3svo2C0wkwq
         1b5CEhIj36OpHIgj+KgDlZTTuzlAR9KlMfegf0pjdzYwaQOP8CNp+WWcUE+ef0dE0o9i
         Fzc4Q0OryzOTCQLeLsNVZo7MVYEQ11z2JZkeMZnaY3ZwdtuhrET5NGcGfhZ+ReHiVyJE
         9l/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTZ9hBbHQ4P3BCAHY1VE+mtDE/hoSmn/YRKGd0047cs=;
        b=UFWnVJEMuQYiBCcvRIptxaoq9M6uHi56yqmlIUW3GaM/bttTK+Sc7Hh9N6w42zYdnN
         a6h0gew9LmSmUqhh3s6GlXlvnFIWB5czJh7YD++KSgPqY5GV4csc3UAKtLxDNHR6hC1t
         /tOAUAO1WVNFEDz5FDGkFKDvdCy4LruwaqQt5d7z4hq0UZWMmsCyqyv7KxUoHSdNPxT2
         +FBqQS3ZmEFzZVaAB3Qyi6AvyDiPOWOTirSw0zMq2z/UKsmw7kBIpYX+9tggZUd2il+6
         MGpt0vNEgF96kWA2FX0CXnfulN/bpaK8RAbVq8M6SlmsJAY0VKWgcEbH0z3q9KiiEjWe
         3njg==
X-Gm-Message-State: AOAM532edz8jBWaSklaADa4eBv4CRernpTwWy555tgWWCJGCpL2lpKAu
        4HTRvhCqs6FA0BfuiMm+vBQ=
X-Google-Smtp-Source: ABdhPJx4bsPwzbnTXVczAxTrmloi9dgNDQlJMxUzAsLDGHsRNRC4A8WeJHgpJR309KlnwUaA/pUPpA==
X-Received: by 2002:a17:90a:eb98:: with SMTP id o24mr12695848pjy.150.1596399758908;
        Sun, 02 Aug 2020 13:22:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h15sm17455477pfo.192.2020.08.02.13.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:22:38 -0700 (PDT)
Subject: Re: [PATCH v3 6/9] ethernet: ti: cpts: Use generic helper function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-7-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <81037828-42e0-e584-30dd-23052fa82ee9@gmail.com>
Date:   Sun, 2 Aug 2020 13:22:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-7-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
[snip]
> -	if (unlikely(ptp_class & PTP_CLASS_V1))
> -		msgtype = data + offset + OFF_PTP_CONTROL;
> -	else
> -		msgtype = data + offset;
> +	msgtype = ptp_get_msgtype(hdr, ptp_class);
> +	seqid	= be16_to_cpu(hdr->sequence_id);

Same comment as patch 5 would probably apply here as well, with using
ntohs():

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
