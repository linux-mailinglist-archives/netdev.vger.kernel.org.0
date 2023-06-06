Return-Path: <netdev+bounces-8575-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 158E17249B9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7414F1C20AEF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DAD21ED47;
	Tue,  6 Jun 2023 17:04:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221891ED3C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:04:30 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC8610C2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:04:29 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-33be5dbb90cso19039505ab.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 10:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686071069; x=1688663069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nJNG+x0MFjTDEXn5A3EugCfQjbbRms9q8telbbG+h8=;
        b=SZEeTe/NH65tWeBqAbJ4jnAYF5PWFy5HjVF+a90yq0zMmZY+YDRbSpxlVnRT8zQ0HO
         vKR8+zeq1mmlm2T7E8GtsKke5ruGmFwlT7D07TMIN9ZIn388Pm/lIKiiTA4AtIjnh9hD
         9ZVSo8Ui+JybBNKGWxZ0jfWbh3qpJV3ItgVYmOith7DrNekO7CFCTQ/sBm+nvoVyNpWN
         SWAjAWcTVSrtdmZ5623RXb3GnrH2YZo1I0ZpImL5qPfgaYThMfdiD5NH+DRXjcfPduKd
         au+0dxOV+49gxDY1sgm1/nBQxTnZmIq5NbJTEYPqoNDp4zZFPC4rzOB6Nk76Z9XHdbL4
         zqeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686071069; x=1688663069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nJNG+x0MFjTDEXn5A3EugCfQjbbRms9q8telbbG+h8=;
        b=JTqKEaHtZHiZYebcfL8QEb5gFKKMUzXauOR881tlTTcAz9kpGIuMSa6YJeL+577CKt
         G1hfEi6R3Ho8FcO3EWJbq42BqFK5qvKcEj7rxtAUiEXT1RswW9aN5yrXbyGXpJTT7klo
         VK0Qgx55qBh6O+c9yALrme+YK07xqbg2zY+BWKoXnoBFRXJS47BPEZTDLLGbOqPGNyYX
         kGPHmAr9sxV996BdEtFQB/oNH9T2uZXyTySNnN1XyNpLMmw+Fm0cOdOT7s/FrVTQW1gM
         QyEK7p9IkG6NrMx8vFla3DDy6pYiLg+oEY2hI40TuJ4vkzMOMO4rliHIQ4Zd92bKlQ1v
         +7Ng==
X-Gm-Message-State: AC+VfDzSEL0mj0pLDasQMiQoxmy3+GTZllOFt6D7J8GpPtpN77oq1J4E
	BgJf1HKLxORdyL+00rTqnCKdipNvwm86DQawJxmXnw==
X-Google-Smtp-Source: ACHHUZ54tKrgB0GX1q3kcDMh2FbyMewEMVVmfuofzdEHm4UzM3sGW1jJRTETl67HxMrJImg6BjtS5BuUTMRCq6VmRPU=
X-Received: by 2002:a92:2809:0:b0:33b:1635:359f with SMTP id
 l9-20020a922809000000b0033b1635359fmr1860547ilf.22.1686071069059; Tue, 06 Jun
 2023 10:04:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-3-jhs@mojatatu.com>
 <20230605103949.3317f1ed@kernel.org>
In-Reply-To: <20230605103949.3317f1ed@kernel.org>
From: Jamal Hadi Salim <hadi@mojatatu.com>
Date: Tue, 6 Jun 2023 13:04:18 -0400
Message-ID: <CAAFAkD9pU0DemGSOBcFoqJWkmvt4e6TLsDM0zzV+yaUY_m-MHg@mail.gmail.com>
Subject: Re: [p4tc-discussions] Re: [PATCH RFC v2 net-next 03/28] net/sched:
 act_api: increase TCA_ID_MAX
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org, deb.chatterjee@intel.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, Mahesh.Shirshyad@amd.com, 
	Vipin.Jain@amd.com, tomasz.osinski@intel.com, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 5:19=E2=80=AFPM Jakub Kicinski via p4tc-discussions
<p4tc-discussions@netdevconf.info> wrote:
>
> On Wed, 17 May 2023 07:02:07 -0400 Jamal Hadi Salim wrote:
> > Increase TCA_ID_MAX from 255 to 1023
> >
> > Given P4TC dynamic actions required new IDs (dynamically) and 30 of tho=
se are
> > already taken by the standard actions (such as gact, mirred and ife) we=
 are left
> > with 225 actions to create, which seems like a small number.
>
> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.=
h
> > index 5b66df3ec332..337411949ad0 100644
> > --- a/include/uapi/linux/pkt_cls.h
> > +++ b/include/uapi/linux/pkt_cls.h
> > @@ -140,9 +140,9 @@ enum tca_id {
> >       TCA_ID_MPLS,
> >       TCA_ID_CT,
> >       TCA_ID_GATE,
> > -     TCA_ID_DYN,
> > +     TCA_ID_DYN =3D 256,
> >       /* other actions go here */
> > -     __TCA_ID_MAX =3D 255
> > +     __TCA_ID_MAX =3D 1023
> >  };
> >
> >  #define TCA_ID_MAX __TCA_ID_MAX
>
> I haven't look at any of the patches but this stands out as bad idea
> on the surface.

The idea is to reserve a range of the IDs for dynamic use in this case
from 256-1023. The kernel will issue an action id from that range when
we request it. The assumption is someone adding a "static" action ID
will populate the above enum and is able to move the range boundaries.
P4TC continues to work with old and new kernels and with old and new
tc.
Did i miss something you were alluding to?

cheers,
jamal

