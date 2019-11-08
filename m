Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9A7F3DFE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfKHCUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:20:30 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34611 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfKHCU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 21:20:29 -0500
Received: by mail-qk1-f193.google.com with SMTP id 205so3983171qkk.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 18:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=K1gmW5ceY0g/N9S60wET47aqWGNyAfsKtPcM+2j8jVU=;
        b=zDUnbJZW4oVWh4n0Ef1nMdMgzRz4NV1nrjHowH66Hvu+URbtQBpPxCZ98Z9qy7S97m
         EDVbSWGMBBRqPSjy6tlz35XqaZE13gfmSXGuPLidogBG1fd3WwllIXLqyMzT2vRWlQ9C
         bBheXpsGupqXBGeC3OOwyDYqc2DGheJwRRYJXRjYVKtcrRejpdgtEO80ncAJvCUrLI4P
         gRXP+15JQ3y+eDz7zCJKqojv5GKz9zqoee8jXOlNHiwbdupK+UdKF7QOA8tC8sYPvOCG
         PD//4gUWBAlDh7KtyFQYqh4OqvDXFrTtT3g5+WeYD5OBp7i2RkZZ3NupCcLHKAjO2twh
         SZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=K1gmW5ceY0g/N9S60wET47aqWGNyAfsKtPcM+2j8jVU=;
        b=NlP8koRxlBB06bcl7IvnU4sFFgrqP9dAz7nrshjn47SZgrN2D2yMTCLkEPkhAk4OEX
         1nBRyjEabCGpamZnEC5Ni942wHdOAs3oy9IpcH8qFfLWy8dmatySX5nlfROXXqoX1ATt
         vzfcQr86txUBWI6VCUK8zra/ATxEPwmzAB4NnbgOOTYICwvB/mVjxRfVKV8ZUWPjbTYj
         xrhmNt4f9VNkhuGBCB2J8f6SE2wbNee8hRXv+AITCYPKYb6gMmme3R6S4kbQ+05DW4Xu
         UZRnSDMx9o21NF40DVpPyF/AwYcn3YF7nTmuXFIeWoSZFOASstyK79uNTxXs6rP//PXt
         ANeA==
X-Gm-Message-State: APjAAAWa082caaBe0EckV+rtxjJRJ7iyLhWWqdnAg9IqfG0/hzfV3ssS
        +Wzo3y+WulyxEBhzFf4Ip3a7+Z+EfYM=
X-Google-Smtp-Source: APXvYqxUpGqfQIeFzkdykpsx4GucwiH3PiumQo7qDKyVY48J1HUS5TzaldZd1dacu+JQQvudg+r5FA==
X-Received: by 2002:a37:9d44:: with SMTP id g65mr6283500qke.302.1573179627483;
        Thu, 07 Nov 2019 18:20:27 -0800 (PST)
Received: from cakuba ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id u27sm2564026qtj.5.2019.11.07.18.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 18:20:27 -0800 (PST)
Date:   Thu, 7 Nov 2019 21:20:24 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Message-ID: <20191107212024.61926e11@cakuba>
In-Reply-To: <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-12-parav@mellanox.com>
        <20191107153836.29c09400@cakuba.netronome.com>
        <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191107201750.6ac54aed@cakuba>
        <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
> > I'm talking about netlink attributes. I'm not suggesting to sprintf it all into
> > the phys_port_name.
> >  
> I didn't follow your comment. For devlink port show command output you said,
> 
> "Surely those devices are anchored in on of the PF (or possibly VFs)
> that should be exposed here from the start." 
> So I was trying to explain why we don't expose PF/VF detail in the
> port attributes which contains 
> (a) flavour
> (b) netdev representor (name derived from phys_port_name)
> (c) mdev alias
> 
> Can you please describe which netlink attribute I missed?

Identification of the PCI device. The PCI devices are not linked to
devlink ports, so the sysfs hierarchy (a) is irrelevant, (b) may not 
be visible in multi-host (or SmartNIC).

> > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>  
> > > >  
> > > > > @@ -6649,6 +6678,9 @@ static int  
> > > > __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,  
> > > > >  		n = snprintf(name, len, "pf%uvf%u",
> > > > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
> > > > >  		break;
> > > > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
> > > > > +		n = snprintf(name, len, "p%s", attrs->mdev.mdev_alias);  
> > > >
> > > > Didn't you say m$alias in the cover letter? Not p$alias?
> > > >  
> > > In cover letter I described the naming scheme for the netdevice of the
> > > mdev device (not the representor). Representor follows current unique
> > > phys_port_name method.  
> > 
> > So we're reusing the letter that normal ports use?
> >  
> I initially had 'm' as prefix to make it easy to recognize as mdev's port, instead of 'p', but during internal review Jiri's input was to just use 'p'.

Let's way for Jiri to weigh in then.

> > Why does it matter to name the virtualized device? In case of other reprs its
> > the repr that has the canonical name, in case of containers and VMs they
> > will not care at all what hypervisor identifier the device has.
> >   
> Well, many orchestration framework probably won't care of what name is picked up.
> And such name will likely get renamed to eth0 in VM or container.
> Unlike vxlan, macvlan interfaces, user explicitly specify the netdevice name, and when newlink() netlink command completes with success, user know the device to use.
> If we don't have persistent name for mdev, if a random name ethX is picked up, user needs refer to sysfs device hierarchy to know its netdev.
> Its super easy to do refer that, but having persistent name based out of alias makes things aligned like naming device on PCI bus.
> This way devices can be used without VM/container use cases too, for example user is interested in only 4 or 8 mdev devices in system and its setup is done through systemd.service.
