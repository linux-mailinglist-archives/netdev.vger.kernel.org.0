Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EE745E004
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 18:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhKYRzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 12:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347496AbhKYRxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 12:53:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE3761100;
        Thu, 25 Nov 2021 17:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637862631;
        bh=/IA8K3T4Iaf+6hOl7F0MiFTRMVGD4yFS/MrT5SpwUpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SMtLQaOf0Fm5fQ7/8yCOx/LLolnC9LXuT5Lzf3O8i3MAzt6aaA/g8TPGz7loQ2xo+
         SbKTpQpEBDF6dU2LnGJk0BUlmO5qhEhQYAjcZQbwozwW0WXLg1JtXkiXMJ/NPGdPLT
         Jd8Hl87sMmgK6ZjkLi1blDX64UoeW+GL4ddBmZ1SyXanjVl5uY1D9cCFDle4Wsv2Wx
         mFHbmcmRAxOPENwmHozgbUTSGbPiOMy4KJWN8NBsxF9S8FNIgVwC9bCrAFsbCfdJQG
         0KSPYpGDOQ31aC+8yT2ZoBfk1SyhpAYkYlmS1LN1s0f2jPF6LFFmO2Wet+gzdlDUf+
         TMz6t2YlOAH+Q==
Date:   Thu, 25 Nov 2021 09:50:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Subject: Re: [PATCH net-next 4/4] net: mvneta: Add TC traffic shaping
 offload
Message-ID: <20211125095029.342b3594@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125154813.579169-5-maxime.chevallier@bootlin.com>
References: <20211125154813.579169-1-maxime.chevallier@bootlin.com>
        <20211125154813.579169-5-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 16:48:13 +0100 Maxime Chevallier wrote:
> The mvneta controller is able to do some tocken-bucket per-queue traffic
> shaping. This commit adds support for setting these using the TC mqprio
> interface.
> 
> The token-bucket parameters are customisable, but the current
> implementation configures them to have a 10kbps resolution for the
> rate limitation, since it allows to cover the whole range of max_rate
> values from 10kbps to 5Gbps with 10kbps increments.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Breaks 32bit build, please make sure you use division helpers for 64b.
