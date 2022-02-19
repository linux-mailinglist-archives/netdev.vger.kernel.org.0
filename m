Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4434BC6F1
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 09:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241649AbiBSIVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 03:21:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiBSIVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 03:21:00 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F4F257DF2;
        Sat, 19 Feb 2022 00:20:41 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id gf13-20020a17090ac7cd00b001bbfb9d760eso712062pjb.2;
        Sat, 19 Feb 2022 00:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m3jQLh0YdNXPEEyUOw44K4g0oe8/hf0ulZgcHgLx9jo=;
        b=UDdeMpHb+ADZ1YRZdlHnorm5vg3KjI6D8ZHlPa0iN+84+m50PCRconsHLP/sV4tAVX
         PQn4Y3jHjbEcUp5x+v+zKxxn/IRuP1EyGj9FZSKh04jV0WgKiN6XoMhiWVEHhJivdQBt
         Iwmbx7hsnvOVtDCCepSGHZjGLxmz1BwvyKx0vConYCjNt5ln9KDAkOi0vcVuj3cO2JLm
         SJ0FZm3BqUmOLM4gBgWrBbQ8j504fIcLmWJD/Dj8R9a/+ST5lkvUoucGXtrfzz/05cfR
         suTlci4yIZH5XX++xp/wHPwh8OtkZxkfCW1+vuIulMUbYkL0p2yQ/ZawndaIW7APQ1AM
         N9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m3jQLh0YdNXPEEyUOw44K4g0oe8/hf0ulZgcHgLx9jo=;
        b=e4yg8phJXVjLi2lwzFkJizsPN32HjiGPxhAB2vE8CyBBAWxWnenna/C/JnIGkRz4jm
         BqDrZ53P2T+feV8uWbWk+LUu32rN/sw2ESwXlSowlul7Dnc4OAQtC9fx9hDsuQ7y8aCZ
         SohTDHpaOS7AfO6tXOBjx3GA1grQGZLA6X3T53qWUimV+XqgG1JKvrMQZkUrgBx/e/Q0
         k9pWtAUUfu7b1oSDML6IedikVDvk3JkGMpSp22ZWWwJUR+/Ra5lucRaSMsdGnQeYnLuh
         /DaHmx87mTp44VG4z/y+bvxKsGJQzY+3olH/OSwjoC8yhCEOB/lwsZAlxvmuo3+fnaOX
         L53w==
X-Gm-Message-State: AOAM532T1QJNuCh+SzE4+pC5U4mpGiQyWOrcJ+YfF41WXMTTP+GAI2D7
        bJjEmjW03vYbBH6C8zxnI9E=
X-Google-Smtp-Source: ABdhPJyYGDpwbJKEdSs7arN9a0InB6ZHc0+YocdZM3abeAQBnq49MFYK+Lh+n6LuEC38NUCDl5vMxA==
X-Received: by 2002:a17:902:ce87:b0:14d:743f:513d with SMTP id f7-20020a170902ce8700b0014d743f513dmr10645864plg.27.1645258841316;
        Sat, 19 Feb 2022 00:20:41 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id rj3sm1504546pjb.49.2022.02.19.00.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 00:20:40 -0800 (PST)
Date:   Sat, 19 Feb 2022 13:50:37 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexander Egorenkov <egorenar@linux.ibm.com>
Cc:     Alexander.Egorenkov@ibm.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com, daniel@iogearbox.net,
        fw@strlen.de, iii@linux.ibm.com, john.fastabend@gmail.com,
        kafai@fb.com, maximmi@nvidia.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        songliubraving@fb.com, toke@redhat.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v8 00/10] Introduce unstable CT lookup helpers
Message-ID: <20220219082037.ow2kbq5brktf4f2u@apollo.legion>
References: <20220218222017.czshdolesamkqv4j@apollo.legion>
 <878ru7qp98.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878ru7qp98.fsf@oc8242746057.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 01:09:15PM IST, Alexander Egorenkov wrote:
>
> Hi Kartikeya,
>
> sorry if i wasn't clear in my first message but just to be sure
> we have no misunderstandings :)
>
> .BTF sections work on s390x with linux-next and nf_conntrack as well if
> the corresponding .BTF section is a part of the kernel module itself.
> I tested it myself by building a linux-next kernel and testing it with a
> KVM guest, i'm able to load nf_conntrack and it works.
>
> In contrast, in the case where the corresponding .BTF section is separate
> from the kernel module nf_conntrack, it fails with the message i
> provided in the first email.
>
> Therefore, my question is, does BTF for kernel modules work if the
> corresponding BTF section is NOT a part of the kernel module but instead
> is stored within the corresponding debuginfo file
> /usr/lib/debug/lib/modules/*/kernel/net/netfilter/nf_conntrack.ko.debug ?
>

Ah, I see, thanks for the clarification.

Currently module BTF is parsed during module load, so unless we can extend the
kernel to pass BTF from a separate debuginfo during modprobe, and associate it
with the loaded module, it won't work. You also won't be able to make the kfunc
call from BPF program, as it would require module BTF fd during prog load.

Still, we can probably remove the error and return 0 when btf == NULL, even if
Kconfig option CONFIG_DEBUG_INFO_BTF is set. I was assuming it would never be
the case that the option is set and btf is not available after successful
parsing, but clearly that is wrong.

If the BPF maintainers agree this is ok, feel free to send a fix to remove the
error.

> Thanks
> Regards
> Alex
>
>
>

--
Kartikeya
