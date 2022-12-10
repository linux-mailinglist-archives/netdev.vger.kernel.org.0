Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D336648B86
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLJAGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJAGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:06:02 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17903747E3
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:06:02 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id x28so4916762qtv.13
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 16:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6mTmyfu7f8hfKlf2DmFuM0mcl9VnAeJQ+G4/U1c7E1A=;
        b=CGq/GSKoDnVWd6pU8fe13uQMYANKphpz6vI/FrBVrpaF2FI+SpHeSqW/fr7LkGt1fc
         fmj/5F7Qjjzi18Pa2cqE4DGrTy3fU9giofAmOcy3g4fB2xnmkh3GHdxgPIyK6InrmMvP
         m9lbWddF5M/9r0YaOEw5QcQ+3tayIQdWOfT2IIwfhM1C9HfG44Aan0JmrQuL9S1o9PBn
         56Tig4AF5jAITUSnbKUS4OOqfltrAV9GG1h3bhwIlLbPVwMmT0oB5BsoTVeBzP9s6FIJ
         gcVKS7QIFpo6BwopKcdziyQqPd/XAyT8RxsuJLdIDmR3/5Dur5u68Hx/PUm1MVLT3egm
         R9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6mTmyfu7f8hfKlf2DmFuM0mcl9VnAeJQ+G4/U1c7E1A=;
        b=kZ7SeFXTNYbmAUh5ITyl/2FAA+qwRUayzq6uZfFYvBVLQkUV5LJxdQGwJuLbEh/yrX
         v73+w6dMpetdmL7NRqAFOqHfJd71Ctbcr79vDUW/Hp3PsWfMI3Ym2UVIc0yq7HHVFzpA
         qg+jzLAaPedsyRlWxBPSgJNF+yvc4kVRegBQF+6zzF6DYH28uRbaQP7gQAi9dckuhHlx
         qQjLiIz7i7AoD++wh53sobo7D9yARaUJGhdy/ZuHjOnlgeSmp2aGi2xlIjLj71blmVKz
         kTFmQ7Wy5FzyJhwwdsyP/G6JeBs8bpE35g71ltUKa2rgFpXsIWG5pYSw3cVe6adIReEJ
         PVGw==
X-Gm-Message-State: ANoB5pmKuRnhxDwOm7Kc95xOzn5tqFzYW+c1nygkaUu/Gmhc/i8sfgU+
        u6Hp66GpaOEWlpo4uZEpZ0U=
X-Google-Smtp-Source: AA0mqf7uFoiOYAxJaQbFH5s+NmKOTFgkeQTi+dzRcQO55nTe+rCQrcUZKTtyYgzK9Dt7hH/rvCmlng==
X-Received: by 2002:a05:622a:6112:b0:3a6:9c36:e3b1 with SMTP id hg18-20020a05622a611200b003a69c36e3b1mr9914375qtb.42.1670630761108;
        Fri, 09 Dec 2022 16:06:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bs33-20020a05620a472100b006b61b2cb1d2sm982317qkb.46.2022.12.09.16.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:06:00 -0800 (PST)
Message-ID: <5e2c5dd0-4785-fa9f-205a-8dcf543e27ae@gmail.com>
Date:   Fri, 9 Dec 2022 16:05:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: mv88e6xxx: read FID when
 handling ATU violations
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209172817.371434-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/22 09:28, Vladimir Oltean wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
> 
> When an ATU violation occurs, the switch uses the ATU FID register to
> report the FID of the MAC address that incurred the violation. It would
> be good for the driver to know the FID value for purposes such as
> logging and CPU-based authentication.
> 
> Up until now, the driver has been calling the mv88e6xxx_g1_atu_op()
> function to read ATU violations, but that doesn't do exactly what we
> want, namely it calls mv88e6xxx_g1_atu_fid_write() with FID 0.
> (side note, the documentation for the ATU Get/Clear Violation command
> says that writes to the ATU FID register have no effect before the
> operation starts, it's only that we disregard the value that this
> register provides once the operation completes)
> 
> So mv88e6xxx_g1_atu_fid_write() is not what we want, but rather
> mv88e6xxx_g1_atu_fid_read(). However, the latter doesn't exist, we need
> to write it.
> 
> The remainder of mv88e6xxx_g1_atu_op() except for
> mv88e6xxx_g1_atu_fid_write() is still needed, namely to send a
> GET_CLR_VIOLATION command to the ATU. In principle we could have still
> kept calling mv88e6xxx_g1_atu_op(), but the MDIO writes to the ATU FID
> register are pointless, but in the interest of doing less CPU work per
> interrupt, write a new function called mv88e6xxx_g1_read_atu_violation()
> and call it.
> 
> The FID will be the port default FID as set by mv88e6xxx_port_set_fid()
> if the VID from the packet cannot be found in the VTU. Otherwise it is
> the FID derived from the VTU entry associated with that VID.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

