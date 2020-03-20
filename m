Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018EE18D8D2
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCTUHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:07:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:39318 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgCTUHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:07:30 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFNvR-0006Vm-I2; Fri, 20 Mar 2020 21:07:25 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFNvR-0009xC-4J; Fri, 20 Mar 2020 21:07:25 +0100
Subject: Re: [PATCH] bpf: explicitly memset the bpf_attr structure
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>
References: <20200320094813.GA421650@kroah.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <cea7babd-48a6-d89a-c93b-32659d6d8a28@iogearbox.net>
Date:   Fri, 20 Mar 2020 21:07:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200320094813.GA421650@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25757/Fri Mar 20 14:13:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/20/20 10:48 AM, Greg Kroah-Hartman wrote:
> For the bpf syscall, we are relying on the compiler to properly zero out
> the bpf_attr union that we copy userspace data into.  Unfortunately that
> doesn't always work properly, padding and other oddities might not be
> correctly zeroed, and in some tests odd things have been found when the
> stack is pre-initialized to other values.
> 
> Fix this by explicitly memsetting the structure to 0 before using it.
> 
> Reported-by: Maciej Żenczykowski <maze@google.com>
> Reported-by: John Stultz <john.stultz@linaro.org>
> Reported-by: Alexander Potapenko <glider@google.com>
> Reported-by: Alistair Delva <adelva@google.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://android-review.googlesource.com/c/kernel/common/+/1235490
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied, thanks!
