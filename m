Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B834572CC
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbhKSQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhKSQZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:25:55 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CA0C061574;
        Fri, 19 Nov 2021 08:22:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c4so19034481wrd.9;
        Fri, 19 Nov 2021 08:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gJ7nvh3PYL8XuI32u9B1gA3gTx9kf/bMqpXsk3AEZsU=;
        b=fpsj7+4SpFXqpTSemI06B9IcXVdlbuued/IQBN4FCqBdSC/xtpTgB2iz9UIQnOPSv5
         7dinU35yvOUDiH/9vJWKbZ9GctdBbeB/cRDVHk0phW4F/NxhOCWoSFMTVcX26VVw3HMt
         GPKNYBxNtyTgnGx50kBrFXzcpurXEIcb4r3vdAScw53cOY82S+nnM1F4LxEs39YLMQ/S
         uDHYEpfJs9WPfjtx2YvKeV+ilwmoATVlGw8z6GW1nGOzQsTXfXgbQ/sMgtuNKtzjMgO+
         m/GWqEfFdALvOcc/k4vNSzQQ8s1MyiSdciXJWtO0mjZ1O20qNFBqF7s2UCtRG1bgp0aS
         YbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gJ7nvh3PYL8XuI32u9B1gA3gTx9kf/bMqpXsk3AEZsU=;
        b=3UAVTh0LUHtRX1wmiMOCq7iQ9nP43yrlAw+tKssdwrTo7IkqKs/trY2X7vcTrdTsly
         RqoPlwUHj+/G1q6+u4eESRMLivU3clJv6h1yUXlVuXG8JNNf53guyERJhvKEpeT24qCs
         yh4aHG8HVtwA1mq6f3QPdSUc2kJhJm2JMT7CgpSDpvumLpx6VqTqzbkmFY3S7B1DOF4C
         WaeRxdjGvI0fU7GnzMmjJNUCyJpDhzzKUT92FALy/RKTzZVd05kLisuyqmtg0A1/CZTY
         cC0es4+rLdPwbqz+O0ucopKuzhefQqh0LW3rvLjEJ1knsZ4+6em0mnvZrfW/2VwADFZE
         WoDw==
X-Gm-Message-State: AOAM533Qd2EXmjPYUk14KuMgoFH7xykgZr1I2wFfhhrGcHTb1CaqmaHf
        0HGTX6xQ0GpN3N/wYHLG8OA=
X-Google-Smtp-Source: ABdhPJz+RkhKg2oPM+DFfdJrmKTihG8D5yySz9/H4aR55REMYZ6fa+PNcb8l7yv++672VBes+PtaDw==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr9039788wri.297.1637338971943;
        Fri, 19 Nov 2021 08:22:51 -0800 (PST)
Received: from [192.168.0.160] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id n2sm12993701wmi.36.2021.11.19.08.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 08:22:51 -0800 (PST)
Message-ID: <2d790206-124b-f850-895f-a57a74c55f79@gmail.com>
Date:   Fri, 19 Nov 2021 17:22:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
 <YZfMXlqvG52ls2TE@smile.fi.intel.com>
 <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <CAK8P3a06CMzWVj2C3P5v0u8ZVPumXJKrq=TdjSq1NugmeT7-RQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/21 17:18, Arnd Bergmann wrote:
> On Fri, Nov 19, 2021 at 5:10 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Fri, Nov 19, 2021 at 04:57:46PM +0100, Arnd Bergmann wrote:
> 
>>> The main problem with this approach is that as soon as you start
>>> actually reducing the unneeded indirect includes, you end up with
>>> countless .c files that no longer build because they are missing a
>>> direct include for something that was always included somewhere
>>> deep underneath, so I needed a second set of scripts to add
>>> direct includes to every .c file.
>>
>> Can't it be done with cocci support?
> 
> There are many ways of doing it, but they all tend to suffer from the
> problem of identifying which headers are actually needed based on
> the contents of a file, and also figuring out where to put the extra
> #include if there are complex #ifdefs.
> 
> For reference, see below for the naive pattern matching I tried.
> This is obviously incomplete and partially wrong.

FYI, if you may not know the tool,
theres include-what-you-use(1) (a.k.a. iwyu(1))[1],
although it is still not mature,
and I'm helping improve it a bit.

If I understood better the kernel Makefiles,
I'd try it.

You can try it yourselves.
I still can't use it for my own code,
since it has a lot of false positives.

Cheers,
Alex

[1]: <https://include-what-you-use.org/>


-- 
Alejandro Colomar
Linux man-pages comaintainer; https://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
