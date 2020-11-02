Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDB82A3563
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgKBUvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgKBUoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:44:30 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C38C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:44:30 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id w11so7424607pll.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gB0p33pgzGNNsw2aXKYvPLwWgY4mdMPfvyKiVdGX/Bc=;
        b=hFPFnWeAxH/KO6KEk5QAzDsFU/7EqBJ2gTgwDde2lYwkMw19f6z7fjWQCIqsAXeHx/
         tYEF9QVeyEyukbuiIJCoIrQGaJJ44WCx8SVYxMea1b4K6LgOu/IvrIH3w+oIhrP4VsJz
         rKMBw4f63GhTiGPI/ILnHh+5zaT7TmVnV4esrgfVlooKcFd6dUZqs8j5Ixqszke/H9DL
         FmtqiJ7XOqx3ZFv3XVabcDt9mA5WvDHV2MY82nKwXpVgw1WgGXOFuYUoEBcQMLrJITzZ
         2wCg3ciql2K9ZE20Xzaahv/McDCzXZHfi6ZLYRBd6A5gm0vfePz1APtRismO99zz/XJd
         fWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gB0p33pgzGNNsw2aXKYvPLwWgY4mdMPfvyKiVdGX/Bc=;
        b=ByqeNNe18xTCET8tr7h7VY+QrXrijGne+W+X2Llz1ZYucdRi6Mc/CqeZXnCa7XDdq+
         RL4DGM4WdhYgAxxLotyYHK1e+xkU+th0e05WY7MMKUxtUV5hDgdM7jaJk6kU9W4d8k12
         BdHRoRnQAcANbRqkrhQe3UFfE5NdRc1evtmjzOqAhcxmTV0NqufkNOBuyGhvFqc1hLG4
         RMep0231Cak/dcQJxfZX4nSeP9fQ5IUx3OYJmgCs9LJPUokEjn38aX0BzDtyGo8X+sJh
         ryNKQ2F+rGQ3lXp0BeLaHfrdvQdENi0q5GWZkp+ZaCLn9Q/1i+op6WBsWQYnWdH9aYSS
         Ntow==
X-Gm-Message-State: AOAM532ahNlGEXJJSzLC6iPrnZUL+FKMXUOErHmRIPUzzDmfoy+eWjLw
        NDOlcB2JwucjXRQmqrs1YD4=
X-Google-Smtp-Source: ABdhPJzoDxfjTTYX+MIuewKvT6SyCjwXp6+1iSLT8rxGxAG4mcSn99q83vVA3sW/iXS3DRP5U8FvwA==
X-Received: by 2002:a17:902:fe0f:b029:d6:cf9d:3260 with SMTP id g15-20020a170902fe0fb02900d6cf9d3260mr5527630plj.3.1604349870138;
        Mon, 02 Nov 2020 12:44:30 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm14745609pfp.195.2020.11.02.12.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:44:28 -0800 (PST)
Subject: Re: [PATCH v3 net-next 03/12] net: dsa: trailer: don't allocate
 additional memory for padding/tagging
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e9243b54-f42d-431e-d6cf-d6c1b1ee3dc4@gmail.com>
Date:   Mon, 2 Nov 2020 12:44:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> The caller (dsa_slave_xmit) guarantees that the frame length is at least
> ETH_ZLEN and that enough memory for tail tagging is available.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
