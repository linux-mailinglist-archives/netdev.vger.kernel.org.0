Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979034D2769
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiCIB7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiCIB7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:59:42 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338394CD4B;
        Tue,  8 Mar 2022 17:58:45 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z15so960052pfe.7;
        Tue, 08 Mar 2022 17:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7PG7n6GhwgZymh0wA6094FxRWkefaowHSSxuvDcjabc=;
        b=R91Qwwy0Cb0xukbPogn0xW4aYwy2Aqq1sxGWvw2CcvjTxDoKHGR6y8lGWPpmwAYGXX
         0iQIC1YFr0y4ysF43dyTH5hXZbRKxHcXhi4aqNBgX2FdjLtIKn+mZzycbEBe1JZnZoIA
         tf33wNOcZnhzcBow2xFkB9H7E39ew4sQTNwHz/0PxxsGlyqxF8/SPnfUVKgImxPyic1H
         caYSjl+/k5sULbq3iwmVZ55qNuSchLni6l9HbNd5aVqxCKwUm9QHaWEKHtrHQzMds3Tw
         J45+Y/7O/QrY5T6ovlIl64qnJWr7Wg6Qm5EPNY4MfUp5pRRE+6XJTtIanW7UNZrd+JnP
         3Y6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7PG7n6GhwgZymh0wA6094FxRWkefaowHSSxuvDcjabc=;
        b=Z8YMhUMFzlNADUqpvxHuIFqJ/UmPO2uhGqVPc9id02MJi3N4F0NqqimdDA+Kgh0Scg
         ohr95peE7eUMaf4lBLZcAszie6X4Fk5hxFa0tdZf0dL0w04JEtNta8VSHTAV01Tig1BT
         zDZ6Z7Eg+142l9JlK/rFiXJKTFDEEy5weAQeURY45usHEgZkJQvRcEhPbZDeENKdFRJN
         rolf3ImPUoCo1ifNSKXE5iw5/IPE7uA4fZ9ZL/DqTdyT4PF+e1T1hoCjXMfp/sPamXsB
         EQGohXYEBpyawL34pQ1Pm12pZaTp3HWCNI9Iw38HYniHDtMAavKcmSwP4z1bmejpfWOH
         e2Uw==
X-Gm-Message-State: AOAM530rr5qSfU96TSvMXDgL7CpSMMoGeSmLLzkZz+/VtqbGnJiI2PeP
        hycN7UPLE3rMUulXFcYQ9GA=
X-Google-Smtp-Source: ABdhPJzJjgOdKTS8G8Lg4WHgrtnaFnKyVgFZgmCMHdFTAsAdtEUV0ecvjEho8Jsy2RKPy26VWbwXsQ==
X-Received: by 2002:a05:6a00:1152:b0:4be:ab79:fcfa with SMTP id b18-20020a056a00115200b004beab79fcfamr20964596pfm.3.1646791124720;
        Tue, 08 Mar 2022 17:58:44 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b1-20020a630c01000000b003758d1a40easm371184pgl.19.2022.03.08.17.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 17:58:44 -0800 (PST)
Date:   Tue, 8 Mar 2022 17:58:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Divya.Koppera@microchip.com, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220309015841.GC24366@hoboy.vegasvil.org>
References: <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309014647.GB24366@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309014647.GB24366@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 05:46:47PM -0800, Richard Cochran wrote:
> The problem with uncorrected PHY time stamps is that they affect the
> boundary point between the node and the network.  A static error there
> will create a path asymmetry that can neither be measured nor
> corrected by the PTP, and a variable error degrades the time signal.

And FWIW, the imperfections in the cable *also* introduce path
asymmetry and thus uncorrected offsets.  The twisted pairs are never
exactly the same length in both directions, for example.

However the PHY delays can be in the microseconds, but cable delay
deltas in the nanoseconds, so correcting PHY delay is much more
important.

Thanks,
Richard
