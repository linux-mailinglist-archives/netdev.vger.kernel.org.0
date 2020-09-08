Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEEC2617C5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgIHRmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731667AbgIHQOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:14:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDDCC09B04A
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:44:02 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id j2so17304770ioj.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fe8zfIBhDwxKpbqi1swwI2f1Y/PtImvzPTCMuyO8osY=;
        b=GW+XKo+F/OFv9+S0A9wwaVNIhRTtEi16/lwCe/cRnXh+Qr38Y+X0d8770MHf2cOzIM
         6lemYGlxEOHk8EDuGQh2JQ6dx8t0IPj0VzJWZM+dJ1N7YEAAhFr8yBkcuAqqDQMWiUlw
         DEo40lGaw1iPQfz4JpUBw5IeNvWSzt+rCz7Dk6qjY/UfauTSPARVH1c25tiszhdNA51s
         JSL3EpYtdT3bZNvWXSs9/Il7cgMajpE27tsdfvf7aXF6xpFBgXa0mSBhioJ/bWM7nDLu
         ZjgDaBTCAmfjJpQfEkspQgZobGotnxFW9/Cs3rvT01sMrv/3kKyhSTqbwWm4fIcIG6Yf
         zC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fe8zfIBhDwxKpbqi1swwI2f1Y/PtImvzPTCMuyO8osY=;
        b=H7/X/13w3IWtChC5bbhN3A5f09+Hxgsj10j9XK9tVDzUVVXo2VybSTP/mgL0qW8M67
         dicUc2hPfdqJtSlgvK+/SHeaQmq8AjfiOuW0f5Sth1Idaue5uC/PLuNVuyf05Vx+pn0q
         9p1B7hsJNISrfs8w2p0CsixsHMgy9C6idSGKr7rzVrVRn3/HKI+CoS8eQD9ePDarKZxU
         vWmNaSjfcB1ocTDcB8PQiFrzS+Ik9qLWULcZ8Wru+th958n+f/MwXEYTkzd6VKj1KLDT
         7ZbsqFPhBbVYMN5wFstN3tHXwSV3LATMLYncOjnz8/hOTPVTMS9oU0GLSNvLtf6IXfrP
         0FXg==
X-Gm-Message-State: AOAM5335+Mnb5LoGfl5TcrJESs+6Ta0fLPHZuxeytRS/l4abHnfTMPGM
        MOrTyVB5KQp6ssmb5amifeE=
X-Google-Smtp-Source: ABdhPJwvNEzLUvptG19z0UF3Jwx/Og+YsXmeTyvurOU/mCpDnopzypqUP2dJ2BUECg/Q29bCmkrLmQ==
X-Received: by 2002:a6b:15c3:: with SMTP id 186mr21410642iov.161.1599576241939;
        Tue, 08 Sep 2020 07:44:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id o12sm5386206ilq.29.2020.09.08.07.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:44:01 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 06/22] nexthop: Pass extack to nexthop
 notifier
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-7-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80a556da-f68f-7c6a-8029-30fd9c6aa63a@gmail.com>
Date:   Tue, 8 Sep 2020 08:44:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-7-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The next patch will add extack to the notification info. This allows
> listeners to veto notifications and communicate the reason to user space.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 8c0f17c6863c..dafcb9f17250 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -38,7 +38,8 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
>  
>  static int call_nexthop_notifiers(struct net *net,
>  				  enum nexthop_event_type event_type,
> -				  struct nexthop *nh)
> +				  struct nexthop *nh,
> +				  struct netlink_ext_ack *extack)
>  {
>  	int err;
>  
> @@ -907,7 +908,7 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
>  static void remove_nexthop(struct net *net, struct nexthop *nh,
>  			   struct nl_info *nlinfo)
>  {
> -	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
> +	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh, NULL);
>  
>  	/* remove from the tree */
>  	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
