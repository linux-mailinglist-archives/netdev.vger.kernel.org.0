Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE70102E47
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfKSVez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:34:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726892AbfKSVez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:34:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574199293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srTaX0P4WSxRldSu7zbMqUtDF6KMPPQzZma8hiWK3Po=;
        b=ZSHLX4yQxFMnYczRi2DpNPslvSvJseiYcERlbz0cvsf4BjFu/4q5BWZ7rrAKXb1siYtMT5
        RpeNj8ugRUi3NOiD7fcgijJO4x1dG8yz2Qype6RSGhKK4TUhxrsG6GFKG2Z0wQNCKbL+ZD
        8LVwxlNw2BbAfLksrygBUP2LkevpKW0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-Umb0M8yROzSOGU8-ypMz4Q-1; Tue, 19 Nov 2019 16:34:52 -0500
Received: by mail-qv1-f71.google.com with SMTP id d12so15636902qvj.16
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 13:34:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JQfgppOtdmpNgdUHoK2y/uXjbBAyhx3tLnLNqFiXHTQ=;
        b=TF9sGrw5pQ5Dou51GjjuyaI+EGK2fWtbnLXioOoZotcBrunm1IphfFj5GwRH1q90zd
         iJiqrueErJQLZ93YqMLLiv4v5B8pIRM1km06yjN0lAygyAK54BSruubqiUQLH6cOeFSk
         My9CAUD0lEM9aTj9xjYe6qdhkRM3HI57vBs2RyAbaKvEhtUGXGxtefP0T+h1Zz/VJpZd
         OeKkj641Bm72D9JTMo7yijGN04jpcESkBhS0vEjjFWd6tll3uf8aUb4zhIO9lWJiNUrp
         Die8HsprOrfcReGLlf8nJuS+qYdirMgb9whwbtgGhqnXGvGiSwJnDFgEUgV/UvHx8GJA
         Ml9w==
X-Gm-Message-State: APjAAAU5+hGpXqLfXGuuyGvYN117+LKVdI5h5IKhbK+HLsQU5yyfvzAo
        W7KeFxnF+OFGR5caJHare1miB3VHsiKUnpkH8NgAYt/WG8UcrRlhiUmKHOG1QOm4rSLauq3YWYD
        LPyecETTEyuGQz364
X-Received: by 2002:a0c:80c9:: with SMTP id 67mr31757757qvb.178.1574199291627;
        Tue, 19 Nov 2019 13:34:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqzD1e7UMgTXdrlywMKgqavdol44IrikHwWPY2asj3N0IS5OwEZpnLAnXo5RDtnytegc4Y23+Q==
X-Received: by 2002:a0c:80c9:: with SMTP id 67mr31757740qvb.178.1574199291413;
        Tue, 19 Nov 2019 13:34:51 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id i186sm10743290qkc.8.2019.11.19.13.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 13:34:50 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:34:44 -0500
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
Message-ID: <20191119163428-mutt-send-email-mst@kernel.org>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119190340.GK4991@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191119190340.GK4991@ziepe.ca>
X-MC-Unique: Umb0M8yROzSOGU8-ypMz4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 03:03:40PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrote:
> > On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> > > As always, this is all very hard to tell without actually seeing real
> > > accelerated drivers implement this.=20
> > >=20
> > > Your patch series might be a bit premature in this regard.
> >=20
> > Actually drivers implementing this have been posted, haven't they?
> > See e.g. https://lwn.net/Articles/804379/
>=20
> Has the consumer half been posted?
>=20
> Jason=20

Yes: https://lkml.org/lkml/2019/11/18/1068

