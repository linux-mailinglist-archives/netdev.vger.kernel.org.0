Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F4143F24
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgAUOPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:15:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728896AbgAUOP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579616128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W0ISVuuIVoP4ewOzYniLTSVuw4vxN7wzv55HQyIkjTg=;
        b=h4ZhI6tJ0ZGLNKmQW6E/yqK5rmSiupoPALGx5YeXw9CqjVZgPozJiDncMnjEdg7rx2SHm/
        x/qsPQKc9c744GuvrO4zKfdYmMlTOsaY+DNXxHV1CmUDx+5sVzFqhAQip7hU1gTWKcO43L
        uJSoCmOh/RuhYfT5zv/4Oo0oUNlfhgQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-7SBnS4f4OamtAccLdOoLRA-1; Tue, 21 Jan 2020 09:15:25 -0500
X-MC-Unique: 7SBnS4f4OamtAccLdOoLRA-1
Received: by mail-qv1-f70.google.com with SMTP id e14so1656314qvr.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W0ISVuuIVoP4ewOzYniLTSVuw4vxN7wzv55HQyIkjTg=;
        b=kLjciHtEdVmenG41wstloouZYoVXseh2Cm2FT3ndKODhdm+Te1Tt5v36md5iFJEWXW
         ZhDEII/OnUaH6KN9oEn86yA0qqUEFJAr4qiXRL3VC5vK07SVTNgC9NxyG/fwgjXZz6EJ
         9wh4dmHCgqNZ6GVmUdVrlvJFWeb0mmXcM3Ax5GlqnwfSvSE2elPQYLznLViNc3twtAH8
         x2bo/2bFjdMPioXWWhDRm1grmTRPLp+B9WzVnOsNiYtCx82yJRD2+UwhF73coAY7W9fI
         KQ01VxfSlqDVovs8Gk6CPug/JX5bs4E87p6jrXsStPHK7tGWmCDST/BUxv6+Km9Ny8qw
         Bofw==
X-Gm-Message-State: APjAAAUKey3UM7Wbe9oDh2zpQGLoF9zZ0IRnqArCZh0sgoaD0fujuXu7
        luhsxQI9WHCzR0ZiMkvgyZfMeZV0gkaqR7KdpslIxfbI7UxiXxEpbnlN2c6OBubc36h5Vh/2zfC
        gHNrxP86H7UYxP0G+
X-Received: by 2002:a05:6214:1907:: with SMTP id er7mr4996629qvb.199.1579616125381;
        Tue, 21 Jan 2020 06:15:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqy8AFk0N0aDDxiY+h2t6Rh1k1ou2Ux/pEPzCq29EZUwXk9nLKkey+jnpSszBH9mQmuAKQMoKA==
X-Received: by 2002:a05:6214:1907:: with SMTP id er7mr4996599qvb.199.1579616125108;
        Tue, 21 Jan 2020 06:15:25 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id o16sm17323139qkj.91.2020.01.21.06.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:15:23 -0800 (PST)
Date:   Tue, 21 Jan 2020 09:15:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200121091456-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200116152209.GH20978@mellanox.com>
 <03cfbcc2-fef0-c9d8-0b08-798b2a293b8c@redhat.com>
 <20200117135435.GU20978@mellanox.com>
 <20200120071406-mutt-send-email-mst@kernel.org>
 <20200120175050.GC3891@mellanox.com>
 <20200120164916-mutt-send-email-mst@kernel.org>
 <20200121141200.GC12330@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121141200.GC12330@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 02:12:05PM +0000, Jason Gunthorpe wrote:
> On Mon, Jan 20, 2020 at 04:56:06PM -0500, Michael S. Tsirkin wrote:
> > > For vfio? vfio is the only thing I am aware doing
> > > that, and this is not vfio..
> > 
> > vfio is not doing anything. anyone can use a combination
> > of unbind and driver_override to attach a driver to a device.
> > 
> > It's not a great interface but it's there without any code,
> > and it will stay there without maintainance overhead
> > if we later add a nicer one.
> 
> Well, it is not a great interface, and it is only really used in
> normal cases by vfio.
> 
> I don't think it is a good idea to design new subsystems with that
> idea in mind, particularly since detatching the vdpa driver would not
> trigger destruction of the underlying dynamic resource (ie the SF).
> 
> We need a way to trigger that destruction..
> 
> Jason 

You wanted a netlink command for this, right?

-- 
MST

