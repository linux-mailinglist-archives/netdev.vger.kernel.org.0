Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029A35F5643
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 16:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJEOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJEOTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 10:19:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B30F2A
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 07:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664979576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vkdopemxb6Z46dw820Cf0moMwpkc0fcV+gICJjjuVD8=;
        b=gaVOxGwLX0YdlhppqAh5dw+Apwv0b+egrlZxPFeuXpOM0+4nDLduwU3mMnfMysKuw2hGYY
        F1qTA5sYTss/qT0PqP9jQneDO5ciDydgOq635VRmJo9HTakunvlNIgVWeB/7PiZv125Qph
        DRK2xuZTcNv0D+ISPFkjR2/JfLfQjFw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-kCnn-n5vOhaCtOaxz4tcPg-1; Wed, 05 Oct 2022 10:19:34 -0400
X-MC-Unique: kCnn-n5vOhaCtOaxz4tcPg-1
Received: by mail-ed1-f72.google.com with SMTP id v11-20020a056402348b00b004516e0b7eedso13616052edc.8
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 07:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=Vkdopemxb6Z46dw820Cf0moMwpkc0fcV+gICJjjuVD8=;
        b=rkST2puRRcwehgv/zqR5fEWwP8D7Xt7pdDGfmQ9i3pESNmYRPPodew1XvnUETDCRIx
         NqHFhm5MMi6zezxwLhoqzOVdLfmnAsd5OYNpqBudON9sWBov3FWQxDmr62ffzp8gWP3T
         HKDZrSpUfxoE9sqVVm/6v+fQk29DULB2RSRJekB4s9jhySput1xAvjYF6IbHAhlxIUBR
         8BGS2f7HGk9FH1pHzG9QkrDpGENVynVJ3MZUP9wv0JR3s6EhHdVkigOIrYCs1TeCQAe5
         oskBqffsLw9C0yJE6H/76DVz+ObNr1B+OyFLyohZvxVCgqLBSHEFZcVm9q9/LxndmgWq
         5LDg==
X-Gm-Message-State: ACrzQf27nfT6+jhWpb/uZWNJg9YoxbEgDkJ69sk6glH232+xsy/11/1t
        qhWx1HOtcpq/q+ycsNcXQ5JsII4TvYMnuebUg7XIELkarjwUxiS4qubvXIXaOQReMzpSLW3x6+0
        H8SgGia5ubgnvd7n8
X-Received: by 2002:a17:906:fe49:b0:73d:70c5:1a52 with SMTP id wz9-20020a170906fe4900b0073d70c51a52mr24303882ejb.469.1664979573478;
        Wed, 05 Oct 2022 07:19:33 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4vPuLz3Q3Ub9HPZp1hFZaBzSZ/qlVOyIBmW79DZsmIc167/r7nCD1F3sRsGclYwUSk6MdJOg==
X-Received: by 2002:a17:906:fe49:b0:73d:70c5:1a52 with SMTP id wz9-20020a170906fe4900b0073d70c51a52mr24303854ejb.469.1664979573233;
        Wed, 05 Oct 2022 07:19:33 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906211100b0077d37a5d401sm8772888ejt.33.2022.10.05.07.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 07:19:32 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <55542209-03d7-590f-9ab1-bbbf924d033c@redhat.com>
Date:   Wed, 5 Oct 2022 16:19:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
 <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
In-Reply-To: <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/10/2022 03.02, Stanislav Fomichev wrote:
> On Tue, Oct 4, 2022 at 5:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 4 Oct 2022 17:25:51 -0700 Martin KaFai Lau wrote:
>>> A intentionally wild question, what does it take for the driver to return the
>>> hints.  Is the rx_desc and rx_queue enough?  When the xdp prog is calling a
>>> kfunc/bpf-helper, like 'hwtstamp = bpf_xdp_get_hwtstamp()', can the driver
>>> replace it with some inline bpf code (like how the inline code is generated for
>>> the map_lookup helper).  The xdp prog can then store the hwstamp in the meta
>>> area in any layout it wants.
>>
>> Since you mentioned it... FWIW that was always my preference rather than
>> the BTF magic :)  The jited image would have to be per-driver like we
>> do for BPF offload but that's easy to do from the technical
>> perspective (I doubt many deployments bind the same prog to multiple
>> HW devices)..

On the technical side we do have the ifindex that can be passed along
which is currently used for getting XDP hardware offloading to work.
But last time I tried this, I failed due to BPF tail call maps.
(It's not going to fly for other reasons, see redirect below).

> 
> +1, sounds like a good alternative (got your reply while typing)
> I'm not too versed in the rx_desc/rx_queue area, but seems like worst
> case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
> parse it out from the pre-populated metadata?
> 
> Btw, do we also need to think about the redirect case? What happens
> when I redirect one frame from a device A with one metadata format to
> a device B with another?

Exactly the problem.  With XDP redirect the "remote" target device also
need to interpret this metadata layout.  For RX-side we have the
immediate case with redirecting into a veth device.   For future TX-side
this is likely the same kind of issue, but I hope if we can solve this
for veth redirect use-case, this will keep us future proof.

For veth use-case I hope that we can use same trick as
bpf_core_field_exists() to do dead-code elimination based on if a device
driver is loaded on the system like this pseudo code:


  if (bpf_core_type_id_kernel(struct xdp_hints_i40e_timestamp)) {
    /* check id + extract timestamp */
  }
  if (bpf_core_type_id_kernel(struct xdp_hints_ixgbe_timestamp)) {
    /* check id + extract timestamp */
  }

If the given device drives doesn't exist on the system, I assume
bpf_core_type_id_kernel() will return 0 at libbpf relocation/load-time,
and thus this should cause dead-code elimination.  Should work today AFAIK?

--Jesper

