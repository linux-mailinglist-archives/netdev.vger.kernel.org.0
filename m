Return-Path: <netdev+bounces-9013-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDF57268E1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD32B2815B8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA25A154B2;
	Wed,  7 Jun 2023 18:35:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED9610FC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:35:11 +0000 (UTC)
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587051984;
	Wed,  7 Jun 2023 11:35:10 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-33b921e4e8fso5448765ab.3;
        Wed, 07 Jun 2023 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686162909; x=1688754909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dJK4RHY5v+HRBfOjP3aLuKokpzUyOO/60QMxyFfMzQQ=;
        b=LvW2sb7IoA33ETDQzUYm65E+Pt8ldwDzeN4s4Yvl8PJt0aQFSegN+FBFdnwnBoZvzd
         AQHPeRzcppNVBITRKGgE0LLVJbwRsZltXRnI0KRJq1tVMiWhCx9pJsYeZX+FcHckPrgG
         oCPphDP28tJ6Zu2GyDLsz91iONCbZ4O8pgg5sRmbdclJ+upg4M0FgchwjG8v3ayABicG
         PzwpXm5AB+KY8fTlvVH1T+BLTWd9ke3USMT2ihqP90X1ubec2vXUu42dHd/IrEMHfSCB
         ocyYNQ+CVkFWxW9iYREonpkwY7yvt3w1qswSz90PgK+ehSe7lImwotjCxxK8mIxJXe6p
         eGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686162909; x=1688754909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJK4RHY5v+HRBfOjP3aLuKokpzUyOO/60QMxyFfMzQQ=;
        b=fLYcjkoYJ5KvgnU08Mx8zvNwHtIzMuvaj91mmGd98mY+HrU2LZak6cZHREJfncSFfL
         UDnAqvksXSAydK16UKVZFZY8Pik+m2s1WrITVoPeq0MI9ebnLnp2Q6qwKA820uE1ztZ8
         sPeWT0YjMlPSjVDGioLA36I6jwiXPzj+4l5bqc+1CS82tArpp+9Sbj7vXEME8UTITl6K
         UxyF4vlQ3kzKHaGyLGqu1q0jt4V8h088RkJJSIBHRV7s8aE7POWOefugIOT9bOK8WyuI
         vqYoBri6Z7b8HIYIRUsy5NpHQfAI4dOdSVkRk3td9YfKMTuF1AQ0kKA9qdTGcBH4Z3Hv
         fpWw==
X-Gm-Message-State: AC+VfDy4lZfkDA1BQFxd2fJSwmBQ5IhZhM2nPhvsODZWLHpjaAkJx2DK
	eEOnYVYZRNQ1i9jNzDqYtJ0=
X-Google-Smtp-Source: ACHHUZ6Y5bg6tZwFIhadKRwAySjSh86iXnlFfuFpwLQpE0nLjCDet27fnvjRicBgXFSYid7JkdC8zg==
X-Received: by 2002:a92:d08c:0:b0:33b:9f29:8928 with SMTP id h12-20020a92d08c000000b0033b9f298928mr5423547ilh.8.1686162909569;
        Wed, 07 Jun 2023 11:35:09 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:6ca6:e764:8524:ec9f? ([2601:282:800:7ed0:6ca6:e764:8524:ec9f])
        by smtp.googlemail.com with ESMTPSA id n7-20020a02cc07000000b0041cce10544dsm3653480jap.123.2023.06.07.11.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 11:35:08 -0700 (PDT)
Message-ID: <379c5dfa-e7e7-3ef6-5e2e-3eb1113843d8@gmail.com>
Date: Wed, 7 Jun 2023 12:35:07 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH net 3/3] selftests: net: fcnal-test: check if FIPS mode is
 enabled
Content-Language: en-US
To: Magali Lemes <magali.lemes@canonical.com>, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org
Cc: andrei.gherzan@canonical.com, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230607174302.19542-1-magali.lemes@canonical.com>
 <20230607174302.19542-4-magali.lemes@canonical.com>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <20230607174302.19542-4-magali.lemes@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 11:43 AM, Magali Lemes wrote:
> There are some MD5 tests which fail when the kernel is in FIPS mode,
> since MD5 is not FIPS compliant. Add a check and only run those tests
> if FIPS mode is not enabled.
> 
> Fixes: f0bee1ebb5594 ("fcnal-test: Add TCP MD5 tests")
> Fixes: 5cad8bce26e01 ("fcnal-test: Add TCP MD5 tests for VRF")
> Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 27 ++++++++++++++++-------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



