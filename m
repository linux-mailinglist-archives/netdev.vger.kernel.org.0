Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2794362C3
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhJUNYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhJUNYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 09:24:50 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16235C0613B9
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 06:22:35 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c28so386844qtv.11
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 06:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CrP/fHBeghkN2M8wwHrJYbzX7OVReJiYD+kE4TtwTf4=;
        b=Q99CuhoJ5hRLi1bSEhJMg9kqxrjPhKai0eDRt85SpsAp2k+97XTVnVSzJQUYaYfeI3
         7sREufTLC1uhl2NhkyTlN7/Qa/UAmDfzx2Y1259uSiEbZseXTyyk2u6gWMC/5i5mMntu
         nNR3y/FrujPXvvyyAlXN7olqS75lTbcmTn5xzxpqfg3oDTVSnF+lvkEJg96bJZ5LHpmM
         mpeITJ8WI6gwa2sECIKO00t7oQqEz2PsruAMYXP6yaOu9oFHZMmxApjMZmDzBUd+zw/u
         Aoih3qfbGwT5sGwVtH4thAfIOq1x5hbrUrf+cbUWz6/bgTRCxKSOLPGXxLHbaD0lz3gn
         XWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CrP/fHBeghkN2M8wwHrJYbzX7OVReJiYD+kE4TtwTf4=;
        b=7i0UJld0G72CjgPuK/J5/acKFmCHH1s4/6ZZk4Mz4bHwe8XPqThq0Bel5j8C00Ozip
         xafP8AGGEMlK8P0HHSsknzU5TmghRcl5I8/IDSf1eRLc35o+3nxGLkzICDuALwbXZulD
         e9UNn9VLPov95aR+yso4pi04dh6Z/vu/BDplW+7SWumd0rLJOxWoq5hsf2uioORVSvIp
         h3SymMLjz0QvXsczcV5KbsCXGaQjI8iqmcUGPN0fp6Zh5AEcfxJolUljy2NWjRLeqioO
         EL4xDH+1N5BOv1ujjIAbanz+ITjQXc22/t3IL8cdeVvSxefdCRSTv92b0PteTr9aWTzi
         h10A==
X-Gm-Message-State: AOAM531JqgnLWCM4UY/rOwJP1jpipqiDCn/BUvzKcR8zJu4ykqlnXkaw
        CLzSonDJai+QxOaiwDDMIg==
X-Google-Smtp-Source: ABdhPJxMx8g5D906SPENxT3g0vTniC5DFKBMmzCkvdAM/RmNEaIJ/GcHmf6xrsoanDjgVgqP2EXZkg==
X-Received: by 2002:ac8:614b:: with SMTP id d11mr5817348qtm.396.1634822554262;
        Thu, 21 Oct 2021 06:22:34 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id f42sm2619213qtb.7.2021.10.21.06.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 06:22:33 -0700 (PDT)
Date:   Thu, 21 Oct 2021 09:22:29 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Antonio Quartulli <a@unstable.cc>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] gre/sit: Don't generate link-local addr if
 addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
Message-ID: <20211021132229.GA6483@ICIPI.localdomain>
References: <20211020200618.467342-1-ssuryaextr@gmail.com>
 <9bd488de-f675-d879-97aa-d27948494ed1@unstable.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd488de-f675-d879-97aa-d27948494ed1@unstable.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 02:52:44PM +0200, Antonio Quartulli wrote:
> 
> Maybe I am missing something, but why checking the mode only for
> pointtopoint? If mode is NONE shouldn't this routine just abort
> regardless of the interface setup?
> 
If it isn't pointtopoint, the function sets up IPv4-compatible IPv6
address, i.e. non link-local (FE80::). addr_gen_mode NONE (1) is only
controlling the generation of link-local address. Quoting from the
sysctl doc:

addr_gen_mode - INTEGER
	Defines how link-local and autoconf addresses are generated.

	0: generate address based on EUI64 (default)
	1: do no generate a link-local address, use EUI64 for addresses generated
	   from autoconf
	2: generate stable privacy addresses, using the secret from
	   stable_secret (RFC7217)
	3: generate stable privacy addresses, using a random secret if unset

So, I thought the checking should be strictly when the link-local
address is about to be generated.
