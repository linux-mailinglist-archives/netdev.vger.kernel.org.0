Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78C0453D2A
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 01:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhKQAe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 19:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhKQAe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 19:34:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F8461BBD;
        Wed, 17 Nov 2021 00:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637109121;
        bh=6D72CXxrpJoipILvmzEalBbO3LRwJUbFZI/GQU3YKwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pJWA3xGu3neA8Dr9/4JkpxA9UubuwCaJVHiwR83rm/mWeJgV4zXWAp/jLbkcMRc+S
         15ebV7VXI4TPJm6CGsbWDFFqGm0ck6u7kMj0iD3lEd92o5nl44RJlN9KJWPQe3qxvM
         20MGwdYS1K9+LxPWIv3253bnNuEinUjWPsBZ0PG3f39/BQ4ZPrL4wViq5L1wDpZYjO
         nJc3mES5QYvOZEi7c8LJgQGBRttJFLuuNiIvdhaMljYMtMhRXdIF76QbbKwy2XzniM
         eabl5BBAyEx/EbwudMGJvnkw0cOWCuO6XlmCVuv5pIJN4jHgrDDcyxY5snew6ThkKh
         w0+W2CFGuw/BA==
Date:   Tue, 16 Nov 2021 16:31:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v18 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <20211116163159.56e1c957@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZRI+ac4c0j/eue5@lore-desk>
References: <cover.1637013639.git.lorenzo@kernel.org>
        <ce5ad30af8f9b4d2b8128e7488818449a5c0d833.1637013639.git.lorenzo@kernel.org>
        <20211116071357.36c18edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZRI+ac4c0j/eue5@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 01:12:41 +0100 Lorenzo Bianconi wrote:
> ack, you are right. Sorry for the issue.
> I did not trigger the problem with xdp-mb self-tests since we will not run
> bpf_xdp_copy_buf() in this specific case, but just the memcpy()
> (but what you reported is a bug and must be fixed). I will add more
> self-tests.
> Moreover, reviewing the code I guess we can just update bpf_xdp_copy() for our case.
> Something like:

Seems reasonable.  We could probably play some tricks with double
pointers to avoid the ternary operator being re-evaluated for each
chunk. But even if it's faster it is probably not worth the ugliness
of the code.
