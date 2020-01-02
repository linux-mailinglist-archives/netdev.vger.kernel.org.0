Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03B012E911
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 18:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgABRE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 12:04:29 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36489 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgABRE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 12:04:29 -0500
Received: by mail-qt1-f196.google.com with SMTP id q20so35093944qtp.3
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 09:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WPbPynAGzUK346pY05E9MVEd+DVJe9NYlWunsc4F7bI=;
        b=hyl+VdR64NWXOm10aZiX8etyFy+/+mlNJSllMAbT9XxWEZPuTYbIgRCjMc7bVLUBcY
         OzMdZ39E5SK168KPzQqV+1fEdiKEuErblQYeLCFYg3vIzE1Ud6tOZqs9s8Eal3J7U9Dr
         Rd3Tmv0WcuQf9HhL24BeVaSMQWZFcO1achF3+xJKSOq7rVRxE0yeF4A8rXSVbof9foIr
         OlLeOD1ofyuevh8taYLZhbW/STPLxGQX3Eu+DVQ8Msc3BDPr1Cr1366POjNpgiQhyin6
         +InkriT2+j7+E7oeb0FAPNv53IVIcMNUhuLlg9qAXdGKf6YVf2dOKke7BF/ElNyXGE75
         /sKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WPbPynAGzUK346pY05E9MVEd+DVJe9NYlWunsc4F7bI=;
        b=okbIGbTlyoKmtVLGMWqG0c6JO/zb8z1G8gBR2qOWpieXse9N9jLKYMv6PhVOEnuvyt
         iL9h6RucaNXmQFfAuZdAI81J4+f2kzeoQVYljwfmQbTiuRwxWzy0EsaraGcGVi/ITrS+
         1/h3sZz2yJc0u1NFPfQmLo9JdQ4B4mSP1i89P5ViRdBEYR1036WqsQn0ZE/rtPbxG85u
         KTbFYKMl7lZBRmzlU626fAuccstXnaoeOw+fg48Ch+3G4dpSkMV9psEU8pQmBFewJCDg
         o/wiLfoC4TXQ8s9N/gpL6hWagEieZzqGE0NsQLV2lIt8TjRm66pQb4OBlE8gBfKZaJLV
         8Lqw==
X-Gm-Message-State: APjAAAWqvefMuZSYtqlGPL6EmeDiYG6J3vEsn/XyjcrjQMVyc/E8uf6E
        35Jis3GbNoUJue2sQK4MRFup1w==
X-Google-Smtp-Source: APXvYqycZUV7O47HiA4P1kXVkI+MdtpEn6M3jTtOOK9XaCvrjBzH6g3r7l4R2UlRy4gtbJ1q4nLNug==
X-Received: by 2002:ac8:540d:: with SMTP id b13mr58796970qtq.244.1577984668023;
        Thu, 02 Jan 2020 09:04:28 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id e19sm17357377qtc.75.2020.01.02.09.04.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jan 2020 09:04:27 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1in3ta-000223-LR; Thu, 02 Jan 2020 13:04:26 -0400
Date:   Thu, 2 Jan 2020 13:04:26 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
 i40iw
Message-ID: <20200102170426.GA9282@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-20-jeffrey.t.kirsher@intel.com>
 <20191211200200.GA13279@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7B6B9343F@fmsmsx124.amr.corp.intel.com>
 <20191217210406.GC17227@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7C1DEF259@fmsmsx123.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7C1DEF259@fmsmsx123.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 04:00:37PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v3 19/20] RDMA: Add irdma Kconfig/Makefile and remove
> > i40iw
> > 
> > 
> > > >  - The whole cqp_compl_thread thing looks really weird
> > > What is the concern?
> > 
> > It looks like an open coded work queue
> > 
> 
> The cqp_compl_thread is not a work queue in the sense
> that no work is queued to it. It is a thread that is signaled to
> check for and handle CQP completion events if present.

How is that not a work queue? The work is the signal to handle CQP
completion events.

Jason
