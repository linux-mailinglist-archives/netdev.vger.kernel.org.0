Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB059B8A6
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 00:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfHWW4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 18:56:51 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:39484 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfHWW4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 18:56:51 -0400
Received: by mail-io1-f53.google.com with SMTP id l7so23774687ioj.6
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 15:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=h+a3NCVDSb5O2WyZx2N9A00Z24tK+m83eRW0ZQkJH14=;
        b=gZieTTOESzLy/+r8GAFWVYdzVfLpNM3tE0oUFo/uGSx5DH9dJCBIyofQz05vgBwA6n
         4ls3UwHAzGhr0o+oWijYgIjC4HBXI31mgy7CMA3E2/3jK0zJbLgTJu0VpyuQIgF9whEi
         plpbLLeRmXJnartfa3gwP2j1zoX6c1630lVwIm6TuBPn+EE7zM8qvkb4F+oEQJuNJ5aD
         4cT83I6A916AIYslj7jTu8Gf40rj87h3sTJ9iBhePC1yUb8CBLdwSJ9qF6KlLFDXwr3B
         y96G3LWQlgliyKzIcSr3HHt5NVArUW5W95I7/zhnEX/2IbO4Et5ZKUjgGH6/i7z1pG1f
         BOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=h+a3NCVDSb5O2WyZx2N9A00Z24tK+m83eRW0ZQkJH14=;
        b=FHsfMGBpT6TufZJy9WRsXvbtSBkaYslHtMdozPQAwTcoPcSbCozv/xEwn9BQtCocOp
         d/Oy+F+EKUxUYmCnOygA8qyViagnMobAi6eY6awGFGgD4yszMnKOm+vapINtBq4Idb1c
         lh2hzgoZLZE6PulH87+JpTs6ztt4RN9xPB98XjnCBWR+pATUlIAhr/f7c8lv68BKKUCh
         456HWsqmIESyB2VB9JpaZs39Blra3X8vo1TpNYaKTuL0S5yactFcnUHmIQCdnbfQlB71
         TZnxw4vT/Vpot+4B3ZgFxDzLSjxqRM/vNsCeKEz/sUtYO1YyxFGtsHTpWMYV+jdpOxsB
         dGYw==
X-Gm-Message-State: APjAAAU/eHVau/xkE08mCJQVomYZUXDhWjfadzM3EsozB6mZXzbxIT+r
        O2tuyyp1S53Y9h0mlPLmh4zvYjexGSs=
X-Google-Smtp-Source: APXvYqw2K4qtRAAqPXhXMDXuhXRUGnqTfdYr+KyV0EsUGlZLBL9hsrwTrP1/TneLaKbYc5tMII18ag==
X-Received: by 2002:a63:9d8a:: with SMTP id i132mr5960457pgd.410.1566599438075;
        Fri, 23 Aug 2019 15:30:38 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::b6f7])
        by smtp.gmail.com with ESMTPSA id v67sm7884045pfb.45.2019.08.23.15.30.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 15:30:36 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Hangbin Liu" <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Stefano Brivio" <sbrivio@redhat.com>,
        wenxu <wenxu@ucloud.cn>, "Alexei Starovoitov" <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Julian Anastasov" <ja@ssi.bg>
Subject: Re: [PATCHv4 net 2/2] xfrm/xfrm_policy: fix dst dev null pointer
 dereference in collect_md mode
Date:   Fri, 23 Aug 2019 15:30:34 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <F97CCF29-DDB4-4AD3-9EF6-1AF1F16529DF@gmail.com>
In-Reply-To: <20190822141949.29561-3-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190822141949.29561-1-liuhangbin@gmail.com>
 <20190822141949.29561-3-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Aug 2019, at 7:19, Hangbin Liu wrote:

> In decode_session{4,6} there is a possibility that the skb dst dev is NULL,
> e,g, with tunnel collect_md mode, which will cause kernel crash.
> Here is what the code path looks like, for GRE:
>
> - ip6gre_tunnel_xmit
>   - ip6gre_xmit_ipv6
>     - __gre6_xmit
>       - ip6_tnl_xmit
>         - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
>     - icmpv6_send
>       - icmpv6_route_lookup
>         - xfrm_decode_session_reverse
>           - decode_session4
>             - oif = skb_dst(skb)->dev->ifindex; <-- here
>           - decode_session6
>             - oif = skb_dst(skb)->dev->ifindex; <-- here
>
> The reason is __metadata_dst_init() init dst->dev to NULL by default.
> We could not fix it in __metadata_dst_init() as there is no dev supplied.
> On the other hand, the skb_dst(skb)->dev is actually not needed as we
> called decode_session{4,6} via xfrm_decode_session_reverse(), so oif is not
> used by: fl4->flowi4_oif = reverse ? skb->skb_iif : oif;
>
> So make a dst dev check here should be clean and safe.
>
> v4: No changes.
>
> v3: No changes.
>
> v2: fix the issue in decode_session{4,6} instead of updating shared dst dev
> in {ip_md, ip6}_tunnel_xmit.
>
> Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnels")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>

This does resolve a local crash where the dev pointer is NULL.
