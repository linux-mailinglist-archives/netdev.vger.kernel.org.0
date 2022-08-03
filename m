Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780A2589010
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 18:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbiHCQTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 12:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiHCQTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 12:19:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1343220E3
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 09:19:45 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w17-20020a17090a8a1100b001f326c73df6so2531250pjn.3
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 09:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oXQ440FXmy/Gwq99YnhUThvtft4aYMka/KTTaLZzEJU=;
        b=gYEm7uqP6VfidT4Ff6FDlw+msDMhCDyyWzDZjOer/EccIG13TtMSEas+UfRK5qmlM8
         KdZiXk49NFGi68uLGAvP3/PqNIpr5ckPOEoxbskwoc2KhQtQ9Sf93/mNd4UMHkh2yr42
         c3ww1yvmedqkwfeyrZeEBSyMSuyT+0T41LIKj2xVHPLu1GqCaEIaOFV9D3PsL0ELYV6q
         MuijGg5L3LS8Gx6anTd0MTj9/eJLvKeJi7SoxPb9lye/kuPGLjBq8v00vntwn0i7b9SZ
         uid4vBCn21+lPN1ElLG28StqBdZ9XlzXeyiUGCyoSnuqSc/Fg5s4sYQyeeZ4SOUf8wtQ
         DxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oXQ440FXmy/Gwq99YnhUThvtft4aYMka/KTTaLZzEJU=;
        b=BLr1lj8d8/M7sgt5cKnmcPvcDdc2n8AOb4Stk9FaGSWFw5PDuUyUY7JKj3155G44LL
         oOr7Y0Jb6D5LolEMdGA54hgnzDKGP7b1cEClbXWErWvwWTtZSvwcGp4ZEYppmw42KTIR
         2Q4AAEnzlLk4xvkJDrH8kSqQh3yVGHJZ1x6kCp1suN+m/yFr+hpJZITt+wQd7LJEx5CE
         WlMSbqXaZFe+CGf9Adjinrj410B5mz4DjM02oYc2rJBxpI73qyKzXpD8xxx73i5e82ky
         r4ait96K5JT1SLcv9kjZu/ffXnLtd68vOgg0RGyvGi2zmBcgR2KOY6iwuc9kBMxqc+Vi
         qr0g==
X-Gm-Message-State: ACgBeo3k3XFsAWezlhHPDcqtio1IoDfwrHuzAPb3FqZipFilmtF3exz6
        u3KM0MtMWHjjy44Y6gTEjsdLne1qnetHTrgE
X-Google-Smtp-Source: AA6agR61wRzXNNGPJs88tcIdguv5lAyEORcdwzQOyySCwMrI9SsSwQMeusPW0am6tQRMy7v+lHCF0w==
X-Received: by 2002:a17:902:dac5:b0:16f:63c:3e91 with SMTP id q5-20020a170902dac500b0016f063c3e91mr8088641plx.169.1659543585422;
        Wed, 03 Aug 2022 09:19:45 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b1-20020a170903228100b0016dbb878f8asm2166097plh.82.2022.08.03.09.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:19:44 -0700 (PDT)
Date:   Wed, 3 Aug 2022 09:19:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload
 (ovpn-dco)
Message-ID: <20220803091942.0e388f5b@hermes.local>
In-Reply-To: <1219c53f-362e-cd55-73e0-87dfe281ec34@openvpn.net>
References: <20220719014704.21346-1-antonio@openvpn.net>
        <20220719014704.21346-2-antonio@openvpn.net>
        <YtbNBUZ0Kz7pgmWK@lunn.ch>
        <c490b87c-085b-baca-b7e4-c67a3ee2c25e@openvpn.net>
        <YuKKJxSFOgOL836y@lunn.ch>
        <52b9d7c9-9f7c-788e-2327-33af63b9c748@openvpn.net>
        <20220803084202.4e249bdb@hermes.local>
        <1219c53f-362e-cd55-73e0-87dfe281ec34@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Aug 2022 17:48:45 +0200
Antonio Quartulli <antonio@openvpn.net> wrote:

> There must have been some confusion - sorry about that.
> 
> The repository I linked in my previous email is this very same driver 
> packaged as "out-of-tree" module (i.e. for people running a kernel that 
> does not yet ship ovpn-dco) and contains some compat wrapper.
> 
> 
> The driver I have submitted to the list is 100% standalone and does not 
> contain any compat code.
> 
> 
> The only extra component required to do something useful with this 
> driver is the OpenVPN software in userspace.


Good to here thanks.
I wonder if there is any chance of having multiple VPN projects
using same infrastructure. There seems to be some parallel effort
in L2TP, OpenVPN, etc.
