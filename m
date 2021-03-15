Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F83833AED6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCOJaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhCOJ3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 05:29:46 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9C1C061574
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 02:29:46 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id r17so64917835ejy.13
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 02:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j/7YzyvMU5JMJ2oNmYhIZNpG2NItj0fRAHUR4AE0BVg=;
        b=CYoFb+FkE4cVoCwo23f8v+KpnuFgaFwf86M7SPHUX/fvyF8dQ231L3g3mF3oRc1mxQ
         VqU9TB9JYFyj8vUY2qgZlG7S80j7fsfOvSycAme0+sSwm6XZG16JFE+G/hrYwJps64rY
         xD/e34Lm254bK+UD64rfN764I93ZuT4YIlnRIOFv7mOKBbA+OH2pOAERsi7wE4WcFrxY
         MqtyRtqCdc2vj9YiTXTzlqOSayJrCvtuNN58JTHctiU7itjDnJzxnxfI5cy0OSW75BrT
         COhGzPudK+YQz47cCkTZBLGBageovcfSCupRR3GJgnqPblwPfYxZfFI7nKYF2ia7bmZt
         stKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j/7YzyvMU5JMJ2oNmYhIZNpG2NItj0fRAHUR4AE0BVg=;
        b=eYqjyUwWx+u50QkuAAiwcJ61Bj21HDRwS9qgSz+Kdc1cIxxgOw+oEydDcEVXuiiDyP
         4vka5at0XCEiOPXWrMZlrcfBZHyqHxujMNelnOKtmAV9fcD4dK4l6H9QQ0S0rjGMWVro
         sZjyN90iOoNhyo2lfHE47ZyJJUgTFxFaHpyW+P4bqo5D2KRqUfM4MWt2ymxYY92dp9ja
         /47PXBh5Z2ArgD+V/14uryfukwBb3diLTzA4IX1BX0RpPcoQDd9TQlGMkJfuf+ZotCDk
         Mv9k8eBWfF7ZswgbtHvO7anA6fbjiCZKsY2vmbALGf3PB50c32Dx10X1IiYMGkwErFwm
         pX4w==
X-Gm-Message-State: AOAM532brnn9rYsNI3IP+PRC2/f7bvtqXSoGr3R4cHcwAQ6vVQSxSO0E
        1Lvlrprc0gQ2mQTYknVSGOk=
X-Google-Smtp-Source: ABdhPJyN9yVIgo0rU6d9QGYQTORJKPoRgX6lv2f0kcEgohjsImqlL6QPSKO0zQy+vXEP++Fo0JHXzQ==
X-Received: by 2002:a17:906:8147:: with SMTP id z7mr21566945ejw.436.1615800585188;
        Mon, 15 Mar 2021 02:29:45 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q12sm6959008ejy.91.2021.03.15.02.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 02:29:44 -0700 (PDT)
Date:   Mon, 15 Mar 2021 11:29:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <20210315092943.ejqwqcbqwcverkim@skbuf>
References: <20210309184244.1970173-1-tobias@waldekranz.com>
 <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
 <87h7lkow44.fsf@waldekranz.com>
 <20210309220119.t24sdc7cqqfxhpfb@skbuf>
 <87czw1pg60.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czw1pg60.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 10:40:55PM +0100, Tobias Waldekranz wrote:
> On Wed, Mar 10, 2021 at 00:01, Vladimir Oltean <olteanv@gmail.com> wrote:
> > +test_vlan_upper_join_vlan_aware_bridge_which_contains_another_physical_port()
> > +{
> > +	ip link add br0 type bridge vlan_filtering 1
> > +	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
> > +	ip link set ${eth1} master br0
> > +	ip link set ${eth0}.100 master br0
> > +	check_fail $? "Expected to fail but didn't"
> 
> Should it though?
> 
>    br0
>    / \
> .100  \
>   |    \
> eth0   eth1
> 
> eth0 is in standalone mode here. So if the kernel allows it, who are we
> to argue?

Without my "call_switchdev_notifiers(SWITCHDEV_BRPORT_OFFLOADED)" patch,
We have the same old problem with bridging with non-offloaded uppers and
the bridge not knowing they aren't offloaded, don't we? The bridge port
will have a wrong offloading mark.

I think in principle the configuration could be supported with software
bridging, and then the dsa_prevent_bridging_8021q_upper restriction can
be lifted, but I imagine we need to add logic for a DSA port offloading
and unoffloading an existing bridge port depending on its upper configuration.

For example, would we support this configuration?

       br0
       /  \
      /    \      br1
     /  eth1.100 /  \
    /       |   /    \
   /        |  /      \
  eth0     eth1      eth2

eth1 would not be "standalone" except from the perspective of br0, but
due to offloading br1, we would need to turn on address learning and
such. So we should probably either enforce that eth1 is standalone when
at least one non-LAG upper is bridged, or deny bridging the non-LAG
uppers. Without a known use case for such configurations, I would rather
deny them for the time being.

> > +	ip link del br0
> > +
> > +	log_test "VLAN upper joins VLAN-aware bridge which contains another physical port"
> > +}
> > +
> > +test_vlan_upper_join_vlan_aware_bridge_which_contains_another_physical_port_initially_unaware()
> > +{
> > +	ip link add br0 type bridge vlan_filtering 0
> > +	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
> > +	ip link set ${eth1} master br0
> > +	ip link set ${eth0}.100 master br0
> > +	ip link set br0 type bridge vlan_filtering 1
> > +	check_fail $? "Expected to fail but didn't"
> 
> Same thing here.
> 
> > +	ip link del ${eth0}.100 > /dev/null 2>&1 || :
> > +	ip link del br0
> > +
> > +	log_test "VLAN upper joins VLAN-aware bridge which contains another physical port, but bridge is initially unaware"
> > +}
> > +
> > +test_bridge_join_when_vlan_upper_of_another_port_is_already_in_bridge()
> > +{
> > +	ip link add br0 type bridge vlan_filtering 1
> > +	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
> > +	ip link set ${eth0}.100 master br0
> > +	ip link set ${eth1} master br0
> > +	check_fail $? "Expected to fail but didn't"
> 
> And here.
> 
> > +	ip link del ${eth0}.100 > /dev/null 2>&1 || :
> > +	ip link del br0
> > +
> > +	log_test "Bridge join when VLAN upper of another port is already in VLAN-aware bridge"
> > +}
> > +
> > +test_bridge_join_when_vlan_upper_of_another_port_is_already_in_bridge_initially_unaware()
> > +{
> > +	ip link add br0 type bridge vlan_filtering 0
> > +	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
> > +	ip link set ${eth0}.100 master br0
> > +	ip link set ${eth0} master br0
> 
> I think you meant for this to be eth1, correct?

Yes, this is a copy-paste mistake.
