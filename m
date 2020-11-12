Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BBF2AFCEC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgKLBcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbgKLA5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 19:57:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8842063A;
        Thu, 12 Nov 2020 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605142637;
        bh=LXOjJTlBrifP9chbMn81H99NI05L0et/1Ys0yqCiLK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ai2aLhsFQQmOUVdhlcal1EG1H6N6ijS2/z+WGjQxiYFIkzkvn9gjpl5mL5jy3o0BI
         4Um62Qrfdq5ymhwKduTyWa+iC19lwmPYM19NwtG9k1TDpDLONS1FYoT/SQE0GguTf4
         W0dE07SjNYtAVHRVq16ggd2SnTD3oaZe4XxNud8c=
Date:   Wed, 11 Nov 2020 16:57:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: Fix re-registering ncsi device
Message-ID: <20201111165716.760829aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112004021.834673-1-joel@jms.id.au>
References: <20201112004021.834673-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 11:10:21 +1030 Joel Stanley wrote:
> If a user unbinds and re-binds a ncsi aware driver, the kernel will
> attempt to register the netlink interface at runtime. The structure is
> marked __ro_after_init so this fails at this point.

netlink family should be registered at module init and unregistered at
unload. That's a better fix IMO.
