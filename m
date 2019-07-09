Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C91631D9
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfGIHXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:23:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35827 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfGIHXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 03:23:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so2022178wmg.0
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 00:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KT7pSYO0fxx85uRlVxlLoRVEUQexLD++JXI+mDi6rqE=;
        b=z5cHeENiMibiPKcRKlWEfL8mygA4s5oiIr9gLubnbWs9zlwR+TKhXAsbZBDc3VYQ61
         xfWLr47ZRUAGTN0I365N+WB1ok4XkNYUEaxu/PzryAXnP3ko1Ora0sU0oE9x8z4fVE65
         kf0WJ4cgc3quoxj3Oq2okfkI6QyOqDLkmF7OwGLRoenfmf5tr5iQmseduTjAqTJHxcUb
         TrF0coOGwEFqpAn4M7N74Mg5kFxwhuZtU5idSXgYI+vZ3ja8fLje+W5PLPdAriTrZ6fI
         9aVpTSdvBcfvB4SvFnwau/z5JzqyPqXGrqEje+C1tR5qvR8V9TgxfTbvf6mmXFQk8bJ2
         M/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KT7pSYO0fxx85uRlVxlLoRVEUQexLD++JXI+mDi6rqE=;
        b=Ny9mc5NWez45WdepH/N1sNncPQ0h0wpED3Us5Tnt6rwYZrzrxIX+gE2PUnQxdiuK7C
         X5EAkshy9WLvPCLJdF7RhiP1aYV/qeqGv2PX915m664Pr3vUD2p8OUsUGqmIkLuUYT26
         8ygJpA46gxFu/2dffdu/3MReVOYT/irikQobHuAur4PDLVZFpcAzzQchXAwp8LDT4w73
         Yh/86J5vBLiOa+WeuQZ22YLMFlZTIJX8l/FmvUWlMrY+o0xlCZfcwKKk1sIvt3cP6hqn
         oiEosVtWPwSH0rQVgkGFfkRu2qhPuG30d3lTfcOtlHDhiGxPFaFzTXZDinknWNvtikej
         UenA==
X-Gm-Message-State: APjAAAXBgTZJyJnnRC8WhdyBL9flaSfW0/VlS0wtKQIDsfcuuqt8NtbU
        Ig3BzXlxaiUcyBCHcHMt2f0IOQ==
X-Google-Smtp-Source: APXvYqxKVE6kGxQAOdTVjRjcWXCBZKOx/fjMcd3FA/tdKtBzuSxgQNDe6HUfBUDwk9qOwaIsUM7EMg==
X-Received: by 2002:a05:600c:303:: with SMTP id q3mr21134045wmd.130.1562657015490;
        Tue, 09 Jul 2019 00:23:35 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id j26sm19863204wrb.88.2019.07.09.00.23.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 00:23:35 -0700 (PDT)
Date:   Tue, 9 Jul 2019 09:23:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 12/16] net/mlx5e: Split open/close ICOSQ into
 stages
Message-ID: <20190709072334.GA2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-13-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-13-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:04PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Align ICOSQ open/close behaviour with RQ and SQ. Split open flow into
>open and activate where open handles creation and activate enables the
>queue. Do a symmetric thing in close flow: split into close and
>deactivate.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
