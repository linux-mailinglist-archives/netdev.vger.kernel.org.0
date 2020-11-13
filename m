Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EB02B1442
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKMC1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgKMC1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 21:27:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B196D21D46;
        Fri, 13 Nov 2020 02:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605234467;
        bh=lJo8H8xzAfGXKfmnObc84RcjmPNiGOatyhu4uqhClKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zLMBast8MYIXzgEfYwsDoiCEFs+njP4spsA1lMxENr8zSk1OsmIQlahZCaEn/fC85
         HZLLNV9HF0CqFgymdkqq3qlu4nFwxugDGmLRSK8morGj5Kujck0hiPSRE31cvEgRqj
         vpUW0f5tBfoWyLRJiqOYhiHyM3czaPVNfyWy9snI=
Date:   Thu, 12 Nov 2020 18:27:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net] net/tls: Fix wrong record sn in async mode of
 device resync
Message-ID: <20201112182745.18f29304@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111125556.7414-1-tariqt@nvidia.com>
References: <20201111125556.7414-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 14:55:56 +0200 Tariq Toukan wrote:
> +static inline bool tls_bigint_subtract(unsigned char *seq, int len, u16 n)

Please make n something more natural than u16. Helper should be
general, not just serving the current use case.


> +	if (WARN_ON_ONCE(len != 8))

You can do a BUILD_BUG_ON on TLS_MAX_REC_SEQ_SIZE instead, please.

> +		/* shouldn't get to wraparound, too long in async stage, something bad happened */

Umpf. Please wrap this comment.

In general for networking code prefer the 80 char wrapping.
