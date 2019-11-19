Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB64B102C4B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfKSTDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 14:03:44 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41008 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfKSTDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 14:03:44 -0500
Received: by mail-qt1-f196.google.com with SMTP id o3so25851291qtj.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 11:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9GDoQY2yC1lhn9ZVp38mlr4upEtNCxpAvQJJt2TniAE=;
        b=PR1O3PbhC2HG7vIjVZypRwStQsCOxpBUEmvXT9CA/xffaI2cuf2iGfvUr/9l7PbU2M
         CJX4dM94AfkIsW+VGOsYNW8ZxQCHbdhjUN5o2iF1kqtWDSndlt85q60gNnSP6gzXdusu
         TMSyHVHF8xwcJ5EHgGt1bH2ATqcsaYGXSDufJgqZpWJPZ04nymL7vMjB8Ca1y2Dl6GOk
         vnlvAbcHn0CK/y7L8OW9v4J9ZGHuhCknOoO8mnI3BJ9PHIEPeEoKV5M0dXfjM7kWJiEj
         YCoZYIVV6DbG7tscJ0FLcae2X2YUvY1fJilwSAiPQdpfaT7SG8xlE6daxQ3SACbDjqnT
         S/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9GDoQY2yC1lhn9ZVp38mlr4upEtNCxpAvQJJt2TniAE=;
        b=VS19lnFEYceRIayYqUx4+136BHiGIKchN6NxL/YSCMGscTZraN/fVlVtMXzzeDHtV7
         ohY2VUlRrZolNTNGrvZvETCkM8ZrXdy2OY/B4L+YYt91G02T2hostTQOspCYlDzHFDia
         g39/zxZNQ1t5ozBaPiV4dvBYnV8LuvAFniaVGE3igzTQgMiIHAmMBzwnS6WdJ4CqYjsl
         0m1TpxGYKNj8h8kK6kx9r6Vc4slY4oWixic5e4FOgfhK3gW1KA5ygIYXpz6kv3jVXlj3
         8NpUiqvwLk2GnldyHRmPu/zNwV1UwW7qcYrp4pkikbMZ4Gkw5jE8L86+YisZOQGG6vOs
         63ow==
X-Gm-Message-State: APjAAAXayk3f/sSCbl4P6y+odQtQ+yB4AkasAep/OGbrG9dyHy99YD1z
        BEHibFhZ2jPUJD/GSE8O3aV4Pg==
X-Google-Smtp-Source: APXvYqxLspxf8WJ0kzuOaxofXiookLE9ciyGbanfLatZv9Qhy3Tw/qNUJArGigCx75Yg+7sccqJ8HQ==
X-Received: by 2002:ac8:22c4:: with SMTP id g4mr34069977qta.45.1574190222024;
        Tue, 19 Nov 2019 11:03:42 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id h37sm13283814qth.78.2019.11.19.11.03.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 11:03:41 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iX8mq-0002XB-W3; Tue, 19 Nov 2019 15:03:40 -0400
Date:   Tue, 19 Nov 2019 15:03:40 -0400
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
Message-ID: <20191119190340.GK4991@ziepe.ca>
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

Has the consumer half been posted?

Jason 
