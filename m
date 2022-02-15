Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825604B766B
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbiBOSSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 13:18:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242974AbiBOSSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 13:18:04 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F165119879;
        Tue, 15 Feb 2022 10:17:53 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 7B67D1F448F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644949071;
        bh=h/COUe+915WJwYQPSbDM5m4K3JjxoSrR771H/V9/JBc=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=VUrykP2Mk8dxmzXlHic+VmIbYYW+LmAzj6vPHmF7Qkg3g8jCQZVTiEaUYoscEhcfS
         hViby0dbf6astOyftkLqX7cA/BNMrwjN5wI4jXXa2sizRCKvrELKZ+X7zuZtGAwwMl
         h05B2YBuf+EuumrEq6rV2oLJ/YpkwHdTWK7BhluC88xvK16vpYO3uePljeIOlljNf7
         AWtxjdLUdm/nAMC8JZKw9JnoVlgt/sfeBiIIxmufa6I4z9pHhP7PS8FwxNvZwxcnur
         7SOFWe9V+FrXIjSXaSYDfKoilpQcu5m9y3DzTla0Oshju1D5u2vrxE1k8C2QhIkDAF
         +UiUHfjMzb4hw==
Message-ID: <4b739847-0622-c221-33b3-9fe428a52bc0@collabora.com>
Date:   Tue, 15 Feb 2022 23:17:39 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     usama.anjum@collabora.com, Shuah Khan <skhan@linuxfoundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "christian@brauner.io" <christian@brauner.io>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2] selftests/seccomp: Fix seccomp failure by adding
 missing headers
Content-Language: en-US
To:     Sherry Yang <sherry.yang@oracle.com>
References: <20220210203049.67249-1-sherry.yang@oracle.com>
 <755ec9b2-8781-a75a-4fd0-39fb518fc484@collabora.com>
 <85DF69B3-3932-4227-978C-C6DAC7CAE64D@oracle.com>
 <66140ffb-306e-2956-2f6b-c017a38e18f8@collabora.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <66140ffb-306e-2956-2f6b-c017a38e18f8@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/14/22 9:12 PM, Muhammad Usama Anjum wrote:
>>> "../../../../usr/include/" directory doesn't have header files if
>>> different output directory is used for kselftests build like "make -C
>>> tools/tests/selftest O=build". Can you try adding recently added
>>> variable, KHDR_INCLUDES here which makes this kind of headers inclusion
>>> easy and correct for other build combinations as well?
>>>
>>>
>>
>> Hi Muhammad,
>>
>> I just pulled linux-next, and tried with KHDR_INCLUDES. It works. Very nice 
>> work! I really appreciate you made headers inclusion compatible. However, 
>> my case is a little more complicated. It will throw warnings with -I, using 
>> -isystem can suppress these warnings, more details please refer to 
>> https://lore.kernel.org/all/C340461A-6FD2-440A-8EFC-D7E85BF48DB5@oracle.com/
>>
>> According to this case, do you think will it be better to export header path 
>> (KHDR_INCLUDES) without “-I”?
> Well said. I've thought about it and it seems like -isystem is better
> than -I. I've sent a patch:
> https://lore.kernel.org/linux-kselftest/20220214160756.3543590-1-usama.anjum@collabora.com/
> I'm looking forward to discussion on it.
The patch has been accepted. It should appear in linux-next soon. You
should be able to use KHDR_INCLUDES easily now.

Thanks,
Usama
