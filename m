Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C8B6D6192
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbjDDMua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbjDDMu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:50:28 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC7A3586;
        Tue,  4 Apr 2023 05:50:06 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eh3so130068908edb.11;
        Tue, 04 Apr 2023 05:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q9UAqvcFvz/sWVmZYlVN5O/yWVAbkblIyFFBAsNOA0M=;
        b=M+95vOMWjFBNFCT/QpUR67JJHOM4h1jOcDIy3Idnzp54hSJP8Lji0NWHuNAy3tTIwZ
         +qoNN8VIrOqjQX70SouA8Vi7S5PUmtwTletEJ4Ur6Tlt+1V8BG6h9SS7jJ3uJNh+sjEu
         Lidz82cVpvcDHJVQVToTc0+5dybzkRrpVFZLl5aCyIAQoKW/+VQltMmJSWJKu6LiBozF
         GNjSnkc/8NToUCoDO8noL4TrIPgjxHZ7ufsp1/CkAv4Z4B/4CCZzwap3UYRkyYByNQWC
         +/xYe/Vilp4d4/ZdDbyLY7Q1botdPStMxKTCnsiHU18Ja7TDgnP7GYpEA1Qbe6L0u43S
         i0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9UAqvcFvz/sWVmZYlVN5O/yWVAbkblIyFFBAsNOA0M=;
        b=kayXuFYiZ994IM1yPFVxNbYXHLmozT2kcxd/LTmvOb2HqgnZrKU7Lbx/qqs1ugnc8V
         elWxZY3Pz3Q/Hw9p0bDQFFpYh5GYQn1TzrQkoU1Soe0PFXII4TJv9MNOamb6ZYkSdOvE
         KzUnXW3jo4WFtWZgMb60hlhJTfV3z125JsM6M8iWQrKHBzUJV4Ro/79E8CvxlJkAGdXw
         c3yjxA5AhBxlOtq9A1dghDMq4nQHYsByITfxMBizXfqyg72ZZdtJx+b7vF5aJfWILvjb
         WPt9rqQlE6Cjtx5IplyqNsknHbhuxA3BEvWj3BWZjnv+dv9vEBk8Aqa2xBYnkistuxZR
         YlMw==
X-Gm-Message-State: AAQBX9ewc8q++FF3dH5jEnCF1AGcaQ8jCExhgrLWXhMATQa5PlcGaopE
        Jm5+zdP029khexZRDwCyew0=
X-Google-Smtp-Source: AKy350ZrsLtgeonpBB6lA1YXQgD825M8m8gdRc+yLFzFfDgvjO35gwA/EEDogcdnVWzALEVTvzaYHQ==
X-Received: by 2002:a17:906:4e09:b0:947:6fae:5d27 with SMTP id z9-20020a1709064e0900b009476fae5d27mr2159325eju.56.1680612604523;
        Tue, 04 Apr 2023 05:50:04 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id bv20-20020a170906b1d400b009447277c2aasm5933902ejb.39.2023.04.04.05.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:50:04 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:50:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/7] net: dsa: microchip: ksz8: Implement
 add/del_fdb and use static MAC table operations
Message-ID: <20230404125002.dv2f4foojhy43dkx@skbuf>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404113124.nokweynmxtj3yqgt@skbuf>
 <20230404121911.GA4044@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404121911.GA4044@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 02:19:11PM +0200, Oleksij Rempel wrote:
> If I compare KSZ879CLX and KSZ8873MLL datasheets, i do not see direct
> answer. The only reason I can imagine is the size of static MAC table.
> All KSZ88xx and KSZ87xx variants have only 8 entries. One is already
> used for STP (even if STP is not enabled, can be optimized). If
> BRIDGE_VLAN compiled, each local address will be configured 2 times.
> So, depending on system configuration the static MAC table will full
> very soon.

Yikes. KSZ8765 has num_statics = 8 and port_cnt = 5 (so 4 user ports I
assume). So if all 4 user ports had their own MAC address, it would
simply not be possible to put them under a VLAN-aware bridge, since that
would consume 2 BR_FDB_LOCAL entries for each port, so the static MAC
table would be full even without taking the bridge's MAC address into
consideration.

Even with CONFIG_BRIDGE_VLAN_FILTERING turned off or with the bridge
option vlan_default_pvid = 0, this would still consume 4 BR_FDB_LOCAL
entries + one for the bridge's MAC address + 1 for STP, leaving only 2
entries usable for *both* bridge fdb, *and* bridge mdb.

I haven't opened the datasheets of these chips. Is it possible to use
the dynamic MAC table to store static(-ish) entries?
