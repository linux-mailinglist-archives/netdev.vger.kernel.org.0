Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A83A30925F
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhA3F6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233846AbhA3F40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:56:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE4B064E0A;
        Sat, 30 Jan 2021 05:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611986145;
        bh=x+SuYWoZzNh7f4oov9DK40rsac6xOlbTRPzNgG5wJNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UYr2b1sD+SiDfLJto3/nNUQJIzlmGCm1ufVamlokIuU7T2bL1KgjimZEScaTbCVe/
         EoIrErvu8dqFwlxt/RUfZDxLyB5Atldof6+QvL0s/9xoi8A4z7yX8NoJ7T8OXlUbAr
         Nhtw4ACAIP4YqGa7SWdxi/YWv0PoFBaGBCHebzvBTpwGmKMsosilBuxwjATvvroy5U
         du/EMJwJo8UjUCQcRdX8pEbDrfwO1WTe6wBWhYzxHaeLfe2LBHL5cFn3bzSJRllRgp
         94qrl5pt7ngVb8ungqwugSIGqVTqcwDnFb7x9sHCKtAl/XbfsuItskBdBkQrW1PnnR
         LITuZ1XxczQMg==
Date:   Fri, 29 Jan 2021 21:55:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, Geliang Tang <geliangtang@gmail.com>,
        davem@davemloft.net, mptcp@lists.01.org
Subject: Re: [PATCH net-next 01/16] mptcp: use WRITE_ONCE/READ_ONCE for the
 pernet *_max
Message-ID: <20210129215544.2956c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129011115.133953-2-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
        <20210129011115.133953-2-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 17:11:00 -0800 Mat Martineau wrote:
>  	spin_lock_bh(&pernet->lock);
> -	rcv_addrs = pernet->add_addr_accept_max;
> +	rcv_addrs = READ_ONCE(pernet->add_addr_accept_max);

Oh, this reader is also under the lock, what's the concurrency issue
you speak of?
