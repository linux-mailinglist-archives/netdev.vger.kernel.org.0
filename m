Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA272DC772
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgLPT7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:59:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgLPT7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608148664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dZZQKs4bp+ifj63PZO0dxaf27I/XYf/Zcar+TijNLXw=;
        b=Dydmq+s4w6D/Cl4EgmRseyijASK+xSL7Ggu8el2n6Az88H0Gp+GXZLSGOP3ItqblSz4eE2
        SpXSAbBuV/hFCHggDnpjSZZCB8tKvtj/eICKM5rwv/eycnM9/lU8oB9HZizsfIN3FSuah1
        s/l02gJaU5S7ezpMvxuz8Mun2fYfvmc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-gRgg6BzGNdmy22qOT3SCvA-1; Wed, 16 Dec 2020 14:57:42 -0500
X-MC-Unique: gRgg6BzGNdmy22qOT3SCvA-1
Received: by mail-wm1-f71.google.com with SMTP id k128so2068199wme.7
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:57:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dZZQKs4bp+ifj63PZO0dxaf27I/XYf/Zcar+TijNLXw=;
        b=SFAmzAZ0ZRbB/3WSyE49o6/1wA3hMQn7h36eo2tH1XeTlFHiuvkw4+2wyipt6+FWqo
         PVSvj2tWpfS656tlJDPLumqAbpeHMvwbLWtfOH2uugd0RkOIY/MByKV8yfvSsSvdkfKZ
         jrgnSVtGIucrLHSFOlwreWSX8ke2/JaFI4h7S6vaCAtJ70bxbAnKSTziRGOoxiBvynpD
         WWozr/jDD80+paZ+nPeiDcqERH0gvRmUkQYt+iGmck31tKiixFOdaWAZnHh73w9C+p6r
         nIYE0N17GKDm485RnfLX1Oou1ySwuECgoaSYH3jivJ8r3SwAL4ykiQIMtppZ04WlpdZv
         ec5A==
X-Gm-Message-State: AOAM533gTJA9qcGomU5N6icmHV0DSz/iR6AtcKkNuWQEE3GAGGajQ+SI
        qXF8sB3uRi2eiK9V4TTJtUruJ2iVoZjWT07whdvnBzUbyYFbAg81cpiF7r5hvG9nysVsv7iWKgb
        RA4i3K+M2sF9Blv0N
X-Received: by 2002:adf:e84f:: with SMTP id d15mr40434602wrn.245.1608148661110;
        Wed, 16 Dec 2020 11:57:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJykOSySwK5/71U8nP5csaea+VdY5+sa9sCXKklxURZoKJ75YDToIwEQqq/BVfRShwNTFoTyJw==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr40434596wrn.245.1608148660918;
        Wed, 16 Dec 2020 11:57:40 -0800 (PST)
Received: from redhat.com (bzq-109-67-15-113.red.bezeqint.net. [109.67.15.113])
        by smtp.gmail.com with ESMTPSA id p9sm4049976wmm.17.2020.12.16.11.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:57:40 -0800 (PST)
Date:   Wed, 16 Dec 2020 14:57:37 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] Introduce vdpa management tool
Message-ID: <20201216145724-mutt-send-email-mst@kernel.org>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20201116142312.661786bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432205C97D1AAEC1E8731FD4DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201216041303-mutt-send-email-mst@kernel.org>
 <20201216080610.08541f44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43227CBBF9A5CED02D74CA79DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43227CBBF9A5CED02D74CA79DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 04:54:37PM +0000, Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, December 16, 2020 9:36 PM
> > 
> > On Wed, 16 Dec 2020 04:13:51 -0500 Michael S. Tsirkin wrote:
> > > > > > 3. Why not use ioctl() interface?
> > > > >
> > > > > Obviously I'm gonna ask you - why can't you use devlink?
> > > > >
> > > > This was considered.
> > > > However it seems that extending devlink for vdpa specific stats, devices,
> > config sounds overloading devlink beyond its defined scope.
> > >
> > > kuba what's your thinking here? Should I merge this as is?
> > 
> > No objections from me if people familiar with VDPA like it.
> 
> I was too occupied with the recent work on subfunction series.
> I wanted to change the "parentdev" to "mgmtdev" to make it little more clear for vdpa management tool to see vdpa mgmt device and operate on it.
> What do you think? Should I revise v2 or its late?

I need a rebase anyway, so sure.

-- 
MST

