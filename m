Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02BB301DF
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfE3S0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:26:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfE3S0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:26:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19E9F14D92C59;
        Thu, 30 May 2019 11:26:31 -0700 (PDT)
Date:   Thu, 30 May 2019 11:26:30 -0700 (PDT)
Message-Id: <20190530.112630.476132829981439143.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        linville@redhat.com, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: copy reglen to userspace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530082722.GB27401@unicorn.suse.cz>
References: <20190529.221744.1136074795446305909.davem@davemloft.net>
        <20190530064848.GA27401@unicorn.suse.cz>
        <20190530082722.GB27401@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:26:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 30 May 2019 10:27:22 +0200

> I believe this should be handled by ethtool_get_regs(), either by
> returning an error or by only copying data up to original regs.len
> passed by userspace. The former seems more correct but broken userspace
> software would suddenly start to fail where it "used to work". The
> latter would be closer to current behaviour but it would mean that
> broken userspace software might nerver notice there is something wrong.

I therefore think we need to meticulously fixup all of these adjustments
of regs.len before adjusting the copy call here in generic ethtool.
