Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1C19D8FA
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfHZWSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:18:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbfHZWSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:18:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0721F15251086;
        Mon, 26 Aug 2019 15:18:19 -0700 (PDT)
Date:   Mon, 26 Aug 2019 15:18:19 -0700 (PDT)
Message-Id: <20190826.151819.804077961408964282.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     dsahern@gmail.com, jiri@resnulli.us, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, sthemmin@microsoft.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add
 and delete alternative ifnames
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190826151552.4f1a2ad9@cakuba.netronome.com>
References: <20190826095548.4d4843fe@cakuba.netronome.com>
        <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
        <20190826151552.4f1a2ad9@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 26 Aug 2019 15:18:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 26 Aug 2019 15:15:52 -0700

> Weren't there multiple problems with the size of the RTM_NEWLINK
> notification already? Adding multiple sizeable strings to it won't
> help there either :S

Indeed.

We even had situations where we had to make the information provided
in a newlink dump opt-in when we added VF info because the buffers
glibc was using at the time were too small and this broke so much
stuff.

I honestly think that the size of link dumps are out of hand as-is.
