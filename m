Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1007B4344
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 23:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbfIPVfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 17:35:52 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:52656 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728552AbfIPVfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 17:35:52 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46XKKt6p0Kz1r7hh;
        Mon, 16 Sep 2019 23:35:46 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46XKKt4s1Pz1qsD2;
        Mon, 16 Sep 2019 23:35:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id vL_Z3Yvzkzi9; Mon, 16 Sep 2019 23:35:45 +0200 (CEST)
X-Auth-Info: 7Yzorz4cL64cpIXYMwEei+hYY6VSe697biienY//MW0u7gRp/4RLUg4/7I3tvenS
Received: from igel.home (ppp-46-244-165-89.dynamic.mnet-online.de [46.244.165.89])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 16 Sep 2019 23:35:45 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
        id A03192C0173; Mon, 16 Sep 2019 23:35:44 +0200 (CEST)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v3 bpf-next 01/14] samples: bpf: makefile: fix HDR_PROBE "echo"
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
        <20190916105433.11404-2-ivan.khoronzhuk@linaro.org>
        <CAEf4BzZVTjCybmDgM0VBzv_L-LHtF8LcDyyKSWJm0ZA4jtJKcw@mail.gmail.com>
X-Yow:  I always wanted a NOSE JOB!!
Date:   Mon, 16 Sep 2019 23:35:44 +0200
In-Reply-To: <CAEf4BzZVTjCybmDgM0VBzv_L-LHtF8LcDyyKSWJm0ZA4jtJKcw@mail.gmail.com>
        (Andrii Nakryiko's message of "Mon, 16 Sep 2019 13:13:23 -0700")
Message-ID: <8736gvexfz.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sep 16 2019, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
> <ivan.khoronzhuk@linaro.org> wrote:
>>
>> echo should be replaced with echo -e to handle '\n' correctly, but
>> instead, replace it with printf as some systems can't handle echo -e.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> ---
>>  samples/bpf/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 1d9be26b4edd..f50ca852c2a8 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -201,7 +201,7 @@ endif
>>
>>  # Don't evaluate probes and warnings if we need to run make recursively
>>  ifneq ($(src),)
>> -HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
>> +HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
>
> printf change is fine, but I'm confused about \# at the beginning of
> the string.

From the NEWS of make 4.3:

* WARNING: Backward-incompatibility!
  Number signs (#) appearing inside a macro reference or function invocation
  no longer introduce comments and should not be escaped with backslashes:
  thus a call such as:
    foo := $(shell echo '#')
  is legal.  Previously the number sign needed to be escaped, for example:
    foo := $(shell echo '\#')
  Now this latter will resolve to "\#".  If you want to write makefiles
  portable to both versions, assign the number sign to a variable:
    H := \#
    foo := $(shell echo '$H')
  This was claimed to be fixed in 3.81, but wasn't, for some reason.
  To detect this change search for 'nocomment' in the .FEATURES variable.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
