Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37106CCD3F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjC1Wcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC1Wce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:32:34 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3461BD8
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:32:33 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id p15so17089694ybl.9
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 15:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680042752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=peo925/Bu/JDhge6kDkRqkL/eVUqaV8Qr5xFLQrh6rw=;
        b=vN4j4T/nd1xnmd5rCeLePRUTlCSil31FSjcB2dw9bAIH1MrD68JZZFBaiwYckuX2Sz
         wtolA78RvBA+Lp8eCivBVkhuOPwAxR09U42Hs53eVgNzOlX/KLK7uUPd1IPFqG3Q4IgU
         qxQrIZ6Db1VD1oc57doQ643zOvkIUdV7/bGoOSG+GQaxp3lvVf7uYJEPH/mOV5534ipe
         kWJQW3DRibIdBkpqT2MQYa/1R6QVBd5XFp7PRS+wRKUws1u3qGbkwark/C7Mhvb1Z+oC
         rk1SotQAz1wKiZ6UwOD61hSiBTZs8LElycrhf6JGaJ2hRW1oSMXj57lYiBiKVzYShlwl
         A8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680042752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=peo925/Bu/JDhge6kDkRqkL/eVUqaV8Qr5xFLQrh6rw=;
        b=JwVrmJ4boP0tQIAm0hwuocQlKqV7HZ3dJDZIYXcaH+CozfXe20JVy//DN8CU0pJUh7
         Dw6MrDyux9OLH/SzTA95XySXe8XCblqXhMhiWxz9NzVCMgJNt1vCsst+G6wPQNsqAhdX
         R/DzVtccOLYFI894nA/DxRTTkdv7dbgEbeSMm7Qk48nsq0cStF48rnWyzwqO8wNWjiBj
         VWs2Vf6AK0X982XxZLNzCq9nunas09IWD6LRc+j/PvVaEUX4GE7giPnK/FFcLQoCEJQw
         KahKSMwHLm4wKGWAmfjKbvXydTL9H1Pex5JJ3UlbMjDEBmnXIZIQUs3o8isJZ8318aWB
         9O0w==
X-Gm-Message-State: AAQBX9exEihc0+HKarxymSS6Rb3PvMSSi+/hIKIw2kGFE6yYkQf6vW4z
        wQ9dADC72dACi3+UfqJVc0tLB6fq5+nJPfBToLShNg==
X-Google-Smtp-Source: AKy350YS4gB1IsLYQFkysoHykNRRwwZBekztkR9bUddNTiAW4M3DRuCo/LFUOJMq9Og1uPzbJdkNxLrQs5VDlRD9OLw=
X-Received: by 2002:a05:6902:168d:b0:b6d:1483:bc18 with SMTP id
 bx13-20020a056902168d00b00b6d1483bc18mr10796891ybb.7.1680042752498; Tue, 28
 Mar 2023 15:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680021219.git.dcaratti@redhat.com> <579a1d30c2d8b417dcc19784cc27b87bab631b27.1680021219.git.dcaratti@redhat.com>
In-Reply-To: <579a1d30c2d8b417dcc19784cc27b87bab631b27.1680021219.git.dcaratti@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 28 Mar 2023 18:32:21 -0400
Message-ID: <CAM0EoMk0aUQ3jMShOuUqzNh-h+Mu5Qf8R26x5BtPK9dW=oDPpw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] net/sched: act_tunnel_key: add support
 for "don't fragment"
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Try 2 (some silly spam filter blocked earlier email)

On Tue, Mar 28, 2023 at 12:45=E2=80=AFPM Davide Caratti <dcaratti@redhat.co=
m> wrote:
>
> extend "act_tunnel_key" to allow specifying TUNNEL_DONT_FRAGMENT.
>
> Suggested-by: Ilya Maximets <i.maximets@ovn.org>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>


Acked-by: Jamal  Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

>
> ---
>  include/uapi/linux/tc_act/tc_tunnel_key.h | 1 +
>  net/sched/act_tunnel_key.c                | 5 +++++
>  2 files changed, 6 insertions(+)
>
> diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/lin=
ux/tc_act/tc_tunnel_key.h
> index 49ad4033951b..37c6f612f161 100644
> --- a/include/uapi/linux/tc_act/tc_tunnel_key.h
> +++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
> @@ -34,6 +34,7 @@ enum {
>                                          */
>         TCA_TUNNEL_KEY_ENC_TOS,         /* u8 */
>         TCA_TUNNEL_KEY_ENC_TTL,         /* u8 */
> +       TCA_TUNNEL_KEY_NO_FRAG,         /* flag */
>         __TCA_TUNNEL_KEY_MAX,
>  };
>
> diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
> index 2d12d2626415..0c8aa7e686ea 100644
> --- a/net/sched/act_tunnel_key.c
> +++ b/net/sched/act_tunnel_key.c
> @@ -420,6 +420,9 @@ static int tunnel_key_init(struct net *net, struct nl=
attr *nla,
>                     nla_get_u8(tb[TCA_TUNNEL_KEY_NO_CSUM]))
>                         flags &=3D ~TUNNEL_CSUM;
>
> +               if (nla_get_flag(tb[TCA_TUNNEL_KEY_NO_FRAG]))
> +                       flags |=3D TUNNEL_DONT_FRAGMENT;
> +
>                 if (tb[TCA_TUNNEL_KEY_ENC_DST_PORT])
>                         dst_port =3D nla_get_be16(tb[TCA_TUNNEL_KEY_ENC_D=
ST_PORT]);
>
> @@ -747,6 +750,8 @@ static int tunnel_key_dump(struct sk_buff *skb, struc=
t tc_action *a,
>                                    key->tp_dst)) ||
>                     nla_put_u8(skb, TCA_TUNNEL_KEY_NO_CSUM,
>                                !(key->tun_flags & TUNNEL_CSUM)) ||
> +                   ((key->tun_flags & TUNNEL_DONT_FRAGMENT) &&
> +                    nla_put_flag(skb, TCA_TUNNEL_KEY_NO_FRAG)) ||
>                     tunnel_key_opts_dump(skb, info))
>                         goto nla_put_failure;
>
> --
> 2.39.2
>
