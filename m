Return-Path: <netdev+bounces-11220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC05732050
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 21:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CD402813DB
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B8BEAE6;
	Thu, 15 Jun 2023 19:30:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5FBEAC7
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 19:30:44 +0000 (UTC)
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D152949;
	Thu, 15 Jun 2023 12:30:43 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7747cc8bea0so66756439f.1;
        Thu, 15 Jun 2023 12:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686857442; x=1689449442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SuvfqCGUiUMCqXPTVDeqjI2KbfZcmdWtMrUhTm7vC+4=;
        b=ZElvyo4Ba0xb/7VIHEbiKnOs+W0DLSzzwZS18uz4ydqmEdWcmbkhEuCgAKkGW6usFm
         BqlIAkdXFQxfJUTuGV+MRfbIQfLtvB9nw8Z5fZhO8g3g48Istcs9xY6Fahf1o+REuzkH
         vP7R06yse6aGBoEmM+GjsQomw6R/BwuylrFLUqJDU7LluqWEnBq//O4F44QV7/HTwf+m
         vGIjawg9iTMoP5PD08otgT9VpmlCiqFP7MWYCmBLQAj89IQDHnPTVeWip5rv+McS+mzL
         +1tNRGWpsflrBT9wQ6G9rIXmEmH+LvxVN1hSIsNR7BcKvjwFUH3WlUoI7v6+q1mmSqKk
         mzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686857442; x=1689449442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuvfqCGUiUMCqXPTVDeqjI2KbfZcmdWtMrUhTm7vC+4=;
        b=VzCG96pN8xuIM2mdovpacwutniMyO/4YhusGVwVWNwHNh25cMV+8T188mIHko8g5u2
         w4/QjNTcfn1zH1RyjmHoPKESdLrwqXgUOpQMYdjs6Hv7GNYNUrLVxC/UOa86rbwaIa47
         iudbGxt2DOt/DDpsuPoAiXYvRWiUdHl5PKqgaLJMTK7ySG1MVHGQw4mfQoCMbaTcdb+u
         nQ3b3hfKSLJ6lJojlYObeUhQ9W1wiIqiRvWPhrJ2vFdDnovZJaldPeDdC3qrGlLw9IJ1
         NGTaW4uvGcL73TAuTVRpE4oq7o0Sc1DCpMPzCz2Wo2s72pZQTTBWwR01AYUANe/hbJZ+
         skWA==
X-Gm-Message-State: AC+VfDzT9uSDLTvMCR7LLRSDpkDdOF4EhBtr/CfxHjj/CL/vhAyPKDZA
	Ib3Ku4VAR8+t77fX2dp+FLPEJXCo+X8=
X-Google-Smtp-Source: ACHHUZ7q6SbiAmgNQR95DVbQmxy3A+/ikCui8Cd/gPfu2cJHil+nCdQqsLS9kIyyRbLCCroNjJOZqA==
X-Received: by 2002:a05:6e02:1207:b0:32a:8792:7248 with SMTP id a7-20020a056e02120700b0032a87927248mr390255ilq.2.1686857442392;
        Thu, 15 Jun 2023 12:30:42 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w15-20020a63474f000000b0054fdb351718sm3097733pgk.29.2023.06.15.12.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 12:30:41 -0700 (PDT)
Date: Thu, 15 Jun 2023 12:30:40 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Alex Maftei <alex.maftei@amd.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] selftests/ptp: Fix timestamp printf format for
 PTP_SYS_OFFSET
Message-ID: <ZItm4OCrMjm56RH0@hoboy.vegasvil.org>
References: <20230615083404.57112-1-alex.maftei@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615083404.57112-1-alex.maftei@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 09:34:04AM +0100, Alex Maftei wrote:
> Previously, timestamps were printed using "%lld.%u" which is incorrect
> for nanosecond values lower than 100,000,000 as they're fractional
> digits, therefore leading zeros are meaningful.
> 
> This patch changes the format strings to "%lld.%09u" in order to add
> leading zeros to the nanosecond value.
> 
> Fixes: 568ebc5985f5 ("ptp: add the PTP_SYS_OFFSET ioctl to the testptp program")
> Fixes: 4ec54f95736f ("ptp: Fix compiler warnings in the testptp utility")
> Fixes: 6ab0e475f1f3 ("Documentation: fix misc. warnings")
> Signed-off-by: Alex Maftei <alex.maftei@amd.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

