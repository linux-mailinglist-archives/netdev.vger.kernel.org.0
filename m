Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA0410AD3C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfK0KIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:08:00 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37447 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK0KIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 05:08:00 -0500
Received: by mail-lf1-f66.google.com with SMTP id b20so16658592lfp.4
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 02:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ohbOQnc700nXSSnABhfLnHFiQLyq4A/qXnZI9zyqJvA=;
        b=c7sqk01SVq6daDuTJUyyCNyKCLwHBZunOUbSrCG3KXSHaSeDwKNa0gxzc/g92hmMFN
         hlbqSKWnc4egzOHaUf8tBgk8xbCV4NjOWbehyOe6UgSTHYSeRQ8+APqfgr+Am6GpkXDB
         wvHtkM1dWi4qLwiOYvXwZaySuDINj2swXSIxJtE9d0QMV8qw8Ks4mdEAtdEVRyr3eI0y
         r70kOXqHUI35+29CGgwItCqhrtTG0emb1SF3/Nwzkqptx20UG2V8So9mQYaj1zMpNkwI
         yVEmH9UGl8e/Uk73Y0UGzPgJDiqPu3mCcGIx/p41HCkv+JmGdTQAErJ24rjETfmazpTZ
         wwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ohbOQnc700nXSSnABhfLnHFiQLyq4A/qXnZI9zyqJvA=;
        b=EQ1jApieHaKRgzmSX4ti+ar/eTXJrzL21R6sChSPvItbUevHOY6mSLBQHZZqnt+IgD
         j1l6xebgT6rfeEvcvfF/MNyEfkKHzdLxRQFIrTYZr8p6Vt8FHxBvS3dcDDuMiBOdjSVw
         McqXaKqw2RKmyzHJGFXoDmvGdUWug1C5I9zu5b/NlYQWKWREJZNIY5km5JSdIlM7zP4B
         STTlt/f9/HFiuOtZM+9ehSvyezgIiqA2X07Ou7XpXm+qq2iMs4ZEw9dN8pgn1OMBQh7I
         8cmltJNq0WnZNEJ7cjoZCvwiMu65QgVs3RPk2ACl6wCSQILGbuEadgZOTx/CIn8vimJk
         cXhQ==
X-Gm-Message-State: APjAAAU49lifYrdOqMhfl9DCNI+dv9jCLP2cVVlIhmuohurTjSCnnJUJ
        aWmZkNxTYofbLWED9R+DHskaxg==
X-Google-Smtp-Source: APXvYqyxRwMZ/PrzlApL8jSTKkL8ppmUybtBoH9YnulnXIw5b/EXgzMlcben0MO5PXxjT5tt1g+3VQ==
X-Received: by 2002:ac2:5216:: with SMTP id a22mr27499773lfl.18.1574849276264;
        Wed, 27 Nov 2019 02:07:56 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4237:c73d:3077:a4da:e919:17fe? ([2a00:1fa0:4237:c73d:3077:a4da:e919:17fe])
        by smtp.gmail.com with ESMTPSA id w71sm7704263lff.0.2019.11.27.02.07.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Nov 2019 02:07:55 -0800 (PST)
Subject: Re: [PATCH net 1/2] openvswitch: drop unneeded BUG_ON() in
 ovs_flow_cmd_build_info()
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pravin B Shelar <pshelar@ovn.org>
References: <cover.1574769406.git.pabeni@redhat.com>
 <a5a946ce525d00f927c010fca7da675ddc212c97.1574769406.git.pabeni@redhat.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <8806ee72-90f2-f9e6-6193-d59c6c31b1fa@cogentembedded.com>
Date:   Wed, 27 Nov 2019 13:07:47 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <a5a946ce525d00f927c010fca7da675ddc212c97.1574769406.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 26.11.2019 15:10, Paolo Abeni wrote:

> All callers already deal with errors correctly, dump a warn instead.

    Warning, maybe?

> Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>   net/openvswitch/datapath.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index d8c364d637b1..e94f675794f1 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -882,7 +882,7 @@ static struct sk_buff *ovs_flow_cmd_build_info(const struct sw_flow *flow,
>   	retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
>   					info->snd_portid, info->snd_seq, 0,
>   					cmd, ufid_flags);
> -	BUG_ON(retval < 0);
> +	WARN_ON_ONCE(retval < 0);
>   	return skb;
>   }
>   

MBR, Sergei
