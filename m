Return-Path: <netdev+bounces-7672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A16B272106D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D21528151F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C28D301;
	Sat,  3 Jun 2023 14:18:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF27C2FB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:18:07 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B076133
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:18:06 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-569386b7861so38601647b3.0
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 07:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685801885; x=1688393885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMEgBBOrgKotlBOmdfOWorp5AoVrKbOiy5XO/D3ai0Q=;
        b=Eg8V9JP0/HbgJGMQoM5P4MZdxjIbJF1gw2NIFEH/nCzrEXzyB1qloozPGOtNLauD1z
         Swb9xNkyRqOsDtVjv8JG/mKT+XlWrNy9+4WouCcTTnS4C0dTv088qky4hSMLWJmw7kIn
         TI3mlUvvztha3/se15U29LxbMjY14ghd5ursl/Is7BW2ckoczbkA6Ls2kZaVX8VuB+ug
         KZXMxwXzbHQ79XTBoF/dlgYcqEW3qnY0reR9lk6qvhwuDVwx+vAbEaLHTiWGmajZ3zTJ
         P4SvOwvD1yBLV0yhL/CDh5YjbODYimSnvEuo4wcngXch7hbPIx/CwRuyVGSlMBxIH7kg
         GWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685801885; x=1688393885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pMEgBBOrgKotlBOmdfOWorp5AoVrKbOiy5XO/D3ai0Q=;
        b=APeMvFJ4u4d/F/BJODDX2g7ETSnQqZGdgdAdCR0t7CTHhOyhNmyJTgOhus5izBiwVD
         KsKDyQO23nz4PkDKC41TBFACdHzfYr2S6B7G/dbY1l94l36Sih1/CL/De/dXcpOrbvMX
         GUV13HOTx0R/C7WJ3RfnkBetf6C3cC91RiYIfz6ZiJGYUBGp62Xvdi0oNP89tTlTZEkr
         Wze0BpQ66y2clO/sUdOE7TNE7gSXT2LMY1Qzow/9qMrONY0vzAsaKLh2BpLHmk2p9p4+
         PaiJiq5umxwBW/Nu9DYVxF7WWXwwGyB00O1uOgyaTPK6dVNg8Eg9weTL680jR1AdcjQy
         X9cQ==
X-Gm-Message-State: AC+VfDx79h7OuTUrQ9AIX+eYfw03wBBU0cinxT6IIVknKOxAQBhrEY8i
	G0J5AecN7yExgrv1v68toGNoGBUqFRpVI5en3yjU4Q==
X-Google-Smtp-Source: ACHHUZ7HPX0v5pSL2LOocKW6QdJN48tQGYVVmZEb055I+7U/W5UjYh6EKnUv11/g7jW6gGPCaxNyUSWBqdGBgvpl23Q=
X-Received: by 2002:a0d:d9cf:0:b0:568:df16:6a36 with SMTP id
 b198-20020a0dd9cf000000b00568df166a36mr3755911ywe.14.1685801885546; Sat, 03
 Jun 2023 07:18:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517110232.29349-1-jhs@mojatatu.com> <20230517110232.29349-20-jhs@mojatatu.com>
 <CALnP8Zb6tO-yuYXo4vD0DrJ=xuQN11-QPOg3FR_Gn1b8_Nm3Yw@mail.gmail.com>
In-Reply-To: <CALnP8Zb6tO-yuYXo4vD0DrJ=xuQN11-QPOg3FR_Gn1b8_Nm3Yw@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Sat, 3 Jun 2023 10:17:54 -0400
Message-ID: <CAM0EoM=C+Z+3_d=pEAhLO7__AHFNtY3EUAFhvBzYRC=us4qXNg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 20/28] selftests: tc-testing: Don't assume
 ENVIR is declared in local config
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, tom@sipanda.io, p4tc-discussions@netdevconf.info, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 6:08=E2=80=AFPM Marcelo Ricardo Leitner
<mleitner@redhat.com> wrote:
>
> On Wed, May 17, 2023 at 07:02:24AM -0400, Jamal Hadi Salim wrote:
> > @@ -28,12 +28,14 @@ NAMES =3D {
> >            'EBPFDIR': './'
> >          }
> >
> > +ENVIR=3D {}
> >
> >  ENVIR =3D { }
>
> Hm? :)
>

Sigh, i was sure we had fixed this - part of a merge issue. We'll take
care of it in the next update.

cheers,
jamal

