Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38457203
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFZTtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:49:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZTtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:49:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A42114DB6E16;
        Wed, 26 Jun 2019 12:49:18 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:49:17 -0700 (PDT)
Message-Id: <20190626.124917.1144578915345631665.davem@davemloft.net>
To:     csully@google.com
Cc:     netdev@vger.kernel.org, sagis@google.com, jonolson@google.com,
        willemb@google.com, lrizzo@google.com
Subject: Re: [net-next 2/4] gve: Add transmit and receive support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626185251.205687-3-csully@google.com>
References: <20190626185251.205687-1-csully@google.com>
        <20190626185251.205687-3-csully@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 12:49:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>
Date: Wed, 26 Jun 2019 11:52:49 -0700

> +#ifdef __LITTLE_ENDIAN
> +#define GVE_SEQNO(x) ((((__force u16)x) >> 8) & 0x7)
> +#else
> +#define	GVE_SEQNO(x) ((__force u16)(x) & 0x7)
> +#endif

This can be simply "le16_to_cpu(x) & 0x7" or similar.  No need to
messy ifdefs.

