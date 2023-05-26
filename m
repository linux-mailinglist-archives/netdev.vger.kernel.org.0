Return-Path: <netdev+bounces-5673-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F92712672
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4B502816B3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:19:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63241171B5;
	Fri, 26 May 2023 12:19:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58947742DE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:19:45 +0000 (UTC)
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57C0116
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:19:43 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-bad1ae90c2eso624210276.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685103583; x=1687695583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHsdIxAYeMANZULb6GLWJmQC7c45qZjIT81elj1fddI=;
        b=lSJYGnqeQY7cNwiJUUTnU31YRBaYTiGEAM5UbYyrnHolLQt+Z9wiJH08UyUunhr38K
         1XO2+rS24yyFIv0efH1UnT+Ma8A5UB5ttQhwqoPodZEeLO9fJFq6AohUXp7/5HzvLnJq
         OIeuNMtgdyCng6SAjiFmDrOfKUu0Aq+FEF/VPys5BwuJoogGjgfl1WpVUl6OzwsEqEYw
         tdLi51TSe1RKUup5yvobDkGwWBrkP4Gb0tXRaYGLbXzEzFN96Q/p4CLl/yeZ7/ziSJnI
         5ZIIDLmg5NRzqAoO74SANVIhACpt34SUt9eEa08lJhxmisg0p3DfbesRIZE8TfEKL1Yq
         kmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685103583; x=1687695583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jHsdIxAYeMANZULb6GLWJmQC7c45qZjIT81elj1fddI=;
        b=Hw1lOsIGR5+zsmG1MfXcLk/Zn1r3fyAgg2AFDUIKy4a0/w+9D02x2whwjeGWtszgvT
         zW4jPjY94/4N4xfHRjLpNSLp5kPW8mCOdxmHVfhjN1U7xPHLLE7jW5YWiHV2sEMldGee
         1waewjWaUp8YZiJg5DfGfdnp55ELTQKBVOwRTB6HagowqccABn53O+iQr7SGM81yWcmj
         gU0cQglOSeWbtULjPU05EOI/BmjM4xTxcINXzAJUcTM+xZlGguszmiG5X47NVgCcAxgt
         hzStNErcS6+zoJReHlGXBF6n58bo7Rz5VMn8kgjT7wKSGktVx8reEcyslBZgF8CP+Bfx
         Mcig==
X-Gm-Message-State: AC+VfDwiv+qUY1vl5d/7FAUJvSYkTNtkma7PT0/Tu0On2U8VPM19fBuj
	SpPBRD2Q09pvaJrtti51P6DB4rZB9VRF42quaiUR9w==
X-Google-Smtp-Source: ACHHUZ6TR8aeEsFNfAjEOuHAuaWt7JWI/7ObSKbm04REWHMNhaCJaos0b7KfEN3AtBAAwszyMAqtvmTJQixwwbC2zu0=
X-Received: by 2002:a25:cbd3:0:b0:ba8:8162:2538 with SMTP id
 b202-20020a25cbd3000000b00ba881622538mr1640458ybg.42.1685103583132; Fri, 26
 May 2023 05:19:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684887977.git.peilin.ye@bytedance.com> <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com> <CAM0EoM=T_p_-zRiPDPj2r9aX0BZ5Vtb5ugkNQ08Q+NrTWB+Kpg@mail.gmail.com>
 <c536fcd795f74016928469be16fe21df8079a129.camel@redhat.com>
In-Reply-To: <c536fcd795f74016928469be16fe21df8079a129.camel@redhat.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 26 May 2023 08:19:32 -0400
Message-ID: <CAM0EoMm5R1qmqz+Pn2_Mawur0_PK070p2zw4Y+EqDwYNF2A6=A@mail.gmail.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Tammela <pctammela@mojatatu.com>, Peilin Ye <yepeilin.cs@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Jiri Pirko <jiri@resnulli.us>, Peilin Ye <peilin.ye@bytedance.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Vlad Buslov <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 5:25=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Wed, 2023-05-24 at 12:09 -0400, Jamal Hadi Salim wrote:
> > When you have a moment - could you run tc monitor in parallel to the
> > reproducer and double check it generates the correct events...
>
> FTR, I'll wait a bit to apply this series, to allow for the above
> tests. Unless someone will scream very loudly very soon, it's not going
> to enter today's PR. Since the addressed issue is an ancient one, it
> should not a problem, I hope.

Sorry I do not mean to hold this back - I think we should have applied
V1 then worried about making things better.  We can worry about events
after.
So Acking this.

cheers,
jamal

> Cheers,
>
> Paolo
>

