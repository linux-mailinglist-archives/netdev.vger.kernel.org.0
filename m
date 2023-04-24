Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986BD6ED404
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDXR73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXR72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:59:28 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C286193
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:59:27 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-b99e10f1c4cso466181276.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682359167; x=1684951167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNseKmFPhAPMzI1fZJXPkf2S/EZ/leAjrK8BAbXzzpY=;
        b=S1YsVL26ziI9kqT+BcFpZcw1ekYU6FaQQiugMmo0Fm0pQb8LVmszNVVajBcKZ3Tfft
         1f+poy+0w77lvtVW/3kxdKM8AfYIWmA6F/2EZvnNXTCNz2YTZkwaR72qmyfcgLROGyx7
         ylMgxriWg6n/B80xSgCUf4p8nttmxJlOPBQj+RY77vVQdvKKnFfzD8se4Xg8i4IIGyNc
         bz6HmJ5agevNluPbtOUxjm5mhRAH/kA/gbwkHm7y3nHmWREJiBwGWaamrE+NiTAPpX29
         hLRrOXjPqVhsHxeVRUlkamvEGNX15AOvdayefr/+SQzY8qhI1l0YMSS8e5wVOJ4jGooA
         sffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682359167; x=1684951167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNseKmFPhAPMzI1fZJXPkf2S/EZ/leAjrK8BAbXzzpY=;
        b=SSiiZC5NrUj7hLsAu15hz3Yr0qBPRsA57BNRbcKjfbTu4czgHrPvZW8A2esBvk/vj9
         ZMQi7U+NbTDXsvC4OvjtsyFEfIG9Rthq1zp0fKbgB61QnTNC9hQ25ndH+IEOPS6I45sT
         19U+dDZ8WwTEDTqwpzkwmKERk0gLmBm8nUeppV49itNnE/pJlblOwk9ldnp2gJOTiUGW
         DT8a9QorKcD0MztdGsorFl01tQQwfw868aQpyS9SfC+iEf+/w0l9a8p9YXp+ZMMEj3k4
         Z8JZhj4+bSXWTPR/77PXUosa+BGVfS+FBZ5iuiEOUIQJ8DxjtK1bfXTIMzb2vVGXUAtS
         30nA==
X-Gm-Message-State: AAQBX9cotZJVg7lr/uGoHwOa1w9mAMuLhnfPbYa6PlnAczD1BWQOpe6x
        iE2C78x+8hnJedIg6scZTuWWC/3TzzzuxeCiIYYtxA==
X-Google-Smtp-Source: AKy350auCruekp+RCQhdIQuQVB3yWZZCy5mC2Oh+fA3TlXlW41LaMBo5RMFAveR1azh2pUnHXkINYvaaShUzVgbOfgs=
X-Received: by 2002:a25:37c8:0:b0:b8f:31c2:7b09 with SMTP id
 e191-20020a2537c8000000b00b8f31c27b09mr10277290yba.54.1682359166671; Mon, 24
 Apr 2023 10:59:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230424170832.549298-1-victor@mojatatu.com> <20230424173602.GA27649@unreal>
 <20230424104408.63ba1159@hermes.local>
In-Reply-To: <20230424104408.63ba1159@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 24 Apr 2023 13:59:15 -0400
Message-ID: <CAM0EoMnM-s4M4HFpK1MVr+ey6PkU=uzwYsUipc1zBA5RPhzt-A@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 1:44=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 24 Apr 2023 20:36:02 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
>
> > > There are cases where the device is adminstratively UP, but operation=
ally
> > > down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 2=
5Gbps)
> > > who's cable was pulled out, here is its ip link output:
> > >
> > > 5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq stat=
e DOWN mode DEFAULT group default qlen 1000
> > >     link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
> > >     altname enp179s0f1np1
> > >
> > > As you can see, it's administratively UP but operationally down.
> > > In this case, sending a packet to this port caused a nasty kernel han=
g (so
> > > nasty that we were unable to capture it). Aborting a transmit based o=
n
> > > operational status (in addition to administrative status) fixes the i=
ssue.
> > >
>
> Then fix the driver. It shouldn't hang.
> Other drivers just drop packets if link is down.


We didnt do extensive testing of drivers but consider this a safeguard
against buggy driver (its a huge process upgrading drivers in some
environments). It may even make sense to move this to dev_queue_xmit()
i.e the arguement is: why is the core sending a packet to hardware
that has link down to begin with? BTW, I believe the bridge behaves
this way ...

cheers,
jamal
