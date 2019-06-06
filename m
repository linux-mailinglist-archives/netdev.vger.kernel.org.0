Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4897336997
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfFFBqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:46:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFFBqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:46:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBA3D13AEF274;
        Wed,  5 Jun 2019 18:46:20 -0700 (PDT)
Date:   Wed, 05 Jun 2019 18:46:20 -0700 (PDT)
Message-Id: <20190605.184620.1429935652147545143.davem@davemloft.net>
To:     ruxandra.radulescu@nxp.com
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 2/3] dpaa2-eth: Support multiple traffic
 classes on Tx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559728646-4332-3-git-send-email-ruxandra.radulescu@nxp.com>
References: <1559728646-4332-1-git-send-email-ruxandra.radulescu@nxp.com>
        <1559728646-4332-3-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 18:46:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Date: Wed,  5 Jun 2019 12:57:25 +0300

> +	queue_mapping %= dpaa2_eth_queue_count(priv);

You are now performing a very expensive modulus operation every single TX
packet, regardless of whether TC is in use or not.

The whole reason we store the queue mapping pre-cooked in the SKB is so
that you don't have to do this.
