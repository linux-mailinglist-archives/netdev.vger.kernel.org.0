Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CF72B12F0
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgKLX7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:59:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLX7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:59:31 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4566320723;
        Thu, 12 Nov 2020 23:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225570;
        bh=RZR/L+Lo8hL5ZFTmGLqghTYNPmizeHYpxoKQH2rS8C8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hf0vkbMI9+KRXRj/eueXLH4K61UXhSzRIJnoW+dfntDH3VaO55HLRxBA5Jv527Tpi
         yk/9oV6sSC2YRKrROkQrNYrNVEKYgLZJ2dldP0r1tUP4WpIOiU2ASJfViIpSeOVS24
         BQee0yyzXiiOCwzELOHUzOp3KHxWMTzwS/Iip0QU=
Date:   Thu, 12 Nov 2020 15:59:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 00/15] mlxsw: spectrum: Prepare for XM
 implementation - prefix insertion and removal
Message-ID: <20201112155929.62b33304@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 11:48:45 +0200 Ido Schimmel wrote:
> Jiri says:
> 
> This is a preparation patchset for follow-up support of boards with
> extended mezzanine (XM), which is going to allow extended (scale-wise)
> router offload.
> 
> XM requires a separate PRM register named XMDR to be used instead of
> RALUE to insert/update/remove FIB entries. Therefore, this patchset
> extends the previously introduces low-level ops to be able to have
> XM-specific FIB entry config implementation.
> 
> Currently the existing original RALUE implementation is moved to "basic"
> low-level ops.
> 
> Unlike legacy router, insertion/update/removal of FIB entries into XM
> could be done in bulks up to 4 items in a single PRM register write.
> That is why this patchset implements "an op context", that allows the
> future XM ops implementation to squash multiple FIB events to single
> register write. For that, the way in which the FIB events are processed
> by the work queue has to be changed.
> 
> The conversion from 1:1 FIB event - work callback call to event queue is
> implemented in patch #3.
> 
> Patch #4 introduces "an op context" that will allow in future to squash
> multiple FIB events into one XMDR register write. Patch #12 converts it
> from stack to be allocated per instance.
> 
> Existing RALUE manipulations are pushed to ops in patch #10.
> 
> Patch #13 is introducing a possibility for low-level implementation to
> have per FIB entry private memory.
> 
> The rest of the patches are either cosmetics or smaller preparations.

Applied, thanks!
