Return-Path: <netdev+bounces-5660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4607125BE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10F4F1C21044
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD2E8476;
	Fri, 26 May 2023 11:40:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2A1742EA
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:40:57 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808D6E7;
	Fri, 26 May 2023 04:40:54 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id B9BEA5FD33;
	Fri, 26 May 2023 14:40:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685101250;
	bh=n2x4yjau1soFcfco90woNujVljdNR0rpU1zLVAOSyM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	b=QiFeUnJmQzxST7Eo7f4WbbpPTgf1DzVYdaSYuXVVy2W6rGiomiqPNQoaBVwFUoFYA
	 sDPdl/LSd8TRdKpSlu+JpVZG3UCLdV9hjxbfL5oW16+i2T4yh23vvbYmywgOFmcQaB
	 YJkGmeGkQ8OJ4q1cy3/om+lBjxQu1u4kAw7fUNERqF5BsySFTY+tGZn5oMIbmowzAI
	 GVjwZ3hLx7/TXp3T57fGm7f2tSs7bqQMmVsUcVomikBwUjDykFgN3/udy7I/21Qakb
	 oGcwX0Fs577IAtNXepODapC6y7EH+P2AtEmenX89JAg8/dkXdke7QOFaegVeSGkbD6
	 OnqpjPpNFhC6Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Fri, 26 May 2023 14:40:45 +0300 (MSK)
Message-ID: <4baf786b-afe5-371d-9bc4-90226e5df3af@sberdevices.ru>
Date: Fri, 26 May 2023 14:36:17 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 00/17] vsock: MSG_ZEROCOPY flag support
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
 <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
From: Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/26 06:32:00 #21351256
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 26.05.2023 13:30, Stefano Garzarella wrote:
> On Thu, May 25, 2023 at 06:56:42PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 22.05.2023 10:39, Arseniy Krasnov wrote:
>>
>> This patchset is unstable with SOCK_SEQPACKET. I'll fix it.
> 
> Thanks for let us know!
> 
> I'm thinking if we should start split this series in two, because it
> becomes too big.
> 
> But let keep this for RFC, we can decide later. An idea is to send
> the first 7 patches with a preparation series, and the next ones with a
> second series.

Hello, ok! So i'll split patchset in the following way:
1) Patches which adds new fields/flags and checks. But all of this is not used,
   as it is preparation.
2) Second part starts to use it and also carries tests.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 

