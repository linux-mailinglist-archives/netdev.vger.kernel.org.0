Return-Path: <netdev+bounces-8517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB277246E4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90E19280F70
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0BC71E528;
	Tue,  6 Jun 2023 14:54:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DC61B8FA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:54:30 +0000 (UTC)
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F6810CA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:54:06 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-ba8374001abso6944214276.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 07:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686063245; x=1688655245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7UebjJiEriep1eTAlD1huPfb0FQGz+rK49aASRy6Hlo=;
        b=FC5Bh7r0qDmhwAP1NrNOGdp0BQXyj9/5/fgMCmyIOnyP46LWgSNINmR5YcCak3fNVE
         Hu/vlD4PTDSVwV8wUjWw+wOq10bNp4AmcAgx/Lab5kxwSaJ+1LBKCu4aq2hph63R89cA
         fVjPsd3Qbm6bpiL2+2yQP7XZvKBctYjaajHHw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686063245; x=1688655245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UebjJiEriep1eTAlD1huPfb0FQGz+rK49aASRy6Hlo=;
        b=jGKCT4qNo6wp6IcgChr2IoOYag3olUKrvHF90zjZpvLpj4NVKXXRJKWABGXu7m5hoh
         wC+8Cs5Bvv7oKJFtjCT2Ple6xNH3dtVfcROxfF1XzzaGrSI83vG6aMrP4dOnGwkfORfm
         0oMVANgKHuWpRwHXG382H2qXa/+o/fEnO9ytdcxuj/YsfRXZ2owqD5H+cD2ZWfLEQG03
         DeJTndIFtwxtiVmfJRsBB5cA3JcH2Zpq0jrnNlInDknhND0507vvGHBROPQ+9zjkT5PV
         XqsBLc5+E2udk7iVP4TBiyFI45UVyCNCgw5d6EAg3zfmkY6SGGR1kjPuYZMssnWtOcnA
         pfQA==
X-Gm-Message-State: AC+VfDz7E18LQqCmRFUAeaw1DH3/jc7XnFEuQgQDttZQ/rsUmUXmX0ec
	CofdxTVG4g6KZfMPWsTyakUCRA==
X-Google-Smtp-Source: ACHHUZ70hBhfrEp2BOIKMO3sqtOg1CAXZuCAS0g+fFLSkgnKjRhM/Vzinzr7aFZzECo1YTWvcxDwow==
X-Received: by 2002:a81:6f07:0:b0:565:1058:abbd with SMTP id k7-20020a816f07000000b005651058abbdmr2554089ywc.35.1686063245436;
        Tue, 06 Jun 2023 07:54:05 -0700 (PDT)
Received: from [192.168.2.144] ([169.197.147.212])
        by smtp.gmail.com with ESMTPSA id d3-20020a816803000000b00568e7e21db7sm4127402ywc.96.2023.06.06.07.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 07:54:05 -0700 (PDT)
Message-ID: <c83bac54-e40b-cca5-4bb4-742f3dc90440@cloudflare.com>
Date: Tue, 6 Jun 2023 09:54:03 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] Add a sysctl to allow TCP window shrinking in order to
 honor memory limits
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20230605203857.1672816-1-mfreemon@cloudflare.com>
 <20230605154229.6077983e@hermes.local>
