Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C365C282D9B
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 22:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgJDUz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 16:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgJDUz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 16:55:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022BAC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 13:55:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k10so7345143wru.6
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 13:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fuz3VnS7gqSToWKpKAn9vH3vGA/DDBL2++eeVTZGySE=;
        b=j9v9tOz8/eiiqkNQ6IrKc2b2vv7a3UQdT3Bs7hgg1ul5SnJRWqJeMur29Qz9kwW/vA
         2hX4s2se6hkBHgqEMgZbdnKOLD7tX463R8dGzOFpaUI4u0DKTU2j0YvpS+WCsnTdALpu
         9NLbcgU/Uu1MWP7BnEW6WVvjwkLEtnVIxtbN3LMawGL8QYnxXlti7r5JQci30liTL6zz
         xqbXAggsmv9Gbft4xGKWA8V1GcMf3XjnNSkJyaLrU4Zeuo+VuYW3IpO0CrRKs+WeIFqP
         eDdOwSAD8lg8SUO1u13zlSZmRXBFABA7562OIywTZ7iq6naN1niFwuED7lWHFxXSuO/2
         mLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fuz3VnS7gqSToWKpKAn9vH3vGA/DDBL2++eeVTZGySE=;
        b=hLf/d6W+AcZ4W/EQieAan0DwnVO8M47ePSyypVY1u+RedQd9561RAr474tz7Fkizhe
         IfjMPc4/NwIlabfV7E+eeNGXJ+tGZvo0AsYVQgrMm+il+Zl2PatwufQHI5RLy+mHaMaM
         /gAfFTow6wJFPxA1/sG7KW7ooctD4jbbXWlNyQcKjQLM4B8oqKSycr0qAUI5RsmLONfS
         lfuzO1MbGXJg/q/VdILKqVMYwiIiBiY5KtD7HsoUr41UCXMuBTyO78ZCqDjLzdWkYHNJ
         4ayhDEHZ/zPzEm9zEsQsAnttPehtbKG37ZCbV0psf2wPOHDd7P4qv61v2Dxu0VULMqlT
         4Htg==
X-Gm-Message-State: AOAM533YmVtwnbQZXplRsGQTX3as+KYOoPtNfCeUyrNGrzsSDrUPFbxl
        llBJ7UR6pwW6wh+QqL6/ttg=
X-Google-Smtp-Source: ABdhPJxF4/SYps5qcB1tBsJNn1r1+HYtpUgE1VJ7ThT2XeNnb+NaeIf2tONhaFYkkKZvRbQ+0JyZag==
X-Received: by 2002:a5d:4b86:: with SMTP id b6mr13744185wrt.173.1601844954676;
        Sun, 04 Oct 2020 13:55:54 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id m10sm10157035wmc.9.2020.10.04.13.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 13:55:54 -0700 (PDT)
Date:   Sun, 4 Oct 2020 23:55:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 3/7] net: dsa: Register devlink ports before
 calling DSA driver setup()
Message-ID: <20201004205553.ableh6nowaudeu6o@skbuf>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004161257.13945-4-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 06:12:53PM +0200, Andrew Lunn wrote:
> DSA drivers want to create regions on devlink ports as well as the
> devlink device instance, in order to export registers and other tables
> per port. To keep all this code together in the drivers, have the
> devlink ports registered early, so the setup() method can setup both
> device and port devlink regions.
> 
> v3:
> Remove dp->setup
> Move common code out of switch statement.
> Fix wrong goto
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
