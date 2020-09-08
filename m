Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76F4261CBB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbgIHTZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731074AbgIHQAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:00:39 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9830C061264
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 08:25:42 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u6so7601457iow.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZjjY7qBamAaU47N636mAYFSY6k8OVvvCwhK9XFmKs/4=;
        b=YlVziAlovp33/V31G3k8A3iXrKTFD/e761sZ5ST4muRAF7MyCUOWiaoeb2OLzsMUfX
         sLsYkg0PT6AGmnJKXqvQ9jvAaZ4p1jlsX2XsXj6896Nve8L++yhJJ+MBxRw6E4FnP51k
         lrYIewOlFccfRVITG1qT/K0YJhRI4kDkuTuh730XBuA56xZmSHRM5iFOvTI3qePZTGOf
         nGJ4APMr5gbslok/hJXLJMNHIWSoGfdEqrG6HEAKRBWDzJk51OF1ol5aIIhlgBi48MOc
         Ua+7MZ+D3lrBdnODtvN3D7DhjdDq9mPSr1QJ1nGNyT/zbIzl902f5SkbIl1PgYJAjwaG
         3rkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjjY7qBamAaU47N636mAYFSY6k8OVvvCwhK9XFmKs/4=;
        b=nvVKLrJ1lYrBiho1Q5yWSLkpFOv8tatIJOYslMGK6Zh0h3b8Tg19uDHtePmEyefsw6
         4E9Z72izlUtMMrd1PhSycEAYKhdtMTqAN7RsNpoz3DxQgjdmkR8FJPVpWoeKIgpUsALw
         OXwkKnmuO9e54iSfzh+dxF6fQWMfALDfxaWzon0giVCm2SNVjzS26iUUCjoOyIiTA6kN
         4pfjLAQyMRS33zV9b9s3sr0wncpj+wyB96VXWJZLmMFroR3waudDLkwY2EzdF1YfEpTg
         WIOScXszcGOfRPWkXlsR9oq+mSw3mbX3m02fM6JQyrvzTaqq6cwAtddB67UVpilJN4db
         b5sA==
X-Gm-Message-State: AOAM533VIntI/80Hi3BhDGHYrHZsA/ZBAeNneIKC/6ELJ2h3E2FBjV8p
        hFeYqzVScidAef965JuyhBRQdWzJ85kOgQ==
X-Google-Smtp-Source: ABdhPJzwYsNDfWIIGAWJT0uQKY6xajqX4foMtwIwvDyRW2nJ+7u+I4DhjdUp2AZdw5+MuFc1ZI71KA==
X-Received: by 2002:a05:6602:2d51:: with SMTP id d17mr21432716iow.11.1599578742083;
        Tue, 08 Sep 2020 08:25:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id w15sm5581667ilq.46.2020.09.08.08.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 08:25:41 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 13/22] nexthop: Emit a notification when a
 single nexthop is replaced
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-14-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d7df0551-f8ac-4c9d-5bcc-5ec67908fce1@gmail.com>
Date:   Tue, 8 Sep 2020 09:25:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-14-idosch@idosch.org>
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
> The notification is emitted after all the validation checks were
> performed, but before the new configuration (i.e., 'struct nh_info') is
> pointed at by the old shell (i.e., 'struct nexthop'). This prevents the
> need to perform rollback in case the notification is vetoed.
> 
> The next patch will also emit a replace notification for all the nexthop
> groups in which the nexthop is used.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index a60a519a5462..b8a4abc00146 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1099,12 +1099,22 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
>  				  struct netlink_ext_ack *extack)
>  {
>  	struct nh_info *oldi, *newi;
> +	int err;
>  
>  	if (new->is_group) {
>  		NL_SET_ERR_MSG(extack, "Can not replace a nexthop with a nexthop group.");
>  		return -EINVAL;
>  	}
>  
> +	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
> +	if (err)
> +		return err;
> +
> +	/* Hardware flags were set on 'old' as 'new' is not in the red-black
> +	 * tree. Therefore, inherit the flags from 'old' to 'new'.
> +	 */
> +	new->nh_flags |= old->nh_flags & (RTNH_F_OFFLOAD | RTNH_F_TRAP);

Will that always be true? ie., has h/w seen 'new' and offloaded it yet?
vs the notifier telling hardware about the change, it does its thing and
sets the flags. But I guess that creates a race between the offload and
the new data being available.

> +
>  	oldi = rtnl_dereference(old->nh_info);
>  	newi = rtnl_dereference(new->nh_info);
>  
> 

