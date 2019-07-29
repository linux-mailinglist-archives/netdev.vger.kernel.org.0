Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D979AFF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfG2VY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:24:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfG2VY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:24:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1ABA11489C0C1;
        Mon, 29 Jul 2019 14:24:56 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:24:55 -0700 (PDT)
Message-Id: <20190729.142455.1728471766679878919.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/16] bnxt_en: Add TPA (GRO_HW and LRO) on
 57500 chips.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 14:24:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 29 Jul 2019 06:10:17 -0400

> This patchset adds TPA v2 support on the 57500 chips.  TPA v2 is
> different from the legacy TPA scheme on older chips and requires major
> refactoring and restructuring of the existing TPA logic.  The main
> difference is that the new TPA v2 has on-the-fly aggregation buffer
> completions before a TPA packet is completed.  The larger aggregation
> ID space also requires a new ID mapping logic to make it more
> memory efficient.

Series applied, but please explain something to me.

I thought initially while reviewing this that patch #5 makes the series
non-bisectable because this only includes the logic that appends new
entries to the agg array but lacks the changes to reset the agg count
at TPE end time (which occurs in patch #8).

However I then realized that you haven't turned on the logic yet that
can result in CMP_TYPE_RX_TPA_AGG_CMP entries in this context.

Am I right?
