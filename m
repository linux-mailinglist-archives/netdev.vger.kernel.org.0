Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636AD367F8D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 13:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbhDVL12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 07:27:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:47276 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbhDVL11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 07:27:27 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZXTu-0008xz-3q; Thu, 22 Apr 2021 13:26:50 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lZXTt-000Xio-PL; Thu, 22 Apr 2021 13:26:49 +0200
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Shaun Crampton <shaun@tigera.io>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net>
 <20210421230858.ruwqw5jvsy7cjioy@apollo>
 <21c55619-e26d-d901-076e-20f55302c2fd@iogearbox.net>
 <20210421233054.sgs5lemcuycx4vjb@apollo>
 <b504c839-d698-19a2-2018-05f867a8ff84@iogearbox.net>
 <CAMhR0U1DRBw5AjzzLfN+bpnxsrONO_Jkr9p57yfeyCND+qMAtQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5ee2c8e7-1ced-6103-99fa-213718bbb601@iogearbox.net>
Date:   Thu, 22 Apr 2021 13:26:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMhR0U1DRBw5AjzzLfN+bpnxsrONO_Jkr9p57yfeyCND+qMAtQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26147/Wed Apr 21 13:06:05 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 11:47 AM, Shaun Crampton wrote:
>> Nope, just get it from the prog itself.
> 
> Looks like the API returns the prog ID, so from that we can look up the prog
> and then get its tag? If so that meets our needs.  Alternatively, if
> the API allows
> for atomic replacement of a BPF program with another, that'd also work for us.

Both is the case: from prog ID you can already retrieve that same tag, and progs
can be atomically replaced with the current API code.

Exposing the tag in here otherwise feels just odd/wrong from a design PoV, explain
that to a user of this API on /why/ such field is in the tc API when it already
can be retrieved via bpf_prog_get_info_by_fd(), as in, what is so special on this
field in the tc API here (aside from legacy reasons when there was no mentioned
helper [which we don't need to support given it dates way too far back]) ... I
cannot. ;-) Hence lets drop it from there.

Thanks,
Daniel
