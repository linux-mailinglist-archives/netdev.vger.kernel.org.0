Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7A28EBAE
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 05:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgJODme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 23:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgJODmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 23:42:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A0DD22243;
        Thu, 15 Oct 2020 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602733353;
        bh=GwGUyejOLstRN1Fx4fxG6UMNfecHd9+GCmbEcvKveDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jcq/f5ElfKyGA7WuJZI8Uj77rhyk9lOWDtsa6Ri+ARf5GN08JDiomJLzOk9WxVje5
         ZmmVeQXM5UxxQjiDo/osNUogJS/dnVrTRzXL6i+y4kppPZIxtzmiYRdtrUHbrcGL2Z
         Wyw1rGvjsRXk4tNEWMIpJvhOFF2eiMJuo4Ex0ja4=
Date:   Wed, 14 Oct 2020 20:42:30 -0700
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
Subject: Re: [PATCH 2/2] Revert "dccp: don't free ccid2_hc_tx_sock struct in
 dccp_disconnect()"
Message-ID: <20201014204230.56cbfb12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013171849.236025-3-kleber.souza@canonical.com>
References: <20201013171849.236025-1-kleber.souza@canonical.com>
        <20201013171849.236025-3-kleber.souza@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 19:18:49 +0200 Kleber Sacilotto de Souza wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 
> This reverts commit 2677d20677314101293e6da0094ede7b5526d2b1.
> 
> This fixes an issue that after disconnect, dccps_hc_tx_ccid will still be
> kept, allowing the socket to be reused as a listener socket, and the cloned
> socket will free its dccps_hc_tx_ccid, leading to a later use after free,
> when the listener socket is closed.
> 
> This addresses CVE-2020-16119.
> 
> Fixes: 2677d2067731 (dccp: don't free ccid2_hc_tx_sock struct in dccp_disconnect())
> Reported-by: Hadar Manor

Does this person has an email address?

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
