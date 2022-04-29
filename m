Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F4F514CF4
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377401AbiD2OeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377384AbiD2OeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:34:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A11656F
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:30:50 -0700 (PDT)
Date:   Fri, 29 Apr 2022 16:30:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651242648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SwUBbCpjXJfT8RoxTvwsoJRhpg/28jL4v2SM3uji8rA=;
        b=mlAE4oqYipV11OZdLz0x+eKPQdO/7mR2QLboJKbmdgAqec9YqjvBRDTC2USrVL376wfQhM
        i4XLfviPa/OwQlgIlRToRDhgt9TPfC8B0iSf2AsUeAY9N+H8hU/SSiOTq6lvPBj1cF5jg8
        FG73wFpTyZPERT+R2TTSQM6IfHF4aAVQOEKJY5+hmT6FcfIMMM+Nu8mN7uszGl87nvdYiB
        ECwM3DGw7N37u5xh2GTMDMRfC7oZISZUswND+MMoVcgUa7XmGgi0jEKki7C2YrgqR/mw5U
        MH5May8oKRfMuTJQSkk/BSOzQ0HkOEMC+syl7s7bXDrAEaA16WPU2txanwcp9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651242648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SwUBbCpjXJfT8RoxTvwsoJRhpg/28jL4v2SM3uji8rA=;
        b=qz/ltQgpfGnes3DXEvbL4dBBVolSjR+2Zj8F9VeEpN8GBvwk+f6rSKiYjx+YxcPrzLSA+F
        39AQ8HiayeZLm1Dg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] selftests: forwarding: add Per-Stream Filtering
 and Policing test for Ocelot
Message-ID: <Ymv2l6Un7QXjrXFy@linutronix.de>
References: <20220428204839.1720129-1-vladimir.oltean@nxp.com>
 <87v8usiemh.fsf@kurt>
 <20220429093845.tyzwcwppsgbjbw2s@skbuf>
 <87h76ci4ac.fsf@kurt>
 <20220429110038.6jv76qeyjjxborez@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220429110038.6jv76qeyjjxborez@skbuf>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-29 11:00:39 [+0000], Vladimir Oltean wrote:
> > I agree. Nevertheless, having a standardized tool for this kind latency
> > testing would be nice. For instance, cyclictest is also not part of the
> > kernel, but packaged for all major Linux distributions.
> 
> Right, the thing is that I'm giving myself the liberty to still make
> backwards-incompatible changes to isochron until it reaches v1.0 (right
> now it's at v0.7 + 14 patches, so v0.8 should be coming rather soon).
> I don't really want to submit unstable software for inclusion in a
> distro (plus I don't know what distros would be interested in TSN
> testing, see above).

Users of those distros, that need to test TSN, will be interested in
having it packaged rather than having it to compile first. Just make it
available, point to it in tests etc. and it should get packaged.

> And isochron itself needs to become more stable by gathering more users,
> being integrated in scripts such as selftests, catering to more varied
> requirements.
> So it's a bit of a chicken and egg situation.
If it is completely experimental then it could be added to, say,
Debian's experimental distribution so user's of unstable/sid can install
it fairly easy but it won't become part of the upcoming stable release
(the relevant freeze is currently set to 2023-02).

Sebastian
