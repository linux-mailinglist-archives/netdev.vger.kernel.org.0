Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D7FF3D49
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 02:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfKHBRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 20:17:00 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36666 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfKHBQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 20:16:59 -0500
Received: by mail-qk1-f194.google.com with SMTP id d13so3866805qko.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 17:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dyxeSBJVMYqSSgHrMoCBX1xHiPyaBtHHDx9vh0MyLbg=;
        b=h1h5lsiTzQmb05+dMRootsjogeunEVA0ty19WeFHKl9612U7UhX9X9zXNdFtny0hqQ
         Xqwnwc/MOy6f/0IsssM+UaqLFVSvo+SoauHQwoqERiAPQyhRSwTo+LaqXpJ2IyHn+QVD
         j3ox7wthRD+ghEUdMcDMAasfX+J/8FtSRE66I2N1m88bW8TLdhk5J8/I4dRZyDUGDNnj
         NcW9JRQkaafLVWRRw9pni54fhdg221ogcm3W4kmcrV/hfle4c7agV8zXuYO35bns+Wd2
         FM2of8IAkzVZqc3kBYbzrmbXjHX179DAIDuc6wMDiOutAzeUzaLjyCtxvblfELxvXvgO
         M8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dyxeSBJVMYqSSgHrMoCBX1xHiPyaBtHHDx9vh0MyLbg=;
        b=jaAlaHCBuscYyA1Negk17IvyOjIbszunA0m3yGwYtHA3SN/PV/tlCbzX/SKC8hPnQP
         54H9RpiDYurD8da0drFUTP5zDmS2ea+cKmuZMZquVz6jNM3aexERp+sEyM2C+k134W+X
         mDwlcyNPPPHHbUZlhBqDurO6YKTY1TY6uX6Z+STkATIZgsgo/1bNHAX/pHAMvAZWLimg
         cOi1ufeX9KH9JsqhTryysz265AtSkQ+N/u0LREuXfa0gs1jikXyuBQRymbVo4u1pwPoX
         Y+J+b1TSykZ49q+kxwDFXHBKiDzXx4e1azDcGZXjMh39nsnm4Bn4JfNVCHIg7iP58zaC
         0vtQ==
X-Gm-Message-State: APjAAAXLxELcQG/tNi0f15jOZ39Nv/nQwgN+gQ3yuNRFkA0ps0GZZG9V
        EDJB9t/2uCCZCYFv0M13Bloudg==
X-Google-Smtp-Source: APXvYqx4DFWX5SNNZl7pjgak86Wa5yCfVWQdSXhfRgO4TjXogQeQyxfBpCD/iqC0hyFp+0USDCQ+EA==
X-Received: by 2002:a05:620a:6ce:: with SMTP id 14mr6624068qky.202.1573175816907;
        Thu, 07 Nov 2019 17:16:56 -0800 (PST)
Received: from cakuba ([65.196.126.174])
        by smtp.gmail.com with ESMTPSA id z7sm3448762qth.85.2019.11.07.17.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 17:16:56 -0800 (PST)
Date:   Thu, 7 Nov 2019 20:16:53 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params
 for mediated device
Message-ID: <20191107201653.0afb51fb@cakuba>
In-Reply-To: <AM0PR05MB486634DCB2778C2DFDBF752FD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-16-parav@mellanox.com>
        <20191107154256.21629e5a@cakuba.netronome.com>
        <AM0PR05MB486634DCB2778C2DFDBF752FD1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Nov 2019 21:30:41 +0000, Parav Pandit wrote:
> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> > Of Jakub Kicinski
> > Sent: Thursday, November 7, 2019 2:43 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> > cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> > rdma@vger.kernel.org
> > Subject: Re: [PATCH net-next 16/19] net/mlx5: Implement dma ops and params
> > for mediated device

Please try to avoid generating those headers, you're not an occasional
contributor. They're annoying and a waste of space :(

> > On Thu,  7 Nov 2019 10:08:31 -0600, Parav Pandit wrote:  
> > > Implement dma ops wrapper to divert dma ops to its parent PCI device
> > > because Intel IOMMU (and may be other IOMMU) is limited to PCI devices.
> > >
> > > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>  
> > 
> > Isn't this supposed to use PASSID or whatnot? Could you explain a little? This
> > mdev stuff is pretty new to networking folks..  
> 
> Currently series doesn't support PCI PASID.
> While doing dma mapping, Intel IOMMU expects dma device to be PCI device in few function traces like, find_or_alloc_domain(), 
> Since mdev bus is not a PCI bus, DMA mapping needs to go through its parent PCI device.
> Otherwise dma ops on mdev devices fails, as I think it fails to identify how to perform the translations.
> (It doesn't seem to consult its parent device).

What's missing for PASSID to work? HW support? FW support? IOMMU
plumbing? mdev plumbing? mlx5 plumbing?
