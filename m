Return-Path: <netdev+bounces-763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 019286F9C05
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 23:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EA16280EBA
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 21:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6F9848B;
	Sun,  7 May 2023 21:46:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A328F2
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 21:46:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A033C0B
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 14:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683495988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRVbumtTL0+M3sbUq4/VAYogRDf43BEUeshB5w8XYBM=;
	b=cY8dX4xMtyEfiWbPl1kEWIFChpcknXLNUJnbAGOd5+yKLivQpM3mPMRCQo9DpdTtaNM2hT
	h0PQqMmRbPFBA38a4fHCCfzE56so+8jbBn+709u6jKQOQSE4xyJUw9H6zXtXQju+5wU0U7
	D812CF1bt7rZO1mDPz3FeYKDHmhDmz0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-CH5c2GVlPju2PoUHDjyLJw-1; Sun, 07 May 2023 17:46:27 -0400
X-MC-Unique: CH5c2GVlPju2PoUHDjyLJw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-61b7ab3a8bbso23416536d6.1
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 14:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683495987; x=1686087987;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRVbumtTL0+M3sbUq4/VAYogRDf43BEUeshB5w8XYBM=;
        b=hpk1QMY2XW/xa3Ghim8NVv+6Yr9okH09l8prGoWo3NC8ttKBvedEnfekpjGU7sqVUI
         2IwNstYn2ub6JNcc0/O3Yk9tzOAGbkW/01Yl/mRDfCXTGM9rOTusBdfffGNoi4tiXH1T
         ct/njTHQ7Tkd/Y7elzPVbHS00s56eXIY3pwsRmDn77R7hfixXqvb7Po7UdSENZ/slZrl
         +foASwC+uRX5sb+b3vtvwVmeNzLb1TZLXD2Lm3S7j4YnH7oTdcBnS+o6T7tWF2ZmZJI/
         iLfecKY11jKizlnJsVeFql8RTWp2VK0UOpSlpb1+D3QqFChhNeZIq3AtYOSBQ7jd4TU+
         XVbg==
X-Gm-Message-State: AC+VfDyOvMIHHrvxsb+Gtlmh15QgloxF/S1eoFwWPKzH9++PrCYHKndq
	UI4d74VtRocmdpe3ofU4BQ7iWOFuur57zyVGo58MmJS2LR0pFVzuRdVVpFRV+G6ul1SxUYsl7Ni
	3S7l3lG8J0UG4mbVA
X-Received: by 2002:a05:622a:614:b0:3f2:1c13:b5a8 with SMTP id z20-20020a05622a061400b003f21c13b5a8mr12283827qta.50.1683495986871;
        Sun, 07 May 2023 14:46:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6f1o7fGePdhoGCZMVr1BKaQq2PNyBO7dAFIrbNmxOuPV6lWDsPAZKGYxijqvcBGTJe4licjg==
X-Received: by 2002:a05:622a:614:b0:3f2:1c13:b5a8 with SMTP id z20-20020a05622a061400b003f21c13b5a8mr12283807qta.50.1683495986598;
        Sun, 07 May 2023 14:46:26 -0700 (PDT)
Received: from [10.0.0.97] ([24.225.234.80])
        by smtp.gmail.com with ESMTPSA id j14-20020ac874ce000000b003e89e2b3c23sm2455384qtr.58.2023.05.07.14.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 14:46:26 -0700 (PDT)
Message-ID: <74fbee87-2d73-1fde-ee3b-97e8c7382d01@redhat.com>
Date: Sun, 7 May 2023 17:46:24 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCHv2 net 0/3] tipc: fix the mtu update in link mtu
 negotiation
Content-Language: en-US
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Tung Nguyen <tung.q.nguyen@dektech.com.au>
References: <cover.1683065352.git.lucien.xin@gmail.com>
From: Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <cover.1683065352.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-02 18:13, Xin Long wrote:
> This patchset fixes a crash caused by a too small MTU carried in the
> activate msg. Note that as such malicious packet does not exist in
> the normal env, the fix won't break any application
>
> The 1st patch introduces a function to calculate the minimum MTU for
> the bearer, and the 2nd patch fixes the crash with this helper. While
> at it, the 3rd patch fixes the udp bearer mtu update by netlink with
> this helper.
>
> Xin Long (3):
>    tipc: add tipc_bearer_min_mtu to calculate min mtu
>    tipc: do not update mtu if msg_max is too small in mtu negotiation
>    tipc: check the bearer min mtu properly when setting it by netlink
>
>   net/tipc/bearer.c    | 17 +++++++++++++++--
>   net/tipc/bearer.h    |  3 +++
>   net/tipc/link.c      |  9 ++++++---
>   net/tipc/udp_media.c |  5 +++--
>   4 files changed, 27 insertions(+), 7 deletions(-)
>
Series
Acked-by: Jon Maloy <jmaloy@redhat.com>


