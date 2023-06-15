Return-Path: <netdev+bounces-10984-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE14730EB3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACE0628160E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CA980A;
	Thu, 15 Jun 2023 05:35:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B0F651
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:35:07 +0000 (UTC)
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6959D26AA
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:35:06 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-54f85f8b961so3220858a12.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686807306; x=1689399306;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QTy3DcGYU1N/aTlQ8VydPycyjj8QqnTY4XFzy8b9VXk=;
        b=R4JPRgQFgc/KEsfIcEMcypWaANXU3MaUty8DN7dMOfPci80FN2BcGeeQb79s2ecBVa
         21AjgQRixMEEPSHcFpAUoRfwNnaBA0uC0PY4M5SKzx6TZEFRFd+zMu6Z+61ub9aW3hIx
         sRnKXA/qXjpfPph9ZA8dXZso9q7Hyw8Tv7n/ZBSmvA5yrRCFt2/Mg8ZcDuDu+CnWWY4w
         rU4qfwaHtzsqzWr8dfrADoiOWJLMQ71cYTvGdy2BpYvW+0l4VQhwCNtslSxVtkwOwSPx
         LZtWLOGDhDqBzIFyjODKuMM2TZ0Rg9nAE/u5o2WnxzXCUejUfRUSrwskppmsMFMclbaU
         VM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686807306; x=1689399306;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QTy3DcGYU1N/aTlQ8VydPycyjj8QqnTY4XFzy8b9VXk=;
        b=g6yRYOHRXICl5OVZ9yWU/nAfIqO9AX+/nOQf+9txFBt6CRRyTBZTyTGujwd1rAuoMS
         Oun950WRNhXS/H0arzEGxu6iyguMzjAzsjGd3aWUlz8ONR1tZqt5cAIKDlznDVbGVrl6
         z7rmefymIIvGK+hzHpID9Z9EEZpjKshtWR39avwi3bo14DJhmlMNzEqt6IWJwwjYOHdc
         wGIAxgIVr3O8Zh6hP0dq/BRi2AnEp0hhSJrZ5q/QbRNNz7WJDB0GhmMARUn10SVkZ2Ba
         wAN27Om4AQx4uKoD38QejcqNZztnJszsceO9OyekBjwN10vwUqTZvZXypxr91qTN5MI4
         iInQ==
X-Gm-Message-State: AC+VfDyoUH7dtUPGgfWT15Pwva8DAgbSMsBU3TVtUpQb/6l3PbeaDqug
	q7VK3KyBTTq/10noHeZG90lkKC4CovaSVVwVB4OcYpr0FOW7mQ==
X-Google-Smtp-Source: ACHHUZ4AL6IApPdJyNDtNkEB+9dZ8kBRkFRpFHstF3bcyr1dBioZ3kXS9YUpSveB21Ezrao7Tmigiv5wsjpLC8VK/a8=
X-Received: by 2002:a17:90b:1b0f:b0:253:3e9d:f925 with SMTP id
 nu15-20020a17090b1b0f00b002533e9df925mr3447473pjb.31.1686807305529; Wed, 14
 Jun 2023 22:35:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADDGra2uwCeiQR6z3O+rHKkZhLHpwO7NG3J_goeX_ieqE-fZkg@mail.gmail.com>
In-Reply-To: <CADDGra2uwCeiQR6z3O+rHKkZhLHpwO7NG3J_goeX_ieqE-fZkg@mail.gmail.com>
From: Mahendra SP <mahendra.sp@gmail.com>
Date: Thu, 15 Jun 2023 11:04:25 +0530
Message-ID: <CADDGra12cxUhPnrFrWVn7xhbs5TuRpjiOa+wFcPr1FV=+Yemjw@mail.gmail.com>
Subject: Re: USGv6 R1 profile test results on kernel version 5.10
To: netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi All,

We are trying to run the USGv6 R1 profile against the 5.10 kernel
version. However we see multiple failures w.r.t. RFC 4862 and RFC 8201
(I can provide failure test details if needed )
Wanted to check if USGv6 R1 profile has already been run by someone
and if yes, please let us know if any issues were found or any
additional patch requirements.

If these failures are expected in 5.10 kernel due to any code change
dependency, please suggest which higher kernel version needs to be
used to pass the USGv6 R1 profile.

Thanks
Mahendra

