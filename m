Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7D3123FCC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfLRGt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:49:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRGt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:49:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C286115031595;
        Tue, 17 Dec 2019 22:49:55 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:49:55 -0800 (PST)
Message-Id: <20191217.224955.497657953140914814.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net 1/1] nfp: flower: fix stats id allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576582136-26701-1-git-send-email-john.hurley@netronome.com>
References: <1576582136-26701-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:49:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Tue, 17 Dec 2019 11:28:56 +0000

> As flower rules are added, they are given a stats ID based on the number
> of rules that can be supported in firmware. Only after the initial
> allocation of all available IDs does the driver begin to reuse those that
> have been released.
> 
> The initial allocation of IDs was modified to account for multiple memory
> units on the offloaded device. However, this introduced a bug whereby the
> counter that controls the IDs could be decremented before the ID was
> assigned (where it is further decremented). This means that the stats ID
> could be assigned as -1/0xfffffff which is out of range.
> 
> Fix this by only decrementing the main counter after the current ID has
> been assigned.
> 
> Fixes: 467322e2627f ("nfp: flower: support multiple memory units for filter offloads")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied and queued up for -stable, thanks.
