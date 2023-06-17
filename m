Return-Path: <netdev+bounces-11662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8C3733D5D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 02:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BA301C210A6
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 00:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E35A637;
	Sat, 17 Jun 2023 00:58:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E75D371
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:58:11 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD1C3AA8;
	Fri, 16 Jun 2023 17:58:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b3f9a96606so2012305ad.0;
        Fri, 16 Jun 2023 17:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686963489; x=1689555489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u8rPlv3Ywh/NUyCYpCykVWdpi8JntsuNA88J8AvL8Ck=;
        b=g+tl+YZvyAJouiUMIa5HQBdhD5zB7uhMwjonJBFdiSAAaotfzGLq46vTcwO+NqpfpP
         hqL+3YSQcN/6pELHfNCAhLcTnmvAgkTvYAnkk2mqs/7zCfgnHHfhlhYLNs4k4PhQ+i1n
         xrfF+czMXg2pZSugIH8TrO0KhU67s+zTFl0k81Dp6HJ4uieS3HEuZ8vHgt1OkxxSy9Re
         wdDcKpwUYpD9dxZkTsYwbwJtRaf+DgOX+gxEMAYll9Bm78kIQMcyxIhTA1+5eWnBzLTb
         w8i3luLGZQT8ZHCGfV4qkcYVgjW59rfcjeS7k7jj9RJqJkE/327OZaSjbDMFGyU878Td
         XxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686963489; x=1689555489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8rPlv3Ywh/NUyCYpCykVWdpi8JntsuNA88J8AvL8Ck=;
        b=d+ZSvNfkQYkjmjIb7/Y5KmlyF2CuysbCFbyXmagAYalO/IwUfwIiEnuCH2xDGq5TVU
         5+ckWm3xdJBv0PdZGix1HJtzJJdGNnWyIJGNYqF6TJXbQlVkS2zpUg0RoHwKUUh3sliM
         bkrTu0o3gbVsjsDEaMmqYdfJ8huE+fgOald7NtVxorJmT2hJVGK2drSyRKW41w8BzxZ5
         mFzV9K4f0/DBxLAeQ0XEiRG9LlbaIXo6njjNCtcnZlCfPi71weUNkgbF+TKxJuyjb9jl
         3CR4vASSL1sxMrDxU1G1+w/O7MlRO0y9bwfUduip0vp2Ybo+g+MNSb6o3UzilgX4jwkh
         wJOA==
X-Gm-Message-State: AC+VfDytvqggiNyjULtANgfgjsq14PjCgzVQCc/dPUh9GrH8hSt4OisJ
	ULDwgk8IcgGGFih1h3bwtVA=
X-Google-Smtp-Source: ACHHUZ7az4sIy8eKKlwLxocvFC/eqUqPa0gN/k1TpxoNbQsT+t2yVkT6gjt/mPsl9/THLbKs2aN0uw==
X-Received: by 2002:a17:902:f691:b0:1af:adc2:ab5b with SMTP id l17-20020a170902f69100b001afadc2ab5bmr4152524plg.0.1686963489235;
        Fri, 16 Jun 2023 17:58:09 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902694100b001b025aba9edsm16342899plt.220.2023.06.16.17.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 17:58:08 -0700 (PDT)
Date: Fri, 16 Jun 2023 17:58:06 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Alex Maftei <alex.maftei@amd.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests/ptp: Add support for new timestamp
 IOCTLs
Message-ID: <ZI0FHsWm37BZ0W4N@hoboy.vegasvil.org>
References: <cover.1686955631.git.alex.maftei@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1686955631.git.alex.maftei@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:48:43PM +0100, Alex Maftei wrote:
> PTP_SYS_OFFSET_EXTENDED was added in November 2018 in
> 361800876f80 (" ptp: add PTP_SYS_OFFSET_EXTENDED ioctl")
> and PTP_SYS_OFFSET_PRECISE was added in February 2016 in
> 719f1aa4a671 ("ptp: Add PTP_SYS_OFFSET_PRECISE for driver crosstimestamping")
> 
> The PTP selftest code is lacking support for these two IOCTLS.
> This short series of patches adds support for them.

This is new functionality, so the target branch should be net-next.

Thanks,
Richard



