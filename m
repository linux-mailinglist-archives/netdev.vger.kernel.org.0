Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2435C671FD3
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjAROj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjAROjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:39:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A7137550
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674052119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zvohO/cAGi/GlRju0XPQ5MY7w85GbbV+IBrhlRqRyqg=;
        b=el2UBSgitT3dcct6yjx/EBzLUgY+X7WW6jBFLuFQyiAbxWjS3G3puyM1i8NMf/CYLRegx5
        602m3s9Twzsxz6jzz5On1mrJt3t1oP0dQOHKjTshl3oj9oC3z7bTMOg86pS3EpgMAtuwn1
        LSfubpYeudg1FdP20QxFd2hsurYBa64=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-GJR3pUYbMgWfm_x8aVDZ9w-1; Wed, 18 Jan 2023 09:28:38 -0500
X-MC-Unique: GJR3pUYbMgWfm_x8aVDZ9w-1
Received: by mail-ej1-f70.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso24092096ejb.14
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zvohO/cAGi/GlRju0XPQ5MY7w85GbbV+IBrhlRqRyqg=;
        b=x1VpYwxS/OcLWTM5105EAKactuUN/N25aHWMA7IqBrWWebuvXrRSQZ36ezgstJ2TyU
         y7ookdgef1rMCfOAg38rx+yJ9UTkkUcvO1XyI8ziyx/z+fjQGUt3Efa5EXsAe8JwGeAQ
         HORiZ+1EFG5iK0lSymZ44pFjgMtwHfRwacNKDgxdHeThNiwCKv2fUKv3oB5KSBAoHs54
         aG3PnQ2dAF92JdjDw73eLYvVLyXNEnQU7VbHjo/JRmTZhEvE+/F3XKAr/lhCg8z9cdS7
         yYoRrD4wy1LLalYgU9sCyJXTQI5py/aBvgJrylYELTaVmcV8q1kXhY9+kp+UrSgsswRa
         s5Hg==
X-Gm-Message-State: AFqh2kqrRzDzC9fALAoXaeckQ0ADHyily830Z6SMRAAaOgEPtefH97t6
        CkN8fppg235YXPqw7hLY2+8iefi0XqlzBTsHiFynO7keh+IZRPLAtsNps5SPU4FcHc73zfxbMN9
        Q81IZk9nCFm7QRzMR
X-Received: by 2002:a50:eac3:0:b0:499:b48b:2c3 with SMTP id u3-20020a50eac3000000b00499b48b02c3mr7114304edp.25.1674052117335;
        Wed, 18 Jan 2023 06:28:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuFLUJf8MuNit9FWrOTugYppUKXSNpuc7vMhIE+hzF9fX7e4lG5pAmiPAioshiQjMW+qb/yJg==
X-Received: by 2002:a50:eac3:0:b0:499:b48b:2c3 with SMTP id u3-20020a50eac3000000b00499b48b02c3mr7114277edp.25.1674052117041;
        Wed, 18 Jan 2023 06:28:37 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id la19-20020a170907781300b007aee7ca1199sm14857759ejc.10.2023.01.18.06.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 06:28:36 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <27e552c4-e1cf-40d3-305c-e4a57ab87bcf@redhat.com>
Date:   Wed, 18 Jan 2023 15:28:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, David Vernet <void@manifault.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Subject: Re: [PATCH bpf-next v7 01/17] bpf: Document XDP RX metadata
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-2-sdf@google.com>
 <affeb1e3-69e6-9783-0012-6d917972ba30@redhat.com>
 <CAKH8qBuE5ipcncQ+=su_Ds1EHm5gUMG_od-+eqJHkuiV-Q6RhQ@mail.gmail.com>
In-Reply-To: <CAKH8qBuE5ipcncQ+=su_Ds1EHm5gUMG_od-+eqJHkuiV-Q6RhQ@mail.gmail.com>
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


