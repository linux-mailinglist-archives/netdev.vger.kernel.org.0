Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5EE3F940C
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 07:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244225AbhH0F3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 01:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhH0F3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 01:29:22 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976FBC061757;
        Thu, 26 Aug 2021 22:28:32 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m17so3237607plc.6;
        Thu, 26 Aug 2021 22:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qNKc0AYQOuldCTs6QHf9qwfms0PO9naizoQWpy+ackQ=;
        b=XAR5ukIt3wvSepJyLv4D5M533KJ5eJcfjSXLiZ2s/0Gt7QXSIOdlvAC15xgFt8/dFd
         VCLhEu1cUPT5fIgQjPflV1By2Tqmj7AqcLRty0hkDGjOopBXAL2qKcdXTqUjYuYjq6pA
         OFgCb6bW1IbhMn5RnY1/oRzq7AZbtsmeMXp8qZM6ATBF3U0MVemsUPkiyd+wfJ8vdacs
         1p8j9nQ2jzdCnA36BI0YS84z+5fdtxj99NrgViU6v13VI7j+vSj5qvndN0mS+w+Ll+tc
         3iK8K9NQOAsajRZ97sEfWthH4CNSH5pkBfQD218GPS8406jswkM3VYM5M7Oso5MgxqeC
         2HYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qNKc0AYQOuldCTs6QHf9qwfms0PO9naizoQWpy+ackQ=;
        b=WcaeCOq+hgm0ogextJbqxsnhEi80zs4xtEP4wvpZm07Aeb6KeI6nQ5c0pfslVTOpvw
         GwQFWsdWiUsbNWh4eDSPahOwszYc5tRNKsxLcxTN+c03CVSG7ad9cigi9SLxZUHRvQED
         fqsmIMi5FkC+pWH33S74+ndxxuehbAXw0vEzfAxWXio8tUt5Y89AqR9xDi+ZkDZKfk6G
         bOnxmxa5clOGD2BCEW3Me7nfjPLhFj7ZoK2xUnyZX4n2RU4YdcH39GD8wCB0oicDqJCg
         IpGVfaS3g9duMe6Uv6qHXkam6JeqR74h7jpOXkWyJaZaKPkxaXhKgddm9/Fm7CKrecqz
         4jWQ==
X-Gm-Message-State: AOAM531YSUUNG7bwiLlz+Um9jkYnnLpcs7jOud4LyDKkkfkmsp8jH+vK
        rdNakTb0ArwilNHVRerTuJxn12mXV0g=
X-Google-Smtp-Source: ABdhPJw+OyNgNNIUWplkkODVZFudqVskWhN88zO+m/nK+wKJy2ycOtkthXhz85xAFHZ5QXxG4h/Cxg==
X-Received: by 2002:a17:902:b093:b029:12c:843:b55a with SMTP id p19-20020a170902b093b029012c0843b55amr7060657plr.83.1630042112170;
        Thu, 26 Aug 2021 22:28:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:647:5e00:7920:e0af:c816:c42a:733e])
        by smtp.googlemail.com with ESMTPSA id l19sm4581153pjq.10.2021.08.26.22.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 22:28:31 -0700 (PDT)
Subject: Re: [PATCH net-next v5] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
References: <20210826064603.5242-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6a870141-089d-5e2b-48a7-448695e26238@gmail.com>
Date:   Thu, 26 Aug 2021 22:28:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210826064603.5242-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 11:46 PM, Rocco Yue wrote:
> @@ -5651,6 +5654,9 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
>  	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))

I should have seen this earlier. The intent here is to only notify
userspace if the RA contains an MTU in which case this should be

	if (idev->ra_mtu &&
	    nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))

and in which case idev->ra_mtu should be initialized to 0 explicitly,
not U32_MIN.

