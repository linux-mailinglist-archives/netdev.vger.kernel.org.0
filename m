Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399AC3A81A2
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFOODQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFOODP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:03:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8B8C061574;
        Tue, 15 Jun 2021 07:01:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id gt18so4272195ejc.11;
        Tue, 15 Jun 2021 07:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JsgNJW5wIP1wTY7QeUlV4IUxG5/Fna3sXYQD6HqLWoE=;
        b=UH54iboglCqZMsyMxaNx1cykI8qEc0gVz47KT1RhFpE0pCCL6YoqjQckTNNTXQdDs2
         Abds+du6hJAjYTyqllnZa7Ou8d+TzUS3xf4axeT1oe9slGnxUOpPf9kS6Q9LimkxgWYI
         AC4WcTvLlM1pUxaGjTj7cen+PMrAXt4k4aEWhxsiVDa78FIeNfom1KUm8c3z0ywgyvSd
         XlKYSkikqbaCwRiLmKkFnrG8MfHejTpUkm7H5vD+23fLHhQFYQok75cB19CEaJzpjUWA
         SLaY5JLnDOXej3FXartZTjG61DJKHcm+DMbatHy5ZuiM23E09AWr1fjy9yfKbfFEayI4
         HKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JsgNJW5wIP1wTY7QeUlV4IUxG5/Fna3sXYQD6HqLWoE=;
        b=Yn6oow986U4IIDWXGfcYHyW9v5SPj6ODglHSi4Vd9M1Lm06daH/nmw7JhkPGNG5cHl
         u0ALqAVQgaI9s0X25iK1fGD2Y58vH6qTUMhanR4kvB+qWqgDs7KCmGjaY4FQR2MQymRv
         E45gOo98jb0Nm/ZhfgOFy+ux/dFvJmTgBYMNsFR4VY79zU5u1kAgzl9Gbh677YJuIS8u
         45yjLzfjOun4XI6MZXiF9s6TpE7IF376R+KNuNo4a9kbSeHtWRjW5QzOAzOm3bhSeKlZ
         gknnICqwwSO6rkNftXbdZ0+Tq+CvFTb7MkyqbmcBml0H8yvjgGHVYP1m2OCNmEryhOr7
         Z0Zw==
X-Gm-Message-State: AOAM531S6NCuaBS6U0kxTrg5f2Sj16C44uC0RDL8PHa3fvioLMdubyX3
        0XJ+xCqjrmJL8Dj87uiq+EE=
X-Google-Smtp-Source: ABdhPJxvfsmJPHywGAB0aAnPn2QYmgFyJLTx9cz4bFNoJLzejT3gfx3slPC8yum+K4Y/NzmFFKyVfA==
X-Received: by 2002:a17:906:dbc4:: with SMTP id yc4mr2556302ejb.119.1623765668368;
        Tue, 15 Jun 2021 07:01:08 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id z7sm10046836ejm.122.2021.06.15.07.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:01:08 -0700 (PDT)
Date:   Tue, 15 Jun 2021 17:01:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next][V2] net: pcs: xpcs: Fix a less than zero u16
 comparison error
Message-ID: <20210615140106.4qqygvptmx4yctwb@skbuf>
References: <20210615135253.59159-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615135253.59159-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 02:52:53PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the check for the u16 variable val being less than zero is
> always false because val is unsigned. Fix this by using the int
> variable for the assignment and less than zero check.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: f7380bba42fd ("net: pcs: xpcs: add support for NXP SJA1110")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> V2: Fix typo in subject and align the following 2 lines after the 
>     val = ret & ... assignment.  Thanks to Vladimir Oltean for spotting
>     these.
> ---

Thanks.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
