Return-Path: <netdev+bounces-7592-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE86720C0D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A0B1C21239
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19EB1C141;
	Fri,  2 Jun 2023 22:48:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8A733301
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:48:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43621BC
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685746101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86nnFvIAvMyLiukOvU/wo8+LyrpqtpVSH2BbGuUzuuI=;
	b=gAW3Vp6TltUR3931BJU1QLp/+ROTrKFfkoZQXCFYIV4xpgoRY7MsFTOjopxTXQkkAFpZrB
	A0Q+mltgd6z/lFbnzC6gW/qVVM+WiZ7a0AJcZRsxmr9phuAgMmpe5/mYmnRxHnTgEa/Ey/
	VQjGJZb04vz7Zi/kJhgXEb/LBtlwsvk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-89Q3-a5FMeuwDwJuPuUWkw-1; Fri, 02 Jun 2023 18:48:20 -0400
X-MC-Unique: 89Q3-a5FMeuwDwJuPuUWkw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f814a2d990so28081761cf.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 15:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685746100; x=1688338100;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=86nnFvIAvMyLiukOvU/wo8+LyrpqtpVSH2BbGuUzuuI=;
        b=gmgbUVQ/I25q/RnQU0RkS0KaRzuakR/BEbBEtGP1eA24Wcg2UVas7yQqwUdrEhG5OI
         Y78DDpZeYKwN0fwsUcIg0aygD5YHoF73JHj5kyQgzhGaGenqe5eeqNKV2cdXlSOUbwOI
         zaf6KzqZm1fwGppcnH86gY5pBSuM24Syrw/LkToxMmEiZtuGDFjQpUl7cweyBnY7ui7t
         Zy7O6nPquTJ5LqChsW07F99nlham/xkgzUZ2OZI6nY6h/A7n2oOJpkpjLBp4j6bh6wlX
         W4CjvaZm7nzIzvTwj/u688IO5ehLSO9Ge9VaucgAB8aXBgnM11xJZ4Qip7YBKnua820F
         qlnQ==
X-Gm-Message-State: AC+VfDyExSiyWbHA5dBaJ4BWT/PmUtj566oh8vW4QIxtEpoL/e5B6g+l
	2ccdlx4TmjEvzdqO0KJusQ5GH9TZVZ7shLwSi4Zf2lIQUYWJDucZ9RLtLXYuY6L1lJNeh6D+aBN
	z9bP2OcfFbNL8XEtDuZfpv7URo3EnBljm
X-Received: by 2002:a05:622a:54e:b0:3f5:3ad4:39b7 with SMTP id m14-20020a05622a054e00b003f53ad439b7mr14052253qtx.66.1685746099922;
        Fri, 02 Jun 2023 15:48:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5KSgxzea6zpUFEZ+Gs/8kapO8ccu9XNo0WDb0EJw0TlyqICwoXEvzfYRo18t7EkACcrfLUUDT98TBUXa39dZg=
X-Received: by 2002:a05:622a:54e:b0:3f5:3ad4:39b7 with SMTP id
 m14-20020a05622a054e00b003f53ad439b7mr14052227qtx.66.1685746099674; Fri, 02
 Jun 2023 15:48:19 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 2 Jun 2023 15:48:19 -0700
From: Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20230517110225.29327-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517110225.29327-1-jhs@mojatatu.com>
Date: Fri, 2 Jun 2023 15:48:19 -0700
Message-ID: <CALnP8ZZps_VJNEMsZm07fK4DjPR1iCQkyH4_tpbZVr+N8KS+ug@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 00/28 v2] Introducing P4TC
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com, anjali.singhai@intel.com, 
	namrata.limaye@intel.com, jiri@resnulli.us, xiyou.wangcong@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	tom@sipanda.io, p4tc-discussions@netdevconf.info, vladbu@nvidia.com, 
	simon.horman@corigine.com, khalidm@nvidia.com, toke@redhat.com, 
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com, tomasz.osinski@intel.com, 
	mattyk@nvidia.com, dan.daly@intel.com, john.andy.fingerhut@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:25AM -0400, Jamal Hadi Salim wrote:
> We are seeking community feedback on P4TC patches.

This was the first time I read these patches. I don't have much to
comment on it overall yet.

>
> Apologies, I know this is a large number of patches but it is the best we could
> do so as not to miss the essence of the work.
> Please do note that > 50% of LOC are testcases. I should have emphasized
> this last time to improve the quality of the discussions, but mea culpa.

And much of the LOC that are not testcases, are for the CRUD
implementations. P4 is not simpe and allowing such simple
manipulations of all those types to the user comes at a cost and I
don't see a way around that.

The scripts seem long and complex, but they can be structured and are
human readable. I like how one is able to inspect the datapath no
matter how it was configured (from a p4 program or manually built).
This helps a lot with the supportability of solutions based on it.

One thing that I hate about u32 is that it is like perl^W^Wwrite-only.
It is as flexible as u32, but making sense out of those matches is a
nightmare. The approach here keeps the flexibility, while not
becoming as complex and slow moving as flower and yet, understandable
by humans. A promising in between the two extreme approaches that we
have in tc today.

  Marcelo


