Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3FF2AC0DD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgKIQ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbgKIQ26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:28:58 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4398FC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:28:58 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e18so9410957edy.6
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VcXUbl2f8utqzzFYS4gDk1OqUS8YDWffeiu9Odc0C+A=;
        b=dQghebCkUm/2O5HtpHQcC3Sq0S1OQ+BRaqC3PuEQsVdOFGAHwD4VkWfptetAQCjl/4
         YJETS+0vzIUSWEurflkbpeallB89hLwtr2GzexP1cv0S8YLuJ8jXOUi/AgTWls1unH53
         fj8KZS8ozbsQdhEUPV5+9EiWwH+NuAJ7I/TG2tL4x3pil2LOznG2xYbvKh5E3GJq+QtI
         OEyHOp08I9/1XkNnW3UM2vUoWkYpMMgQXSPpYFwlJ4p0fUY9PDSaIVN2WbaKZ5DR5Dqy
         sLyuAiQtU92/SH4a/d0t8IxYLIX5nIgpNlASaAgXLRI7+9HgTQTL1eFtMtOAPpUmXV/e
         M7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VcXUbl2f8utqzzFYS4gDk1OqUS8YDWffeiu9Odc0C+A=;
        b=ZIPpzjv7zW8fq28l0pfgxwjC1ZmUASmbmzzlZsgkud5rUQ6QGShIamTL1A3rDacRym
         O2hsGDPjXUlaPdt1xta45FdLtbmyNEk/QukmsNQIhtgNB9LZAQ+Ce5ENkDVL/VBejCIB
         ipHjCa+Iom8zOtnuxvBuJKi2MlBYOjS0mM3lxEilD1n1ZMsl2RXRfP4sy8lgo0+/2sDb
         zemU0rCMq/AM3EpxsR9/zz8XG1jLYZAR56bZYmnm6a1fN1nbZxqZINEpM4I4ztXuJwbo
         R2xlHQ1cZnc71MAw6Rbgsp8C8tLpRmb7ibtd+oPRgjG/xd+57VcjKpNAp+DcS6Y0353m
         p6gg==
X-Gm-Message-State: AOAM533BovF4JCiJQT9rFS0PAJ3rmC+k97nGGrArjdiH4pT/CU4Jq2qj
        qIZIjt2CTltoecFjdZCoxaqz+A==
X-Google-Smtp-Source: ABdhPJw9Ev8Usg+y6pJcQxDa4Fc6Eq+iqNDrk/4dsYlJhXWuzODI/Q5M+uLoEgvINzWOVj9kdpa0bQ==
X-Received: by 2002:a50:a689:: with SMTP id e9mr6198994edc.233.1604939336772;
        Mon, 09 Nov 2020 08:28:56 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:42d:4528:36bd:c4ae])
        by smtp.gmail.com with ESMTPSA id b12sm9204372edn.86.2020.11.09.08.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 08:28:56 -0800 (PST)
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
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in
 mptcp_pm_add_timer
Message-ID: <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net>
Date:   Mon, 9 Nov 2020 17:28:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang, Dan,

On 09/11/2020 14:59, Geliang Tang wrote:
> Fix the following Smatch complaint:

Thanks for the report and the patch!

>       net/mptcp/pm_netlink.c:213 mptcp_pm_add_timer()
>       warn: variable dereferenced before check 'msk' (see line 208)
> 
>   net/mptcp/pm_netlink.c
>      207          struct mptcp_sock *msk = entry->sock;
>      208          struct sock *sk = (struct sock *)msk;
>      209          struct net *net = sock_net(sk);
>                                             ^^
>   "msk" dereferenced here.
> 
>      210
>      211          pr_debug("msk=%p", msk);
>      212
>      213          if (!msk)
>                      ^^^^
>   Too late.
> 
>      214                  return;
>      215
> 
> Fixes: 93f323b9cccc ("mptcp: add a new sysctl add_addr_timeout")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

A small detail (I think): the Signed-off-by of the sender (Geliang) 
should be the last one in the list if I am not mistaken.
But I guess this is not blocking.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
