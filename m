Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9228EBB2
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgJODn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgJODnZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 23:43:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5002122241;
        Thu, 15 Oct 2020 03:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602733405;
        bh=azE8D6Jip/DfgDAtotq0y1JFG3w8UjkW+iU0XO+pqEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HL9yxG0LA7lztRKCg0XUK3Be9kv6e3tjQu8ZiPTS7dwkZVHhTXJKycsESwIb3cfQA
         sHAor+N4tCr5gHZzLqfSycvS4W/HQbVyEfIqf8tNLPUNzAlBlz+yVmGdWOnNlpVacn
         dLWwDfcWmnGcLhiJRUtJxA3GPdJEMbUdYYpSY07c=
Date:   Wed, 14 Oct 2020 20:43:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>
Cc:     netdev@vger.kernel.org, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
Message-ID: <20201014204322.7a51c375@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013171849.236025-2-kleber.souza@canonical.com>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
        <20201013171849.236025-2-kleber.souza@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 19:18:48 +0200 Kleber Sacilotto de Souza wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 
> When dccps_hc_tx_ccid is freed, ccid timers may still trigger. The reason
> del_timer_sync can't be used is because this relies on keeping a reference
> to struct sock. But as we keep a pointer to dccps_hc_tx_ccid and free that
> during disconnect, the timer should really belong to struct dccp_sock.
> 
> This addresses CVE-2020-16119.
> 
> Fixes: 839a6094140a (net: dccp: Convert timers to use timer_setup())

Presumably you chose this commit because the fix won't apply beyond it?
But it really fixes 2677d2067731 (dccp: don't free.. right?

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
