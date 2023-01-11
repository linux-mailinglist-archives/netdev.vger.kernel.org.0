Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B595665470
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjAKGUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjAKGT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:19:59 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA99FE0A7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:19:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso16033713pjf.1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dSnK+amNRW+rHXJfTqvbLYb33E3j0tmAwfWlfG8ZZ9Q=;
        b=tqzmj2UBtkSMZ/tIFzP4h3jSYAGj4585ZBDKxHy6vHHixIIC0BMUJOiaSw3He92GHm
         DVVMHg9DvRdRItwka9z3y49pGbTKoO7Q9fMB8EtYRwUNYU4WBNiwnNGn2F07k7DI4mlq
         z3fYhN9fIlWQjOi5LTqDUCY79Ck4Yj2X4J0hJyMjv8MSctr9o5vfg5W26d5q+hcyNYgL
         moELVxWvVzjFIxIqZlUMBLha5bcsn2ekV1coOGzY8esbkL6cM9Za7ytzIVyqpMgwE9yH
         dYj5PaUglGiXlG3fH/EqrkLj8aEzYih5TeDxEvO+as2TZaicKyyIcRWerCG1h6Shiv/a
         fCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dSnK+amNRW+rHXJfTqvbLYb33E3j0tmAwfWlfG8ZZ9Q=;
        b=sQVeFwZgiFxd/QzdJXbxFiPrHr3CyFefEyvv7FmxyIc7B+Y9dWfpbs0g/a7ZwV0Uq1
         6/e9TE+ZnkIYNlf5nIHqCw/5oMWztYBgZqh+MzDTPPsbAmyf9KrTqdqg8G8rtgwApzeV
         HLFSybbbras/rxbn1ipQjOY11tCCtLT2RsOQS93hpN0idPZWNwmjcPOz93WFX6NzuKrM
         DHTWJ3ETz47T/eUzkEWL4XFw7m+M6vbt3exqJYNOdzSpUVIdMboRYsogYaIb4iiU0ESl
         f8FcsorHXT0OmuvMDwOl+W2H2fYxDW9Z6PN7fqqkMXMIrgAWYttHflsfWFJw66YwVf7P
         qWFA==
X-Gm-Message-State: AFqh2koZHrZ+oprBrQGJLl56VM14hqDZewh7ZS/UgLGwUkw2PznSDhE9
        92zW3/XDOgNy1cUdoe8flWT7OA==
X-Google-Smtp-Source: AMrXdXuAA/pwlHUIGKmtVD4+vVbSZUnAzmrSA0r3cXxpSlgsaV/PMjVeX2/7uaU3SbyvVbdyXO9E/Q==
X-Received: by 2002:a05:6a20:6f59:b0:a4:8725:fdcd with SMTP id gu25-20020a056a206f5900b000a48725fdcdmr71069560pzb.15.1673417996377;
        Tue, 10 Jan 2023 22:19:56 -0800 (PST)