Content-Language: en-US
From: Mike Freemon <mfreemon@cloudflare.com>
In-Reply-To: <20230605154229.6077983e@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 6/5/23 17:42, Stephen Hemminger wrote:
> On Mon,  5 Jun 2023 15:38:57 -0500
> Mike Freemon <mfreemon@cloudflare.com> wrote:
> 
>> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
>>
>> Under certain circumstances, the tcp receive buffer memory limit
>> set by autotuning is ignored, and the receive buffer can grow
>> unrestrained until it reaches tcp_rmem[2].
>>
>> To reproduce:  Connect a TCP session with the receiver doing
>> nothing and the sender sending small packets (an infinite loop
>> of socket send() with 4 bytes of payload with a sleep of 1 ms
>> in between each send()).  This will fill the tcp receive buffer
>> all the way to tcp_rmem[2], ignoring the autotuning limit
>> (sk_rcvbuf).
>>
>> As a result, a host can have individual tcp sessions with receive
>> buffers of size tcp_rmem[2], and the host itself can reach tcp_mem
>> limits, causing the host to go into tcp memory pressure mode.
>>
>> The fundamental issue is the relationship between the granularity
>> of the window scaling factor and the number of byte ACKed back
>> to the sender.  This problem has previously been identified in
>> RFC 7323, appendix F [1].
>>
>> The Linux kernel currently adheres to never shrinking the window.
>>
>> In addition to the overallocation of memory mentioned above, this
>> is also functionally incorrect, because once tcp_rmem[2] is
>> reached, the receiver will drop in-window packets resulting in
>> retransmissions and an eventual timeout of the tcp session.  A
>> receive buffer full condition should instead result in a zero
>> window and an indefinite wait.
>>
>> In practice, this problem is largely hidden for most flows.  It
>> is not applicable to mice flows.  Elephant flows can send data
>> fast enough to "overrun" the sk_rcvbuf limit (in a single ACK),
>> triggering a zero window.
>>
>> But this problem does show up for other types of flows.  A good
>> example are websockets and other type of flows that send small
>> amounts of data spaced apart slightly in time.  In these cases,
>> we directly encounter the problem described in [1].
>>
>> RFC 7323, section 2.4 [2], says there are instances when a retracted
>> window can be offered, and that TCP implementations MUST ensure
>> that they handle a shrinking window, as specified in RFC 1122,
>> section 4.2.2.16 [3].  All prior RFCs on the topic of tcp window
>> management have made clear that sender must accept a shrunk window
>> from the receiver, including RFC 793 [4] and RFC 1323 [5].
>>
>> This patch implements the functionality to shrink the tcp window
>> when necessary to keep the right edge within the memory limit by
>> autotuning (sk_rcvbuf).  This new functionality is enabled with
>> the following sysctl:
>>
>> sysctl: net.ipv4.tcp_shrink_window
>>
>> This sysctl changes how the TCP window is calculated.
>>
>> If sysctl tcp_shrink_window is zero (the default value), then the
>> window is never shrunk.
>>
>> If sysctl tcp_shrink_window is non-zero, then the memory limit
>> set by autotuning is honored.  This requires that the TCP window
>> be shrunk ("retracted") as described in RFC 1122.
>>
>> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
>> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
>> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
>> [4] https://www.rfc-editor.org/rfc/rfc793
>> [5] https://www.rfc-editor.org/rfc/rfc1323
>>
>> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> 
> Does Linux TCP really need another tuning parameter?

It's useful to make testing faster, i.e. comparing enabled vs disabled.
It could also be useful as a quick diagnostic test, i.e. someone is
having a problem and they want to quickly eliminate this patch as a
cause.

But I left it in mainly as a risk response.  This patch requires that
the receiving TCP implementation handle the shrinking window correctly.  
This patch has been deployed at Cloudflare and we have not discovered
any cases where the peer TCP fails to be RFC compliant.  But we cannot
rule out the possibility completely.  The concern is what if someone is
running some old software on a non-public network and their software
does not handle a shrinking window.  Simply disabling this feature via
a sysctl parameter seems like a good solution for that situation.

If the consensus is to not have a sysctl parameter, I am happy to
remove it.

A related question:  If we leave it in, what do we think the default
value should be?  It's disabled by default right now, but that is just
me being conservative.  If we are comfortable enabling this by default,
I'm happy to do that too.

> Will tests get run with both feature on and off?

More background and details about the patch is here, including the test
results you're looking for:
https://blog.cloudflare.com/unbounded-memory-usage-by-tcp-for-receive-buffers-and-how-we-fixed-it/

> What default will distributions ship with?

I'm not sure how to answer this.  Isn't that up to the distributions to decide?

