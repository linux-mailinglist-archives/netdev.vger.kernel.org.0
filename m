Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8395B17AAB8
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCEQlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:41:39 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:38270 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCEQli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:41:38 -0500
Received: by mail-io1-f68.google.com with SMTP id s24so7179319iog.5
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 08:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xJ9IuCwpxwFw+yjT3QnESkIrBNpzfhchcrrtRf86kyQ=;
        b=EuEZm5h4KIrb8zG2A2yc61eZabzsnffCxSDvlEazTx2aMc+0Te2fTsPoO8W/B6xDtF
         ZddgiZi1/ibsj/fgNGEGFjcUe6A79b9s3eUyEbiozbEjv7/sPzA2A3EnwhVt44jPCSSn
         TX4Hf+vFCbIv2cuvcwhbu8MSG2AsDwYuAVrF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJ9IuCwpxwFw+yjT3QnESkIrBNpzfhchcrrtRf86kyQ=;
        b=PhYQYSOWtd7ecLMo1ErKD/Zjb5tPlgHl8fKTyXHXIBlP++x6Tvxoxu5+H4AQb0Znq/
         Tpak9B8D3ePAlSPWvs42uDitObLdRsuhsy9SKFCpRtvFB0IByCsHPaIxeEd2Fa+ipPg8
         x6SK7rUkbc/GzKGu+bBERbcT3WJQXBr2fja/d21VovCCiRt/mJFnfL4l3HIm6TBqJelg
         EpEvapkFSI5kra9P5L4DUz7PuiFDTQK0+mButSAsxK7UqWYkP5kKgn0FbNiKM/jDzgrv
         AyjzC2hUoqjxsjHT0dX55rtKVCLG1nA8o2F3mg3kBj3L6toTuGdUzUrPS/N7SOVYNIlp
         NsdQ==
X-Gm-Message-State: ANhLgQ2acgy6Nrmhken1WN/pUTkeNdO2d6sau9Yt/ymRTT2CF/VaikuI
        ux7zb5ZV+1eCwVf3RpH/i3bk3w==
X-Google-Smtp-Source: ADFU+vsOjyY3/T4qkHy41VLOvrwcLfGSPjRT+kAbzxP4YEIQ71dFbU0bx4zo+eS9xrmFRaT1R5Iwiw==
X-Received: by 2002:a6b:4417:: with SMTP id r23mr7148912ioa.262.1583426496596;
        Thu, 05 Mar 2020 08:41:36 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m10sm5467738ioa.65.2020.03.05.08.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:41:35 -0800 (PST)
Subject: Re: [PATCH v2 2/4] selftests: Fix seccomp to support relocatable
 build (O=objdir)
To:     Kees Cook <keescook@chromium.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        daniel@iogearbox.net, kafai@fb.com, yhs@fb.com, andriin@fb.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        khilman@baylibre.com, mpe@ellerman.id.au,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200305003627.31900-1-skhan@linuxfoundation.org>
 <202003041815.B8C73DEC@keescook>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f4cf1527-4565-9f08-a8a2-9f51022eac63@linuxfoundation.org>
