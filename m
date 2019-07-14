Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A963967F2C
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 16:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfGNN6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 09:58:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38985 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfGNN6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 09:58:22 -0400
Received: by mail-io1-f66.google.com with SMTP id f4so30086884ioh.6
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 06:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0tKYXVKflFc3HgvicC1OKcH5tAavOyVQP1Tr7XdSqZs=;
        b=Jlsl/NcXP7KxXjGUFqs+4b0BHZam63WG5DAQ2xr5SSIYQlyC4Q92LdnatAtE3aI+dt
         yvGaim6CmXCymm9rb38O+5eddvHFwRkJRDeVJy9G5s1VZlrN1ZK1sffC+WYqovdGqczY
         FANmih4dVAqsAtQFA5ac2aaYgY3tQAEEFAiZcx3bo/kWuK9Da+XOMjJu7CxnaYCxZq0K
         MU5Rucr4pCo8P3QAC+BKKToDzrsRrOoAbG4dbGHAH61kfpCvZ5HsoqUPfu5iTntGhrKR
         /Ifk/jF3rgiyDqJ0dB3zP2FET/7vlJMP6CCmcoeJA8WdzL+7teNrEjxBjDwISJfCVMEq
         gZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0tKYXVKflFc3HgvicC1OKcH5tAavOyVQP1Tr7XdSqZs=;
        b=WSR5oYbvGTp7DfRBOZl4hyiJZuvNAWv1lgQY0bnDD2kxEqA2yLg3QvVYU/aFjv2cra
         a9VSnSJ0Q1zQ0rlGsQJdlo/KqGS0Czt4gRDQOk3AIOinPVzK/tOSqIwDPMJ5fV0J1xfP
         G+KyzvBzNdsupkJV5Ey7X9WtGM69H9L4chJ2amrsWgD3efJ4PDP22noYqwH15/KTEWrO
         H6OzdXYH26s0LXXiwmwENnQBzLdI45etPvrha4QdSNcixygPvMVnLOdvrDV5xgicm/BP
         C1hFs0Pu/fTuodFFpCq94CbvZjyslGXyqRenjkOMJN6+8Hitt2zp+gK38nuHpjrhq5/Q
         OpCg==
X-Gm-Message-State: APjAAAX9s5PWh1wqZAMMECkDCSXir6QC2/AZAhxPeuP0qHgHiUu56SEU
        maTK30KYItunae+XMCxStv0=
X-Google-Smtp-Source: APXvYqzfu4SZZ2/Qc8IlX4Mk1cG1gut6FS9t90gTWtNthMy9Mrkdz0ldSyNj85DOso/xj/LdFGpDjQ==
X-Received: by 2002:a5e:c00e:: with SMTP id u14mr21379395iol.196.1563112701652;
        Sun, 14 Jul 2019 06:58:21 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:a5e2:b690:52f6:614b? ([2601:282:800:fd80:a5e2:b690:52f6:614b])
        by smtp.googlemail.com with ESMTPSA id y18sm16229210iob.64.2019.07.14.06.58.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jul 2019 06:58:20 -0700 (PDT)
Subject: Re: [PATCH net v2] net: neigh: fix multiple neigh timer scheduling
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, marek@cloudflare.com
References: <793a1166667e00a3553577e1505bebd435e22c88.1563041150.git.lorenzo.bianconi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26f58e35-f1f8-9543-819f-ef7f52da1e49@gmail.com>
Date:   Sun, 14 Jul 2019 07:58:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <793a1166667e00a3553577e1505bebd435e22c88.1563041150.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/19 2:45 AM, Lorenzo Bianconi wrote:
> @@ -1124,7 +1125,9 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  
>  			atomic_set(&neigh->probes,
>  				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
> -			neigh->nud_state     = NUD_INCOMPLETE;
> +			if (check_timer)
> +				neigh_del_timer(neigh);

Why not just always call neigh_del_timer and avoid the check_timer flag?
Let the NUD_IN_TIMER flag handle whether anything needs to be done.

> +			neigh->nud_state = NUD_INCOMPLETE;
>  			neigh->updated = now;
>  			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
>  					 HZ/2);
> @@ -1140,6 +1143,8 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  		}
>  	} else if (neigh->nud_state & NUD_STALE) {
>  		neigh_dbg(2, "neigh %p is delayed\n", neigh);
> +		if (check_timer)
> +			neigh_del_timer(neigh);
>  		neigh->nud_state = NUD_DELAY;
>  		neigh->updated = jiffies;
>  		neigh_add_timer(neigh, jiffies +

