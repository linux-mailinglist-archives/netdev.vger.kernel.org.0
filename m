Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DED7F09D5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfKEWtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:49:06 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39658 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbfKEWtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:49:06 -0500
Received: by mail-lf1-f65.google.com with SMTP id 195so16395732lfj.6
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GReb7FHIceNkeymhpo9/nm8KvBrDNRNbBjj45HNBuXI=;
        b=xOgG4GUpYha0ICb6/vOcZ3m3P/7GbbiId5y2ijLdkCwxXZPuF9eEhsMAowVjl7nLA0
         3pe5Kvv91tJyTabvUb5UvdBBHyDvNBCfKQ0XfXyYCp/WAPXNtNJ0a4/g691PAqEbrB8d
         anhp+tgRO1pAsGuEnv1Kpt5Qj1cCPHpBeAtGybZRv/aiPqR0EATZFqPF55joSC58CA+B
         9Y232yhs5bdOk1rHlvu7O7NItTeI/Sr5W3VWMjMgmh8uQhx2bIJR7/hqnVwm7s4Q22C6
         9CKD5OL4yTfxYO+7mNJy26VETQc7G8xdvLdQvkXQEDY1f6F/z3IKuEFNkPkzAZlXBZgF
         aRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GReb7FHIceNkeymhpo9/nm8KvBrDNRNbBjj45HNBuXI=;
        b=KCGDxoO2D8HbaGqEh8byk7ycpckv1jYeXyznUMOnycvad2IiZevs1CERWJ0mngMEIP
         m8QGnqbaX45ZQjzwYmQZ2GKS2dV6pyo44+K4THSrg0Fbh6igw0ULwkzVBFhWLHN1iYFG
         B3Lw0T7EfR8LiL1KIlcEJ0vLAGueb+j5GGO4XquUwMRQUSKNvHml5tcqrKVntjymAHwI
         yzay9DYtxbOffOALIZT7IPqo4S1Hu+J7stA8akNPu8WaQO0qf9aaeCpEbuIZB0Ar2TMs
         tuinL3CzhuRcdtO2CDh6gdEYEUkQk7dZytIQme2Ytm7t6/mxoXg6EqJrM7gt+cVZRirr
         IfmQ==
X-Gm-Message-State: APjAAAX/HK3ANV1rQSHX+4HRnoRTZ/SSz4GGBin3wfqt/7OtPO43N0GA
        Moxcgj09pkXZAKZOBiF9Q1Rp+Q==
X-Google-Smtp-Source: APXvYqzpCHJnvmbJ2Z0U0dMW7uWqlEds/Ap7TbKwH+WnBcuNkRJj+U3keQ8ID6rIeDE8o1dbSwHnqg==
X-Received: by 2002:ac2:57cb:: with SMTP id k11mr21839748lfo.87.1572994144361;
        Tue, 05 Nov 2019 14:49:04 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm1991399lfj.91.2019.11.05.14.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 14:49:04 -0800 (PST)
Date:   Tue, 5 Nov 2019 14:48:57 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 2/3] net_sched: extend packet counter to 64bit
Message-ID: <20191105144857.3c8d531a@cakuba.netronome.com>
In-Reply-To: <20191105031315.90137-3-edumazet@google.com>
References: <20191105031315.90137-1-edumazet@google.com>
        <20191105031315.90137-3-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Nov 2019 19:13:14 -0800, Eric Dumazet wrote:
> diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
> index 5f3889e7ec1bb8b5148e9c552dd222b7f1c077d8..1424e02cef90c0139a175933577f1b8537bce51a 100644
> --- a/include/net/gen_stats.h
> +++ b/include/net/gen_stats.h
> @@ -10,8 +10,8 @@
>  /* Note: this used to be in include/uapi/linux/gen_stats.h */
>  struct gnet_stats_basic_packed {
>  	__u64	bytes;
> -	__u32	packets;
> -} __attribute__ ((packed));
> +	__u64	packets;
> +};

nit: if there needs to be a respin for other reason perhaps worth
s/__u/u/ as this is no longer a uAPI structure?
