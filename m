Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B7321F73A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgGNQXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgGNQXl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:23:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE41922525;
        Tue, 14 Jul 2020 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594743821;
        bh=6THZ0azZ2145BsxpgpdagQ7qlkVlMUrEQfOcRx4OM+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A2AR/FEoTkBLklVGkH5YIiaMfC4ET/boHAn+YX0hmcfmfFC/O0c2EzzS5JG+hTOYi
         q2oJxGOQ55Galpu1HKe007nQ7bkiixr3JWuQPZEWIr/N0KQja/pv1SqBNXREPpLjXh
         3dD3hMsqUYedOFShEG6Gw64IK9Xy/eHbT2gLqMvg=
Date:   Tue, 14 Jul 2020 09:23:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Boris Pismenny <borisp@mellanox.com>
Cc:     David Miller <davem@davemloft.net>, john.fastabend@gmail.com,
        daniel@iogearbox.net, tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tls: add zerocopy device sendpage
Message-ID: <20200714092339.6aa12add@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e538c2bc-b8b5-c5d9-05a3-a385d2c809e4@mellanox.com>
References: <1594550649-3097-1-git-send-email-borisp@mellanox.com>
        <20200712.153233.370000904740228888.davem@davemloft.net>
        <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
        <20200713.120530.676426681031141505.davem@davemloft.net>
        <9d13245f-4c0d-c377-fecf-c8f8d9eace2a@mellanox.com>
        <20200713155906.097a6fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e538c2bc-b8b5-c5d9-05a3-a385d2c809e4@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 10:31:25 +0300 Boris Pismenny wrote:
> Now we have an ASIC that uses this API, and I'd like to show the best
> possible outcome, and not the best possible given an arbitrary
> limitation that avoids an error where the user does something
> erroneous.

I would not call correctness an arbitrary limitation.

AFAIU page cache is shared, one application thinking that files it
opens can't be modified is no guarantee that the pages themselves 
will remain unchanged.

Isn't support for read-only page cache entries also a problem for 
RDMA when it comes to fs checksums? Sounds like a problem area that
needs real solutions.
