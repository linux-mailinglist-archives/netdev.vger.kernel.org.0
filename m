Return-Path: <netdev+bounces-5915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3182B71353D
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:01:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF144281722
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353C5134A3;
	Sat, 27 May 2023 15:01:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5C1078A
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:01:32 +0000 (UTC)
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA1CE1
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:01:30 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-557d69340e9so939556eaf.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685199690; x=1687791690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2W4MrnchGL1SigbHUXlhRXA26MNbIwnWnd8o8027xzE=;
        b=TwY383Bofz//q+W+QEvmknxO7d2HvbEPmp9+3d50BOXvM3NpQTUaAFHoSI4DMdYcbY
         Y7nKCASQ1RUceoPfTxaHJuqviRtCFd50RYDaQW25zgA/hSskWPZp0QWr4zPg34BZHLfL
         t3u23sP9zfLSqjUJxX/9vgI/8Y0pFRySVWviv7ysj2ec9wUiSV7/OlqzG84oMv5YyR9l
         xQz7WguDBymhtdbo5UHNgplDWdeCky66VBIMiC8+dcNNO063geUkjLCDW2/YhWr8CaLh
         RmGeGKBGBo3QyJNTZSKsdeIdb2h2cudulrrUlzCB6t3xZp/xXrFT1HApDN1TDkeX3md+
         DjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685199690; x=1687791690;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2W4MrnchGL1SigbHUXlhRXA26MNbIwnWnd8o8027xzE=;
        b=AQu7bS082pZoKy7pI+3wfX8wOqrV3hMbcASmNQAQZtyAe17qqhGeXkb3wwQ97GnXto
         DwtE4evn8Kydydb0U6hTohTGHKL/V4fHUjRDK6DMcxYck8fiUclJMmDnf9nYMIybXD/R
         kJEL1nW4xG8a0WIvajpUCN7dPL7n26P9P2XfkffACJsu+SKUA1N6JRtei5OaAQwvUEaA
         jKl92ewLnfBwTGBVQ3w2tO4dKxwD3hMDM0EPwgCGGMJiVmLW7hW23rw76sFyC3C516x6
         egFKAlpOk37/yLuUL4EJSiiZUCtg15BDwtI2O58j7aJxmvmTBRpGVHBrmCSt+HFQ6S5A
         3JhA==
X-Gm-Message-State: AC+VfDzapww06NN162kTVu7sZZbcKSvQACX7SBy+uRDjMmoW0YRo9t0a
	d7UvYjnM1eQpdI1DQyOvhFq16A==
X-Google-Smtp-Source: ACHHUZ5tIQ7vjKGhSZBm2WO6APcXzgm6ht/YexTxFDJ9DiPYwi2u5Bh0qpjx/+nUl6dQUlFnCQMFHg==
X-Received: by 2002:a05:6808:4d:b0:399:25d0:30d1 with SMTP id v13-20020a056808004d00b0039925d030d1mr2799057oic.3.1685199689276;
        Sat, 27 May 2023 08:01:29 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:c676:faf5:b4eb:6b9a? ([2804:14d:5c5e:44fb:c676:faf5:b4eb:6b9a])
        by smtp.gmail.com with ESMTPSA id i1-20020aca0c41000000b003942036439dsm2676526oiy.46.2023.05.27.08.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 May 2023 08:01:28 -0700 (PDT)
Message-ID: <1be298c3-ce57-548e-e0af-937971fe58e9@mojatatu.com>
Date: Sat, 27 May 2023 12:01:25 -0300
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
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230526203301.6933b4b3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 27/05/2023 00:33, Jakub Kicinski wrote:
> On Thu, 25 May 2023 11:46:09 -0300 Pedro Tammela wrote:
>> For the socket option 'NETLINK_LIST_MEMBERSHIPS' the length is defined
>> as the number of u32 required to represent the whole bitset.
> 
> I don't think it is, it's a getsockopt() len is in bytes.

Unfortunately the man page seems to be ambiguous (Emphasis added):
	
        NETLINK_LIST_MEMBERSHIPS (since Linux 4.2)
               Retrieve all groups a socket is a member of.  optval is a
               pointer to __u32 and *optlen is the size of the array*.  The
               array is filled with the full membership set of the
               socket, and the required array size is returned in optlen.

Size of the array in bytes? in __u32?
SystemD seems to be expecting the size in __u32 chunks:
https://github.com/systemd/systemd/blob/9c9b9b89151c3e29f3665e306733957ee3979853/src/libsystemd/sd-netlink/netlink-socket.c#L37

But then looking into the getsockopt manpage we see (Ubuntu 23.04):

        int getsockopt(int sockfd, int level, int optname,
                       void optval[restrict *.optlen],
                       socklen_t *restrict optlen);


So it seems like getsockopt() asks for optlen to be, in this case, __u32 
chunks?

WDYT?

> 
>> User space then usually queries the required size and issues a subsequent
>> getsockopt call with the correct parameters[1].
>>
>> The current code has an unit mismatch between 'len' and 'pos', where
>> 'len' is the number of u32 in the passed array while 'pos' is the
>> number of bytes iterated in the groups bitset.
>> For netlink groups greater than 32, which from a quick glance
>> is a rare occasion, the mismatch causes the misreport of groups e.g.
>> if a rtnl socket is a member of group 34, it's reported as not a member
>> (all 0s).
> 
> IDK... I haven't tried to repro but looking at the code the more
> suspicious line of code is this one:
> 
> 		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
> 
> It's going to round down bytes, and I don't think it's intending to.
> It should be DIV_ROUND_UP(, 8) then ALIGN(, 4) right?

That indeed looks suspicious.
Your suggestions looks correct for optlen reported as bytes.
For optlen reported in __u32 chunks seems like BITS_TO_U32(nlk->ngroups) 
would be sufficient.




