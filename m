Return-Path: <netdev+bounces-4703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC69570DF41
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A77E71C20DD4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCDA576C3;
	Tue, 23 May 2023 14:31:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EB228C32;
	Tue, 23 May 2023 14:31:35 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A815FA;
	Tue, 23 May 2023 07:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=PgTAlk789B2je/R+T+tN93jTtxuoHPYsG6W9waWQK2A=; b=jSTrr/U4wdQ/2VFvQhy8KOq4F1
	BoALMZKdtPDm9a3YktBMuNezLuZhob602iZf4foYSuf6ih7k4JpZ/m+M2XoBs0Y1ZCsnW9v1Za6qU
	AZN2i3oNrCD9RZ8qO3m+3TYwkVmeio/D2osNRALEl6EVDUHLWaJC3uDznzWF8Zwj007OYWAxyRnPd
	U+BLE0tlLFz9fphQEMZCyTXmBne+snsQKKqUOh+thWIXHofKqIfdRiqjCKEIOvhJQQmBUMrWbv4mU
	GamlabBDaE/3gCRPLiuDic6C7qiUciRQxXENElhFUC65icCg3cVTdN0sd/5Q8jlTU14sJk395l4US
	p5fEJJhw==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q1T2w-000IHA-Vq; Tue, 23 May 2023 16:31:30 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q1T2w-000T3T-GM; Tue, 23 May 2023 16:31:30 +0200
Subject: Re: [PATCH bpf v10 00/14] bpf sockmap fixes
To: John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com,
 ast@kernel.org, andrii@kernel.org, will@isovalent.com
References: <20230523025618.113937-1-john.fastabend@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <27cabfca-33e9-8883-ad9c-7a7731c82b0b@iogearbox.net>
Date: Tue, 23 May 2023 16:31:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230523025618.113937-1-john.fastabend@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26916/Tue May 23 09:22:39 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/23/23 4:56 AM, John Fastabend wrote:
> v10, CI noticed build error with old headers.

Applied, thanks everyone!

