Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE041D1EE
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347968AbhI3Dll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhI3Dlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:41:40 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D98C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:39:58 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id c6-20020a9d2786000000b005471981d559so5602825otb.5
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3DilanIwRE/Fn8ivf6SL4AHT2+vKsa0tS798qh0k7Vk=;
        b=mgUW8pUCiZY2FxkTZvzaSzj/l9Yz0IMx4I7f0ZqJ0IJdhh2qk5pEgrozhRUvWG0y3d
         GisbNtaKiBpDm3W/2UdzDbGO/zzdb6kM5aKCbZcFuoaxvL2Q0WBFZCsa1Tt7NWQ8wDjG
         rgJSGe6eQQ2ll3f1Cyw0+m9Wvp8lGIdRUcTTcUyOOYw2ZpMrrp8lfXSvi7bitE+BNtFH
         vGh0davFjiTtOCLb9YbzjBluElLFbp48qgvunGq6o0IVi3XsbGQKpflpHKSdJxvhFAj/
         HyhmvmFX00vcG1l25l4EP5gTNquZlGRWzug9hJQ6BSd89Cwys3x4WKp7AlxeWhbY2Lb2
         3NoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3DilanIwRE/Fn8ivf6SL4AHT2+vKsa0tS798qh0k7Vk=;
        b=XjzJpgI37o9G8ontrwTx8EuUnhqU0zn+JOBjXb7e0sHLDck1kLCbQe9sPtm0kOWmBn
         JFop8h7BCKkM/FEdORl8EJSbepw4/VNlwbvWc1ABO66FVZ5jl/SOhnt4jbfjgjL9RlUQ
         HtdsZorG1BgVci27vCgrpy20z0GJqC+iv7L2nLG7VgR1ZwfNDVnF9rOr9va2JF0XsaZZ
         xM4ejfE9HnaKJX1RYqlGklWuMbVs10+asiDLoiTTUweqi/YmOkbu9ZAck02uHrgVRBZ6
         rOpoGlAEYYLEQyyxHelTfdKzsSdQHIn5QcMmpUcxCTo3B+RUIcT7/NZH1u2fr104EXsg
         nGdw==
X-Gm-Message-State: AOAM530QM82UNJbRDZhL4n5OjWNcerQD+o2FsbIjKETj/2mm6c7TIQT8
        3IjkmD6YStQcTnGj34/T15I=
X-Google-Smtp-Source: ABdhPJzPNy1mpEm4D5X5d+CJCNqgKPaqP4xu5DD/wSgYO4gQQq3HbTasrmYe6tcQlrsrdTWP2RzNpQ==
X-Received: by 2002:a05:6830:2f2:: with SMTP id r18mr3175857ote.228.1632973198330;
        Wed, 29 Sep 2021 20:39:58 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bc27sm361281oib.5.2021.09.29.20.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:39:57 -0700 (PDT)
Subject: Re: [RFC iproute2-next 07/11] ip: nexthop: add cache helpers
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <20210929152848.1710552-8-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <401cdb30-1448-d63c-fa1a-f29b3a14094f@gmail.com>
Date:   Wed, 29 Sep 2021 21:39:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929152848.1710552-8-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
> @@ -372,7 +409,7 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
>  		if (RTA_PAYLOAD(tb[NHA_GATEWAY]) > sizeof(nhe->nh_gateway)) {
>  			fprintf(fp, "<nexthop id %u invalid gateway length %lu>\n",
>  				nhe->nh_id, RTA_PAYLOAD(tb[NHA_GATEWAY]));
> -			err = EINVAL;
> +			err = -EINVAL;
>  			goto out_err;
>  		}
>  		nhe->nh_gateway_len = RTA_PAYLOAD(tb[NHA_GATEWAY]);
> @@ -383,7 +420,7 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
>  	if (tb[NHA_ENCAP]) {
>  		nhe->nh_encap = malloc(RTA_LENGTH(RTA_PAYLOAD(tb[NHA_ENCAP])));
>  		if (!nhe->nh_encap) {
> -			err = ENOMEM;
> +			err = -ENOMEM;
>  			goto out_err;
>  		}
>  		memcpy(nhe->nh_encap, tb[NHA_ENCAP],
> @@ -396,13 +433,13 @@ static int ipnh_parse_nhmsg(FILE *fp, const struct nhmsg *nhm, int len,
>  		if (!__valid_nh_group_attr(tb[NHA_GROUP])) {
>  			fprintf(fp, "<nexthop id %u invalid nexthop group>",
>  				nhe->nh_id);
> -			err = EINVAL;
> +			err = -EINVAL;
>  			goto out_err;
>  		}
>  
>  		nhe->nh_groups = malloc(RTA_PAYLOAD(tb[NHA_GROUP]));
>  		if (!nhe->nh_groups) {
> -			err = ENOMEM;
> +			err = -ENOMEM;
>  			goto out_err;
>  		}
>  		nhe->nh_groups_cnt = RTA_PAYLOAD(tb[NHA_GROUP]) /

those should go with previous patches.

