Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCACC48C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfJDVH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:07:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfJDVH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:07:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14CDE14EC30BC;
        Fri,  4 Oct 2019 14:07:25 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:07:24 -0700 (PDT)
Message-Id: <20191004.140724.479420933444301576.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com
Subject: Re: [PATCH net-next 0/6] net/tls: separate the TLS TOE code out
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:07:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Thu,  3 Oct 2019 11:18:53 -0700

> We have 3 modes of operation of TLS - software, crypto offload
> (Mellanox, Netronome) and TCP Offload Engine-based (Chelsio).
> The last one takes over the socket, like any TOE would, and
> is not really compatible with how we want to do things in the
> networking stack.
> 
> Confusingly the name of the crypto-only offload mode is TLS_HW,
> while TOE-offload related functions use tls_hw_ as their prefix.
> 
> Engineers looking to implement offload are also be faced with
> TOE artefacts like struct tls_device (while, again,
> CONFIG_TLS_DEVICE actually gates the non-TOE offload).
> 
> To improve the clarity of the offload code move the TOE code
> into new files, and rename the functions and structures
> appropriately.
> 
> Because TOE-offload takes over the socket, and makes no use of
> the TLS infrastructure in the kernel, the rest of the code
> (anything beyond the ULP setup handlers) do not have to worry
> about the mode == TLS_HW_RECORD case.
> 
> The increase in code size is due to duplication of the full
> license boilerplate. Unfortunately original author (Dave Watson)
> seems unreachable :(

Series applied.
