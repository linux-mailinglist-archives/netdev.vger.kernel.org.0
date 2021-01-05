Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8558D2EAA87
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbhAEMQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:16:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbhAEMQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:16:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609848904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GzsOsVwoB44yWUjZKrE3hGQLq4CO80CE1lp9CnWnymQ=;
        b=bWADp97tJed3guyOl+MFqBdAgszBvQu5nWloRBFlkA/oAk5N0vAIQxq9fpcdMQghbc3Wns
        cTh0mhQ8ZcNKhezzh6BiVAVBpUEzReHN/Xv/51cThGbWXCDB8XXPpQ1GCckmFfQKcayJfC
        yDCOCEloapjAAvZS4WsXYp1UoqGIrfo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-hLQXNMPDOxuU2_2IV_vjpg-1; Tue, 05 Jan 2021 07:15:02 -0500
X-MC-Unique: hLQXNMPDOxuU2_2IV_vjpg-1
Received: by mail-wr1-f72.google.com with SMTP id b8so14705466wrv.14
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GzsOsVwoB44yWUjZKrE3hGQLq4CO80CE1lp9CnWnymQ=;
        b=Ck2hLUIafPWYpPLSRhJVnoLiLXbDTu8PjY6tFsGe1yBPdgz+0ZD6e+n3q/zx0V4GcH
         A9lbIuNvoHvNekf4B+oFKIYAUnxjODwIAdhohhmfelFhCGKM/y44v0K0Hbkq0F303qx/
         Xb97Zl8ZH4VGF9f9ot3DwwoSP75dVMx63xiPnn07LV5HPw3T6Yus0vTBpSJCi6kEoMK/
         sZvpGsUx0pVzoKTMOSEicnLeHQddpu7BosBksyZD6t45kd/wcIw0UZ2LO/sRQz6j2m2o
         22SATYuKomBm54IT5vgbyb3EavA3NlZbT6qaYA/aXtIFFBkDUmFhzcKn+OHdLTsLpP2W
         rOfg==
X-Gm-Message-State: AOAM5323UaOHEz0BcLDYUO61GGDgq5Eqknj4yxIbs9tosYr7v82emUiD
        yWAUhowJCd0Jwdh9OQhDLip5Y27MXgQ3Udq4tv3FQYx/cmb0+RXbTkFNrd342c9tIs9BUi6ycPY
        wNE8XhHIdcnw+5RM5
X-Received: by 2002:a1c:e083:: with SMTP id x125mr3377042wmg.0.1609848901055;
        Tue, 05 Jan 2021 04:15:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5tY2rNfqYCNDGjnQqFotIxEadv9niP5oP+t2XfwMjWrLkhpl0wfHyjjmDWhZlA2s5E9RVwA==
X-Received: by 2002:a1c:e083:: with SMTP id x125mr3377034wmg.0.1609848900907;
        Tue, 05 Jan 2021 04:15:00 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id a17sm99413423wrs.20.2021.01.05.04.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 04:15:00 -0800 (PST)
Date:   Tue, 5 Jan 2021 07:14:57 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH linux-next v3 6/6] vdpa_sim_net: Add support for user
 supported devices
Message-ID: <20210105071101-mutt-send-email-mst@kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210105103203.82508-1-parav@nvidia.com>
 <20210105103203.82508-7-parav@nvidia.com>
 <20210105064707-mutt-send-email-mst@kernel.org>
 <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB4322E5E7CA71CB2EE0577706DCD10@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 12:02:33PM +0000, Parav Pandit wrote:
> 
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Tuesday, January 5, 2021 5:19 PM
> > 
> > On Tue, Jan 05, 2021 at 12:32:03PM +0200, Parav Pandit wrote:
> > > Enable user to create vdpasim net simulate devices.
> > >
> > >
> 
> > > $ vdpa dev add mgmtdev vdpasim_net name foo2
> > >
> > > Show the newly created vdpa device by its name:
> > > $ vdpa dev show foo2
> > > foo2: type network mgmtdev vdpasim_net vendor_id 0 max_vqs 2
> > > max_vq_size 256
> > >
> > > $ vdpa dev show foo2 -jp
> > > {
> > >     "dev": {
> > >         "foo2": {
> > >             "type": "network",
> > >             "mgmtdev": "vdpasim_net",
> > >             "vendor_id": 0,
> > >             "max_vqs": 2,
> > >             "max_vq_size": 256
> > >         }
> > >     }
> > > }
> > 
> > 
> > I'd like an example of how do device specific (e.g. net specific) interfaces tie
> > in to this.
> Not sure I follow your question.
> Do you mean how to set mac address or mtu of this vdpa device of type net?
> If so, dev add command will be extended shortly in subsequent series to set this net specific attributes.
> (I did mention in the next steps in cover letter).
> 
> > > +static int __init vdpasim_net_init(void) {
> > > +	int ret;
> > > +
> > > +	if (macaddr) {
> > > +		mac_pton(macaddr, macaddr_buf);
> > > +		if (!is_valid_ether_addr(macaddr_buf))
> > > +			return -EADDRNOTAVAIL;
> > > +	} else {
> > > +		eth_random_addr(macaddr_buf);
> > >  	}
> > 
> > Hmm so all devices start out with the same MAC until changed? And how is
> > the change effected?
> Post this patchset and post we have iproute2 vdpa in the tree, will add the mac address as the input attribute during "vdpa dev add" command.
> So that each different vdpa device can have user specified (different) mac address.

For now maybe just avoid VIRTIO_NET_F_MAC then for new devices then?

-- 
MST

