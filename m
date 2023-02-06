Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81AC68B9DD
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjBFKUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjBFKUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:20:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF959EB69
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675678733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F/tkrW/h3v8eGkTwyoWU+A4uEMs8y6b9OAocIi4ScMs=;
        b=VNipGNfnShHDFhxW1igzqK9ICKgTXWfwyXtbOihtyegXbBNwpHQyatDD0Sum4Hpf8qBKPV
        wcPzkADSjJ0zdR3nbH/uUmfqzQ1HqNvyrd29Tk/JKp5f/fOIBwMAeXqh/9LTktK5/bdsQM
        Xh9fQANvdok4YN3ytP3pWGRQiD0swjI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-298-U5zsqaxYP2-cnoRenw52nQ-1; Mon, 06 Feb 2023 05:18:52 -0500
X-MC-Unique: U5zsqaxYP2-cnoRenw52nQ-1
Received: by mail-ej1-f69.google.com with SMTP id qa17-20020a170907869100b0088ea39742c8so8387631ejc.13
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 02:18:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F/tkrW/h3v8eGkTwyoWU+A4uEMs8y6b9OAocIi4ScMs=;
        b=JgwfL2r0er2Fcpvu/JC1/OVYaCozyKRq24eM2QDFCA/1xZamU84+Ict37oT40pjKTz
         LdlRNRSHg8c82UM8HbeF1zGInbyF46UoFe2FEsDVPS7pkJhB9C1UaLsdSpQNErze9LCb
         6sjSIX7A3vUMakwa56jSNzzf2+25dZFE61roMtW0rvJ7GLFE+pDaCeye3X5AN+TaYSn5
         qR2igL3OzEg7SQZu6Gpg4pECBrQ5M2tLV2w4oRqf16PzqoLt04e3dmlehnLDC9sAzRgk
         j4dzBned/UyBCgzSwkIHwL41l1Bz2NuRIPB8NHGvUABEc7J3ECLHjiPDI0ga8M9vV/Wg
         5ZKw==
X-Gm-Message-State: AO0yUKVrEYNqrsCMel7w+lvl1ICsG+jfY+LYVXs0ZPbLoJOsRQUdmE7Y
        YZyhE+GiNfitzwcj9cYeo33+mJovnfckJSHoP5ha7/cdNhxoaPW8OiH9OwxS7VGgQ5u9/C1nn4S
        pmCMYdk/wGyBT66LF
X-Received: by 2002:a50:f68a:0:b0:4aa:c354:a0e7 with SMTP id d10-20020a50f68a000000b004aac354a0e7mr612597edn.25.1675678731236;
        Mon, 06 Feb 2023 02:18:51 -0800 (PST)
X-Google-Smtp-Source: AK7set/KX4NAvekmawDJWQPFiqdD+ThOgqRkWAQaCGz0efcQ6xvB8RFQidJSDxUzjeC0/5vMtYqCrg==
X-Received: by 2002:a50:f68a:0:b0:4aa:c354:a0e7 with SMTP id d10-20020a50f68a000000b004aac354a0e7mr612583edn.25.1675678731004;
        Mon, 06 Feb 2023 02:18:51 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id v17-20020aa7dbd1000000b004a249a97d84sm4833572edt.23.2023.02.06.02.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 02:18:50 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <aad52e2d-b4fc-2ab3-0877-ecb9a3a65336@redhat.com>
Date:   Mon, 6 Feb 2023 11:18:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: page_pool: use in_softirq() instead
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230202024417.4477-1-dqfext@gmail.com>
 <ec42f238-8fc7-2ea4-c1a7-e4c3c4b8f512@redhat.com>
 <CALW65ja+P+E0fjEsZfm1XWb_dn_snuRoFA5i_i+_1K9j0+wi7Q@mail.gmail.com>
In-Reply-To: <CALW65ja+P+E0fjEsZfm1XWb_dn_snuRoFA5i_i+_1K9j0+wi7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/02/2023 14.05, DENG Qingfang wrote:
> Hi Jesper,
> 
> On Fri, Feb 3, 2023 at 7:15 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>> How can I enable threaded NAPI on my system?
> 
> dev_set_threaded(napi_dev, true);
> 
> You can also enable it at runtime by writing 1 to
> /sys/class/net/<devname>/threaded, but it only works if the driver
> does _not_ use a dummy netdev for NAPI poll.
> 

Thanks for providing this setup info.

I quickly tested driver i40e with a XDP_DROP workload, and switch 
between the threaded and normal NAPI, and no performance difference.
(p.s. driver i40e doesn't use page_pool)

>> I think other cases (above) are likely safe, but I worry a little about
>> this case, as the page_pool_recycle_in_cache() rely on RX-NAPI protection.
>> Meaning it is only the CPU that handles RX-NAPI for this RX-queue that
>> is allowed to access this lockless array.
> 
> The major changes to the threaded NAPI is that instead of scheduling a
> NET_RX softirq, it wakes up a kthread which then does the polling,
> allowing it to be scheduled to another CPU. The driver's poll function
> is called with BH disabled so it's still considered BH context.
> 

As long as drivers NAPI poll function doesn't migrate between CPUs while
it is running this should be fine. (This guarantee is needed as XDP + TC
have per_cpu bpf_redirect_info).

Looking at the code napi_threaded_poll() in net/core/dev.c I can see
this is guarantee is provided by the local_bh_disable() +
local_bh_enable around the call to __napi_poll().

>> We do have the 'allow_direct' boolean, and if every driver/user uses
>> this correctly, then this should be safe.  Changing this makes it
>> possible for drivers to use page_pool API incorrectly and this leads to
>> hard-to-debug errors.
> 
> "incorrectly", like, calling it outside RX-NAPI?

Yes.

--Jesper

