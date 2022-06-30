Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03BF35625B4
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 23:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiF3Vzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 17:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbiF3Vzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 17:55:43 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45175564E3;
        Thu, 30 Jun 2022 14:55:41 -0700 (PDT)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o728N-0006si-N4; Thu, 30 Jun 2022 23:55:35 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o728N-000H7n-DI; Thu, 30 Jun 2022 23:55:35 +0200
Subject: Re: [PATCH bpf-next 4/4] bpftool: Show also the name of type
 BPF_OBJ_LINK
To:     Quentin Monnet <quentin@isovalent.com>,
        Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220629154832.56986-1-laoar.shao@gmail.com>
 <20220629154832.56986-5-laoar.shao@gmail.com>
 <14bdc764-a129-35f6-bacc-6f517b259a5c@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3e4672cb-9272-b487-0dcb-1bca1a663653@iogearbox.net>
Date:   Thu, 30 Jun 2022 23:55:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <14bdc764-a129-35f6-bacc-6f517b259a5c@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26589/Thu Jun 30 10:08:14 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/22 6:22 PM, Quentin Monnet wrote:
> On 29/06/2022 16:48, Yafang Shao wrote:
>> For example,
>> /sys/fs/bpf/maps.debug is a bpf link, when you run `bpftool map show` to
>> show it,
>> - before
>>    $ bpftool map show pinned /sys/fs/bpf/maps.debug
>>    Error: incorrect object type: unknown
>> - after
>>    $ bpftool map show pinned /sys/fs/bpf/maps.debug
>>    Error: incorrect object type: link
>>
>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>> ---
>>   tools/bpf/bpftool/common.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>> index a0d4acd7c54a..5e979269c89a 100644
>> --- a/tools/bpf/bpftool/common.c
>> +++ b/tools/bpf/bpftool/common.c
>> @@ -251,6 +251,7 @@ const char *get_fd_type_name(enum bpf_obj_type type)
>>   		[BPF_OBJ_UNKNOWN]	= "unknown",
>>   		[BPF_OBJ_PROG]		= "prog",
>>   		[BPF_OBJ_MAP]		= "map",
>> +		[BPF_OBJ_LINK]		= "link",
>>   	};
>>   
>>   	if (type < 0 || type >= ARRAY_SIZE(names) || !names[type])
> 
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

(Took this one in so far given fairly independent of the rest, thanks Yafang!)
