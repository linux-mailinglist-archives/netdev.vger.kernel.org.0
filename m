Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F224B5B39AC
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiIINtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 09:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiIINsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 09:48:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7557613EE6D
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 06:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662731323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YImNobrFe/WhuWDTj42TmI0iV1ssLlERqxsuvNWDERI=;
        b=GMkHSmjLujAvDBKa+wmelGRA2dVYsoI9ytmgYqU/EbS5UymzZufRbaIqZGwovKnDE5dJRC
        7QehAbsOOIFgPzepCboNh0MfkIz3jhDvR8kvi53KD8n7AIa4ibuLwW4BmAwkn+mU13ys97
        7swzjHFzSteYWX3FV/bVQzLTHGUDlao=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-296-wMmQOzBDOoy2kHzH0yMJ_Q-1; Fri, 09 Sep 2022 09:48:33 -0400
X-MC-Unique: wMmQOzBDOoy2kHzH0yMJ_Q-1
Received: by mail-ed1-f72.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so1298655eda.19
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 06:48:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=YImNobrFe/WhuWDTj42TmI0iV1ssLlERqxsuvNWDERI=;
        b=6Dbtmh1nYhhVuQjgkMhxf9W7LngU9R85579aFmC8q9635p0URw+vBB2UaXDQjaVtXl
         a87wagL5y3MZmkqDBDLALl9+720zl3HEdJJh6UENNZrsufXLmD3HiVzeJ+AXh45aJmpF
         xxgqVldof7RFRjB0vKN0jgpvFjQOLoMwwANUKhkcQYDqtyHIM35dJ7vsXlgK88ynkcwa
         +LwQSuShsG73+5Ja+RovNIImqHWJoaGUopiQb8c4d81PTKs8E9YqEz7iJZH0mtOIMuLY
         PV7AUGHGidqkqt2esiqGICheRhAvRcYau4Gl5uegyegIOfc5tUQnI+nLNVcjzBa2DYNC
         dDTQ==
X-Gm-Message-State: ACgBeo0jRk4W/v25B3sr8e6xchLWGhJ5z7MXtvvsDmD2ZXAR5tkm8896
        kfK3/zDaGKmevxO/1CJjuoRjYyoK0tx5+JfnjRUbAFNbPSIIjMApch1aURtxUEYjEJpzx8C3jFu
        ObdP+vCFkWRbotjlB
X-Received: by 2002:a05:6402:2786:b0:448:e15d:ab0e with SMTP id b6-20020a056402278600b00448e15dab0emr11602220ede.91.1662731311934;
        Fri, 09 Sep 2022 06:48:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6N5xVGmsWUYQGhRgZqvZxQk2yqsaCgbYWlCDEXeY7sJ7OUl4WVZyP0sxTnug/6kY7xRheOcA==
X-Received: by 2002:a05:6402:2786:b0:448:e15d:ab0e with SMTP id b6-20020a056402278600b00448e15dab0emr11602201ede.91.1662731311724;
        Fri, 09 Sep 2022 06:48:31 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id kw4-20020a170907770400b0073dcdf9b0bcsm338050ejc.17.2022.09.09.06.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 06:48:31 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <434a45f6-aaf6-3bf0-8efe-c28a6c8b604d@redhat.com>
Date:   Fri, 9 Sep 2022 15:48:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [xdp-hints] [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining
 access to HW offload hints via BTF
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <20220908093043.274201-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220908093043.274201-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/09/2022 11.30, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Wed, 07 Sep 2022 17:45:00 +0200
> 
>> This patchset expose the traditional hardware offload hints to XDP and
>> rely on BTF to expose the layout to users.
>>
[...]
>> The main different from RFC-v1:
>>   - Drop idea of BTF "origin" (vmlinux, module or local)
>>   - Instead to use full 64-bit BTF ID that combine object+type ID
>>
>> I've taken some of Alexandr/Larysa's libbpf patches and integrated
>> those.
> 
> Not sure if it's okay to inform the authors about the fact only
> after sending? Esp from the eeeh... "incompatible" implementation?

Just to be clear: I have made sure that developers of the patches
maintain authorship (when applied to git via the From: line) and I've
Cc'ed the developers directly.  I didn't Cc you directly as I knew you
would be included via XDP-hints list, and I didn't directly use one of
your patches.

> I realize it's open code, but this looks sorta depreciatingly.

After discussions with Larysa on pre-patchset, I was convinced of the
idea of a full 64-bit BTF ID.  Thus, I took those patches and carried
them in my patchset, instead of reimplementing the same myself.
Precisely out of respect for Larysa's work as I wanted to give her
credit for coding this.

I'm very interested in collaborating.  That is why I have picked up
patches from your patchset and are carrying them forward.  I could just
as easily reimplemented them myself.

--Jesper

