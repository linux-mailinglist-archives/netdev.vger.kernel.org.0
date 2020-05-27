Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B5B1E44C2
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbgE0N43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388604AbgE0N43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:56:29 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E15C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 06:56:28 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so11240021qkg.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 06:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yx8mfdcIlHSnBR5P+mYqezx89TsAwmfJwsRa3/J6fYU=;
        b=gcbKl3E7/khvKyuNdCIPGZn989k8aeecXQbxuk4qurDPgShENPvFBnistcLoLJhh4R
         q9i+fWwcgVnuhnvf88OZGYilwZKrs53VQeMG5YTZ6xjOm23NSJjk+aEdHcfo9ZUpWfKG
         vZ0ifA711450fV2neoAcrjd2bneHMCya2tyfHCoUeI8geTzLP+76KaQKUOmqwyFxT+5j
         r3+er7iYMUkbBkgqbqA1tRNLidrikPNpoR+9j6AxNAEeXDhAc3b2N9Ci0RWBuRkpLXwi
         gjJ4PK6giPq8druBhxl7xLpHwu3v6RfBoOL3K/Ax/6zqc1O/baSGCDUnAdBoAjaHp1PO
         eyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yx8mfdcIlHSnBR5P+mYqezx89TsAwmfJwsRa3/J6fYU=;
        b=hk4P14/1yZWqd5FJMUyFdG0ZV4ukAX48R4RDQbjUcMfPshQHQQqVyEtsrn4rkMfqra
         v+9kjrGj3VMaayvuzRRF3y1sB3u6QVNewQNbl7vJuERTSKRyFuo1rFfei+l5I+66iLyp
         W47f8dMTRYr4ST6B1RbVFUVlDd98hZ8Y2w3bnufvdMS218rKmJCQ6lXttYwLVugrSyjZ
         ax5X7S1wIl09n4KponHzjOzxbfkoUPyltAHgBygZUSV3qTUI33YAhuijevndtM/eGSwD
         2xf7llNbsH+BKpaVImifhfTYgUCuDgrmoVr4LZkf1FXDGC60con9oJ30JRmv8Wv7vZ+K
         Vkjw==
X-Gm-Message-State: AOAM53041G2M0KAAG/3ZtdKACtWrUVOdEdWZQEqiHCsR8j194Ln7Na1n
        yRpr4SQ5E+F+zv+czpErqrs=
X-Google-Smtp-Source: ABdhPJzEItYfJG8HYaHPdeWxZH4oiDW25Jq3BcVYOtSg7PpYuSllRd7vt7H58pMJJOEW6XlloGLbpg==
X-Received: by 2002:a37:9a02:: with SMTP id c2mr4191327qke.470.1590587787596;
        Wed, 27 May 2020 06:56:27 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id t189sm2291578qkc.87.2020.05.27.06.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 06:56:26 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com
References: <20200527010905.48135-1-dsahern@kernel.org>
 <20200527010905.48135-2-dsahern@kernel.org> <20200527122612.579fbb25@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c58f11be-af67-baff-bd70-753ca84de0dd@gmail.com>
Date:   Wed, 27 May 2020 07:56:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527122612.579fbb25@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 4:26 AM, Jesper Dangaard Brouer wrote:
>> @@ -108,9 +118,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
>>  	u64 cost = 0;
>>  	int err;
>>  
>> -	/* check sanity of attributes */
>> +	/* check sanity of attributes. 2 value sizes supported:
>> +	 * 4 bytes: ifindex
>> +	 * 8 bytes: ifindex + prog fd
>> +	 */
>>  	if (attr->max_entries == 0 || attr->key_size != 4 ||
>> -	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
>> +	    (attr->value_size != 4 && attr->value_size != 8) ||
> 
> IMHO we really need to leverage BTF here, as I'm sure we need to do more
> extensions, and this size matching will get more and more unmaintainable.
> 
> With BTF in place, dumping the map via bpftool, will also make the
> fields "self-documenting".
> 
> I will try to implement something that uses BTF for this case (and cpumap).
> 

as mentioned in a past response, BTF does not make any fields special
and this code should not assume it either. You need to know precisely
which 4 bytes is the program fd that needs to be looked up, and that
AFAIK is beyond the scope of BTF.
