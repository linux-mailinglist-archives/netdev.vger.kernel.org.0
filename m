Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264103E2B35
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 15:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbhHFNM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 09:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231388AbhHFNM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 09:12:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3999604DB;
        Fri,  6 Aug 2021 13:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628255497;
        bh=Tr1IB48QyqqZw+MLNXRX+N03dm0H0jBEHbZKl+s5DGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6nSVj1EL2bF5suI3OHAKFiK25b7bGsMTEh7hW5r2H/f5cAfFK7CEep5Ztgf5ycVF
         BalSx4PxAFW+/aBlEh53ddRlb65p8ksc9tfEh080Wrl6yNOmHcpXsHzJAMHPzPCEuC
         TMqNiTGXsqYQ/ZJ4AH+bz99Y+eI1TVeo2/X1Ct7PZpX9Jxg7hJrVpdlqNx9CFF5aET
         6H/YiEcj1TASb6dgy7WMezaPjLBA318R4aC+2nJ3LH2jT08ZQ3YyILiOHWmYD8yLTz
         gapSxovbkTrSozFh03F2vsE2JL01QDuW0Th7QdQrDyOAfbChpiCTI/PaFlNRPMy/Kf
         hYh0WLOdoz/OQ==
Date:   Fri, 6 Aug 2021 06:11:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sock: add the case if sk is NULL
Message-ID: <20210806061136.54e6926e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806063815.21541-1-yajun.deng@linux.dev>
References: <20210806063815.21541-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Aug 2021 14:38:15 +0800 Yajun Deng wrote:
> Add the case if sk is NULL in sock_{put, hold},
> The caller is free to use it.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

The obvious complaint about this patch (and your previous netdev patch)
is that you're spraying branches everywhere in the code. Sure, it may
be okay for free(), given how expensive of an operation that is but
is having refcounting functions accept NULL really the best practice?

Can you give us examples in the kernel where that's the case?
