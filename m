Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8834A1BB34
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729890AbfEMQoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:44:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39850 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729576AbfEMQoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:44:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6A0E14E25416;
        Mon, 13 May 2019 09:44:45 -0700 (PDT)
Date:   Mon, 13 May 2019 09:44:45 -0700 (PDT)
Message-Id: <20190513.094445.551211876164198376.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: fix arp_validate toggling in active-backup
 mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190510215709.19162-1-jarod@redhat.com>
References: <20190510215709.19162-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:44:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 10 May 2019 17:57:09 -0400

> There's currently a problem with toggling arp_validate on and off with an
> active-backup bond. At the moment, you can start up a bond, like so:
 ...
> The problem lies in bond_options.c, where passing in arp_validate=0
> results in bond->recv_probe getting set to NULL. This flies directly in
> the face of commit 3fe68df97c7f, which says we need to set recv_probe =
> bond_arp_recv, even if we're not using arp_validate. Said commit fixed
> this in bond_option_arp_interval_set, but missed that we can get to that
> same state in bond_option_arp_validate_set as well.
> 
> One solution would be to universally set recv_probe = bond_arp_recv here
> as well, but I don't think bond_option_arp_validate_set has any business
> touching recv_probe at all, and that should be left to the arp_interval
> code, so we can just make things much tidier here.
> 
> Fixes: 3fe68df97c7f ("bonding: always set recv_probe to bond_arp_rcv in arp monitor")
 ...
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied and queued up for -stable, thanks.
