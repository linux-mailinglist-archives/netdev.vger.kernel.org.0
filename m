Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34072AC78B
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 18:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394880AbfIGQLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 12:11:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391081AbfIGQLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 12:11:34 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3981C152F52EA;
        Sat,  7 Sep 2019 09:11:32 -0700 (PDT)
Date:   Sat, 07 Sep 2019 18:11:29 +0200 (CEST)
Message-Id: <20190907.181129.1814581845232128155.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net-next 0/4] net/tls: small TX offload optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190907053000.23869-1-jakub.kicinski@netronome.com>
References: <20190907053000.23869-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 09:11:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri,  6 Sep 2019 22:29:56 -0700

> Hi!
> 
> This set brings small TLS TX device optimizations. The biggest
> gain comes from fixing a misuse of non temporal copy instructions.
> On a synthetic workload modelled after customer's RFC application
> I see 3-5% percent gain.

Series applied.

But if history is any indication I'd watch for how much this actually
helps or hurts universally.  We once tried to use non-temporal stores
for sendmsg/recvmsg copies and had to turn that off because it only
helped in certain situations on certain cpus and hurt in others.
