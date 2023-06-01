Return-Path: <netdev+bounces-7214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB00271F15E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:08:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 753AD2818A7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A44864823C;
	Thu,  1 Jun 2023 18:08:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C6D4701B;
	Thu,  1 Jun 2023 18:08:04 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F8D123;
	Thu,  1 Jun 2023 11:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=515CNbKAiQFmrnoi+myJfxe8Z6RUoGqdRGLDXXV+zjk=; b=NPKM62b9Wnxzwu4Fno7Ngf0s7L
	ZZGS35QM7+74hD0/FOEegZ/g9WKZaMRyJF0eB2BPfQkCqgSf2HbERWv/JcmNtkLban31CMH3qhI/J
	MPZ77m+OK2PojuRuWgBukXgMN5ziuNrD6nw8H1gV71rKysLJ0FkvwiUn+AdiVxPKUu5dMoNmwjQLZ
	ZMqgCP9Cztt2CoiN87wh3scbFgsmM4vClvKTJmW8Ef73TvHHo+jlFiinxirJTLW9yph2cambSBK/K
	gwdn4le/OgujYxOlTQ8/Jhpt8Bh/NJUfKMAjKKdEC4xzPAhqF6ufWW3k0dFvAp+wgWItasuNC3FYQ
	6sJitrjA==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q4miN-000PSI-2H; Thu, 01 Jun 2023 20:07:58 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q4miM-0002in-J8; Thu, 01 Jun 2023 20:07:58 +0200
Subject: Re: [PATCH v2 0/2] bpf: utilize table ID in bpf_fib_lookup helper
To: Louis DeLosSantos <louis.delos.devel@gmail.com>, bpf@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
 Stanislav Fomichev <sdf@google.com>, razor@blackwall.org,
 John Fastabend <john.fastabend@gmail.com>, Yonghong Song <yhs@meta.com>
References: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c86e21df-2856-8b11-f8ce-b23769e3b877@iogearbox.net>
Date: Thu, 1 Jun 2023 20:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v2-0-0a31c22c748c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26925/Thu Jun  1 09:27:46 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/31/23 9:38 PM, Louis DeLosSantos wrote:
> This patchset adds the ability to specify a table ID to the
> `bpf_fib_lookup` BPF helper.

LGTM, and this is a very useful extension, applied thanks!

