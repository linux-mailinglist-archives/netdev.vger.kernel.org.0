Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118CB1DC077
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgETUq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgETUq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 16:46:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743FE207D8;
        Wed, 20 May 2020 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590007617;
        bh=k1JXP+MZP0BjPtKIXZ2/bXXLR4RKfTUOHHvSwxNAxfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnXBSD9lI0TMycuS2VMMf5rF3zmy5gLeSSiGqKhLCOt8kIlES+mYAGmRCwkfXdMlQ
         Rw7BOO7FEfAlOfIvghBxINaCk/+Z79nBALzXwMpyZH6DXS808KTmdbzAc5AFj/fsUe
         5Dq53ATCAramQgDxJxizcGITymf3x7l0E+NIzJqo=
Date:   Wed, 20 May 2020 13:46:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [net v3 0/2] net/tls: fix encryption error path
Message-ID: <20200520134655.15fead0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
References: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 11:41:42 +0300 Vadim Fedorenko wrote:
> The problem with data stream corruption was found in KTLS
> transmit path with small socket send buffers and large 
> amount of data. bpf_exec_tx_verdict() frees open record
> on any type of error including EAGAIN, ENOMEM and ENOSPC
> while callers are able to recover this transient errors.
> Also wrong error code was returned to user space in that
> case. This patchset fixes the problems.

Thanks:

Acked-by: Jakub Kicinski <kuba@kernel.org>

Pooja, I think Vadim's fix to check the socket error will make changes
to handling of -EAGAIN unnecessary, right? Still would be good to get
that selftest, triggering EAGAIN should be quite simple.
