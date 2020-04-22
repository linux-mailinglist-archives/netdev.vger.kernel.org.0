Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FE21B3BB3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgDVJsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725961AbgDVJsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 05:48:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6717C03C1A8
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 02:48:03 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w4so1658829ioc.6
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 02:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tIk35OlHPDX6n12j2pZSDOuj979+Q9ZAlmTrda5l5b0=;
        b=TycfypalCWBKroIC2WsZBfzmGxEd+se/FepNnFTxDYquGhwnN0wBhWwJzzhI9HsaxG
         uTbJGAfWYnIs0OVbUjx857XSDbHjmxKphcYrzrm7+4oN6KFy3av63t8l1KdT6Q4UPcsZ
         wSDN6qY3D6TDdp7OX8AuG5SZCxjDZHzlJzwBSn1SuYHnyxxBAlOEcSrs/8aikpxTuijG
         AYVLPMD6HICZlbmdNTofYIChJOjxg6DzadOwwckELLnhMFjqJr+/uv/hxrh9Pe7PvqpI
         UyXqTMh5HfywVj5eOsJxh51l1QKF9jig+jupf0zYPMDq3XEZ2hNX48wYJh/JO60A1ng2
         OJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tIk35OlHPDX6n12j2pZSDOuj979+Q9ZAlmTrda5l5b0=;
        b=qP9R7tCstL+f0kA2Xk2Ezoe8/N/2Y7Y81DwxcFIqnLI9v+Y4A3FXBfSB9xpJzsZPBz
         caAcBZFA1HQUn9oiLArwtvmIKZ3QaztFJeI2rPIwoeHIXPr7Z/j56nNZRsYVi/RTednb
         /iaqb07blSo64wJHXU1Fi2DbzLtVy7L5iWj8+4fxrY0d2upNh/+VF9JWqJNmlSiYYufG
         0xpyEAJJunpScCTr4l3VnMm1sY7sOr/gpzqPp/LzdVYwcTW0TDIpoKZKg9qHSR7SHoYo
         7WcFGqSq2PJSJF7hJie5Nr9odhh6+lRHDoH1BXn8B9yUenuVLTGYLtnNwgJOdqN+M+x+
         X48g==
X-Gm-Message-State: AGi0PubLeiPk83Q2rIKmjV5DbEnLJb0sDU9U0GcHdL3xH4IXfXG5yu/v
        VY8j2hYZZDxXaQH5kjp34flFzA==
X-Google-Smtp-Source: APiQypIDi2d7wTXwpFVyaBmrERb0mhfR143clFk1m/t5fY1dlsItKBBR5/XCQKL/UsTln7ASsy3WuA==
X-Received: by 2002:a05:6602:2f08:: with SMTP id q8mr24920887iow.103.1587548883177;
        Wed, 22 Apr 2020 02:48:03 -0700 (PDT)
Received: from [192.168.0.105] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id g87sm1885670ile.25.2020.04.22.02.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 02:48:02 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/1] bpf: Fix segfault when custom pinning is
 used
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, aclaudi@redhat.com, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
References: <20200421180426.6945-1-jhs@emojatatu.com>
 <20200422064215.GA17201@nautica>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <8766e548-5486-8228-f583-e5d501a41aec@mojatatu.com>
Date:   Wed, 22 Apr 2020 05:47:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422064215.GA17201@nautica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-22 2:42 a.m., Dominique Martinet wrote:
> (random review)
> 

Good review;->

> Jamal Hadi Salim wrote on Tue, Apr 21, 2020:
>> diff --git a/lib/bpf.c b/lib/bpf.c
>> index 10cf9bf4..cf636c9e 100644
>> --- a/lib/bpf.c
>> +++ b/lib/bpf.c
>> @@ -1509,12 +1509,12 @@ out:
>>   static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
>>   				const char *todo)
>>   {
>> -	char *tmp = NULL;
>> +	char tmp[PATH_MAX] = {};
>>   	char *rem = NULL;
>>   	char *sub;
>>   	int ret;
>>   
>> -	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
>> +	ret = sprintf(tmp, "%s/../", bpf_get_work_dir(ctx->type));
>>   	if (ret < 0) {
>>   		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
> 
> error check needs to be reworded,

Will reword.

  and it probably needs to use snprintf
> instead of sprintf: bpf_get_work_dir() can be up to PATH_MAX long and as
> pointed out there are strcat() afterwards so it's still possible to
> overflow this one
> 

and change to snprintf. The strcat afterwards is protected by the check
                 if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX)
                         return -EINVAL;
However, since you looked at it now that i am paying closer attention
there's another bug there. The above check will return without freeing
earlier asprintf allocated "rem" variable. Sounds like separate patch.

cheers,
jamal
