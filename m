Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3349515DBC
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfEGGuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:50:01 -0400
Received: from ozlabs.org ([203.11.71.1]:41283 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfEGGuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 02:50:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44yqwl0wf4z9sB8;
        Tue,  7 May 2019 16:49:58 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: selftests/bpf/test_tag takes ~30 minutes?
In-Reply-To: <ec8bdc06-8f61-aab8-9b1d-73045ccb3b64@iogearbox.net>
References: <87bm0nbpdu.fsf@concordia.ellerman.id.au> <ec8bdc06-8f61-aab8-9b1d-73045ccb3b64@iogearbox.net>
Date:   Tue, 07 May 2019 16:49:58 +1000
Message-ID: <87pnouwyg9.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:
> On 04/30/2019 03:21 PM, Michael Ellerman wrote:
>> Hi Daniel,
>> 
>> I'm running selftests/bpf/test_tag and it's taking roughly half an hour
>> to complete, is that expected?
>> 
>> I don't really grok what the test is doing TBH, but it does appear to be
>> doing it 5 times :)
>> 
>> 	for (i = 0; i < 5; i++) {
>> 		do_test(&tests, 2, -1,     bpf_gen_imm_prog);
>> 		do_test(&tests, 3, fd_map, bpf_gen_map_prog);
>> 	}
>> 
>> Could we make it just do one iteration by default? That would hopefully
>> reduce the runtime by quite a bit. It could take a parameter to run the
>> longer version perhaps?
>
> On my 2.5 years old laptop it's taking 16 seconds. ;)

Hrm. I guess I need to dig into why it's taking so long then :)

Today it takes 10s on the same machine :/

Is it affected by the BPF JIT being enabled/disabled?

cheers
