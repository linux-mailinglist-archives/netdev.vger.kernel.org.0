Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500D52D0C0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiESKnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbiESKnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:43:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B6EAAEE1F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652956996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TH+ICKBkv+npEh8DphvHokm9BJGopIGyRclr3HlZVLs=;
        b=T3/WxuLkJCrVB9de5Uj6J5y573YR5VZ0mutWbBv5/HurfaesQMqhD4aBP0sB35v/Qinnwu
        13CTVjllWhAmqtHQAJiYX2XFy2iwk+okvytRdnDtWRCw4QS3L8pwDIP/Ij4NIRMEoRIPYX
        uzftSNWjwub08gr8u6odOcyMq0yPRQ4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-3ozBdx3tOCe-cdsMAPFdig-1; Thu, 19 May 2022 06:43:15 -0400
X-MC-Unique: 3ozBdx3tOCe-cdsMAPFdig-1
Received: by mail-ed1-f70.google.com with SMTP id l18-20020aa7d952000000b0042ab7be9adaso3348574eds.21
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 03:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TH+ICKBkv+npEh8DphvHokm9BJGopIGyRclr3HlZVLs=;
        b=N5D+3cNzs/vMuS6F3X6SnYHQO8hKz+3udGrjZ2QabCFgzL0G0/nODXcAxbwTed3FEr
         zqwV69prsfLpskc7uliBSBdhzW/D5+NkIKvYtLY6vxUxwnKwkZczZHR4ilrRQhi5AFg8
         UaazOOYP2htOud+wqBgyqiaED/yn+8YHwcbpN5hV9sAL40mQZbv2mfAl/qzSysYd28V1
         yz5KtuE7J0DnM/pstaX4KiUkmRgxQr/k/UMPf96BdIvFcYHrGMlH51LEeiMqJtlVxlUY
         x37Fs6waeKqMB/yHN5Vx7sxLCJuORpVgG1WE5jNqFyIYkMEoFsGQdbWd181+u++IWoyo
         tUug==
X-Gm-Message-State: AOAM530oPbHzhE/KjjTqZDSbWXx164wMXK3pHU2YBtRvnyaivU/kVrT7
        vtdYe4YQGMAlnbS9XdlgWOj7JiWBOCMX4k/KWL1mqPgQzk9Mifvv8DRixjyd1fF/cy5P9ufvZt2
        hGifMBEahS+gV9DTA
X-Received: by 2002:a17:907:7248:b0:6fe:a121:d060 with SMTP id ds8-20020a170907724800b006fea121d060mr219603ejc.9.1652956994174;
        Thu, 19 May 2022 03:43:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHHvHWCE8grFkse1E+0Et3IrynHZBLQEcX4mCaSY2qLTTCfOjmb3O4tDa7n/CbxO+w2AwAfQ==
X-Received: by 2002:a17:907:7248:b0:6fe:a121:d060 with SMTP id ds8-20020a170907724800b006fea121d060mr219560ejc.9.1652956993791;
        Thu, 19 May 2022 03:43:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d12-20020a056402000c00b0042617ba637bsm2571532edu.5.2022.05.19.03.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 03:43:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A871E38EE12; Thu, 19 May 2022 12:43:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
In-Reply-To: <CAO-hwJL4Pj4JaRquoXD1AtegcKnh22_T0Z0VY_peZ8FRko3kZw@mail.gmail.com>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <YoX7iHddAd4FkQRQ@infradead.org> <YoX904CAFOAfWeJN@kroah.com>
 <YoYCIhYhzLmhIGxe@infradead.org>
 <CAO-hwJL4Pj4JaRquoXD1AtegcKnh22_T0Z0VY_peZ8FRko3kZw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 19 May 2022 12:43:12 +0200
Message-ID: <87ee0p951b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Tissoires <benjamin.tissoires@redhat.com> writes:

> On Thu, May 19, 2022 at 10:39 AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Thu, May 19, 2022 at 10:20:35AM +0200, Greg KH wrote:
>> > > are written using a hip new VM?
>> >
>> > Ugh, don't mention UDI, that's a bad flashback...
>>
>> But that is very much what we are doing here.
>>
>> > I thought the goal here was to move a lot of the quirk handling and
>> > "fixup the broken HID decriptors in this device" out of kernel .c code
>> > and into BPF code instead, which this patchset would allow.
>
> Yes, quirks are a big motivation for this work. Right now half of the
> HID drivers are less than 100 lines of code, and are just trivial
> fixes (one byte in the report descriptor, one key mapping, etc...).
> Using eBPF for those would simplify the process from the user point of
> view: you drop a "firmware fix" as an eBPF program in your system and
> you can continue working on your existing kernel.

How do you envision those BPF programs living, and how would they be
distributed? (In-tree / out of tree?)

-Toke

