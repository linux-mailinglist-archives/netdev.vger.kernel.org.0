Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7277D1DBA4B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 18:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgETQyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 12:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETQyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 12:54:25 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D747C061A0E;
        Wed, 20 May 2020 09:54:24 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i22so3533050oik.10;
        Wed, 20 May 2020 09:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nyBlTohT+p4Cct9XzKg6h0d1HJz/Pvm7IIF5Q+qFbBI=;
        b=KGvYAbunqzVh76KHN0n0y/hW65M0h2OTc2Q07Cl2IKbnUH3U3+oGricYMLuRmZE0nX
         kZRJ//VnXy+NJwy/0DpTNOwERPjfgMH7bluNkPZEAyThIt51mMn/kIoIfHpnlKPK8Lf0
         EXhi8uMdx2nphLKQyQg3L+VqgxuP4/vG22JzyTakC7cspd7V+mlOxck/yvx29c0RdfGa
         88uIlvLJoHQsqkcWsZ/m5mTT/DXhQ9QjsVoZqU+7tz9Lbl4JLmiUjea3isU7xj6wEMSx
         2Fhfb9CzSlniAFv6sRQiENk33wPqXM1tSruFF3WZo3n86rgjErZlO57OZoZ8kC13VWaL
         4jLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nyBlTohT+p4Cct9XzKg6h0d1HJz/Pvm7IIF5Q+qFbBI=;
        b=Ek7IBPmPlKe/VpSI1qa8ObosrCnnkLSQK63RS09nZ9NDKi0GVZJQ6D8kJodan9DUgU
         lx2fvgO0iaba7j7vKXTr831Mub+8Ga0+Gu22v/zbdYfXMmZgjq2QdzqmV7TYs814Z0om
         oA8B8N/oUKPI2xEl45H1vVI3ykGQEoILpTKxgsXAOVIRQQRmwpsvfwGHusYEO52b3YC6
         qB6AY9UagAZI44+8WFq0+bWjbpQfQTMKytRSYOBehfeMTsGxY2leiXrbS3Rk6B9e26yX
         YymcgnjJtXovfpE0wgWsIeOsT9vh0rjKe9aU1d5SB4CW2Yl9vzpjmJRuAedxvdUjwQpA
         DHXw==
X-Gm-Message-State: AOAM531A6s3R+Cz++ByVzPaq7aUHTul932DkEMbEQ9NpgYamOtQpeFyH
        1pWVJO8hkp9wm10VFF0B7OcQxZhX
X-Google-Smtp-Source: ABdhPJyqZxQli28p0gpsBxZr8df4TLQgts08Q70/zRlEG277Z2MdtkdEh7HuNUdUYDH0nyR76eLmKA==
X-Received: by 2002:aca:aa91:: with SMTP id t139mr3995498oie.176.1589993663525;
        Wed, 20 May 2020 09:54:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d5aa:9958:3110:547b? ([2601:282:803:7700:d5aa:9958:3110:547b])
        by smtp.googlemail.com with ESMTPSA id v24sm851366otn.59.2020.05.20.09.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 09:54:23 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6/route: inherit max_sizes from current netns
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200520145806.3746944-1-christian.brauner@ubuntu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4b22a3bc-9dae-3f49-6748-ec45deb09a01@gmail.com>
Date:   Wed, 20 May 2020 10:54:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520145806.3746944-1-christian.brauner@ubuntu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/20 8:58 AM, Christian Brauner wrote:
> During NorthSec (cf. [1]) a very large number of unprivileged
> containers and nested containers are run during the competition to
> provide a safe environment for the various teams during the event. Every
> year a range of feature requests or bug reports come out of this and
> this year's no different.
> One of the containers was running a simple VPN server. There were about
> 1.5k users connected to this VPN over ipv6 and the container was setup
> with about 100 custom routing tables when it hit the max_sizes routing
> limit. After this no new connections could be established anymore,
> pinging didn't work anymore; you get the idea.
> 

should have been addressed by:

commit d8882935fcae28bceb5f6f56f09cded8d36d85e6
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri May 8 07:34:14 2020 -0700
    ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
    We currently have to adjust ipv6 route gc_thresh/max_size depending
    on number of cpus on a server, this makes very little sense.


Did your tests include this patch?
