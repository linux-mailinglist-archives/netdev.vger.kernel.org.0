Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B037E8A64B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfHLS1O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Aug 2019 14:27:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49134 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHLS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:27:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87584154B1F06;
        Mon, 12 Aug 2019 11:27:13 -0700 (PDT)
Date:   Mon, 12 Aug 2019 11:27:10 -0700 (PDT)
Message-Id: <20190812.112710.2043086880271864277.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     liuhangbin@gmail.com, netdev@vger.kernel.org, joe@perches.com
Subject: Re: [PATCHv2 net 0/2] Add netdev_level_ratelimited to avoid netdev
 msg flush
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9bb8e9af-4d9b-7c16-f58d-e299b1f30007@linux.ibm.com>
References: <20190811.210820.1168889173898610979.davem@davemloft.net>
        <20190812073733.GV18865@dhcp-12-139.nay.redhat.com>
        <9bb8e9af-4d9b-7c16-f58d-e299b1f30007@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Aug 2019 11:27:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Mon, 12 Aug 2019 10:56:39 -0500

> Hi, thanks for reporting this. I was able to recreate this on my own
> system. The virtual ethernet's multicast filter list size is limited,
> and the driver will check that there is available space before adding
> entries.  The problem is that the size is encoded as big endian, but
> the driver does not convert it for little endian systems after
> retrieving it from the device tree.  As a result the driver is
> requesting more than the hypervisor can allow and getting this error
> in reply. I will submit a patch to correct this soon.

This is 1,000 times better than just trying to make the warning message
go away, thanks Thomas!
