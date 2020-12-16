Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860CE2DBD65
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 10:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgLPJPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 04:15:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbgLPJPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 04:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608110038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlZr8e4b4QyEqbJXLhWMSpFHmJcnFFKnckGLJnj/rQc=;
        b=YwVOh6ZR7RhngYFEuE1QA4m6gW5SQ95xMJjFpEituiJ+RayGw/ciAQ/0IR3HMXks3DFAxj
        DkRsMquMB40cb5c6xHbCFq6u8AQcLox/s+cO+THY5u/zag8fhFuHXbzQiaiOFlSF0TisAR
        QP8vc/fss62OIgHrOrRn5xf3xSGGoR4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-fTPjuT1pPPypsmHgju2DbQ-1; Wed, 16 Dec 2020 04:13:56 -0500
X-MC-Unique: fTPjuT1pPPypsmHgju2DbQ-1
Received: by mail-wm1-f71.google.com with SMTP id r5so1085388wma.2
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 01:13:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xlZr8e4b4QyEqbJXLhWMSpFHmJcnFFKnckGLJnj/rQc=;
        b=h97QQQGM4euXMD+//0N249uat5LmLqaUXvLZETP5pSLLGqbQOZnJb5xr7IQg1qcDq9
         5OVCNT5Vb/JZSjDb4KsxrE47oLOEp0OKn0zqDATyhSlWEsAysnT6DoEuII9zAk8xUHbM
         Mm/oNH+Utvg3Aw72q4IAhTnvEV3sVuGARo3TFnpBhrWYwFbdBkcCKahpZ0BakXjfXhMk
         yIRW7PWwA2Q5avfUIGfHHrIVXAYKS71IEcyhJxumGvH+QU1hVrfkQiugUh0evNjToj6V
         WMOgoa9+eUCxQuNcuO/WEPj4lAxRcEK91BHKojKr1gqMww6mEQBD59yEvozCR87j6A7k
         TR8g==
X-Gm-Message-State: AOAM533b/2jCVlXq508gO4yiXhi1aTQ/oFlh6xtJ9a3z1J/HeFc1kaLB
        3owfSHraik5SYd0vhLEhCH3PL0OoWZofW/IytTibZiOCjfknb4fVsBXvEfnMPB751pgccB/uWL8
        BVZCmLqqpDu9yzNdv
X-Received: by 2002:a5d:488d:: with SMTP id g13mr36918134wrq.274.1608110035367;
        Wed, 16 Dec 2020 01:13:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyI3sJg2iK/Z+eccnrmwQSJxjia/Jdn5DdNW1wULhddirz2EPzKlyh5o9nq4APX2mKTbDY2QA==
X-Received: by 2002:a5d:488d:: with SMTP id g13mr36918110wrq.274.1608110035183;
        Wed, 16 Dec 2020 01:13:55 -0800 (PST)
Received: from redhat.com (bzq-109-67-15-113.red.bezeqint.net. [109.67.15.113])
        by smtp.gmail.com with ESMTPSA id p9sm1831190wmm.17.2020.12.16.01.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 01:13:54 -0800 (PST)
Date:   Wed, 16 Dec 2020 04:13:51 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] Introduce vdpa management tool
Message-ID: <20201216041303-mutt-send-email-mst@kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20201116142312.661786bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432205C97D1AAEC1E8731FD4DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB432205C97D1AAEC1E8731FD4DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 07:51:56PM +0000, Parav Pandit wrote:
> 
> 
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, November 17, 2020 3:53 AM
> > 
> > On Thu, 12 Nov 2020 08:39:58 +0200 Parav Pandit wrote:
> > > FAQs:
> > > -----
> > > 1. Where does userspace vdpa tool reside which users can use?
> > > Ans: vdpa tool can possibly reside in iproute2 [1] as it enables user
> > > to create vdpa net devices.
> > >
> > > 2. Why not create and delete vdpa device using sysfs/configfs?
> > > Ans:
> > 
> > > 3. Why not use ioctl() interface?
> > 
> > Obviously I'm gonna ask you - why can't you use devlink?
> > 
> This was considered.
> However it seems that extending devlink for vdpa specific stats, devices, config sounds overloading devlink beyond its defined scope.

kuba what's your thinking here? Should I merge this as is?

> > > Next steps:
> > > -----------
> > > (a) Post this patchset and iproute2/vdpa inclusion, remaining two
> > > drivers will be coverted to support vdpa tool instead of creating
> > > unmanaged default device on driver load.
> > > (b) More net specific parameters such as mac, mtu will be added.
> > 
> > How does MAC and MTU belong in this new VDPA thing?
> MAC only make sense when user wants to run VF/SF Netdev and vdpa together with different mac address.
> Otherwise existing devlink well defined API to have one MAC per function is fine.
> Same for MTU, if queues of vdpa vs VF/SF Netdev queues wants have different MTU it make sense to add configure per vdpa device.

