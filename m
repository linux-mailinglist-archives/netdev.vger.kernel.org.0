Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3D55256CB
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 22:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353400AbiELU7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 16:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349618AbiELU7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 16:59:41 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E45727BC56;
        Thu, 12 May 2022 13:59:40 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1npFuG-000B4N-E9; Thu, 12 May 2022 22:59:32 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1npFuG-000IPr-1T; Thu, 12 May 2022 22:59:32 +0200
Subject: Re: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
To:     liqiong <liqiong@nfschina.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        hukun@nfschina.com, qixu@nfschina.com, yuzhe@nfschina.com,
        renyu@nfschina.com
References: <20220512142814.26705-1-liqiong@nfschina.com>
 <bd3d4379-e4aa-79c7-85b8-cc930a04f267@fb.com>
 <223f19c0-70a7-3b1f-6166-22d494b62b6e@nfschina.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <92cc4844-5815-c3b0-63be-2e54dc36e1d9@iogearbox.net>
Date:   Thu, 12 May 2022 22:59:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <223f19c0-70a7-3b1f-6166-22d494b62b6e@nfschina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26539/Thu May 12 10:04:41 2022)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/22 7:08 PM, liqiong wrote:
> 在 2022年05月12日 23:16, Yonghong Song 写道:
>>
>> On 5/12/22 7:28 AM, liqiong wrote:
>>> The string form of "char []" declares a single variable. It is better
>>> than "char *" which creates two variables.
>>
>> Could you explain in details about why it is better in generated codes?
>> It is not clear to me why your patch is better than the original code.
> 
> The  string form of "char *" creates two variables in the final assembly output,
> a static string, and a char pointer to the static string.  Use  "objdump -S -D  *.o",
> can find out the static string  occurring  at "Contents of section .rodata".

There are ~360 instances of this type in the tree from a quick grep, do you
plan to convert all them ?

Thanks,
Daniel