Date:   Thu, 5 Mar 2020 09:41:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <202003041815.B8C73DEC@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 7:20 PM, Kees Cook wrote:
> On Wed, Mar 04, 2020 at 05:36:27PM -0700, Shuah Khan wrote:
>> Fix seccomp relocatable builds. This is a simple fix to use the
>> right lib.mk variable TEST_CUSTOM_PROGS to continue to do custom
>> build to preserve dependency on kselftest_harness.h local header.
>> This change applies cutom rule to seccomp_bpf seccomp_benchmark
>> for a simpler logic.
>>
>> Uses $(OUTPUT) defined in lib.mk to handle build relocation.
>>
>> The following use-cases work with this change:
>>
>> In seccomp directory:
>> make all and make clean
> 
> This works.
> 
>>
>>  From top level from main Makefile:
>> make kselftest-install O=objdir ARCH=arm64 HOSTCC=gcc \
>>   CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp
> 
> This fails for me:
> 
> $ make kselftest-install O=objdir ARCH=arm64 HOSTCC=gcc CROSS_COMPILE=aarch64-linux-gnu- TARGETS=seccomp
> make[1]: Entering directory '/home/kees/src/linux/objdir'
> make --no-builtin-rules INSTALL_HDR_PATH=$BUILD/usr \
>          ARCH=arm64 -C ../../.. headers_install
> make[4]: ../scripts/Makefile.build: No such file or directory
> make[4]: *** No rule to make target '../scripts/Makefile.build'.  Stop.
> make[3]: *** [Makefile:501: scripts_basic] Error 2
> make[2]: *** [Makefile:151: khdr] Error 2
> make[1]: *** [/home/kees/src/linux/Makefile:1221: kselftest-install] Error 2
> make[1]: Leaving directory '/home/kees/src/linux/objdir'
> make: *** [Makefile:180: sub-make] Error 2
> 
> (My "objdir" is empty)
> 
> If I remove O=objdir everything is fine. And see below...
> 
>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> ---
>>   tools/testing/selftests/seccomp/Makefile | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
>> index 1760b3e39730..355bcbc0394a 100644
>> --- a/tools/testing/selftests/seccomp/Makefile
>> +++ b/tools/testing/selftests/seccomp/Makefile
>> @@ -1,17 +1,16 @@
>>   # SPDX-License-Identifier: GPL-2.0
>> -all:
>> -
>> -include ../lib.mk
>> +CFLAGS += -Wl,-no-as-needed -Wall
>> +LDFLAGS += -lpthread
>>   
>>   .PHONY: all clean
>>   
>> -BINARIES := seccomp_bpf seccomp_benchmark
>> -CFLAGS += -Wl,-no-as-needed -Wall
>> +include ../lib.mk
>> +
>> +# OUTPUT set by lib.mk
>> +TEST_CUSTOM_PROGS := $(OUTPUT)/seccomp_bpf $(OUTPUT)/seccomp_benchmark
>>   
>> -seccomp_bpf: seccomp_bpf.c ../kselftest_harness.h
>> -	$(CC) $(CFLAGS) $(LDFLAGS) $< -lpthread -o $@
>> +$(TEST_CUSTOM_PROGS): ../kselftest_harness.h
>>   
>> -TEST_PROGS += $(BINARIES)
>> -EXTRA_CLEAN := $(BINARIES)
>> +all: $(TEST_CUSTOM_PROGS)
>>   
>> -all: $(BINARIES)
>> +EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)
>> -- 
>> 2.20.1
>>
> 
> Instead of the TEST_CUSTOM_PROGS+all dance, you can just add an explicit
> dependency, with the final seccomp/Makefile looking like this:
> 
> 
> # SPDX-License-Identifier: GPL-2.0
> CFLAGS += -Wl,-no-as-needed -Wall
> LDFLAGS += -lpthread
> 
> TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
> 

TEST_CUSTOM_PROGS is for differentiating test programs that
can't use lib.mk generic rules. It is appropriate to use
for seccomp_bpf

> include ../lib.mk
> 
> # Additional dependencies
> $(OUTPUT)/seccomp_bpf: ../kselftest_harness.h
> 
> 
> (Though this fails in the same way as above when run from the top-level
> directory.)
> 

I didn't see this because I have been the same directory I used
for relocated cross-build kernel. :(

Thanks for testing this. I know the problem here. all is a dependency
for install step and $(OUTPUT) is referencing the objdir before it
gets created. It is a Makefile/lib.mk problem to fix.

I will do a separate patch for this. This will show up in any test
that is using $(OUTPUT) to relocate objects mainly the ones that
require custom build rule like seeccomp.

thanks,
-- Shuah

