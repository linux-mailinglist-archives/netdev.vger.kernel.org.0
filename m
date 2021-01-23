Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C09B301216
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhAWBoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbhAWBoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:44:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DAE623A60;
        Sat, 23 Jan 2021 01:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611366206;
        bh=3jJdRfMfmME9F1MhCK+yHwe+eHsS2tV4j0XTgdSAaPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fRa+TM7LC90XDRWr6L5HX/kMkcmOZC9lyEzbE3j2oIlTrwQAp1VnB1si6lGZDQrYU
         w7OjouWffbizGpo4pUDuMIY3BYcwO+YaI8gLovO9xiu4ORMt2ZrQ1a81VAO+98ZOen
         Xt8OxWICQJALI/nJQAM/0C6A8HGLkab0XbbzKAcwxdjLU65lLJikbchmAVYAg5Lxq5
         SIvTauU/QPIr5/cz+IRwLThDC0CjGghNk2Iz1arnT6W8xhIeKVrSExdxtpHRpgfn1s
         fuStULOx/bg3OtAz8fsrRjPuUDUTpSQlLPWxaFfecKtRy1mAjP5G+BsVjw/Mo4CHab
         axiLkDSohihJw==
Date:   Fri, 22 Jan 2021 17:43:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH net] tcp: make TCP_USER_TIMEOUT accurate for zero window
 probes
Message-ID: <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122191306.GA99540@localhost.localdomain>
References: <20210122191306.GA99540@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 11:13:06 -0800 Enke Chen wrote:
> From: Enke Chen <enchen@paloaltonetworks.com>
> 
> The TCP_USER_TIMEOUT is checked by the 0-window probe timer. As the
> timer has backoff with a max interval of about two minutes, the
> actual timeout for TCP_USER_TIMEOUT can be off by up to two minutes.
> 
> In this patch the TCP_USER_TIMEOUT is made more accurate by taking it
> into account when computing the timer value for the 0-window probes.
> 
> This patch is similar to the one that made TCP_USER_TIMEOUT accurate for
> RTOs in commit b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout()
> helper to improve accuracy").
> 
> Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> Reviewed-by: Neal Cardwell <ncardwell@google.com>

This is targeting net, any guidance on Fixes / backporting?
