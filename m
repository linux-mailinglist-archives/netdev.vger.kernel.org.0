Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D59A340E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfH3Jch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:32:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34876 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfH3Jcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 05:32:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id g7so6283713wrx.2
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 02:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+47wD5vGZ+6kUib765nKfUpzmQhNcuWkVLIbcOTw29M=;
        b=bqFBGWBroRmmRKcvZzKsu+g8bCZm7qIJT5Tuw2T1n9ZxS6FjtvQtLoUIvPovOYoyMF
         zm0of0+kMSbdGYKpoP8/2qgZ5yEG4bInmhHM+nvWFjJCg1LyMgHt4XtTYza6t2320e/o
         IR6bb5komWIxHXq2y8KK082STfGWAb9IpExH6Esfy7a8QcU0j+40LpRwxUm3HR7v9Nbi
         joWLHAHF3xX3BbI1T3HETn9t6i98WSn/9Ays+EEHRSAsk2OlR3r787CkPiLXhAS/yMyZ
         bZ+Pt4LZrUXw+0VBw/OVF3XulmeJ8nlH5P4PeG5Q+FSdGkGJ49MeV7fVJ2ppQxRjwRQq
         jPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+47wD5vGZ+6kUib765nKfUpzmQhNcuWkVLIbcOTw29M=;
        b=D1FpFssXszUbbbTn7XNTBxCPwrWy9bLThss+2geIlPogdMZAkJO+8PN0a5fJ4Yh3KW
         6gX+6eUVLwVvrHiAwKF9E6H6HNIHEBDuzHOK7N9Xk3+oJsr8J16KWkm8ryckoXlUybwq
         pe/ac7TI/qWnqmWX/YhEc3pBuAUvBKxBbYAEt37T/h3vpH/SxXJbIKGh7JmpEsAAjGv2
         DB3Cc27dsnG4HunQrUhShrDiTalFWeKfCjbjFyihsnpqPg1znVC3qblHNwa2TFPrZ59W
         WxMSGx60Qw0jaU1U4jcriZVuH4S1X5IQuR3BiUwUNtOiJIOMhmc1dmNR6L2T5DQRGNrz
         8NOw==
X-Gm-Message-State: APjAAAXto62E+TZqtKO25ElL0lQbtHkPusfBCDoMZGCjTo2SOxJZUHKx
        2Iw38hrNb5b3PgFsAH7djhI=
X-Google-Smtp-Source: APXvYqwaZPU8RDZo27OAx9VActHGrUB7ZmFn5Ouo/BXN0qrtdp8kGW2B40Z+R2RY/zsGsgCaWMn8fQ==
X-Received: by 2002:a5d:51c6:: with SMTP id n6mr1036003wrv.206.1567157554852;
        Fri, 30 Aug 2019 02:32:34 -0700 (PDT)
Received: from [192.168.8.147] (31.169.185.81.rev.sfr.net. [81.185.169.31])
        by smtp.gmail.com with ESMTPSA id a142sm6903516wme.2.2019.08.30.02.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 02:32:34 -0700 (PDT)
Subject: Re: [PATCH 1/1] forcedeth: use per cpu to collect xmit/recv
 statistics
To:     Zhu Yanjun <yanjun.zhu@oracle.com>, netdev@vger.kernel.org,
        davem@davemloft.net, nan.1986san@gmail.com
References: <1567154111-23315-1-git-send-email-yanjun.zhu@oracle.com>
 <1567154111-23315-2-git-send-email-yanjun.zhu@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <24ad8394-cb24-fcb7-0dc2-3435429bb8cd@gmail.com>
Date:   Fri, 30 Aug 2019 11:32:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567154111-23315-2-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/19 10:35 AM, Zhu Yanjun wrote:
> When testing with a background iperf pushing 1Gbit/sec traffic and running
> both ifconfig and netstat to collect statistics, some deadlocks occurred.
> 

This is quite a heavy patch trying to fix a bug...

I suspect the root cause has nothing to do with stat
collection since on 64bit arches there is no additional synchronization.

(u64_stats_update_begin(), u64_stats_update_end() are nops)

> +static inline void nv_get_stats(int cpu, struct fe_priv *np,
> +				struct rtnl_link_stats64 *storage)
> +{
> +	struct nv_txrx_stats *src = per_cpu_ptr(np->txrx_stats, cpu);
> +	unsigned int syncp_start;
> +
> +	do {
> +		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_rx_syncp);
> +		storage->rx_packets       += src->stat_rx_packets;
> +		storage->rx_bytes         += src->stat_rx_bytes;
> +		storage->rx_dropped       += src->stat_rx_dropped;
> +		storage->rx_missed_errors += src->stat_rx_missed_errors;
> +	} while (u64_stats_fetch_retry_irq(&np->swstats_rx_syncp, syncp_start));
> +
> +	do {
> +		syncp_start = u64_stats_fetch_begin_irq(&np->swstats_tx_syncp);
> +		storage->tx_packets += src->stat_tx_packets;
> +		storage->tx_bytes   += src->stat_tx_bytes;
> +		storage->tx_dropped += src->stat_tx_dropped;
> +	} while (u64_stats_fetch_retry_irq(&np->swstats_tx_syncp, syncp_start));
> +}
> +
>

This is buggy :
If the loops are ever restarted, the storage->fields will have
been modified multiple times.

