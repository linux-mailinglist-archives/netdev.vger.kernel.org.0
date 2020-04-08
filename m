Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E4E1A2BF8
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDHWnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:43:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46854 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgDHWnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 18:43:00 -0400
Received: by mail-qt1-f196.google.com with SMTP id g7so1290963qtj.13;
        Wed, 08 Apr 2020 15:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ko4uGSDcQBC0ZMvFYKvwGCBvqKAgRQ/uBDkQUM1icWE=;
        b=mkJLZXzbRGw4XvDrLpTkNq/iEjJYZuen+37ek1g2fH0P+DiNEL4M/ljg96Rc3xBI5j
         UJEb3dzOlBbsr3Tin3aGxzfv0mTGTbKKPBAjouDBZNZby3bbgoUiMRhuGOFuOFdZp0oA
         5DdOZb+F1TRwg8wDVpc4Ph4nmCiJwpCMYQmjQ6XVmHF2yoWBRLQA9oPw9GwmYZ6iKTL9
         JuGMXLR0thD4TJ+WJbcTaT8k7x7rGkmgsG+05nVlwF5Q6Cd4AbRBaE9az+2a28PqWG70
         iA4D/Dxx7gzqjTv7CwITqtTRIPIcEAzXkRMfJcOrffFNpijApapRX9P0ZQ3rF1K7nHrW
         a4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ko4uGSDcQBC0ZMvFYKvwGCBvqKAgRQ/uBDkQUM1icWE=;
        b=U0x+UGe3S7LG0g8BzrzY+9hI2PLLGD07ODEURaSkE3eSebHwnxBv76otXvIpy3c7AN
         TmWvD46SqcSx8tLRBqJw20gS3iJ2ugUbZrrEm3/WLKWVvP3Yt8L36yWpwCsQ9HBSOy1L
         2jG5tgrxIznWfGPlecMk+7eH4ovJ8ToooFENf4dtPnClIMPYC9ABwWgO/zQuYpMKaQUa
         obSKR8jND7FonzDJ3E2nxOEb6k2qJ9jtEjNjZnsYAttxfe11XPyMKRDOJwEv3h2xvS1U
         ZVXrXKs7ArjWJju76RfMwnNGGL4T6C9vva+gZS+Cw55tqxr6lzCtmF+9h0TG53tfnGDi
         fFUw==
X-Gm-Message-State: AGi0PuYOUhiwJ+TSBBIghwK3QzigM+2W1rkNJit76siBvU8eUhZPAS0X
        0qtkZOCOKvrt5nd3aQe4Jps=
X-Google-Smtp-Source: APiQypJmltrwaUggaAzXhForYzdq+KhpRNYCeHSClJIAHGn2Jz1r/BXrU0bsBVMB7ADHs2iDTs+mpQ==
X-Received: by 2002:ac8:43c3:: with SMTP id w3mr2026364qtn.350.1586385779215;
        Wed, 08 Apr 2020 15:42:59 -0700 (PDT)
Received: from localhost.localdomain ([177.220.176.139])
        by smtp.gmail.com with ESMTPSA id d189sm10869211qkf.118.2020.04.08.15.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 15:42:58 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1B156C5510; Wed,  8 Apr 2020 19:42:56 -0300 (-03)
Date:   Wed, 8 Apr 2020 19:42:56 -0300
From:   "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5e: limit log messages due to (ovs) probing
 to _once
Message-ID: <20200408224256.GB137894@localhost.localdomain>
References: <d57b95462cccf0f67089c91d3dfd3d1f4c46e9bf.1585872570.git.marcelo.leitner@gmail.com>
 <c4e43a61a8ad7f57e2cb228cc0ba810b68af89cb.camel@mellanox.com>
 <20200403024835.GA3547@localhost.localdomain>
 <d4c0225fc25a6979c6f6863eaf84ee4d4d0a7972.camel@mellanox.com>
 <20200408215422.GA137894@localhost.localdomain>
 <54e70f800bc8f3b4d2dc7ddea02c1baa0036ea54.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e70f800bc8f3b4d2dc7ddea02c1baa0036ea54.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 10:38:52PM +0000, Saeed Mahameed wrote:
> On Wed, 2020-04-08 at 18:54 -0300, marcelo.leitner@gmail.com wrote:
> > On Wed, Apr 08, 2020 at 07:51:22PM +0000, Saeed Mahameed wrote:
> > ...
> > > > > I understand it is for debug only but i strongly suggest to not
> > > > > totally
> > > > > suppress these messages and maybe just move them to tracepoints
> > > > > buffer
> > > > > ? for those who would want to really debug .. 
> > > > > 
> > > > > we already have some tracepoints implemented for en_tc.c 
> > > > > mlx5/core/diag/en_tc_tracepoints.c, maybe we should define a
> > > > > tracepoint
> > > > > for error reporting .. 
> > > > 
> > > > That, or s/netdev_warn/netdev_dbg/, but both are more hidden to
> > > > the
> > > > user than the _once.
> > > > 
> > > 
> > > i don't see any reason to pollute kernel log with debug messages
> > > when
> > > we have tracepoint buffer for en_tc .. 
> > 
> > So we're agreeing that these need to be changed. Good.
> 
> I would like to wait for the feedback from the CC'ed mlnx TC
> developers..
> 
> I just pinged them, lets see what they think.
> 
> but i totally agree, TC can support 100k offloads requests per seconds,
> dumping every possible issue to the kernel log shouldn't be an option,this is not a boot or a fatal error/warning .. 
> 
> > 
> > I don't think a sysadmin would be using tracepoints for
> > troubleshooting this, but okay. My only objective here is exactly
> > what
> > you said, to not pollute kernel log too much with these potentially
> > repetitive messages.
> 
> these types of errors are easily reproduce-able, a sysadmin can see and
> report the errno and the extack message, and in case it is really
> required, the support or development team can ask to turn on trace-
> points or debug and reproduce .. 

Roger that, thanks Saeed.
