Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1169059F6C6
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiHXJs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbiHXJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:48:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C1567478
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661334533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qiF7/qO+yisg9qjBhsaAka2ZWunzOCu9/3xjQqLrf9U=;
        b=W/bo8nXPtT+PU5WnRFJIDATmKMhacIvKXHQ2QlE8c7KXZM7ev5BWeRzLafoVF3YY62WmFG
        BV2+Jjuq8roy29BGbfkcfMz6cen2cca5OzZn9z9nUaMWVuPJ88ffyEIcdgiD04kaH567Ig
        eRUCAUl7KVuLAiVh/tFVJcPnOgUPnFI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-522-eVJADYQvNkeMQ9H3YdYeLg-1; Wed, 24 Aug 2022 05:48:52 -0400
X-MC-Unique: eVJADYQvNkeMQ9H3YdYeLg-1
Received: by mail-wr1-f71.google.com with SMTP id e14-20020adf9bce000000b002254afda62aso1628158wrc.18
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=qiF7/qO+yisg9qjBhsaAka2ZWunzOCu9/3xjQqLrf9U=;
        b=w3gOKttPYmiwoR8TmFTIfD6TnFUZ9t4Co0CWL1k2NFVJq1SWROWVOwGkJgd4T/Y09y
         Sro3WMFiybf1eb5c8DbELMyFjdi5RQSZploGWsHGLjMTNxH8MWecVT6CSzTOGmheLqeT
         FqTQ8zKnuJhTcYiG/ki40yId+Fbd4uY5UOHBs43jY8flqqEz5Rynr/yjfr13l4wx+Wn2
         wTNKcT+oqvjkpcN5GNU26wv7cIlrjXHrTJs8L5HxZT1g+VhPBLZN7UkgR2i03/KmBOFX
         qx5KdI5DKlUgWekOj4nMTluvQbcWSjGzNWZDL3c8dGudDYmso8Jse3VNW85oZFloiApf
         dyQA==
X-Gm-Message-State: ACgBeo0hf4WCySturDLvxfvxjMwUFJVGjx6sjixJP0I47sJQHJJkiEmr
        UvnagwfUXluW4C70vUoYQ6YlBDkqjhZDOmlQfmObQygOFM9Vi05eKcIJRMfZYtyjJyYtLoQBAHu
        ygNzqpQTCU8RNqiqZ
X-Received: by 2002:a5d:5986:0:b0:225:6216:5a79 with SMTP id n6-20020a5d5986000000b0022562165a79mr5828980wri.594.1661334530986;
        Wed, 24 Aug 2022 02:48:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5QheGVv9qlYiusEVisLJNGRUzET8ghwC3bQSFWUdMe6rMHsgYEyFps6VAi3eF+kzcPiQUQtg==
X-Received: by 2002:a5d:5986:0:b0:225:6216:5a79 with SMTP id n6-20020a5d5986000000b0022562165a79mr5828965wri.594.1661334530719;
        Wed, 24 Aug 2022 02:48:50 -0700 (PDT)
Received: from [192.168.110.200] (82-65-22-26.subs.proxad.net. [82.65.22.26])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c4f8500b003a601a1c2f7sm1367229wmq.19.2022.08.24.02.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 02:48:50 -0700 (PDT)
Message-ID: <f4624a16-ee0b-8e8e-a390-349d38f229b4@redhat.com>
Date:   Wed, 24 Aug 2022 11:48:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 13/24] HID: initial BPF implementation
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-14-benjamin.tissoires@redhat.com>
 <YuKbCCOAtSvUlI3z@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
In-Reply-To: <YuKbCCOAtSvUlI3z@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/22 16:19, Greg KH wrote:
> On Thu, Jul 21, 2022 at 05:36:14PM +0200, Benjamin Tissoires wrote:
>> --- /dev/null
>> +++ b/include/linux/hid_bpf.h
>> @@ -0,0 +1,102 @@
>> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> 
> This is not a uapi .h file, so the "WITH Linux-syscall-note" should not
> be here, right?

thanks, dropping this syscall note from the series.

