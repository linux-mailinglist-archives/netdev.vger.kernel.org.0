Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60C2A3F7F
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfH3VMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:12:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3VMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:12:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9EF21154FE281;
        Fri, 30 Aug 2019 14:12:00 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:12:00 -0700 (PDT)
Message-Id: <20190830.141200.1276391338286705378.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, olteanv@gmail.com
Subject: Re: [PATCH net v1] net/sched: cbs: Fix not adding cbs instance to
 list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828173615.4264-1-vinicius.gomes@intel.com>
References: <20190828173615.4264-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 14:12:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed, 28 Aug 2019 10:36:15 -0700

> When removing a cbs instance when offloading is enabled, the crash
> below can be observed. Also, the current code doesn't handle correctly
> the case when offload is disabled without removing the qdisc: if the
> link speed changes the credit calculations will be wrong.

I think it does handle that case correctly, because in the !offloaded
code path of cbs_change() it makes an explict call to the function
cbs_set_port_rate().

And that is the only location where offload can be disabled on an
already existing instance.

If you agree, please fix your commit message to be more accurate on
this point.

Thank you.
