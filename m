Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2179E6F440F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbjEBMqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjEBMpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:45:15 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4D35FD9
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 05:45:09 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-51f1b6e8179so2484193a12.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 05:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683031509; x=1685623509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JL0NFk8yMxL2Uax9qVim0oisHD3hlfOakqQFa+PAb+4=;
        b=cJYZchaVzuEeqmg3UdyBjWkFgNT4hor6f+jXfzGV36UMY3fam/h+WvORBrwvgLrFst
         6OFBfkKKGC9+2nv0J3Z1v77u8AWidcrSQ1usFD8ipZe/t5aZxYUHygiH9DLMrmr85ax0
         y+RMVIwq4FjAExr/S/UgU/LljQc0xi077earMtZgB72Vf04LTa27y7PyBwbVV8g7vPkT
         63r9hsI0bUAxlUK93NZ6iC8/EWdZ+65e206up7nPbRdbj8e3gsWstvD5px7XNClxk4ST
         oSjvM8tWu/V+Wd6wNGAJDRJSHQzPB+uuyKDwv/6+O/Z7+ycmmrYILaxV/1hKJJPD5/Sh
         Pjuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683031509; x=1685623509;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JL0NFk8yMxL2Uax9qVim0oisHD3hlfOakqQFa+PAb+4=;
        b=DCdmiDFb+BQEchZah8DO8c+0zEWN0OhMVTdVVDGvjupE1JYE/jarUlh58AuMNIx/Y7
         nZR6bNHmJU5IUCS6PWNBN2EMCepWEY9OoIywB0pE7NN8dAKUaAbsP5m7Ym40opSZZEM2
         twgr8botD6PH2RrFg1srRWMc7jsWEgfbY0D1cgLV278UqSUgKnUevZenrJ8LZQnMYo3i
         n5FHAEKiMGHRqne3egFrbqGnYgs5AN1Nv6S9m+qVwZWERA53A+q2YmzEQ4tiJax5BA90
         jVgjG/GbRzalc4VcGmxlptToDkXIGmsZl4l8OZRSf4XrP019vwAmOSDgbPN7PghyFUHy
         eu0A==
X-Gm-Message-State: AC+VfDyjSe/uHAqlLmycV6ssgvHXjBJAj3abkQvn+BkVPeM7RYJfE63l
        F/UWwAc+5Phy31wXFGwJksQ=
X-Google-Smtp-Source: ACHHUZ7yN/rOOho1wBDcbm5aHkaTEJzJK21HuVoarHQzUDiPdDtt5MO+z06mQsoLOdHSOKuBZAbw+A==
X-Received: by 2002:a05:6a20:7f9f:b0:fb:f0b5:1e3d with SMTP id d31-20020a056a207f9f00b000fbf0b51e3dmr1337077pzj.41.1683031508698;
        Tue, 02 May 2023 05:45:08 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j6-20020a17090a94c600b0024de0de6ec8sm5575898pjw.17.2023.05.02.05.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 05:45:07 -0700 (PDT)
Date:   Tue, 2 May 2023 20:45:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCHv2 net 1/4] bonding: fix send_peer_notif overflow
Message-ID: <ZFEFzvaRmPL5kLE6@Laptop-X1>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
 <20230427033909.4109569-2-liuhangbin@gmail.com>
 <ZEwmxt4vvw/+2zqI@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEwmxt4vvw/+2zqI@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 10:04:22PM +0200, Simon Horman wrote:
> On Thu, Apr 27, 2023 at 11:39:06AM +0800, Hangbin Liu wrote:
> 
> ...
> 
> > diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> > index c2d080fc4fc4..09a501cdea0c 100644
> > --- a/drivers/net/bonding/bond_netlink.c
> > +++ b/drivers/net/bonding/bond_netlink.c
> > @@ -244,6 +244,12 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
> >  	if (data[IFLA_BOND_PEER_NOTIF_DELAY]) {
> >  		int delay = nla_get_u32(data[IFLA_BOND_PEER_NOTIF_DELAY]);
> >  
> > +		if (delay > 300000) {
> > +			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_BOND_PEER_NOTIF_DELAY],
> > +					    "peer_notif_delay should be less than 300s");
> > +			return -EINVAL;
> > +		}
> 
> Hi Hangbin,
> 
> can this limit be implemented using NLA_POLICY_MAX() in bond_policy ?

Thanks for the comment, I will update the patch after backing from holiday
next week.

Hangbin