On 17/01/2023 21.33, Stanislav Fomichev wrote:
> On Mon, Jan 16, 2023 at 5:09 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>> On 12/01/2023 01.32, Stanislav Fomichev wrote:
>>> Document all current use-cases and assumptions.
>>>
[...]
>>> Acked-by: David Vernet <void@manifault.com>
>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> ---
>>>    Documentation/networking/index.rst           |   1 +
>>>    Documentation/networking/xdp-rx-metadata.rst | 108 +++++++++++++++++++
>>>    2 files changed, 109 insertions(+)
>>>    create mode 100644 Documentation/networking/xdp-rx-metadata.rst
>>>
>>> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
>>> index 4f2d1f682a18..4ddcae33c336 100644
>>> --- a/Documentation/networking/index.rst
>>> +++ b/Documentation/networking/index.rst
[...cut...]
>>> +AF_XDP
>>> +======
>>> +
>>> +:doc:`af_xdp` use-case implies that there is a contract between the BPF
>>> +program that redirects XDP frames into the ``AF_XDP`` socket (``XSK``) and
>>> +the final consumer. Thus the BPF program manually allocates a fixed number of
>>> +bytes out of metadata via ``bpf_xdp_adjust_meta`` and calls a subset
>>> +of kfuncs to populate it. The userspace ``XSK`` consumer computes
>>> +``xsk_umem__get_data() - METADATA_SIZE`` to locate that metadata.
>>> +Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
>>> +``METADATA_SIZE`` is an application-specific constant.
>>
>> The main problem with AF_XDP and metadata is that, the AF_XDP descriptor
>> doesn't contain any info about the length METADATA_SIZE.
>>
>> The text does says this, but in a very convoluted way.
>> I think this challenge should be more clearly spelled out.
>>
>> (p.s. This was something that XDP-hints via BTF have a proposed solution
>> for)
> 
> Any suggestions on how to clarify it better? I have two hints:
> 1. ``METADATA_SIZE`` is an application-specific constant
> 2. note missing ``data_meta`` pointer
> 
> Do you prefer I also add a sentence where I spell it out more
> explicitly? Something like:
> 
> Note, ``xsk_umem__get_data`` is defined in ``libxdp`` and
> ``METADATA_SIZE`` is an application-specific constant (``AF_XDP``
> receive descriptor does _not_ explicitly carry the size of the
> metadata).

That addition works for me.
(Later we can hopefully come up with a solution for this)

>>> +
>>> +Here is the ``AF_XDP`` consumer layout (note missing ``data_meta`` pointer)::
>>
>> The "note" also hint to this issue.
> 
> This seems like an explicit design choice of the AF_XDP? In theory, I
> don't see why we can't have a v2 receive descriptor format where we
> return the size of the metadata?

(Cc. Magnus+Bjørn)
Yes, it was a design choice from AF_XDP not to include the metadata length.

The AF_XDP descriptor, see struct  xdp_desc (below) from 
/include/uapi/linux/if_xdp.h.

  /* Rx/Tx descriptor */
  struct xdp_desc {
	__u64 addr;
	__u32 len;
	__u32 options;
  };

Does contain a 'u32 options' field, that we could use.

In previous discussions, the proposed solution (from Bjørn+Magnus) was
to use some bits in the 'options' field to say metadata is present, and
xsk_umem__get_data minus 4 (or 8) bytes contain a BTF_ID.  The AF_XDP
programmer can then get the metadata length by looking up the BTF_ID.


>>> +
>>> +  +----------+-----------------+------+
>>> +  | headroom | custom metadata | data |
>>> +  +----------+-----------------+------+
>>> +                               ^
>>> +                               |
>>> +                        rx_desc->address
>>> +
>>> +XDP_PASS
>>> +========
>>> +
>>> +This is the path where the packets processed by the XDP program are passed
>>> +into the kernel. The kernel creates the ``skb`` out of the ``xdp_buff``
>>> +contents. Currently, every driver has custom kernel code to parse
>>> +the descriptors and populate ``skb`` metadata when doing this ``xdp_buff->skb``
>>> +conversion, and the XDP metadata is not used by the kernel when building
>>> +``skbs``. However, TC-BPF programs can access the XDP metadata area using
>>> +the ``data_meta`` pointer.
>>> +
>>> +In the future, we'd like to support a case where an XDP program
>>> +can override some of the metadata used for building ``skbs``.
>>
>> Happy this is mentioned as future work.
> 
> As mentioned in a separate email, if you prefer to focus on that, feel

Yes, I'm going to work on PoC code that explore this area.

> free to drive it since I'm gonna look into the TX side first.

Happy to hear you are going to look into TX-side.
Are your use case related to TX timestamping?

--Jesper

