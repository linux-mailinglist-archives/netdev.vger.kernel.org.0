Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E99197ED
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 07:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfEJFJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 01:09:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36636 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfEJFJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 01:09:52 -0400
Received: by mail-pl1-f195.google.com with SMTP id d21so2252346plr.3;
        Thu, 09 May 2019 22:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pFPzu6ptUdap+HQEdZU/NpniArB2AscIANfBOrUGg54=;
        b=FYzv4YSGVKRu2v9DOUeHh/yQz0Vz3kt8dQJKQwBwfC0cBZvtEXxTZCywEitn1UpcgW
         XkST+HOc+n4VCqKotPRHzUZ+sFD9AaqDZ/gY9qQXJZi7JDmLnK0msVlgGtQ4rEXXzvBU
         9jVHVsx/+hYxc06UcqUFNWIKOJkeTRI8RmA3teazetsjx2wDS8e+a7jE5a5vGAji+voC
         KI3/U4OHfb0U5jvwHnVIPYCLTLdVP3dF4TXDPNaw7I/h8yVSccI31kwZpnT5J3td4JpG
         /cqP7e4dE7bCNoT4iW/a4wuhxMGDew59r08EXv9AmNyAATkvU6enwUy4+u0B746/euyb
         Yl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pFPzu6ptUdap+HQEdZU/NpniArB2AscIANfBOrUGg54=;
        b=G5q3aTGNFQDqgwJ4kRVWAmcnziz77kLdfmrz3QwlPjNSJXlbS9Xo5ocPMngdUihkoS
         Tk4LIND4ycHOO2F8cy9hjgCO0U5IW6pi4NPqmNzWX7RVmU2P/oTTT0YE3Cr4Grhk74PV
         mNTbEvGXvFq6KoTnsO4r92H97Cb80bILiArN+eStDh1U3IoYgCW1iAdyqOXg/8YTwYyU
         L3gIameajx8R0xIweox+/ONax5pxDYQatYRJESu+ApE19hanP70lsWpY7Ovp7WrumqEP
         SbD0mFQ2S+W8mJ7DuiiErJmIy7FHkaTFZjnG6zZI6HGADC2dr3SKLCuGexttBApEQsJ5
         QkVQ==
X-Gm-Message-State: APjAAAUlTpwAK1eQify4EfXsB+xDKvz+Y3CPSbFCRh5oB3fA2S8UjzoG
        XcHtSCsqsCNSzq7WTHKIXbA=
X-Google-Smtp-Source: APXvYqwuVzLlL0yF6d17Moq5sYdl+fIF2CwKA+mt39Kz91RUlO+cvr4Q989/g+L0bROSSbaGjA6u7w==
X-Received: by 2002:a17:902:2c01:: with SMTP id m1mr5824060plb.108.1557464991733;
        Thu, 09 May 2019 22:09:51 -0700 (PDT)
Received: from bridge ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id 6sm5124653pfd.85.2019.05.09.22.09.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 22:09:51 -0700 (PDT)
Date:   Fri, 10 May 2019 13:09:46 +0800
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/3] auth_gss: netns refcount leaks when use-gss-proxy==1
Message-ID: <20190510050946.GA17994@bridge>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <20190509205218.GA23548@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509205218.GA23548@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 09, 2019 at 04:52:18PM -0400, J. Bruce Fields wrote:
> Thanks for figuring this out!
> 
> I guess I'll take these patches (with the one fix in your response to
> Al) through the nfsd tree, unless someone tells me otherwise.  (The
> original bug was introduced through nfsd.)

Thank you, Bruce.
I am submitting v2 with that fix right away.

> 
> How serious are the consequences of the leak?  I'm wondering if it's
> worth a stable cc or not.

Though the leak only happens with _privileged_ docker containers that have
gssproxy service enabled and use-gss-proxy set to 1, the consequences
can be ugly, the killed/stopped containers not only leave struct net
unfreed, also possibly leave behind veth devices linked to the netns, in
environments that containers are frequently killed/stopped, it is quite
ugly.

> 
> --b.
> 
> On Wed, May 01, 2019 at 02:42:22PM +0800, Wenbin Zeng wrote:
> > This patch series fixes an auth_gss bug that results in netns refcount leaks when use-gss-proxy is set to 1.
> > 
> > The problem was found in privileged docker containers with gssproxy service enabled and /proc/net/rpc/use-gss-proxy set to 1, the corresponding struct net->count ends up at 2 after container gets killed, the consequence is that the struct net cannot be freed.
> > 
> > It turns out that write_gssp() called gssp_rpc_create() to create a rpc client, this increases net->count by 2; rpcsec_gss_exit_net() is supposed to decrease net->count but it never gets called because its call-path is:
> > 	net->count==0 -> cleanup_net -> ops_exit_list -> rpcsec_gss_exit_net
> > Before rpcsec_gss_exit_net() gets called, net->count cannot reach 0, this is a deadlock situation.
> > 
> > To fix the problem, we must break the deadlock, rpcsec_gss_exit_net() should move out of the put() path and find another chance to get called, I think nsfs_evict() is a good place to go, when netns inode gets evicted we call rpcsec_gss_exit_net() to free the rpc client, this requires a new callback i.e. evict to be added in struct proc_ns_operations, and add netns_evict() as one of netns_operations as well.
> > 
> > Wenbin Zeng (3):
> >   nsfs: add evict callback into struct proc_ns_operations
> >   netns: add netns_evict into netns_operations
> >   auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when
> >     use-gss-proxy==1
> > 
> >  fs/nsfs.c                      |  2 ++
> >  include/linux/proc_ns.h        |  1 +
> >  include/net/net_namespace.h    |  1 +
> >  net/core/net_namespace.c       | 12 ++++++++++++
> >  net/sunrpc/auth_gss/auth_gss.c |  9 ++++++---
> >  5 files changed, 22 insertions(+), 3 deletions(-)
> > 
> > -- 
> > 1.8.3.1
