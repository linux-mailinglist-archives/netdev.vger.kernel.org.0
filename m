Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91982686D70
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjBARyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjBARye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:54:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B308F1EBF3
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675274029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3C/jKpTygMNBKacLgOlja89rzh1jqDZR0L6gDa+JpI=;
        b=WwoDIHq+bKeALx13ah4SAYQYpEKWNZXVMxUjxutBSHyLfBzjIswpzS5nSj7eOgvd2VhE5J
        8azGX9xo7jwKloOvalT5msF4DFdLYbJ6EUnPaFRRAIRpJf7F9l7NmC96hxx3aPxX8S3nn1
        M1Rgz4yYNRaOT0E8HDxWxFEXiUtliOo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-YcaZEndgP3SoRCKXo_Hq-g-1; Wed, 01 Feb 2023 12:53:47 -0500
X-MC-Unique: YcaZEndgP3SoRCKXo_Hq-g-1
Received: by mail-ej1-f71.google.com with SMTP id ti11-20020a170907c20b00b00886244203fcso7451972ejc.2
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 09:53:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3C/jKpTygMNBKacLgOlja89rzh1jqDZR0L6gDa+JpI=;
        b=21H4qYIB5Jxb+tZlVOnu69cNh5G9kuAUSAQXgmoDxbCnoefDkhfl6pqxTu+MOxqwP6
         9UNUmT2LmOBTG7MkJyfpc+yGJUH9iyz3egiga2Eya1xB9NZOKYVOpG3cYncGAb2J4wZA
         kebmBqlESuwHrG2KSxbgHb3fyG1cenUvdT9banJrcE9eyiQK/MZAmTxeXPp6rsROd+Wy
         4mig1ZFJAgP5cdNc9nq3Y/X7QpFB41XGrSbYYGuCtWbtCjBf6yY1c67yq4K+gUMhtqE/
         ShAY8d25ljJ0bFRiBYvoyUJlMhE8NmCv+HoM69bBK5rb9fh8iX7ojYELWe32d3omVC2T
         RiKw==
X-Gm-Message-State: AO0yUKWKDjT3nQViYzE4UGf1nOna3af5K+79gdtTzVGRxZX0rTqWrX0d
        m8o7QUrNz9MbEj10NI4aqv9PHKi+6/u7qII7bl1EUYfNx+dntEVINYsosuX7JJSPomqJ1j7PZPX
        ioG4sqetIYuD7ALjo
X-Received: by 2002:a17:907:9914:b0:878:8237:7abb with SMTP id ka20-20020a170907991400b0087882377abbmr4047797ejc.35.1675274026736;
        Wed, 01 Feb 2023 09:53:46 -0800 (PST)
X-Google-Smtp-Source: AK7set9iaHy0dAJGKxRMQzkfuhvMi3UlE3SQOtU6bDESavzDpTPXmKddwsC1a4XXH1ARn7hHErTIlg==
X-Received: by 2002:a17:907:9914:b0:878:8237:7abb with SMTP id ka20-20020a170907991400b0087882377abbmr4047778ejc.35.1675274026560;
        Wed, 01 Feb 2023 09:53:46 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id o18-20020a170906359200b0088dc98e4510sm1279111ejb.112.2023.02.01.09.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 09:53:46 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <73d3e5c5-a38b-6f83-3022-b0442203ad6b@redhat.com>
Date:   Wed, 1 Feb 2023 18:53:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        dsahern@gmail.com, willemb@google.com, void@manifault.com,
        kuba@kernel.org, xdp-hints@xdp-project.net, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next V2 2/4] selftests/bpf: xdp_hw_metadata cleanup
 cause segfault
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
 <167527271533.937063.5717065138099679142.stgit@firesoul>
 <484ca75b-d5f0-31db-6f81-2fb17ce0702e@linux.dev>
Content-Language: en-US
In-Reply-To: <484ca75b-d5f0-31db-6f81-2fb17ce0702e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/02/2023 18.46, Martin KaFai Lau wrote:
> On 2/1/23 9:31 AM, Jesper Dangaard Brouer wrote:
>> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c 
>> b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>> index 3823b1c499cc..438083e34cce 100644
>> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
>> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
>> @@ -121,7 +121,7 @@ static void close_xsk(struct xsk *xsk)
>>           xsk_umem__delete(xsk->umem);
>>       if (xsk->socket)
>>           xsk_socket__delete(xsk->socket);
>> -    munmap(xsk->umem, UMEM_SIZE);
>> +    munmap(xsk->umem_area, UMEM_SIZE);
> 
> Ah. Good catch. This should also explain a similar issue that CI is 
> seeing in the prog_tests/xdp_metadata.c.

Yes, very likely same bug in prog_tests/xdp_metadata.c.

It was super tricky (and time consuming) to find as I was debugging in
GDB and it didn't make sense that checking a value against NULL would
cause a segfault.  Plus, sometimes it worked without issues.

We also need this fix:

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c 
b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index e033d48288c0..241909d71c7e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -121,7 +121,7 @@ static void close_xsk(struct xsk *xsk)
                 xsk_umem__delete(xsk->umem);
         if (xsk->socket)
                 xsk_socket__delete(xsk->socket);
-       munmap(xsk->umem, UMEM_SIZE);
+       munmap(xsk->umem_area, UMEM_SIZE);
  }

