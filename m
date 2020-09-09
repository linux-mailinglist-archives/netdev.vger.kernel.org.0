Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406B1263421
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgIIROn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgIIPaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:30:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61482C0612F5
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 07:39:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s12so3221998wrw.11
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 07:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bkORLZG3u3dzhotZjzrL2NcwPRVYSyfBeouqNvnhcek=;
        b=fyF++iAhOrN2HEuFApmRjksJO4k6V6b/TEDM7ifrpowYJyMF583aiPiVeZeaLz4n01
         aXIplHyi5iH2rHBH8P3SJ0nfUp/MqUruFrLdz3Qvqp6fN/c3fp6nOD1QNSZRhCD4CTbw
         3E8dIp+bQUOiHnO8ua9OK42LV54gFGtqzb+47n9xeBlU67pBcM+6xd0Q80bKRBqp7hvF
         t363NYLHUXSlHpHQngLMGMpGXKBlqFjiRJVNCGODxKJJ03sinIREuTAjEFxKDfbpJH2c
         Tudwpd6NYqeES0APQoE9eGbWqzIZYYTlXirPT+Lb13tgcARg2eGNQJbNYZ/k+2+FyMS7
         TssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bkORLZG3u3dzhotZjzrL2NcwPRVYSyfBeouqNvnhcek=;
        b=foXOcsmru/sRSIQ5Hr0Lhi0Wm+dFX7a85DzD1n9UfJU6hZgdf0EOosnTAbjVF+dwX4
         c/uhCtXwT54To5ni8mbIE+5bzgNoQ6YyeVxK1FBgyVKNRMFuuqHeEfom39VUOIVNzfre
         CExE47NaQKT4LJV4oSWBLPjwyDQ4RIBy/0XgkaGciVUqSHnmz/t6Wn1qATv+lmJXkMIh
         SQNaeQgc3TUo+yOGfMVH0yChCVmGXj6ZHqHlc05W60SyISVlVyF2yedVeYTs7G1aCo6B
         sd2gWxW3rUczUHZy5IZuFHhlYNRbOiaERfq5yDYPdTD/xezZbBNWfTxcpJ9cLz87/pOh
         odpg==
X-Gm-Message-State: AOAM53244Ef5dI6M61bmGADmysT3Ll23zdBPD9Z8YMAUxQgbKEGIG80C
        4/ZatKR3BqXXAhWYboEMCr7BSA==
X-Google-Smtp-Source: ABdhPJxsySl+jiMG3NFQaWU08dYy2xTnHvxYnOWZzgh2yN0TVSMchxfChJNOhS8s5Nqo0JfFQH5Fww==
X-Received: by 2002:adf:f846:: with SMTP id d6mr4712246wrq.56.1599662393458;
        Wed, 09 Sep 2020 07:39:53 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:8ddf:bedd:580e:7a7e])
        by smtp.gmail.com with ESMTPSA id a10sm4144731wmj.38.2020.09.09.07.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 07:39:52 -0700 (PDT)
Subject: Re: [MPTCP][PATCH v2 net 1/2] mptcp: fix subflow's local_id issues
To:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
References: <cover.1599532593.git.geliangtang@gmail.com>
 <110eaa273bf313fb1a2a668a446956d27aba05a8.1599532593.git.geliangtang@gmail.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <c1537a78-c2b6-383b-f2fb-817c35bbfdaa@tessares.net>
Date:   Wed, 9 Sep 2020 16:39:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <110eaa273bf313fb1a2a668a446956d27aba05a8.1599532593.git.geliangtang@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geliang,

On 08/09/2020 04:49, Geliang Tang wrote:
> In mptcp_pm_nl_get_local_id, skc_local is the same as msk_local, so it
> always return 0. Thus every subflow's local_id is 0. It's incorrect.
> 
> This patch fixed this issue.
> 
> Also, we need to ignore the zero address here, like 0.0.0.0 in IPv4. When
> we use the zero address as a local address, it means that we can use any
> one of the local addresses. The zero address is not a new address, we don't
> need to add it to PM, so this patch added a new function address_zero to
> check whether an address is the zero address, if it is, we ignore this
> address.
> 
> Fixes: 01cacb00b35cb ("mptcp: add netlink-based PM")
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Thank you for the v2!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
