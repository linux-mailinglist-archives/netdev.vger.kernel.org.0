Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFF77AA53
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfG3N6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:58:06 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33151 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfG3N6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:58:06 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so9388309iog.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 06:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8nB6UOzgonvSgIT4y+9poBDn/jzEnMha8n1NPzW/YvQ=;
        b=fENZINM7Mxpu4pmIjemj1Ft671AiOSHGKCfYHIezbR7BRrcad7Kt63UyhqN4bHOD/0
         SGtxFM+ZGjcOq6pqFc5CSnnrQ22j1NUyviL7ZCnIeKqAYNlFx9tq5K5eLzYwvKepVzdJ
         dlolAynjEXybnLijnok1Nh0b7P2cl9nnTUfLwL4zjezR99zkDtPbtyV0bzYCdXshj3QY
         TH6BHAvy5283v2TTfrmMKc7bwbObtMq3vWdgU1OGKIWFzI12RrMueopRo42llVlF3gN1
         VaMKjSD7etp/RcVLPV9RB35IAAhLT1FJofVLG5l1T8FQy11QI7aT/ACvSfXfTlVNNPQC
         Mlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nB6UOzgonvSgIT4y+9poBDn/jzEnMha8n1NPzW/YvQ=;
        b=HJHnTO4KtqXLsM3FNdKHSi47DwaMW5Q7yRifW9WB26XCN95AkRcwANd/2DI2Mkeq1v
         a1Z0v80Ue4Fpml0ROhVDjd8CNshE9zdKv9BHmhz6PRZwuibGyTRIHy5e48qcjVsZV0ik
         vLscak/NKL7y8mSzJ1WVaVkj39/vZ8m5heX101lMfCsOeGQFHcWs6nb0g53YyzHmAk5e
         5yeudCfzuTrNX9M2HzFDAU2W7NNcAx/4QH2OArW+8osePd498IPmW6p1gCClWMWiHvjk
         5vehrbJuBYbW2e0a0pu78ViNIijdL+4T7ABLkuQiwP5Grrzx17+r4+L20+mBGqOjFq6B
         dN3g==
X-Gm-Message-State: APjAAAVz14otk0wg/iY6TTnBJdKlZwk97fnVjJfb+TMPh8iEw2YFp7Ww
        06tn4eP5og4yP6woQSH/SqE=
X-Google-Smtp-Source: APXvYqzZjcl3uwUJZR4nFPY3D8p6RvxZgBcbascWcjQ17GiagCq3hL/xjj3rRouFr2ZuUb3/MT4P4w==
X-Received: by 2002:a02:ce35:: with SMTP id v21mr29517008jar.108.1564495085399;
        Tue, 30 Jul 2019 06:58:05 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:48fd:47f6:b7d0:19dc? ([2601:282:800:fd80:48fd:47f6:b7d0:19dc])
        by smtp.googlemail.com with ESMTPSA id n22sm106251580iob.37.2019.07.30.06.58.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 06:58:04 -0700 (PDT)
Subject: Re: [PATCH net] net: bridge: mcast: don't delete permanent entries
 when fast leave is enabled
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4511701d-88c4-a937-2fbc-b557033a24ed@gmail.com>
Date:   Tue, 30 Jul 2019 07:58:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 5:21 AM, Nikolay Aleksandrov wrote:
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 3d8deac2353d..f8cac3702712 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -1388,6 +1388,9 @@ br_multicast_leave_group(struct net_bridge *br,
>  			if (!br_port_group_equal(p, port, src))
>  				continue;
>  
> +			if (p->flags & MDB_PG_FLAGS_PERMANENT)
> +				break;
> +
>  			rcu_assign_pointer(*pp, p->next);
>  			hlist_del_init(&p->mglist);
>  			del_timer(&p->timer);

Why 'break' and not 'continue' like you have with
	if (!br_port_group_equal(p, port, src))
