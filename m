Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A726239C8
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiKJC2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiKJC22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:28:28 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF53526D8;
        Wed,  9 Nov 2022 18:28:27 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id h10so560717qvq.7;
        Wed, 09 Nov 2022 18:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NkdQ/WurO1hHJLC7ybTckDQ6CYDmu0x+X2BkTGqE4BI=;
        b=S0+CzsCYNuf5a4dVkXJDdCX7gLAVf6xn2OmbTgqn6mnRBgq1iW8/wQdY4L0QIBkiEy
         LMZumXBDcLOk1temcUSCYpvHaDOIPETf3UwvimACcwlSsKuxd8h811eOrmREW0gCnz33
         R7HljoooXAuRJlZyXCtcHMmqPWoL58ZEmvbYf/dpoU7N3i9TUbkEy8eMGtvqPCis6SCU
         8NTNJciYqBaOL1/F6b/1bLvjuF+gck/H+/dd92Gj6k74NJDJiigsLXoSafWPCRBEy8r/
         60fJj0CSbquEyJd7lAl1rdKX+jMpSCaWgDNp5fZRJ8UIkdNl/U089c4V2cLk8j2iAr+x
         55+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkdQ/WurO1hHJLC7ybTckDQ6CYDmu0x+X2BkTGqE4BI=;
        b=crAWo/FoI/TiKrxZjbnTEIbB4SFdQvhK3az2gKsHxaiuudtMj8ymWo/tEzFaZ1hgvj
         uf8W/XHfW5rNBjDpCpnFX+csE48h93wIV4upFaUzyeHKkaSLwbPS8wluxZqkF3u8BZDA
         Hlh+rDQWgLl2lSjsLF4S+0Q61V7J+XDMwPK9PKc2Is/qLjE8i1dcuQij+Moz8X/bj+2n
         LGaEnAOEo2SUsj3bKrNUpxvss5Q8FNrd9xNsaB/1MvARXtMJL5yAZWY91P2aVNlXuoeJ
         s/2Ljyqaf9iXrZFQarbDKkOUHXiHfUJgMcVMSNiA6Klr/H2wV4ot/+Ed3cKUpozz3Ypf
         7kNw==
X-Gm-Message-State: ACrzQf0HdFNCVs+4TlJGIpOXgqLv6/bPg6GLwZoVtRvIJmp9K3lZkFpI
        /GuHDtBCOChmH9/0F0jtJuaUfyaPLg==
X-Google-Smtp-Source: AMsMyM4LiIM48wIeVmo+fjB8y1ZVFBSutKtr7j0ZEcLw2yGFGzGtiJLh6GpsyWJXYz/oPIv65FIP7Q==
X-Received: by 2002:a0c:cb01:0:b0:4be:e9f3:6d0 with SMTP id o1-20020a0ccb01000000b004bee9f306d0mr32515278qvk.3.1668047307087;
        Wed, 09 Nov 2022 18:28:27 -0800 (PST)
Received: from bytedance ([130.44.212.155])
        by smtp.gmail.com with ESMTPSA id l16-20020ac81490000000b003a57004313fsm10593330qtj.3.2022.11.09.18.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 18:28:26 -0800 (PST)
Date:   Wed, 9 Nov 2022 18:28:22 -0800
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20221110022822.GA2463@bytedance>
References: <20221012232121.27374-1-yepeilin.cs@gmail.com>
 <20221014000058.30060-1-yepeilin.cs@gmail.com>
 <Y0kDKpuJHPC36kal@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kDKpuJHPC36kal@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 09:35:22AM +0300, Leon Romanovsky wrote:
> Please don't reply-to new patches and always send them as new threads
> with links to previous versions in changelog.

Sure, I can do that.  However, for example: 

  - I got a build error.
  - I found on LKML some v1 patch developed by someone else that
    introduced a similar error, by searching the error message.
  - I wanted to know how v2 fixed that error in v1, but since v2 didn't
    in-reply-to v1, it took me some extra seconds to find v2.

Therefore, I think sometimes it's useful to keep all versions in one
thread, especially when the set only contains one patch?

> > diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
> > index f13f16479eca..084da6698080 100644
> > --- a/drivers/infiniband/hw/erdma/erdma_cm.c
> > +++ b/drivers/infiniband/hw/erdma/erdma_cm.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/types.h>
> >  #include <linux/workqueue.h>
> >  #include <net/addrconf.h>
> > +#include <trace/events/sock.h>
> >  
> >  #include <rdma/ib_user_verbs.h>
> >  #include <rdma/ib_verbs.h>
> > @@ -933,6 +934,8 @@ static void erdma_cm_llp_data_ready(struct sock *sk)
> >  {
> >  	struct erdma_cep *cep;
> >  
> > +	trace_sk_data_ready(sk);
> > +
> >  	read_lock(&sk->sk_callback_lock);
> 
> I see this pattern in all places and don't know if it is correct or not,
> but you are calling to trace_sk_data_ready() at the beginning of
> function and do it without taking sk_callback_lock.

Thanks for bringing this up, but I'm not sure it's an issue.  We already
do similar thing, for example, in net/core/neighbour.c:

static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
			  u8 new, u32 flags, u32 nlmsg_pid,
			  struct netlink_ext_ack *extack)
{
	bool gc_update = false, managed_update = false;
	int update_isrouter = 0;
	struct net_device *dev;
	int err, notify = 0;
	u8 old;

	trace_neigh_update(neigh, lladdr, new, flags, nlmsg_pid);

	write_lock_bh(&neigh->lock);

Thanks,
Peilin Ye

