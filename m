Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CE3282DAB
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgJDVHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgJDVHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:07:46 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65091C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 14:07:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k18so6808014wmj.5
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 14:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+I9MVQYvY5q8kWw2c3ow6ilGJUOAUj4CPLX0tIObKIo=;
        b=IHibMZmFgazTN6C19STcvKfxeHeB27aZgV18pLZE5mFx3cHnnlFPFvoP259mUwzFjJ
         VvRBpdNfOeKJ5yVCvjkmZEkZ6fdVexNoOL7RhGZGBRKJTQvjohnkuwgaUw4X1EuE1d/A
         0xbLHDI7CESYTddgJvF5qG9cmj8Z+ErLnjODDIdcDz9dlK5eyEpQeXzUfYvRyJF7nIm9
         iHkqduILU2WvfTFguTNPFNAOvejreD/qv06tW177LFQUR6caREHzfDm18ZoD9ahMl8nO
         XJVfPojF7zgQ/h1OGkdGaUDLz8q5kdiUaxNRMl/h6/JAiX4Cmqt9RyYIAofpNoyaobfo
         HQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+I9MVQYvY5q8kWw2c3ow6ilGJUOAUj4CPLX0tIObKIo=;
        b=O20JY4JcA9KsR3NiMsvjYuFyORKxJe1U7Gc5rmGx8UWC9zTcIt6AZ/JR69F1vc/VC/
         JoQ+7yBVtqz+F4aERINNtjQ40pFr07XiOypuAeeuQ9cNMWNZDx06S/2BnLGW13nx5bze
         Exdihz1tw4BAh3EmA608tF3Zq00L/As9oVu4FA6Xu0CEL3bQ36Xyyw1vN/u7maCL3TeE
         nnXlfdGUWwGqeuzjHndp5nmjgWZ40EB+CW5Lqi66W42+OyczhqmDPjZq5FNZrPGFbqVo
         YXyNwMEPHW4AKPgnT5HZLDb16TbGtnsF2hgvFWGVPOBK/Xt/HZZOLNdQ2UTKd4aPahNE
         6/IQ==
X-Gm-Message-State: AOAM533ufnrEaefFAHh4ecx8BNggNYltZ+5aIdlPE/vmJsMo+HOVHZ6K
        A9k1Wcy/qDkpRbvro1JI2DY=
X-Google-Smtp-Source: ABdhPJwsxLXWj2EQbb+6m8D7e+7xhOffonJ+OLEM3jaEHwhFSM78PaKGU8Pw1XMM9PxjCal76xtV4A==
X-Received: by 2002:a7b:c317:: with SMTP id k23mr12919806wmj.44.1601845664162;
        Sun, 04 Oct 2020 14:07:44 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id p67sm10554657wmp.11.2020.10.04.14.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 14:07:43 -0700 (PDT)
Date:   Mon, 5 Oct 2020 00:07:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 7/7] net: dsa: mv88e6xxx: Add per port
 devlink regions
Message-ID: <20201004210742.nxumrvdzqjah25xe@skbuf>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-8-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004161257.13945-8-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 06:12:57PM +0200, Andrew Lunn wrote:
> Add a devlink region to return the per port registers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Sorry for the wrong "while (port-- >= 0)" advice given in v2.
"while (port-- > 0)" is definitely the correct idiom, which is what you
are using here.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
