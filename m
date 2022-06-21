Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E430553094
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349115AbiFULSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349157AbiFULSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:18:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836BD2A247;
        Tue, 21 Jun 2022 04:18:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id fd6so16132670edb.5;
        Tue, 21 Jun 2022 04:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L9lgkyEP/oepVJZZz+PCpzPR1E8oPBIChmkEwdJMXWU=;
        b=hVvHCTIauVfCWBF/tqmtHAVRCwQ6cxD3p1dR+ufgo44zHduV2WYiG7AE1g4j2S3NNi
         sYx9OMWlqbSBNkTsWoOJOBX/DBfLRsafW9WsPrgpW+ee3ZAi2DFhRHTmiETF+boGiVkO
         q4OUn8GiHry1xmnlTTHAyhyVdx5ijZSe/lv6RdjsuwzMeDyyjqigArf71msMGEkDu56t
         hmDHqRtIMgkF5LZ9SfQhSa4fHxNns53LM6Pc3P5wMyLOfLLWIpN5XRH0FepQRE7mFjbN
         BlKlvJbr+ya2sBaEdmwlsS5Ldn+UqNGhzjg7P2lGWaCdqcPAjtXf+34BFKU/UXe8ei2w
         fKJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L9lgkyEP/oepVJZZz+PCpzPR1E8oPBIChmkEwdJMXWU=;
        b=HiP1gABcZawmMJIUiO6s5Kui1V7kdtQ/KzBp79vHKlURGjlWp6rkoC9etOL6/oyiH4
         IiBd9M1O+K0iruS/gojhJRKZy8B0cVtDrs6yfxK78HturkpQqzgGOICsw7dHIVaHyU7E
         FSgusJwc3tbz8lovXAVEVlkcp+w9hrwhKv5X9xPho/xtbfJllkLGoGVywQVeJa3fNbuu
         44DD6q4t8WacGEHb+79dxtv38CxSnoc1NNFzQp4i/0x5nVhYP+H9SFAVlaEWrMQGSX1p
         O6mCW9eYkm6vYfHwUlu3XiH+xqngJ0R81rB9Atd+S4BN7W+YY/fTBq5o8UXg41Xf6m9L
         PFnA==
X-Gm-Message-State: AJIora+pmli7N8/tvGNVYX/x2zSj0HeT2rkJDH8v362kc3ZlayLSPfCC
        /MrCfFVh8sm7cnnrup1XKrg=
X-Google-Smtp-Source: AGRyM1tBYIl9MnvxC5leWSGo6eqMFLA3Ip9xVYsSj6hwIZzvujdmG0uEEviJvyMUAcQ2I0SELDMzFA==
X-Received: by 2002:a05:6402:403:b0:434:eb49:218f with SMTP id q3-20020a056402040300b00434eb49218fmr35193587edv.426.1655810314390;
        Tue, 21 Jun 2022 04:18:34 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906219100b007105a157706sm7448284eju.82.2022.06.21.04.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 04:18:33 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:18:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [Patch net-next 00/11] net: dsa: microchip: common spi probe for
 the ksz series switches - part 1
Message-ID: <20220621111832.pdpodpc4q2wczom6@skbuf>
References: <20220617084255.19376-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617084255.19376-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 02:12:44PM +0530, Arun Ramadoss wrote:
> This patch series aims to refactor the ksz_switch_register routine to have the
> common flow for the ksz series switch. At present ksz8795.c & ksz9477.c have
> its own dsa_switch_ops and switch detect functionality.
> In ksz_switch_register, ksz_dev_ops is assigned based on the function parameter
> passed by the individual ksz8/ksz9477 switch register function. And then switch
> detect is performed based on the ksz_dev_ops.detect hook.  This patch modifies
> the ksz_switch_register such a way that switch detect is performed first, based
> on the chip ksz_dev_ops is assigned to ksz_device structure. It ensures the
> common flow for the existing as well as LAN937x switches.
> In the next series of patch, it will move ksz_dsa_ops and dsa_switch_ops
> from ksz8795.c and ksz9477.c to ksz_common.c and have the common spi
> probe all the ksz based switches.
> 
> Changes in v1
> - Splitted the patch series into two.
> - Replaced all occurrence of REG_PORT_STATUS_0 and PORT_FIBER_MODE to
>   KSZ8_PORT_STATUS_0 and KSZ8_PORT_FIBER_MODE.
> - Separated the tag protocol and phy read/write patch into two.
> - Assigned the DSA_TAG_PROTO_NONE as the default value for get_tag_protocol hook.
> - Reduced the indentation level by using the if(!dev->dev_ops->mirror_add).
> - Added the stp_ctrl_reg as a member in ksz_chip_data and removed the member
>   in ksz_dev_ops.
> - Removed the r_dyn_mac_table, r_sta_mac_table and w_sta_mac_table from the
>   ksz_dev_ops since it is used only in the ksz8795.c.
> 
> Changes in RFC v2
> - Fixed the compilation issue.
> - Reduced the patch set to 15.

For the series:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
