Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3621D88F
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgGMOce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:32:33 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B11AC061755;
        Mon, 13 Jul 2020 07:32:33 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id j11so11098805oiw.12;
        Mon, 13 Jul 2020 07:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zZwbP0XmcIlrVcvFrOStVLKCtwWwRzObsjDhvNvGkV0=;
        b=LUth4lsGIFbWOIWyqjUGwUEtMkh7ucn7ie31LCbFoM49wB64jcYpHa4Nj3pFeRqT/3
         ERwjef323qCiCl9uodl9MFsooiRetN7qAg9GJCOxJ19gdFQKmnBMNas22EPMtmoYLDYt
         dVWMlhKvDsub44I8qf3xpUWaqNRy2A579HDr12cIlaEQq/l6JGioG+8vlgNHMQz/Jnw7
         iCTGDdFyljbZJ4MYIw02uob5Ayfe1NfIxVeXfmRcFrmN4GfBSL7qsdlzCzL7Rcn/gq1g
         KOZ44u129s0Y55TAANi7vMWoPzuJ3d7rFWEYEPUUxjUiZ/kp6HXXB689dFEE1OUnVNOl
         T2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zZwbP0XmcIlrVcvFrOStVLKCtwWwRzObsjDhvNvGkV0=;
        b=p8v5ZLXI4J1iugG7aSFHKJ8asoQ+nVOq+xp94PU8fR+e5QSvA7nZR7kAagj39q0DUZ
         8O4JpGSwihiiYKt5KYcIdQ/zpSG0ns8oYYNnsDhHmHFY+1Mh6Ov9+fyNmvaz9dIgrZzo
         YmO5QsoXXx4I6XnwxLxnTLi4UtBea+dVBjxOWCFq0X7EycmFtkv0PjRifclPng2DdHST
         14MdoAlh9Wvava41Rt2Qjgoc25jt9zP97HT9Osr29MZ+i0TKZszT01q5PlCKbaW2v5Fy
         uluLluTcbWIUXmeFat9t7DyBJvDoSHeagAwwLw31yOXBJHa6qT2Du3ndflp2bHREn4OR
         sMyw==
X-Gm-Message-State: AOAM532Ch8GGINUjS6t0JfklES8GU98ACf/S56D1jJb9QwW9zOp87apL
        siyFYof3XbqmK5C8vNbJuBs=
X-Google-Smtp-Source: ABdhPJwX9c+DYb0h3lVTjYdIV9MgdQFsbe4hiAc1+s1XZLsEwVHrQ1OBfVTOxbCDWIbuU0e9tJC5YQ==
X-Received: by 2002:a05:6808:a19:: with SMTP id n25mr149036oij.84.1594650752806;
        Mon, 13 Jul 2020 07:32:32 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:a406:dd0d:c1f5:683e? ([2601:284:8202:10b0:a406:dd0d:c1f5:683e])
        by smtp.googlemail.com with ESMTPSA id u19sm2786287oic.10.2020.07.13.07.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 07:32:31 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/7] bpf: implement BPF XDP link-specific
 introspection APIs
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Jakub Kicinski <kicinski@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Takshak Chahande <ctakshak@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
References: <20200710224924.4087399-1-andriin@fb.com>
 <20200710224924.4087399-5-andriin@fb.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a68d9cc-f8dc-a11f-f1d4-7307519be866@gmail.com>
Date:   Mon, 13 Jul 2020 08:32:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710224924.4087399-5-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 4:49 PM, Andrii Nakryiko wrote:
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 025687120442..a9c634be8dd7 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8973,6 +8973,35 @@ static void bpf_xdp_link_dealloc(struct bpf_link *link)
>  	kfree(xdp_link);
>  }
>  
> +static void bpf_xdp_link_show_fdinfo(const struct bpf_link *link,
> +				     struct seq_file *seq)
> +{
> +	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
> +	u32 ifindex = 0;
> +
> +	rtnl_lock();
> +	if (xdp_link->dev)
> +		ifindex = xdp_link->dev->ifindex;
> +	rtnl_unlock();

Patch 2 you set dev but don't hold a refcnt on it which is why you need
the locking here. How do you know that the dev pointer is even valid here?

If xdp_link is going to have dev reference you need to take the refcnt
and you need to handle NETDEV notifications to cleanup the bpf_link when
the device goes away.
