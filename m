Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1219E4DA073
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350213AbiCOQwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350232AbiCOQwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:52:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC48C57B01;
        Tue, 15 Mar 2022 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647363051; x=1678899051;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XXGgXF6pP41ECoDy55xbWxdrjJohWNzgAweyr9Pk7XA=;
  b=DhBZAayiRaLFUPU1yXDT9lXszXsSVQrDy632mVs00kgJShHFWS/BKh5Y
   s95EsOWrMzyuAKTLpgr995q8YF/mzZqMm4yhe1ypK3qyZZDPVIvLZH4jc
   Dt8klpecVenpOk4zDBZTACbz+BlvUBL9KlrIS6Xrs96EkzjIbbH6fG+2D
   B09MPSKoyFm5PdgL5P+j2Ftqp9kBZYkH/w6FXJgjRi4DipqwnO/tCSRCC
   jC5oTlSnGNsA0bn9Hw0gnXI2Dc4q9kcl5DlG21V2pj9U8EffwgoLi+b8D
   4y00fbtB3V9ivAgqkxaAO85UYRBiBVAZnW5T5vUhimDkuN34TVfvMDvPx
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256548470"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="256548470"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:49:27 -0700
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690261831"
Received: from lepple-mobl1.ger.corp.intel.com (HELO [10.252.56.30]) ([10.252.56.30])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:49:23 -0700
Message-ID: <e1acd50f-fe67-14a8-846f-66b52e77abc0@linux.intel.com>
Date:   Tue, 15 Mar 2022 18:49:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH bpf-next v2 14/28] selftests/bpf: add tests for
 hid_{get|set}_data helpers
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
 <20220304172852.274126-15-benjamin.tissoires@redhat.com>
From:   Tero Kristo <tero.kristo@linux.intel.com>
In-Reply-To: <20220304172852.274126-15-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

