Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BF325FD14
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgIGP2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgIGPRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:17:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E75C061755
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 08:07:36 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id c10so13094914edk.6
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 08:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BsqSCPCPiaLJ8Go+KX+dmTuaOJyEKP9pJrk437CGKxg=;
        b=l3gYcQrwwdOR9fijZnyUEmRnV41Jn1GPXnCDbFgLE3/DycIWBY+5xj64K+P4kaRsS/
         jWcZgNfSWwU8vJc22qhfcZOz9MyrpKUMuSIf9Ab+agdioBrleVzplVKE38nLSY5cBUX1
         ucE+0iOfFSSJCPm8cPHdOGfAEHGc6PTo2aks7VEfJc3QFzqYJEKBjF6QHscBNiJWDZFL
         yro4UN8yf3Q34nB4re9cCV6hQxXMtz9ndNbsnZ3Ynh5pQZXM9ySv7MuphzR07H6p9bMn
         FtQUT68lqjxh7HJ0iD4WVyQAd/X2+uiq9CM4zPbJCnZXBEPp0n3sfqRnrw0ggdAGClnB
         VzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BsqSCPCPiaLJ8Go+KX+dmTuaOJyEKP9pJrk437CGKxg=;
        b=ExolTfNDmqmL4JNAWYDgHHh2TBNTMd0InqsSfgoJTyTY/3LbjXjgJJg4vYsIBqTUh/
         AxRFx966aObb79b2dLrdfFu5hUCwljRZzABquT8yaYbwYVOPpDUmX3Qdt/oLrAjK68TS
         uxR2l3hmIBNxmnvy5l6MeLxIQ49fArjgeWVvRlH3lnnqiHvJ6Ejgsrn8DFpnSgm3VJGL
         I/dplvDGBRHdJK/7gZNO9HdkXPYgrOvh2j1Yy5OwznW77npHmB1+pw0jtP2ZTAKhNOIo
         ygXDgwWoe7AsQQjeCRq661s0dZh1kHLy3HbzrNtV4Mhna2PICWAv0axgYXQCVpI7A9Nm
         YenQ==
X-Gm-Message-State: AOAM532HL3gHvu2Dbrvocm+3bFC+jhrZFItHCvYog7ITaM1Pil7vWsns
        JDgxjQPNkAxAAiTIpdSLzXRolg==
X-Google-Smtp-Source: ABdhPJz4KjCatnUJFTsRS8yPpcGqriKrL3EhPhWrN7yE7V6S7tBAHkHGZ5mzppwc0wjk5DI/rOsxiQ==
X-Received: by 2002:aa7:d15a:: with SMTP id r26mr22499081edo.181.1599491254960;
        Mon, 07 Sep 2020 08:07:34 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:8ddf:bedd:580e:7a7e])
        by smtp.gmail.com with ESMTPSA id o11sm15104926edw.80.2020.09.07.08.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 08:07:34 -0700 (PDT)
Subject: Re: [MPTCP][PATCH net 2/2] mptcp: fix subflow's remote_id issues
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
References: <f24ee917e4043d2befe2a0f96cd57aa74d2a4b26.1599474422.git.geliangtang@gmail.com>
 <7187516ee5a9f17a7bf1e4aa9a849da2dd56a734.1599474422.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <a62124ba-bb3e-bd19-e2b4-50e8cb1465ea@tessares.net>
Date:   Mon, 7 Sep 2020 17:07:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7187516ee5a9f17a7bf1e4aa9a849da2dd56a734.1599474422.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 07/09/2020 12:29, Geliang Tang wrote:
> This patch set the init remote_id to zero, otherwise it will be a random
> number.
> 
> Then it added the missing subflow's remote_id setting code both in
> __mptcp_subflow_connect and in subflow_ulp_clone.

Thank you for this other patch!

Here as well, may you add a "Fixes:" tag please?

(...)

> diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
> index dc2c57860d2d..255695221309 100644
> --- a/net/mptcp/pm_netlink.c
> +++ b/net/mptcp/pm_netlink.c
> @@ -186,7 +186,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
>   {
>   	struct sock *sk = (struct sock *)msk;
>   	struct mptcp_pm_addr_entry *local;
> -	struct mptcp_addr_info remote;
> +	struct mptcp_addr_info remote = { 0 };

To respect the "reversed Xmas tree" way to declare variables, may you 
move this line up to be the first one in the list please?

The rest looks good to me, thank you!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
