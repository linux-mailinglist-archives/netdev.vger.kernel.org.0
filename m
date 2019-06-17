Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC904778F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 03:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfFQBR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 21:17:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34489 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbfFQBR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 21:17:28 -0400
Received: by mail-io1-f68.google.com with SMTP id k8so17765463iot.1
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 18:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lA4QUrk/bgzYROLlHr0tn/5eztBCBM5r9LwCXqZQf7o=;
        b=n1o1sCeMQnbYNdOLexUnN4mf3p/DCcY6TTyQFwKgMtzJoBs7XZYjr6QG3jzf9n55n/
         LyiKJvW81I6doHv4zq32QBvv7AhpwSos2N5LJnABUTpAAVV5MGoafC1eA6+Ttx/zlLwy
         7OKuqLU01swJ/hmvaFAYKqEv9qmwAsfBgnZqBZ00o7TG1c/lTTCptNK7hfDhoTekkPYT
         S41+zxNHizHiWsv2oqYfcv1h8Gw6+pm3o2DoCBERDkqqIsLkt+O+4TbkedF4mlnkOW47
         fEVDn852UCZBgMzK0o0ntGDMjh17W8eJOhwS8y70mCIP9777Rg9vwIby8ByActnUoQrq
         6J6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lA4QUrk/bgzYROLlHr0tn/5eztBCBM5r9LwCXqZQf7o=;
        b=rWsucH24wGptQSB1bV4QSuOsL3lzrprm3n9dXXuGwQWtOLYEqYsUgxdXgRuWYLhsaV
         sPlpS/zBv6+P0nj61RedO+oONkG93QtVWyARkpyf/Y1zJa19tM8FVccr5LWSUdjReVNo
         8oZl4yAuxjOA7ENqjJrEz0KIYqx9W0ySNpM1SWGclox+EgDMu683Tk1KsugWgpvppjF4
         r5ijiQxsguQKCo8UtqMh2aFeEXqIrKpfI69cVs00/TpD3C2V2Ol+k+8HDogSukpAWuiw
         EHXhnO7sPODAvzwybMuS0pA4Xu+804QoaZ/E+YfrgW1u+/0OPWzyE5cwI1nIhDp/T2Qq
         YY0w==
X-Gm-Message-State: APjAAAUh3kTPK54KasHre6P1AdcES5ixeevGiIA/JkC2r6ohtEYnncbt
        ijP3SJvuczsIuX/lr+b/i6w=
X-Google-Smtp-Source: APXvYqySu7+rZ1Y/fp/zrZ8GRa4sUPHyZlQwLxSfEpO8CMA9j0L8ORpioJb1bSzbZVpTTCrRB1S69g==
X-Received: by 2002:a02:ab83:: with SMTP id t3mr2370546jan.133.1560734247946;
        Sun, 16 Jun 2019 18:17:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:e47c:7f99:12d2:ca2e? ([2601:282:800:fd80:e47c:7f99:12d2:ca2e])
        by smtp.googlemail.com with ESMTPSA id t5sm7433080iol.55.2019.06.16.18.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 18:17:27 -0700 (PDT)
Subject: Re: [PATCH net-next 02/17] netlink: Add field to skip in-kernel
 notifications
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexpe@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190615140751.17661-1-idosch@idosch.org>
 <20190615140751.17661-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c4ff39a6-9604-6c3c-bf2b-a2c36471e84d@gmail.com>
Date:   Sun, 16 Jun 2019 19:17:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615140751.17661-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/19 8:07 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> The struct includes a 'skip_notify' flag that indicates if netlink
> notifications to user space should be suppressed. As explained in commit
> 3b1137fe7482 ("net: ipv6: Change notifications for multipath add to
> RTA_MULTIPATH"), this is useful to suppress per-nexthop RTM_NEWROUTE
> notifications when an IPv6 multipath route is added / deleted. Instead,
> one notification is sent for the entire multipath route.
> 
> This concept is also useful for in-kernel notifications. Sending one
> in-kernel notification for the addition / deletion of an IPv6 multipath
> route - instead of one per-nexthop - provides a significant increase in
> the insertion / deletion rate to underlying devices.
> 
> Add a 'skip_notify_kernel' flag to suppress in-kernel notifications.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/netlink.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Unfortunate a second flag is needed.

Reviewed-by: David Ahern <dsahern@gmail.com>


