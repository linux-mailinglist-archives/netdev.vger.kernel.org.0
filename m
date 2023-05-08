Return-Path: <netdev+bounces-774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E6F6F9DDA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 04:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53B1B280E8E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 02:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDFB125CA;
	Mon,  8 May 2023 02:46:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382183C22
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 02:46:10 +0000 (UTC)
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF16E4A
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 19:46:08 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-757720be6abso53747285a.2
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 19:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683513967; x=1686105967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n6Aq2bhX5tQtXnCx1q7IJgtJTUCj63dVnWyqSkMWvdk=;
        b=D6cSDmNGN9jujM++D46MtYcmIhAB9qYMvBokezvAbuyYBn+3xpLVIhienGP9YBItzu
         MmE+PlB0NO6rVsk+fecsuo0c3lryGIVTkzXvIgdY+cfClwWSLq5XtG5ie+mZorJ/uGDW
         NSs9DI0tlsfqVqYZhqp4TGs91AnSWhxsgcpvIctjEVTdO6kq4gvzg7Jt9I6kRWHWmJU6
         YNxmNNCCQWzIb47hmxL/EjLzLrwCaZ580vZKJuSbnuVsPLWrSKvFF0QEjO87SQdZgPLh
         KoHm4vmQ++Tof7ZG1eTlLiPCzVLk19YI7AC6CjnZSdFDEs1OjM93PVEVPZKJw/oWQ96l
         6IoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683513967; x=1686105967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6Aq2bhX5tQtXnCx1q7IJgtJTUCj63dVnWyqSkMWvdk=;
        b=JxN6UO2wClYLaEwEdLBK9yyxqZzM716+6xsD8ZWPJd7rB5rGGDGgrAROe3NTbGc+M+
         NKAYzZxfhIZ9/Qfvqjr1bOwXv4hpZo1rna7XmuwhPSXAzu6nuvo9cn1R9NXLvNXG/cFL
         ilzNdYi5Pl3vfSfDXz/+SwWqMzGIGgWIYm9upqUMCROYO3+fgAoQ+SaI60YkkegcGo7m
         spMTtW9VMYM2aUSAQJz9+/uL1IIEX3Hyana57Yjtyu6g6BiV7/4IEuk18G2+/KX/YQb4
         fK13gX3XUHYOLyumPE/2KC6s6+G7HMnLNJx46WbOPscykas2w6nCdD33auqpQeZQjCaz
         B7HQ==
X-Gm-Message-State: AC+VfDwwJMJeM6RJ78mDs+VDxowcLPioBL3xei1hxR/XFFabG7ihm+JR
	QXODesrHTmq8h4wkg1Dj1Z/zf3egcOA=
X-Google-Smtp-Source: ACHHUZ6VUnJ1PGDGNbFY66mlo9JlhRPx/QgwMcs6rRU2v4jneppU/j5rkKL16tber6BbByRX/3WuVQ==
X-Received: by 2002:ad4:5967:0:b0:5ef:8b22:699e with SMTP id eq7-20020ad45967000000b005ef8b22699emr11005145qvb.14.1683513967436;
        Sun, 07 May 2023 19:46:07 -0700 (PDT)
Received: from ?IPV6:2602:47:d92c:4400:3754:1f3a:8fb6:2341? ([2602:47:d92c:4400:3754:1f3a:8fb6:2341])
        by smtp.gmail.com with ESMTPSA id y9-20020a0c9a89000000b0061b58b07130sm2444613qvd.137.2023.05.07.19.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 19:46:06 -0700 (PDT)
Message-ID: <8907c066-9ac9-8abc-eeff-078d0b0219de@gmail.com>
Date: Sun, 7 May 2023 22:46:05 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH ethtool 3/3] Fix potentinal null-pointer derference
 issues.
To: Michal Kubecek <mkubecek@suse.cz>
Cc: netdev@vger.kernel.org
References: <cover.1682894692.git.nvinson234@gmail.com>
 <105e614b4c8ab46aa6b70c75111848d8e57aff0c.1682894692.git.nvinson234@gmail.com>
 <20230507225752.fhsf7hunv6kqsten@lion.mk-sys.cz>
Content-Language: en-US
From: Nicholas Vinson <nvinson234@gmail.com>
In-Reply-To: <20230507225752.fhsf7hunv6kqsten@lion.mk-sys.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 5/7/23 18:57, Michal Kubecek wrote:
> On Sun, Apr 30, 2023 at 06:50:52PM -0400, Nicholas Vinson wrote:
>> Found via gcc -fanalyzer. Analyzer claims that it's possible certain
>> functions may receive a NULL pointer when handling CLI arguments. Adding
>> NULL pointer checks to correct the issues.
>>
>> Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
> A similar theoretical issue was discussed recently:
>
>    https://patchwork.kernel.org/project/netdevbpf/patch/20221208011122.2343363-8-jesse.brandeburg@intel.com/
>
> My position is still the same: argv[] members cannot be actually null
> unless there is a serious kernel bug (see the link above for an
> explanation). I'm not opposed to doing a sanity check just in case but
> if we do, I believe we should check the whole argv[] array right at the
> beginning and be done with it rather than add specific checks to random
> places inside parser code.

By convention and POSIX standard, the last argv[] member is always set 
to NULL and is accessed from main(int argc, char **argp) via argp[argc] 
(see 
https://pubs.opengroup.org/onlinepubs/9699919799/functions/execve.html). 
It's also possible for argc to be zero. In such a case, 
find_option(NULL) would get called.

However, after reviewing main(), I recommend changing:

         if (argc == 0)

                 exit_bad_args();

to

         if (argc <= 0 || !*argp)

                 exit_bad_args();


as this fixes the potential issue of main()'s argc being 0 (argc would 
be -1 at this point in such cases), and "!*argp" silences gcc's built-in 
analyzer (and should silence all other SA with respect to the reported 
issue) as the SA doesn't recognize that it would take a buggy execve 
implementation to allow argp to be NULL at this point ).

If you don't have any objections to this change, I can draft an updated 
patch to make this change.

Thanks,

Nicholas Vinson

>> @@ -6182,16 +6182,18 @@ static int find_option(char *arg)
>>   	size_t len;
>>   	int k;
>>   
>> -	for (k = 1; args[k].opts; k++) {
>> -		opt = args[k].opts;
>> -		for (;;) {
>> -			len = strcspn(opt, "|");
>> -			if (strncmp(arg, opt, len) == 0 && arg[len] == 0)
>> -				return k;
>> -
>> -			if (opt[len] == 0)
>> -				break;
>> -			opt += len + 1;
>> +	if (arg) {
>> +		for (k = 1; args[k].opts; k++) {
>> +			opt = args[k].opts;
>> +			for (;;) {
>> +				len = strcspn(opt, "|");
>> +				if (strncmp(arg, opt, len) == 0 && arg[len] == 0)
>> +					return k;
>> +
>> +				if (opt[len] == 0)
>> +					break;
>> +				opt += len + 1;
>> +			}
>>   		}
>>   	}
>>   
> I would rather prefer a simple
>
> 	if (!arg)
> 		return -1;
>
> to avoid closing almost all of the function body inside an if block.
>
> Michal

