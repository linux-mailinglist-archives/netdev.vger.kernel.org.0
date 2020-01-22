Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96FB145918
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:56:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:33914 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgAVP4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 10:56:19 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuIMZ-0004O7-Ev; Wed, 22 Jan 2020 16:56:16 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuIMZ-000Mk8-6E; Wed, 22 Jan 2020 16:56:15 +0100
Subject: Re: [PATCH bpf-next] bpf: Fix error path under memory pressure
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20200122024138.3385590-1-ast@kernel.org>
 <CAADnVQ+HdfXVHnEBMkqbtE2fm2drd+4b8otrJR+Qkqb3_3OGdQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <93031d04-097e-662c-bbf0-043fcb83f51c@iogearbox.net>
Date:   Wed, 22 Jan 2020 16:56:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+HdfXVHnEBMkqbtE2fm2drd+4b8otrJR+Qkqb3_3OGdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25703/Wed Jan 22 12:37:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/20 3:45 AM, Alexei Starovoitov wrote:
> On Tue, Jan 21, 2020 at 6:42 PM Alexei Starovoitov <ast@kernel.org> wrote:
>>
>> Restore the 'if (env->cur_state)' check that was incorrectly removed during
>> code move. Under memory pressure env->cur_state can be freed and zeroed inside
>> do_check(). Hence the check is necessary.
>>
>> Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Forgot to add:
> Reported-by: syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com
> 
> Daniel, pls add while applying.

Done & applied, thanks!
