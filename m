Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0884346927
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCWTdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhCWTdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 15:33:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB9EC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 12:33:44 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h13so24819210eds.5
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 12:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YmIf3x2Z/FpuSB/HZwUlctp9YGIJswZmI25lH4/9Izw=;
        b=SXpZ4ZTmAhuPBKZOxWfdMJcnaBXtxqShdcCD1J5naBpqitP02aJUw5B+YBfOw07GRB
         CJxdbJyHRhWNh0eGNaKVO2wDiS1Vs9n/kSYUsQ/olno79xdpz6S/QL4jA7UjVirZ63GJ
         CGOiodlA97BjxpJsevk4fh9tNqyNCswtbrpvRlyt2bsBZKvt9R++U2KBEa/wDDjuT46M
         yNMZDwhOkDOEP+EHa+3Y3vBgU+WCLAtu654kraRPB0NTVTIE2EoQ6f+KgrSYSCukR3vI
         RyXDcGjCIFSIU3KZA58EILJv/f1qMvprP835oLTFM2DV/9jcvg6sIBJDjWPb/u3Y0rbs
         tjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YmIf3x2Z/FpuSB/HZwUlctp9YGIJswZmI25lH4/9Izw=;
        b=A776f7FP3l2ScR8Kf/FYsMZJ90DLYzo1xGi1aqcliM9YET7TfCMcEnT/apTtPgFEOB
         EEmzwexrKvPpb6tCyL3sEMJhnBCAOH4QSAq1O0JOQmPNHbMcpUYXMw5En+2LcPB+zEr7
         1Xl68lH8WXcDP9X5NeoO2OOo8rbuckGg+FE4oBFg+3LYnS0hccQTqfXMAA0qLaL5QcFg
         Q3XPVdvs6m+TyvDqhT47/509jQR/7vINwUBHp6fxOZQ/z1BWQoeiCrQYU1JH2lNlU0pJ
         ///lRgnjoiZPEiteWxOXNunl4cvKG5X9YG5ZssnAArgTLflcHQasDt3QqvPzRcFoo46Y
         sNRQ==
X-Gm-Message-State: AOAM531NiJOgSE0F/tNNEtbvbCaoBmtG/Uqq9vPMLi+UZ8FXTpIjvsw6
        5VBi7KtKwAnI9goY0qQpJBI=
X-Google-Smtp-Source: ABdhPJydEkE+2FWISdFYITRbmKNqi7ipHYcgvn6h+0TZ6hWVcpPYO8digboTZMH5C/trm0s/POLhxQ==
X-Received: by 2002:a50:bb47:: with SMTP id y65mr6263760ede.305.1616528023179;
        Tue, 23 Mar 2021 12:33:43 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id h10sm13811168edk.17.2021.03.23.12.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 12:33:42 -0700 (PDT)
Date:   Tue, 23 Mar 2021 21:33:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 2/3] net: dsa: don't advertise 'rx-vlan-filter' if
 VLAN filtering not global
Message-ID: <20210323193341.nuaqv22mdyn3be5p@skbuf>
References: <20210320225928.2481575-1-olteanv@gmail.com>
 <20210320225928.2481575-3-olteanv@gmail.com>
 <d4bb95df-9395-168f-f6e8-33ae620fed8f@gmail.com>
 <20210323120325.5ghp43xfgg4hifpk@skbuf>
 <6a9c0cd6-02fe-dced-dce0-410f1104e4ca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a9c0cd6-02fe-dced-dce0-410f1104e4ca@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 09:16:03AM -0700, Florian Fainelli wrote:
> > Would you be so kind to try this fixup patch on top?
>
> That works for me, thank you! So for the whole patch when you resend,
> you can add:
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks again for testing!

> > Although I am much less confident now about submitting this as a bugfix
> > patch to go to stable trees. But I also kind of dislike the idea that
> > Tobias' patch (which returns -EOPNOTSUPP in dsa_slave_vlan_rx_add_vid)
> > only masks the problem and makes issues harder to reproduce.
> >
> > Tobias, how bad is your problem? Do you mind if we tackle it in net-next?
> > Also, again, any chance you could make mv88e6xxx not refuse the 8021q
> > VLAN IDs?
>
> I was thinking the same last night while sending my results, as far as I
> can tell the switches that have global VLAN filtering or hellcreek are
> not broken currently right?

Yes.

> If only mv88e6xxx seems to be requiring special treatment, how do we
> feel about adding an argument to port_vlan_add() and port_vlan_del()
> that tell us the context in which they are called, that is via 802.1q
> upper, or via bridge and have mv88e6xxx ignore the former but not the
> latter?

How would you then describe to .port_vlan_add() those VLANs that don't
come either from the bridge nor from 8021q uppers, but from direct calls
to vlan_vid_add? A VLAN is a VLAN, and a driver with
configure_vlan_while_not_filtering should accept it.

If mv88e6xxx refuses this right away:

ip link add link lan0 name lan0.100 type vlan id 100

Then traffic through lan0.100 will be broken as soon as we do:

ip link add br0 type bridge vlan_filtering 1
ip link set lan0 master br0

So I believe we should be looking at how to make the Marvell driver
accept the VLAN, not how to help it refuse it in other ways.
