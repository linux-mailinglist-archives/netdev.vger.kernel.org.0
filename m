Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16216145916
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgAVPzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:55:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:33548 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgAVPzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 10:55:41 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuILv-0004Kh-96; Wed, 22 Jan 2020 16:55:35 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuILv-000HJ3-0O; Wed, 22 Jan 2020 16:55:35 +0100
Subject: Re: [PATCH bpf-next] bpf: Fix trampoline usage in preempt
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     jannh@google.com, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
References: <20200121032231.3292185-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ab7d6f3-fc97-cb29-cf77-7d0d9b70e9ca@iogearbox.net>
Date:   Wed, 22 Jan 2020 16:55:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200121032231.3292185-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25703/Wed Jan 22 12:37:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/20 4:22 AM, Alexei Starovoitov wrote:
> Though the second half of trampoline page is unused a task could be
> preempted in the middle of the first half of trampoline and two
> updates to trampoline would change the code from underneath the
> preempted task. Hence wait for tasks to voluntarily schedule or go
> to userspace.
> Add similar wait before freeing the trampoline.
> 
> Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Applied, thanks!
