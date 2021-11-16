Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F04534C4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbhKPPCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:02:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233685AbhKPPCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:02:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65AAB63214;
        Tue, 16 Nov 2021 14:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637074773;
        bh=pjB6O+aUHoni3cu9m/ZbVHzvVFAReA05DhRF1b9WHiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f1v5m06TLUbsHhYyau9vNn/FK6rRsgPoOuYpCii9k17PJ721S/mJm+Ro9ErMIbcTg
         7+Pxovf8qOQmPzTvhsbKp+EObXXznqlvZgQu6Wo8oQOohJppHKwbcIKGjRvDFMxy23
         pcupUuQUcY0FSRrLBU5gTxShVJtY+TKz2cbQr9yRYpadP4Omkpshq79zuuRVCiO0Q3
         l9jO40e3QkRdiwQQlM0v4vekLVpfcEh3DetzYY9fTh5SDXwoW4uLYZ13JcpR7UZopX
         LbnDEEH3l/urAN4OlfV8HYMOGgR04aYXxl+oO7wPk873QeJ0InfJfEGrsF4Hbrm7Ns
         2AswmDz5OFumg==
Date:   Tue, 16 Nov 2021 06:59:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v18 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20211116065931.054266c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c1ba406957cced3c0c4f35c8763b37cd0a902839.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
        <c1ba406957cced3c0c4f35c8763b37cd0a902839.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 23:33:06 +0100 Lorenzo Bianconi wrote:
> +	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)

Why the latter check?

> +		return -EOPNOTSUPP;
> +
> +	tailroom = rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag);

Looks good. We can adjust/extend the exact semantics as drivers add
support. Important part is we should be safe from negligence.

Acked-by: Jakub Kicinski <kuba@kernel.org>
