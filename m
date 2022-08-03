Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E558588ADE
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbiHCLHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiHCLHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:07:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCF921A2;
        Wed,  3 Aug 2022 04:07:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id uj29so17667891ejc.0;
        Wed, 03 Aug 2022 04:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uJf2Rd5aYjBzLVvZyoKj8ZEt37zTrFyyOUBbDF7qQoQ=;
        b=VRzqAzRkMg1iji03JVVS21GDJcFATk1vNkRcbyyoBTPNets1KqTdCZjrUQjX3dTQRX
         zAEw1RwiUMOz46ZC6lWGu3Vtrnx72ru4RBbgclRXQV1N7JoPlPkEJ177+7tnBN68Bi94
         BLPpcFo3QN55k9frE83NphXOHZo8joIU3RaZdSMxqWgijNrFZU3QkOljOSnbtOLde3sW
         5/oMo410AZA+z/RNxKjqr9zFVjh3mqQlZ57Xcwz0DObTczNeoPhpRHu3xj8XzBaXgm34
         pL1st712o6b7Sn2/wg6JDSd1JE8aVtZu1kr2WxacQ5RLN0mipTCr7c3T5AkHlVS9vovv
         LUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uJf2Rd5aYjBzLVvZyoKj8ZEt37zTrFyyOUBbDF7qQoQ=;
        b=gGB3NTMIpCaUKtFIUTmZpV2rxal88vl3vD7tbrUJyKjIAgTBXiaioewo4P194IXBUP
         P5Zdt33Y93eh3UpcM8fZTj2/2tXk274O4YYUMA4+vDqWnIfd4kZZ1s3rC9rcCePSddlQ
         /t3Vrdpaivx/GyN1f2IU07uX1GoI61vKOGzAPT3syMmOYRLlIjC+/y/bx41fahxNzsMh
         GiIx8SED1SC1IjD6bBlSNzdLfKUoQ5k89F8LrIBSYAsdEQuvb1/CvGMGtPN5jZntTj0L
         /uAQGB4rQA3SgkQVYZMpnAEJbhRMMyRePPiHN7ogSL9Dk2T/PYFZCoimBHA1ryPjIis0
         f+cg==
X-Gm-Message-State: ACgBeo0/huTi/254oAaPFPhrzU4axI5GZY80WRyxa6W6zLL05kCdjaD1
        vta8dG3B/O2TxUVLDGaLty0=
X-Google-Smtp-Source: AA6agR4/sWa0cwLxrpCL0TrsfmDDwzNEIyzON8DHDlaYaUoVEmvRbU7nfHLLBkpGDLG2x2+Qdm0fQg==
X-Received: by 2002:a17:907:d1f:b0:730:95c0:6cbc with SMTP id gn31-20020a1709070d1f00b0073095c06cbcmr8654385ejc.395.1659524846660;
        Wed, 03 Aug 2022 04:07:26 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id g25-20020a170906539900b00730b933410csm292960ejo.145.2022.08.03.04.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 04:07:25 -0700 (PDT)
Date:   Wed, 3 Aug 2022 14:07:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [Patch RFC net-next 2/4] net: dsa: microchip: lan937x: remove
 vlan_filtering_is_global flag
Message-ID: <20220803110723.hym43imgsnnrgdnj@skbuf>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-3-arun.ramadoss@microchip.com>
 <20220729151733.6032-3-arun.ramadoss@microchip.com>
 <20220802104032.7g7jgn6t3xq6tcu5@skbuf>
 <1fe46b15172ff82125c46369d9ed235f67ed5afe.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fe46b15172ff82125c46369d9ed235f67ed5afe.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 04:09:35PM +0000, Arun.Ramadoss@microchip.com wrote:
> I have done some study on this SW_VLAN_ENABLE bit. By default the pvid
> of the port is 1 and vlan port membership (0xNA04) is 0xff. So if the
> bit is 0, then unknown dest addr packets are broadcasted which is the
> default behaviour of switch.
> Now consider when the bit is 1,
> - If the invalid vlan packet is received, then based on drop invalid
> vid or unknown vid forward bit, packets are discarded or forwarded.
> - If the valid vlan packet is received, then broadcast to ports in vlan
> port membership list.
> The port membership register set using the ksz9477_cfg_port_member
> function.
> In summary, I infer that we can enable this bit in the port_setup and
> based on the port membership packets can be forwarded. Is my
> understanding correct?
> Can I remove this patch from this series and submit as the separate
> one?

I'm not sure that the switch's capabilities are quite in line with the
Linux kernel expectations if you always force the 802.1Q VLAN Enable bit
to true.

I am looking at Table 4-8: VLAN forwarding from the KSZ9563 datasheet,
and it says that when the "Unknown VID forward" bit is set and we are in
VLAN enable mode, packets are forwarded to the Unknown VID packet
forward list regardless of ALU match (which is "don't care" in this table).
In essence this is because the switch failed to resolve the unknown VID
to a FID. Other switches have a default FID for this case, but it
doesn't appear to hold true for KSZ.

The last thing you want is for packets under a VLAN-unaware bridge to be
always flooded to the ports in the Unknown VID packet forward list, and
bypass ALU lookups.
