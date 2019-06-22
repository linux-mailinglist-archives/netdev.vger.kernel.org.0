Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3194F904
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 01:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFVXrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 19:47:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfFVXrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 19:47:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27D2F153913FE;
        Sat, 22 Jun 2019 16:47:01 -0700 (PDT)
Date:   Sat, 22 Jun 2019 16:47:00 -0700 (PDT)
Message-Id: <20190622.164700.475498860884895501.davem@davemloft.net>
To:     sergej.benilov@googlemail.com
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: fix TX completion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620090218.11549-1-sergej.benilov@googlemail.com>
References: <20190620090218.11549-1-sergej.benilov@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Jun 2019 16:47:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergej Benilov <sergej.benilov@googlemail.com>
Date: Thu, 20 Jun 2019 11:02:18 +0200

> Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
> outbound throughput is dramatically reduced for some connections, as sis900
> is doing TX completion within idle states only.
> 
> Make TX completion happen after every transmitted packet.
> 
> Test:
> netperf
> 
> before patch:
>> netperf -H remote -l -2000000 -- -s 1000000
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to 95.223.112.76 () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380 327680 327680    253.44      0.06
> 
> after patch:
>> netperf -H remote -l -10000000 -- -s 1000000
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to 95.223.112.76 () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380 327680 327680    5.38       14.89
> 
> Thx to Dave Miller and Eric Dumazet for helpful hints
> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>

Applied.
