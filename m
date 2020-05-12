Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35F51CEB82
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgELDcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728110AbgELDcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:32:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66357C061A0C;
        Mon, 11 May 2020 20:32:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id b8so5501517pgi.11;
        Mon, 11 May 2020 20:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=clmXMD0ITkLllb3z7aMvXuaOzSwEr8scUARGMQgkkOA=;
        b=MwmyC6Y8bfURXw/VyPrEWX5jwUBb4+5DH+OlUGuAb9xi7bDbMcy++j6Ia205y9hGGK
         urS5S/VMljVajR8yeXUAng2QH5Tx7EFXnyShW8QgTyCPa4WX7Fi5hdvxPc+l7v4m8otH
         NTNxaZ6a3TYQUNYNA1RZSdAdC9T+u/xmvlo/lK8a4VY6FlyoFhysXLdOOLXKcqenr+/f
         yxQtbgBG3ppIYWXzoo/PJu8NX2b+vNP2Xdp7mueOsRNm7hQhon82eePCtw9AbG7uB+ZD
         z7bM1x4jLSdoatcl5o//Poi8UsuLm3BGjwLJrcYlG+xisQkAtbfZZGHGoF17TOVxvHbC
         hfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=clmXMD0ITkLllb3z7aMvXuaOzSwEr8scUARGMQgkkOA=;
        b=T2JI0lfuBLxCxtFOIpK8VGn4ZFUrI1HECgX9dzWaa1mhVExErgX6YiteBWuw5xB8wd
         3zTNSxmbUPE9EktgBymPaH09z/em5AywJ2VdZRRBt8LLd8PpGh1VubTWoaiMGzX/vqGb
         1f6HrAz1G85MmQStYSCUJ8Ayk/I2YeNIaM4xvnJudcRcWXVTQywLu0kPJea+0bABy2Zc
         sfS4lpCjQzmmcqzDNVUPu4Jz/+NXT+mLSvKc9dbDCG0YAkAO6iy2VRQgDt+Hc6ymX9m3
         MbIA/b8wVaFS8SZtcjwJRUXpvwIFojAvi2goER7D0qpz76mB7JYUHSVAC/EbQ5BRWIzy
         mDuQ==
X-Gm-Message-State: AOAM532ta5NuJDEgLyofTdqbxuuIjwQ6OWhRPodH8nViPVU3zAzL8OD1
        28L+00j1ELkONDihbGsnfFneevbb
X-Google-Smtp-Source: ABdhPJxH3qhxpWgCvYbDXUb/6eM98iMQ2GhZvPv4jhLJatGrFy/LfxBAW2weYoCYoGQGFEj6cE5I+w==
X-Received: by 2002:a63:387:: with SMTP id 129mr8711083pgd.117.1589254337580;
        Mon, 11 May 2020 20:32:17 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f136sm10253123pfa.59.2020.05.11.20.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:32:16 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 07/15] net: dsa: sja1105: exit
 sja1105_vlan_filtering when called multiple times
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4909d016-25ae-c296-42b5-a25df5eb9587@gmail.com>
Date:   Mon, 11 May 2020 20:32:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> VLAN filtering is a global property for sja1105, and that means that we
> rely on the DSA core to not call us more than once.
> 
> But we need to introduce some per-port state for the tagger, namely the
> xmit_tpid, and the best place to do that is where the xmit_tpid changes,
> namely in sja1105_vlan_filtering. So at the moment, exit early from the
> function to avoid unnecessarily resetting the switch for each port call.
> Then we'll change the xmit_tpid prior to the early exit in the next
> patch.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
