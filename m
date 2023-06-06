Return-Path: <netdev+bounces-8554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D56F972486A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FEFF281048
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6746430B85;
	Tue,  6 Jun 2023 16:02:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C99637B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:02:03 +0000 (UTC)
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C787E4F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:01:59 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-5664b14966bso76329517b3.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 09:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686067318; x=1688659318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lF2UGEA9OrkpXye5dI96ZgQtY63NyK9cI7pFh0ko5gI=;
        b=3fZhuuShZmXH9aTBKu5VMEf5zlchzOlrEF8VKtlM4k+5vXkqLj+MhKffHkfh10Btl5
         5QmXifAjXi+9X5cb+YnLilHFbe9VhrMdTZ6bgvl+EPYxGOwkE8wb0q7UzxOrtLdULlH4
         3kPLuFxTiJ7ZTbUexBNyvYF/kOu0J7WQiPR+BHyraAsXkPBxaPVctAwflcCEY1BCdhTG
         JT+OJVavWQuYMhwbLGZy5WWqz3ALlC1cg8r0YibIRIYnH8j78Rxl8EjTaRISR2qyzJPg
         DhgqRm1ejSmmTChRkgTjYYBQLMqOuhb0YJY4+RInJYTD+02T3rL/wTf2bHUCyhPHQtu5
         P63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686067318; x=1688659318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lF2UGEA9OrkpXye5dI96ZgQtY63NyK9cI7pFh0ko5gI=;
        b=j/FHBCfrsMoZbLS69vkFEIldUDaJHvP63B4N9vn94/5CVMJUKwOVxhg4jv/wFFTDwf
         TyjPBokWhLQPaa9wIfdtJHV6qy5/bw++7BZsnFaW6opWF8B5FqsNOVR8Vt2sunJfvp6O
         hao6OTxfK6b+TI76bYN7uoTjtsUa+mS8knFkgyZq+xSOMllcCDDTwQmg4ZyqjtTCHVPw
         laMcIklh0icJ3OoLGsPQcrG9+IVj6BG/W8LlARfu/fNYiUrIPJK5wZ23FFP/c038GJpo
         WIdL3ZBKUHHyeKcwqndAa4pFu+9dCKI+0gA+c18VYOnTgSwtdVd4UH/dGuwt48D1m1tJ
         yIsQ==
X-Gm-Message-State: AC+VfDyd80zDKL9Ao3/8zHE9uujMqMpedHlxPoIVw2bGSaYcmIA0OLtb
	AW9rPpY41UQ6W31R1nShS6G1Tgc3aqGXqcJ/kaJvOA==
X-Google-Smtp-Source: ACHHUZ5bzvxdH/e2OcvNNOB0H3xPGdj2sLKDeMs6TlDgqMP5ta4ePGFx2oX5OHvj0PSfPRpJOa84Q6uXA0h0s02B4l4=
X-Received: by 2002:a0d:e88f:0:b0:565:d40b:f695 with SMTP id
 r137-20020a0de88f000000b00565d40bf695mr2995573ywe.48.1686067318256; Tue, 06
 Jun 2023 09:01:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606131304.4183359-1-edumazet@google.com> <ZH9PB79LUMXLZOPR@corigine.com>
In-Reply-To: <ZH9PB79LUMXLZOPR@corigine.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 6 Jun 2023 12:01:47 -0400
Message-ID: <CAM0EoMn1veKy2-qX5zcfbx3pcXhiVmBMTcV7JHv6jREuxgrFhw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_police: fix sparse errors in tcf_police_dump()
To: Simon Horman <simon.horman@corigine.com>
Cc: Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 11:21=E2=80=AFAM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Tue, Jun 06, 2023 at 01:13:04PM +0000, Eric Dumazet wrote:
> > Fixes following sparse errors:
> >
> > net/sched/act_police.c:360:28: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:362:45: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:362:45: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:368:28: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:370:45: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:370:45: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:376:45: warning: dereference of noderef expressi=
on
> > net/sched/act_police.c:376:45: warning: dereference of noderef expressi=
on
> >
> > Fixes: d1967e495a8d ("net_sched: act_police: add 2 new attributes to su=
pport police 64bit rate and peakrate")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

Trivial comment: Eric, for completion, does it make sense to also convert
opt.action =3D police->tcf_action to opt.action =3D p->tcf_action;
and moving it after p =3D rcu_dereference_protected()?


cheers,
jamal

