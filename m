Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3E6639129
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 22:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKYVkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 16:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiKYVkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 16:40:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3243856D73;
        Fri, 25 Nov 2022 13:40:38 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s5so7890912edc.12;
        Fri, 25 Nov 2022 13:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XNaBZL9MZcNCqmZkqv11ka/Dn7mF7OI5C41Pu9xMYMc=;
        b=Y1HHq96UL1l3km0QQ//mHoLkIj8zeIaokUq55LGm5aYacRK/f+Gh/vkQQVXEWA164Y
         DJ6bY+pkFMb2kA+NW+moKK/PQ+Izz4Fjo4p+nneW8bUZyiCW12XjqRha1wROKmfUJRfS
         aBjwfFg+7yzn/cNVL9HLBFjX1mL6horPpP19hv9sNCHSqpflr90pLnyh8HfDi8C2/lA8
         0MDrAckm3UdXsTWh8gulTHtPQAi1n485yq10KVPoiXeDxPHREy+QlFZnLZsKFqrXDcuf
         7WUlBbbyTudbw3cU6D2LhxptlQ9jRZIRQBbL57C7Kz8xf6/hBtgASPuXWbxumTMVWOM3
         U2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNaBZL9MZcNCqmZkqv11ka/Dn7mF7OI5C41Pu9xMYMc=;
        b=iy+TT4GXHDUKvAkCcy/sbsiEDDIgP7Bft3LzPdVSXrX9efYWmsOakCjnuBei2sMk4L
         BvtJbHJYFvyzHQsdYsAldi9GBqNEWpw+YIRAGsYUsau/K4wPUh1mxGFonf4pzjAXkW3A
         exGXhLm7cx9O+xexznjFq/kVwc85BeZBi/wstVfpzEZ/6lemALJUATh97YXTxC3yUZv+
         3+bTkuDx7Y+zJPfvYaPUi/q8oF1BckKt1ZAkCAesJSm6qFuR0U2n/LfkV6h5BBv/jVuo
         uIjpK1zKDyNu5ag/0Pj0FqHLWRpsG4niVmsmCKPzLDlEMD2Yl1Ry9PjHY92kJWTKiS0e
         GOaw==
X-Gm-Message-State: ANoB5pm9R2m0s2/5zXtx03m4LEM078T2Gqw5Zbw7dZ0ahZ8IC/Xib0UW
        fJpZ3stLW1jOBXpgBL+yDdM=
X-Google-Smtp-Source: AA0mqf5SJQvKlEEsURWR5hTwCO8Go6GPXa3mG5GlT1yf3i6DYN/S13e9NX0LMtaMSLLytHsaJAWejQ==
X-Received: by 2002:a05:6402:1118:b0:467:a8cb:10c9 with SMTP id u24-20020a056402111800b00467a8cb10c9mr22525201edv.123.1669412436635;
        Fri, 25 Nov 2022 13:40:36 -0800 (PST)
Received: from skbuf ([188.26.57.184])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709061db100b0078128c89439sm1986388ejh.6.2022.11.25.13.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 13:40:36 -0800 (PST)
Date:   Fri, 25 Nov 2022 23:40:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Message-ID: <20221125214033.mb67ozczo7th6vi3@skbuf>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
 <20221121154150.9573-4-arun.ramadoss@microchip.com>
 <20221121231314.kabhej6ae6bl3qtj@skbuf>
 <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
 <20221124102221.2xldwevfmjbekx43@skbuf>
 <0d7df00d4c3a5228571fd408ea7ca3d71885bf6f.camel@microchip.com>
 <20221124141456.ruxxiu7bfmsihz35@skbuf>
 <4b2408602ce29c421250102c5165564d7dafda77.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b2408602ce29c421250102c5165564d7dafda77.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 07:06:07AM +0000, Arun.Ramadoss@microchip.com wrote:
> KSZ switches need a additional 4 bytes in tail tag if the PTP is
> enabled in hardware. If the PTP is enabled and if we didn't add 4
> additional bytes in the tail tag then packets are corrupted.
> 
> Tristram explained this in the patch conversation
> 
> https://lore.kernel.org/netdev/20201118203013.5077-1-ceggers@arri.de/T/#mb3eba4918bda351a405168e7a2140d29262f4c63
> 
> I did the follwing experiment today, 
> * Removed the ptp time stamp check in tag_ksz.c. In the ksz_xmit
> function, 4 additional bytes are added only if KSZ_SKB_CB->ts_en bit is
> set.
> * Setup the board, ping two boards. Ping is successful.
> * Run the ptpl in the background
> * Now if I run the ping, ping is not successful. And also in the ptp4l
> log message it shows as bad message received.
> 
> We need a mechanism to inform tag_ksz.c to add 4 additional bytes in
> tail_tag for all the packets if the ptp is enabled in the hardware.

Ok. The code + comments need to be sufficiently self-explanatory that
this question does not get asked again. It will not be trivial to do a
proper job documenting the hardware oddities as a justification for the
software workarounds, but it should be possible.
