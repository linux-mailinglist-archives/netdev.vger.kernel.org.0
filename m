Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1311B2A99A6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgKFQkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgKFQkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 11:40:17 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D222C0613CF;
        Fri,  6 Nov 2020 08:40:17 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id j12so2115243iow.0;
        Fri, 06 Nov 2020 08:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wFLtKUwT5ZvmDcv5zrEJNSopht3kHGBwLH6MG+aoAb8=;
        b=Vg5nKxDZu895ttIHrDM477LtUq2tTMuNvYBCp/tR8Xl2m2lIeak6kqji6iOpxtSjmb
         KU+29HSyzpytGLDR2uJVWBSnhoeLDlYTUaoiNnRn5xm2PN0uP6DqN0ixhKt2vtzFjyeE
         8XW7IDHpaKvXbEt701jGTvOdmPV9XPpkcXO9Mf8rqKlDB9/mVgff8oK17QXddT80Zm0Z
         PAqj8LqYsRNzh+iJ1Go36LS+ou5dbAtAqEx+jwIwA+QvuEtVpXL5Yo5uv/99RUZ/Skgd
         vo+s9Jk8zg+VJOEToB4bUnjRjt9v2kedXGY0n8hSQnHegamgwRMZY4O5FgzvN6TqatV0
         8tkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wFLtKUwT5ZvmDcv5zrEJNSopht3kHGBwLH6MG+aoAb8=;
        b=NfJ0C6hZZEWpMq4SsYVxnqLKOwVCn4S5ibgzYhMfCRruSl5Rxk6z6PSVyr8bIs/SgK
         2LgShXvbPP0TS0uOT0MZauiyk1Ii6UwlolxYK2pmh+qvrkAsNHwmPAbJgZniNMRGG6Tt
         RwiRoYia1ScHBBHLV8DHIVg3yKqJU5f6/4Ph2/ekqqCaeiyzyq0XG4T1ybW3TatJICgh
         eX9uGw4QLR/8D4Vjcd3gWr5q+ZABsBpExlJLIEc4A1x+G0PeKOfisCusBcg1+x5Ya3r4
         encgRCTR2Yzv1K6rh7yJObJbPOPdA3qIfWN4fURA/Z34S5QgW4oLcmEHv2oNSbFlmrHE
         TULw==
X-Gm-Message-State: AOAM530V6cYwyVV/v12KSnSgR0M0ZOxXzWb3KZYefuHLfxLy5bwWzHOd
        HBWHJIzn8gqwSBVq67SX0QA=
X-Google-Smtp-Source: ABdhPJzkJbtdTj466ZCI8mKcmOme9VuesNIVUd10qMJjwA15AHpdZtiCSDPM0/9n2ZtbofRm8ZnBng==
X-Received: by 2002:a6b:3e83:: with SMTP id l125mr2071092ioa.151.1604680816504;
        Fri, 06 Nov 2020 08:40:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:59f:e9df:76ab:8876])
        by smtp.googlemail.com with ESMTPSA id n15sm1376010ilt.58.2020.11.06.08.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 08:40:15 -0800 (PST)
Subject: Re: [PATCH v2 iproute2-next] bridge: add support for L2 multicast
 groups
To:     Vladimir Oltean <olteanv@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@mellanox.com,
        idosch@idosch.org
References: <20201029222828.2149980-1-olteanv@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2f127ed7-a816-bb13-0be2-68b19eef78fb@gmail.com>
Date:   Fri, 6 Nov 2020 09:40:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201029222828.2149980-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 4:28 PM, Vladimir Oltean wrote:
> @@ -168,9 +176,14 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
>  	print_string(PRINT_ANY, "port", " port %s",
>  		     ll_index_to_name(e->ifindex));
>  
> +	if (af == AF_INET || af == AF_INET6)
> +		addr = inet_ntop(af, grp, abuf, sizeof(abuf));
> +	else
> +		addr = ll_addr_n2a(grp, ETH_ALEN, 0, abuf, sizeof(abuf));
> +

The above can be replaced with a single call to rt_addr_n2a_r.

>  	print_color_string(PRINT_ANY, ifa_family_color(af),
> -			    "grp", " grp %s",
> -			    inet_ntop(af, grp, abuf, sizeof(abuf)));
> +			    "grp", " grp %s", addr);
> +
>  	if (tb && tb[MDBA_MDB_EATTR_SOURCE]) {
>  		src = (const void *)RTA_DATA(tb[MDBA_MDB_EATTR_SOURCE]);
>  		print_color_string(PRINT_ANY, ifa_family_color(af),

I think the rest is ok.
