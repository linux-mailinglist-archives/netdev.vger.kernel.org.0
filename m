Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECEB120FE6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 17:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfLPQov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 11:44:51 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41486 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfLPQov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 11:44:51 -0500
Received: by mail-qk1-f194.google.com with SMTP id u5so5014277qkf.8
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 08:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i4LE41vD04VyJUrDe/wg27Hmmh8eR5NCXNXC2uGBs8s=;
        b=rlhAIi0J+KRYPt5OoZ3QsGvIIYQezegpvd9rX0uZefpTpiS5AMXa3qYE196T3KNrCK
         iy3nwv11/LYnmINxJCqgTFn2TtYptHP1FVUL1Jzs3vtu9Qq232R1JJTKbmQ50Y0NTwqN
         n3XzdEC5EJDt4BEBuuL9h35kSG6aNSomXDjhHjJ4AldMGRe1wwFBolue0rsHl9O7Bb2L
         ZiedtiYK6RUuwcIVVteCkKh+kogRiR7hAMf8myupsKNUEaZZxmULhnj0pu1QWYsWya/T
         SmVb6J1YlYrYOPB9Hyqib5oecrKUlDsEL4yO0inzMCvaauSvs7QnckwY3uL32oPZNBy3
         EDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i4LE41vD04VyJUrDe/wg27Hmmh8eR5NCXNXC2uGBs8s=;
        b=PbRaiV7k4HnmJlL8D14qTbd27+L9FkHTlFMOnBReXOcekloThziixV+GL8VgcdnJAF
         ZA/RFL9afsJQg2p1vhXiNgbZ2uFdxCS5yXt1v4EooHe9fYNbRzaplHAwG3lRin4uIDeu
         YwqHOmITZqpC4oOZFAgMG61/eK6mnJDbRzI4o75OKIXYofHzK/5sURy0Nx42r2jo52Kx
         7DuKhmYxjj33r5qIpjw/kNhczwlWOxUWKnjyd1+2sS1QaAF0ZNQEIJYvbqFxOMLN4Evv
         wf7Rtr3QMuLH/jFvcu9MYxSSorwdO9HmXNKxA7JLnxu+Hx0bYGNAeCjG8xCo8THmsC9R
         bOnA==
X-Gm-Message-State: APjAAAXi3aZ//GtNBDQvgvMuXbtEgtynUjNP6s/pwcVzPe8jYoNDtD6U
        B8yfkXCXROGMj78kNLXqYaU=
X-Google-Smtp-Source: APXvYqxk4QSOrRvVDt/CMTQKx01E/ow6E0C3P9AHUkRt2+6P8pRmVtER6HdNz7Kh9lBcZ7VVMx3IRg==
X-Received: by 2002:a05:620a:134d:: with SMTP id c13mr147242qkl.322.1576514690427;
        Mon, 16 Dec 2019 08:44:50 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:c48d:b570:ebb:18d9? ([2601:284:8202:10b0:c48d:b570:ebb:18d9])
        by smtp.googlemail.com with ESMTPSA id e130sm6127004qkb.72.2019.12.16.08.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:44:49 -0800 (PST)
Subject: Re: [PATCH net-next v2 10/10] ipv4: Remove old route notifications
 and convert listeners
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191214155315.613186-1-idosch@idosch.org>
 <20191214155315.613186-11-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e6d5c5e7-deeb-69a2-08d3-b1c75b8b92fe@gmail.com>
Date:   Mon, 16 Dec 2019 09:44:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191214155315.613186-11-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/19 8:53 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Unlike mlxsw, the other listeners to the FIB notification chain do not
> require any special modifications as they never considered multiple
> identical routes.
> 
> This patch removes the old route notifications and converts all the
> listeners to use the new replace / delete notifications.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  4 --
>  .../ethernet/mellanox/mlxsw/spectrum_router.c | 11 +++---
>  drivers/net/ethernet/rocker/rocker_main.c     |  4 +-
>  drivers/net/netdevsim/fib.c                   |  4 +-
>  include/net/fib_notifier.h                    |  2 -
>  net/ipv4/fib_trie.c                           | 38 ++++---------------
>  6 files changed, 16 insertions(+), 47 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


