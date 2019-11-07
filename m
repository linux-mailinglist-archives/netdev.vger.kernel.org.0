Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE9AF3C52
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfKGXtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:49:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKGXtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:49:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8EF571537E161;
        Thu,  7 Nov 2019 15:49:22 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:49:22 -0800 (PST)
Message-Id: <20191107.154922.1123372183066604716.davem@davemloft.net>
To:     Mark-MC.Lee@mediatek.com
Cc:     sean.wang@mediatek.com, john@phrozen.org, matthias.bgg@gmail.com,
        andrew@lunn.ch, robh+dt@kernel.org, mark.rutland@arm.com,
        opensource@vdorst.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net] net: ethernet: mediatek: rework GDM setup flow
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107105135.1403-1-Mark-MC.Lee@mediatek.com>
References: <20191107105135.1403-1-Mark-MC.Lee@mediatek.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:49:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: MarkLee <Mark-MC.Lee@mediatek.com>
Date: Thu, 7 Nov 2019 18:51:35 +0800

> +	for (i = 0; i < 2; i++) {

This is a regression, because in the existing code...

> -	for (i = 0; i < MTK_MAC_COUNT; i++) {

the proper macro is used instead of a magic constant.

You're doing so many things in one change, it's hard to review
and audit.

If you're going to consolidate code, do that only in one change.

Then make other functional changes such as putting the chip into
GDMA_DROP_ALL mode during the stop operation etc.
