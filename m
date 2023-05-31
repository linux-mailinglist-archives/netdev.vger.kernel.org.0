Return-Path: <netdev+bounces-6723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C3B7179D0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E08E72813DB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C8ABE5D;
	Wed, 31 May 2023 08:18:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1269BA52
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:18:54 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DE310E
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:18:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9707313e32eso1018751866b.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685521130; x=1688113130;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvmMiUwyBQPq4pfFY+SS/m/KZqhfIcrmFD93CDkiW8I=;
        b=Dee5TIrrKVDSoSGQmAV/zjLf9hn7xkXeNXZFKrN4o8I0O50g0KngfyTfXYbtiP7v12
         JIr/7y3ysOdA6dPqRBJOjjYmFYkf5/8jDaV7/ayf/46qJI3u+y4GdvHa2GU5uLTeSLYM
         cyVQujo2Yxq5Bd/SS7KW55/k2dKgbGpV1m9OFCeqnsgGewjZuyQ3OnGaE+4DwWF0e4g+
         hnqVY5gjsEepjvy/HSVriHwQSxh3e82RD81uFlKPK7HEVqgrsZvBJOvrVaT36U++FrBE
         0VGX/XUaGYHbCzb1GZU0pKpMaMa85T2o7KHSXfhjK2p3zjM87OOUA+LH9iDaErGEGPc2
         bQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685521130; x=1688113130;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZvmMiUwyBQPq4pfFY+SS/m/KZqhfIcrmFD93CDkiW8I=;
        b=aj38znVKwEPTndgvk6NIkzdiVpFcUdV2BKJjF1D3c2DT1SeEl94DItJek/YiyWc1O4
         20EFr+LZstIHSWwhPHP9a1wFq2SahUt4fGzS+tta4tiL35kJ2eA0wG4cTx1q6yyxqJvO
         4COPKbKbGN5YrYQ8/1oee9iiT/KVCM0BDv9H+1VuRVioDofMfV+texCzR8S4LHBFVC9P
         6PGNR5bs5vG7lRRX55j5ezbl9PHYGfpJmhVDsvSoOEMmPyF2k9hk9LEhQ2zcieS2bbQO
         i1f85/iolpRMcxjMkahT7aRrOFU8asLFxi2Ng2N7IpkZ/RYeKrLAx4FmWgOVJdt8oKjI
         wsQw==
X-Gm-Message-State: AC+VfDxkuTrQzL/ygsL9alwqAjkQgP9L2KSPMSRihPBWX1ElDQRY1y48
	iJqfVVrH1voN46jJbJtOx+0=
X-Google-Smtp-Source: ACHHUZ79ipfMk7nv7j7BfPuBvSjN13f/7lgToHcguKSPd//5UkoAougpN1UNcsTRW4Ml+94mloCzLw==
X-Received: by 2002:a17:907:2dab:b0:96f:7af5:9e9e with SMTP id gt43-20020a1709072dab00b0096f7af59e9emr4078465ejc.53.1685521129942;
        Wed, 31 May 2023 01:18:49 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c18f:4600:f909:602e:4191:f30f? (dynamic-2a01-0c23-c18f-4600-f909-602e-4191-f30f.c23.pool.telefonica.de. [2a01:c23:c18f:4600:f909:602e:4191:f30f])
        by smtp.googlemail.com with ESMTPSA id k17-20020a170906681100b0096f7105b3a6sm8496389ejr.189.2023.05.31.01.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 01:18:49 -0700 (PDT)
Message-ID: <87535ce9-4780-d982-0535-d010720aa636@gmail.com>
Date: Wed, 31 May 2023 10:18:40 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f9439c7f-c92c-4c2c-703e-110f96d841b7@gmail.com>
 <20230530233055.44e18e3a@kernel.org>
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: don't set sw irq coalescing defaults in
 case of PREEMPT_RT
In-Reply-To: <20230530233055.44e18e3a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 31.05.2023 08:30, Jakub Kicinski wrote:
> On Sun, 28 May 2023 19:39:59 +0200 Heiner Kallweit wrote:
>> If PREEMPT_RT is set, then assume that the user focuses on minimum
>> latency. Therefore don't set sw irq coalescing defaults.
>> This affects the defaults only, users can override these settings
>> via sysfs.
> 
> Did someone complain? I don't have an opinion, but I'm curious what
> prompted the patch.

No direct complain, and not covering exactly this point.
Background: I witnessed some discussions between PREEMPT_RT users
(e.g. from linuxcnc project) regarding network latency with
RTL8168 NICs. It seems these users aren't really aware of the
userspace knobs that the kernel provides for RT optimization.
To make their life easier we could optimize few things for latency
and use PREEMPT_RT as an indicator.


