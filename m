Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D079B4563A5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhKRTtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbhKRTtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 14:49:22 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8021C061574;
        Thu, 18 Nov 2021 11:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=A0kpxeX3ux8Zs3KSSdktR+Xma0rIOEQOzFaFM8BnP6Q=;
        t=1637264782; x=1638474382; b=WLtDSZd4KMnCQM2rCOr7Bgh66/jcy0qZRYucCmmolj7yEBK
        1uupnbQQswUWGaEkfjDqswzcCvgrQd3S40nZ5ClLJMTfXob0wvC7D8dvxmXb/3A0Sx/nIpg3QGb+b
        stWWufkR7LN51UJaBLLV88gPWA8+KAGE8yk3W/gDVmUvyX9SxRAhZ0YUvar+9sYLBKGRwZH7o++ZB
        5T0YMPuG7iagZsxAYRjBUMb0jiQkaBYEoFhq0aydEttjT4bGwWfEDUVBJEfnejQbBB/Soff5XHkdY
        Prltm/UqXDcX1cTwfqcNHSY+xANSL7KmOcRug3vFKIdB9OqijYqU4dpOPEfMsQww==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mnnML-00H8SF-9L;
        Thu, 18 Nov 2021 20:46:13 +0100
Message-ID: <c5d8c214b5df75b5b77450d71c7aec9f3bd97a67.camel@sipsolutions.net>
Subject: Re: [PATCH] intersil: Use struct_group() for memcpy() region
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>, Jouni Malinen <j@w1.fi>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Thu, 18 Nov 2021 20:46:11 +0100
In-Reply-To: <20211118184158.1284180-1-keescook@chromium.org>
References: <20211118184158.1284180-1-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-18 at 10:41 -0800, Kees Cook wrote:
> 
>  	/* 802.11 */
> -	__le16 frame_control; /* parts not used */
> -	__le16 duration_id;
> -	u8 addr1[ETH_ALEN];
> -	u8 addr2[ETH_ALEN]; /* filled by firmware */
> -	u8 addr3[ETH_ALEN];
> -	__le16 seq_ctrl; /* filled by firmware */
> +	struct_group(frame,

Arguably, that should be 'header' rather than 'frame' :)

johannes


