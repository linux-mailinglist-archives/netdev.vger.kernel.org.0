Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5B2DC9D8
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgLQAMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730802AbgLQAMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:12:36 -0500
Date:   Wed, 16 Dec 2020 16:11:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608163915;
        bh=ou6Soac3S6dbWdy24RVNUAaduWHENUjupbKslAWzNnE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=UjaIxCjuhKbIra6Uivle1mc10pr5jAQQsqQRdw909udq60DfgLjOS43ZcdTFK+ib/
         KjstJ6vEfvspPTcgX5cqrZQWFXk5aXkNDHPooCB4SWu4Q77JXl3bdX9ewd3H55YPGH
         JYslxyW2RHCu7jsxIOVUaiaG0Lh5YZgA0ZTRXK51o+mXssplWqQ2SGTfdfZVv8HLC+
         BL4bNn0lB2lHQhxtzpeEXAwpDVtTVynrh+4hOnp+6eM93ja77c79ri7xBKLjO11y2/
         MpGOgGp5PBMajIKVxVTaxVnALFOTx6WjQOow7K7W04OdEz/9+m51+mAM5EMC2yipGp
         87tSehVSkfqgQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Message-ID: <20201216161154.69e367fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
        <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 05:19:15 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, December 16, 2020 6:14 AM
> > 
> > On Tue, 15 Dec 2020 01:03:50 -0800 Saeed Mahameed wrote:  
> > > +static ssize_t sfnum_show(struct device *dev, struct device_attribute
> > > +*attr, char *buf) {
> > > +	struct auxiliary_device *adev = container_of(dev, struct  
> > auxiliary_device, dev);  
> > > +	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev,
> > > +adev);
> > > +
> > > +	return scnprintf(buf, PAGE_SIZE, "%u\n", sf_dev->sfnum); } static
> > > +DEVICE_ATTR_RO(sfnum);
> > > +
> > > +static struct attribute *sf_device_attrs[] = {
> > > +	&dev_attr_sfnum.attr,
> > > +	NULL,
> > > +};
> > > +
> > > +static const struct attribute_group sf_attr_group = {
> > > +	.attrs = sf_device_attrs,
> > > +};
> > > +
> > > +static const struct attribute_group *sf_attr_groups[2] = {
> > > +	&sf_attr_group,
> > > +	NULL
> > > +};  
> > 
> > Why the sysfs attribute? Devlink should be able to report device name so
> > there's no need for a tie in from the other end.  
> There isn't a need to enforce a devlink instance creation either,

You mean there isn't a need for the SF to be spawned by devlink?

> those mlx5 driver does it.

Really, no idea what you're trying to say. Read your emails before
you send them.

> systemd/udev looks after the sysfs attributes, so its parent device, similar to how phys_port_name etc looked for representor side.

