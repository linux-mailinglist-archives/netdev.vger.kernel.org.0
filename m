Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D701AF3D57
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfKHBRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:17:55 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:35147 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfKHBRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:17:55 -0500
Received: by mail-qv1-f65.google.com with SMTP id y18so1616702qve.2
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 17:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=q6xlZKp1FmiyBYDuRvWEgcHuXDfy0uBqqo0d2wzNJjk=;
        b=SgszKXp+Bh6X72c6ZgrD244PjjG0EOo12EZqDs1K7snEUFA4fgWAOdHBJeMug4frdY
         oAIRyS0Dzl77gWfwbvVpKa/nrsRoTseE+09SHBQyc56PfbOI0aJXj4nUVRggclgHa45s
         Eo3745ePjRlt0wTcYILx7tAX2qTM28UQJN1WXdtKtyM3k25tnOC3Dr5BPxRLB8y/78iV
         NxuGe38SK5Q5q2Li4e+5aW4RY0ryWeXcK2f9X6XlG086cQDq7rWZPYyb+OY7/yPgegHy
         Gjb7o2usFlvfgF36K542uG3NpOu3W89HPTzqJo6nmH6KOiMquVtTAdVE/dx+few/+QR5
         WlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=q6xlZKp1FmiyBYDuRvWEgcHuXDfy0uBqqo0d2wzNJjk=;
        b=N4uL5D9Hvo3TD6G07Xm4g5sKPp94bJ69dJRwmDp2USFxAcXWO3JC3IT2fZ9ibAGy78
         lHbuiWLZRUuwdSsaAcxxy9XhJGrbNwqKhqKlvvAq11vELAlxV51VSWSuNiKBikGIbWy2
         pTkxvMna+xMefgKfANNG4jvhsGPZM23fPto2f1dcSGFcAsqqFGVm72/XWPPGXM/nLFQ+
         jxCfaPjtE5QTCv0a8W7VexEcOFokNEwqThafX96DMheZzDA6LNw8NRPzvzraERhYIBJf
         mhtardmzsBgQn6sooNDgytxcQtZTQEAwPKiBbUFmugjsbrKWXHceKFB2wuR44jSfJmu1
         5WsQ==
X-Gm-Message-State: APjAAAWYpevrO2uIinrUFIXNXEsIZnHJq101H7lWEggHY6LY6laQNut1
        +gnaUphRsRIyoQ9KmfBUakxND/thnl8=
X-Google-Smtp-Source: APXvYqxuEoLlUtuNZj5stZuH8R1e/xB4LZQ/XFGr9Nb4gHb8ESeDGljNTqJTvH71Xej2ZW7vwHiFzA==
X-Received: by 2002:a0c:d09b:: with SMTP id z27mr6806500qvg.168.1573175873819;
        Thu, 07 Nov 2019 17:17:53 -0800 (PST)
Received: from cakuba ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id u4sm2117942qkd.105.2019.11.07.17.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 17:17:53 -0800 (PST)
Date:   Thu, 7 Nov 2019 20:17:50 -0500
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
Message-ID: <20191107201750.6ac54aed@cakuba>
In-Reply-To: <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-12-parav@mellanox.com>
        <20191107153836.29c09400@cakuba.netronome.com>
        <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 21:03:09 +0000, Parav Pandit wrote:
> > Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
> > 
> > On Thu,  7 Nov 2019 10:08:27 -0600, Parav Pandit wrote:  
> > > Introduce a new mdev port flavour for mdev devices.
> > > PF.
> > > Prepare such port's phys_port_name using unique mdev alias.
> > >
> > > An example output for eswitch ports with one physical port and one
> > > mdev port:
> > >
> > > $ devlink port show
> > > pci/0000:06:00.0/65535: type eth netdev p0 flavour physical port 0
> > > pci/0000:06:00.0/32768: type eth netdev p1b0348cf880a flavour mdev
> > > alias 1b0348cf880a  
> > 
> > Surely those devices are anchored in on of the PF (or possibly VFs) that should
> > be exposed here from the start.
> >   
> They are anchored to PCI device in this implementation and all mdev device has their parent device too.
> However mdev devices establishes their unique identity at system level using unique UUID.
> So prefixing it with pf0, will shorten the remaining phys_port_name letter we get to use.
> Since we get unique 12 letters alias in a system for each mdev, prefixing it with pf/vf is redundant.
> In case of VFs, given the VF numbers can repeat among multiple PFs, and representor can be over just one eswitch instance, it was necessary to prefix.
> Mdev's devices parent PCI device is clearly seen in the PCI sysfs hierarchy, so don't prefer to duplicate it.

I'm talking about netlink attributes. I'm not suggesting to sprintf it
all into the phys_port_name.

> > > Signed-off-by: Parav Pandit <parav@mellanox.com>  
> >   
> > > @@ -6649,6 +6678,9 @@ static int  
> > __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,  
> > >  		n = snprintf(name, len, "pf%uvf%u",
> > >  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
> > >  		break;
> > > +	case DEVLINK_PORT_FLAVOUR_MDEV:
> > > +		n = snprintf(name, len, "p%s", attrs->mdev.mdev_alias);  
> > 
> > Didn't you say m$alias in the cover letter? Not p$alias?
> >   
> In cover letter I described the naming scheme for the netdevice of
> the mdev device (not the representor). Representor follows current
> unique phys_port_name method.

So we're reusing the letter that normal ports use?

Why does it matter to name the virtualized device? In case of other
reprs its the repr that has the canonical name, in case of containers
and VMs they will not care at all what hypervisor identifier the device
has.

> > > +		break;
> > >  	}
> > >
> > >  	if (n >= len)  
