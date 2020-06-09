Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7A51F48E8
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgFIVek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgFIVeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:34:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA724C08C5C2
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 14:34:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i12so1939838pju.3
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 14:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HJ2FmoydfaL6CDGwbH52Ge0Wrl30zawrfmow1nUj2c0=;
        b=O9m+8l7H1EoW8OdCL5uN79CKNtr5vtgiar0rElEwg0GXCXRMa/HpByf5nP6I02kE1x
         HRTZ/aWeF8EkuhsLaUqsZcXBOm0zRzWopDAZ3aMKTgI+Zpu7E5yRdMi891ViTEtGIk+e
         vXgBDm+gEq1gyMFT1zuuVTMpRGm4guxKp1L6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HJ2FmoydfaL6CDGwbH52Ge0Wrl30zawrfmow1nUj2c0=;
        b=jHmjxTdf4hrrGT72MjxDD//eDJn+oVeIT/t9Ls+AlQtn9WV3x0GWuv1uQp4/S9nIyp
         5l5Wzv60GdWgIfcsL4HBTF9NaED7y6q78x1iv9XSzbcFBipMhh0DKrnUxxrhQtx8+6sJ
         z103ijKS3A0e45sSA7ZH7T79zPkInTib07Td98/XoRomxvqJTuMTPYQqRL67EqzfTkP0
         A1fAWj5BXCaAgFlSzLkqMf45wT570j5YM1qO1Ln/0emsL5ts3rJYOh7wAFAK92y7amtd
         jNuxQPvLj2bHQgt//6856KyRtnOWQ5dDGVro2k3444CAsQWcFX2snrmNCaBM7k5OmGBR
         28pQ==
X-Gm-Message-State: AOAM533jvBUCZi8wbIDq65WoWG/OaosWTVRZQ8SA2bcqIyf//HBcNxlf
        F7MNFzfQD6QJfHnk03kmBpEyaw==
X-Google-Smtp-Source: ABdhPJzVdGugeSY+f/v7H2CcczWDHeTj5Wba8lDwrArZhrGFec0z3F0kB6ZTvyimrS+fuO4LK33e/A==
X-Received: by 2002:a17:90a:e2c4:: with SMTP id fr4mr6901141pjb.32.1591738476398;
        Tue, 09 Jun 2020 14:34:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z20sm9280968pgv.52.2020.06.09.14.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 14:34:34 -0700 (PDT)
Date:   Tue, 9 Jun 2020 14:34:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        stephen@networkplumber.org, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, corbet@lwn.net, linville@tuxdriver.com,
        david@protonic.nl, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mkl@pengutronix.de, marex@denx.de, christian.herber@nxp.com,
        amitc@mellanox.com, petrm@mellanox.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <202006091358.6FD35CF@keescook>
References: <202006091222.CB97F743AD@keescook>
 <20200609.123437.1057990370119930723.davem@davemloft.net>
 <202006091244.C8B5F9525@keescook>
 <20200609.130517.1373472507830142138.davem@davemloft.net>
 <202006091312.F91BB4E0CE@keescook>
 <20200609205303.z3kfoptj7w2jpnts@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609205303.z3kfoptj7w2jpnts@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 10:53:03PM +0200, Michal Kubecek wrote:
> The same IMHO holds for your example with register states or names:
> I believe it is highly beneficial to make them consistent with technical
> documentation. There are even cases where we violate kernel coding style
> (e.g. by using camelcase) to match the names from specification.

Yup, when I saw the original patch it wasn't clear this was matching a
spec. I haven't been arguing for the $subject patch since Dave pointed
that out, and am now trying to shape what the general guidance should
be.

-- 
Kees Cook
