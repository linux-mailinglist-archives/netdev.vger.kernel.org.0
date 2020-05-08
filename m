Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A3B1CB976
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgEHVHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHVHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 17:07:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619352173E;
        Fri,  8 May 2020 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588972064;
        bh=YBAE91VwnIUcElMZlNPTiW0b+aGnn+Vf4CDzikGE1To=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KqOj+c4pSAIK6KkjUJcNkUYBeTYOF1fOx9svAaBcpbpvYsL0arEP0b3cyJmt4RKNe
         KxzAwI855PRWF31Dgl91XqFKw1vAVM/aaMsgFiFy1DX4q8VtQi4qd4qgjSU1t8reVF
         Bt4Xv3uJAdz+vJDpjUmqCqGlgY7WK/NDwoV0rrTo=
Date:   Fri, 8 May 2020 14:07:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, jgross@suse.com,
        wei.liu@kernel.org, paul@xen.org, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v8 2/3] xen networking: add XDP offset
 adjustment to xen-netback
Message-ID: <20200508140742.351772c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1588855241-29141-2-git-send-email-kda@linux-powerpc.org>
References: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org>
        <1588855241-29141-2-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 May 2020 15:40:40 +0300 Denis Kirjanov wrote:
> +static inline int xenvif_rx_xdp_offset(struct xenvif *vif)

Please don't use static inlines in C files, compiler will know when to
inline and when not. 

> +{
> +	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
> +}
