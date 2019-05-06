Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86ACE147A8
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 11:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFJdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 05:33:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:39608 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfEFJdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 05:33:23 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNZzs-0000GF-MA; Mon, 06 May 2019 11:33:20 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNZzs-000Xb2-FZ; Mon, 06 May 2019 11:33:20 +0200
Subject: Re: selftests/bpf/test_tag takes ~30 minutes?
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <87bm0nbpdu.fsf@concordia.ellerman.id.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ec8bdc06-8f61-aab8-9b1d-73045ccb3b64@iogearbox.net>
Date:   Mon, 6 May 2019 11:33:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <87bm0nbpdu.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/30/2019 03:21 PM, Michael Ellerman wrote:
> Hi Daniel,
> 
> I'm running selftests/bpf/test_tag and it's taking roughly half an hour
> to complete, is that expected?
> 
> I don't really grok what the test is doing TBH, but it does appear to be
> doing it 5 times :)
> 
> 	for (i = 0; i < 5; i++) {
> 		do_test(&tests, 2, -1,     bpf_gen_imm_prog);
> 		do_test(&tests, 3, fd_map, bpf_gen_map_prog);
> 	}
> 
> Could we make it just do one iteration by default? That would hopefully
> reduce the runtime by quite a bit. It could take a parameter to run the
> longer version perhaps?

On my 2.5 years old laptop it's taking 16 seconds. ;) I'm okay if we
reduce the runs and add a long version via cmdline param. It's basically
comparing the sha based tag generation from the BPF core with plain AF_ALG
from crypto subsys over the same insn sequence to make sure both match fine.

Thanks,
Daniel
