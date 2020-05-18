Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D081D7C7B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgERPMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgERPMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:12:47 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C0CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:12:47 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f189so10407692qkd.5
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JIj6I8r3/cBS+MKQ77dbW/xynFdQvZB1TXULhPz18Lo=;
        b=F9ef2wdVsr/m2C6LZVx9N2OKwkKnXmT+lMrYFf4MXa+Q9FJxgJ+VHouMr1RrpORh2q
         m5tzsvZ7OnFcOo8cieaPImN1CtI6rGdGy97dF0vaGncEw5vfF57ZSnBGJNKB0Y9X6Cox
         sVYQpW7q/ygKxgtM7Dyz6xjWgziW3/YeHE+PXSe1DbX8/wlwEsiD33j+xolurIfr50Ha
         paGaJOgTrii9hcwvsYsS3gYkigaIZi+bBOd6BQ+vbvSp33s3xrBoXH7cd+8GkiAgaNNc
         CA0t9xnqntnQR1mT6Ie/y0yaX/ZMiY8LqiZm+IxO8eE52dxMnDW2aSn79EtUfwooCziA
         r2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIj6I8r3/cBS+MKQ77dbW/xynFdQvZB1TXULhPz18Lo=;
        b=PJ+piVWSzXLWwT9SIEyplUCqmUS9+hYLAmniO97iwWbNHQpcAq0UmMhzPSENZkym9k
         p2L3PGXfsffkk10EnAiycltAdd3PwNvp9AIRO8BLN4TnJKZsSHW1dXvStZ4e6LJUGXta
         TCvmhvwSm2lB1fWVm1ICmXXRpxk4tUsf1NSPbVg5tbFsF95qMvwcxU4P26dF6VN9Rzb1
         EBoVbMMeoWDWb6qekMhOViXSLnarIAeVgpV+0MWSKG98HA6yZjkk7VbbDuvfgLNTiDh7
         Yr3ZMU3rLU+iIfmfOPhvowdGOnqzwSJyMDiSKV4qiFIplKZ7jUIzoIgng9HY6eDWy323
         +X+Q==
X-Gm-Message-State: AOAM530YgROUcb3NS+jayX1xA2SL3f4cj5wa7HvB1KvGFf50YIUE6DC9
        Ca7W8AH7DT3kRsf5qxJIVMV22rZ8
X-Google-Smtp-Source: ABdhPJzLhI0WlaZGldL40rOPiRojkZuWrzcl9sMa64f97D4XclXkTyey70x1LSza4Fg2kuqbKxb0nw==
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr17601473qka.449.1589814766002;
        Mon, 18 May 2020 08:12:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f866:b23:9405:7c31? ([2601:282:803:7700:f866:b23:9405:7c31])
        by smtp.googlemail.com with ESMTPSA id 67sm1565211qkg.51.2020.05.18.08.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:12:45 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: mqprio: reject queues count/offset pair
 count higher than num_tc
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, kiran.patil@intel.com
References: <20200513194717.15363-1-maciej.fijalkowski@intel.com>
 <20200518080810.568a6d28@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <08dff834-05e7-6079-4895-907a35a2a1a6@gmail.com>
Date:   Mon, 18 May 2020 09:12:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200518080810.568a6d28@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 9:08 AM, Stephen Hemminger wrote:
> On Wed, 13 May 2020 21:47:17 +0200
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> 
>> Provide a sanity check that will make sure whether queues count/offset
>> pair count will not exceed the actual number of TCs being created.
>>
>> Example command that is invalid because there are 4 count/offset pairs
>> whereas num_tc is only 2.
>>
>>  # tc qdisc add dev enp96s0f0 root mqprio num_tc 2 map 0 0 0 0 1 1 1 1
>> queues 4@0 4@4 4@8 4@12 hw 1 mode channel
>>
>> Store the parsed count/offset pair count onto a dedicated variable that
>> will be compared against opt.num_tc after all of the command line
>> arguments were parsed. Bail out if this count is higher than opt.num_tc
>> and let user know about it.
>>
>> Drivers were swallowing such commands as they were iterating over
>> count/offset pairs where num_tc was used as a delimiter, so this is not
>> a big deal, but better catch such misconfiguration at the command line
>> argument parsing level.
>>
>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> ---
>>  tc/q_mqprio.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
>> index 0eb41308..f26ba8d7 100644
>> --- a/tc/q_mqprio.c
>> +++ b/tc/q_mqprio.c
>> @@ -48,6 +48,7 @@ static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
>>  	__u64 max_rate64[TC_QOPT_MAX_QUEUE] = {0};
>>  	__u16 shaper = TC_MQPRIO_SHAPER_DCB;
>>  	__u16 mode = TC_MQPRIO_MODE_DCB;
>> +	int cnt_off_pairs = 0;
> 
> Since opt.num_tc is u8, shouldn't this be u8 as well?
> Note: maximum number of queue is TC_QOPT_MAX_QUEUE (16).
> 

I was looking that as having cnt_off_pairs as an int makes for simpler
code - not having to detect rollover. But if there is a limit, I guess
that takes precedence.

And if there is a limit, perhaps that should be checked on num_tc parsing.
