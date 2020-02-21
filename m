Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC84716860E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgBUSEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:04:30 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42424 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgBUSE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:04:29 -0500
Received: by mail-qk1-f194.google.com with SMTP id o28so2617658qkj.9
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IvOXCotP7OctVlF/hDyZgg9xC6oqeT5r/ULL0/51mBY=;
        b=gkQ70iBhG6Oa8bGD95caNxR4SeDTfeFj4wZYcntAOnjiNg4Lc5j4DF4KE0WK8k1lm3
         Z4Cqu+vE3SEmQCc252K46C2U2HryVK+qyKeu2VNin6StqWTyz4CsKtssEfYGzNQYwdvd
         wQ5BJEfCajuaxSGrfEqLteL21RIa8kg2HaKf2yMMcTNAFFAwCHMbinqmiyW43peXT1cd
         LBniG/Yie8mx6P8Yw5+02CJthTc6MEwEJGdr7wMk1si8Y5rqxKNzTfRLFQjXjKkV6Xnt
         Q5+fbJLtSVubEnylDSJ/MczAMKXY8GYXo+ZzY8s9V/zqQ7OhjQB0lMRisGJBI5qsuWY8
         mvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IvOXCotP7OctVlF/hDyZgg9xC6oqeT5r/ULL0/51mBY=;
        b=jEm2s1wTOCp3eHet5afOqLZXMigiFnFnIMDJSKxcWZ28naiPMUa50orQqVezE3HThO
         4OjMmNnzRSrxsj2oLd+iUUDIrUdekKoGyMvsofRoAcKsmz1cdHc8vVAETDNJw9XMz73l
         vl8Huqhd7Ar90N5PuzpCruSt+/bRfgHYOXeZxY9RhdgulcrAjPkTAyh+22gbVIKo8OoN
         kJ4qOMD4F2XUJn0rFPtNhcNp+et+7+Kwx6A+pdO25FtcTCziEx//KKSfSlpNb923g1A8
         475/e8MaulYYmuLOG+pKL0PGl5L8WkC0BSgReUGEHD4kK3Y1X+uWI0aorH5Y6QUv869a
         sI/Q==
X-Gm-Message-State: APjAAAXwedjwfK7O/0Ce86S53Gjfh+XglCV/b5vhRJhRuae6q1ds2hRX
        3oXYYNoSoLA39l4MmCSa8LMeJA==
X-Google-Smtp-Source: APXvYqxoVJVfaiFqNyqZBDuiDMYGihKMwDTgkPjYWAjdWMdjSTjoYUjJ7DGFxe+gb1/Z8lwL8TV9FQ==
X-Received: by 2002:ae9:e841:: with SMTP id a62mr31589186qkg.384.1582308268719;
        Fri, 21 Feb 2020 10:04:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id t2sm1884307qkc.31.2020.02.21.10.04.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 21 Feb 2020 10:04:28 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j5Cf5-0004Yy-NR; Fri, 21 Feb 2020 14:04:27 -0400
Date:   Fri, 21 Feb 2020 14:04:27 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework definitions
Message-ID: <20200221180427.GL31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
 <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <9DD61F30A802C4429A01CA4200E302A7C60CE4C4@fmsmsx124.amr.corp.intel.com>
 <b8263bea-fd0f-345e-b497-d5531dc63554@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8263bea-fd0f-345e-b497-d5531dc63554@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 05:23:31PM +0000, Parav Pandit wrote:
> On 2/21/2020 11:01 AM, Saleem, Shiraz wrote:
> >> Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
> >> definitions
> >>
> > 
> > [....]
> > 
> >>>>> +static int irdma_devlink_reload_up(struct devlink *devlink,
> >>>>> +				   struct netlink_ext_ack *extack) {
> >>>>> +	struct irdma_dl_priv *priv = devlink_priv(devlink);
> >>>>> +	union devlink_param_value saved_value;
> >>>>> +	const struct virtbus_dev_id *id = priv->vdev->matched_element;
> >>>>
> >>>> Like irdma_probe(), struct iidc_virtbus_object *vo is accesible for
> >>>> the given
> >>> priv.
> >>>> Please use struct iidc_virtbus_object for any sharing between two drivers.
> >>>> matched_element modification inside the virtbus match() function and
> >>>> accessing pointer to some driver data between two driver through
> >>>> this matched_element is not appropriate.
> >>>
> >>> We can possibly avoid matched_element and driver data look up here.
> >>> But fundamentally, at probe time (see irdma_gen_probe) the irdma
> >>> driver needs to know which generation type of vdev we bound to. i.e. i40e or ice
> >> ?
> >>> since we support both.
> >>> And based on it, extract the driver specific virtbus device object,
> >>> i.e i40e_virtbus_device vs iidc_virtbus_object and init that device.
> >>>
> >>> Accessing driver_data off the vdev matched entry in
> >>> irdma_virtbus_id_table is how we know this generation info and make the
> >> decision.
> >>>
> >> If there is single irdma driver for two different virtbus device types, it is better to
> >> have two instances of virtbus_register_driver() with different matching string/id.
> >> So based on the probe(), it will be clear with virtbus device of interest got added.
> >> This way, code will have clear separation between two device types.
> > 
> > Thanks for the feedback!
> > Is it common place to have multiple driver_register instances of same bus type
> > in a driver to support different devices? Seems odd.
> > Typically a single driver that supports multiple device types for a specific bus-type
> > would do a single bus-specific driver_register and pass in an array of bus-specific
> > device IDs and let the bus do the match up for you right? And in the probe(), a driver could do device
> > specific quirks for the device types. Isnt that purpose of device ID tables for pci, platform, usb etc?
> > Why are we trying to handle multiple virtbus device types from a driver any differently?
> > 
> 
> If differences in treating the two devices is not a lot, if you have lot
> of common code, it make sense to do single virtbus_register_driver()
> with two different ids.
> In that case, struct virtbus_device_id should have some device specific
> field like how pci has driver_data.
> 
> It should not be set by the match() function by virtbus core.
> This field should be setup in the id table by the hw driver which
> invokes virtbus_register_device().

Yes

I think the basic point here is that the 'id' should specify what
container_of() is valid on the virtbus_device

And for things like this where we want to make a many to one
connection then it makes sense to permute the id for each 'connection
point'

ie, if the id was a string like OF uses maybe you'd have

 intel,i40e,rdma
 intel,i40e,ethernet
 intel,ice,rdma

etc

A string for match id is often a good idea..

And I'd suggest introducing a matching alloc so it is all clear and
type safe:

   struct mydev_struct mydev;

   mydev = virtbus_alloc(parent, "intel,i40e,rdma", struct mydev_struct,
                         vbus_dev);


   [..]
   virtbus_register(&mydev->vbus_dev);

Jason
