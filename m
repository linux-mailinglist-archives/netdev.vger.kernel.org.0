Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDD558881D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbiHCHmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHCHma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:42:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC51FCE3;
        Wed,  3 Aug 2022 00:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659512548; x=1691048548;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bPBTAmFItJli/FgJ5QFwiA9bwcWk7H1U0xpUswriSnI=;
  b=A/wfslUEPTKWtCbYUpgHlF/ZPIfpuAdnozf2duO8J200RajbBJSPcLMq
   Rc4XDjJon1RKlkmWu+YgBfJsRso+luKsjruvXMpicpOlML0fiXqyGqcen
   f6HD9dHM74h/uHm4Eip6wcHB3C0zVZCou220GcVxBRfi9VPPGLMWFd9nq
   FnPvU11HKPMv0SGO1Ki7jG4ewB590eaOFIz5SQPja3cUYgMII865dNRGq
   9uOpNNaTcqfwUKN2NNH0jeN/IkjrS41tgbB0KyvQuE67GEPn3KArROGYB
   IoN6K3n0DS/2cQydgZQknKkUk2xtF3scAQh1cmVorCpkBXAIHPnasJ5wc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10427"; a="353614222"
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="353614222"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 00:42:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,213,1654585200"; 
   d="scan'208";a="599557794"
Received: from mpaulits-mobl.ger.corp.intel.com (HELO [10.252.59.205]) ([10.252.59.205])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2022 00:42:22 -0700
Message-ID: <9d298ab7-4ad4-7849-6a64-6e1bdd5f18c3@linux.intel.com>
Date:   Wed, 3 Aug 2022 10:41:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v7 00/24] Introduce eBPF support for HID devices
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
From:   Tero Kristo <tero.kristo@linux.intel.com>
In-Reply-To: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Tried this out with my USI support eBPF code, and it works fine with the 
single patch I had to apply on top of i2c-hid (not related to the 
hid-bpf support itself.)

For the whole series:

Tested-by: Tero Kristo <tero.kristo@linux.intel.com>

-Tero

