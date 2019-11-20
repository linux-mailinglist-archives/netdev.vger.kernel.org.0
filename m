Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A1C103C31
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfKTNla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:41:30 -0500
Received: from mail-qk1-f179.google.com ([209.85.222.179]:37813 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbfKTNl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:41:29 -0500
Received: by mail-qk1-f179.google.com with SMTP id e187so21242469qkf.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 05:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=icDSw0kK1puulej1TqOEDk3c9ykeB0QO2JJKV2fLt6E=;
        b=XI0v4WKhD8Cz4abX0PIeCnnAyhgnhXmBc5jzD4GJFV15LHSCDfrn/rw45O/qWmSV87
         NRH6ekwJtoP9l4ez2QKoB/LebojlYRWTFPFso0jD3L0JtOHl+KItmV+zLqNIyizR1c+X
         42tlV15avvRFcCo4Ik6esLJFUFM0nyWU8E62tZqBEVo5A5raZmHb2rZdMNXTqmq2rhGe
         D7l7eLsQkbxspF+k3oFO7iRYVVUCAHwct2XVE3FisfNQd56KbAtggm2T8f8c/vYQ4H5s
         rmIKJ7h5+IC1EzoTM0XIvo6ZVlbjz/ChLVXEv0uPChtBq5u/n/p0192rcAF9ZgsrXpri
         SpmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=icDSw0kK1puulej1TqOEDk3c9ykeB0QO2JJKV2fLt6E=;
        b=JLdsr8cjzbFBnTO/JDsVUE+y6cORF5e2GlhCEVlrfMtkDWJH4CPQDSjo2N5PBdjYXS
         IqgKXzYAf5u8XmE3dmVl90VOAOzfTaFSxSDwFcjJwE86UUgTx24W12xIfZ0Q2Tq4XzPf
         RrIARUTMwiniOClFXd+5U+V1fcy2U2WaZEUTTX4cNA6DSA9Wa8xvdeSaHLFutJD+aZDc
         7kTHBhVjzkyR/OPTyoim8pkd2LDJITj9JEjP7RsrDpzJmz3TCtIKVVqa1ElzIDaLclaR
         RA9M4t0fhhpTrk3563WGqcpNWsBsQ/47mzFUd2kR6uoGOIa9MR6aVQEtEIA1dGu/NCO3
         I+Xw==
X-Gm-Message-State: APjAAAUsYsqzjYBfrQUsDv+IXqyGRxPKk0NfA2DHyp58s3F/MNx50lHT
        Di8dk6LKHOmfi84gCQvI1K16hw==
X-Google-Smtp-Source: APXvYqwV55Shx1sqh/BT/rqphjh2QnRXE1xCrFZaY4WpYzL41lQGLAunB0X8ZMgXo02n55DAUssHBg==
X-Received: by 2002:a37:a010:: with SMTP id j16mr2437128qke.84.1574257288122;
        Wed, 20 Nov 2019 05:41:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id x12sm11869585qkf.84.2019.11.20.05.41.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 05:41:27 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXQEY-0006bD-Q0; Wed, 20 Nov 2019 09:41:26 -0400
Date:   Wed, 20 Nov 2019 09:41:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120134126.GD22515@ziepe.ca>
References: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
 <AM0PR05MB48664221FB6B1C14BDF6C74AD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <21106743-57b2-2ca7-258c-e37a0880c70f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21106743-57b2-2ca7-258c-e37a0880c70f@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:07:59PM +0800, Jason Wang wrote:

> 1) create sub fucntion and do must to have pre configuration through devlink
> 2) only after sub function is created one more available instance was added
> and shown through sysfs
> 3) user can choose to create and use that mdev instance as it did for other
> type of device like vGPU
> 4) devlink can still use to report other stuffs

Why do we want the extra step #3? The user already indicated they want
a mdev via #1

I have the same question for the PF and VF cases, why doesn't a mdev
get created automatically when the VF is probed? Why does this need
the guid stuff?

The guid stuff was intended for, essentially, multi-function devices
that could be sliced up, I don't think it makes sense to use it for
single-function VF devices like the ICF driver.

Overall the guid thing should be optional. Drivers providing mdev
should be able to use another scheme, like devlink, to on demand
create their mdevs.

Jason
