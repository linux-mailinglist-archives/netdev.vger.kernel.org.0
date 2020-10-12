Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9E28C4BF
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388856AbgJLW2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:28:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:50556 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388361AbgJLW2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:28:41 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kS6J2-0005dl-Ec; Tue, 13 Oct 2020 00:28:36 +0200
Received: from [2a02:1205:5048:a230:688e:a88c:2b15:ece2] (helo=pc-95.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kS6J2-000S4U-6d; Tue, 13 Oct 2020 00:28:36 +0200
Subject: Re: [PATCH bpf-next] xsk: introduce padding between ring pointers
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
References: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com>
 <43b0605d-f0c9-b81c-4d16-344a7832e083@iogearbox.net>
 <CAJ8uoz3nfDe0a9Vp0NmnHVv5qM+kvqR-f6Yd0keKSqctNzi6=g@mail.gmail.com>
 <CAJ8uoz1Z4dpaoK5th092gid+xbcp1Rz1wkPXZuuceh5y0wvKYw@mail.gmail.com>
 <CAJ8uoz0V+nLc7KVe9NjZJ6FpKxJUcubm7K699g1C70+tLuWJpQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <169cf549-1adc-0b75-4fc1-52d2a110a6a7@iogearbox.net>
Date:   Tue, 13 Oct 2020 00:28:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz0V+nLc7KVe9NjZJ6FpKxJUcubm7K699g1C70+tLuWJpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25955/Mon Oct 12 15:49:06 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 1:13 PM, Magnus Karlsson wrote:
[...]
> Nope, that was a bad idea. After measuring, this one produces worse
> performance than the original suggestion with padding in between all
> members. Cannot explain why at the moment, but the numbers are
> convincing and above noise level for sure. So let us keep this one:
> 
> u32 producer ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> u32 consumer ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> u32 flags ____cacheline_aligned_in_smp;
> ____cacheline_padding_in_smp;
> 
>>> Do you want to submit a patch, or shall I do it? I like your
>>> ____cacheline_padding_in_smp better than my explicit "padN" member.

Ok, feel free to go for it.

Thanks,
Daniel