On 21/07/2022 18:36, Benjamin Tissoires wrote:
> Hi,
>
> here comes the v7 of the HID-BPF series.
>
> Again, for a full explanation of HID-BPF, please refer to the last patch
> in this series (24/24).
>
> This version sees some minor improvements compared to v6, only
> focusing on the reviews I got.
>
> I also wanted to mention that I have started working on the userspace
> side to "see" how the BPF programs would look when automatically loaded.
> See the udev-hid-bpf project[0] for the code.
>
> The idea is to define the HID-BPF userspace programs so we can reuse
> the same semantic in the kernel.
> I am quite happy with the results: this looks pretty similar to a kernel
> module in term of design. The .bpf.c file is a standalone compilation
> unit, and instead of having a table of ids, the filename is used (based
> on the modalias). This allows to have a "probe" like function that we
> can run to decide if the program needs to be attached or not.
>
> All in all, the end result is that we can write the bpf program, compile
> it locally, and send the result to the user. The user needs to drop the
> .bpf.o in a local folder, and udev-hid-bpf will pick it up the next time
> the device is plugged in. No other operations is required.
>
> Next step will be to drop the same source file in the kernel source
> tree, and have some magic to automatically load the compiled program
> when the device is loaded.
>
> Cheers,
> Benjamin
>
> [0] https://gitlab.freedesktop.org/bentiss/udev-hid-bpf (warning: probably
> not the best rust code ever)
>
> Benjamin Tissoires (24):
>    selftests/bpf: fix config for CLS_BPF
>    bpf/verifier: allow kfunc to read user provided context
>    bpf/verifier: do not clear meta in check_mem_size
>    selftests/bpf: add test for accessing ctx from syscall program type
>    bpf/verifier: allow kfunc to return an allocated mem
>    selftests/bpf: Add tests for kfunc returning a memory pointer
>    bpf: prepare for more bpf syscall to be used from kernel and user
>      space.
>    libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
>    HID: core: store the unique system identifier in hid_device
>    HID: export hid_report_type to uapi
>    HID: convert defines of HID class requests into a proper enum
>    HID: Kconfig: split HID support and hid-core compilation
>    HID: initial BPF implementation
>    selftests/bpf: add tests for the HID-bpf initial implementation
>    HID: bpf: allocate data memory for device_event BPF programs
>    selftests/bpf/hid: add test to change the report size
>    HID: bpf: introduce hid_hw_request()
>    selftests/bpf: add tests for bpf_hid_hw_request
>    HID: bpf: allow to change the report descriptor
>    selftests/bpf: add report descriptor fixup tests
>    selftests/bpf: Add a test for BPF_F_INSERT_HEAD
>    samples/bpf: add new hid_mouse example
>    HID: bpf: add Surface Dial example
>    Documentation: add HID-BPF docs
>
>   Documentation/hid/hid-bpf.rst                 | 512 +++++++++
>   Documentation/hid/index.rst                   |   1 +
>   drivers/Makefile                              |   2 +-
>   drivers/hid/Kconfig                           |  20 +-
>   drivers/hid/Makefile                          |   2 +
>   drivers/hid/bpf/Kconfig                       |  18 +
>   drivers/hid/bpf/Makefile                      |  11 +
>   drivers/hid/bpf/entrypoints/Makefile          |  93 ++
>   drivers/hid/bpf/entrypoints/README            |   4 +
>   drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
>   .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++
>   drivers/hid/bpf/hid_bpf_dispatch.c            | 553 ++++++++++
>   drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
>   drivers/hid/bpf/hid_bpf_jmp_table.c           | 577 ++++++++++
>   drivers/hid/hid-core.c                        |  49 +-
>   include/linux/bpf.h                           |   9 +-
>   include/linux/btf.h                           |  10 +
>   include/linux/hid.h                           |  38 +-
>   include/linux/hid_bpf.h                       | 148 +++
>   include/uapi/linux/hid.h                      |  26 +-
>   include/uapi/linux/hid_bpf.h                  |  25 +
>   kernel/bpf/btf.c                              |  91 +-
>   kernel/bpf/syscall.c                          |  10 +-
>   kernel/bpf/verifier.c                         |  65 +-
>   net/bpf/test_run.c                            |  23 +
>   samples/bpf/.gitignore                        |   2 +
>   samples/bpf/Makefile                          |  27 +
>   samples/bpf/hid_mouse.bpf.c                   | 134 +++
>   samples/bpf/hid_mouse.c                       | 147 +++
>   samples/bpf/hid_surface_dial.bpf.c            | 161 +++
>   samples/bpf/hid_surface_dial.c                | 212 ++++
>   tools/include/uapi/linux/hid.h                |  62 ++
>   tools/include/uapi/linux/hid_bpf.h            |  25 +
>   tools/lib/bpf/skel_internal.h                 |  23 +
>   tools/testing/selftests/bpf/Makefile          |   5 +-
>   tools/testing/selftests/bpf/config            |   5 +-
>   tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
>   .../selftests/bpf/prog_tests/kfunc_call.c     |  76 ++
>   tools/testing/selftests/bpf/progs/hid.c       | 206 ++++
>   .../selftests/bpf/progs/kfunc_call_test.c     | 125 +++
>   40 files changed, 5184 insertions(+), 79 deletions(-)
>   create mode 100644 Documentation/hid/hid-bpf.rst
>   create mode 100644 drivers/hid/bpf/Kconfig
>   create mode 100644 drivers/hid/bpf/Makefile
>   create mode 100644 drivers/hid/bpf/entrypoints/Makefile
>   create mode 100644 drivers/hid/bpf/entrypoints/README
>   create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
>   create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
>   create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
>   create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
>   create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
>   create mode 100644 include/linux/hid_bpf.h
>   create mode 100644 include/uapi/linux/hid_bpf.h
>   create mode 100644 samples/bpf/hid_mouse.bpf.c
>   create mode 100644 samples/bpf/hid_mouse.c
>   create mode 100644 samples/bpf/hid_surface_dial.bpf.c
>   create mode 100644 samples/bpf/hid_surface_dial.c
>   create mode 100644 tools/include/uapi/linux/hid.h
>   create mode 100644 tools/include/uapi/linux/hid_bpf.h
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
>   create mode 100644 tools/testing/selftests/bpf/progs/hid.c
>
