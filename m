Return-Path: <netdev+bounces-7149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8850571EE97
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:18:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B0551C210F5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12FA4250A;
	Thu,  1 Jun 2023 16:18:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48DC22D77
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:18:26 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907DB137
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:18:24 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30ae5f2ac94so1056605f8f.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 09:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685636303; x=1688228303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cDIfVJ0K33ar1URlxi6I672OGZtBheR+6A6gMVrTuGs=;
        b=k+Yuk66SQ/6ZURtxSMkrnsBCPFW6mLLk+92+HnAzxED+BOmiNaMp0/fpeEtCmqcSYn
         9jL+0TEVZtOUoF1GF29I23xiMizS0eGij716PuBdo5lqzwZ3DRKFTa1JV85qkVqRBa6s
         y5aqNNgWwBZhfoINiffgCXAeFrg/MWDFC5/ure7YTQFlHkUm7IfkJLXUIZ26cB3I+UQ1
         MJVQo0C3uouC8AcqaXbu5zQtb83jBLK6/CRFA6OhRHrVe44JVPSjzxn94Un/cRHv4HXC
         mLFiq74rWKZEblFGKruLsZWPfQUPkKUAyYRoZV7hCv4j5bd5PqvzJK4rkf493K6mplr0
         KNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685636303; x=1688228303;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cDIfVJ0K33ar1URlxi6I672OGZtBheR+6A6gMVrTuGs=;
        b=jdHvRB4+/LRDQkGQvXiFXBFpDbLExiGwfy4yrp5hDGQ/c9jF5XgevLOFv/lsyqqWwU
         Wie40XIGVmvGnZiJz4OAYOTbreN752tEJupYen1USVGxsMq7JrEtqlBfS6br0A941Pk1
         sNgVcraOsfFkUfdDGT1++2ccJC4zOaSPvy2JkZSZSZXpCXrKTJUh4qsYU/VQ+8wSML8/
         HkAGrM2bnOFNjXIoJfkPUhPxVR6rBU0PyTu8d8nHHI6BCC3iU0lgdQz7kADlfRN980Ic
         g8ivT9FBKpIR7dXgGhupYDQNkgxl6yG/kq0ONscZ+IT7ZtZrGuwtgQXTzedAFyURgDAE
         ECRA==
X-Gm-Message-State: AC+VfDy+HgALW5mSQk/E6DLA6r+k0vRYHA3nkL33L3uyWdQBALnGXL2o
	EcwQA3ILJ0LzbkMF07cm4L5y7Q==
X-Google-Smtp-Source: ACHHUZ4kt2gYGAgNB5NnSPsJD1Yne5GDTHn4tFmrqy7iZloOcDAVVEAUvWMW5bEyb9n2ivi8hpvI4w==
X-Received: by 2002:a5d:6747:0:b0:30a:a715:66c8 with SMTP id l7-20020a5d6747000000b0030aa71566c8mr2645594wrw.8.1685636302975;
        Thu, 01 Jun 2023 09:18:22 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:d0b8:9910:433a:655f? ([2a02:578:8593:1200:d0b8:9910:433a:655f])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600012c400b003047dc162f7sm10899820wrx.67.2023.06.01.09.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 09:18:22 -0700 (PDT)
Message-ID: <476ea123-d20a-d9ef-9713-d53bd93f7876@tessares.net>
Date: Thu, 1 Jun 2023 18:18:21 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net 0/2] net/ipv6: skip_notify_on_dev_down fix
Content-Language: en-GB
To: Eric Dumazet <edumazet@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 eric.dumazet@gmail.com
References: <20230601160445.1480257-1-edumazet@google.com>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230601160445.1480257-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Eric,

On 01/06/2023 18:04, Eric Dumazet wrote:
> While reviewing Matthieu Baerts recent patch [1], I found it copied/pasted
> an existing bug around skip_notify_on_dev_down.

Good catch! Indeed, I quickly copied/pasted the code around
skip_notify_on_dev_down to create my RFC without looking for possible
issues in the code.

> First patch is a stable candidate, and second one can simply land
> in net tree.
> 
> https://lore.kernel.org/lkml/20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net/
> 
> Eric Dumazet (2):
>   net/ipv6: fix bool/int mismatch for skip_notify_on_dev_down
>   net/ipv6: convert skip_notify_on_dev_down sysctl to u8

Thank you for the patches and for having cced me! The modifications look
good to me!

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

