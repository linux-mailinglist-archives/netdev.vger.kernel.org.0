Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16CF258118
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 20:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729181AbgHaSaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 14:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:43348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgHaSaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 14:30:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCB72206E3;
        Mon, 31 Aug 2020 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598898612;
        bh=9EEp6ubZyaLmwG7Cl+QI+MI8URnoMNT6tLC6MAxlbCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qstsa3KRL4NDr5RrpIf7fWMOmtcfcaKsHmuGYsBBHZJQ/PLemYR4SuChA9kTkj1SW
         bjR7YGExc8tjWpwuDLxceHrSMdaieGoZEDyO4X1AXLKgb6T15KWyuZdndFezA8GDEV
         0rtPyhx+3gForltCDPmlpcJYN+5VrBi6p5MLQEuM=
Date:   Mon, 31 Aug 2020 11:30:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yutaro Hayakawa <yhayakawa3720@gmail.com>
Cc:     netdev@vger.kernel.org, michio.honda@ed.ac.uk
Subject: Re: [PATCH RFC v3 net-next] net/tls: Implement getsockopt SOL_TLS
 TLS_RX
Message-ID: <20200831113010.0107dc5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200830190713.69832-1-yutaro.hayakawa@linecorp.com>
References: <CABTgxWF5vtQu4H6-_54QdMcM2mJW3h8Co254+Qb4q88k0He1dA@mail.gmail.com>
        <20200830190713.69832-1-yutaro.hayakawa@linecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 04:07:13 +0900 Yutaro Hayakawa wrote:
> From: Yutaro Hayakawa <yhayakawa3720@gmail.com>
> 
> Implement the getsockopt SOL_TLS TLS_RX which is currently missing. The
> primary usecase is to use it in conjunction with TCP_REPAIR to
> checkpoint/restore the TLS record layer state.
> 
> TLS connection state usually exists on the user space library. So
> basically we can easily extract it from there, but when the TLS
> connections are delegated to the kTLS, it is not the case. We need to
> have a way to extract the TLS state from the kernel for both of TX and
> RX side.
> 
> The new TLS_RX getsockopt copies the crypto_info to user in the same
> way as TLS_TX does.
> 
> We have described use cases in our research work in Netdev 0x14
> Transport Workshop [1].
> 
> Also, there is an TLS implementation called tlse [2] which supports
> TLS connection migration. They have support of kTLS and their code
> shows that they are expecting the future support of this option.
> 
> [1] https://speakerdeck.com/yutarohayakawa/prism-proxies-without-the-pain
> [2] https://github.com/eduardsui/tlse
> 
> Signed-off-by: Yutaro Hayakawa <yhayakawa3720@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
