Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1D1E223F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbfJWSBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:01:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35836 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387516AbfJWSBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 14:01:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id m15so33668126qtq.2
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 11:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NQ6tKgTGVcyRqL0Uez6+bIGFAD/xWLx1fHm590a6YIQ=;
        b=jtFkd7hTl76drrjU8sdI7bunECUCsC8ktafivS+U7bIYhMIJ+zS0iQCa3pXpQdQ6eq
         ypwkFXGe4dLgpYRMYpPvbMkx0zuXvfkS+rPNPyiXP2K50Ttg65B6sgq7QNUc7J3mH4Dv
         zGw/uJhn1LK8R0ihpu7IwnJcBNJliEsP7HZ+Q48B2QVZRS68WSoXfAfZaaKnNl4RbgZk
         jfkt2oBLSBKBbMoszkfCf3BkrStERShu88Uqhweb9o4W+jaGr4JzXe1FZhlMy5ArvlM2
         QasjfUN1oOuG8HVPAln2AC9gJJWL0NOCcH5jvTrQnYGFo4pT+wVlg5LNR43krehTP0yD
         JYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NQ6tKgTGVcyRqL0Uez6+bIGFAD/xWLx1fHm590a6YIQ=;
        b=lwk6tOiw95K12Dz8N4Jm/9Dbp/xHUbXIDACBDRkMdv0HwBLXgnsymWPYZbQHlKfTke
         3bCpFAT00CDYlpR4h9wJ7rDKFOWQxkI/37BjYwJ87vqwS/4EnoOnl1GQ3iUkxsTI5Cnq
         KVt/bLt9ca8eQEA+toBm1LWf4ku4Rzbl64mjj3JZqib+8LfqtaB+xTO2diXTaypV6jo6
         xSfqzADKO5l/CPRqouhty5dh995OgtyHPK5lhawzx/yTHzHYmxOw/+EbXjyL1i9XDXmx
         CxbXqv4rq02GwxcpYQBtBpgt8KPbT/PPrRp9/E+YUR9yJFN6nzQGD6roLkGK37/sPvpq
         XIsA==
X-Gm-Message-State: APjAAAUMBOFWf2vx0JmxkyRq3RFD3lHZO4076RyEtbEk1+y+YjkICWjj
        zkNSC6rGTf6l2qiuu+QUW0Lefg==
X-Google-Smtp-Source: APXvYqzbUVVpjQLD1S33F3Se+dUpl1cwA2mMXn+N9c27dQBJQnj92hcffr8ioNzWSaQQcv+3ilUqbg==
X-Received: by 2002:a0c:9adf:: with SMTP id k31mr2446593qvf.126.1571853670122;
        Wed, 23 Oct 2019 11:01:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id y29sm11774227qtc.8.2019.10.23.11.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Oct 2019 11:01:09 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iNKwX-0006KT-0c; Wed, 23 Oct 2019 15:01:09 -0300
Date:   Wed, 23 Oct 2019 15:01:09 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20191023180108.GQ23952@ziepe.ca>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 05:55:38PM +0000, Ertman, David M wrote:
> > Did any resolution happen here? Dave, do you know what to do to get Greg's
> > approval?
> > 
> > Jason
> 
> This was the last communication that I saw on this topic.  I was taking Greg's silence as
> "Oh ok, that works" :)  I hope I was not being too optimistic!
> 
> If there is any outstanding issue I am not aware of it, but please let me know if I am 
> out of the loop!
> 
> Greg, if you have any other concerns or questions I would be happy to address them! 

I was hoping to hear Greg say that taking a pci_device, feeding it to
the multi-function-device stuff to split it to a bunch of
platform_device's is OK, or that mfd should be changed somehow..

As far I as I was interested in the, the basic high level approach
seems much better than the previous attempt using net notifiers.

Jason
