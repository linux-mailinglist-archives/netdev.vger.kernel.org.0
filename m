Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B51228A41
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgGUU7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUU7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 16:59:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 400CF2068F;
        Tue, 21 Jul 2020 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595365180;
        bh=3cZ9YApgZPolUVJUO65RHZceev1mq3qCgOD74tOPbZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hDUbVb+AQGRRkxevb2sin4i3BfUjkCrYlVBECvwJdF//IPj1Tbxr6rIn79QpAOHjn
         Rfp2e8gc9ydgqIqOt/tGtDYHuanmJAlLDGBJ1likYITqS85PVPkkWXv1h7Itgl+7lr
         wefvKv4WmV+uFCDcY1VCecgK4jnPq0/7h5j6q4V0=
Date:   Tue, 21 Jul 2020 13:59:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 05/29] l2tp: cleanup difficult-to-read line breaks
Message-ID: <20200721135938.46203a0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721173221.4681-6-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
        <20200721173221.4681-6-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 18:31:57 +0100 Tom Parkin wrote:
>  #if IS_ENABLED(CONFIG_IPV6)
> -		if (info->attrs[L2TP_ATTR_IP6_SADDR] &&
> -		    info->attrs[L2TP_ATTR_IP6_DADDR]) {
> -			cfg.local_ip6 = nla_data(
> -				info->attrs[L2TP_ATTR_IP6_SADDR]);
> -			cfg.peer_ip6 = nla_data(
> -				info->attrs[L2TP_ATTR_IP6_DADDR]);
> -		} else
> +		if (attrs[L2TP_ATTR_IP6_SADDR] && attrs[L2TP_ATTR_IP6_DADDR]) {
> +			cfg.local_ip6 = nla_data(attrs[L2TP_ATTR_IP6_SADDR]);
> +			cfg.peer_ip6 = nla_data(attrs[L2TP_ATTR_IP6_DADDR]);
> +		} else {
>  #endif

This no longer builds. Probably because you added the closing backet
which wasn't there?

Please make sure each patch in the submission builds cleanly.

Please split this submission into series of at most 15 patches at a
time, to make sure reviewers don't get overloaded.

Please CC people who are working on the l2tp code (get_maintainers
script is your friend).
