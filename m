Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445EF164B07
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 17:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgBSQw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 11:52:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:40848 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgBSQw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 11:52:28 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4SaG-0005EC-ES; Wed, 19 Feb 2020 17:52:24 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4SaF-000Jq9-VN; Wed, 19 Feb 2020 17:52:24 +0100
Subject: Re: [PATCH bpf-next 0/6] bpftool: Allow to select sections and filter
 probes
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Michal Rostecki <mrostecki@opensuse.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200218190224.22508-1-mrostecki@opensuse.org>
 <CAADnVQJm_tvMGjhHyVn66feA3rHLSXTdzqCCABu+9tKer89LVA@mail.gmail.com>
 <06ae3070-0d35-df49-9310-d1fb7bfb3e67@opensuse.org>
 <CAADnVQLhEaV=dWMZC83g5QHit7Qvu4H84Dh--K3aOTiUNeEd4g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <498282f3-7e75-c24d-513d-be97b165b01f@iogearbox.net>
Date:   Wed, 19 Feb 2020 17:52:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQLhEaV=dWMZC83g5QHit7Qvu4H84Dh--K3aOTiUNeEd4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25728/Wed Feb 19 15:06:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 5:37 PM, Alexei Starovoitov wrote:
> On Wed, Feb 19, 2020 at 4:33 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>>
>> On 2/19/20 4:02 AM, Alexei Starovoitov wrote:
>>> The motivation is clear, but I think the users shouldn't be made
>>> aware of such implementation details. I think instead of filter_in/out
>>> it's better to do 'full or safe' mode of probing.
>>> By default it can do all the probing that doesn't cause
>>> extra dmesgs and in 'full' mode it can probe everything.
>>
>> Alright, then I will send later v2 where the "internal" implementation
>> (filtering out based on regex) stays similar (filter_out will stay in
>> the code without being exposed to users, filter_in will be removed). And
>> the exposed option of "safe" probing will just apply the
>> "(trace|write_user)" filter_out pattern. Does it sound good?
> 
> yes. If implementation is doing filter_in and applying 'trace_printk|write_user'
> strings hidden within bpftool than I think it should be good.
> What do you think the default should be?
> It feels to me that the default should not be causing dmesg prints.
> So only addition flag for bpftool command line will be 'bpftool
> feature probe full'

Agree, that makes sense to me.
