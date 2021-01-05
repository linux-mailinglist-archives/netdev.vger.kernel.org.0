Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127262EABDA
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbhAENZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 08:25:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728591AbhAENZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 08:25:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609853016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qYjuB5/l6vhggwtbdmp7b5rhdExSXPtz8f4X5n5pZWE=;
        b=BGFHA67uNsnoJzvQzcg7MVDt6cVjiRzodxqH6fmx6eaUqZunrvP4Fs/lK+C7ZitkogrHpo
        7Msy1utqoadWcvbY7qYDm2VZ2B9c08K+9qijgUKzuYW8S/mKq4gjfmQw9IOYBIyHnh2vm4
        7alY0Mnb1VR6YJVcIj2IG407j/PO5X0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-U-cQliwGMnOoNqR0WBTFjA-1; Tue, 05 Jan 2021 08:23:32 -0500
X-MC-Unique: U-cQliwGMnOoNqR0WBTFjA-1
Received: by mail-wr1-f69.google.com with SMTP id b8so14783384wrv.14
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 05:23:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qYjuB5/l6vhggwtbdmp7b5rhdExSXPtz8f4X5n5pZWE=;
        b=a1UKwJXbIVdzMZhX4I/sFBN/iqUc35zsMnmyS55mYLwvMpKZPoyde+jG7X/jxESaCV
         IZw7tWSqAFghIdstc6hBdvvZuA7niKW8DmbkWuN9NPaS9AW4xO09l60ZddGUOgjPbqhH
         P32625RVz8deQY6e1nTfGSfzt6z2PPY88YpzjL7YtvSQT2Aw9t++oSHASSf+mIIFMvRN
         GF/QCkcUUzF5XNAnhIjTz+++1CUVdjcchLzTRI6BueNhsvigmPlBii6Hbfzm+pN5qKla
         bjx9sHTAe1bpmLztyWeaEMOtTKy8fg294XtB7AZoDu2uDR/bBT+c7kYOWIm9XCLNuRo+
         Cgjw==
X-Gm-Message-State: AOAM531XZrezZMusSSmrOWAiDBEzATed2vwSxJI7Y1qlT8rVThGM8Ddr
        JgkGJfLZRY27JJGRHhYORJ/XVknTTdtGWv0UOrlOTZn4hdqc/5aez5/OIaagegGQknLM2wB5KNu
        qRLo8DsHS1t0zVpz5
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr3548020wmj.115.1609853011789;
        Tue, 05 Jan 2021 05:23:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP/0VjP00CAUsHLAsVLH2Av4b3D3yARUrqUVa8Fi5s1bbgwnRZ15/RvJVKZX/IWW534zbedw==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr3548012wmj.115.1609853011656;
        Tue, 05 Jan 2021 05:23:31 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id s6sm105436561wro.79.2021.01.05.05.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 05:23:31 -0800 (PST)
Date:   Tue, 5 Jan 2021 08:23:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Message-ID: <20210105082243-mutt-send-email-mst@kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210105071101-mutt-send-email-mst@kernel.org>
 <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB432235169D805760EC0CF7CEDCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 12:30:15PM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Tuesday, January 5, 2021 5:45 PM
> > 
> > On Tue, Jan 05, 2021 at 12:02:33PM +0000, Parav Pandit wrote:
> > >
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Tuesday, January 5, 2021 5:19 PM
> > > >
> > > > On Tue, Jan 05, 2021 at 12:32:03PM +0200, Parav Pandit wrote:
> > > > > Enable user to create vdpasim net simulate devices.
> > > > >
> > > > >
> > >
> > > > > $ vdpa dev add mgmtdev vdpasim_net name foo2
> > > > >
> > > > > Show the newly created vdpa device by its name:
> > > > > $ vdpa dev show foo2
> > > > > foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2
> > > > > max_vq_size 256
> > > > >
> > > > > $ vdpa dev show foo2 -jp
> > > > > {
> > > > >     "dev": {
> > > > >         "foo2": {
> > > > >             "type": "network",
> > > > >             "mgmtdev": "vdpasim_net",
> > > > >             "vendor_id": 0,
> > > > >             "max_vqs": 2,
> > > > >             "max_vq_size": 256
> > > > >         }
> > > > >     }
> > > > > }
> > > >
> > > >
> > > > I'd like an example of how do device specific (e.g. net specific)
> > > > interfaces tie in to this.
> > > Not sure I follow your question.
> > > Do you mean how to set mac address or mtu of this vdpa device of type
> > net?
> > > If so, dev add command will be extended shortly in subsequent series to
> > set this net specific attributes.
> > > (I did mention in the next steps in cover letter).
> > >
> > > > > +static int __init vdpasim_net_init(void) {
> > > > > +	int ret;
> > > > > +
> > > > > +	if (macaddr) {
> > > > > +		mac_pton(macaddr, macaddr_buf);
> > > > > +		if (!is_valid_ether_addr(macaddr_buf))
> > > > > +			return -EADDRNOTAVAIL;
> > > > > +	} else {
> > > > > +		eth_random_addr(macaddr_buf);
> > > > >  	}
> > > >
> > > > Hmm so all devices start out with the same MAC until changed? And
> > > > how is the change effected?
> > > Post this patchset and post we have iproute2 vdpa in the tree, will add the
> > mac address as the input attribute during "vdpa dev add" command.
> > > So that each different vdpa device can have user specified (different) mac
> > address.
> > 
> > For now maybe just avoid VIRTIO_NET_F_MAC then for new devices then?
> 
> That would require book keeping existing net vdpa_sim devices created to avoid setting VIRTIO_NET_F_MAC.
> Such book keeping code will be short lived anyway.
> Not sure if its worth it.
> Until now only one device was created. So not sure two vdpa devices with same mac address will be a real issue.
> 
> When we add mac address attribute in add command, at that point also remove the module parameter macaddr.

Will that be mandatory? I'm not to happy with a UAPI we intend to break
straight away ...

-- 
MST

