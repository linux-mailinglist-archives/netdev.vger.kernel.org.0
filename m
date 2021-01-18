Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153C2FA7BD
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407248AbhARRmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407243AbhARRmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:42:24 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE367C061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:41:43 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id v19so4276916ooj.7
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6BjCsUjB+34z59FFJM6pqts8kRnU0zDorKLQzUCDKJs=;
        b=C9+ZuYyCmFbtUCO/9J1Un432+HswCa6HDrrydoctvIi+eIiRElzqjJ1O7fEj6ejnrX
         N/XPaiKwNRXuImOY5rF029D6tXwtfQS2YX9GoS6wjNaaaBci1DlkKqMLdn/haGwu/8cz
         G+YewtlfRrokfpz65TmvV6OxlbGAQiH9iQs5lhyMnRvXlH/+oh22G8NzuxhFVNA6uImF
         OdGeB/+V8HbPbh9KCbFKEPrl0eC2HHaP/fd+KE69gAR9ZKQdGqW0r0XNuGl+xs93WP4P
         qiUGR+BBiS5IaJt/DV1fLV56RYQyMco+E2h4WCXoyBRz4SDXbJOPTZMx9dVsSIA6dUy7
         SHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6BjCsUjB+34z59FFJM6pqts8kRnU0zDorKLQzUCDKJs=;
        b=AAvMESvAhOGFiEgwMasc4qHqF4jtPNb2a/S6gs+PM7Q4uygYyVwuUnLqiOjJ9HV9kF
         F4TNHm2Udh481q5gqHN26CgjLTMbj+XPlo/Xhhit2zj9Hx9gZa1P/9S8PnoMXnczdm52
         otU5iTGyYuUmmD3JNYDUl0k02wNrcFKJuMP2VFGv4Qa3aX2+uIzA606g/yfxA1foQjii
         Jdcra9Db04ihOS19en1osvaVph8wwkzL1v+E7gfJfgvJV9ZleEprbhzcjjMZnjyAlqES
         TCWZu4VAN9bnMAelEmsUipaW6bjoB/tXu+WrGEHwRfK9S2MzbGaxQWw7tOs/j4zSdZGp
         jujg==
X-Gm-Message-State: AOAM530zy/4srJptN7bvPbYTIit0plM2upzGJVDOAwkY+5YMQ8a67nIC
        D0kkJc9U3w6+MyirPbvdRJA=
X-Google-Smtp-Source: ABdhPJzZL8leDtUp59MWZ7zEWUVi9nzEuEsDpxq+BdCGlE0gjWp1eaDXTt4Lp7BlXECTtZf2so3ksg==
X-Received: by 2002:a05:6820:22c:: with SMTP id j12mr156483oob.65.1610991703310;
        Mon, 18 Jan 2021 09:41:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.248])
        by smtp.googlemail.com with ESMTPSA id k65sm2018123oia.19.2021.01.18.09.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:41:42 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] nexthop: Use a dedicated policy for
 nh_valid_get_del_req()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1610978306.git.petrm@nvidia.org>
 <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0abdd7bb-e618-e68c-7597-9de475cfb92e@gmail.com>
Date:   Mon, 18 Jan 2021 10:41:41 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 7:05 AM, Petr Machata wrote:
> This function uses the global nexthop policy only to then bounce all
> arguments except for NHA_ID. Instead, just create a new policy that
> only includes the one allowed attribute.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


