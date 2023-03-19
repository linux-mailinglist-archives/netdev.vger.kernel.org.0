Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8636C020F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjCSNeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCSNeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:34:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F221CBDE7;
        Sun, 19 Mar 2023 06:34:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eg48so37106458edb.13;
        Sun, 19 Mar 2023 06:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679232850;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k0vTjG3j694l2irVWvF24VYgMD4LKQ8zKEC4Qg3DHq4=;
        b=l7CwAkbhgoizu+bt23E5cMKYLXwm1bkdP/WBvLEykq5hENjzZbfYjIsj2/14UnuQ6O
         Eeck+bip4IIhlLNQ/PR8Ji53/ntVW9xgU0HggrUqZDy91YYcaEmqEkkdC/0zAsFAqjYf
         OKEznF0mImTBj00gIatnCZkCBM36dxN3VOjXjMHXlXgC45Y6UhmEqowbnMjp8GfKZWHs
         JH56/geV8RwAPTSLYw8CHA46wy15qIe1bVBL5hIpwxLcy+FM0m9CTyIJhDJ4vgV9XJgN
         W0w6OILSb1lPTRM1/lBq9w2Bh8s965jA0miQcX/qm062g5x1FL8a8jlKhM1uXFiGZgyO
         +0BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679232850;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k0vTjG3j694l2irVWvF24VYgMD4LKQ8zKEC4Qg3DHq4=;
        b=QIku+c8rjCR5Ni4wrKj9qtwClvvcfbw/Nrw7yyD1tpf/EnC3gGiaxdl4WKDLxPiQRJ
         QkJu28/oWrYLVMpvoScHm5ioTXYMOeeisUt9BbN/X1lzvnuuN/leZkGk8tP6ePijmrgD
         qjiAKqYDf4n64/r7J3vxr7DepheJ7JmA1GyLupu5GXWMe6tbEJwM6q/1KRBus5CjzEHi
         Ym1aOJdqR8O3iDdTKWz25rQtdP5snLh8uaNzq9EFaW5RW+nrgBYwLRfsu3aQidj0jZy3
         +72noGDZyW2gzz1hktc0SlqQZFU3e0vviAAWb8/9bdvPqN/xGjOWVKyfQw3xioLpACAt
         tVVQ==
X-Gm-Message-State: AO0yUKX/0DD354bojxMWxe4dttAFmiF4Y2l6cXlFs876EvWuXgCBK9iH
        NDBzEmDB7blWcP1XidJ7lF4=
X-Google-Smtp-Source: AK7set+ZVghLMleXY1FP+6FBlRny2uMDAM/DqWk//E8azusj6BxZsd8FPPOWl72nGeQzcQwW1mtODQ==
X-Received: by 2002:aa7:cc14:0:b0:4fb:80cf:89e6 with SMTP id q20-20020aa7cc14000000b004fb80cf89e6mr8661536edt.8.1679232850291;
        Sun, 19 Mar 2023 06:34:10 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q11-20020a1709064c8b00b00932ebffdf4esm2141268eju.214.2023.03.19.06.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 06:34:10 -0700 (PDT)
Date:   Sun, 19 Mar 2023 15:34:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: dsa: mv88e6xxx: mask apparently
 non-existing phys during probing
Message-ID: <20230319133407.xb6k2uxcy52a5pzl@skbuf>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-5-klaus.kudielka@gmail.com>
 <20230319110606.23e30050@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230319110606.23e30050@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 11:06:06AM +0100, Marek Behún wrote:
> > +	bus->phy_mask = GENMASK(31, mv88e6xxx_num_ports(chip));
> 
> shouldnt this be
>   GENMASK(31, mv88e6xxx_num_ports(chip) + chip->info->phy_base_addr) |
>   GENMASK(chip->info->phy_base_addr, 0)
> ?
> Or alternatively
>   ~GENMASK(chip->info->phy_base_addr + mv88e6xxx_num_ports(chip),
>            chip->info->phy_base_addr)

Good point. Would you mind sending a patch? I prefer the second variant BTW.
