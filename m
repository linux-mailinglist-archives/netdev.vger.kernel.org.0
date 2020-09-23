Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A9E276371
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWWAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:00:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:48984 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIWWAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:00:46 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLCoU-0007jR-1Z; Thu, 24 Sep 2020 00:00:34 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLCoT-000BI3-Ri; Thu, 24 Sep 2020 00:00:33 +0200
Subject: Re: Keep bpf-next always open
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
References: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
 <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d8efb658-7aef-f742-24ff-adca53dc17d8@iogearbox.net>
Date:   Thu, 24 Sep 2020 00:00:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25936/Wed Sep 23 15:55:51 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 11:48 PM, Andrii Nakryiko wrote:
> On Wed, Sep 23, 2020 at 2:20 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> BPF developers,
>>
>> The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In the past we
>> observed a rush of patches to get in before bpf-next closes for the duration of
>> the merge window. Then there is a flood of patches right after bpf-next
>> reopens. Both periods create unnecessary tension for developers and maintainers.
>> In order to mitigate these issues we're planning to keep bpf-next open
>> during upcoming merge window and if this experiment works out we will keep
>> doing it in the future. The problem that bpf-next cannot be fully open, since
>> during the merge window lots of trees get pulled by Linus with inevitable bugs
>> and conflicts. The merge window is the time to fix bugs that got exposed
>> because of merges and because more people test torvalds/linux.git than
>> bpf/bpf-next.git.
>>
>> Hence starting roughly one week before the merge window few risky patches will
>> be applied to the 'next' branch in the bpf-next tree instead of
> 
> Riskiness would be up to maintainers to determine or should we mark
> patches with a different tag (bpf-next-next?) explicitly?

Imho, 'bpf-next-next' tag in subject line would be too confusing, so just sticking
to 'bpf-next' as-is and then up to maintainers whether to apply to master vs next
branch when we get to merge window time. We can see how that works out and adjust
later if necessary.

>> bpf-next/master. Then during the two weeks of the merge window the patches will
>> be reviewed as normal and will be applied to the 'next' branch as well. After
>> Linus cuts -rc1 and net-next reopens, we will fast forward bpf-next tree to
>> net-next tree and will try to merge the 'next' branch that accumulated the
>> patches over these three weeks. After fast-forward the bpf-next tree might look
>> very different vs its state before the merge window and there is a chance that
>> some of the patches in the 'next' branch will not apply. We will try to resolve
>> the conflicts as much as we can and apply them all. Essentially bpf-next/next
>> is a strong promise that the patches will land into bpf-next. This scheme will
>> allow developers to work on new features and post them for review and landing
>> regardless of the merge window or not. Having said that the bug fixing is
>> always a priority.
>>
>> We've considered creating a bpf-next-next.git tree for this purpose, but decided
>> that bpf-next/next branch will be easier for everyone.
>>
>> Thoughts and comments?
> 
> I like more continuous mode, thanks! bpf-next/next branch still means
> that libbpf on Github is effectively frozen for the duration of the
> merge window (merging an extra branch automatically is too much pain,
> we have enough fun with bpf and bpf-next trees), but let's see how it
> goes.
