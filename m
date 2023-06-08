Return-Path: <netdev+bounces-9285-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B18DB7285A6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69A11C21095
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0967174DF;
	Thu,  8 Jun 2023 16:44:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0E23D7
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:44:50 +0000 (UTC)
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597971FEB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:44:31 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b16cbe4fb6so560756a34.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686242670; x=1688834670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9BA+GLIhtYpwQpx6PbAmi0jPjFZQbVLgz4oE4SUeDU=;
        b=U4WT6ytxyIoYyZVuMnq1JlbrSEIulG3TBKhlpszrNPnO1FzR2g4cFFp5JUfYTM76dc
         4Zc7eIfKhbIB6KTQnWowqxm/XqAf8/vQ7vc5bit4X+hJ8Ur5diHso052SuBn+rn7OnLA
         5QXhkRgFbLKeYYBbYxdZ6w/JVF1Tizrda3v8U7smb+7zP8crn0MLRthbj0P0lf2VTuyO
         WhZRfInDrM6d/GNLMXsPCAhOoJHd89B6xPhBeB9r/MjPUSXB0B0DEyW5HTSFCX/HbbwF
         jd4RXhYPIzld98fkb8uUOgm02UTpyO+YETJ0dtiklTOFx5pH3VbDGZ8GcGI6j4Xb8BfZ
         n4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242670; x=1688834670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9BA+GLIhtYpwQpx6PbAmi0jPjFZQbVLgz4oE4SUeDU=;
        b=inqd/+8qWbCUrl4WlYnU014Y97T2KZJ9iXLrHM3Rf276lOkQfRNGcFSi4aufkIGqz9
         V0UaAqxHvUANsnemgWof/TW4ZO1DLV2YFK/fa/XX0btXJzbF7Rs/+b4bAjs4py4RF1ta
         KK8ZaUI5EFShyjrGEQqZ4ENTw5xairnmSqF6HPq9nSWSmo6tJCsZhNfXM3c0i7kFOtdg
         sSxQ8YiQg8OMCxeLJ0Yy9pRkcxjfVd/zlf28PCM3ejvxF9z3u9IyWaqIo6FRf74shP96
         dNTVLAXvQx18u/rqyulO3KA+/HpK7YA6l9Zt8a8JjpxQjCTvGot/ST9RIPRvu38B0xLL
         1msw==
X-Gm-Message-State: AC+VfDyPHz/Vv7QYxpu40DvWgD0CfHenQ29rC4r/d5AB5AsCx16FWyUE
	HPZv4cxyEpeR/LCLG/XgATdt9eWF7zbi+L2dHlaQaw==
X-Google-Smtp-Source: ACHHUZ7ZnZdr3mhb23juHeVlswu4acabW+SU/yfDsY9mm8AWOXfT0T8jqYSAdf8trJudN2wqOZc6eEhUgK1N0+VYHls=
X-Received: by 2002:a05:6359:692:b0:125:83a6:caa5 with SMTP id
 ei18-20020a056359069200b0012583a6caa5mr7319535rwb.3.1686242670376; Thu, 08
 Jun 2023 09:44:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607145954.19324-1-fw@strlen.de> <20230607145954.19324-2-fw@strlen.de>
 <ZIGxCWZJoSGJZiUw@corigine.com> <20230608135719.GC27126@breakpoint.cc>
In-Reply-To: <20230608135719.GC27126@breakpoint.cc>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 8 Jun 2023 12:44:19 -0400
Message-ID: <CAM0EoM=F0x2mY-RHN9Me2qZav31Z6jwee2_p6fKQDyW8kybaQA@mail.gmail.com>
Subject: Re: [PATCH net 1/3] net/sched: act_ipt: add sanity checks on table
 name and hook locations
To: Florian Westphal <fw@strlen.de>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 9:57=E2=80=AFAM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Simon Horman <simon.horman@corigine.com> wrote:
> > I think that patches for 'net' usually come with a fixes tag.
> > Likewise for the other patches in this series.
>
> Right, I'll add
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

If we want to be pedantic (not trying to be) that cannot be the
correct Fixes tag since some of these issues are a result of feature
additions to netfilter (post 2.6.12-rc2) . But it's ok to use that
tag.

cheers,
jamal

