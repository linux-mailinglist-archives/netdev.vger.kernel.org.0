Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D54457286
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbhKSQP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhKSQP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:15:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E675C061574;
        Fri, 19 Nov 2021 08:12:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id b12so18998966wrh.4;
        Fri, 19 Nov 2021 08:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ugr1swvvEJM7P07dTrUMW86aHmgr9RVOKFoLL2kQN7k=;
        b=lFlyvkBNI61mJyUJLQ1+hcFZu152Rj5qZK9mAkDP6bOJesLhBEd3Q4Oq83qIYEd64n
         YITNPwkZi9S7IB6Inh60GB/VEkSv28veKOaIGDMIPbCKTFzqAkbspPLR28oVvo5U5vKX
         ni4AocUEsv6MI6QlC5aDBhUxTPYJ6WUDtSoDVTmcNAcrcrW+S1gPrCGf3ON0VZfJ6JKa
         0KBtAUbroY6eHDRyQJdN136bKjpeWs281Zu15Ruh/5ySpQ1d5ekmM8Ta6jagf5CN7g3S
         kwp92bvu9VLsql4q4anafWvPndH2TGTUpGf0qg8qKM1C7v1a4tqdU9+hNI70/o/Awrbu
         5GRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ugr1swvvEJM7P07dTrUMW86aHmgr9RVOKFoLL2kQN7k=;
        b=BYrdkGvg6wiyPzrnDBhUSphzMAL5umH7l/E2xiClgXhdh4CZbWrfDVAZ3jgh3mLeUP
         7Xgvrlsi9aaCvY+NfzHTLmThyXiY/EVxSPc0DZX7Rilxgxp7Xy0ssCTyOoTxkfoBEhJs
         BaglXTwlLginJdbqCnaa66rAGBebOvW3fq8zOwFYb3HG9hVQDB0F1+dRx7PeMizMjyOm
         UA/YG7F/EAo/QYQwuRX0mKc6AYWCHLDf+7LgBobeYSZGJxcy1yyY8EdoXtwn0P6bo5It
         h6oZNUSkqwE8o/u0463Z2RfQz/izwfJT+sDudCOKxFnXD8QbDE27xD1QjB+WeQxnjD81
         sGww==
X-Gm-Message-State: AOAM531wyMlsO4fH7FjJum5k9sa4d7hLmoxDsc/NBdxtrjjdg01YR3gX
        g7VQBKJkwVhEGp7du7gUENw=
X-Google-Smtp-Source: ABdhPJxXT53cxKGwOTawEJZsAHGDZX4/cS9uLMXoPT1yRB0yOWFLwaopD6E8urQvNF7W4NC52G5yJw==
X-Received: by 2002:a05:6000:156a:: with SMTP id 10mr8724643wrz.87.1637338343047;
        Fri, 19 Nov 2021 08:12:23 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id a1sm191231wri.89.2021.11.19.08.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 08:12:22 -0800 (PST)
Message-ID: <f751fb48-d19c-88af-452e-680994a586b4@gmail.com>
Date:   Fri, 19 Nov 2021 17:12:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:DRM DRIVER FOR QEMU'S CIRRUS DEVICE" 
        <virtualization@lists.linux-foundation.org>
References: <20211119113644.1600-1-alx.manpages@gmail.com>
 <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
 <434296d3-8fe1-f1d2-ee9d-ea25d6c4e43e@gmail.com>
 <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAK8P3a2yVXw9gf8-BNvX_rzectNoiy0MqGKvBcXydiUSrc_fCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On 11/19/21 16:57, Arnd Bergmann wrote:
> 
> From what I can tell, linux/stddef.h is tiny, I don't think it's really
> worth optimizing this part. I have spent some time last year
> trying to untangle some of the more interesting headers, but ended
> up not completing this as there are some really hard problems
> once you start getting to the interesting bits.

In this case it was not about being worth it or not,
but that the fact that adding memberof() would break,
unless I use 0 instead of NULL for the implementation of memberof(),
which I'm against,
or I split stddef.

If I don't do either of those,
I'm creating a circular dependency,
and it doesn't compile.

> 
> The approach I tried was roughly:
> 
> - For each header in the kernel, create a preprocessed version
>   that includes all the indirect includes, from that start a set
>   of lookup tables that record which header is eventually included
>   by which ones, and the size of each preprocessed header in
>   bytes
> 
> - For a given kernel configuration (e.g. defconfig or allmodconfig)
>   that I'm most interested in, look at which files are built, and what
>   the direct includes are in the source files.
> 
> - Sort the headers by the product of the number of direct includes
>   and the preprocessed size: the largest ones are those that are
>   worth looking at first.
> 
> - use graphviz to visualize the directed graph showing the includes
>   between the top 100 headers in that list. You get something like
>   I had in [1], or the version afterwards at [2].
> 
> - split out unneeded indirect includes from the headers in the center
>   of that graph, typically by splitting out struct definitions.
> 
> - repeat.
> 
> The main problem with this approach is that as soon as you start
> actually reducing the unneeded indirect includes, you end up with
> countless .c files that no longer build because they are missing a
> direct include for something that was always included somewhere
> deep underneath, so I needed a second set of scripts to add
> direct includes to every .c file.
> 
> On the plus side, I did see something on the order of a 30%
> compile speed improvement with clang, which is insane
> given that this only removed dead definitions.

Huh!

I'd like to see the kernel some day
not having _any_ hidden dependencies.

For the moment,
since my intent is familiarizing with kernel programming,
and not necessarily improving performance considerably
(at least not in the first rounds of changes),
I prefer starting where it more directly affects
what I initially intended to change in the kernel,
which in this case was adding memberof().

> 
>> But I'll note that linux/fs.h, linux/sched.h, linux/mm.h are
>> interesting headers for further splitting.
>>
>>
>> BTW, I also have a longstanding doubt about
>> how header files are organized in the kernel,
>> and which headers can and cannot be included
>> from which other files.
>>
>> For example I see that files in samples or scripts or tools,
>> that redefine many things such as offsetof() or ARRAY_SIZE(),
>> and I don't know if there's a good reason for that,
>> or if I should simply remove all that stuff and
>> include <linux/offsetof.h> everywhere I see offsetof() being used.
> 
> The main issue here is that user space code should not
> include anything outside of include/uapi/ and arch/*/include/uapi/

Okay.  That's good to know.

So everything can use uapi code,
and uapi code can only use uapi code,
right?

Every duplicate definition of something outside of uapi
should/could be removed.

> 
> offsetof() is defined in include/linux/stddef.h, so this is by
> definition not accessible here. It appears that there is also
> an include/uapi/linux/stddef.h that is really strange because
> it includes linux/compiler_types.h, which in turn is outside
> of uapi/. This should probably be fixed.

I see.
Then,
perhaps it would be better to define offsetof() _only_ inside uapi/,
and use that definition from everywhere else,
and therefore remove the non-uapi version,
right?

Thanks,
Alex


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
