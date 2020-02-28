Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A2017386F
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgB1NfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:35:02 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34141 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgB1NfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:35:02 -0500
Received: by mail-qt1-f195.google.com with SMTP id l16so2015612qtq.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 05:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SO4k+cEae+kcaRUxuLpklhk4ez8pzokBlgA+/XnFpzY=;
        b=YVBzc0fPtfTWU3WI4CpD6wflzlKNfGdtBy6xeStvbbJrgzA1/3+LYWWJJUKFHLlNe6
         estvGTicQLamm11cs7CeJACAaxInS7RYp50Ztlq8H6enN1ap/uDBCZGrp01GO+iJRfIo
         f9AQLO3nan12oFT4cROZv+gFhJRYiiUvK/NiN1xOGXaQVrAU3sF5LpTxKxD41jmRvNf8
         PaL+thoLLUdzf38op6Q1/pE7SJNflTxQSjoshQsa2XyYGSpX/1fVU/9woELTNFVBP8L6
         j4p3BrvBSXmHOMVMeKrnH+22GmcJSgmom5xUSelUdQBcdQiwVibPhsEnqQPTwhfKHlje
         6KdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SO4k+cEae+kcaRUxuLpklhk4ez8pzokBlgA+/XnFpzY=;
        b=h3daA+QiScRVO5KeG1cA/VuYA5lTfcEgmTrabew+NPHB3vF5arPPoLcTtb+fQnRoSG
         RV//omtQ51CKqhPCSEA/8t619KVOr77oVtAH++HS/0MMywfL27QbdRJNcjoz1r9+emA8
         qX+ShBAECdsl9NUB+nhsjA7RJ0AdGJMg4Tq/fhZuB/pndi/QzImm+7qXke8zJqWdFoFD
         neGIn8o/8J6gQi3wfjXjqLEDYaDV8CDeJCvY+vIMGzjFVcp1BWyHbofLumt5+sYhaFux
         6NsUOQniaDcNLhsfS28NI5s1E9qLiZQ0s7JLizujdd7qPHdxj1J2dmEsRq0GeS0zqerX
         crag==
X-Gm-Message-State: APjAAAWtor9vhkb7W1RONfOy+OnnVzrM/TamwNRa5ZSwLv1JStYHCgu/
        eaTSeIaTEbXANu403Ie3kZ9XAA==
X-Google-Smtp-Source: APXvYqz34jQPrszufJ93Ceni4PEZYOnNx21NiUQdDnBqKX3jqVT7UroWcBUFS7T8hVPeCfHcAR4H6g==
X-Received: by 2002:ac8:5190:: with SMTP id c16mr4174211qtn.200.1582896901187;
        Fri, 28 Feb 2020 05:35:01 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o25sm5120118qkk.7.2020.02.28.05.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Feb 2020 05:35:00 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j7fnA-0007ph-1Q; Fri, 28 Feb 2020 09:35:00 -0400
Date:   Fri, 28 Feb 2020 09:35:00 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bernard Metzler <BMT@zurich.ibm.com>
Cc:     syzbot <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Subject: Re: Re: possible deadlock in cma_netdev_callback
Message-ID: <20200228133500.GN31668@ziepe.ca>
References: <20200227164622.GJ31668@ziepe.ca>
 <20200227155335.GI31668@ziepe.ca>
 <20200226204238.GC31668@ziepe.ca>
 <000000000000153fac059f740693@google.com>
 <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
 <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
 <OFF9E6CFC6.7E79459D-ON0025851C.00472582-0025851C.0047F357@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFF9E6CFC6.7E79459D-ON0025851C.00472582-0025851C.0047F357@notes.na.collabserv.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 01:05:53PM +0000, Bernard Metzler wrote:
> 
> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
> >From: "Jason Gunthorpe" <jgg@ziepe.ca>
> >Date: 02/27/2020 05:46PM
> >Cc: "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
> >chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
> >linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
> >netdev@vger.kernel.org, parav@mellanox.com,
> >syzkaller-bugs@googlegroups.com, willy@infradead.org
> >Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
> >
> >On Thu, Feb 27, 2020 at 04:21:21PM +0000, Bernard Metzler wrote:
> >> 
> >> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
> >> >From: "Jason Gunthorpe" <jgg@ziepe.ca>
> >> >Date: 02/27/2020 04:53PM
> >> >Cc: "syzbot"
> ><syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
> >> >chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
> >> >linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
> >> >netdev@vger.kernel.org, parav@mellanox.com,
> >> >syzkaller-bugs@googlegroups.com, willy@infradead.org
> >> >Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
> >> >
> >> >On Thu, Feb 27, 2020 at 10:11:13AM +0000, Bernard Metzler wrote:
> >> >
> >> >> Thanks for letting me know! Hmm, we cannot use RCU locks since
> >> >> we potentially sleep. One solution would be to create a list
> >> >> of matching interfaces while under lock, unlock and use that
> >> >> list for calling siw_listen_address() (which may sleep),
> >> >> right...?
> >> >
> >> >Why do you need to iterate over addresses anyhow? Shouldn't the
> >> >listen
> >> >just be done with the address the user gave and a BIND DEVICE to
> >the
> >> >device siw is connected to?
> >> 
> >> The user may give a wildcard local address, so we'd have
> >> to bind to all addresses of that device...
> >
> >AFAIK a wild card bind using BIND DEVICE works just fine?
> >
> >Jason
> >
> Thanks Jason, absolutely! And it makes things so easy...

Probably check to confirm, it just my memory..

Jason
