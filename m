Return-Path: <netdev+bounces-3782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0840708D5B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 03:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A3F2281A74
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 01:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83FD6386;
	Fri, 19 May 2023 01:31:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EDB362
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 01:31:32 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135DF99
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:31:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-52c84543902so256681a12.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684459890; x=1687051890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=niC0geNUue6Sx6QFsUb2nuJDwhXo/8zDEY5ILi3ihqk=;
        b=20go3clJ1vddJwF/2rDnrRCoRIfrDA+E/hgI2+HFlnFjWFs0TWPuAo0I0Pq28voNiC
         z1lWj/uV1eZmxVVy7BmFyOEB0ExR4aDfF4IqJgLFHmSyIlQP6uX+Wc7y49ZjROs+g1Ym
         zfAzonjtW5GgJsr/qgNbo2GhorlfNC+tXm+fEfcMg1UhB7E9wZOSWeumRDO9h5qIuJmu
         X+FkR3kpJDXLUBM/padjdCN11f5o7f20c5+MtK9Q/GFvV3CZgRWi17hMeYB8piyMcF4X
         FpveZxHfJTakQk3tTMHWo8FlF0SRbzlJX+ZadX1t1blImpHP6BiumfN6Hfi+D/aKVpHo
         raxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684459890; x=1687051890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=niC0geNUue6Sx6QFsUb2nuJDwhXo/8zDEY5ILi3ihqk=;
        b=lwca7nHDb8xZSjpkldBcNUnS/Gda2VMJCkr58137wkEythhcKEExTA1HxdFHxMqndF
         mD0CSArZdGSUrWw3O/+q+LrxqNwV4Of/eXYPd8W0f4xpHo7lJusWydWXqVcf3EhraiBr
         GFym2qw0tilHdPA+LToTGA6PRqAgh/XRQqkS5/GdhaasccNYVbJU1NFeLQKUF0i8ZvTW
         eHMLpiqSkR0l5O+gPlfjdMAGk7VZmTCUXtB3vJum2K2GJPK52dlOe7Lp0HcuiAJF8eCO
         qw+/9+Zmy8BJFCNl4OGiP/SDOpZO/zUI/BYJgtxF2P54hFrxmNeoRa8VgkASwJFaYOpe
         3vJw==
X-Gm-Message-State: AC+VfDxuvE6qZVpkQXIrQ1x0qAZJTW7Ur/INeK6imio1eZOE7+BpI2wL
	kPynjVmDrpZz2NeVNCuLMLZcamXuZz9rplNKHi4=
X-Google-Smtp-Source: ACHHUZ5BD/jJHV36vIA5yZPlqUmeOccOnDGXKSjorNTpD7jLOzJmOr4nZhlcpiUxYsHVqR4rYQpoKg==
X-Received: by 2002:a17:90b:3802:b0:247:9e56:d895 with SMTP id mq2-20020a17090b380200b002479e56d895mr691582pjb.1.1684459890571;
        Thu, 18 May 2023 18:31:30 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i22-20020a17090adc1600b002471deb13fcsm320675pjv.6.2023.05.18.18.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:31:29 -0700 (PDT)
Message-ID: <4861a3be-543d-3c1a-584a-b2f041c16bc1@kernel.dk>
Date: Thu, 18 May 2023 19:31:28 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 0/7] io_uring: add napi busy polling support
Content-Language: en-US
To: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
 olivier@trillion01.com
References: <20230518211751.3492982-1-shr@devkernel.io>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230518211751.3492982-1-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A few minor nits, apart from that looks good to me.

I'll let the networking folks take a look at the NAPI helper
refactoring. I ran some testing and it is a nice improvement for the
expected cases on my end.

-- 
Jens Axboe


