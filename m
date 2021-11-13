Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C06444F11E
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhKMELW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:11:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235602AbhKMELV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:11:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B6960231;
        Sat, 13 Nov 2021 04:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636776509;
        bh=skCVwuXYEwDzyLSK6IT3IZnJ8CseLdYsvFM0+aOYZ9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I2JCOogvdJYA7+iuAGW3YEPls91Mj1Fd6y9uuxHGogNnqUbZ4JAVzx22tS1Ai945H
         ZuMik+BYpmBAzu5C7RYFCS5FmMyw/XlMeYWwGzeE926GCg7O1R3QjsRuYyacgcPDqq
         JKbF4ZsMgHyGMHA4bT49Widnryq4+i2FK0cx9lEVQmrMCAtqIhw7rKaray8femPTvb
         edMxdOXS2zLtXdDKTMex/oUO1ZSVjdANZl+Nbef9iDCWf2JPu9e3T37w+hzir4Y+Gu
         r54aYJlxHrDV1ZOgoUdXH6xTz+EKTSEK/DEVt/+Q1T6Y7XlafV1SJus5hrvpdwUVFK
         eQhwGnwh4HSDQ==
Date:   Fri, 12 Nov 2021 20:08:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     jmaloy@redhat.com, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] tipc: check for null after calling kmemdup
Message-ID: <20211112200828.50049d76@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111205916.37899-1-tadeusz.struk@linaro.org>
References: <20211111205916.37899-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 12:59:15 -0800 Tadeusz Struk wrote:
> kmemdup can return a null pointer so need to check for it, otherwise
> the null key will be dereferenced later in tipc_crypto_key_xmit as
> can be seen in the trace [1].

> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
