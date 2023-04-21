Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C00F6EAC44
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbjDUOG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbjDUOG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:06:27 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB49A6EB6
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:06:26 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-325f728402cso694075ab.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682085986; x=1684677986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMjWMaSEW6mkf9t9qOHzwnyrgkKOQHPv2y3YTFPPqyM=;
        b=tJmeXNZxdKlxJGhF34omz4S4PM0OWa0poYw47Ri+jYC2tlMEUauZo49XIhVO+n9Qy1
         h3KzCabs27kqck1/qnh054+4yp8egmp5Edo7Q/9z5jWF3AIH0vXciK3oJuCV0akerIaW
         aum8SV/bP6FCLNkdKbQhTaXNnUTZTYFqdlKZ7D9SFwVGGn+KLHh/d9RvVV+3v+SlulMZ
         j/1b0OC6c8ui31fGqP4EqxLFdZVtLYY8m3Fm3Dw1VC2u9qa29ONeRa4e2RAQIQItmw6j
         z7wc+EjFdJojUP1Uxtxb/2rynUipClUnpGu2c+VHPR4RjXEKyS3/u/7M5GZEADTLskkQ
         eBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682085986; x=1684677986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMjWMaSEW6mkf9t9qOHzwnyrgkKOQHPv2y3YTFPPqyM=;
        b=DLv+tTOWYQbk7ytTeI5e9Z8f6qlaAAVWNzjiHSlDaqBAPT9DYWwxWp+mJJUHXhRXEA
         sM1+IW0MQURXs6Y8/lILbwwW+k5Q+C7fQRJBW6ucxmWhQqktzYjv4qWpqlIwLxpfH6tg
         MfDx+Aj63k2Pr+rN8eYNLZ9YWCQZ1Pl3OL9RpoRxUY8nU0xipLwcJnZ6WQay2EHvYO7l
         p90d+6iuZdkNHPLGc7H/Oker4T0B0p1P8j/qa/5rtXUfPQtCW1EHsnP29dsgotAw4wi3
         2fB/arCipJkSfiTtdC80Sk3V/MWQq+z2qlSH0/xwuCWx6bIYWlb9QTqrK9AUzuxgYOlg
         5QBg==
X-Gm-Message-State: AAQBX9dC1cgMs/2bxhRlTQlp4O1TN9hbqP19sil9enUGISicTEjTmWvs
        75WNEhSgpY43wm/AwxR1T8PpjxDsTBZO9cbSiJRjRuTk91uiekkVjHc4bg==
X-Google-Smtp-Source: AKy350abMWeu4JU6ijH/otY7Abuj3g2lRbM2ri+QexU/YFMPcKrR6OFsg6FIXu2ICSF9dI8oY4EjPF6387taT6dVP+o=
X-Received: by 2002:a05:6e02:198c:b0:32a:9305:5d90 with SMTP id
 g12-20020a056e02198c00b0032a93055d90mr208858ilf.11.1682085986012; Fri, 21 Apr
 2023 07:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230421094357.1693410-1-edumazet@google.com> <20230421094357.1693410-6-edumazet@google.com>
 <d84e9f5056c4945cb4cfcc68c89986d3094b95b7.camel@redhat.com>
In-Reply-To: <d84e9f5056c4945cb4cfcc68c89986d3094b95b7.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Apr 2023 16:06:12 +0200
Message-ID: <CANn89i+94vKLZ9ijgf+vzVcoBV4fNo3z1aF_Djbr-kC65qxzZA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] net: optimize napi_threaded_poll() vs RPS/RFS
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 3:10=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> Hello,
>
> thank you for the extremely fast turnaround!
>
> On Fri, 2023-04-21 at 09:43 +0000, Eric Dumazet wrote:
> > We use napi_threaded_poll() in order to reduce our softirq dependency.
> >
> > We can add a followup of 821eba962d95 ("net: optimize napi_schedule_rps=
()")
> > to further remove the need of firing NET_RX_SOFTIRQ whenever
> > RPS/RFS are used.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/netdevice.h |  3 +++
> >  net/core/dev.c            | 12 ++++++++++--
> >  2 files changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index a6a3e9457d6cbc9fcbbde96b43b4b21878495403..08fbd4622ccf731daaee34a=
d99773d6dc2e82fa6 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3194,7 +3194,10 @@ struct softnet_data {
> >  #ifdef CONFIG_RPS
> >       struct softnet_data     *rps_ipi_list;
> >  #endif
> > +
> >       bool                    in_net_rx_action;
> > +     bool                    in_napi_threaded_poll;
>
> If I'm correct only one of the above 2 flags can be set to true at any
> give time. I'm wondering if could use a single flag (possibly with a
> rename - say 'in_napi_polling')?

Well, we can _not_ use the same flag, because we do not want to
accidentally enable
the part in ____napi_schedule()

We could use a bit mask with 2 bits, but I am not sure it will help readabi=
lity.
