Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3A316273
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhBJJhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhBJJfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:35:25 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63A0C06174A
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:33:13 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id i8so2875735ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 01:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wk7YrWlOQA56vJ4RdCSPwxakotHhYG4niWd4UtEagLk=;
        b=l8uPRVCA3/tK6ENQnII9YdwRuCC58ttEhYrMHPK83Bcz+p3fhHPBNW3exR9/OLndRk
         3LHx0oCfcjGsUR6JS3V0Pg9sLHBhnev15MAVWtSgtTdFRiERdv+JXp2uoWXvncXjBvql
         e3Qq1kWDtglcBeEyZNyJ4tyjA82N6c79I+w/LNDVjBcavXs7APRLzwqHYIfFyHqeXIUW
         7wiQjVg2BNe6Nq8FRmW5BpgM9YarVkjuBvhZ2Xh9obBaflcFXw1b3NIAOtUmdU/plp5d
         VkYiwf+IkMlfrnNH0LcXHaXmPrNqxLr+4aifOwz14quW2IFFKdk2EhRddfe2TUP9BX1A
         /5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wk7YrWlOQA56vJ4RdCSPwxakotHhYG4niWd4UtEagLk=;
        b=MXBFxB5ESacyG0BSlndHr2mHVWqOoDU6UYke5WftrvGiIde4npr07hBlg3Sd4mxn4U
         woihTtX56cbToObbjiJ115qVrdJihh2epaeVa18zpUBVW6Po9vggS4Inv0IvjDdrVEv+
         RcIoOIC3WlkXKlaU9DGh4q6ZM28Gtzh4nrc1usEzw/kTFiKW1FNfN781ScAsQkUREpsW
         DP56GBZA3v2XXBu9+uxPA8pc/hbtscR6qZT8YpaM3r0iVIxjSqbeOoLNDTKv/nUGtmsf
         wSdSWiFP5hDKoWDKfs+PiWeO79FfgwmxoNfqnN3ZTUzPnMgJk7+0C4gT4/n9CQZEBgg2
         pj5A==
X-Gm-Message-State: AOAM532uxcllte/c6M0DTpSjMOYOlOHQAnPFNJmPXgsAnf50RoJ8pv+h
        k/tpDduQNQkTkp2wsCts+8E=
X-Google-Smtp-Source: ABdhPJwAncwdcnSQaqDrAdyDzbgcjwVyAQshmTpo3EcaQT4C82AX/KWcJggw0+cD1bVi4+Z1VSnIFw==
X-Received: by 2002:a17:906:85d8:: with SMTP id i24mr2091798ejy.115.1612949592376;
        Wed, 10 Feb 2021 01:33:12 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u9sm724779ejc.57.2021.02.10.01.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 01:33:11 -0800 (PST)
Date:   Wed, 10 Feb 2021 11:33:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] net: hsr: generate supervision frame
 without HSR/PRP tag
Message-ID: <20210210093310.c3el4m57hmso4kya@skbuf>
References: <20210210010213.27553-1-george.mccollister@gmail.com>
 <20210210010213.27553-2-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210010213.27553-2-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 07:02:10PM -0600, George McCollister wrote:
> For a switch to offload insertion of HSR/PRP tags, frames must not be
> sent to the CPU facing switch port with a tag. Generate supervision frames
> (eth type ETH_P_PRP) without HSR v1 (ETH_P_HSR)/PRP tag and rely on
> create_tagged_frame which inserts it later. This will allow skipping the
> tag insertion for all outgoing frames in the future which is required for
> HSR v1/PRP tag insertions to be offloaded.
> 
> HSR v0 supervision frames always contain tag information so insertion of
> the tag can't be offloaded. IEC 62439-3 Ed.2.0 (HSR v1) specifically
> notes that this was changed since v0 to allow offloading.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
