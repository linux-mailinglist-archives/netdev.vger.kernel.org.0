Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C29623BDA
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 07:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiKJG3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 01:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKJG3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 01:29:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC15111144
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 22:29:35 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j12so706778plj.5
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 22:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/TgocPEGFSpyDzacYiG4y3r4jw8YN35cvTTQxDEvvw=;
        b=aFzSZe2+9HE8hfUCNdUc9tN7V/EbCJ5TeyAMV038xM23Ru/DW72MZkds93Oi7XjiRA
         vb3fzckNV2dSrSs1UXfuRT4NT4kLw/x72ABBuIltnTFr7nhtNopZjTGawtlE5DTP5mLc
         wPzM4qTzFU2t05iKUgQqjyaLWO7BeJo7HiqsnzD467uKSA1RBTPH54G2AseamJEn/0dh
         f+8tjw4vq2szfN/inr869o4FG9RGOAtjhe1WUdRI07GBHGJsnyvUXM656HyXeC4NHsYS
         hYc+xdJAQb06tyipPgnoWoNtXvqwpkf4hSQjL1fgeXA35YbrURZsshRUD9d46EyioN0H
         zHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/TgocPEGFSpyDzacYiG4y3r4jw8YN35cvTTQxDEvvw=;
        b=pd3iER0Mq3xC2vrHNdfMfccnhgq2QcKJeX2XKx63hkK3dKfzJWiBQliY1oHh9Wjrvt
         DuM04wy59u1Pp37gVJ2uqC3Pvr8fXT5gKZQeZ6bxr6YGPWWh2le2rn0Mox/iIikPdzsV
         uM81sneCPId7h8cxz+4oQGjhumjxpr6bISqTa7lXqvWAt6t8xx8Lqva2CLkVum5d22cq
         t3Uuu2/qck5TuhXmdkmSovpYBd0zKX9TYevfJfnEcjmUNyaWirHSBAAEg/nXYcg9N57w
         Gs0zc4ygxAktdx5UVOhi3Mv8YBrwZtHEcDb5lrvVfBzHumCts5/2sJRR0ty2wOSv/Krx
         ijaw==
X-Gm-Message-State: ACrzQf2FDoUkMMrxP2vgYdi516pxMz06C1ZEGTb2XHZzEE/AS2ZGacVJ
        bw2gwi2+okvT+18n26iA5R8=
X-Google-Smtp-Source: AMsMyM6zjLnwhkDnfzVUuiKrIWTRwSXlN7yp7zcMcHUVxqGMzztoQMJJvUUJvR9S1jJvSo1zepLaug==
X-Received: by 2002:a17:90a:480b:b0:213:82b3:1fe7 with SMTP id a11-20020a17090a480b00b0021382b31fe7mr64996211pjh.34.1668061775379;
        Wed, 09 Nov 2022 22:29:35 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w7-20020a634747000000b0042b5095b7b4sm8477216pgk.5.2022.11.09.22.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 22:29:34 -0800 (PST)
Date:   Thu, 10 Nov 2022 14:29:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <Y2yaSQUC7zdL5V1Y@Laptop-X1>
References: <Yzillil1skRfQO+C@t14s.localdomain>
 <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
 <Y1kEtovIpgclICO3@Laptop-X1>
 <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
 <20221102163646.131a3910@kernel.org>
 <Y2odOlWlonu1juWZ@Laptop-X1>
 <20221108105544.65e728ad@kernel.org>
 <Y2uUsmVu6pKuHnBr@Laptop-X1>
 <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
 <20221109182053.05ca08b8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109182053.05ca08b8@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 06:20:53PM -0800, Jakub Kicinski wrote:
> Unless we want to create a separate netlink multicast channel for 
> just ext acks of a family. That's fine by me, I guess. I'm mostly
> objecting to pretending notifications are multi-msg just to reuse
> NLMSG_DONE, and forcing all notification listeners to deal with it.

Hi Jakub,

Actually I'm a little curious about how should we use NLMSG_DONE.
Does a normal nlmsg(with NLM_F_MULTI flag) + a NLMSG_DONE msg illegal?
Should we need at least  2 nlmsgs + a NLMSG_DONE message.

Because when I wrote this patch, I saw some functions, like
team_nl_send_options_get(), team_nl_send_port_list_get() in team driver,
devlink_dpipe_tables_fill() in netlink.c, even netlink_dump_done(), could
*possible* only have 1 nlmsg + 1 NLMSG_DONE message.

In my understand, we can send only 1 nlmsg without NLM_F_MULTI flag. But if
there is 1 nlmsg + 1 NLMSG_DONE message. It should be considered as multi
message, and the first nlmsg need to add NLM_F_MULTI flag. Maybe there is
a little abuse of using NLMSG_DONE, but should be legal.

What do you think? Did I miss something?

Thanks
Hangbin
