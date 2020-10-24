Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26A4297DED
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 20:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762836AbgJXSJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762788AbgJXSJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 14:09:31 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D95C0613CE;
        Sat, 24 Oct 2020 11:09:31 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id v6so6286296lfa.13;
        Sat, 24 Oct 2020 11:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Rs8wf6UTP36EHEFprEmiC1KVvxxowcuUQfMMjdsiuFs=;
        b=VcSrhGthOSMv1Uf40TC0L1Ztwu/uGnTzjd6uR/zaxFrf5yqtDruSvORf773vNXISNX
         T4yVSVT8sVbl2JesSI4MxxOFR71b2/hNYyyVTnVNBbusnUU8x0LpMpU/wOfBP3Pq/+K/
         xPuJJVBdfYyNA8kB77rWFY+5ikAsfKeHtkZsEswp5zFuWr4iWrBwQvYf9jUfH/uRnTNH
         TZVIt38am0Wv+Mokiw1FhKp0sAXBOeOmw4jVmqRopXsYDECXX/7g9FH1V3Ix7hcAfHpO
         HGO9e6ichtOLMJrm5ogtuw4Msi7i9Qj+lj+QStIBxfoiFVs7mIZG4sydPqf3GystAD40
         VRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rs8wf6UTP36EHEFprEmiC1KVvxxowcuUQfMMjdsiuFs=;
        b=MdpFhSU2EpxmRakJN2E01EvKnFDDroySVSHsCbAiidxvsy1eXSJjMeZtIbwCODvFGX
         4KerPnC1xQcQ7dm/iLUcz4EBBP2YZeJnfUCpaWTwszVymbQPBVUlwNVpgXxALGE0Nn4I
         lLycUT32zewD6tYEzBVwWiQ+R3zjiQqnyPE3PA4v/EY9waMmON37uy+eVXVhVQ13Wbc3
         OOAQ4D99CU4BdP83kPa96+nMIwHxECEcJ/O7/9Ue8Xclc8y4uKDTDHCO9/cBuchr3LGQ
         x0Cq4fChw3yVteoDTBx0Gnd2VI85FzAy4bjplQn0n5xC8eO6CC4DZRRhftgv7iSr64qQ
         MEmA==
X-Gm-Message-State: AOAM530rLs+P1BzBwg497fXz48EOCPCcCI1Tx7gruzZt1C81EI8QQYUI
        wMspNCVYlb/bj+sbS2HhWew=
X-Google-Smtp-Source: ABdhPJwy2jkzvtw5uvw5ux5oKF/sdk7XAPUOkbW68+ffyBULVwu1jVXKAQ7S0npp+70bS16fdMa7jQ==
X-Received: by 2002:ac2:5496:: with SMTP id t22mr2415626lfk.43.1603562969616;
        Sat, 24 Oct 2020 11:09:29 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:2e4:31cf:c47:21a0:adde:4748? ([2a00:1fa0:2e4:31cf:c47:21a0:adde:4748])
        by smtp.gmail.com with ESMTPSA id c26sm576743lji.18.2020.10.24.11.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2020 11:09:29 -0700 (PDT)
Subject: Re: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
To:     Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, geert+renesas@glider.be,
        Julia Lawall <julia.lawall@inria.fr>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <6d3d0da6-00da-cddd-1d1a-32e8f612d133@gmail.com>
Date:   Sat, 24 Oct 2020 21:09:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930192124.25060-1-andrew_gabbasov@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 10:21 PM, Andrew Gabbasov wrote:

> In the function ravb_hwtstamp_get() in ravb_main.c with the existing
> values for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
> (0x6)
> 
> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
> 
> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true,
> it will never be reached.
> 
> This issue can be verified with 'hwtstamp_config' testing program
> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type
> to ALL and subsequent retrieving it gives incorrect value:
> 
> $ hwtstamp_config eth0 OFF ALL
> flags = 0
> tx_type = OFF
> rx_filter = ALL
> $ hwtstamp_config eth0
> flags = 0
> tx_type = OFF
> rx_filter = PTP_V2_L2_EVENT
> 
> Correct this by converting if-else's to switch.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Reported-by: Julia Lawall <julia.lawall@inria.fr>
> Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
