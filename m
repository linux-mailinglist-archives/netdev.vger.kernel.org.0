Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1F12AC0FF
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbgKIQfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730602AbgKIQfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:35:06 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508C8C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:35:05 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o9so13194565ejg.1
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iJKPrJRnBan+OH1HSQyOpP2QiklKNnN8Jd0BWjeUTO4=;
        b=RUtbwDCPnkgQ7ZuaCR+msxEkYMVxgCa/j4fLJYpk2YNcEFga84B56nvc3QAaZLQ3cG
         bPziS89SGBuWHk6KRXrKQVrRxhSJmoXX/1alxqNBoXRMKzw5lVJTYT5Apco/Fbt2Iuhf
         /rWolaDPKPZaJU07kBb/BxuIgxXsrASNt9/RWYnP3L7o3FdZ4C6mJMDVxzPP4lmciBhK
         5ytxJMg7P/uWe60tDWp9u0refDdGLmNVjUywAuR/ZZPtiKlCY2JTFj00pueiR0dwQ6RR
         5aRnlKoKdA7tL1ufVCIwiJIcRwyn5D90HJ2u7GJRPL25uzay4qyzZBYG2O2Hn9K724DP
         OVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iJKPrJRnBan+OH1HSQyOpP2QiklKNnN8Jd0BWjeUTO4=;
        b=iuKIC6RdcYjbVGdMnSlqM9ounQMcqVdRDX+2AMSmMMbcTCsiV1MPdFGY2+df7B360F
         14o6fEUVErSdskkGwRwu6sL12UDGdiSe9ae5b4rZ1ECFD2g/x1GFIz99ZL+96dcakHbB
         TVLkPlYM2cjTcR566a8bnyDB+KGT2dDWLLHMFGc3Cx0w6FISx3rIrgR6YB+McjLRhjW0
         zBD9uGcm6Tl7RNBRzt11ztLXVid/qwDscjYcJ0bOV+WR7iRi7QFwBHe9Rux4Fg/H+CeC
         8xkjirdC61PjdCrAomiinMAKzuEPcTXpOiLY4hOGs857Rdavzv+31URoI0tPZEDxSDJj
         mDcg==
X-Gm-Message-State: AOAM531o5ob0oSRBWHffy6JDo6t19Znlq3kP9AWXX7YFIgbQ/QFVonKi
        S8Bg6BUj0bLpkEcoDbPmCt3CTA==
X-Google-Smtp-Source: ABdhPJxbjA58+Z2QyY2zPDdDkFExrvvjGDJhy+U36RQCjrwZywkEc1Pq7Ex4J9yNTXevyg3jih2VsA==
X-Received: by 2002:a17:906:f186:: with SMTP id gs6mr16402433ejb.171.1604939703886;
        Mon, 09 Nov 2020 08:35:03 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:42d:4528:36bd:c4ae])
        by smtp.gmail.com with ESMTPSA id x1sm5374735edl.82.2020.11.09.08.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 08:35:03 -0800 (PST)
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <cover.1604930005.git.geliangtang@gmail.com>
 <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
 <0f17d2f60c188554d093e820c45caf20fe53aab0.1604930005.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [MPTCP][PATCH net 2/2] mptcp: cleanup for
 mptcp_pm_alloc_anno_list
Message-ID: <8b1c6862-ad2f-f639-42e3-b793aefbfd78@tessares.net>
Date:   Mon, 9 Nov 2020 17:35:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <0f17d2f60c188554d093e820c45caf20fe53aab0.1604930005.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 09/11/2020 14:59, Geliang Tang wrote:
> This patch added NULL pointer check for mptcp_pm_alloc_anno_list, and
> avoided similar static checker warnings in mptcp_pm_add_timer.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

I think Dan reviewed the v1 of your patch -- without some modifications 
below -- but not the v2 nor this one.

> ---
>   net/mptcp/pm_netlink.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index 03f2c28f11f5..dfc1bed4a55f 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -266,7 +266,9 @@ static bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
>   {
>   	struct mptcp_pm_add_entry *add_entry = NULL;
>   	struct sock *sk = (struct sock *)msk;
> -	struct net *net = sock_net(sk);
> +
> +	if (!msk)
> +		return false;

As Dan mentioned on MPTCP ML, this check is not required: "msk" cannot 
be NULL here.

We can maybe keep the cleanup (only move sock_net() below) but I don't 
think we need or want this in -net.
I am not even sure we want it in net-next but why not :)
This could also be part of other refactors.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
