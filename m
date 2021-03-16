Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB42133D070
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhCPJUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbhCPJTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:19:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA377C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:19:53 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ci14so70746123ejc.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oMt3kR43rls6Hn4BzF3uRTkxYhjqyJVFUMWggQbAskI=;
        b=a1eGNru9mAQRlgN2FE3OPZMyS9SfbPuKeCcrNvzE3KZOm28RqwQZWkTnaM2nxgh2PI
         c0dB7a6LWtleR5sUryW30yd0eg205Yjf7YHimrwByT0xwG6jwt6COurJdsHkhVvMGHfs
         mPtTnZr/MQxBr7cU9NSTIBlypvK/19iHlidai0fFSfrCEz0C4GDJ1NpRXh1fZVLKLYfG
         fGXI8tohDLHVebkLXLlbJ5Sp6uDpTfeqLUhHDysplzhSPTGHPH0iV0zNpieK5SF1jgRr
         668EUvpU1EXyk4Ouq50O/rgrV8Y5pcSzjKMnp+Ky10iXNVXc5rjRaeFuLaHpqjpUGVyz
         mhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oMt3kR43rls6Hn4BzF3uRTkxYhjqyJVFUMWggQbAskI=;
        b=YcS1A6ihKnU+VOJuasS3xXLMzpxNnXpIP+20cLeuixQtYmjocT8YKl8mRFilb0IHB2
         mZIw5KDmtDpZ0Q9quO39h+mFcLk1kbIusVatqYd66uMTtPqHSa9fDZfTcJ/NdjGVnwyg
         Mp+a3t7aBHesm6rt1nt0wEj75FvgKSuC4grhpLqwHBPaGWDaf1FrnYllhRCZpTxP4SVa
         Kd3BEiiX143PsyAX/UZ908K3SYuwvFlJCB66ZMX+IoBr6YkbgLxFxl2ZiDJRc359kdt2
         l9N++oRlg4q9GGBoBPuNMYDnOU2dNOWBJQQ7lDJnufbzxl3A/13ttoGUbpU7lvncN77Y
         dyIQ==
X-Gm-Message-State: AOAM533wI/p5jy+D/cN+OlS34Sdj3uqliL0gnSxTJYtulCxoEohaem3K
        CdNCok6cWuGdo1zPbqDzjHQ=
X-Google-Smtp-Source: ABdhPJzHzIvqTiz4+f1oZ5WeDVObMDZLSFrF2CvP15O/KpU8+QfqjC9h79k3305AXkKkpKuBgDQyQw==
X-Received: by 2002:a17:907:76b6:: with SMTP id jw22mr28370775ejc.11.1615886392434;
        Tue, 16 Mar 2021 02:19:52 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 11sm8783939ejv.101.2021.03.16.02.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 02:19:52 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:19:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Flood all traffic
 classes on standalone ports
Message-ID: <20210316091951.7pdjur7gy52ebwid@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:13:58PM +0100, Tobias Waldekranz wrote:
> In accordance with the comment in dsa_port_bridge_leave, standalone
> ports shall be configured to flood all types of traffic. This change
> aligns the mv88e6xxx driver with that policy.
> 
> Previously a standalone port would initially not egress any unknown
> traffic, but after joining and then leaving a bridge, it would.
> 
> This does not matter that much since we only ever send FROM_CPUs on
> standalone ports, but it seems prudent to make sure that the initial
> values match those that are applied after a bridging/unbridging cycle.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
