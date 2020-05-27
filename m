Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881E41E4CE1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391738AbgE0SMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388720AbgE0SMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:12:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39434C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:12:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89D29128B13F5;
        Wed, 27 May 2020 11:12:14 -0700 (PDT)
Date:   Wed, 27 May 2020 11:12:11 -0700 (PDT)
Message-Id: <20200527.111211.1980078971767456943.davem@davemloft.net>
To:     ivecera@redhat.com
Cc:     dcaratti@redhat.com, netdev@vger.kernel.org, tahiliani@nitk.edu.in,
        jhs@mojatatu.com
Subject: Re: [PATCH net] net/sched: fix infinite loop in sch_fq_pie
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527092451.5ae03435@ceranb>
References: <416eb03a8ca70b5dfb5e882e2752b7fc13c42f92.1590537338.git.dcaratti@redhat.com>
        <20200527092451.5ae03435@ceranb>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:12:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Wed, 27 May 2020 09:24:51 +0200

> On Wed, 27 May 2020 02:04:26 +0200
> Davide Caratti <dcaratti@redhat.com> wrote:
> 
>> this command hangs forever:
>> 
>>  # tc qdisc add dev eth0 root fq_pie flows 65536
>> 
>>  watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [tc:1028]
 ...
>> 
>> we can't accept 65536 as a valid number for 'nflows', because the loop on
>> 'idx' in fq_pie_init() will never end. The extack message is correct, but
>> it doesn't say that 0 is not a valid number for 'flows': while at it, fix
>> this also. Add a tdc selftest to check correct validation of 'flows'.
>> 
>> CC: Ivan Vecera <ivecera@redhat.com>
>> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
 ...
> Good catch, Davide.
> 
> Reviewed-by: Ivan Vecera <ivecera@redhat.com>

Applied and queued up for v5.6 -stable, thanks.
