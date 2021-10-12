Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A8C42AF3A
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 23:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhJLVsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 17:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbhJLVsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 17:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB5F060F3A;
        Tue, 12 Oct 2021 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634075178;
        bh=bayt69whk/kJTHyo3bve6DbvoazFFUm1mv1IQhVfL4Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i4lDZRWdvZTNjOkOVgFINTTvyQqa1y1UlyK0NR98ZISzGacCUzu3xQyh/zNQhWFp3
         UgErcsLqXcTuy/nlHnRvNGAlb27z5qFQJlQBlneMP2B1CfcH46LAdR4T36NlT0WjM7
         gg0fQL0ySzjeSj3us2CUhMFTiAlb/KUfaiE+IygsKj4JSlo2K/djC3Zjra8w5u7Tuk
         NUmajfhXKNKCOndbGMBSIzzhO+lKsuSSe/5va7O+ihdGLsilNEsoCWw45B9bU6mY+J
         qbZAQD/XnEJmTHMcrcV5H9O2/r8UToByeprq0UsDfQX0qXLHuRFLRXUDS//5GwYuhS
         VcaxpYEWoDIag==
Date:   Tue, 12 Oct 2021 14:46:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, roopa@nvidia.com, dsahern@kernel.org,
        m@lambda.lt, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net, neigh: Extend neigh->flags to 32 bit
 to allow for extensions
Message-ID: <20211012144616.48df57e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011121238.25542-4-daniel@iogearbox.net>
References: <20211011121238.25542-1-daniel@iogearbox.net>
        <20211011121238.25542-4-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 14:12:37 +0200 Daniel Borkmann wrote:
> +		if (ext & ~0) {
> +			NL_SET_ERR_MSG(extack, "Invalid extended flags");
> +			goto out;
> +		}

Could you also follow up and use NLA_POLICY_MASK() instead of
validating in the code? It's probably less important for non-genl
but still a good best practice.
