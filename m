Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE528E9F7
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732186AbgJOBZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388656AbgJOBZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 21:25:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 375BD22254;
        Thu, 15 Oct 2020 01:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602725101;
        bh=YBLKi6Mjxj4D8HFHFUdrANVKThhTNBXxCoH7elR16Fo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S96Y7gqs+XYulv3FBSXhNovrcXPpSYjTuXw1F8glDjdxTUWKoNEZZa8IIIIYXmkXt
         D6Vvc0Z2dP2cFoiz2QirE36flYpb2JXEiTPU90KtY9oyUEumF1zXldb5HSOdZReix+
         UnNOvtr3ne72LNidKfP+n9tgWJdVIzNFZB6PynSQ=
Date:   Wed, 14 Oct 2020 18:24:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herat Ramani <herat@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, rahul@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: handle 4-tuple PEDIT to NAT mode
 translation
Message-ID: <20201014182459.68896a93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201013093129.321-1-herat@chelsio.com>
References: <20201013093129.321-1-herat@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 15:01:29 +0530 Herat Ramani wrote:
> The 4-tuple NAT offload via PEDIT always overwrites all the 4-tuple
> fields even if they had not been explicitly enabled. If any fields in
> the 4-tuple are not enabled, then the hardware overwrites the
> disabled fields with zeros, instead of ignoring them.
> 
> So, add a parser that can translate the enabled 4-tuple PEDIT fields
> to one of the NAT mode combinations supported by the hardware and
> hence avoid overwriting disabled fields to 0. Any rule with
> unsupported NAT mode combination is rejected.
> 
> Signed-off-by: Herat Ramani <herat@chelsio.com>

Looks good, applied, but to net. 

Not rejecting unsupported configurations is a bug.

Unless you tell me otherwise I'll also queue this for stable.

Thanks!
