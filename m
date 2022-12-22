Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94420653CA7
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 08:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiLVHsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 02:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiLVHsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 02:48:40 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B4324954
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 23:48:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id u4-20020a17090a518400b00223f7eba2c4so1065426pjh.5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 23:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9l+qwncIf3VpLaYi/ljxLFn2Z/dpF9XmBY8f2rw2CQ=;
        b=KV5F1KjF/en+QpNfUJBE85FRONuHGwRQU+b6E9LTMUQIHg8qn7NGqpRMyySqBd5PFa
         VC/On+8xG8o8i7vTcHBcWbCFM8L1gb3YGOifPVsX1/s7SQEQ05SwTRoJq8/As3bmg59W
         hTcrrX8fDO1iVxojG41avtwrA/XL7ekTv6m5XLag6qI4nIWxlK5sS7YC+miVOEgznrbh
         v8U6DM6LkAadMtDOEvIOnjxVy0IMx4D5bOU7/8INLtgNTcqz1JhkEKHr77BqPJPAqvtS
         n2/nCnva1KD7AuGQ8PoRYQicnmJ8YSXNHlTCdG1aQQN4MCrTOcS49LjmDAyZPR5RaPU1
         m7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9l+qwncIf3VpLaYi/ljxLFn2Z/dpF9XmBY8f2rw2CQ=;
        b=UiinQnl2sa8venjCeiC+3TUqddsl6UJvLuutrcUi64FFGY74MHPKTGCV5t3c+G1Waq
         u4j+LVxMRQF6ArPaHUZNxzNHdbN2fDVyYppHi/3WRbrW7vjOQoUfAENvu+p8kiRtrfSO
         hirQ7ubbb/pozK5OFD78pSfxLcE4yR6yGEPiyt58RpIYRE4o+vaPv58BrmKu5Sp4BU3g
         7gI8ykEXbWpEE8ObHW98fzdxQL0jPk7m/aqKA1jhFqbEhWmQ1CrgyzkiFbolWr34kOhN
         M4iNZy6M+umUKq0g+6/0kCFxnOI9Jjh5PpumPbErlLuEeh3mpWH2ZKs+zqnLV23VuMKs
         uHWw==
X-Gm-Message-State: AFqh2koK796RqzVN6mYaBF+ShCgxR2mKhEA/XeDfbKBLdHktDdsyrzKI
        +itWpz2GEZJ5icDL1gEBf0apZQcUtt2SsBRi
X-Google-Smtp-Source: AMrXdXvbJVeeHRH/28fp9kVZZyabDwXTKA0vkVY5Okyb9udIWJiwvkuKvWcy4xPwszPpLiaQfPEo+A==
X-Received: by 2002:a17:902:a588:b0:192:50cd:97e2 with SMTP id az8-20020a170902a58800b0019250cd97e2mr2184619plb.26.1671695317733;
        Wed, 21 Dec 2022 23:48:37 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902650f00b00186b86ed450sm3038227plk.156.2022.12.21.23.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 23:48:36 -0800 (PST)
Date:   Thu, 22 Dec 2022 15:48:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
Message-ID: <Y6QLz7pCnle0048z@Laptop-X1>
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221172817.0da16ffa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 05:28:17PM -0800, Jakub Kicinski wrote:
> On Wed, 21 Dec 2022 17:39:40 +0800 Hangbin Liu wrote:
> > +	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, NLMSG_ERROR, sizeof(*errmsg),
> > +			NLM_F_ACK_TLVS | NLM_F_CAPPED);
> > +	if (!nlh)
> > +		return -1;
> > +
> > +	errmsg = (struct nlmsgerr *)nlmsg_data(nlh);
> > +	errmsg->error = 0;
> > +	errmsg->msg = *n;
> > +
> > +	if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
> > +		return -1;
> > +
> > +	nlmsg_end(skb, nlh);
> 
> I vote "no", notifications should not generate NLMSG_ERRORs.
> (BTW setting pid and seq on notifications is odd, no?)

I'm not sure if this error message should be counted to notifications generation.
The error message is generated as there is extack message, which is from
qdisc/filter adding/deleting.

Can't we multicast error message?

If we can't multicast the extack message via NLMSG_ERROR or NLMSG_DONE. I
think there is no other way to do it via netlink.

Thanks
Hangbin
