Return-Path: <netdev+bounces-618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 976DB6F8918
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C062810CC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDEEC8E4;
	Fri,  5 May 2023 18:54:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BF12F33
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:54:30 +0000 (UTC)
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAA9226AE;
	Fri,  5 May 2023 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1683312862;
	bh=X3mGffREaWVeATl3zMMUiUzS4LSvCI/gVo9z8P7mjRk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LEFsNIIr+Duxnv3+wGVwXtrVVO/Rc894j1ZO30NrKlGwyJbjC1IYhwi7fYTxGbuuc
	 guRAj2p1iGiMcfckbwVBs5ojUMM84O1Jm8kIqKPAgzUAviT4EE+KnvhSbsxDUcRkUV
	 JuDrZJfwvu+LP03tykx+8Mte7uATOB1/QLlpsP1fATcLuPkSU5qdvqrbNfsZPgHocz
	 JnbRm2UTXepM5RPFvvTFcxUPPYoxXE1oQqaLYwILhM5GFQHEMm738BzofX+MsIGbP7
	 Tz9lTH+TezejkYOJUjzTXykz3BcL1VpgGrJDg/oUzZx8odRvTfQetuM3k+ZelR/1/9
	 2lEDG+8yArw5A==
Received: from [172.16.0.99] (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4QCfxB21Q4z11ZT;
	Fri,  5 May 2023 14:54:22 -0400 (EDT)
Message-ID: <501fdd3e-9f95-0d31-88c3-99f559118142@efficios.com>
Date: Fri, 5 May 2023 14:54:26 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 11/13] netdevice.h: Fix parentheses around macro
 parameter use
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20230504200527.1935944-1-mathieu.desnoyers@efficios.com>
 <20230504200527.1935944-12-mathieu.desnoyers@efficios.com>
 <20230505114445.49082b62@kernel.org>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20230505114445.49082b62@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-05 14:44, Jakub Kicinski wrote:
> On Thu,  4 May 2023 16:05:25 -0400 Mathieu Desnoyers wrote:
>> Add missing parentheses around macro parameter use in the following
>> pattern:
>>
>> - "x - 1" changed for "(x) - 1",
>> - "x->member" changed for "(x)->member".
>>
>> to ensure operator precedence behaves as expected.
>>
>> Remove useless parentheses around macro parameter use in the following
>> pattern:
>>
>> - m((x), y) changed for m(x, y), because comma has the lowest operator
>>    precedence, which makes the extra comma useless.
> 
> Sure, why not. Can we take it via netdev, tho?
> I can't have any dependencies, right?

I'll note your Acked-by in my patch for the next round. When I post 
without RFC tag it will be ready for merging. There is still some 
high-level feedback I want to gather on the overall series before I 
remove the RFC tag.

There are no dependencies, each patch in this series only target a 
single header, and there are no dependencies across those patches.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


