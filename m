Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C17FF560
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKPUJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:09:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfKPUJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:09:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DD2015171A6C;
        Sat, 16 Nov 2019 12:09:36 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:09:34 -0800 (PST)
Message-Id: <20191116.120934.1197611919693218297.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next 0/2] net: introduce and use route hint
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1573893340.git.pabeni@redhat.com>
References: <cover.1573893340.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:09:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Sat, 16 Nov 2019 10:14:49 +0100

> This series leverages the listification infrastructure to avoid
> unnecessary route lookup on ingress packets. In absence of policy routing,
> packets with equal daddr will usually land on the same dst.
> 
> When processing packet bursts (lists) we can easily reference the previous
> dst entry. When we hit the 'same destination' condition we can avoid the
> route lookup, coping the already available dst.
> 
> Detailed performance numbers are available in the individual commit messages.

Looks like there are some problems with the unconditional use of
fib{6}_has_custom_rules in this series.
