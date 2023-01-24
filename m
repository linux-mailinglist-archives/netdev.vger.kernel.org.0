Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE716797F0
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjAXMZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjAXMZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:25:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53800C15D
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674563034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g+LfH6VeKj6sLIThRnQmmpIRj8db3/PJxpTjT61GUMA=;
        b=heyqN3Keit1zkg9bSvevb11BOOtbb8DavtF8k0ivQZN62CoElvMl88aFG6BxbwbEF/vDac
        wpDYWFWT33xu1HWIVJ2RRPL+30K3zx4Yx4A19ohK9uBb2KzzenWc06w2tWmzcVXVCtXQTK
        ufagEc1RTrrMprMx5MzlgPKg3El1WHw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-290-0BRZ0RSuNwOIr84ky6nnhg-1; Tue, 24 Jan 2023 07:23:53 -0500
X-MC-Unique: 0BRZ0RSuNwOIr84ky6nnhg-1
Received: by mail-ej1-f72.google.com with SMTP id og35-20020a1709071de300b00877faf0a4b4so344834ejc.6
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:23:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+LfH6VeKj6sLIThRnQmmpIRj8db3/PJxpTjT61GUMA=;
        b=orlM1GBblib7XBRbfJOgOwNSmb5D/OnT6epAIlmDeuvyVg2hV3sMo6tbak5yxQ0Kfx
         zO7T++krI4+id3lPR9fpshSgBUA7nFZ684LD8NxAe7BSEpjpvOOnDJCYXMaegMMHVPTw
         cU6O1T0YKQ9ykDBndItv/VeAbmTzKf1gnFIlyWZwi4drIk9ghEM/27TKNkUdBeO3tY6I
         /ZxIKNpRv/myq7GjCgs3QHynOuiYELGEmIyAoLeI7yqA9AxzVq4ZDKsuqhJhggBb6UE1
         8blkL4L0h7l+BwcBKJfVFrNW15YCplveiO/Urr+VT6G0CZtC/aCl/y4VeOvSDOKxr67v
         rIKQ==
X-Gm-Message-State: AO0yUKX0Tjj+fSwQsrL/uP3zKrVPuPznukKKrKjyCawkVzZxMSlZWff1
        GLW2zxh5Vxtq50RtqIqT28E4p45kaS6DCKuLvH/A1xW6GcbnNS1/ZCg/TSyTfNTxhsBfYEXhi7/
        FodI6rChridjL8soc
X-Received: by 2002:aa7:cd6c:0:b0:4a0:90cf:2232 with SMTP id ca12-20020aa7cd6c000000b004a090cf2232mr132275edb.27.1674563032371;
        Tue, 24 Jan 2023 04:23:52 -0800 (PST)
X-Google-Smtp-Source: AK7set/AGz7aqFGfsCwbtAAgOXUa2iUOH9MTJsLbnmhnuLJvNXNwcws5qQaSwx/ySYVoIk000QtbmQ==
X-Received: by 2002:aa7:cd6c:0:b0:4a0:90cf:2232 with SMTP id ca12-20020aa7cd6c000000b004a090cf2232mr132255edb.27.1674563032147;
        Tue, 24 Jan 2023 04:23:52 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id u4-20020a50eac4000000b0048ebe118a46sm658978edp.77.2023.01.24.04.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 04:23:51 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <da633a14-0d0e-0be3-6291-92313ab1550d@redhat.com>
Date:   Tue, 24 Jan 2023 13:23:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Martin KaFai Lau <martin.lau@linux.dev>,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Stanislav Fomichev <sdf@google.com>
References: <20230119221536.3349901-1-sdf@google.com>
 <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
 <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
 <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com> <87lelsp2yl.fsf@toke.dk>
In-Reply-To: <87lelsp2yl.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/01/2023 12.49, Toke Høiland-Jørgensen wrote:
> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
>> From: Stanislav Fomichev <sdf@google.com>
>> Date: Mon, 23 Jan 2023 10:55:52 -0800
>>
>>> On Mon, Jan 23, 2023 at 10:53 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>>
>>>> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
>>>>> Please see the first patch in the series for the overall
>>>>> design and use-cases.
>>>>>
>>>>> See the following email from Toke for the per-packet metadata overhead:
>>>>> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
>>>>>
>>>>> Recent changes:
>>>>> - Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops' (Tariq)
>>>>>
>>>>> - Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)
>>>>>
>>>>> - Clarify xdp_buff vs 'XDP frame' (Jesper)
>>>>>
>>>>> - Explicitly mention that AF_XDP RX descriptor lacks metadata size (Jesper)
>>>>>
>>>>> - Drop libbpf_flags/xdp_flags from selftests and use ifindex instead
>>>>>     of ifname (due to recent xsk.h refactoring)
>>>>
>>>> Applied with the minor changes in the selftests discussed in patch 11 and 17.
>>>> Thanks!
>>>
>>> Awesome, thanks! I was gonna resend around Wed, but thank you for
>>> taking care of that!
>> Great stuff, congrats! :)
> 
> Yeah! Thanks for carrying this forward, Stanislav! :)

+1000 -- great work everybody! :-)

To Alexander (Cc Jesse and Tony), do you think someone from Intel could
look at extending drivers:

  drivers/net/ethernet/intel/igb/ - chip i210
  drivers/net/ethernet/intel/igc/ - chip i225
  drivers/net/ethernet/stmicro/stmmac - for CPU integrated LAN ports

We have a customer that have been eager to get hardware RX-timestamping
for their AF_XDP use-case (PoC code[1] use software timestamping via
bpf_ktime_get_ns() today).  Getting driver support will qualify this
hardware as part of their HW solution.

--Jesper
[1] 
https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L77

