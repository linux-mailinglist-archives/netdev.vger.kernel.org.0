Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A92F4888
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhAMKVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbhAMKVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 05:21:44 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E3FC061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 02:21:03 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id g25so3343486wmh.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 02:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t7X9JmEYAV33UPHNNmYfL1urqVLdpyq17RETZySR0c0=;
        b=Md2JO0BXTNuGVS4hDjOg7+ukcwCJk93szFO2zvgRKtizNSQ1JNVtWZxYioOYZT5vp6
         pBXiLCJO8nMrGsMW6ekl6BcbHE4d8jZVdoJJS2wU8r2Z5m0vnkEoUHOreglXKUlxHzfb
         xUpSskRmibYpDTukcc5hNTS7bexVaab/CxuX2UO8brSSm/BHsm5/8FjFcxUQcYDMlyh1
         9oG63JGBMhE2WpnZLQMZV85binvGaCwnTJ7AJXOo7kmwqolYqADz8J1UKvYxVwz11K27
         0f8lhiaAgx6mhp24ZHAkAOLgvnh6HbvfGnVY2FQ/aB04kIStERofXRqexXyQHNFowdaD
         /6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t7X9JmEYAV33UPHNNmYfL1urqVLdpyq17RETZySR0c0=;
        b=EWT3iMgDrPHSdMmbpFa+TrNiMKX/8AyQqUmUbMqsqzGxPh6YdEdKUl92M9we0ianfu
         Xfgji3UecHTzS2HyB011gKUXOq0EsUT95OB2LI4HfUWMqI+iggkbwNwnbakK3PwR9iat
         gEqKnxkUYLrfVSyvG6Q3h6dL9E+8ZY2Cr4ExNm+hIO+JEociJMLbWCm0DAuLywV0nDuc
         nocrAF9UHH8dVg3/7lAMGGw99GEQ9jaZmvIDAuGB/sxsmZWBkvKto4DGVHX2qfvsqxdw
         NsM/sNZZkcycjDyDuWilB3+xzs/sdUpEMM7hbJOebQwNGqE5P4GIP4KXIJLwTcjgy+Pw
         K/QQ==
X-Gm-Message-State: AOAM533oDrwjoyMIaUWx/JXR+YTqJs9vQ+ifhmT5UGCnC9ppLMp6Jefn
        f2/aOaAYVGgRgRuQwl9uGoY=
X-Google-Smtp-Source: ABdhPJwQioTrm+oLpVDXAcOLjk1gAtAg1/VQnSOgNCEeyZwiWI+md75zKwbfzElY1931Og19cEhbbw==
X-Received: by 2002:a1c:e10b:: with SMTP id y11mr1522980wmg.65.1610533262594;
        Wed, 13 Jan 2021 02:21:02 -0800 (PST)
Received: from [192.168.1.101] ([37.165.157.144])
        by smtp.gmail.com with ESMTPSA id n10sm2383874wrx.21.2021.01.13.02.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 02:21:02 -0800 (PST)
Subject: Re: [PATCH net 2/2] mptcp: better msk-level shutdown.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1610471474.git.pabeni@redhat.com>
 <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a42a3c10-0183-a232-aec6-b1e6bbfaa800@gmail.com>
Date:   Wed, 13 Jan 2021 11:21:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <4cd18371d7caa6ee4a4e7ef988b50b45e362e177.1610471474.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/21 6:25 PM, Paolo Abeni wrote:
> Instead of re-implementing most of inet_shutdown, re-use
> such helper, and implement the MPTCP-specific bits at the
> 'proto' level.
> 
> The msk-level disconnect() can now be invoked, lets provide a
> suitable implementation.
> 
> As a side effect, this fixes bad state management for listener
> sockets. The latter could lead to division by 0 oops since
> commit ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling").
> 
> Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/mptcp/protocol.c | 62 ++++++++++++--------------------------------
>  1 file changed, 17 insertions(+), 45 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 2ff8c7caf74f..81faeff8f3bb 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2642,11 +2642,12 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
>  
>  static int mptcp_disconnect(struct sock *sk, int flags)
>  {
> -	/* Should never be called.
> -	 * inet_stream_connect() calls ->disconnect, but that
> -	 * refers to the subflow socket, not the mptcp one.
> -	 */
> -	WARN_ON_ONCE(1);
> +	struct mptcp_subflow_context *subflow;
> +	struct mptcp_sock *msk = mptcp_sk(sk);
> +
> +	__mptcp_flush_join_list(msk);
> +	mptcp_for_each_subflow(msk, subflow)
> +		tcp_disconnect(mptcp_subflow_tcp_sock(subflow), flags);

Ouch.

tcp_disconnect() is supposed to be called with socket lock being held.

Really, CONFIG_LOCKDEP=y should have warned you :/


