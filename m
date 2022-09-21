Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3A25BFC5A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 12:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiIUKb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 06:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiIUKb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 06:31:26 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8468E901AC
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 03:31:25 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b75so5475639pfb.7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 03:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=g7/bNXBkv6Zn92S95QY8Dj8e/vsOzrDZ7l2HEpYLx+E=;
        b=pF1f1hMGpqMxxcYIdDvGVUwjLtkLMx5hNm5ZKpt3InXMQb22wi8jf+uLlZy/4dEg9T
         nrYSc4+1JMg0kbsgrazR5Y8tvmoI9uKjLpaWn/1ENQdK2mFHoS6Gfn40doc/Tg7op9bA
         ud+VYRMCwnfd1nyvaJZNLabNiR0e6rYrwEiC2nXLSeBPbBb/Bv9cUB4YRUS6hgHm6lyU
         ZhZPLf2TpylxicmLlArqZEKZmwfeRFGdHBbkhhQaE8XQ3Gj7fN7j+nEOu73d5VGfeZEb
         fm5JUtiWzXReta8RLX9BZ/cHf2lMAr0yymCYkkZ/N0Te8PW0Fv/SL5aVxA6fknNW98hy
         5Irw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=g7/bNXBkv6Zn92S95QY8Dj8e/vsOzrDZ7l2HEpYLx+E=;
        b=F5SSl3Hh90KYQrNDnPo1+O60QXva/ow8yxtnOZgjSqLpmgYRzqCeWtkAYNbgzWtOyx
         WToS0Fxg3In2JKDuO9m2qbvHNV6K6wo38PZc+3rFpCK42tc6aF5QOIV6t5IW2dKytMed
         Imwc+yUeBEj6M6UnvAyRtn+9L5JZjrSVBKRs5dJHMeHvYmB9/oCNdUmCXnoKvw32LldD
         W30lLBv26wJKJD50YpBbk7DHY0OcptVE3RuS0rm7KBoZIxM9NbyHbStdFsHzL4gInLO4
         91idcGrgML27Kz1fkg3KG8+eXoTbIiPKRnAgoYJeeqwsWTqY7wh+ClPx5GMb+Mx7SW4W
         KNzQ==
X-Gm-Message-State: ACrzQf2Qt2jro189MLQbV6L2jFxuEHzDdHP2+E9NNQjISZZRCVZ9t5rQ
        7XQGRcunovmyM5CjsQ0mIdM=
X-Google-Smtp-Source: AMsMyM5qCsOt+HZM4EEPUTcTxDmAT+oVWNECMJAOr9GJU4z3KROK85mPx1nU4Omkw9FCph2Dcxv+Cg==
X-Received: by 2002:a63:8641:0:b0:43a:c03d:6af with SMTP id x62-20020a638641000000b0043ac03d06afmr9010077pgd.611.1663756285022;
        Wed, 21 Sep 2022 03:31:25 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d18-20020a170902ced200b001783f964fe3sm1644912plg.113.2022.09.21.03.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 03:31:24 -0700 (PDT)
Date:   Wed, 21 Sep 2022 18:31:19 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in rtnl_{new,
 set}link
Message-ID: <Yyrn9wIO+3kU/zOx@Laptop-X1>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
 <1ff2e97e-003f-e6b4-d724-c42449fde221@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ff2e97e-003f-e6b4-d724-c42449fde221@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 11:11:19AM +0200, Nicolas Dichtel wrote:
> > @@ -3336,9 +3381,9 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
> >  		return PTR_ERR(dest_net);
> >  
> >  	if (tb[IFLA_LINK_NETNSID]) {
> > -		int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
> > +		netnsid = nla_get_s32(tb[IFLA_LINK_NETNSID]);
> >  
> > -		link_net = get_net_ns_by_id(dest_net, id);
> > +		link_net = get_net_ns_by_id(dest_net, netnsid);
> >  		if (!link_net) {
> >  			NL_SET_ERR_MSG(extack, "Unknown network namespace id");
> >  			err =  -EINVAL;
> > @@ -3382,6 +3427,17 @@ static int rtnl_newlink_create(struct sk_buff *skb, struct ifinfomsg *ifm,
> >  		if (err)
> >  			goto out_unregister;
> >  	}
> > +
> > +	if (nlmsg_flags & NLM_F_ECHO) {
> > +		u32 ext_filter_mask = 0;
> > +
> > +		if (tb[IFLA_EXT_MASK])
> > +			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
> > +
> > +		rtnl_echo_link_info(dev, NETLINK_CB(skb).portid, nlmsg_seq,
> > +				    ext_filter_mask, netnsid);
> => netnsid, ie IFLA_LINK_NETNSID has nothing to do with IFLA_TARGET_NETNSID.
> Link netns is used for x-netns interface like vlan for example. The vlan iface
> could be in a netns while its lower iface could be in another netns.
> 
> The target netns is used when a netlink message is sent in a netns but should
> act in another netns.

Oh, thanks for the explanation. Then we can remove the netnsid parameter
from rtnl_echo_link_info().

Thanks
Hangbin
