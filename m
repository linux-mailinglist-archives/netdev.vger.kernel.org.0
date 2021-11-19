Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A997456F6D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 14:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhKSNTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 08:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhKSNTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 08:19:11 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4463C061574;
        Fri, 19 Nov 2021 05:16:09 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c4so18093635wrd.9;
        Fri, 19 Nov 2021 05:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/pL+Oyiy0IE/VSN3VcOMQBkBUj2zcO4M5BEO9TZep1A=;
        b=fYTnnvM8ksusjPkK4Sby+CQscGGjmFeWWkZjInk/876Zd4Z/LprwRSUWcHweTrZLPP
         vmB1nYM0TvqZDPEA3v2PisH3FUjA01QMt5bKVp2vWUTwq8PTA3BIzg0tCJ/MMpSi6TBv
         jSxjdZYdFg91rc0E1I/Bh/9JzZFtrInvmTgnA4y1Ds1GJmp/BArK87zZo1SPIljhT0eb
         4Knk0PNuEc9rw/snjcQOOHEzi4saW4nLM72WbAWa2XDKfExpNgFLnd0H9W6/X3o45Y8e
         MykoGPmPXOpQ6fIcPHs5e2kkN95orSNsKwz9WEwU60w0rGkrFsbASEWV2ZIRaKUDswIj
         caeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/pL+Oyiy0IE/VSN3VcOMQBkBUj2zcO4M5BEO9TZep1A=;
        b=0/acUsipQyYTVzPHej9+h2X9dHSVzBRQD876L9mBN9Hh5+sMTiS6h5JVNVzLItg3sT
         LTS/U/Lj4yOVyPKmwRUAzGr59+R0xb5n142MMrID0e7qx6TYJidnq6sCtuZu5skiUNXq
         lgQw7cx2PNdiQizrn3g0nSRM6njghS/3gsXO33fvpTSZH4fJPUBO5iGpX6S8czmnyk7W
         j5bGzq+lYtio/wbkqz/+/aILQJLCFpVyTS/F/3VblwYw5YW5namzknuWTEfD9KYmoQHo
         gO5q2X/dX+EEjd0Bci30fwu33L5tiyRGHwQbBDMgPYCiHjIV9bBVW36mfi4bXdFMJYrN
         9hPA==
X-Gm-Message-State: AOAM531TeNB1IRPCUHLrfKxSrhay/U0zLqxbGEwHKT7Vu7VjHhvFOnKI
        7vAgStqlToEHIXyvex4E700=
X-Google-Smtp-Source: ABdhPJwMk3Sh4eyDIhTFLQU+Br82TWmaoMdoXdpg3wMxizhZnQz7Gu4prOucaSRKiPWIfb1fa4zi1g==
X-Received: by 2002:a05:6000:1681:: with SMTP id y1mr7257994wrd.52.1637327767994;
        Fri, 19 Nov 2021 05:16:07 -0800 (PST)
Received: from [10.168.10.170] ([170.253.36.171])
        by smtp.gmail.com with ESMTPSA id q26sm3003188wrc.39.2021.11.19.05.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 05:16:07 -0800 (PST)
Message-ID: <a9522c0e-0762-c7cd-edb1-0376c435c4d9@gmail.com>
Date:   Fri, 19 Nov 2021 14:16:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
Content-Language: en-US
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
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
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211119113644.1600-1-alx.manpages@gmail.com>
 <87mtm0jos3.fsf@intel.com>
From:   "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <87mtm0jos3.fsf@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jani,

On 11/19/21 13:47, Jani Nikula wrote:
> On Fri, 19 Nov 2021, Alejandro Colomar <alx.manpages@gmail.com> wrote:
>> In the first and second commits
>> I changed a lot of stuff in many parts,
>> and that's why I CCd so many people (also in this cover letter).
>> However, to avoid spamming,
>> and since it would be a nightmare to
>> find all the relevant people affected in so many different areas,
>> I only CCd in 01, 02 and in the cover letter.
>> If anyone is interested in reading the full patch set,
>> I sent it to the LKML.
> 
> I think with the patch split you have this would be a nightmare to get
> merged. Please consider refactoring the headers first, and once those
> are reviewed and merged, you can proceed with using them elsewhere. For
> example, we'd want the drm/i915 changes in patches separate from changes
> to other drivers or the core headers.

So,
would it be preferable something like this?:

Patch set 1:
- Add <linux/memberof.h> with memberof()
- Split offsetof() to <linux/offsetof.h>
- Split offsetofend() to <linux/offsetofend.h>
- Split typeof_member() to <linux/typeof_member.h>
- Split sizeof_field() to <linux/sizeof_field.h>
- Split NULL to <linux/NULL.h>
- Split ARRAY_SIZE() to <linux/array_size.h>
- Implement offsetof() in terms of memberof()
- Implement typeof_member() in terms of memberof()
- Implement sizeof_field() in terms of memberof()
- Implement container_of_safe() in terms of container_of()
- Remove unnecessary cast from container_of[_safe]()
- Cosmetic changes

Patch set 2:
- And in a different patch set, fix all other files
   that make use of these macros.


Patch 1 without editing any other files except for the basic ones,
and adding includes where the definition had been previously,
to not break stuff.

And then,
start patching individual subsystems and
send tiny patch sets to each of them?


For the first part,
I agree it is better.
I'll change it to do that.
I'll send an v2 with less changes and more organized.


For the second part,
I'll see what I can do after the first one has been reviewed.
I'll do tiny patches with a few changes to one or few files,
so that I can reorganize them easily with a rebase -i afterwards,
and then decide.


Thanks,
Alex

> 
>>
>>
>> Alejandro Colomar (17):
>>    linux/container_of.h: Add memberof(T, m)
>>    Use memberof(T, m) instead of explicit NULL dereference
>>    Replace some uses of memberof() by its wrappers
>>    linux/memberof.h: Move memberof() to separate header
>>    linux/typeof_member.h: Move typeof_member() to a separate header
>>    Simplify sizeof(typeof_member()) to sizeof_field()
>>    linux/NULL.h: Move NULL to a separate header
>>    linux/offsetof.h: Move offsetof(T, m) to a separate header
>>    linux/offsetof.h: Implement offsetof() in terms of memberof()
>>    linux/container_of.h: Implement container_of_safe() in terms of
>>      container_of()
>>    linux/container_of.h: Cosmetic
>>    linux/container_of.h: Remove unnecessary cast to (void *)
>>    linux/sizeof_field.h: Move sizeof_field(T, m) to a separate header
>>    include/linux/: Include a smaller header if just for NULL
>>    linux/offsetofend.h: Move offsetofend(T, m) to a separate header
>>    linux/array_size.h: Move ARRAY_SIZE(arr) to a separate header
>>    include/: Include <linux/array_size.h> for ARRAY_SIZE()
>>
>>   arch/x86/include/asm/bootparam_utils.h        |  3 +-
>>   arch/x86/kernel/signal_compat.c               |  5 ++--
>>   drivers/gpu/drm/i915/i915_sw_fence.c          |  1 +
>>   drivers/gpu/drm/i915/i915_utils.h             |  5 ++--
>>   drivers/gpu/drm/i915/intel_runtime_pm.h       |  3 +-
>>   drivers/net/ethernet/emulex/benet/be.h        | 10 +++----
>>   drivers/net/ethernet/i825xx/ether1.c          |  7 +++--
>>   drivers/platform/x86/wmi.c                    |  3 +-
>>   drivers/scsi/be2iscsi/be.h                    | 12 ++++----
>>   drivers/scsi/be2iscsi/be_cmds.h               |  5 +++-
>>   fs/btrfs/ctree.h                              |  5 ++--
>>   fs/proc/inode.c                               |  1 +
>>   include/acpi/actypes.h                        |  4 ++-
>>   include/crypto/internal/blake2b.h             |  1 +
>>   include/crypto/internal/blake2s.h             |  1 +
>>   include/crypto/internal/chacha.h              |  1 +
>>   include/drm/drm_mipi_dbi.h                    |  1 +
>>   include/drm/drm_mode_object.h                 |  1 +
>>   include/kunit/test.h                          |  1 +
>>   include/linux/NULL.h                          | 10 +++++++
>>   include/linux/arm_ffa.h                       |  1 +
>>   include/linux/array_size.h                    | 15 ++++++++++
>>   include/linux/blk_types.h                     |  1 +
>>   include/linux/can/core.h                      |  1 +
>>   include/linux/clk-provider.h                  |  1 +
>>   include/linux/container_of.h                  | 28 ++++++++++-------
>>   include/linux/counter.h                       |  1 +
>>   include/linux/crash_core.h                    |  1 +
>>   include/linux/efi.h                           |  1 +
>>   include/linux/extable.h                       |  2 +-
>>   include/linux/f2fs_fs.h                       |  1 +
>>   include/linux/filter.h                        |  3 ++
>>   include/linux/fs.h                            |  1 +
>>   include/linux/genl_magic_func.h               |  1 +
>>   include/linux/hashtable.h                     |  1 +
>>   include/linux/ieee80211.h                     |  1 +
>>   include/linux/kbuild.h                        |  3 ++
>>   include/linux/kernel.h                        |  7 +----
>>   include/linux/kfifo.h                         |  1 +
>>   include/linux/kvm_host.h                      |  3 ++
>>   include/linux/libata.h                        |  1 +
>>   include/linux/llist.h                         |  1 +
>>   include/linux/memberof.h                      | 11 +++++++
>>   include/linux/mlx5/device.h                   |  1 +
>>   include/linux/mlx5/driver.h                   |  1 +
>>   include/linux/mm_types.h                      |  1 +
>>   include/linux/moduleparam.h                   |  3 ++
>>   include/linux/mtd/rawnand.h                   |  1 +
>>   include/linux/netdevice.h                     |  1 +
>>   include/linux/netfilter.h                     |  1 +
>>   include/linux/nvme-fc.h                       |  2 ++
>>   include/linux/offsetof.h                      | 17 +++++++++++
>>   include/linux/offsetofend.h                   | 19 ++++++++++++
>>   include/linux/pagemap.h                       |  1 +
>>   include/linux/phy.h                           |  1 +
>>   include/linux/phy_led_triggers.h              |  1 +
>>   include/linux/pinctrl/machine.h               |  1 +
>>   include/linux/property.h                      |  1 +
>>   include/linux/rcupdate.h                      |  1 +
>>   include/linux/rcupdate_wait.h                 |  1 +
>>   include/linux/regmap.h                        |  1 +
>>   include/linux/sched/task.h                    |  1 +
>>   include/linux/sizeof_field.h                  | 14 +++++++++
>>   include/linux/skb_array.h                     |  1 +
>>   include/linux/skbuff.h                        |  1 +
>>   include/linux/skmsg.h                         |  3 ++
>>   include/linux/slab.h                          |  2 ++
>>   include/linux/spinlock_types.h                |  1 +
>>   include/linux/stddef.h                        | 30 +++----------------
>>   include/linux/string.h                        |  5 +++-
>>   include/linux/surface_aggregator/controller.h |  1 +
>>   include/linux/surface_aggregator/serial_hub.h |  1 +
>>   include/linux/swap.h                          |  1 +
>>   include/linux/ti-emif-sram.h                  |  1 +
>>   include/linux/typeof_member.h                 | 11 +++++++
>>   include/linux/ucs2_string.h                   |  2 +-
>>   include/linux/vdpa.h                          |  1 +
>>   include/linux/virtio_config.h                 | 17 ++++++-----
>>   include/linux/wireless.h                      |  2 ++
>>   include/net/bond_3ad.h                        |  1 +
>>   include/net/dsa.h                             |  1 +
>>   include/net/ip_vs.h                           |  1 +
>>   include/net/netfilter/nf_conntrack_tuple.h    |  1 +
>>   include/net/netfilter/nf_tables.h             |  1 +
>>   include/net/netlink.h                         |  1 +
>>   include/rdma/uverbs_ioctl.h                   |  1 +
>>   include/rdma/uverbs_named_ioctl.h             |  1 +
>>   include/scsi/scsi_host.h                      |  1 +
>>   include/sound/soc-dapm.h                      |  1 +
>>   include/sound/soc.h                           |  1 +
>>   include/trace/events/wbt.h                    |  1 +
>>   include/uapi/linux/netfilter/xt_sctp.h        |  1 +
>>   include/xen/hvm.h                             |  1 +
>>   kernel/kallsyms.c                             |  3 +-
>>   94 files changed, 255 insertions(+), 79 deletions(-)
>>   create mode 100644 include/linux/NULL.h
>>   create mode 100644 include/linux/array_size.h
>>   create mode 100644 include/linux/memberof.h
>>   create mode 100644 include/linux/offsetof.h
>>   create mode 100644 include/linux/offsetofend.h
>>   create mode 100644 include/linux/sizeof_field.h
>>   create mode 100644 include/linux/typeof_member.h
> 

-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
