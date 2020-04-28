Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BB31BC455
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgD1QBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:01:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29801 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728099AbgD1QBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 12:01:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588089659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/nHrnAWjFYDEx+ooars7FfriVR6n5mahvVNAOlPkCA=;
        b=T+G7JyE7CA49AvV1biNb5AOP7jqobjGb6AaCtB9L2E0TEjhJtICZrd7K2CFC9KsYP4XQsd
        LvrdLNDO2O2Jh5vql2rEZMKtUwoDi0lxa7DWHMBYLDvKX3cKe/y+yp8Ukl7x+UCsFoguv2
        XA3iPctyvNr8gPlnfUNOvyhTDOuzHbc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-6ydUt0x3MyidjZs9nVjm9g-1; Tue, 28 Apr 2020 12:00:58 -0400
X-MC-Unique: 6ydUt0x3MyidjZs9nVjm9g-1
Received: by mail-wm1-f72.google.com with SMTP id b203so1046601wmd.6
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 09:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=V/nHrnAWjFYDEx+ooars7FfriVR6n5mahvVNAOlPkCA=;
        b=YID0RGxnrypPazuWM9sjwMyerwTJC3GRgTj1p7sGCml7pbJ7sLAyAiMG2uNFJhAZsy
         FgzxfRt9/ZDWfiwCAQnpaEN4F2IADkAE9qqEyoEoiT5Bf0ZFYTzQ3jGWlYgALdR1EsC5
         iI2uCCFRCF3fPbQdymwVQUOM4sQ/rf2Hvnq1rR90JW5CWoP0EYDU8+n9yZhhGyqpRF6Z
         K5iVbXi3OoJ0k7V18LvNZMrq87fQakx0aZUjnmWCUam1XlkC5pjkSuJwa71cH+lcxIRx
         9mB/2+YlcPIhg87Winq4OnKiPHV9wMS8rvYg0tPjc6wm79ATuEyYKSRufX7bib3UKZJf
         WB1A==
X-Gm-Message-State: AGi0PuYExmNFnmYBrJNAMrY6d5u5hx4PeCmKnZSl4Md7uiD2oN5DQQtT
        Vd7xBMPwa5p2TQCoinbcMTxYVM348XctOJWXPofr8yt9WOfFIOHX7zKhs2qHEaFIEh1BQ8ma3QF
        M1pVDbESTKLwkLIVC
X-Received: by 2002:adf:bb94:: with SMTP id q20mr36673137wrg.105.1588089656826;
        Tue, 28 Apr 2020 09:00:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypKIbCy5WLfJsOD2H4tVuk3XU3G9si8HV/hIhC9ID521e8b71TD3eq8vjhdxcrAKzwjnXgEZ/g==
X-Received: by 2002:adf:bb94:: with SMTP id q20mr36673001wrg.105.1588089655649;
        Tue, 28 Apr 2020 09:00:55 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id i129sm4064632wmi.20.2020.04.28.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 09:00:54 -0700 (PDT)
Date:   Tue, 28 Apr 2020 18:00:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20200428160052.o3ihui4262xogyg4@steredhat>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
> 
> On 2020/4/27 下午10:25, Stefano Garzarella wrote:
> > Hi David, Michael, Stefan,
> > I'm restarting to work on this topic since Kata guys are interested to
> > have that, especially on the guest side.
> > 
> > While working on the v2 I had few doubts, and I'd like to have your
> > suggestions:
> > 
> >   1. netns assigned to the device inside the guest
> > 
> >     Currently I assigned this device to 'init_net'. Maybe it is better
> >     if we allow the user to decide which netns assign to the device
> >     or to disable this new feature to have the same behavior as before
> >     (host reachable from any netns).
> >     I think we can handle this in the vsock core and not in the single
> >     transports.
> > 
> >     The simplest way that I found, is to add a new
> >     IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS to /dev/vsock to enable the feature
> >     and assign the device to the same netns of the process that do the
> >     ioctl(), but I'm not sure it is clean enough.
> > 
> >     Maybe it is better to add new rtnetlink messages, but I'm not sure if
> >     it is feasible since we don't have a netdev device.
> > 
> >     What do you suggest?
> 
> 
> As we've discussed, it should be a netdev probably in either guest or host
> side. And it would be much simpler if we want do implement namespace then.
> No new API is needed.
> 

Thanks Jason!

It would be cool, but I don't have much experience on netdev.
Do you see any particular obstacles?

I'll take a look to understand how to do it, surely in the guest would
be very useful to have the vsock device as a netdev and maybe also in the host.

Stefano

