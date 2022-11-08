Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21331621843
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiKHPaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiKHPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:30:11 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE51277C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 07:30:10 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 13so39639923ejn.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 07:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FpLiGaXhotQZ8b2nqHMo2ysie9FYsoam/Xs2nB2FQwI=;
        b=DSqKxORe+HHRIvWQTmqEOWX7uJ+Bog3bxbKTF2CX1y3k0sLtXjrT49HSo8EnDml9yz
         Cql1c9yQozM1lmZCl9QgxvGYpEk43cOuUi7piWpWCKc7VjEEBUZa9ooamxw2bD0xYtE8
         jSnU+wg3G58OTskD78IJllcxnpQmVJ9Z0F5cAHnOrNUFly4Y4X6OlhUzgeZJ4HHZcaiS
         Ea5TNEcVOHU/al1AS96Gqy3pQwPK88njNFhLLFmQIo/XYcD7CHAhH7kyJZPtxJlllvRn
         9GeoY4dr7BOfM4EXDHpQt/lJZ5mPdWI6uRSHfqg/5F6dDwZCfExSBMCB+/uUBDQzWWjk
         Zzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpLiGaXhotQZ8b2nqHMo2ysie9FYsoam/Xs2nB2FQwI=;
        b=Ip/7onNUcFj8DfLDS2LTG5Qq+gWZqPoOkwtct3Glp9B5jXtG7ncQPYuC2i4Dpgr4D6
         0/pG8T0Y3Sy6TAqkYxtjpOIH5FlA17dCEUdwogeT7hR8+uWWAd+mo/emgPVzk/Q49ihd
         zrJ90eqOSJyLs13EsJsqakUdiwJf306BQ0B2pASCjb+hyIDncNby+JoNGnfBDZJQ0YPN
         GCrPSL6+bh+ADcmkUzTt3GfJspCo9pkOK1uMHTWpO18/Zo8OOJ6ua4NF/bHOoZ0KzXAi
         H2+pEAFF2P2AfS5kE2dqeb+ZwetT7KP79aTVWl6/WMFEImOBnpXx1tHII6C3CkOscs+Q
         tGAw==
X-Gm-Message-State: ACrzQf1JvnCCssxz1R7OEZAhvWrdATw+62qXj6nuFORhE2Ia9vAvoeZn
        0vtK+NcmSpprbdx0MkoQ2RvE6BeF0X4ywQ==
X-Google-Smtp-Source: AMsMyM5LSnf+Pf3Owy39GhVGMBlevi8XhExQOJ/9qPL7Z7WDtKsrKPTC5uLosSkAeln7ysL8LBrxtg==
X-Received: by 2002:a17:906:eeca:b0:730:6880:c398 with SMTP id wu10-20020a170906eeca00b007306880c398mr54399922ejb.706.1667921408806;
        Tue, 08 Nov 2022 07:30:08 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ku15-20020a170907788f00b007ae1ab8f887sm4865360ejc.14.2022.11.08.07.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:30:08 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:30:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 14/15] selftests: mlxsw: Add a test for locked
 port trap
Message-ID: <20221108153006.githtup7oisty4qb@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <cover.1667902754.git.petrm@nvidia.com>
 <61b030c0932726657eff1ac545d1904a2ee930ea.1667902754.git.petrm@nvidia.com>
 <61b030c0932726657eff1ac545d1904a2ee930ea.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61b030c0932726657eff1ac545d1904a2ee930ea.1667902754.git.petrm@nvidia.com>
 <61b030c0932726657eff1ac545d1904a2ee930ea.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:20AM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Test that packets received via a locked bridge port whose {SMAC, VID}
> does not appear in the bridge's FDB or appears with a different port,
> trigger the "locked_port" packet trap.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Pretty impressively designed. I liked the extensive checks (for example
that traps stop counting after port security is disabled).

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