> 
> 
>> +
>> +#ifndef __HID_BPF_H
>> +#define __HID_BPF_H
>> +
>> +#include <linux/spinlock.h>
>> +#include <uapi/linux/hid.h>
>> +#include <uapi/linux/hid_bpf.h>
>> +
>> +struct hid_device;
>> +
>> +/*
>> + * The following is the HID BPF API.
>> + *
>> + * It should be treated as UAPI, so extra care is required
>> + * when making change to this file.
> 
> So is this uapi?  If so, shouldn't it go into a uapi include directory
> so we know this and properly track it and maintain it that way?

IMO it's a grey area. It is not "uapi" because it doesn't export 
anything that userspace can use. A userspace program can not include 
that and use it in other words.

So strictly speaking, it's a normal part of a kernel header file, 
because it's a description of what other kernel users (though here, eBPF 
programs) can use.

But I really want that part of the API to be considered as "stable" and 
give some guarantees to the users that I won't change it at every 
release. Thus the "uapi-like".

> 
>> + */
>> +
>> +/**
>> + * struct hid_bpf_ctx - User accessible data for all HID programs
>> + *
>> + * ``data`` is not directly accessible from the context. We need to issue
>> + * a call to ``hid_bpf_get_data()`` in order to get a pointer to that field.
>> + *
>> + * All of these fields are currently read-only.
>> + *
>> + * @index: program index in the jump table. No special meaning (a smaller index
>> + *         doesn't mean the program will be executed before another program with
>> + *         a bigger index).
>> + * @hid: the ``struct hid_device`` representing the device itself
>> + * @report_type: used for ``hid_bpf_device_event()``
>> + * @size: Valid data in the data field.
>> + *
>> + *        Programs can get the available valid size in data by fetching this field.
>> + */
>> +struct hid_bpf_ctx {
>> +	__u32 index;
>> +	const struct hid_device *hid;
>> +	enum hid_report_type report_type;
>> +	__s32 size;
>> +};
>> +
>> +/* Following functions are tracepoints that BPF programs can attach to */
>> +int hid_bpf_device_event(struct hid_bpf_ctx *ctx);
>> +
>> +/* Following functions are kfunc that we export to BPF programs */
>> +/* only available in tracing */
>> +__u8 *hid_bpf_get_data(struct hid_bpf_ctx *ctx, unsigned int offset, const size_t __sz);
>> +
>> +/* only available in syscall */
>> +int hid_bpf_attach_prog(unsigned int hid_id, int prog_fd, __u32 flags);
>> +
>> +/*
>> + * Below is HID internal
>> + */
>> +
>> +/* internal function to call eBPF programs, not to be used by anybody */
>> +int __hid_bpf_tail_call(struct hid_bpf_ctx *ctx);
>> +
>> +#define HID_BPF_MAX_PROGS_PER_DEV 64
>> +#define HID_BPF_FLAG_MASK (((HID_BPF_FLAG_MAX - 1) << 1) - 1)
>> +
>> +/* types of HID programs to attach to */
>> +enum hid_bpf_prog_type {
>> +	HID_BPF_PROG_TYPE_UNDEF = -1,
>> +	HID_BPF_PROG_TYPE_DEVICE_EVENT,			/* an event is emitted from the device */
>> +	HID_BPF_PROG_TYPE_MAX,
>> +};
>> +
>> +struct hid_bpf_ops {
>> +	struct module *owner;
>> +	struct bus_type *bus_type;
>> +};
>> +
>> +extern struct hid_bpf_ops *hid_bpf_ops;
>> +
>> +struct hid_bpf_prog_list {
>> +	u16 prog_idx[HID_BPF_MAX_PROGS_PER_DEV];
>> +	u8 prog_cnt;
>> +};
>> +
>> +/* stored in each device */
>> +struct hid_bpf {
>> +	struct hid_bpf_prog_list __rcu *progs[HID_BPF_PROG_TYPE_MAX];	/* attached BPF progs */
>> +	bool destroyed;			/* prevents the assignment of any progs */
>> +
>> +	spinlock_t progs_lock;		/* protects RCU update of progs */
>> +};
>> +
>> +#ifdef CONFIG_HID_BPF
>> +int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
>> +				  u32 size, int interrupt);
>> +void hid_bpf_destroy_device(struct hid_device *hid);
>> +void hid_bpf_device_init(struct hid_device *hid);
>> +#else /* CONFIG_HID_BPF */
>> +static inline int dispatch_hid_bpf_device_event(struct hid_device *hid, enum hid_report_type type, u8 *data,
>> +						u32 size, int interrupt) { return 0; }
>> +static inline void hid_bpf_destroy_device(struct hid_device *hid) {}
>> +static inline void hid_bpf_device_init(struct hid_device *hid) {}
>> +#endif /* CONFIG_HID_BPF */
>> +
>> +#endif /* __HID_BPF_H */
>> diff --git a/include/uapi/linux/hid_bpf.h b/include/uapi/linux/hid_bpf.h
>> new file mode 100644
>> index 000000000000..ba8caf9b60ee
>> --- /dev/null
>> +++ b/include/uapi/linux/hid_bpf.h
>> @@ -0,0 +1,25 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> 
> This is fine, it is in include/uapi/
> 
> Other than those minor comments, this all looks good to me!
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

Great!
And thanks a lot for the other reviews.

I finally managed to get some time to work on it after some time off and 
urgent sh**t happening, so I'll send a new version of the series today.

Cheers,
Benjamin

