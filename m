Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA55102C6A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfKSTPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 14:15:49 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34031 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfKSTPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 14:15:49 -0500
Received: by mail-qk1-f196.google.com with SMTP id 205so18914794qkk.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 11:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wzoIv3PgQ5xg77XVjLm23G3rCo4a5omAce2oLdpNLf0=;
        b=XE0/ul2UH6r1RgftX+x3FfxRVtupCc0p5j0CssMbeJpj9XpIfEt7ladYWvfy54o6Rg
         amj5FPwjOky3fb6cVFljYWKTaVErqw09vP6ui7h+2TyUDXQCqE70A37nvgt7HyZHrxf3
         V8JUDy38dL0v1I7A9N5JdjR6YDfEaFMIToaDZunT+tn8ckvBTwGr3IpDyuqEmRjiHgMH
         q2ZF0rGJkIdipvVsCY3GQEa0Qj+LYYmBMvgm3d1hv8DF+ar6Gg7dHjFuyFaUPTfKOwKF
         eaurWEbbTu1OVxsgNwi+CoRdCzltDRJW+MyY+sIifQYyLzEUKqiGh4y8eqxhprl0CCkp
         Abeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wzoIv3PgQ5xg77XVjLm23G3rCo4a5omAce2oLdpNLf0=;
        b=sz41/rLSEF/ONGWRt5WpeRv32yb8FRCCS5JxZO+uSW8iVl08Qp9YY5c9FNgq75CW99
         Lfl1pWRuwdKq7t642GZQFPf4QuZefUJ66RtNtwHbFd8+ZlBfbFiP48Z8lLu77lfB2UY4
         9H9xlFlo19uwLx4ot7NSlwc7zfegTBB3yxcLjJlN41uDbOTsIhuZjgjSmFKCSSEFoSzJ
         fe6x/11A0nKAQ68fLiAd3TX9wXUWMURHv21hI0vnPJXLfiSXRTBWezAzB6KpBwJjP6p2
         imnFn9ejTh6vxlCyZ4gv/Jo3Ul+G3uWrxHHo193png9o1xhGbtdZc9U9eg7IW/PFAN/L
         gBIQ==
X-Gm-Message-State: APjAAAW6rWkDxiIPDFdMb2kUwmzX5DO+2nzXXpwmXbWNXiphbqdwp4tW
        8QlQJA6DfMQBPFck/NyBMG3vgg==
X-Google-Smtp-Source: APXvYqxRNsEg1levwxBxtexcCKoGDcNnCXh67oEXnQ2zgfRUQ9XoNmJhJPOHNIKTRGaI5LuduX6avA==
X-Received: by 2002:a37:9f48:: with SMTP id i69mr30497457qke.273.1574190948542;
        Tue, 19 Nov 2019 11:15:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id m13sm10540375qka.109.2019.11.19.11.15.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 11:15:48 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iX8yZ-0002e8-NJ; Tue, 19 Nov 2019 15:15:47 -0400
Date:   Tue, 19 Nov 2019 15:15:47 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191119191547.GL4991@ziepe.ca>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119134822-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrote:
> On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> > As always, this is all very hard to tell without actually seeing real
> > accelerated drivers implement this. 
> > 
> > Your patch series might be a bit premature in this regard.
> 
> Actually drivers implementing this have been posted, haven't they?
> See e.g. https://lwn.net/Articles/804379/

Is that a real driver? It looks like another example quality
thing. 

For instance why do we need any of this if it has '#define
IFCVF_MDEV_LIMIT 1' ?

Surely for this HW just use vfio over the entire PCI function and be
done with it?

Jason