On 04/03/2022 19:28, Benjamin Tissoires wrote:
> Simple test added here, with one use of each helper.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v2:
> - split the patch with libbpf left outside.
> ---
>   tools/testing/selftests/bpf/prog_tests/hid.c | 65 ++++++++++++++++++++
>   tools/testing/selftests/bpf/progs/hid.c      | 45 ++++++++++++++
>   2 files changed, 110 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/hid.c b/tools/testing/selftests/bpf/prog_tests/hid.c
> index 91543b8078ca..74426523dd6f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/hid.c
> +++ b/tools/testing/selftests/bpf/prog_tests/hid.c
> @@ -297,6 +297,68 @@ static int test_hid_raw_event(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
>   	return ret;
>   }
>   
> +/*
> + * Attach hid_set_get_data to the given uhid device,
> + * retrieve and open the matching hidraw node,
> + * inject one event in the uhid device,
> + * check that the program makes correct use of bpf_hid_{set|get}_data.
> + */
> +static int test_hid_set_get_data(struct hid *hid_skel, int uhid_fd, int sysfs_fd)
> +{
> +	int err, hidraw_ino, hidraw_fd = -1;
> +	char hidraw_path[64] = {0};
> +	u8 buf[10] = {0};
> +	int ret = -1;
> +
> +	/* attach hid_set_get_data program */
> +	hid_skel->links.hid_set_get_data =
> +		bpf_program__attach_hid(hid_skel->progs.hid_set_get_data, sysfs_fd);
> +	if (!ASSERT_OK_PTR(hid_skel->links.hid_set_get_data,
> +			   "attach_hid(hid_set_get_data)"))
> +		return PTR_ERR(hid_skel->links.hid_set_get_data);
> +
> +	hidraw_ino = get_hidraw(hid_skel->links.hid_set_get_data);
> +	if (!ASSERT_GE(hidraw_ino, 0, "get_hidraw"))
> +		goto cleanup;
> +
> +	/* open hidraw node to check the other side of the pipe */
> +	sprintf(hidraw_path, "/dev/hidraw%d", hidraw_ino);
> +	hidraw_fd = open(hidraw_path, O_RDWR | O_NONBLOCK);
> +
> +	if (!ASSERT_GE(hidraw_fd, 0, "open_hidraw"))
> +		goto cleanup;
> +
> +	/* inject one event */
> +	buf[0] = 1;
> +	buf[1] = 42;
> +	send_event(uhid_fd, buf, 6);
> +
> +	/* read the data from hidraw */
> +	memset(buf, 0, sizeof(buf));
> +	err = read(hidraw_fd, buf, sizeof(buf));
> +	if (!ASSERT_EQ(err, 6, "read_hidraw"))
> +		goto cleanup;
> +
> +	if (!ASSERT_EQ(buf[2], (42 >> 2), "hid_set_get_data"))
> +		goto cleanup;
> +
> +	if (!ASSERT_EQ(buf[3], 1, "hid_set_get_data"))
> +		goto cleanup;
> +
> +	if (!ASSERT_EQ(buf[4], 42, "hid_set_get_data"))
> +		goto cleanup;
> +
> +	ret = 0;
> +
> +cleanup:
> +	if (hidraw_fd >= 0)
> +		close(hidraw_fd);
> +
> +	hid__detach(hid_skel);
> +
> +	return ret;
> +}
> +
>   /*
>    * Attach hid_rdesc_fixup to the given uhid device,
>    * retrieve and open the matching hidraw node,
> @@ -395,6 +457,9 @@ void serial_test_hid_bpf(void)
>   	err = test_hid_raw_event(hid_skel, uhid_fd, sysfs_fd);
>   	ASSERT_OK(err, "hid");
>   
> +	err = test_hid_set_get_data(hid_skel, uhid_fd, sysfs_fd);
> +	ASSERT_OK(err, "hid_set_get_data");
> +
>   	err = test_rdesc_fixup(hid_skel, uhid_fd, sysfs_fd);
>   	ASSERT_OK(err, "hid_rdesc_fixup");
>   
> diff --git a/tools/testing/selftests/bpf/progs/hid.c b/tools/testing/selftests/bpf/progs/hid.c
> index 2270448d0d3f..de6668471940 100644
> --- a/tools/testing/selftests/bpf/progs/hid.c
> +++ b/tools/testing/selftests/bpf/progs/hid.c
> @@ -66,3 +66,48 @@ int hid_rdesc_fixup(struct hid_bpf_ctx *ctx)
>   
>   	return 0;
>   }
> +
> +SEC("hid/device_event")
> +int hid_set_get_data(struct hid_bpf_ctx *ctx)
> +{
> +	int ret;
> +	__u8 *buf;
> +
> +	buf = bpf_ringbuf_reserve(&ringbuf, 8, 0);

Ordering of patches is probably wrong, it seems the ringbuf is defined 
in patch #21 but used here.

Also, this usage of ringbuf leads into running out of available memory 
in the buffer if used for long time, it is not evident from the test 
case written here but I spent a couple of hours debugging my own BPF 
program that used ringbuf in similar way as what is done here. Basically 
the producer idx is increased with the bpf_ringbuf_reserve / discard, 
but the consumer index is not if you don't have a consumer in place.

I ended up using a global statically allocated buffer for the purpose 
for now.

-Tero


> +	if (!buf)
> +		return -12; /* -ENOMEM */
> +
> +	/* first try read/write with n > 32 */
> +	ret = bpf_hid_get_data(ctx, 0, 64, buf, 8);
> +	if (ret < 0)
> +		goto discard;
> +
> +	/* reinject it */
> +	ret = bpf_hid_set_data(ctx, 24, 64, buf, 8);
> +	if (ret < 0)
> +		goto discard;
> +
> +	/* extract data at bit offset 10 of size 4 (half a byte) */
> +	ret = bpf_hid_get_data(ctx, 10, 4, buf, 8);  /* expected to fail */
> +	if (ret > 0) {
> +		ret = -1;
> +		goto discard;
> +	}
> +
> +	ret = bpf_hid_get_data(ctx, 10, 4, buf, 4);
> +	if (ret < 0)
> +		goto discard;
> +
> +	/* reinject it */
> +	ret = bpf_hid_set_data(ctx, 16, 4, buf, 4);
> +	if (ret < 0)
> +		goto discard;
> +
> +	ret = 0;
> +
> + discard:
> +
> +	bpf_ringbuf_discard(buf, 0);
> +
> +	return ret;
> +}
