Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9A75F6275
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiJFITt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 04:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiJFITo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 04:19:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E8460E6
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 01:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665044381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwCjUrTl5eAHnjiz9iHXpu9SUcGA4ZwcUrBhyn+zXBI=;
        b=YOG5m5YHdvZWfNydQapZ0FC2Ui0B51l7D8IdX6mZ8in+eDA98u1znieUBCS/ddkLMVq3s4
        rtdBiFt5vHwy2CVal6ZY2JspPKtQkzuUIb5Q8KsIoy8ZcYmHRmwkSXiiHG/TXd853JDs11
        yQuwMJItvD4/S3W2IhF5M8LVPFqDFJk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-668-WqaIddsgMISUvtWrY8rgpg-1; Thu, 06 Oct 2022 04:19:40 -0400
X-MC-Unique: WqaIddsgMISUvtWrY8rgpg-1
Received: by mail-wm1-f69.google.com with SMTP id 133-20020a1c028b000000b003bd776ce0f3so2246687wmc.0
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 01:19:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TwCjUrTl5eAHnjiz9iHXpu9SUcGA4ZwcUrBhyn+zXBI=;
        b=KOXwq9tkSoKHvf8mUGUdb4L4NKwFSW5V/vTnP7WkGaMrkO1SyoWLE0fWtr51JjWD9/
         GfKTmpwtJtCMFt0dZFbYSfP1OzcEa24tZrd69jGR7sozuBCqlUVev7e+pdvZpfeFLrGF
         FRQus4L530F2/bWGuVAQquQJMO6MrOdPAKnG8hltbh8TOPOB9awMMThhBoms8CF3od5O
         jQV2s6350iw0RCdNtyCB4FAK8vDrExTZ/eJCFhvRFta2LYXUjFLhTuyJNndERDuzxaSv
         NOmtR+bW1Ccz0da69vIPErUyM+W5HLj1RzEZVG08J3RT6U+IwxP4BIILXSnEjEkb7wqP
         Nfdw==
X-Gm-Message-State: ACrzQf1+yeY7Q5Woxu0f6Zsysy5TEDmctESRUeKBsrR0KC6J/K/Pv2Ls
        eWCeE/RmUlMJdLaJlpUyt+8iBiPLKbFFIHKmlMZSqgoz7ddAnm9XCB05m+OUTcvOOEWzM+r64RP
        rk00n2kNNDeFjss85
X-Received: by 2002:a05:6000:104:b0:22e:74bb:3a49 with SMTP id o4-20020a056000010400b0022e74bb3a49mr519331wrx.349.1665044378792;
        Thu, 06 Oct 2022 01:19:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5oDrwJG8M/Mmqdr1AF7j1dusO/ZuyNmiWwrEOo0jYffmCBM+zotrhVhNpMQa0B9nmDuEJ4lw==
X-Received: by 2002:a05:6000:104:b0:22e:74bb:3a49 with SMTP id o4-20020a056000010400b0022e74bb3a49mr519319wrx.349.1665044378533;
        Thu, 06 Oct 2022 01:19:38 -0700 (PDT)
Received: from [192.168.0.4] ([78.17.186.98])
        by smtp.gmail.com with ESMTPSA id g3-20020a7bc4c3000000b003bd83d8c0f2sm4329089wmk.16.2022.10.06.01.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 01:19:37 -0700 (PDT)
Message-ID: <be3f16a2-8422-4a34-3eb9-3943753d453e@redhat.com>
Date:   Thu, 6 Oct 2022 09:19:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.1
Subject: Re: [xdp-hints] Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP
 gaining access to HW offload hints via BTF
Content-Language: en-US
To:     sdf@google.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com>
 <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
 <20221004175952.6e4aade7@kernel.org>
 <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
 <87h70iinzc.fsf@toke.dk> <Yz3RQbh2TocpnuX0@google.com>
