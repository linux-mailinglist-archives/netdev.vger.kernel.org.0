Return-Path: <netdev+bounces-4799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 644C270E65A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28C0028147E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2797D21CFC;
	Tue, 23 May 2023 20:17:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B5E1F957
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:17:09 +0000 (UTC)
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC47129;
	Tue, 23 May 2023 13:17:08 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-75b2a2bf757so20143585a.2;
        Tue, 23 May 2023 13:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684873028; x=1687465028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m69+0U+vf8WBXQfiW8cb5lnrUt7WhgTHWMAX6k595F4=;
        b=VP0fHtjC3N4hCeuVqyg/C3oO7n9xQXxKL3dUNKvZ1gDMksuTVZyuxUuCYeoc/Gr0gS
         2KaPT1FqB22o2RpQSu1A7kSB72uDMvOAPxpfFH47lJ9Y9nlrRBS3/GuxrQb2rIVCs/Fs
         q64me5UewXpu75kHm56eGiV61mfeSEG/GHEscko6K9JD/i9NzzzjSyyST0GIc1cdhvRh
         ClJI2qEQ+N3eryZTLIlj1H6yt++fiiWlQHm/nroZCswRWTK7Nh3LUAzB8a92qaHMsWLN
         uK5F8hIxZzIYbiMspMC8L3p+J3+j7aaKSgT2jXWC0OFO8EgmjT2uJ2ip0eySyFrNfWoL
         qqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684873028; x=1687465028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m69+0U+vf8WBXQfiW8cb5lnrUt7WhgTHWMAX6k595F4=;
        b=A4LJOFtJtECbkFvmlwinYcRuft7wmOIKI5ZsdS1VO5zBJ+iVkhYTb/maI1cJZC7yaw
         i4zlhyBtYuN7uk9028Lm1Mt6nlRJvKIVb6bosY1Qx5JX+FfpZOHm+Ppn3m3jJbC4H+eq
         8OrN0/7Hd1jtiv/VpE0QEbrZgzLtgWFC5d3BCj8nI+YpuQ8wHXr7jwulNj/x4X8i45cH
         +qfYnFkLfcPMs9sIHPSeD8uDYeO34c+fIvQvXvBhcrf5RN2L42NmORUmbv+l70FQNtr0
         5OtunSUDG/masvARWBlzfNjHlVxp0aPwt36h+3IVjt1+PPbMIHJRbX43Ed0GlVnm+piI
         B54w==
X-Gm-Message-State: AC+VfDz8UBpExFhakninHGSOrGZIBLXSnYyRSd1nOoMcoOgqZLThPuEI
	vMDXuQhfxFCDBkTuBjh52A==
X-Google-Smtp-Source: ACHHUZ4JvW+edJ5rldUTq3rDNMQKfHeo7Pd4M1OGvKZP+IfR+c7XlRCuBkSO/rxjkLQ97mt2A5qM+g==
X-Received: by 2002:a37:a914:0:b0:75b:23a1:364b with SMTP id s20-20020a37a914000000b0075b23a1364bmr5512524qke.12.1684873027715;
        Tue, 23 May 2023 13:17:07 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:c32:b55:eaec:a556])
        by smtp.gmail.com with ESMTPSA id i28-20020a05620a145c00b00759169d0316sm2743370qkl.40.2023.05.23.13.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 13:17:07 -0700 (PDT)
Date: Tue, 23 May 2023 13:17:02 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Vlad Buslov <vladbu@mellanox.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v4 net 0/6] net/sched: Fixes for sch_ingress and
 sch_clsact
Message-ID: <ZG0fPks+1/RgwFC1@C02FL77VMD6R.googleapis.com>
References: <cover.1684825171.git.peilin.ye@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1684825171.git.peilin.ye@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 12:12:39AM -0700, Peilin Ye wrote:
> [1,2/6]: ingress and clsact Qdiscs should only be created under ffff:fff1
>   [3/6]: Under ffff:fff1, only create ingress and clsact Qdiscs (for now,
>          at least)
>   [4/6]: After creating ingress and clsact Qdiscs under ffff:fff1, do not
>          graft them again to anywhere else (e.g. as the inner Qdisc of a
>          TBF Qdisc)
>   [5/6]: Prepare for [6/6], do not reuse that for-loop in qdisc_graft()
>          for ingress and clsact Qdiscs
>   [6/6]: Fix use-after-free [a] in mini_qdisc_pair_swap()

In v5, I'll improve [6/6] according to Vlad's suggestion [a], and fix
[1,2/6] according to Pedro's report [b].

[a] https://lore.kernel.org/r/87sfbnxhg7.fsf@nvidia.com/
[b] https://lore.kernel.org/r/e462a91e-8bea-8b72-481c-4a36699e4149@mojatatu.com/

Thanks,
Peilin Ye


