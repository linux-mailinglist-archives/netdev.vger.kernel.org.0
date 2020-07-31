Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7907234BAD
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 21:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgGaTji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 15:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgGaTji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 15:39:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBBE72076B;
        Fri, 31 Jul 2020 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596224378;
        bh=kcmLfanjdqpjSrohQjeE9D3iHfnpPoAT8Ip5bHqtSHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I2KqznqTleZXgK872wtyCDPZ6i2MajWvXBgd3+xqJnC6vG+fOchNngkcwd9jtDl99
         /QguzJBD77UVTXTH93Ob8r8qFvKlWjoeuvRneGkvzuaRW2AEU72moauE/N102VqTPr
         k8VMHgbrl2Whkd0/1vZFVqQClQ8eVUoNQa68J8pA=
Date:   Fri, 31 Jul 2020 12:39:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 04/11] sfc_ef100: TX path for EF100 NICs
Message-ID: <20200731123936.38680a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9776704b-d4b0-7477-42ba-f82ad3d4ec48@solarflare.com>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
        <9776704b-d4b0-7477-42ba-f82ad3d4ec48@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 13:59:04 +0100 Edward Cree wrote:
> +static inline efx_oword_t *ef100_tx_desc(struct efx_tx_queue *tx_queue,
> +					 unsigned int index)

Does this static inline make any difference?

You know the general policy...

> +{
> +	if (likely(tx_queue->txd.buf.addr))
> +		return ((efx_oword_t *)tx_queue->txd.buf.addr) + index;
> +	else
> +		return NULL;
> +}
