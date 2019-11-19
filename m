Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F268B102C2B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 19:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfKSS6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 13:58:53 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32931 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726939AbfKSS6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 13:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574189932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFWTHuIB+L6IZSct+FIzo+M5q3SYg/8/nPaBMk+3VaU=;
        b=L4VnQIYAbc8+s03iPXZ8KTlOEQM3bT+z+MuOZR4LDgawQ+QfI8l3vFTNETIGQYktXaRvpB
        BidRmd8DiiWaVRPsWn4pnpxl+/Fo3kn7cMAVueOWb8j7zvo4MasxQE4/HsAlgSx8Qh5HTe
        hZP0bFxU7IP51H6pT7/XUoJ9hLsVk64=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-KobqVd3RPGOwZ4CfssdT9g-1; Tue, 19 Nov 2019 13:58:50 -0500
Received: by mail-qt1-f197.google.com with SMTP id g13so15246666qtq.16
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 10:58:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EjrhTZUF7jtDysVYJRqGuNLeGXSR7KDqe9NefhbwW0U=;
        b=lQKBhq7TyeB2cJMOApA9QRnetQFtvtTRA/8+3LdDLM1T5sse7/5v3dJ/tPcAqT7d0t
         6kTSgas5yEcHeHjN4cPuR3QHKh62pzVjCdvCOADgwJG1bM0BPEwIhLN640XUyXdEZQMO
         W5WTdR3JlhOYo37C7LlcvlWK8sitNiyhPW6MOO+mZ87lWVFwkzbof7KfaSjQ0ERUpoFi
         FYQrSXYhX1LqQhSDosR7YDdfsXN2qjJ+wfZOll5XVqtevJSjRLUuvA9u9aWnCtN+vvv1
         rRN8tYFTIVCQ02ZqxKHjthHF07a29yzZ9UMuo8zn0l+69gZdyRShYAvvJqGKipEUAYH3
         16fg==
X-Gm-Message-State: APjAAAWoRZ3fIBNXvxt1j7Pru0Rj3H752/m6ETtn9eCrzXZo0NZHSIOY
        vWH6kaLrk5A/447pAPnL3vCZP9q+JbpM5N2pIW8gkIven9l05I5axgoy1tydu5o2fm6jgP6ZrY5
        ONHWMpluQAxnQ+yCl
X-Received: by 2002:a37:3c8:: with SMTP id 191mr29472495qkd.77.1574189930455;
        Tue, 19 Nov 2019 10:58:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnBZAF+Wt1CXxfcMn6Q/+Z+4iK6XGfqiua/IbAXSkx+t9b7Vkf5iIeIpKwNaUzLal2VrJvnQ==
X-Received: by 2002:a37:3c8:: with SMTP id 191mr29472450qkd.77.1574189930141;
        Tue, 19 Nov 2019 10:58:50 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id y29sm13298234qtc.8.2019.11.19.10.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 10:58:49 -0800 (PST)
Date:   Tue, 19 Nov 2019 13:58:42 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <20191119134822-mutt-send-email-mst@kernel.org>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191119164632.GA4991@ziepe.ca>
X-MC-Unique: KobqVd3RPGOwZ4CfssdT9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> As always, this is all very hard to tell without actually seeing real
> accelerated drivers implement this.=20
>=20
> Your patch series might be a bit premature in this regard.

Actually drivers implementing this have been posted, haven't they?
See e.g. https://lwn.net/Articles/804379/

--=20
MST

