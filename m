Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1853115E61E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394030AbgBNQp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:45:56 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44075 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394011AbgBNQp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:45:56 -0500
Received: by mail-qv1-f65.google.com with SMTP id n8so4534274qvg.11
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 08:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6zMAV6opT8F4IR1EmzI6ROBaFFltfgM895kUaotRIlk=;
        b=oNniTQAWE+1pH7ooqR0szPphGeNMfhxh0K7p07S3hqK3YV8+Aes8Eb32kL0g+XbGCQ
         tZTSWIurEjn2VjNJGS4dkuitS7jaRUJlDOsRFMYf+yZvusk2yC2vRxp6+SUha9lbwLPj
         K/aiKYG445wnrz7BD+AJh6emWHCrnd2TqN4I8bFP5Pu4jARATLSwVNU0n9it+fGx/+Wo
         i4H2rDyDIV3e2v9AybQXyYP5BJ6EXFhmupT8MQ+b1Vn4geVLh9xESJEVmDd3DnBR9xMr
         pY7nAEPWnZ3hinT0yhPJa5O9MlrNoTqAwJYANNJsqpQzuYYawT26BlUjYviy8Rxzpegj
         KVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6zMAV6opT8F4IR1EmzI6ROBaFFltfgM895kUaotRIlk=;
        b=A+Ha+nVb/qDye78S13J6K9FN9K9NwStbauQjvuOlm67C5dFK//qDfD9UrQcdI5rUg7
         e65NeAjKCQdXMRh+IpNl453ajkZWU2HBbdm+fIXeOWN1VI0XJghPTM17NpTIPqgjFhLl
         RUIl8tHjSmuZxzroigaFOgIHSCYEYTDgvjMjjwotWVtHaKhmLCIGbbMywvY+G86frvxs
         spQoaR3Al5u5tfbYfu5a6/uHketRmbhE3wkx3FiU5nD+Ko3qVXxjuOg96zvzfoZW93EB
         LEWGlHoV2oygSUFMTVMZOT4KjS/WkDXACZdeWg0TBAobG18m69ZPVOYzHPr8g+DFrgti
         4VGw==
X-Gm-Message-State: APjAAAVqNOAOgCWR9nZniOD6mossMoqUpIGqxpl0/WxcirwSaCGodf/j
        qlcQIV5KbJd8tESf1oqVWT21xg==
X-Google-Smtp-Source: APXvYqwyqbVW2l3NU+TGVwqM1Q2R64Pbxb1BEV1d5U3mEZkqfT6cMit9OEAbxJF0vAUFwm5AzEvPfQ==
X-Received: by 2002:a0c:fe8d:: with SMTP id d13mr2983695qvs.217.1581698754942;
        Fri, 14 Feb 2020 08:45:54 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d20sm1734570qkg.8.2020.02.14.08.45.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 08:45:54 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j2e6D-0001DP-RH; Fri, 14 Feb 2020 12:45:53 -0400
Date:   Fri, 14 Feb 2020 12:45:53 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Andrew Boyer <aboyer@pensando.io>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v4 18/25] RDMA/irdma: Implement device supported verb
 APIs
Message-ID: <20200214164553.GV31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-19-jeffrey.t.kirsher@intel.com>
 <20200214145443.GU31668@ziepe.ca>
 <E686D00B-5B27-4463-ADB1-D01588621138@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E686D00B-5B27-4463-ADB1-D01588621138@pensando.io>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 10:49:38AM -0500, Andrew Boyer wrote:
> 
> > On Feb 14, 2020, at 9:54 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Wed, Feb 12, 2020 at 11:14:17AM -0800, Jeff Kirsher wrote:
> > ...
> > New drivers are forbidden from calling this:
> > 
> > /**
> > * rdma_set_device_sysfs_group - Set device attributes group to have
> > *				 driver specific sysfs entries at
> > *				 for infiniband class.
> > *
> > * @device:	device pointer for which attributes to be created
> > * @group:	Pointer to group which should be added when device
> > *		is registered with sysfs.
> > * rdma_set_device_sysfs_group() allows existing drivers to expose one
> > * group per device to have sysfs attributes.
> > *
> > * NOTE: New drivers should not make use of this API; instead new device
> > * parameter should be exposed via netlink command. This API and mechanism
> > * exist only for existing drivers.
> > */
> > 
> > Jason
> 
> Is there an existing field in RDMA_NLDEV_ATTR_* that allows us to
> display a string to use as a replacement for the board_id in sysfs?

I don't think so, this is highly vendor specific stuff.

> Like “Mellanox ConnectX-3” or similar.

General names like that can come from the pci database that udev and
lspci keeps. Ie if you do 'systemctl -a' on a modern system with
rdma-core you will see the PCI device description show up next to the
verbs char device.

> The other two sysfs fields (hca_type and hw_rev) seem to have been unused.

I wonder if hw_rev was supposed to be the same as hw_ver (see
ib_uverbs_query_device_resp).

Jason
