Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01E06DD97A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDKLfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDKLfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:35:23 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10240E7A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:35:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id sh8so19435190ejc.10
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681212919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p+w8xJXIlI7Zu0RlE+gH/iZj22rfblX0XI64w4c5cMI=;
        b=FQJb/b7eADQwglz/tz3FBrhq/YD/45aFWAThUUe5zum3xMtek2kGqcE+funfQB4273
         tKDp98tOMIkU7jnIPq7OjkiixiUPTbb3afndngVHD1N/Fyp+RhiYZkviXQMz/doEotEo
         MzyA3U1qXB9bHnRZhsxehaRtrnKghvZbL1+3PeVqFurMFbYx7pabT6rQglhUIGECLdZs
         gu4V9saCGOXArTxn2gfF275398L8BMmQTK0mDyRmNXM7sseODunn0oBs7PdF7uAlIfQ2
         ve0Nk0VM8W4KCMwwCgOd5ntulGyvzy2B665124B2qccYp+4t+X6XFH7K7kHQRe9hl7hb
         aJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681212919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+w8xJXIlI7Zu0RlE+gH/iZj22rfblX0XI64w4c5cMI=;
        b=qkm5lvF9JFutHvo0M/LWADCo/XLYREePJXob42QI0+gempfE6c2RcPX/QqIDgRUVDg
         mPLzI4tITJ9erogElxhKNJUIZG2WJsoQ//0YNHxP2kx56o8g+KAtL3vaHYD/ADcO/Pd5
         fTmTRwRsxHbzwv2CGkbSVWtwOG5y/5xsx4Q4phT7NyV38owNyjVVEzLj4t3x7ELqS1Hp
         ciy5Iee5+akoMdwMMB7egg58+O+PhkNW/NM/U5kWaXFw0AGAbdQnRlaC8glpDJOMdI27
         JyOzInNy4G+Nlczghgb0KJFhrMCCvfFbhNvD3WwIJ0H13ElEHk55E2U+oHVHJAa+NEi5
         nreA==
X-Gm-Message-State: AAQBX9fFA09XudIhVZpBs6/r3nH/lq+uTJ5zGRuMYEmAOJ00/7kzAuqc
        LaBHbl/Budk20l9bwMp9beQ=
X-Google-Smtp-Source: AKy350b3hcW9FKWWcYvsE6VxIdhXokuRwBvqcr4a6yil1sj5mNIxQOTl3XUhxL1ZHq2IS+5ntN7F2Q==
X-Received: by 2002:a17:906:f182:b0:94b:d72:bfa9 with SMTP id gs2-20020a170906f18200b0094b0d72bfa9mr2328208ejb.18.1681212919210;
        Tue, 11 Apr 2023 04:35:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id g19-20020a1709065d1300b00928e0ea53e5sm6015934ejt.84.2023.04.11.04.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:35:19 -0700 (PDT)
Date:   Tue, 11 Apr 2023 14:35:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20230411113516.ez5cm4262ttec2z7@skbuf>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411111609.jhfcvvxbxbkl47ju@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:16:09PM +0300, Vladimir Oltean wrote:
> I may have missed something.

Maybe I'm wrong, but my blind intuition says that when autoneg is
disabled in the integrated PHYs, flow control _is_ by default forced off
per port, unless the "Force Flow Control" bit from Port N Control 2
registers is set. So that can be used to still support:
- ethtool --pause swp0 autoneg off rx on tx on
- ethtool --pause swp0 autoneg off rx off tx off
- ethtool --pause swp0 autoneg on # asymmetric RX/TX combinations depend upon autoneg

I may be wrong; I don't have the hardware and the ethtool pause autoneg
bit is not 100% clear to me.
