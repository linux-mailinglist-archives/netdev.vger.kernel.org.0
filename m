Return-Path: <netdev+bounces-6080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1D6E714C44
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13E97280EAB
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 360516FCF;
	Mon, 29 May 2023 14:38:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6337E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:38:20 +0000 (UTC)
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35084125
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:37:43 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-19f268b1d83so1963655fac.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685371036; x=1687963036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uLb3YTMGdKhJR9u+HoXps5N6tSrCGN6wEkjlSczlMH0=;
        b=4eavr51c2MLKH2PqtdtY9ManBM9TRo3VzFM83QXEqCzCgMjLP/zbuaIJ3BPK19Q7Y+
         hWfF/2cTaUMSMwBIZK3IgaEBv3iL9hELISCoAwitzZ2yyi2KUe6RzPLgsZKI3UXsmNrZ
         dtMHbTK0XC3VS6qu0tVeMjf51Pt0Muvk8Pdb8YNRewSttWhw9S3CeS/389I6PTffbr+T
         VlnQupsYYt2NTyjZloX3KUQjRqYeqDHkoZqSfQms/FsRkjtdj8INIHmyAagz4b66v97W
         PGaLsbOQ6ukaCwwK6OXz21ycz9ylorhTAl6piYNeQbTbm7BQZ2DBBxVhfVFSIdLd/ew2
         LdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371036; x=1687963036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uLb3YTMGdKhJR9u+HoXps5N6tSrCGN6wEkjlSczlMH0=;
        b=Fa6jCHHw2MGOYhNasSz0fveE2TDlodsnpCAH1AxhMbXbGPEpA6437LrWUKwJhJwpOK
         dqb/dWEcrun91QMMcefEMv6MgmQ495Z0047W2GrekuNE93avTD++ikzXF069uV2xbJNj
         Ev+tSn0sEXZeS0wZ3YsRYTSoBwmtTNCYh9VqDPhvu3mE6nJoqoXumyHWYoghfp6+SwBH
         3qloBvn8fpiJUH84be/rs6lvfWGuK9sYotgzg5j28RIJyOUsCW4umgzjgCEQgHj+h49L
         UQmWUxD9RGDbvitugKfTKryVXRq1NwPpDAu8zxmOlMjEBpNNU156w2GGRRDEqEqC58KV
         Pv2A==
X-Gm-Message-State: AC+VfDz9Mliokv7hu5nWWJzamy8UszVX4BRK8VvJ9CCB+x+3Zl636mVE
	ij8Q5SVpqLh3QLcJz7EYgL2NUg==
X-Google-Smtp-Source: ACHHUZ49XjfzmNFzLg3i0pzAAvgVJZtaG+Adp/ihPVOSf32H5J//1Ay2vlnqzfG2lvl+RywE6WeZGg==
X-Received: by 2002:a05:6870:3652:b0:19f:2c0e:f865 with SMTP id v18-20020a056870365200b0019f2c0ef865mr4815914oak.7.1685371036327;
        Mon, 29 May 2023 07:37:16 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:e754:d14e:b665:58ef? ([2804:14d:5c5e:44fb:e754:d14e:b665:58ef])
        by smtp.gmail.com with ESMTPSA id dt48-20020a0568705ab000b00195e943f958sm4687351oab.1.2023.05.29.07.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:37:15 -0700 (PDT)
Message-ID: <2229fd4a-a65f-28f8-333f-26a6a1236d52@mojatatu.com>
Date: Mon, 29 May 2023 11:37:12 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net/netlink: fix NETLINK_LIST_MEMBERSHIPS group array
 length check
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, kuniyu@amazon.com, dh.herrmann@gmail.com, jhs@mojatatu.com
References: <20230525144609.503744-1-pctammela@mojatatu.com>
 <20230526203301.6933b4b3@kernel.org>
 <1be298c3-ce57-548e-e0af-937971fe58e9@mojatatu.com>
 <20230528234038.1d6de5cb@kernel.org>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230528234038.1d6de5cb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 03:40, Jakub Kicinski wrote:
> On Sat, 27 May 2023 12:01:25 -0300 Pedro Tammela wrote:
>> On 27/05/2023 00:33, Jakub Kicinski wrote:
>>> On Thu, 25 May 2023 11:46:09 -0300 Pedro Tammela wrote:
>>>> For the socket option 'NETLINK_LIST_MEMBERSHIPS' the length is defined
>>>> as the number of u32 required to represent the whole bitset.
>>>
>>> I don't think it is, it's a getsockopt() len is in bytes.
>>
>> Unfortunately the man page seems to be ambiguous (Emphasis added):
>> 	
>>          NETLINK_LIST_MEMBERSHIPS (since Linux 4.2)
>>                 Retrieve all groups a socket is a member of.  optval is a
>>                 pointer to __u32 and *optlen is the size of the array*.  The
>>                 array is filled with the full membership set of the
>>                 socket, and the required array size is returned in optlen.
>>
>> Size of the array in bytes? in __u32?
> 
> Indeed ambiguous, in C "size of array" could as well refer to sizeof()
> or ARRAY_SIZE()..
> 
>> SystemD seems to be expecting the size in __u32 chunks:
>> https://github.com/systemd/systemd/blob/9c9b9b89151c3e29f3665e306733957ee3979853/src/libsystemd/sd-netlink/netlink-socket.c#L37
>>
>> But then looking into the getsockopt manpage we see (Ubuntu 23.04):
>>
>>          int getsockopt(int sockfd, int level, int optname,
>>                         void optval[restrict *.optlen],
>>                         socklen_t *restrict optlen);
>>
>>
>> So it seems like getsockopt() asks for optlen to be, in this case, __u32
>> chunks?
> 
> Why so?

It's a far fetched interpretation of the function signature in the man 
page but
someone could argue that it's trying to emulate a VLA style function 
prototype over a generic optval.
But let's not waste precious time in this discussion.

> 
>> [...]
> 
> I don't know of any other case where socklen_t would refer to something
> else than bytes, I'm leaning towards addressing the truncation (and if
> systemd thinks the value is in u32s potentially also fixing system, not
> that over-allocating will hurt its correctness).

OK! Will re-spin to net-next so people have plenty of time to adjust

