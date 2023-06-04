Return-Path: <netdev+bounces-7790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0276E721862
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0EE52810E2
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D07CFC1E;
	Sun,  4 Jun 2023 16:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7B923A5
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 16:03:49 +0000 (UTC)
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253BFBB
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:03:48 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7606d460da7so96921839f.1
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 09:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685894627; x=1688486627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=18nEVLeAaj7TxxMmxSwNqi7OUeMd0EUKekeDPPt60Ho=;
        b=CWnJYmfce0159vwTqkkybAarkhcBGjHW3sVofwtAZjQkapogdHEkvPGn0TaoFfiS5C
         KTdXMFA2lEDktG9ryZioHOgWWM2spJJjHm4TXua90CB9oiCW+vsAlVuPSSAh1rJB3BPo
         OUlYEtxu3EfDk0LblIuyLGaC+6EvVeJwYQDDKz1zOewjbb6k7WYjoO2mW/+uflIR8zRi
         nFRPSfNSkvVyj68cQMwyfw9JPiX9ZgqnDL8i6xskX9J1a96yIhd4r0VnQWfxvqp811lU
         74fSlN6rgoFqxK1Xykw/IQoGsktf0YIbLDpMp4pW71fZYkRWUW2IP+BJA5kYsxFUIrfW
         w9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685894627; x=1688486627;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18nEVLeAaj7TxxMmxSwNqi7OUeMd0EUKekeDPPt60Ho=;
        b=OOaCeo8cmTOG4FK9g037aDN68//p3ZNdeVHrLwJzG1xFLdZwqBcqP6qWEepscRhbht
         WEzW1VrYGDNDfwU9FKvjkBcnOstX10hufp//ur0/xuSFw5fRB0tt8VkdtFP4ZVm8MhZz
         KSXcCHryFgQBH+OoQ/CEn4QpYAjU4Bg9TzZhs1GUI7Bs/SenwHk1JpVb6mgPuTYiEX2I
         6F9ysjV8aUiSxx8dnzI1XJnXcnInmdiHdOtbW0lxe9C31VpCny/GZu1gnFoJPE71LEtT
         2fRSM3GyN/sCVCWYkrXSQjsvDhJjJUuiU/KCc25PEtXqLAfAqmjtuLTetateT3Z+SeDo
         tSIQ==
X-Gm-Message-State: AC+VfDw3cb5UrBeFKfVMyrL38X05otr17XZdAU52GV+ugSAXB8m2TgG3
	Kn+NgUZRR1aJadt2EErlE3k=
X-Google-Smtp-Source: ACHHUZ5yFth7aXu9DKuhBIayOxLDcEZ2nLtxX5CwKkALTWhQr9HSIdFXkjuOHDSEFf7L0jYTb5Xixw==
X-Received: by 2002:a6b:740f:0:b0:777:91d5:c198 with SMTP id s15-20020a6b740f000000b0077791d5c198mr4260675iog.15.1685894627472;
        Sun, 04 Jun 2023 09:03:47 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:1084:4e4a:fc45:90c5? ([2601:282:800:7ed0:1084:4e4a:fc45:90c5])
        by smtp.googlemail.com with ESMTPSA id r23-20020a02c857000000b00418b836f89bsm1641649jao.63.2023.06.04.09.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 09:03:46 -0700 (PDT)
Message-ID: <a34a8392-9c9a-7ce6-1289-ec3a0b6e2e0d@gmail.com>
Date: Sun, 4 Jun 2023 10:03:45 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2] lib/libnetlink: ensure a minimum of 32KB for the
 buffer used in rtnl_recvmsg()
To: Gal Pressman <gal@nvidia.com>,
 Stephen Hemminger <stephen@networkplumber.org>
Cc: Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>,
 Eric Dumazet <eric.dumazet@gmail.com>, Hangbin Liu <liuhangbin@gmail.com>,
 Phil Sutter <phil@nwl.cc>, Jakub Kicinski <kuba@kernel.org>,
 Michal Kubecek <mkubecek@suse.cz>
References: <20190213015841.140383-1-edumazet@google.com>
 <b42f0dcb-3c8c-9797-a9f1-da71642e26cc@gmail.com>
 <7517ba8c-2f51-6ced-ba84-e349f5db8cac@nvidia.com>
 <20230531145148.2cb3cbe8@hermes.local>
 <99d127c4-d6cc-4f68-8b73-3ba4f4e6b864@nvidia.com>
Content-Language: en-US
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <99d127c4-d6cc-4f68-8b73-3ba4f4e6b864@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/4/23 7:33 AM, Gal Pressman wrote:
>> It is possible to dump millions of routes, so it is not directly a netlink
>> issue more that the current API is slamming all the VF's as info blocks
>> under a single message response.
>>
>> That would mean replacing IFLA_VFINFO_LIST with a separate query
> 
> Thanks Stephen!
> How would you imagine it? Changing the userspace to split each (PF, VF)
> to a separate netlink call instead of a single call for each PF?


This is the last attempt that I recall to address this issue:

https://lore.kernel.org/netdev/20210123045321.2797360-1-edwin.peer@broadcom.com/


