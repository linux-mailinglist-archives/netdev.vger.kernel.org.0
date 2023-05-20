Return-Path: <netdev+bounces-4045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB7F70A4A7
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A52281B38
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0047636;
	Sat, 20 May 2023 02:53:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDDA632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:53:02 +0000 (UTC)
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE82C4
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:53:01 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-52867360efcso2785601a12.2
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684551181; x=1687143181;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=whrMJ2xZ1qsRtqScFyWtdYpUZtIz0qqv9OMUPlZO06U=;
        b=Hdn4/uTzdmW6dt76Ru8u94flJyY4k5KbHhOJzIjBgFwLjyEsIc42X3016E/pfTn+tF
         bg8T2wiFK+lfXorYzqkAEzc8eKGz+DYSBA4IbRqa9bHS1/1yZMWyb3bHYz1ogVfOqoq9
         wwsEAbXXZHk8GR5I6pGTgmKZ06B7PUeHwQ5zceVTfRYpF/CqmQ+0RkomiAqfAJ065AAO
         R5RzGM5WGR+sKvXvHbEYmuG3sdRwEfdbABtMTpOc86DYBlMAm05ox6ZgQPCwoTpl7A/y
         9CIiHM+1MrF8r9R5pinHL8QymjtnmHfbj3/IN07uzRMjoL6DRD2Amz94ghOjbYVe36Wc
         T2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684551181; x=1687143181;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=whrMJ2xZ1qsRtqScFyWtdYpUZtIz0qqv9OMUPlZO06U=;
        b=JOQf7ODJm4nZV0WALEi9us81l1acnHf5+jADpTLTfCEmU0bNbV61xm8FF1qdR7CPDQ
         6qEpDNgRPJGLECGxltHerGydOSbf88JfUD28xAbMsg1/m0aWKH3HWTdjtd74CwEA95NC
         pzi/fcA/FqYDa4oFapljQU49Tj0RPeI8ZeDH/4EjeIaWBDxZzajrDqc3ntsO3H4G7K94
         9w4+e42VAJbznxqmQXZ4js+b2T6zuXt3ifu5bObhhC1UO9HtdRxGNn+wtCcPTTOq82Xz
         5udf6rEpzRgwUX77v8f+IaTcaN7ZmWJzI0qumJYGX+LZ9MU64G7CPVIFRpyZoz4cCyU+
         sfSQ==
X-Gm-Message-State: AC+VfDzSfNndzzJf+btYbNVzE867pq/kPSw5m3bjNJxrnJj39K7WAtwn
	MlB1JpBs6A5i+N9DYFB1kh6yML3IpBSm9Q==
X-Google-Smtp-Source: ACHHUZ4gtJozw4gGuTrfehKT76lfk4gSc94TEuMpCLmR/uNWUAPYRT/LKftdBGFj+lp+wLHynWqr2g==
X-Received: by 2002:a17:903:11c9:b0:1ac:63ac:10a7 with SMTP id q9-20020a17090311c900b001ac63ac10a7mr4889503plh.68.1684551180560;
        Fri, 19 May 2023 19:53:00 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903004d00b001a9293597efsm309011pla.246.2023.05.19.19.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 19:52:59 -0700 (PDT)
Message-ID: <ced226b9-e14c-a1fc-4974-8492efd45270@gmail.com>
Date: Fri, 19 May 2023 19:52:58 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: netconsole not working on bridge+atlantic
Content-Language: en-US
To: netdev@vger.kernel.org, Igor Russkikh <irusskikh@marvell.com>,
 Egor Pomozov <epomozov@marvell.com>
References: <20230520003818.GA30096@cmadams.net>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230520003818.GA30096@cmadams.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+CC maintainers,

On 5/19/2023 5:38 PM, Chris Adams wrote:
> I have a system with an Aquantia AQC107 NIC connected to a bridge (for
> VM NICs).  I set up netconsole on it, and it logs that it configures
> correctly in dmesg, but it doesn't actually send anything (or log any
> errors).  Any ideas?

It does not look like there is a ndo_poll_controller callback 
implemented by the atlantic driver which is usually a prerequisite to 
supporting netconsole.

> 
> This is on Fedora 37, updated to distro kernel 6.3.3-100.fc37.x86_64.
> It hasn't worked for some time (not sure exactly when).

Does that mean that it worked up to a certain point and then stopped?
-- 
Florian

