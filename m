Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE484EAE1B
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237111AbiC2NGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiC2NGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:06:21 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB82340EA;
        Tue, 29 Mar 2022 06:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648559077; x=1680095077;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9kQjeBJCbRw818KO3/vAUpiMndjw9ObV4lqk2smtPXg=;
  b=TvVjiGzN0dqRsyjfS0v1rOg8ENVdcfuWk/raaHhIIqijKs2V0Okhtxnb
   JOt0CakHY+9LaKiPSIOEUdiNWxnkM+v/4cjieVjmIfZuGtsHdQuy1HeMY
   A71d2om/sXIXy2f69csiz8Tx2YhAKKt+nOLqXz/6eok7KtTVYMpHZVyM4
   O7Qs4BqVZ0WDD5lY57TmYyZ5n1PDsXSs3/Od7w2VV7iZncbGbFq2OYeaC
   68jajI9v6c/y3m5QiUdd8XQemcLm8rQFftEvJmJcxqpW+oMvP8EBnZUQg
   firWHDEA6r2w6Jz23sr3tao5E9B8zP1n0Ejx+DB3KXj5IxMzw9DA1hPHq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="241399042"
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="241399042"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 06:04:36 -0700
X-IronPort-AV: E=Sophos;i="5.90,220,1643702400"; 
   d="scan'208";a="694708112"
Received: from gboschi-mobl.ger.corp.intel.com (HELO [10.249.42.217]) ([10.249.42.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2022 06:04:30 -0700
Message-ID: <0a30942b-e6c9-72fb-d012-4b8a6a16ae42@linux.intel.com>
Date:   Tue, 29 Mar 2022 16:04:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH bpf-next v3 00/17] Introduce eBPF support for HID devices
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
From:   Tero Kristo <tero.kristo@linux.intel.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

I tested this iteration of the set, and I faced couple of problems with it.

1) There were some conflicts as I could not figure out the correct 
kernel commit on which to apply the series on. I applied this on top of 
last weeks bpf-next (see below) with some local merge fixes.

commit 2af7e566a8616c278e1d7287ce86cd3900bed943 (bpf-next/master, 
bpf-next/for-next)
Author: Saeed Mahameed <saeedm@nvidia.com>
Date:   Tue Mar 22 10:22:24 2022 -0700

     net/mlx5e: Fix build warning, detected write beyond size of field

2) hid_is_valid_access() causes some trouble and it rejects pretty much 
every BPF program which tries to use ctx->retval. This appears to be 
because prog->expected_attach_type is not populated, I had to apply 
below local tweak to overcome this problem:

diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 30a62e8e0f0a..bf64411e6e9b 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -180,8 +180,7 @@ static bool hid_is_valid_access(int off, int size,
         case offsetof(struct hid_bpf_ctx, retval):
                 if (size != size_default)
                         return false;
-               return (prog->expected_attach_type == BPF_HID_USER_EVENT ||
-                       prog->expected_attach_type == BPF_HID_DRIVER_EVENT);
+               return true;
         default:
                 if (size != size_default)
                         return false;

Proper fix would probably be to actually populate the 
expected_attach_type, but I could not figure out quickly where this 
should be done, or whether it is actually done on some other base commit.

With those, for the whole series:

Tested-by: Tero Kristo <tero.kristo@linux.intel.com>

On 18/03/2022 18:15, Benjamin Tissoires wrote:
> Hi,
>
> This is a followup of my v1 at [0] and v2 at [1].
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
> I think I addressed the comments from the previous version, but there are
> a few things I'd like to note here:
>
> - I did not take the various rev-by and tested-by (thanks a lot for those)
>    because the uapi changed significantly in v3, so I am not very confident
>    in taking those rev-by blindly
>
> - I mentioned in my discussion with Song that I'll put a summary of the uapi
>    in the cover letter, but I ended up adding a (long) file in the Documentation
>    directory. So please maybe start by reading 17/17 to have an overview of
>    what I want to achieve
>
> - I added in the libbpf and bpf the new type BPF_HID_DRIVER_EVENT, even though
>    I don't have a user of it right now in the kernel. I wanted to have them in
>    the docs, but we might not want to have them ready here.
>    In terms of code, it just means that we can attach such programs types
>    but that they will never get triggered.
>
> Anyway, I have been mulling on this for the past 2 weeks, and I think that
> maybe sharing this now is better than me just starring at the code over and
> over.
>
>
> Short summary of changes:
>
> v3:
> ===
>
> - squashed back together most of the libbpf and bpf changes into bigger
>    commits that give a better overview of the whole interactions
>
> - reworked the user API to not expose .data as a directly accessible field
>    from the context, but instead forces everyone to use hid_bpf_get_data (or
>    get/set_bits)
>
> - added BPF_HID_DRIVER_EVENT (see note above)
>
> - addressed the various nitpicks from v2
>
> - added a big Documentation file (and so adding now the doc maintainers to the
>    long list of recipients)
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
>
>
>
> [0] https://lore.kernel.org/linux-input/20220224110828.2168231-1-benjamin.tissoires@redhat.com/T/#t
> [1] https://lore.kernel.org/linux-input/20220304172852.274126-1-benjamin.tissoires@redhat.com/T/#t
>
>
> Benjamin Tissoires (17):
>    bpf: add new is_sys_admin_prog_type() helper
>    bpf: introduce hid program type
>    bpf/verifier: prevent non GPL programs to be loaded against HID
>    libbpf: add HID program type and API
>    HID: hook up with bpf
>    HID: allow to change the report descriptor from an eBPF program
>    selftests/bpf: add tests for the HID-bpf initial implementation
>    selftests/bpf: add report descriptor fixup tests
>    selftests/bpf: Add a test for BPF_F_INSERT_HEAD
>    selftests/bpf: add test for user call of HID bpf programs
>    samples/bpf: add new hid_mouse example
>    bpf/hid: add more HID helpers
>    HID: bpf: implement hid_bpf_get|set_bits
>    HID: add implementation of bpf_hid_raw_request
>    selftests/bpf: add tests for hid_{get|set}_bits helpers
>    selftests/bpf: add tests for bpf_hid_hw_request
>    Documentation: add HID-BPF docs
>
>   Documentation/hid/hid-bpf.rst                | 444 +++++++++++
>   Documentation/hid/index.rst                  |   1 +
>   drivers/hid/Makefile                         |   1 +
>   drivers/hid/hid-bpf.c                        | 328 ++++++++
>   drivers/hid/hid-core.c                       |  34 +-
>   include/linux/bpf-hid.h                      | 127 +++
>   include/linux/bpf_types.h                    |   4 +
>   include/linux/hid.h                          |  36 +-
>   include/uapi/linux/bpf.h                     |  67 ++
>   include/uapi/linux/bpf_hid.h                 |  71 ++
>   include/uapi/linux/hid.h                     |  10 +
>   kernel/bpf/Makefile                          |   3 +
>   kernel/bpf/btf.c                             |   1 +
>   kernel/bpf/hid.c                             | 728 +++++++++++++++++
>   kernel/bpf/syscall.c                         |  27 +-
>   kernel/bpf/verifier.c                        |   7 +
>   samples/bpf/.gitignore                       |   1 +
>   samples/bpf/Makefile                         |   4 +
>   samples/bpf/hid_mouse_kern.c                 | 117 +++
>   samples/bpf/hid_mouse_user.c                 | 129 +++
>   tools/include/uapi/linux/bpf.h               |  67 ++
>   tools/lib/bpf/libbpf.c                       |  23 +-
>   tools/lib/bpf/libbpf.h                       |   2 +
>   tools/lib/bpf/libbpf.map                     |   1 +
>   tools/testing/selftests/bpf/config           |   3 +
>   tools/testing/selftests/bpf/prog_tests/hid.c | 788 +++++++++++++++++++
>   tools/testing/selftests/bpf/progs/hid.c      | 205 +++++
>   27 files changed, 3204 insertions(+), 25 deletions(-)
>   create mode 100644 Documentation/hid/hid-bpf.rst
>   create mode 100644 drivers/hid/hid-bpf.c
>   create mode 100644 include/linux/bpf-hid.h
>   create mode 100644 include/uapi/linux/bpf_hid.h
>   create mode 100644 kernel/bpf/hid.c
>   create mode 100644 samples/bpf/hid_mouse_kern.c
>   create mode 100644 samples/bpf/hid_mouse_user.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
>   create mode 100644 tools/testing/selftests/bpf/progs/hid.c
>
