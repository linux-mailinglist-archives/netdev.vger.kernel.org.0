Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6616E596C97
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238815AbiHQKJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiHQKJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:09:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C341D4D4C1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660730967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rFQ2vbdqNLS83JEBag1JaG73C2ejg94L1xY/86td28w=;
        b=PrEaIf33xzkRRa3lxPK89SEwj8Cb2hqpVVcbWuGPzd6hNXxgj7NU84CY6jaipvmQRmGnCB
        loxxGCDEviHZNFPD8htvb6nF5BdzuI6VxKvBj5T9kVMDzLLGeuN8LxOAJTKaNu8MKigFsv
        sId3WJqdRIrXxZFL6eNyk389SbWWKXk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-UbQwJsVdMkG-hawwZurvVQ-1; Wed, 17 Aug 2022 06:09:26 -0400
X-MC-Unique: UbQwJsVdMkG-hawwZurvVQ-1
Received: by mail-wr1-f70.google.com with SMTP id d16-20020adfa350000000b00224fe84272aso1827081wrb.8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=rFQ2vbdqNLS83JEBag1JaG73C2ejg94L1xY/86td28w=;
        b=Ial0Y4+6bupwbcK7FWYyR1mh/2Rg/ZPMk85YitOWQ302GyX1BwIq4LkBc62H6iH41h
         fYOtZMyaPU8zXgKZgfTB5+BkIn2rjjE6dTDl6qAqKyFFjmjW2jDtY8Mw/jAxHTHdOVyK
         xn6CDdXI60zk7zxR4qf4kI7RYY7IWw2KkhdMAT3hhDg09oKe3cxhOmyiT2Z5gpeedqhc
         MPgSGlTnn60vUZ5COzrF8mGxbF8iotSyclojbTLqaOKrF9cikb43NNyePf1D0IG2qjB8
         ROoPS6JjRw+FGBbpAQ2YC0XBsbHWbLRozvqr3r0NOmzO3cxgQm+3Azlr3qrmzXwT9PWj
         wVcw==
X-Gm-Message-State: ACgBeo2BuHJC1a7BFGHIHnTleEv1kIcCoe+DaAoCKGtmfykT/8srYo4C
        OoY9RvfM9T5vyeCdGOA/LC+eT6AdlmxlsLc6u9tZMNYCGTOgKm2TlNs7Iv+ePyjDrpJB9cfdjfR
        94THXPaYDNafQBHFX
X-Received: by 2002:a5d:68c2:0:b0:225:1fd1:4225 with SMTP id p2-20020a5d68c2000000b002251fd14225mr2720021wrw.392.1660730965432;
        Wed, 17 Aug 2022 03:09:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ZGYQ0AEgur9hwTQYlVHMNZtnDKsqXY7sZjx66IWnuzJqZHhHrrJ4f4Wg4sIvLI1TqI9vYKw==
X-Received: by 2002:a5d:68c2:0:b0:225:1fd1:4225 with SMTP id p2-20020a5d68c2000000b002251fd14225mr2719982wrw.392.1660730965093;
        Wed, 17 Aug 2022 03:09:25 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id b18-20020a5d4b92000000b0021d6924b777sm12153974wrt.115.2022.08.17.03.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 03:09:24 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH 2/5] cpumask: Introduce for_each_cpu_andnot()
In-Reply-To: <YvwZH/q5rvT6JD5S@yury-laptop>
References: <20220816180727.387807-1-vschneid@redhat.com>
 <20220816180727.387807-3-vschneid@redhat.com>
 <YvwZH/q5rvT6JD5S@yury-laptop>
Date:   Wed, 17 Aug 2022 11:09:23 +0100
Message-ID: <xhsmhbksjb2r0.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/22 15:24, Yury Norov wrote:
> On Tue, Aug 16, 2022 at 07:07:24PM +0100, Valentin Schneider wrote:
>> for_each_cpu_and() is very convenient as it saves having to allocate a
>> temporary cpumask to store the result of cpumask_and(). The same issue
>> applies to cpumask_andnot() which doesn't actually need temporary storage
>> for iteration purposes.
>>
>> Following what has been done for for_each_cpu_and(), introduce
>> for_each_cpu_andnot().
>>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>> ---
>>  include/linux/cpumask.h | 32 ++++++++++++++++++++++++++++++++
>>  lib/cpumask.c           | 19 +++++++++++++++++++
>>  2 files changed, 51 insertions(+)
>>
>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>> index fe29ac7cc469..a8b2ca160e57 100644
>> --- a/include/linux/cpumask.h
>> +++ b/include/linux/cpumask.h
>> @@ -157,6 +157,13 @@ static inline unsigned int cpumask_next_and(int n,
>>      return n+1;
>>  }
>>
>> +static inline unsigned int cpumask_next_andnot(int n,
>> +					    const struct cpumask *srcp,
>> +					    const struct cpumask *andp)
>> +{
>> +	return n+1;
>> +}
>> +
>
> It looks like the patch is not based on top of 6.0, where UP cpumask
> operations were fixed.  Can you please rebase?
>

Right, this is based on tip/sched/core, I'll rebase it. Sorry about that!

