Return-Path: <netdev+bounces-12115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CEB67363AF
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CC311C20A9B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 06:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DABF187C;
	Tue, 20 Jun 2023 06:39:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E0B1119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:39:34 +0000 (UTC)
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0939E7E
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:39:32 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1a28de15c8aso4423961fac.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 23:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687243172; x=1689835172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=auJ6EJaNEhBlb5WUEu9u5pzfD1n3KesDYvPGRacKRpY=;
        b=Q0x5ZOGt4/v3wQppV0vu3j4kjyVREZuzdlXMoLL29N7NXduun7x+/qMKtZI9/fJvkE
         uXAJEwy/vwqunPx2kBUjpJnwRZJYHPKEU135M3wz8Lbji0KHP6SAo8dzYCyUA91hD2hK
         qQFY1wwfxb6zZ2hcn39cy6SQgMduj6ZO6UnIgFsg/LsEwb5s1ohxYtTnc3+lnKX4c4up
         9b0HQQSe2NnahNMiG0Ue1NNNiQHRN1pqAwwNk3vqHBW6OZsxoTORWGTDR/hX/gVasPBI
         RgeSOvQLSLXUsLXt6N2Sx/C/uwmT3Q+vwAAehP4zPVzFD3vAPrUxgSq1xPAf2WLJ68Is
         nDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687243172; x=1689835172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=auJ6EJaNEhBlb5WUEu9u5pzfD1n3KesDYvPGRacKRpY=;
        b=f1lKPvjcfMKKDRjKkW1Z4CTjbQoHQxu/jvNtRwEq+IWrZKY34zqmjIxYZ4t1C/aC+/
         H5gEQ7K1G5hOX914oJ0zXnleL3W+G7sGNZ77WiOCfGvbpAkcQwtkaTMvJ9oG7TgCRpSC
         wXBvX6xxHN8oSN9HwLVudpJRQAWOdsbQnMfeUputHVcVRNikh6UYudEX08Sff5NHDgSR
         gpCyAbWpOhbtue4WqX52bTfFug4BJmoXhiMJBmcgGDy6G6Xz19Rf/vXRgEswXu7yFF7j
         roFVV6yVaXFvZWqjRpTl2La0QJ0pAAs1fDlwpf9px41dRYoC5Uf4yLY1jmuIaFx/ehOP
         Fbog==
X-Gm-Message-State: AC+VfDzA0FzxF52f95J807YRNzXdealuGaO++o7Dw/PtwKtYJj7ZqjaX
	SU+7WkH6nnVbJDjCKXw2+M3DhA==
X-Google-Smtp-Source: ACHHUZ7MXbwUUZMP5G5VW1Wv8zl+x/+Um3sJyQyvUnyO9ywOp/LLZEb0Mxk8lkxfS1aPkLdMl9HoVQ==
X-Received: by 2002:a05:6808:198a:b0:39e:deb3:e1f with SMTP id bj10-20020a056808198a00b0039edeb30e1fmr6248467oib.40.1687243171988;
        Mon, 19 Jun 2023 23:39:31 -0700 (PDT)
Received: from [10.94.58.170] ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id jn9-20020a170903050900b001b679ec20f2sm843151plb.31.2023.06.19.23.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 23:39:31 -0700 (PDT)
Message-ID: <8ac1034d-4ddf-86a6-a7dc-769bc5080fac@bytedance.com>
Date: Tue, 20 Jun 2023 14:39:20 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Content-Language: en-US
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Eric Dumazet <edumazet@google.com>, Tejun Heo <tj@kernel.org>,
 Christian Warloe <cwarloe@google.com>, Wei Wang <weiwan@google.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao
 <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Martin KaFai Lau <martin.lau@kernel.org>, Xin Long <lucien.xin@gmail.com>,
 Jason Xing <kernelxing@tencent.com>, Michal Hocko <mhocko@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, open list
 <linux-kernel@vger.kernel.org>,
 "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
 <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
 <4p22vtjrpu4obmbjivgpe635gbpjmhsfisnxghgsson2g6yy5r@ovawhchw7maq>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <4p22vtjrpu4obmbjivgpe635gbpjmhsfisnxghgsson2g6yy5r@ovawhchw7maq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Michal,

On 6/20/23 1:30 AM, Michal Koutný wrote:
> On Tue, Jun 13, 2023 at 02:46:32PM +0800, Abel Wu <wuyun.abel@bytedance.com> wrote:
>> Memory protection (memory.{min,low}) helps the important jobs less
>> affected by memstalls. But once low priority jobs use lots of kernel
>> memory like sockmem, the protection might become much less efficient.
> 
> What would happen if you applied memory.{min,low} to the important jobs
> and memory.{max,high} to the low prio ones?

I might expect that the memory of low prio jobs gets reclaimed first.
Specifically we set memory.low to protect the working-set for important
jobs. Due to the best-effort behavior of 'low', the important jobs can
still be affected if not enough memory reclaimed from the low prio ones.
And we don't use 'min' (yet?) because the need for flexibility when
memory is tight.

Best Regards,
	Abel

