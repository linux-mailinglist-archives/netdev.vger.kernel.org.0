Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53533295D68
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 13:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897307AbgJVLcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 07:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897299AbgJVLcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 07:32:47 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F24EC0613CE;
        Thu, 22 Oct 2020 04:32:47 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t20so1391986edr.11;
        Thu, 22 Oct 2020 04:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jIaIAx6jS/4uqnHJUBuWWcGf2+UjzZ+gZdm819hN/VU=;
        b=ThtOsYEM5zerzLpBETqFjB3YKpeIJRvrmxJZEf3w4Kz9TeYMus9fkxqZomDOjrPcYl
         IRCDlFO5p8JDQHy/VyN3aDs8OMHv2Wwg/jkcPE+UDEx8jSV6kGPWZlCihR+1me/mVfwe
         1beaL4nlFZ48dotOLhiSl03EchBgg+kfFcMdyzY82YyEI4FHOfvKBvhFaU1viBQG8JaS
         hn/STTq4JcywsW2SUbtbfIAnz1gMWTAboVM8+1ahVW0S3ElzI2rsSFxKD6EAsbSa4NGf
         KCvvjO+9p8XX9w8Je31XyrVwsxQ7bwV1GbDHSqQX8D2+oisv55xDvdT8H161tNFSshC+
         SvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jIaIAx6jS/4uqnHJUBuWWcGf2+UjzZ+gZdm819hN/VU=;
        b=fKZHZygcI8qImIoOsHY/hwHDCTQCHdlL2r2+irDBLZN2TuUfgOGEibqOrvTNCm+e24
         X38WK2FGusaIyt+6qvcuMJQLlW5ARSr9UscXZODJ4jvFNZxf/Qfz5KZYCmWPBTex7+dS
         KGXll4WTUFiJFGu3+kKTvmu/JEgNNU9XuUqjJqTlKigJAM6sHUP/Tbd4hPNX7cNI+nen
         11ET+j/5AyWV0qHyIE6BqPTiJbwSqMu+kduuz+TGSzh8Zecy+8y928ObswASWxaEaKT8
         /HXc2twogAUucSBSrWgiBkpULylEYD24XT+DPA6luN6XVcdmmmoGi5Me3gyUp2ewqhv8
         +mUA==
X-Gm-Message-State: AOAM531lIOw9N5d2TDLgjRadlcv3fUe0CMr0HZ5TlTrmDnWhTLtUlgtA
        bDYUGOOGMvW5Wc4obSF7N4M=
X-Google-Smtp-Source: ABdhPJwkhqe63VnyxqwGSnytPajTDBSuPz6CsHi5+yS9NQpJLA8jC8m4X3b+pysB2hGKfZ+pmlegxA==
X-Received: by 2002:a50:f389:: with SMTP id g9mr1834189edm.367.1603366365840;
        Thu, 22 Oct 2020 04:32:45 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id d6sm601729edr.26.2020.10.22.04.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 04:32:45 -0700 (PDT)
Date:   Thu, 22 Oct 2020 14:32:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201022113243.4shddtywgvpcqq6c@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201022090126.h64hfnlajqelveku@skbuf>
 <20201022105014.gflswfpie4qvbw3h@skbuf>
 <2541271.Km786uMvHt@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2541271.Km786uMvHt@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 01:11:40PM +0200, Christian Eggers wrote:
> Hi Vladimir,
> 
> On Thursday, 22 October 2020, 12:50:14 CEST, Vladimir Oltean wrote:
> after applying the RX timestamp correctly to the correction field (shifting
> the nanoseconds by 16),

That modification should have been done anyway, since the unit of
measurement for correctionField is scaled ppb (48 bits nanoseconds, 16
bits scaled nanoseconds), and not nanoseconds.

> it seems that "moving" the timestamp back to the tail tag on TX is not
> required anymore. Keeping the RX timestamp simply in the correction
> field (negative value), works fine now. So this halves the effort in
> the tag_ksz driver.

Ok, this makes sense.
Depending on what Richard responds, it now looks like the cleanest
approach would be to move your implementation that is currently in
ksz9477_update_ptp_correction_field() into a generic function called

static inline void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff *skb,
							 unsigned int ptp_type,
							 struct ptp_header *ptp_header,
							 ktime_t t2)

You should then clearly document that this function is needed for
hardware capable of one-step P2P that does not already modify the
correctionField of Pdelay_Req event messages on ingress.
