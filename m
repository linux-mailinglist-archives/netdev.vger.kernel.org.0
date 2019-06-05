Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38CA36077
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfFEPmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:42:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41776 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbfFEPmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:42:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id q17so15063323pfq.8
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 08:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjlv+ApWLX3HTsuf1Vi48F2A2yBt/brxhNfn4nOtyNs=;
        b=P0Kv1alhEKK5pUGiSSWhrYnZOyP8CZpF1MrHuS38MumUOEfwxizgmblN1WWbtF+RDM
         MFER8JTpetmZTQNlN2uWWrDMv1sYafcpIuoZnEJ8YTDdI7CnE8wn4fOul4+klLnB01AP
         RaptjBunVnkad3N77o2KsdgT7duzrZK6+CU4bfBv7SPkG61tmq7I7NGEzLxqHeyCE7VY
         s6rf2ygG7THD5okIk+JMlv2F79LWr1mzojeuhXsyuS/qfvhcsAPNh2q8hLv39y4plzPQ
         tckUWGmCF5Miopov3AWK0mQzi6JEL1Uwh7BaH8lRBFL3VHufQCQ2zxapCZXEGHBP3exf
         etfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjlv+ApWLX3HTsuf1Vi48F2A2yBt/brxhNfn4nOtyNs=;
        b=R8YE8EzEVR1/HGKr+RnPQm7uemHKFkQFDCM0TvmbRbFc4pwslB8M0n/Dcj9fsBHxb9
         Efh8rpMj+FG3XlK8KAMwbq7t3/yYw8LTffNBQvyjjY8u/+RWTa9KSln3KpKf4Li9iNpQ
         aFj2dyhu9tRuj8qZ/o748bztHI3+vhiFveT4FBuEgafUPNhmYra8sYzUhpjGq49cauax
         dAsjKZpQafckWKAf1i6l3uA5DSippMM3QiIbX0/fwaOZ/zSi480ixZExV1tIhaSn14Qx
         0Og/F/Q+pnp36nu0hShNgx+Kmo07VoZop/O9kRJNJBaLnHnQcdFJ4dpX2EqtxEBw0rRT
         ctqA==
X-Gm-Message-State: APjAAAVNGj8ZQwSA6Rsj47REjExfOZoDi4g1q7+2gQgV3g803j7zBKWE
        iMVDFI+brGyvLt9FvtCxzMw=
X-Google-Smtp-Source: APXvYqw7i+u7ZpF+0NY6r/2rqh6IrZu9/6YzdPDia7Me7D75SWI0p/7ubTffE3OUSX09pdYxz8ke0w==
X-Received: by 2002:a17:90a:d151:: with SMTP id t17mr31703159pjw.60.1559749370111;
        Wed, 05 Jun 2019 08:42:50 -0700 (PDT)
Received: from [172.20.85.241] ([2620:10d:c090:180::1:bf6])
        by smtp.gmail.com with ESMTPSA id i22sm21047495pfa.127.2019.06.05.08.42.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 08:42:49 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@gmail.com>
Cc:     "Martin Lau" <kafai@fb.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        netdev@vger.kernel.org, "Kernel Team" <Kernel-team@fb.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Date:   Wed, 05 Jun 2019 08:42:48 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <1E4A2FA7-E759-450A-8979-F7CCD7F653C4@gmail.com>
In-Reply-To: <CAJ+HfNiQ-wO+sT_6FHAMHw7eDv-kMNjg0ecUmHa_TKg-gPXCyA@mail.gmail.com>
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
 <20190603163852.2535150-2-jonathan.lemon@gmail.com>
 <20190604184306.362d9d8e@carbon>
 <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com>
 <20190604181202.bose7inhbhfgb2rc@kafai-mbp.dhcp.thefacebook.com>
 <CAJ+HfNiQ-wO+sT_6FHAMHw7eDv-kMNjg0ecUmHa_TKg-gPXCyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5 Jun 2019, at 1:45, Björn Töpel wrote:

> On Tue, 4 Jun 2019 at 20:13, Martin Lau <kafai@fb.com> wrote:
>>
>> On Tue, Jun 04, 2019 at 10:25:23AM -0700, Jonathan Lemon wrote:
>>> On 4 Jun 2019, at 9:43, Jesper Dangaard Brouer wrote:
>>>
>>>> On Mon, 3 Jun 2019 09:38:51 -0700
>>>> Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>>>>
>>>>> Currently, the AF_XDP code uses a separate map in order to
>>>>> determine if an xsk is bound to a queue.  Instead of doing this,
>>>>> have bpf_map_lookup_elem() return the queue_id, as a way of
>>>>> indicating that there is a valid entry at the map index.
>>>>
>>>> Just a reminder, that once we choose a return value, there the
>>>> queue_id, then it basically becomes UAPI, and we cannot change it.
>>>
>>> Yes - Alexei initially wanted to return the sk_cookie instead, but
>>> that's 64 bits and opens up a whole other can of worms.
>>>
>>>
>>>> Can we somehow use BTF to allow us to extend this later?
>>>>
>>>> I was also going to point out that, you cannot return a direct pointer
>>>> to queue_id, as BPF-prog side can modify this... but Daniel already
>>>> pointed this out.
>>>
>>> So, I see three solutions here (for this and Toke's patchset also,
>>> which is encountering the same problem).
>>>
>>> 1) add a scratch register (Toke's approach)
>>> 2) add a PTR_TO_<type>, which has the access checked.  This is the most
>>>    flexible approach, but does seem a bit overkill at the moment.
>> I think it would be nice and more extensible to have PTR_TO_xxx.
>> It could start with the existing PTR_TO_SOCKET
>>
>> or starting with a new PTR_TO_XDP_SOCK from the beginning is also fine.
>>
>
> Doesn't the PTR_TO_SOCKET path involve taking a ref and mandating
> sk_release() from the fast path? :-(

AF_XDP sockets are created with SOCK_RCU_FREE, and used under rcu, so
I don't think that they need to be refcounted.  bpf_sk_release is a NOP
in the RCU_FREE case.
-- 
Jonathan
