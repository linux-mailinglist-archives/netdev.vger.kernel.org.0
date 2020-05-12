Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79D71CEB85
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgELDeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:34:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA6C061A0C;
        Mon, 11 May 2020 20:34:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f6so5522398pgm.1;
        Mon, 11 May 2020 20:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W8dLqANTNFn9AN5absS3+EM2h3zccrJm9G19h2ZFVVM=;
        b=kVRz/O7umyxUlX9kp/fRvPTQ7bhdbtA9yzbKqWmux6q0iBemW2j1RxutPypJqBvHOc
         FUnC/29Ayb4LXEV6TiaIUd6AiHrmN1ydUc5ENWgCuSJo7+hSdtP81sm5ml6ZJmdWHZgL
         sQfWTsQToT51i0wDYe1e4+xPNf8SKpBDHlgDoZ+nbPwEXRINKLhgJolXS4P3whFjGm/w
         rUR/nVZfjk5wqlElLMUPYp4gTMSbLJ87tT0T/17q2mDhFXQyzWhT2Ie7rtUOwMYwJ2kQ
         eT2aygGcSmDK84amIsIiZgxLGCkSrqBW7m8TQPvQwoeyHpo0a40HSOdk2+9mLPVeNHbq
         Ge3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W8dLqANTNFn9AN5absS3+EM2h3zccrJm9G19h2ZFVVM=;
        b=ft2JJ7SiN1WgWS39/zkMEHi5bAxh1KvU1Z8f/GCvlNP5/PrCdOTK63yHUDuejRdZPB
         gVjKnJB2lXfb4rlo/a92tCfhUKXZwkaJjy5YqUhw2xbApQaZ7ny1Kpc15gW9fpxrZFMH
         tr1nkrLX84IoMVKwjE10Rsg1o7xvVBE4fgfwy8QSPxuZSm2G7KBYZ18ZaGWseGfld6zu
         n5n4pEtQxEZFb2VqX9dAaeSs16KTdHvG/YUNLDTcGLo/Nt1DRL3Tl70AUgB4REoyly6C
         oljmllG73G2HClpuuHvLsaHa61rSfoxws/gUbdv3imSSIXN4laQHPU1FlH5tjjEOK1pa
         2K8w==
X-Gm-Message-State: AGi0PuaL7Bex9tCmroRexFzn916wlw1SpeGD8TgiiBQlaf6U82l0Y1Dn
        7L3XHSLsdyCwN04D6gYANUMMsXRQ
X-Google-Smtp-Source: APiQypKtpnOkoyIgFmC2XGPGNeb0aP5LJeNS+oMs7YG5gUdZWZettmnZTbEMA05FvphAd+8ZDpW8Rg==
X-Received: by 2002:a63:a61:: with SMTP id z33mr17514757pgk.440.1589254446591;
        Mon, 11 May 2020 20:34:06 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b1sm10431174pfi.140.2020.05.11.20.34.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:34:05 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 08/15] net: dsa: sja1105: prepare tagger for
 handling DSA tags and VLAN simultaneously
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <17e1e870-e9ae-1650-ab4d-c042b9d244ab@gmail.com>
Date:   Mon, 11 May 2020 20:34:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-9-olteanv@gmail.com>
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
> In VLAN-unaware mode, sja1105 uses VLAN tags with a custom TPID of
> 0xdadb. While in the yet-to-be introduced best_effort_vlan_filtering
> mode, it needs to work with normal VLAN TPID values.
> 
> A complication arises when we must transmit a VLAN-tagged packet to the
> switch when it's in VLAN-aware mode. We need to construct a packet with
> 2 VLAN tags, and the switch will use the outer header for routing and
> pop it on egress. But sadly, here the 2 hardware generations don't
> behave the same:
> 
> - E/T switches won't pop an ETH_P_8021AD tag on egress, it seems
>   (packets will remain double-tagged).
> - P/Q/R/S switches will drop a packet with 2 ETH_P_8021Q tags (it looks
>   like it tries to prevent VLAN hopping).
> 
> But looks like the reverse is also true:
> 
> - E/T switches have no problem popping the outer tag from packets with
>   2 ETH_P_8021Q tags.
> - P/Q/R/S will have no problem popping a single tag even if that is
>   ETH_P_8021AD.
> 
> So it is clear that if we want the hardware to work with dsa_8021q
> tagging in VLAN-aware mode, we need to send different TPIDs depending on
> revision. Keep that information in priv->info->qinq_tpid.
> 
> The per-port tagger structure will hold an xmit_tpid value that depends
> not only upon the qinq_tpid, but also upon the VLAN awareness state
> itself (in case we must transmit using 0xdadb).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
