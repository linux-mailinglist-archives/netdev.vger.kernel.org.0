Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7931D10EB3
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfEAVoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:44:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:43006 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfEAVoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:44:22 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hLx1R-0008PH-NM; Wed, 01 May 2019 23:44:13 +0200
Received: from [173.228.226.134] (helo=localhost.localdomain)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hLx1R-000OV8-8R; Wed, 01 May 2019 23:44:13 +0200
Subject: Re: [PATCH v2] bpf, x32: Fix bug for BPF_JMP | {BPF_JSGT, BPF_JSLE,
 BPF_JSLT, BPF_JSGE}
To:     Wang YanQing <udknight@gmail.com>, ast@kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, tglx@linutronix.de,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190427082826.GA16311@udknight>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aca27db2-5c16-6bf8-e601-be8b42678cd4@iogearbox.net>
Date:   Wed, 1 May 2019 23:44:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190427082826.GA16311@udknight>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25436/Wed May  1 09:58:19 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/27/2019 10:28 AM, Wang YanQing wrote:
> The current method to compare 64-bit numbers for conditional jump is:
> 
> 1) Compare the high 32-bit first.
> 
> 2) If the high 32-bit isn't the same, then goto step 4.
> 
> 3) Compare the low 32-bit.
> 
> 4) Check the desired condition.
> 
> This method is right for unsigned comparison, but it is buggy for signed
> comparison, because it does signed comparison for low 32-bit too.
> 
> There is only one sign bit in 64-bit number, that is the MSB in the 64-bit
> number, it is wrong to treat low 32-bit as signed number and do the signed
> comparison for it.
> 
> This patch fixes the bug and adds a testcase in selftests/bpf for such bug.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>

Applied, thanks!
