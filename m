Return-Path: <netdev+bounces-5050-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 414BA70F8E8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:41:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E89BA1C20DDD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328B4174E6;
	Wed, 24 May 2023 14:41:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE0AC2CB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:41:24 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5249F119
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:41:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-510e90d785fso2011038a12.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684939281; x=1687531281;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aZYV/12vQ9lahj04X3CDTNOGYMZepSboTlhuztLfP9Q=;
        b=vpHcfgCBf+YktUu36xDjIFofhhhdSPTV59fS4EuebRM2xWQYijSSfmb9Z669qjAKYS
         BlbA70h01QOhTsCa802m+rAiS9G7GTxQCSjJQBxMcQRTRg8DZeqzOsol9W62e+Y+Z9qZ
         2VvxkLhO5uVv/T26BnHAmt8Rwp5oFpQLFEju+kZjJ0q+/trKpEymnIHOLTCGcRbuhj85
         0wibhUMmR1IYQ4lYXNh1jmvw7l4ygyQhRSz0gOaClIWtIzAFeNxnTQ2IWylKA+LoGIpE
         v1I7C6y5Bq+jhPcH+KA0/agckAxabtHOH8t7x3+YFxBw9wRoJ9nOsRvHPkpQpN2YDGqX
         Vwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684939281; x=1687531281;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZYV/12vQ9lahj04X3CDTNOGYMZepSboTlhuztLfP9Q=;
        b=JTPS/8dj8fGBag3twxNNpLDaP1wVFZ1QYN3tAgGWyoMkIACZRSE5HRSuOuJ/BPILrU
         6IYwnllb2w2B7MEw9gSw6Mcs78JNx1SkjYP00ZUsA+CkFjxgHoO9jyBjD4Zd8f+F5tJR
         1gCTPbL1dWrJqFTdjhl50ZImUapxHaMTWTP44BdZihMaPIVhg4Lh2qaxBajO8dkxqHp1
         ykIQg95Z7PpEbnt4Euy0RfyPJ0ZvJeo6v6MG0dNTPH/4CrWJUaP7GvlRVLEHXIxYP3ez
         29mKr/XWfgmpiizsKUf8AuWf1kjFlAltkYcfqMxPevVb7aQVt1XovfLkwVFh+VTrsCkj
         DS9Q==
X-Gm-Message-State: AC+VfDyPUEGMrgvX4C7qsnjh8S5juKH5sTYaGfzx6B+F5IumAIojYr+k
	A0uOvCGX3yU78J5ifZwrU6hsCw==
X-Google-Smtp-Source: ACHHUZ68X9nv3fqHQvgxU30d8UALpboLib7VXowZV8z/CLhcAOCKED2+qRMgkv2dZ0X854EEhHsMiQ==
X-Received: by 2002:a17:906:ee88:b0:96a:1c2a:5a38 with SMTP id wt8-20020a170906ee8800b0096a1c2a5a38mr15730515ejb.11.1684939280689;
        Wed, 24 May 2023 07:41:20 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z25-20020a1709064e1900b0096f6e836fa0sm5768890eju.27.2023.05.24.07.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 07:41:20 -0700 (PDT)
Date: Wed, 24 May 2023 16:41:19 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Eric Dumazet <edumazet@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Message-ID: <ZG4iDxcQ7BIz0H33@nanopsycho>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
 <20230524111259.1323415-2-bigeasy@linutronix.de>
 <CANn89iLRALON8-Bp+0iN8qEfSas2QoAE0nPMTDHS97QQWS9gyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLRALON8-Bp+0iN8qEfSas2QoAE0nPMTDHS97QQWS9gyg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 24, 2023 at 03:53:27PM CEST, edumazet@google.com wrote:
>On Wed, May 24, 2023 at 1:13 PM Sebastian Andrzej Siewior
><bigeasy@linutronix.de> wrote:
>>
>> I've been looking into threaded NAPI. One awkward thing to do is
>> to figure out the thread names, pids in order to adjust the thread
>> priorities and SMP affinity.
>> On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
>> the threaded interrupt which means a dedicate CPU affinity for the
>> thread and a higher task priority to be favoured over other tasks on the
>> CPU. Otherwise the NAPI thread can be preempted by other threads leading
>> to delays in packet delivery.
>> Having to run ps/ grep is awkward to get the PID right. It is not easy
>> to match the interrupt since there is no obvious relation between the
>> IRQ and the NAPI thread.
>> NAPI threads are enabled often to mitigate the problems caused by a
>> "pending" ksoftirqd (which has been mitigated recently by doing softiqrs
>> regardless of ksoftirqd status). There is still the part that the NAPI
>> thread does not use softnet_data::poll_list.
>>
>
>How is interface rename handled ?

Well, having name of interface in sysfs dir/file name is silly, even if
it would be handled correctly. Should not be there.


>
>root@edumazet1:~# ip link show dev dummy0
>4: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
>DEFAULT group default qlen 1000
>    link/ether f2:38:20:69:b4:ca brd ff:ff:ff:ff:ff:ff
>root@edumazet1:~# ip link set dummy0 name new-name
>root@edumazet1:~# ip link show dev dummy0
>Device "dummy0" does not exist.
>root@edumazet1:~# ip link show dev new-name
>4: new-name: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
>DEFAULT group default qlen 1000
>    link/ether f2:38:20:69:b4:ca brd ff:ff:ff:ff:ff:ff
>
>Thanks.
>

