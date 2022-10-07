Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44025F7A39
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJGPFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 11:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiJGPFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:05:22 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B177731EF3;
        Fri,  7 Oct 2022 08:05:17 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id h18so2654914ilh.3;
        Fri, 07 Oct 2022 08:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3UB2+S6iNV+PuAZHciHp5nePjKHIWTaoahZDj7m4Io=;
        b=FICWIEjxLZ+/dltKbSCq5lsDAk6uDv5/muVS5LntEWF0P7ZyROuPk/xfhT3MKCnjBs
         SRruhIFi+D9y9Aw4OkkIzE6LJzWaqMeSCQ9E3YLfCLOvPm4dUwOyFOoA+C+elkdzEMHr
         bDVbkMMbyt5XgVXqCfwrEBmNLt4O0J30KQdepgtatw7zt77szOewrRGiN25R/+2rdu8n
         2SLTQ2vGvCRigk2OzfrE64TuUMGsRHq99Vh82OcDZUmDi5C3UjYHxDTlUdJOSqoEq7b5
         /B2OsSsUpE3F+vempvhkWc16H75Bo56VjmLsBCt98xuF0bO71lnAN+0iqd/Itqkx5Qxa
         c3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3UB2+S6iNV+PuAZHciHp5nePjKHIWTaoahZDj7m4Io=;
        b=Kv2y4XR+71k1X87hbXdkm12VsoycnV6xkm+NXQVmLIZ+cXxrGjsKw0z2/HiV8hwuIZ
         kDZ+Hm/GjARDTNtp+2zVX5QFRrnAbMNS6bsPQZi+zjqVZFCxLCE0dyX83qb+qNsiwAan
         7jJ+4gXTyCpD65iZfFC+A0pp3VhS7e1DtEazqnYSUVeIWsnHac6umSPjjIk5J70IaaRc
         u6ijm0lfTz6Zgwfs8yrJbwqBWcWyd8HJTAT9tA2jy/P9HjKyZa8J389C6erR/sKLtWSk
         sl2CPI9hgaOeNNl4Py4+V2Ibpvhz2lKmK7bc10Ym9mzT00J7j3fri+hgxxNa/6C5fQ6O
         jBvQ==
X-Gm-Message-State: ACrzQf3EfkMP04o5hmD+ixQ490b9/n7Vt/6qDN87HL5R0oi/Vk4/k9ro
        WeV9JaU+ZoPeZAy7L+vLRYI+1ztrpls=
X-Google-Smtp-Source: AMsMyM5UJUkkQ7+PXwUoPy1vlfcGid2bJy4kg4orcRdxrsSax1VFbzXbB67rP5TuW2buceZI2SmQLg==
X-Received: by 2002:a92:cda7:0:b0:2fa:74e:9ca1 with SMTP id g7-20020a92cda7000000b002fa074e9ca1mr2431962ild.323.1665155117033;
        Fri, 07 Oct 2022 08:05:17 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:38e6:13c8:49a3:2476? ([2601:282:800:dc80:38e6:13c8:49a3:2476])
        by smtp.googlemail.com with ESMTPSA id c1-20020a92cf01000000b002eb1137a774sm976579ilo.59.2022.10.07.08.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 08:05:16 -0700 (PDT)
Message-ID: <7518b0ec-ef27-6cc7-65c2-6d4b956b301a@gmail.com>
Date:   Fri, 7 Oct 2022 09:05:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP
 gaining access to HW offload hints via BTF
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, sdf@google.com
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <982b9125-f849-5e1c-0082-7239b8c8eebf@redhat.com>
 <Yz3QNM7061WmXDHS@google.com>
 <ebbb99a1-c3c8-6d97-4bb3-03f28a0a74b1@redhat.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <ebbb99a1-c3c8-6d97-4bb3-03f28a0a74b1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/22 11:47 AM, Jesper Dangaard Brouer wrote:
> 
> 
>> I also feel like xdp_hints_common is
>> a bit distracting. It makes the common case easy and it hides the
>> discussion/complexity about per-device hints. Maybe we can drop this
>> common case at all? Why can't every driver has a custom hints struct?
>> If we agree that naming/size will be the same across them (and review
>> catches/guaranteed that), why do we even care about having common
>> xdp_hints_common struct?
> 
> The xdp_hints_common struct is a stepping stone to making this easily
> consumable from C-code that need to generate SKBs and info for
> virtio_net 'hdr' desc.
> 
> David Ahern have been begging me for years to just add this statically
> to xdp_frame.  I have been reluctant, because I think we can come up
> with a more flexible (less UAPI fixed) way, that both allows kerne-code
> and BPF-prog to access these fields.  I think of this approach as a
> compromise between these two users.
> 

Simple implementation for common - standard - networking features; jump
through hoops to use vendor unique features. Isn't that point of
standardization?

There are multiple use cases where vlans and checksumming requests need
to traverse devices on an XDP redirect.
