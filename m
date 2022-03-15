Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1498D4DA0DC
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350460AbiCORIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350485AbiCORHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:07:54 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C5580C0;
        Tue, 15 Mar 2022 10:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647364002; x=1678900002;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0XG+gX0DCjUrifLHVo4uvhwaHh2d9IKH+kZXF/KXoOE=;
  b=O0Wh72+SxpnY1kunIVWqpRmr4AoABFX7eBbg6y+nSJgqUhsBCnEzaG8k
   CkiKrh4J0d+op01OFDYi7NSYbt2AZoblb8vOYGgjfeXa5uOmCCdTTDPQf
   sCrvxbs/tamlcpN8vfo0SiPc3BcYFBDzIbtR06QihMJtb6PGuSQXR3PQT
   CwvRoLg8D/gOfFUHOFsVO7+eQWVQX0qiiuk/ELn7Bxu7eeIiaF/DTKICF
   X9Xl+kDS9gY29uor9gAaWFpl+cVlmxl4VzX1uPhLBcPt+XUQqYPEAY1vi
   OgGFKcBoRk1mU1i4prehYC61GUjh0bsg4CUs9dCcHvL8DNiyTDYm86NkR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="317085653"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="317085653"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 10:04:26 -0700
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690269219"
Received: from lepple-mobl1.ger.corp.intel.com (HELO [10.252.56.30]) ([10.252.56.30])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 10:04:21 -0700
Message-ID: <84435254-b072-661f-f108-81a00178d7bc@linux.intel.com>
Date:   Tue, 15 Mar 2022 19:04:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH bpf-next v2 00/28] Introduce eBPF support for HID devices
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>
Cc:     linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
From:   Tero Kristo <tero.kristo@linux.intel.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

On 04/03/2022 19:28, Benjamin Tissoires wrote:
> Hi,
>
> This is a followup of my v1 at [0].
>
> The short summary of the previous cover letter and discussions is that
> HID could benefit from BPF for the following use cases:
>
> - simple fixup of report descriptor:
>    benefits are faster development time and testing, with the produced
>    bpf program being shipped in the kernel directly (the shipping part
>    is *not* addressed here).
>
> - Universal Stylus Interface:
>    allows a user-space program to define its own kernel interface
>
> - Surface Dial:
>    somehow similar to the previous one except that userspace can decide
>    to change the shape of the exported device
>
> - firewall:
>    still partly missing there, there is not yet interception of hidraw
>    calls, but it's coming in a followup series, I promise
>
> - tracing:
>    well, tracing.
>
>
> I tried to address as many comments as I could and here is the short log
> of changes:
>
> v2:
> ===
>
> - split the series by subsystem (bpf, HID, libbpf, selftests and
>    samples)
>
> - Added an extra patch at the beginning to not require CAP_NET_ADMIN for
>    BPF_PROG_TYPE_LIRC_MODE2 (please shout if this is wrong)
>
> - made the bpf context attached to HID program of dynamic size:
>    * the first 1 kB will be able to be addressed directly
>    * the rest can be retrieved through bpf_hid_{set|get}_data
>      (note that I am definitivey not happy with that API, because there
>      is part of it in bits and other in bytes. ouch)
>
> - added an extra patch to prevent non GPL HID bpf programs to be loaded
>    of type BPF_PROG_TYPE_HID
>    * same here, not really happy but I don't know where to put that check
>      in verifier.c
>
> - added a new flag BPF_F_INSERT_HEAD for BPF_LINK_CREATE syscall when in
>    used with HID program types.
>    * this flag is used for tracing, to be able to load a program before
>      any others that might already have been inserted and that might
>      change the data stream.
>
> Cheers,
> Benjamin

I posted a couple of comments to the series, but other than that for the 
whole series you can use:

Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>

Tested-by: Tero Kristo <tero.kristo@linux.intel.com>

I did test this with my USI-BPF program + userspace code, they work with 
few minor updates compared to previous version.

