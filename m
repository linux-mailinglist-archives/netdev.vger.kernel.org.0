Return-Path: <netdev+bounces-6825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB90718584
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6DBB1C20EA4
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C86316423;
	Wed, 31 May 2023 15:03:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7FAC8FF
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:03:56 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C576134
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:03:50 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso85645e9.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685545429; x=1688137429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9hQYHnZva8RSd0ItZzDKoX0R76IANPL/LygsCiCcfM=;
        b=5eyGCrFRA0SL7FzVYaBQBJ2c8rAMnCHGbZbxofJSdWYn2RGso3EZe9+EkK/66lPwO6
         Iqkjxs1Z/wsp/BJMjYgtx7qNFvjln+N+gOdsgizXyHLaMvugYES3hJhblFygpuNU3dBK
         /rkufjynWgFactLBpWmY1gI2TdNk5gBTjLL1IcIFvlTBqQx1x7UhpM3ZgDbiWyCc+umi
         8mT7thH79odxYbf+z7xCjuY8T+f0NRrw+w4Yf0uEp2Z9YXaRoiq533RL8cCe+FwjH5Gd
         kko7M2E/dnpLMQhNoYP4itS4DOXOBeGc2UE44rlrN49637vqEg+778LGtVyqQds6j7tb
         dCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685545429; x=1688137429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9hQYHnZva8RSd0ItZzDKoX0R76IANPL/LygsCiCcfM=;
        b=TWproatnHDPPGWIjn5rYUulafe/efw7TqJYFQyA9t5F7VHpMy0hShNA4rbRIwPKtHN
         zXD5W4CMSJurF5Cz2V1L3iTl16sWMDTibkZjzNBCEdG6IkgGhudWWFV+cXqy43u0rAIU
         2FOZkwuZ1fxh9CEIP6t4h31Zcnji9w7uyi/vMHfg1S1JA5ShHCDWBeXfTMU97VIzHFfE
         cjYsaPqFrQWkAouqgnVfsEen9VldJeee19zOmscj7UuknFKZhNK23lUbR9coe98rIpfp
         0af2OWz6lu25Eoah8+VZi7QAIwcTatAcfy1inXLfcMT1WlUW0t6BB6usdpYCAxrZ8BfM
         6G8g==
X-Gm-Message-State: AC+VfDxlvNL/sCu1GMga3Nx3LV/oi+OM1HR3I/1HpfisC8k7QsXXczyr
	r4ToMYWo5oILTFg4IvREFu6snu6g22DkNiQf+Ya6kA==
X-Google-Smtp-Source: ACHHUZ79rtAYPrPj9pBckviOihnUQ6c6rbV3UKc5JhuaJRnXqnkN385r39yywDbzp8MbSz7+BQtk28q2498nTMd+/Y4=
X-Received: by 2002:a05:600c:4f8d:b0:3f1:9a3d:4f7f with SMTP id
 n13-20020a05600c4f8d00b003f19a3d4f7fmr132466wmq.1.1685545428875; Wed, 31 May
 2023 08:03:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531141556.1637341-1-lee@kernel.org>
In-Reply-To: <20230531141556.1637341-1-lee@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 17:03:37 +0200
Message-ID: <CANn89iJw2N9EbF+Fm8KCPMvo-25ONwba+3PUr8L2ktZC1Z3uLw@mail.gmail.com>
Subject: Re: [PATCH 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
To: Lee Jones <lee@kernel.org>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 4:16=E2=80=AFPM Lee Jones <lee@kernel.org> wrote:
>
> In the event of a failure in tcf_change_indev(), u32_set_parms() will
> immediately return without decrementing the recently incremented
> reference counter.  If this happens enough times, the counter will
> rollover and the reference freed, leading to a double free which can be
> used to do 'bad things'.
>
> Cc: stable@kernel.org # v4.14+

Please add a Fixes: tag.

> Signed-off-by: Lee Jones <lee@kernel.org>
> ---
>  net/sched/cls_u32.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4e2e269f121f8..fad61ca5e90bf 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -762,8 +762,11 @@ static int u32_set_parms(struct net *net, struct tcf=
_proto *tp,
>         if (tb[TCA_U32_INDEV]) {
>                 int ret;
>                 ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], extack);

This call should probably be done earlier in the function, next to
tcf_exts_validate_ex()

Otherwise we might ask why the tcf_bind_filter() does not need to be undone=
.

Something like:

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4e2e269f121f8a301368b9783753e055f5af6a4e..ac957ff2216ae18bcabdd3af3b0=
e127447ef8f91
100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -718,13 +718,18 @@ static int u32_set_parms(struct net *net, struct
tcf_proto *tp,
                         struct nlattr *est, u32 flags, u32 fl_flags,
                         struct netlink_ext_ack *extack)
 {
-       int err;
+       int err, ifindex =3D -1;

        err =3D tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
                                   fl_flags, extack);
        if (err < 0)
                return err;

+       if (tb[TCA_U32_INDEV]) {
+               ifindex =3D tcf_change_indev(net, tb[TCA_U32_INDEV], extack=
);
+               if (ifindex < 0)
+                       return -EINVAL;
+       }
        if (tb[TCA_U32_LINK]) {
                u32 handle =3D nla_get_u32(tb[TCA_U32_LINK]);
                struct tc_u_hnode *ht_down =3D NULL, *ht_old;
@@ -759,13 +764,9 @@ static int u32_set_parms(struct net *net, struct
tcf_proto *tp,
                tcf_bind_filter(tp, &n->res, base);
        }

-       if (tb[TCA_U32_INDEV]) {
-               int ret;
-               ret =3D tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
-               if (ret < 0)
-                       return -EINVAL;
-               n->ifindex =3D ret;
-       }
+       if (ifindex >=3D 0)
+               n->ifindex =3D ifindex;
+
        return 0;
 }

