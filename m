Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D723B5EC61E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiI0Oa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiI0OaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:30:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877FA61CD;
        Tue, 27 Sep 2022 07:30:13 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x18so15286551wrm.7;
        Tue, 27 Sep 2022 07:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4qLPtvUWN+AfrLhyVfZ91N3yZnBEIddv2rouQHzCYLA=;
        b=LSvdUNSjYwsgaB1ny7A29I06dZuPVvZasJ53PSj2IRqPVKq1ohmeHh9Z6CkkhwtJQf
         85O+gH6Z/IdRrelbEU0k1mMXu+6fxxn2WMN9doOp+loYLAuRiKZyPsNuFdcRNJn8dsQ8
         lRGEVEdnN3VzNzjA7sb4HgBPlDNeuOXWP9VvdICO7KXryKqpFA3ehg94nCKxwk0Gpl0X
         I+5MDhB4PGTBCY6571kzJwU8c1BDIDcYu4PmD8hWvxk6btQMMwVeIkdHwp1kUu0xXGSI
         v+WsS2ry+SxZHb8HRxtcqqy322vcXEZOmSjORm3FjfTCAcEhB2XwEz0Q5vPUPRONX/Nv
         BdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4qLPtvUWN+AfrLhyVfZ91N3yZnBEIddv2rouQHzCYLA=;
        b=1UONNbVEuDFY6zRY99MKo1XJTEdALGtliiawL0a/bfg1ilPh32kf/k9NkEPLogRTUA
         blwQv2/jC2CdtziHerqg3FzaT0ImtU+0+8BoBs9pBDrmHRqOaJnA/iugdAFI++1sKz2v
         F7IkZy+gRwB1g0iePTVDNHbP+THIn5fmoXQ1MPNAzgGs+AS8OybRAI5wty7LKkIclpWG
         xzEOvX0mkldCc+R0g/USR5nFhC/32C/ivNDfLO/EM5jar+rYd5dUicA6ISn0StDM+nfn
         JUJYNFBogB1ON8noQJ45gG34UI2fVEHFdsOtowzG9vcTP3cwr8KG8lD7NN7D6ULCWtOf
         NWsw==
X-Gm-Message-State: ACrzQf2kRGhBVf0VVuhNXfCKMr3UxcDMBAkcZmQC4eSJd+u3senqsX/I
        bHvEmYpMBiNCDcJoblclDQM=
X-Google-Smtp-Source: AMsMyM7wIF7Q/yLHfL4qpto23LFzYlOodjB18WlyAhMXTZyo5ET7oeG7w+FroLjnnh5vWx2LP52ZzQ==
X-Received: by 2002:adf:f347:0:b0:22c:be39:4e38 with SMTP id e7-20020adff347000000b0022cbe394e38mr2077945wrp.151.1664289011650;
        Tue, 27 Sep 2022 07:30:11 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id a5-20020a05600c224500b003b4fac020c8sm14022447wmm.16.2022.09.27.07.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 07:30:11 -0700 (PDT)
Message-ID: <021d8ea4-891c-237d-686e-64cecc2cc842@gmail.com>
Date:   Tue, 27 Sep 2022 15:28:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/4] shrink struct ubuf_info
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
 <7fef56880d40b9d83cc99317df9060c4e7cdf919.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7fef56880d40b9d83cc99317df9060c4e7cdf919.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

On 9/27/22 14:49, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-09-23 at 17:39 +0100, Pavel Begunkov wrote:
>> struct ubuf_info is large but not all fields are needed for all
>> cases. We have limited space in io_uring for it and large ubuf_info
>> prevents some struct embedding, even though we use only a subset
>> of the fields. It's also not very clean trying to use this typeless
>> extra space.
>>
>> Shrink struct ubuf_info to only necessary fields used in generic paths,
>> namely ->callback, ->refcnt and ->flags, which take only 16 bytes. And
>> make MSG_ZEROCOPY and some other users to embed it into a larger struct
>> ubuf_info_msgzc mimicking the former ubuf_info.
>>
>> Note, xen/vhost may also have some cleaning on top by creating
>> new structs containing ubuf_info but with proper types.
> 
> That sounds a bit scaring to me. If I read correctly, every uarg user
> should check 'uarg->callback == msg_zerocopy_callback' before accessing
> any 'extend' fields.

Providers of ubuf_info access those fields via callbacks and so already
know the actual structure used. The net core, on the opposite, should
keep it encapsulated and not touch them at all.

The series lists all places where we use extended fields just on the
merit of stripping the structure of those fields and successfully
building it. The only user in net/ipv{4,6}/* is MSG_ZEROCOPY, which
again uses callbacks.

Sounds like the right direction for me. There is a couple of
places where it might get type safer, i.e. adding types instead
of void* in for struct tun_msg_ctl and getting rid of one macro
hiding types in xen. But seems more like TODO for later.

> AFAICS the current code sometimes don't do the
> explicit test because the condition is somewhat implied, which in turn
> is quite hard to track.
> 
> clearing uarg->zerocopy for the 'wrong' uarg was armless and undetected
> before this series, and after will trigger an oops..

And now we don't have this field at all to access, considering that
nobody blindly casts it.

> There is some noise due to uarg -> uarg_zc renaming which make the
> series harder to review. Have you considered instead keeping the old
> name and introducing a smaller 'struct ubuf_info_common'? the overall
> code should be mostly the same, but it will avoid the above mentioned
> noise.

I don't think there will be less noise this way, but let me try
and see if I can get rid of some churn.

-- 
Pavel Begunkov
