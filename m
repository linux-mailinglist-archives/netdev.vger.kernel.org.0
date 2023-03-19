Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490566C03A2
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCSRyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 13:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCSRyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 13:54:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0BB1E1C7
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 10:53:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eg48so38474456edb.13
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679248431;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4Kv7QFZVr9U316OD2g+tbPZSYZoVvPpFVY1APefpXwE=;
        b=MvSRuyJ2RkkIRIJi0nZIvVIxZfmUxS3J4j5Fz1pZmDUBQIuZqA1L5Zi2wxkMsbh1Up
         nkNqszWEHFoFgKtZeSdQp0Of5IrWeWiGhf/qJKyttLsq0OeaOk7mzzPohOXWYyZqZ3T+
         +099+SI2mh5MXoYk+0/GMuomFFuaITsNJaA0nSB2pEjmlKZCliyIMxY3JV50dMipFsjc
         7JVR14DwtUsoWU9EJly5U/ZSMTWr4kd1xFhYhxBOLEcBMmrq2J/hsuqUNqtKJuzO5/ug
         F2L/RXFQOzTvXwFSp2ovrLy7QSUwIAvkqefhqTpeak9n62iya5NII8/YzATjA4V2fcmM
         gvcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679248431;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Kv7QFZVr9U316OD2g+tbPZSYZoVvPpFVY1APefpXwE=;
        b=WZ54OKFavFZyjqxz/JRx+P4eoMFLAIC5UF1ioMF7k+d1EmscwPvvdfNKOkh+Ov39dK
         PRJVjTlg1ivfTVz5s+OzpH2CSqXbI4bH6aLQEmYW+FLCoVHf4kk7f657Vg54XFS8cU1+
         e6EAvV8yoSh97N3evkX+IjiXgqXCC4lj+4r2ntnjVi27TLiQi3uXGXJnQUo2v4lAJvfj
         pdZtASoX4fYXuQfYmZDPxGZxJvCMhAX3rHfYX/tlgry3JGz9dcXWVwh9Qijmtc8qBD3k
         4lA9mlYQs9105GDsgmog7g7tqjnx/MKq0oUA0Hp9hbqgF9GtszdFWcE3nyQNoZmvZ+V7
         NbeA==
X-Gm-Message-State: AO0yUKVjzxHRFl17PBoin1QfEM83TRMw769I7I6jjdJseOH/DOkp7EcI
        co5lemUucjU8WwC1d+51lG0=
X-Google-Smtp-Source: AK7set+xxVi091f0hw76LgO4MPBHAptOBUkm9ehl/Y/s0Q/S0OWSglg/jJDocKKluKjzf1gCLPtSzA==
X-Received: by 2002:a17:906:1906:b0:925:1d1d:6825 with SMTP id a6-20020a170906190600b009251d1d6825mr6742505eje.42.1679248430632;
        Sun, 19 Mar 2023 10:53:50 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ha25-20020a170906a89900b00934212e973esm603854ejb.198.2023.03.19.10.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 10:53:50 -0700 (PDT)
Date:   Sun, 19 Mar 2023 19:53:48 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Klaus Kudielka <klaus.kudielka@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix mdio bus' phy_mask
 member
Message-ID: <20230319175348.lg6is633myxotqgs@skbuf>
References: <20230319140238.9470-1-kabel@kernel.org>
 <20230319140238.9470-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230319140238.9470-1-kabel@kernel.org>
 <20230319140238.9470-1-kabel@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 03:02:38PM +0100, Marek Behún wrote:
> Commit 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing
> phys during probing") added non-trivial bus->phy_mask in
> mv88e6xxx_mdio_register() in order to avoid excessive mdio bus
> transactions during probing.
> 
> But the mask is incorrect for switches with non-zero phy_base_addr (such
> as 88E6341).
> 
> Fix this.
> 
> Fixes: 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing phys during probing")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> I was unable to test this now, so this change needs testing.

You should be able to test it if you remove the phy-handles and the mdio
subnode from the device tree.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
