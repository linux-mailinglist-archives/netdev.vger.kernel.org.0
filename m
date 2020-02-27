Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8F1723DA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgB0Qq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:46:26 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:32778 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730033AbgB0QqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:46:25 -0500
Received: by mail-qv1-f67.google.com with SMTP id ek2so1863798qvb.0
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 08:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+39Zg09IW1UqskBXG22m/r+7Tun0l/AA6e5ypJPRWkM=;
        b=Bgg8JAo4Hi+CWH2DBZAX8yCbFJALWRDS9rPmNvtmTs4L+yM0hUNzQjmgpMV3DWGG5P
         JnZAVmWOefAbrhDhL0Z0TJL8eI6A0xyDqdPZ/eJ/jsRrRHujKy7PGCnmY5nfaHbUbT7f
         vR4UhSRyPyJTRlJNt3Sf+31FZie2TP1iKA2B2YFWTug5IrJtgcio/n91jcH5pgdfNcty
         V5reYAhoWxrlxv6cq82ulFH2d44sMeJvwo7unCZezGjA+Jw0pfvwo7aVCFBLa73GIYJZ
         hObIMgxqKUqruPR6xJEobp4kCtRSOtRvzp0i/4B2QRh3td2pUbj0T9Y0tw8Ep/aX6yCu
         fxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+39Zg09IW1UqskBXG22m/r+7Tun0l/AA6e5ypJPRWkM=;
        b=d3zcKWg5KqajHaZBiK6midJ/j1Cv+TP6lfPJVcX+6LUW8kf0FSi6bqSVRg0VZHWAsM
         wnRaEJZbpZMgPZkHAN4BR8aVY7k7HWc5O375wGuZqStxFvF820Ltg2+Er1b7/5dQmB6M
         RTR6Io6Qh/pZ5U8iT4kL3vKhs8Qllhkd7ji9FG1awvLuNAFCOCBSedjX2Um2LPKI/mrH
         +gzjy5/eagTt8ARnfWZRV7yySKA2NRgegLGqU2Ptq4HwzsimIckqel76keAVqI34Ep4i
         f+ZzZTyaNzthVtymRENcuz25rpShLrOrhsz+RYpanESDowAfCHD46G+XtvcJT8K5Fu1H
         dI3Q==
X-Gm-Message-State: APjAAAUKUpMtEJ2s7/MZ1JokKW9En3bZ6Agj5pjxBMkgQMxS83Gm3K2o
        LfVWCULa2dFRWTzbYjbkWvOnhA==
X-Google-Smtp-Source: APXvYqwrHZYEIEuESwvmFkEWQhgGRxwXw41iGxF56msahSCCRfVrEFUbqncWow7/3rMzl4WgyhO+GQ==
X-Received: by 2002:a0c:fa92:: with SMTP id o18mr615449qvn.125.1582821982930;
        Thu, 27 Feb 2020 08:46:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p92sm3344990qtd.14.2020.02.27.08.46.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Feb 2020 08:46:22 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j7MIo-0001k5-2a; Thu, 27 Feb 2020 12:46:22 -0400
Date:   Thu, 27 Feb 2020 12:46:22 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bernard Metzler <BMT@zurich.ibm.com>
Cc:     syzbot <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
        chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com, willy@infradead.org
Subject: Re: possible deadlock in cma_netdev_callback
Message-ID: <20200227164622.GJ31668@ziepe.ca>
References: <20200227155335.GI31668@ziepe.ca>
 <20200226204238.GC31668@ziepe.ca>
 <000000000000153fac059f740693@google.com>
 <OF0B62EDE7.E13D40E8-ON0025851B.0037F560-0025851B.0037F56C@notes.na.collabserv.com>
 <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF0C6D63D8.F1817050-ON0025851B.0059D878-0025851B.0059D887@notes.na.collabserv.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 04:21:21PM +0000, Bernard Metzler wrote:
> 
> >To: "Bernard Metzler" <BMT@zurich.ibm.com>
> >From: "Jason Gunthorpe" <jgg@ziepe.ca>
> >Date: 02/27/2020 04:53PM
> >Cc: "syzbot" <syzbot+55de90ab5f44172b0c90@syzkaller.appspotmail.com>,
> >chuck.lever@oracle.com, dledford@redhat.com, leon@kernel.org,
> >linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
> >netdev@vger.kernel.org, parav@mellanox.com,
> >syzkaller-bugs@googlegroups.com, willy@infradead.org
> >Subject: [EXTERNAL] Re: possible deadlock in cma_netdev_callback
> >
> >On Thu, Feb 27, 2020 at 10:11:13AM +0000, Bernard Metzler wrote:
> >
> >> Thanks for letting me know! Hmm, we cannot use RCU locks since
> >> we potentially sleep. One solution would be to create a list
> >> of matching interfaces while under lock, unlock and use that
> >> list for calling siw_listen_address() (which may sleep),
> >> right...?
> >
> >Why do you need to iterate over addresses anyhow? Shouldn't the
> >listen
> >just be done with the address the user gave and a BIND DEVICE to the
> >device siw is connected to?
> 
> The user may give a wildcard local address, so we'd have
> to bind to all addresses of that device...

AFAIK a wild card bind using BIND DEVICE works just fine?

Jason
