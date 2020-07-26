Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D988422DDB7
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 11:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgGZJUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 05:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgGZJUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 05:20:20 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A004EC0619D4
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 02:20:20 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id p14so11099197wmg.1
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 02:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fbaoL9wc+TzhBeQPiolD3jgZoPFAPhgCzCV3R5hxi0Y=;
        b=ZR8Q0E2Y5mOyQesOX7+JgXbKmUx5NBDaYTeIeWaGcUxyjsAii0tLS8a1EorpL/dBvE
         AiBH07JCby8vRx797b1hIuC9sWh64XhoKlbXExiV8j9UHfPbwq+ABVXyGT1OJ6NJVZeI
         z3/IopDkg44IGAMB7uB+RhLbp2m1uScx0HJF5zjmhAd87eR9zKEcW/6p2sppmnGuAHpA
         2JJDYHtupHHKT6f4zBdxCTWNoktLCBnoVRLpNa4x5A4XxJvwpSyzLLK1pmB8ZJeuRyUK
         t8FYbMT5tja7l+RIGcc5xfWyYdjg7eajyd7DsrA3y9Nguq8dSZgC9A835TfwhgOXSHkv
         /v8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fbaoL9wc+TzhBeQPiolD3jgZoPFAPhgCzCV3R5hxi0Y=;
        b=S8nFPWxaZplBmBZt10uQ0eGeb6G46V48fhCnCFPRDwlfGyed1CdB9dBcjx2sM5JFuQ
         8oCsR+sJ/2TQr8GOhxG5a5o4NoKVZSLrLI6JU7tw9cIAKEQquCt7zvGalrDqGOxa/L2I
         SiXFgPD/AHHQl8+aWF2lTycRJi29n5gTudQDLACwjbC/kpyGYmLPnJrfDXytdW7Yx8DM
         jHW8mFbNHAAGjyej5XNwmgEQf/NJ2zu2Y/2E9u5OioxZbjjh2J02w1miV3UxkC+ACo1V
         df6J5qHRheMBtRAPD3V89kmsYMJu+osXuJlPDs+mXIuRx9z1DImNGRhuP9T9iUklEhzg
         zpKA==
X-Gm-Message-State: AOAM531VdKa0XZ7t2fhWRZQ2P1sZjSZM+yyXPh2Qp5v3GorYXbimo3+1
        +GsXjJj01XrdYW11p9NsJyd5/A==
X-Google-Smtp-Source: ABdhPJxjBeGJhYNffhH7UmESIV9YZc+0Vs87J4kHBojWsAft6koYVjfBghO+QYeA0g8FeWet4MP7bg==
X-Received: by 2002:a1c:6707:: with SMTP id b7mr8298414wmc.97.1595755219386;
        Sun, 26 Jul 2020 02:20:19 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k14sm7775988wrn.76.2020.07.26.02.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 02:20:18 -0700 (PDT)
Date:   Sun, 26 Jul 2020 11:20:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v3 3/6] net: marvell: prestera: Add basic devlink
 support
Message-ID: <20200726092018.GF2216@nanopsycho>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
 <20200725150651.17029-4-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725150651.17029-4-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 25, 2020 at 05:06:48PM CEST, vadym.kochan@plvision.eu wrote:
>Add very basic support for devlink interface:
>
>    - driver name
>    - fw version
>    - devlink ports
>
>Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
