Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF90654B23
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 03:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiLWCf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 21:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiLWCf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 21:35:58 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CFF175BC
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 18:35:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d3so3710275plr.10
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 18:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gAj5aRV7DjVub+rWMi/CqgY6yZ4YKOJBo34KBBDy/KQ=;
        b=VarhaTE9ObGPDrjritguqKdViQIAW4KUZZcS5pmyE9nMc0CRRFeL/2gAaQK/B32SYQ
         f9rXJgqF31T7VL9mrJ3wuT9XM1noiT+bKvuFU4/TS+EDVeubcvkRUZOHZX2vgF9AN04u
         maqUxPVFBEslL3t0CjiIH6TBYDcKTNu4n5OkLdo4bDYHdOIvnNbxy1g+PQ99rj1p0auB
         elG0XyjTA7BOhdgM12gir8WuOVZxpsZKYIp5tzdMx1xsBh+c+V5ChFsIYBODAg9z/CLZ
         ih4EzriZJqXRl1oz6ekAMPtnO7LCgisEQK1g5kqpy+Wtvzl9qrsso6jAiQa0xY31APqL
         Z6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAj5aRV7DjVub+rWMi/CqgY6yZ4YKOJBo34KBBDy/KQ=;
        b=innud9g9YGiwEye0yPQpuGuLV6eLk1VhUevoVlmtg788uXTLvyAo5K2R0GXK1VpNq9
         WwXZtL7n8BO4p9K43paX7wokAZftMGU0msW+riAievdv8HzrvnXsRwfT2zIuYwge61wH
         MUQp2TZQrmpEW6dHD78ohCewjqSY1GFnHPvKaIvNPEHqDjVgPVDuL7isYr/aMqKEfM2s
         9ptX0neHqVo/rQhQXHWFi8iuIj9kXVYNgZLqFqVzfSxgDzQzkcaoe7A2r2Al33vplyPH
         NbMZqsSGy/z2rEAEpDCx4Iivt+QhfcjWeax4yt7rJ6/xZVU6qTpuOX3bKXv7ugtZVJhW
         d+KQ==
X-Gm-Message-State: AFqh2kr/PZBJP4Cf5OsGdz8VPM5K+D/FEzwCx2gfo8v3FC4WzodsroAv
        kH2sbgUIuaItmfGKfos0hS0=
X-Google-Smtp-Source: AMrXdXvSQMOWBrxqLX5D5zMvtKScuoWeBFaiWtAzBJzPb9Tb7i0dgyzJB0OglgHV1TzQb+HBzxMhLA==
X-Received: by 2002:a17:903:2781:b0:189:c3ef:c759 with SMTP id jw1-20020a170903278100b00189c3efc759mr9045200plb.68.1671762956997;
        Thu, 22 Dec 2022 18:35:56 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090341c900b0018f6900a183sm1177079ple.140.2022.12.22.18.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 18:35:55 -0800 (PST)
Date:   Fri, 23 Dec 2022 10:35:48 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
Message-ID: <Y6UUBJQI6tIwn9tH@Laptop-X1>
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org>
 <Y6QLz7pCnle0048z@Laptop-X1>
 <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 09:26:14AM -0700, David Ahern wrote:
> On 12/22/22 12:48 AM, Hangbin Liu wrote:
> > On Wed, Dec 21, 2022 at 05:28:17PM -0800, Jakub Kicinski wrote:
> >> On Wed, 21 Dec 2022 17:39:40 +0800 Hangbin Liu wrote:
> >>> +	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, NLMSG_ERROR, sizeof(*errmsg),
> >>> +			NLM_F_ACK_TLVS | NLM_F_CAPPED);
> >>> +	if (!nlh)
> >>> +		return -1;
> >>> +
> >>> +	errmsg = (struct nlmsgerr *)nlmsg_data(nlh);
> >>> +	errmsg->error = 0;
> >>> +	errmsg->msg = *n;
> >>> +
> >>> +	if (nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
> >>> +		return -1;
> >>> +
> >>> +	nlmsg_end(skb, nlh);
> >>
> >> I vote "no", notifications should not generate NLMSG_ERRORs.
> >> (BTW setting pid and seq on notifications is odd, no?)
> > 
> > I'm not sure if this error message should be counted to notifications generation.
> > The error message is generated as there is extack message, which is from
> > qdisc/filter adding/deleting.
> > 
> > Can't we multicast error message?
> > 
> > If we can't multicast the extack message via NLMSG_ERROR or NLMSG_DONE. I
> > think there is no other way to do it via netlink.
> > 
> 
> it is confusing as an API to send back information or debugging strings
> marked as an "error message."
> 

I think it's OK to send back information with error message. Based on rfc3549,

   An error code of zero indicates that the message is an ACK response.
   An ACK response message contains the original Netlink message header,
   which can be used to compare against (sent sequence numbers, etc).

I tried to do it on netlink_ack[1]. But Jakub pointed that the message ids
are not same families. So I moved it to net/sched.

I think the argue point is, can we multicast the error message?

[1] https://lore.kernel.org/all/Y4W9qEHzg5h9n%2Fod@Laptop-X1/

Thanks
Hangbin
