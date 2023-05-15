Return-Path: <netdev+bounces-2803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 52345703F6A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 23:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11113281490
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D060519BB4;
	Mon, 15 May 2023 21:13:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F861FBE;
	Mon, 15 May 2023 21:13:05 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72F2A256;
	Mon, 15 May 2023 14:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=UigK/88z5LMRn78twYOLrB800XL3mo+Rb9t3mzevDFY=; b=fdxziww4m4drj/drtxHRHpiBPM
	9DQZ31Dm5oVywZ6AEVlt9PrTf2bsjozCRt7/wLIBGuyMjdrFGF0fEQgxf25HT7XCfQqVzJpBylKxM
	x7rqqLoIOdee13C4bsj2zl8AzPIUSk0npE/HNlFauL0igNm1P6UNJYC8kbPMrfrywQGqgK4dnIKc1
	9HxrrTUZgA7VZTOEvGy9wGHG8yCI/bHJ7b53peKw7MCjKnXjhLH41XPpjggF9z6hhRbh4o0Yy941K
	hKnfvwHZsvIqXJjwJbunVqYdm2XNiv1EDNemXV5uUKSmJ2JjM8XOELW4BgVESutfEsxwpZ26HuuHz
	FtuQHEFw==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1pyfV0-000Hrv-BV; Mon, 15 May 2023 23:12:54 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1pyfUz-000Fcl-JV; Mon, 15 May 2023 23:12:53 +0200
Subject: Re: [PATCH bpf-next 00/10] seltests/xsk: prepare for AF_XDP
 multi-buffer testing
To: Magnus Karlsson <magnus.karlsson@gmail.com>, magnus.karlsson@intel.com,
 bjorn@kernel.org, ast@kernel.org, netdev@vger.kernel.org,
 maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
 andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
 haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
References: <20230512092043.3028-1-magnus.karlsson@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9e553914-3703-8f10-b3b8-7d7e90462417@iogearbox.net>
Date: Mon, 15 May 2023 23:12:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230512092043.3028-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26907/Mon May 15 09:25:12 2023)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Magnus,

On 5/12/23 11:20 AM, Magnus Karlsson wrote:
> 
> Prepare the AF_XDP selftests test framework code for the upcoming
> multi-buffer support in AF_XDP. This so that the multi-buffer patch
> set does not become way too large. In that upcoming patch set, we are
> only including the multi-buffer tests together with any framework
> code that depends on the new options bit introduced in the AF_XDP
> multi-buffer implementation itself.
> 
> Currently, the test framework is based on the premise that a packet
> consists of a single fragment and thus occupies a single buffer and a
> single descriptor. Multi-buffer breaks this assumption, as that is the
> whole purpose of it. Now, a packet can consist of multiple buffers and
> therefore consume multiple descriptors.
> 
> The patch set starts with some clean-ups and simplifications followed
> by patches that make sure that the current code works even when a
> packet occupies multiple buffers. The actual code for sending and
> receiving multi-buffer packets will be included in the AF_XDP
> multi-buffer patch set as it depends on a new bit being used in the
> options field of the descriptor.
> 
> Patch set anatomy:
> 1: The XDP program was unnecessarily changed many times. Fixes this.
> 
> 2: There is no reason to generate a full UDP/IPv4 packet as it is
>     never used. Simplify the code by just generating a valid Ethernet
>     frame.
> 
> 3: Introduce a more complicated payload pattern that can detect
>     fragments out of bounds in a multi-buffer packet and other errors
>     found in single-fragment packets.
> 
> 4: As a convenience, dump the content of the faulty packet at error.
> 
> 5: To simplify the code, make the usage of the packet stream for Tx
>     and Rx more similar.
> 
> 6: Store the offset of the packet in the buffer in the struct pkt
>     definition instead of the address in the umem itself and introduce
>     a simple buffer allocator. The address only made sense when all
>     packets consumed a single buffer. Now, we do not know beforehand
>     how many buffers a packet will consume, so we instead just allocate
>     a buffer from the allocator and specify the offset within that
>     buffer.
> 
> 7: Test for huge pages only once instead of before each test that needs it.
> 
> 8: Populate the fill ring based on how many frags are needed for each
>     packet.
> 
> 9: Change the data generation code so it can generate data for
>     multi-buffer packets too.
> 
> 10: Adjust the packet pacing algorithm so that it can cope with
>      multi-buffer packets. The pacing algorithm is present so that Tx
>      does not send too many packets/frames to Rx that it starts to drop
>      packets. That would ruin the tests.

This triggers build error in BPF CI:

   https://github.com/kernel-patches/bpf/actions/runs/4984982413/jobs/8924047266

   [...]
   xskxceiver.c:1881:2: error: variable 'ret' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
           default:
           ^~~~~~~
   xskxceiver.c:1885:6: note: uninitialized use occurs here
           if (ret == TEST_PASS)
               ^~~
   xskxceiver.c:1779:9: note: initialize the variable 'ret' to silence this warning
     GEN-SKEL [test_progs] test_subskeleton.skel.h
     GEN-SKEL [test_progs] test_subskeleton_lib.skel.h
           int ret;
                  ^
                   = 0
   1 error generated.
   make: *** [Makefile:617: /tmp/work/bpf/bpf/tools/testing/selftests/bpf/xskxceiver] Error 1
   make: *** Waiting for unfinished jobs....
     GEN-SKEL [test_progs] test_usdt.skel.h
   make: Leaving directory '/tmp/work/bpf/bpf/tools/testing/selftests/bpf'

Pls fix and respin, thanks.