Received: from [10.16.128.218] (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id t21-20020a635355000000b0049f5da82b12sm7451111pgl.93.2023.01.10.22.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 22:19:56 -0800 (PST)
Message-ID: <fb4c0675-e94f-209c-fa33-dcf79147ebb0@igel.co.jp>
Date:   Wed, 11 Jan 2023 15:19:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to
 vringh_kiov
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221227022528.609839-1-mie@igel.co.jp>
 <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
 <CANXvt5rfXDYa0nLzKW5-Q-hjhw-19npXVneqBO1TcsariU6rWg@mail.gmail.com>
 <CACGkMEvmZ5MEX4WMa3JhzT404C2uhsNk0nnkYBRtvLPhNTSzHQ@mail.gmail.com>
 <18a0a7cd-0601-0ff6-12d7-353819692155@igel.co.jp>
 <CACGkMEsVeE9G=-OkvazGu_EtfKgD8iakon54iLgFFPWYJSSekg@mail.gmail.com>
From:   Shunsuke Mie <mie@igel.co.jp>
In-Reply-To: <CACGkMEsVeE9G=-OkvazGu_EtfKgD8iakon54iLgFFPWYJSSekg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2023/01/11 14:54, Jason Wang wrote:
> On Wed, Jan 11, 2023 at 11:27 AM Shunsuke Mie <mie@igel.co.jp> wrote:
>>
>> On 2022/12/28 15:36, Jason Wang wrote:
>>> On Tue, Dec 27, 2022 at 3:06 PM Shunsuke Mie <mie@igel.co.jp> wrote:
>>>> 2022年12月27日(火) 15:04 Jason Wang <jasowang@redhat.com>:
>>>>> On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
>>>>>> struct vringh_iov is defined to hold userland addresses. However, to use
>>>>>> common function, __vring_iov, finally the vringh_iov converts to the
>>>>>> vringh_kiov with simple cast. It includes compile time check code to make
>>>>>> sure it can be cast correctly.
>>>>>>
>>>>>> To simplify the code, this patch removes the struct vringh_iov and unifies
>>>>>> APIs to struct vringh_kiov.
>>>>>>
>>>>>> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
>>>>> While at this, I wonder if we need to go further, that is, switch to
>>>>> using an iov iterator instead of a vringh customized one.
>>>> I didn't see the iov iterator yet, thank you for informing me.
>>>> Is that iov_iter? https://lwn.net/Articles/625077/
>>> Exactly.
>> I've investigated the iov_iter, vhost and related APIs. As a result, I
>> think that it is not easy to switch to use the iov_iter. Because, the
>> design of vhost and vringh is different.
> Yes, but just to make sure we are on the same page, the reason I
> suggest iov_iter for vringh is that the vringh itself has customized
> iter equivalent, e.g it has iter for kernel,user, or even iotlb. At
> least the kernel and userspace part could be switched to iov_iter.
> Note that it has nothing to do with vhost.
I agree. It can be switch to use iov_iter, but I think we need to change
fundamentally. There are duplicated code on vhost and vringh to access
vring, and some helper functions...

Anyway, I'd like to focus vringh in this patchset. Thank you for your

comments and suggestions!


Best

>> The iov_iter has vring desc info and meta data of transfer method. The
>> vhost provides generic transfer function for the iov_iter. In constrast,
>> vringh_iov just has vring desc info. The vringh provides transfer functions
>> for each methods.
>>
>> In the future, it is better to use common data structure and APIs between
>> vhost and vringh (or merge completely), but it requires a lot of
>> changes, so I'd like to just
>> organize data structure in vringh as a first step in this patch.
> That's fine.
>
> Thansk
>
>>
>> Best
>>
>>> Thanks
>>>
>>>>> Thanks
>>>>>
>>>>>> ---
>>>>>>    drivers/vhost/vringh.c | 32 ++++++------------------------
>>>>>>    include/linux/vringh.h | 45 ++++--------------------------------------
>>>>>>    2 files changed, 10 insertions(+), 67 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
>>>>>> index 828c29306565..aa3cd27d2384 100644
>>>>>> --- a/drivers/vhost/vringh.c
>>>>>> +++ b/drivers/vhost/vringh.c
>>>>>> @@ -691,8 +691,8 @@ EXPORT_SYMBOL(vringh_init_user);
>>>>>>     * calling vringh_iov_cleanup() to release the memory, even on error!
>>>>>>     */
>>>>>>    int vringh_getdesc_user(struct vringh *vrh,
>>>>>> -                       struct vringh_iov *riov,
>>>>>> -                       struct vringh_iov *wiov,
>>>>>> +                       struct vringh_kiov *riov,
>>>>>> +                       struct vringh_kiov *wiov,
>>>>>>                           bool (*getrange)(struct vringh *vrh,
>>>>>>                                            u64 addr, struct vringh_range *r),
>>>>>>                           u16 *head)
>>>>>> @@ -708,26 +708,6 @@ int vringh_getdesc_user(struct vringh *vrh,
>>>>>>           if (err == vrh->vring.num)
>>>>>>                   return 0;
>>>>>>
>>>>>> -       /* We need the layouts to be the identical for this to work */
>>>>>> -       BUILD_BUG_ON(sizeof(struct vringh_kiov) != sizeof(struct vringh_iov));
>>>>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, iov) !=
>>>>>> -                    offsetof(struct vringh_iov, iov));
>>>>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, i) !=
>>>>>> -                    offsetof(struct vringh_iov, i));
>>>>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, used) !=
>>>>>> -                    offsetof(struct vringh_iov, used));
>>>>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, max_num) !=
>>>>>> -                    offsetof(struct vringh_iov, max_num));
>>>>>> -       BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
>>>>>> -       BUILD_BUG_ON(offsetof(struct iovec, iov_base) !=
>>>>>> -                    offsetof(struct kvec, iov_base));
>>>>>> -       BUILD_BUG_ON(offsetof(struct iovec, iov_len) !=
>>>>>> -                    offsetof(struct kvec, iov_len));
>>>>>> -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_base)
>>>>>> -                    != sizeof(((struct kvec *)NULL)->iov_base));
>>>>>> -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_len)
>>>>>> -                    != sizeof(((struct kvec *)NULL)->iov_len));
>>>>>> -
>>>>>>           *head = err;
>>>>>>           err = __vringh_iov(vrh, *head, (struct vringh_kiov *)riov,
>>>>>>                              (struct vringh_kiov *)wiov,
>>>>>> @@ -740,14 +720,14 @@ int vringh_getdesc_user(struct vringh *vrh,
>>>>>>    EXPORT_SYMBOL(vringh_getdesc_user);
>>>>>>
>>>>>>    /**
>>>>>> - * vringh_iov_pull_user - copy bytes from vring_iov.
>>>>>> + * vringh_iov_pull_user - copy bytes from vring_kiov.
>>>>>>     * @riov: the riov as passed to vringh_getdesc_user() (updated as we consume)
>>>>>>     * @dst: the place to copy.
>>>>>>     * @len: the maximum length to copy.
>>>>>>     *
>>>>>>     * Returns the bytes copied <= len or a negative errno.
>>>>>>     */
>>>>>> -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
>>>>>> +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len)
>>>>>>    {
>>>>>>           return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
>>>>>>                                  dst, len, xfer_from_user);
>>>>>> @@ -755,14 +735,14 @@ ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len)
>>>>>>    EXPORT_SYMBOL(vringh_iov_pull_user);
>>>>>>
>>>>>>    /**
>>>>>> - * vringh_iov_push_user - copy bytes into vring_iov.
>>>>>> + * vringh_iov_push_user - copy bytes into vring_kiov.
>>>>>>     * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
>>>>>>     * @src: the place to copy from.
>>>>>>     * @len: the maximum length to copy.
>>>>>>     *
>>>>>>     * Returns the bytes copied <= len or a negative errno.
>>>>>>     */
>>>>>> -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
>>>>>> +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
>>>>>>                                const void *src, size_t len)
>>>>>>    {
>>>>>>           return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
>>>>>> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
>>>>>> index 1991a02c6431..733d948e8123 100644
>>>>>> --- a/include/linux/vringh.h
>>>>>> +++ b/include/linux/vringh.h
>>>>>> @@ -79,18 +79,6 @@ struct vringh_range {
>>>>>>           u64 offset;
>>>>>>    };
>>>>>>
>>>>>> -/**
>>>>>> - * struct vringh_iov - iovec mangler.
>>>>>> - *
>>>>>> - * Mangles iovec in place, and restores it.
>>>>>> - * Remaining data is iov + i, of used - i elements.
>>>>>> - */
>>>>>> -struct vringh_iov {
>>>>>> -       struct iovec *iov;
>>>>>> -       size_t consumed; /* Within iov[i] */
>>>>>> -       unsigned i, used, max_num;
>>>>>> -};
>>>>>> -
>>>>>>    /**
>>>>>>     * struct vringh_kiov - kvec mangler.
>>>>>>     *
>>>>>> @@ -113,44 +101,19 @@ int vringh_init_user(struct vringh *vrh, u64 features,
>>>>>>                        vring_avail_t __user *avail,
>>>>>>                        vring_used_t __user *used);
>>>>>>
>>>>>> -static inline void vringh_iov_init(struct vringh_iov *iov,
>>>>>> -                                  struct iovec *iovec, unsigned num)
>>>>>> -{
>>>>>> -       iov->used = iov->i = 0;
>>>>>> -       iov->consumed = 0;
>>>>>> -       iov->max_num = num;
>>>>>> -       iov->iov = iovec;
>>>>>> -}
>>>>>> -
>>>>>> -static inline void vringh_iov_reset(struct vringh_iov *iov)
>>>>>> -{
>>>>>> -       iov->iov[iov->i].iov_len += iov->consumed;
>>>>>> -       iov->iov[iov->i].iov_base -= iov->consumed;
>>>>>> -       iov->consumed = 0;
>>>>>> -       iov->i = 0;
>>>>>> -}
>>>>>> -
>>>>>> -static inline void vringh_iov_cleanup(struct vringh_iov *iov)
>>>>>> -{
>>>>>> -       if (iov->max_num & VRINGH_IOV_ALLOCATED)
>>>>>> -               kfree(iov->iov);
>>>>>> -       iov->max_num = iov->used = iov->i = iov->consumed = 0;
>>>>>> -       iov->iov = NULL;
>>>>>> -}
>>>>>> -
>>>>>>    /* Convert a descriptor into iovecs. */
>>>>>>    int vringh_getdesc_user(struct vringh *vrh,
>>>>>> -                       struct vringh_iov *riov,
>>>>>> -                       struct vringh_iov *wiov,
>>>>>> +                       struct vringh_kiov *riov,
>>>>>> +                       struct vringh_kiov *wiov,
>>>>>>                           bool (*getrange)(struct vringh *vrh,
>>>>>>                                            u64 addr, struct vringh_range *r),
>>>>>>                           u16 *head);
>>>>>>
>>>>>>    /* Copy bytes from readable vsg, consuming it (and incrementing wiov->i). */
>>>>>> -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t len);
>>>>>> +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, size_t len);
>>>>>>
>>>>>>    /* Copy bytes into writable vsg, consuming it (and incrementing wiov->i). */
>>>>>> -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
>>>>>> +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
>>>>>>                                const void *src, size_t len);
>>>>>>
>>>>>>    /* Mark a descriptor as used. */
>>>>>> --
>>>>>> 2.25.1
>>>>>>
>>>> Best,
>>>> Shunsuke
>>>>
