Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F75103AA1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbfKTNDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:03:22 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33442 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbfKTNDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 08:03:22 -0500
Received: by mail-qk1-f194.google.com with SMTP id 71so21153874qkl.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 05:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2iApCzjf1i0i8p6WofoOUizgrWbsRLbQ/wv4IGhkU0A=;
        b=m/VMHG+uRCb3VVp1GM0DQ5XsVo2Qh25ThKGP0SitRfdu0jAo8zb18pKiolOeM7PEl3
         Ark8M2kJf6n9+eYppMkXnO4jPHfMbN0yhF4RJRCrdaoczNceWxH02iGYuJ9RLD7l3M62
         DSQAat/pbzLFW4HpECk1fbrIfr9CG7mwq57BeOIc/cdizT350uxVUoKsC6UCJM2pEqK8
         oe4LDYHlRPliRchk2SlinyZjnoAAlb9wcnExU/LGYFhNXEKOotYDaKeLh1GA9YHdBOCF
         6e3AAEPF6mzw0Y9KHaacx2N4myjmoGasSbXjGHUIUeFjK5vzTbNz33zAfoYtom8XiwS8
         XgWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2iApCzjf1i0i8p6WofoOUizgrWbsRLbQ/wv4IGhkU0A=;
        b=DlZ1njJbk7pMTYfkoDlg2AkAdptjX/Wnb8EX/fYACn04amy9MsWumFzxWfLz9q8uDU
         FroLCSTS3CD2uxCWbd4Nzs5myCXdpgE3TTQPaGnc64sQkZR/7SsRuiH0NQei21yRQW5E
         zyNWyX9YtRWmkQ4Zo6L6nk2j0gdUYPT1uR5pjj508KrR07nZHeBE/Y5/Zqq1eE50yH42
         xvWPmtMquPbpoeIdb81XoEHxsPK5XDX/hoXFBtklkfeDBJSNNMegW+/Ri+MWIICfXzQW
         EOvxBFpMZU/1riE8KY6fM6uM/OU+UsY0xTUJBRi9cH3EROC5o+Xp6vFghCPcTo2cdITN
         vv+Q==
X-Gm-Message-State: APjAAAX5aejkEtD8h14g3Ka13pSGFAbRgX7Ue0tA5Nwav5MKOBnHeuEB
        ryhePLqZ9kE5pkEOikNJxMsL3Q==
X-Google-Smtp-Source: APXvYqygO70Cv/t+j9/8s9HBurSMwIFonOfaFlMMFysL0d9D4NFlxgF/aCweEzaUW2xMpjMWb2TPgA==
X-Received: by 2002:a05:620a:12a3:: with SMTP id x3mr2191656qki.336.1574255000938;
        Wed, 20 Nov 2019 05:03:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id l198sm11808585qke.70.2019.11.20.05.03.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 05:03:20 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXPdf-00062Y-D3; Wed, 20 Nov 2019 09:03:19 -0400
Date:   Wed, 20 Nov 2019 09:03:19 -0400
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
Message-ID: <20191120130319.GA22515@ziepe.ca>
References: <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <20191120022141-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120022141-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 02:38:08AM -0500, Michael S. Tsirkin wrote:
> > > I don't think that extends as far as actively encouraging userspace
> > > drivers poking at hardware in a vendor specific way.  
> > 
> > Yes, it does, if you can implement your user space requirements using
> > vfio then why do you need a kernel driver?
> 
> People's requirements differ. You are happy with just pass through a VF
> you can already use it. Case closed. There are enough people who have
> a fixed userspace that people have built virtio accelerators,
> now there's value in supporting that, and a vendor specific
> userspace blob is not supporting that requirement.

I have no idea what you are trying to explain here. I'm not advocating
for vfio pass through.

Jason
