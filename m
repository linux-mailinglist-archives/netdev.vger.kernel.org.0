Return-Path: <netdev+bounces-5868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D65713392
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 11:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 209121C21037
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 09:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654EF20FB;
	Sat, 27 May 2023 09:03:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55446539F
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 09:03:56 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14187E3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:03:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ac65ab7432so83565ad.0
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 02:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685178234; x=1687770234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/RkbwQ/COCkahnxbPBIR4kgBWslvmVMwZ3GtAJc4tM=;
        b=2pOGnbV5wUv7hj6HVZDd7NzSB+OgWLd5s94mQ3GocF9egefXRROjqtULUK1GpugWB0
         G5vVr67SzQLXeRTC+8xifZlEPjZg/R5KvhxavdZwPhRlJpZN1YTfD4AnfzcryszPeVf5
         5YX0Lh3jMEoz3vyJtNXFN8RV93HpVV6M0wyeEwnMvStjspekI/wL/nzcmLWQ2N0cKQ/f
         3eKS+xz8PMCJRmBlpIW4CLRv39COvxZZ6WDKcLPDL9HzTEsD8vvHGgK3Pj+GW9FYLyLj
         ZjhvSm8C8/CW8HEAFX+qOhFCGELTEPKzXSQMv/k7f4WkvzF6/sv63dtKxlMVBksEMDpV
         XgXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685178234; x=1687770234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/RkbwQ/COCkahnxbPBIR4kgBWslvmVMwZ3GtAJc4tM=;
        b=cdc1toO1gxTeSlfhGhafUeMdzDEPlyvi3qqAwJ5kevv4Ma/636wrTDPAAc22SuRlkD
         wlWg9ZFKDFH7fDjTn16+Dw73EiPo+cUl8Kll629q5FGHreck8MuJx6vA07E4qvr/oLI+
         n5Xo/3UI978kXWmrBLQSEfMRa+GuWLwv3PwCBBiaebDoBYIJQDB5XoLrGal8g1Gh3Ul0
         UbW4MxvT4OLUrN+3xphLsqIut0YzEKWO8LRywvKNf4cKemTXRMCLQ0h0UKpPIcO2LdEW
         /AQsryOnogSyXo5QfP7a4oARVyW2D/F3jYibgckcuaAoezYrSkolA9ZMQvsQ4m66ZaSy
         8FYA==
X-Gm-Message-State: AC+VfDxtNKBXnM/m434VlysPutzA6E0A+03qk3BYFwW77EoISGYP5KG4
	V2IaMYHoVl4LBlgxi3UKCTrEFRGWnIpLU2UMW8qMzw==
X-Google-Smtp-Source: ACHHUZ4fj2deluJxay2xM0U+t7sr8Aqbe6eDGJPZrNFbrm+u2NSyVT7uCc7NhoekQPTYrMW3ZX0PmN6Qn62M2b0VnJE=
X-Received: by 2002:a17:902:e5c8:b0:1a9:8907:ae56 with SMTP id
 u8-20020a170902e5c800b001a98907ae56mr137140plf.0.1685178234254; Sat, 27 May
 2023 02:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230527040317.68247-1-cambda@linux.alibaba.com>
In-Reply-To: <20230527040317.68247-1-cambda@linux.alibaba.com>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 27 May 2023 11:03:43 +0200
Message-ID: <CANn89iLHO7Cma9kdjVTkAy8Z3QvdG-8U4=ob=TSofA5nojWV+w@mail.gmail.com>
Subject: Re: [PATCH net v3] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Jason Xing <kerneljasonxing@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 6:04=E2=80=AFAM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
> This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> it's zero is probably a bug.
>
> With this change, getting TCP_MAXSEG before connecting will return
> default MSS normally, and return user_mss if user_mss is set.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=
=3D3u+UyLBmGmifHA@mail.gmail.com/#t
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> Link: https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92F6=
@linux.alibaba.com/
> Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

