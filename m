Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32205284CA3
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFNmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFNmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:42:51 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70D5C061755;
        Tue,  6 Oct 2020 06:42:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id cq12so9836247edb.2;
        Tue, 06 Oct 2020 06:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ptUy/bamGhbnmhn7Q8bQ/nqFN/CVdkuyh2oHpRPTWzI=;
        b=CbVEKL0FUy1iWxfISLAu6wf9qhtKruFGkrCL+lvj/S9H00mvI5BoJEpVcoG3FEdbUY
         b82MFF8kSfURytu54DX/grNHVfsYiwFN7BxlmqlI+tTyT33QWl1p2TvS8hjLfxz2sXSc
         dCuPrTO6MSbiv2m86R6o2K5j0GWQKmMpavSrTQSAS6iJran4OGcm70YdU7EABSkXCS9H
         F8g+kcf9c06VZGyWWNc3zZGMJXsJmPbEpAuLJR9glg1NHqaPp8e6+VXUp/J8Tb6TWetb
         iF3JUDLaCbuOQm+nBJsRTShyYWKWtx3PfkXAZFpJKNNQhc6ulpo0H9sDxWAKd66fGzl8
         PQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ptUy/bamGhbnmhn7Q8bQ/nqFN/CVdkuyh2oHpRPTWzI=;
        b=XCCwCflaGvJLcM6n/jKFfUBRPrN3hIH5uaM75uj9Cw4x22Nb17MShvBhnLrPVaR0se
         SViatRidiY5ftdBk/tD2VIF9fQBlJu4zm4E9gVHqZARiotPI/60c3d+J1oYLiA0lPm5x
         IUmmyiMtIMTbCLdibOLEEg2PejaRsD39DlRAfiuMDwPkWOBLUdMbQODuxLsr115ZhUbf
         nu2d0xbRrqBZ/2CENUYvWYknqEDw/C50WEcbmX4x0HJ5eRmXN+ffRQo0aXLjkPN2R8dU
         6/SVRV7HptmOSfEzvgPQ68iVqCT4VeW231xrAVQcJUYmhnpvXPbHBnI4xxjJzlN6c8s1
         p+Dg==
X-Gm-Message-State: AOAM530pbkiB52zLLvlmWRZFDcGzCs7ENTh0Ow81/CB2SiP9ND0WQD+9
        zdCgUVY+CnGpz769j4hkD5Y=
X-Google-Smtp-Source: ABdhPJx/vSao5sLb83szHFmi3b13Bbr9Mp1YpZZYvidA8zcsArOpKDzHl/FJGj9gmcn0K/qD8BWSxg==
X-Received: by 2002:a50:9e4f:: with SMTP id z73mr5520115ede.109.1601991769450;
        Tue, 06 Oct 2020 06:42:49 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id rn4sm2298174ejb.43.2020.10.06.06.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 06:42:49 -0700 (PDT)
Date:   Tue, 6 Oct 2020 16:42:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201006134247.7uwchuo6s7lmyzeq@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo037ajr.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 03:23:36PM +0200, Kurt Kanzenbach wrote:
> On Tue Oct 06 2020, Vladimir Oltean wrote:
> Does this mean that tagged traffic is forwarded no matter what?

Precisely. The bridge VLAN table should be irrelevant to the acceptance
or forwarding decision of the packet if vlan_filtering is 0.

> That doesn't work with the current implementation, because the VLAN
> tags are interpreted by default. There's a global flag to put the
> switch in VLAN unaware mode. But it's global and not per bridge or
> port.

Oh, there is? Maybe you can use it then.

JUST FOR CONTEXT, for sja1105 and felix/ocelot, this is the mode that
they're operating in, when a bridge with vlan_filtering=0 is configured
as an upper.

In sja1105, I don't even have the VLAN awareness flag that you have. So
I need to change the VLAN TPID from 0x8100 to 0xdadb, and the switch
will think that VLAN-tagged frames aren't VLAN. So all frames are tagged
internally by the switch with the port-based VLAN ID and PCP, when in
vlan_filtering=0.
And because my knob is global and not per bridge either, I just set
ds->vlan_filtering_is_global = true and let DSA handle the rest.

As for ocelot/felix, those switches have 2 knobs:
- VLAN awareness: does the ingress port derive the classified VLAN from
  the packet's 802.1Q header? If yes, the VLAN ID and PCP are taken from
  the packet. If not, they are taken from the port-based default.
- VLAN ingress filtering: does the ingress port drop a VLAN-tagged frame
  if the classified VLAN is not installed in its ingress filter?

As you may guess, even for ocelot/felix, when we have a bridge with
vlan_filtering=0, we are still configuring it as:
VLAN awareness = disabled
VLAN ingress filtering = enabled

Because the classified VLAN is not derived from the packet, it will
always be equal to the pvid of the port, which is installed privately by
the driver. So no packet drops due to VLAN, regardless of VLAN ID.

> So you're saying private VLANs can be used but the user or the other
> kernel modules shouldn't be allowed to use them to simplify the
> implementation?  Makes sense to me.

Yes.
And because the user is more likely to install VLAN 2 and 3 than 4095
and 4094, maybe you could use private VLANs from the end of the range,
just to make this restriction less obvious (or maybe not at all).

> The egress port has to member to that VLAN.

Same as ocelot/felix. This is the reason why we make it VLAN-unaware.
There's no point in disabling just VLAN ingress filtering if the end
result is still going to be a drop, albeit due to a different reason (no
destinations).
