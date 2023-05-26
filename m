Return-Path: <netdev+bounces-5812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C5E3712DDB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 21:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5385D1C2112A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:47:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BEA2A9C4;
	Fri, 26 May 2023 19:47:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5891B29115
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 19:47:47 +0000 (UTC)
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEC5DF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:47:45 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-bacf7060678so1969162276.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685130465; x=1687722465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUz3cYZJzxYpChJac/7E7ylhZT6Nv4qatri6Adv31ts=;
        b=nGEyT5uymfWQJUBAXIcnKOztcnh+nuA/ennn48fCHOEnED4St0CC/dOuSXWfnFHnau
         OYFzPg0TT6M2J/Lpui/uacLJNLWJIdkWkyIR6c+CkLnelBPOKHQgBEhG/z4CURSHN+k3
         eTNza7OJnInTM0DnCb0qGmgAHt4uQkBo3phHmfjrOlEDfrrUE0mH9ZOg6XyLZJaKTMpw
         cvKT1v4O5DATyNtP0YOuj6kvKb6Y98tIATVyFD+CCCrgtAhk/FqzjiZ2y6kBbsoKTwNy
         gJMEDUNYLsfNsX1i7r18sb2HVYDbcUUFcbsfRDFZK63jcxMkrOIAG/mG1IhCK+WYkyWL
         6wTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685130465; x=1687722465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUz3cYZJzxYpChJac/7E7ylhZT6Nv4qatri6Adv31ts=;
        b=cOJsoG1q5S6X2usBmaGfNMOEQ3D97c3DDlXZdXXkxV/kT0Nuh1uEmqbA0FxMbmufk0
         IT/e2qEnWZyTFw73NA19ntwdrGTq+OTFjUN46rcNvQvyp/yIUb749HiSdOqUsiC/hdUr
         1Jby4gvwk8Lbb+SQTwyrsrWVjsFC61lQLupesU1tdKB3WISjjpRM/BApsaBAwO6k7l2p
         udBTaKxCawjQrDA80QAnCf6iRGegjXz0B5FbvgQ4oMC3rO6+QOgr7V0ifyKGszC5MauL
         Jxjlrm13Nip4mdjNJEyW9fKeAseL5YeGAYUDTKLUeY3ythI8EFFg+cEhWVxn5YIYIMlQ
         0f1A==
X-Gm-Message-State: AC+VfDxUFp4Lg9Rwu0AZPYlkxIzefhauhmt21R/+8FxnlPi7deYIXd2K
	UB7c6PjVPXGyXpkHurjgEaqUla3HL6o4CTk+VUGfuQ==
X-Google-Smtp-Source: ACHHUZ4JH7SDDIfaBbEyxaE595kxzNqDoryzPH4uuMbFwu5yeZoTstauDgITfnvovwUAv+R6UqOtD4URMnbpHNYU4ak=
X-Received: by 2002:a25:5cb:0:b0:b9e:c516:6e32 with SMTP id
 194-20020a2505cb000000b00b9ec5166e32mr114111ybf.24.1685130465099; Fri, 26 May
 2023 12:47:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684887977.git.peilin.ye@bytedance.com> <429357af094297abbc45f47b8e606f11206df049.1684887977.git.peilin.ye@bytedance.com>
 <faaeb0b0-8538-9dfa-4c1e-8a225e3534f4@mojatatu.com> <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
In-Reply-To: <CAM0EoM=3iYmmLjnifx_FDcJfRbN31tRnCE0ZvqQs5xSBPzaqXQ@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 26 May 2023 15:47:33 -0400
Message-ID: <CAM0EoM=FS2arxv0__aQXF1a7ViJnM0hST=TL9dcnJpkf-ipjvA@mail.gmail.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Vlad Buslov <vladbu@mellanox.com>, 
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 8:20=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Wed, May 24, 2023 at 11:39=E2=80=AFAM Pedro Tammela <pctammela@mojatat=
u.com> wrote:
> >
> > On 23/05/2023 22:20, Peilin Ye wrote:
> > > From: Peilin Ye <peilin.ye@bytedance.com>

> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

I apologize i am going to take this back, lets please hold the series for n=
ow.

In pursuit for the effect on events, Pedro and I spent a few _hours_
chasing this - and regardless of the events, there are still
challenges with the concurrency issue. The current reproducer
unfortunately cant cause damage after patch 2, so really patch 6 was
not being tested. We hacked the repro to hit codepath patch 6 fixes.
We are not sure what the root cause is - but it certainly due to the
series. Peilin, Pedro will post the new repro.

cheers,
jamal

