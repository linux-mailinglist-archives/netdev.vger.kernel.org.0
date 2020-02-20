Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C81216671D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 20:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgBTT1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 14:27:47 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:35576 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgBTT1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 14:27:47 -0500
Received: by mail-qv1-f67.google.com with SMTP id u10so2441054qvi.2
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 11:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nUozYIkh0i8DU+wPMPYypmV4LSBzg3fvJQVbP0NF19U=;
        b=aVVlxkmEL23fXzjpVt1O/bNwtvN016VPrPsihJn7xfGuAXQc6nQFH8CGmIjKLsKpRw
         dlp+/astzBJYJQsd+HcMBsAvwmcxqnPC2L9gNMZuLLBz9iwqwaho58RC27GiJ6XeD1ka
         nFxvBGqfHERvZAZjeTAKKd1fW5d8Qph6hQz/mSGwcA2O/q98E7vwcKyhuKxpWjHZu63A
         sAIG7psOeVl3A/UWwaE1bcehaUS5B29jm5M5pxuos0fX175q8RYD/Fsfg5m5/M5/vk+i
         rE23UcmQC7c7F+vh/0tOpKz8su539jJZoNFLCIwZmDEQrEMp2KVa+jbmlPfMBW4d/hia
         VXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nUozYIkh0i8DU+wPMPYypmV4LSBzg3fvJQVbP0NF19U=;
        b=WnZKGP3kwKamXtFsy8Bjmx/xM65TDsP7svgzRqaT4d+0pcDT2PhdRTfQoGR76V3WkT
         74Ub8YpjNbiIr6ya6PterD7VIK5JSDS/lt34wISdaVxqPDmNVvF9gIybCPEOCMHDlC4A
         w0Qq8FxHfYbJNnCle/FGR8xbNyx/j2R73M8J6As7rKlxgg4B3gQvcI53UqYZGS928KxW
         3R6NjbjKVo+V8RKz1U+isuP6Kb3t8uedFGOo6qic18jpBhUJPIyakLCjAfsS37PWLegW
         Krdyz/6HJwJHgGK9lZqHsbb4LnCfWVuQj1fcr/AV2wV3jOlcVOdqO2S6zCV6rr4ZoWkS
         AIAA==
X-Gm-Message-State: APjAAAW9lFMxQBgZQY8wYgIsIVi/cvM7krMKGDHindhOX65NgYdTmmje
        kVUQTJvyVAuY1ZBv0u3Q7paXjA==
X-Google-Smtp-Source: APXvYqzdvdh4nMl++9Dc7ZrNJO23gvdzS8NJbsAVUjtvTxPN8Dtttw4XRUj+5/HNbSpuM4HGiYxzYg==
X-Received: by 2002:a0c:ab13:: with SMTP id h19mr26696830qvb.243.1582226864726;
        Thu, 20 Feb 2020 11:27:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id m27sm288868qta.21.2020.02.20.11.27.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Feb 2020 11:27:44 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j4rU7-0007w0-S2; Thu, 20 Feb 2020 15:27:43 -0400
Date:   Thu, 20 Feb 2020 15:27:43 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: Re: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Message-ID: <20200220192743.GD31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
 <20200214170240.GA4034785@kroah.com>
 <20200214203455.GX31668@ziepe.ca>
 <20200214204500.GC4086224@kroah.com>
 <DM6PR11MB2841DDF7EEA187B368FFDE53DD130@DM6PR11MB2841.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB2841DDF7EEA187B368FFDE53DD130@DM6PR11MB2841.namprd11.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 06:55:28PM +0000, Ertman, David M wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Friday, February 14, 2020 12:45 PM
> > To: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> > Ertman, David M <david.m.ertman@intel.com>; netdev@vger.kernel.org;
> > linux-rdma@vger.kernel.org; nhorman@redhat.com;
> > sassmann@redhat.com; parav@mellanox.com; galpress@amazon.com;
> > selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> > benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> > yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> > aditr@vmware.com; Patil, Kiran <kiran.patil@intel.com>; Bowers, AndrewX
> > <andrewx.bowers@intel.com>
> > Subject: Re: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
> > 
> > On Fri, Feb 14, 2020 at 04:34:55PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Feb 14, 2020 at 09:02:40AM -0800, Greg KH wrote:
> > > > > +	put_device(&vdev->dev);
> > > > > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > > >
> > > > You need to do this before put_device().
> > >
> > > Shouldn't it be in the release function? The ida index should not be
> > > re-used until the kref goes to zero..
> 
> The IDA should not be reused until the virtbus_device is unregistered.  We
> don't want another device with the same name and same IDA to be
> registered,

Unregistration of the virtbus_device always happens before release.

release is the point when the kref goes to zero and you can be
confident there are no other threads reading the index or the device
name.

Remember, the put_device() above is not guarenteed to be the one that
calls to release..

Jason