From:   Maryam Tahhan <mtahhan@redhat.com>
In-Reply-To: <Yz3RQbh2TocpnuX0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2022 19:47, sdf@google.com wrote:
> On 10/05, Toke H�iland-J�rgensen wrote:
>> Stanislav Fomichev <sdf@google.com> writes:
> 
>> > On Tue, Oct 4, 2022 at 5:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> >>
>> >> On Tue, 4 Oct 2022 17:25:51 -0700 Martin KaFai Lau wrote:
>> >> > A intentionally wild question, what does it take for the driver 
>> to return the
>> >> > hints.  Is the rx_desc and rx_queue enough?  When the xdp prog is 
>> calling a
>> >> > kfunc/bpf-helper, like 'hwtstamp = bpf_xdp_get_hwtstamp()', can 
>> the driver
>> >> > replace it with some inline bpf code (like how the inline code is 
>> generated for
>> >> > the map_lookup helper).  The xdp prog can then store the hwstamp 
>> in the meta
>> >> > area in any layout it wants.
>> >>
>> >> Since you mentioned it... FWIW that was always my preference rather 
>> than
>> >> the BTF magic :)  The jited image would have to be per-driver like we
>> >> do for BPF offload but that's easy to do from the technical
>> >> perspective (I doubt many deployments bind the same prog to multiple
>> >> HW devices)..
>> >
>> > +1, sounds like a good alternative (got your reply while typing)
>> > I'm not too versed in the rx_desc/rx_queue area, but seems like worst
>> > case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
>> > parse it out from the pre-populated metadata?
>> >
>> > Btw, do we also need to think about the redirect case? What happens
>> > when I redirect one frame from a device A with one metadata format to
>> > a device B with another?
> 
>> Yes, we absolutely do! In fact, to me this (redirects) is the main
>> reason why we need the ID in the packet in the first place: when running
>> on (say) a veth, an XDP program needs to be able to deal with packets
>> from multiple physical NICs.
> 
>> As far as API is concerned, my hope was that we could solve this with a
>> CO-RE like approach where the program author just writes something like:
> 
>> hw_tstamp = bpf_get_xdp_hint("hw_tstamp", u64);
> 
>> and bpf_get_xdp_hint() is really a macro (or a special kind of
>> relocation?) and libbpf would do the following on load:
> 
>> - query the kernel BTF for all possible xdp_hint structs
>> - figure out which of them have an 'u64 hw_tstamp' member
>> - generate the necessary conditionals / jump table to disambiguate on
>>    the BTF_ID in the packet
> 
> 
>> Now, if this is better done by a kfunc I'm not terribly opposed to that
>> either, but I'm not sure it's actually better/easier to do in the kernel
>> than in libbpf at load time?
> 
> Replied in the other thread, but to reiterate here: then btf_id in the
> metadata has to stay and we either pre-generate those bpf_get_xdp_hint()
> at libbpf or at kfunc load time level as you mention.
> 
> But the program essentially has to handle all possible hints' btf ids 
> thrown
> at it by the system. Not sure about the performance in this case :-/
> Maybe that's something that can be hidden behind "I might receive forwarded
> packets and I know how to handle all metadata format" flag? By default,
> we'll pre-generate parsing only for that specific device?

I did a simple POC of Jespers xdp-hints with AF-XDP and CNDP (Cloud 
Native Data Plane). In the cases where my app had access to the HW I 
didn't need to handle all possible hints... I knew what Drivers were on 
the system and they were the hints I needed to deal with.

So at program init time I registered the relevant BTF_IDs (and some 
callback functions to handle them) from the NICs that were available to 
me in a simple tailq (tbh there were so few I could've probably used a 
static array).

When processing the hints then I only needed to invoke the appropriate 
callback function based on the received BTF_ID. I didn't have a massive 
chains of if...else if... else statements.

In the case where we have redirection to a virtual NIC and we don't 
necessarily know the underlying hints that are exposed to the app, could 
we not still use the xdp_hints (as proposed by Jesper) themselves to 
indicate the relevant drivers to the application? or even indicate them 
via a map or something?