-Tero

>
>
>
> [0] https://lore.kernel.org/linux-input/20220224110828.2168231-1-benjamin.tissoires@redhat.com/T/#t
>
>
> Benjamin Tissoires (28):
>    bpf: add new is_sys_admin_prog_type() helper
>    bpf: introduce hid program type
>    HID: hook up with bpf
>    libbpf: add HID program type and API
>    selftests/bpf: add tests for the HID-bpf initial implementation
>    samples/bpf: add new hid_mouse example
>    bpf/hid: add a new attach type to change the report descriptor
>    HID: allow to change the report descriptor from an eBPF program
>    libbpf: add new attach type BPF_HID_RDESC_FIXUP
>    selftests/bpf: add report descriptor fixup tests
>    samples/bpf: add a report descriptor fixup
>    bpf/hid: add hid_{get|set}_data helpers
>    HID: bpf: implement hid_bpf_get|set_data
>    selftests/bpf: add tests for hid_{get|set}_data helpers
>    bpf/hid: add new BPF type to trigger commands from userspace
>    libbpf: add new attach type BPF_HID_USER_EVENT
>    selftests/bpf: add test for user call of HID bpf programs
>    selftests/bpf: hid: rely on uhid event to know if a test device is
>      ready
>    bpf/hid: add bpf_hid_raw_request helper function
>    HID: add implementation of bpf_hid_raw_request
>    selftests/bpf: add tests for bpf_hid_hw_request
>    bpf/verifier: prevent non GPL programs to be loaded against HID
>    HID: bpf: compute only the required buffer size for the device
>    HID: bpf: only call hid_bpf_raw_event() if a ctx is available
>    bpf/hid: Add a flag to add the program at the beginning of the list
>    libbpf: add handling for BPF_F_INSERT_HEAD in HID programs
>    selftests/bpf: Add a test for BPF_F_INSERT_HEAD
>    samples/bpf: fix bpf_program__attach_hid() api change
>
>   drivers/hid/Makefile                         |   1 +
>   drivers/hid/hid-bpf.c                        | 361 +++++++++
>   drivers/hid/hid-core.c                       |  34 +-
>   include/linux/bpf-hid.h                      | 129 +++
>   include/linux/bpf_types.h                    |   4 +
>   include/linux/hid.h                          |  25 +
>   include/uapi/linux/bpf.h                     |  59 ++
>   include/uapi/linux/bpf_hid.h                 |  50 ++
>   kernel/bpf/Makefile                          |   3 +
>   kernel/bpf/hid.c                             | 652 +++++++++++++++
>   kernel/bpf/syscall.c                         |  26 +-
>   kernel/bpf/verifier.c                        |   7 +
>   samples/bpf/.gitignore                       |   1 +
>   samples/bpf/Makefile                         |   4 +
>   samples/bpf/hid_mouse_kern.c                 |  91 +++
>   samples/bpf/hid_mouse_user.c                 | 129 +++
>   tools/include/uapi/linux/bpf.h               |  59 ++
>   tools/lib/bpf/libbpf.c                       |  22 +-
>   tools/lib/bpf/libbpf.h                       |   2 +
>   tools/lib/bpf/libbpf.map                     |   1 +
>   tools/testing/selftests/bpf/prog_tests/hid.c | 788 +++++++++++++++++++
>   tools/testing/selftests/bpf/progs/hid.c      | 216 +++++
>   22 files changed, 2649 insertions(+), 15 deletions(-)
>   create mode 100644 drivers/hid/hid-bpf.c
>   create mode 100644 include/linux/bpf-hid.h
>   create mode 100644 include/uapi/linux/bpf_hid.h
>   create mode 100644 kernel/bpf/hid.c
>   create mode 100644 samples/bpf/hid_mouse_kern.c
>   create mode 100644 samples/bpf/hid_mouse_user.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
>   create mode 100644 tools/testing/selftests/bpf/progs/hid.c
>
