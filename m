Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53B65F328
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbjAERwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbjAERwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:52:11 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2333DBC6;
        Thu,  5 Jan 2023 09:52:10 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id vm8so84843580ejc.2;
        Thu, 05 Jan 2023 09:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Q8126pDSGvuCEqMYoy84PYeUDqUJLUME1x2vTudpWE=;
        b=LcdwexTuYoWDsEu5TPzORLagHmCbLbVknr+mZt6zAbxufyIzuiUYMs/Iij1CeDIa4a
         lMAjH7O2PatCWLThMpZW0bp10fB+5P6riG6d/P/q7T+9tp1b0m4C7uZ/LwfDH6oG8L5P
         BCC3QFknXcJZAFDcTRq8HM/0i5C27SLFjUymUJZ/h3MHgvlakUmlsxe6O1/BLcouzu/k
         8I9PTggOwqDJGM1rsXWm7/SI62dPuaJEHPSPLJab96vEE8z2lFwSPMdnDsa+oIajQw4v
         U/Ukw9drDD/KOaVKhzCbJ8UM/rXVmEL4U5kcnJgFsDI+r4IO/AvtX4DCbh5q1Qmnkdpj
         O0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Q8126pDSGvuCEqMYoy84PYeUDqUJLUME1x2vTudpWE=;
        b=RkTqPbFcpJVuSNZ0lXdBnuVled+sx6QuN5D1nDhY8831PXzygHlnjj27su/MK3FlcN
         aq2lTwXAYaAuliR+UqCRPsjzLavgdFzZ72ZeIVi0LxQ807O+FY2nGmGZ9kxDp1ZqncTP
         hV2b1Gs2UW75Ui9FZwJ1Zr8Rrowe5WugRPu3jdEjxez+0NrlBkIryeB55bI27ggjTT7V
         yN8KRwzaBQytD3GYbD4i4vHDoi/BBMP/LS1ZvfehcUZQydH0JzTLCs8LjcN1/f+Lt+8y
         A8uf4ZHf4g9VjDZeB4rgJInd65yZgcwuM/CIq+v0MBYnWMi5HvXNUFrgdrT6B3tjIr43
         ewuw==
X-Gm-Message-State: AFqh2kqrRGQPYtJoCRJULSPLJ8Bh2ClHcIDoMyGlXSyBhRNuf6frPBcm
        uapdqTGrHRpZG2ni7G3ER8w=
X-Google-Smtp-Source: AMrXdXuVCSHBhzySjuaWwhzE/NEvXTuhtDhz+GAG/KX8bxsRZYIBhJvhsQYHluevTXj+CcAojl4fNw==
X-Received: by 2002:a17:907:8b11:b0:81b:fbff:a7cc with SMTP id sz17-20020a1709078b1100b0081bfbffa7ccmr44479771ejc.18.1672941129118;
        Thu, 05 Jan 2023 09:52:09 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id w15-20020a170906d20f00b007bf988ce9f7sm16612184ejz.38.2023.01.05.09.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 09:52:08 -0800 (PST)
Date:   Thu, 5 Jan 2023 19:52:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230105175206.h3nmvccnzml2xa5d@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3919acb9-04bb-0ca0-07b9-45e96c4dad10@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 12:43:47PM -0500, Sean Anderson wrote:
> Again, this is to comply with the existing API assumptions. The current
> code is buggy. Of course, another way around this is to modify the API.
> I have chosen this route because I don't have a situation like you
> described. But if support for that is important to you, I encourage you
> to refactor things.

I don't think I'm aware of a practical situation like that either.
I remember seeing some S32G boards with Aquantia PHYs which use 2500BASE-X
for 2.5G and SGMII for <=1G, but that's about it in terms of protocol switching.
As for Layerscape boards, SERDES protocol switching is a very new concept there,
so they're all going to be provisioned for PAUSE all the way down
(or USXGMII, where that is available).

I just pointed this out because it jumped out to me. I don't have
something against this patch getting accepted as it is.
