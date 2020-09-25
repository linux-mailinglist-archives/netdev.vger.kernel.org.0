Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458C5277D2E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgIYAu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgIYAuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:50:55 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF34CC0613CE;
        Thu, 24 Sep 2020 17:50:55 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k133so1048504pgc.7;
        Thu, 24 Sep 2020 17:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZEj7jJ2RajYtDSmZOrLZRT9SFF9pAXigrpnF3pG53vM=;
        b=dDZ+FP4+FHl4gUgw2wF/Uuem6fqtpWvDOGt52UFUkBzGXHV+7Jth4pWeCB+5gryZAM
         ho/vb6eJx797Q1muCG0bIyeZbQZt72VVccaeY6H9VP8YNWHY/k75gZ+zTo+GFx2Xn4XF
         7171eRlBErtdeQDB10Mm6+oWyYhej7YIdSzPPlOaKAinmObCDKdb3l/Y9uDZKTyYUdZ1
         NFYuIBNNdMB4pVHpx/DVdlf6MuWuhzDv0Dyn5Q2L5+MINFib8sOYfaL4avO/Q9gqkTpg
         DQlszmtid4zzx4T18TF0cLdVEnQNNLc5AuLsT31HlQdKwurfwVw91TBvIGtu4g59URGl
         SITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZEj7jJ2RajYtDSmZOrLZRT9SFF9pAXigrpnF3pG53vM=;
        b=PVDtnYdim6ozjWfDgaEToCb8pW8Yd2gzY3LSD4vKVXHFYvs+fCjbmt6lGbzAMMUo5F
         O920QxbRLgq0JZgCWU7oir3+MxCRAo+U9HllLEYIPNvF0AvQAnt7fiRnA/PiV9SOOjlu
         sOtzbY3i6Rr+ZzMdK/WKIW/NlN9yg1+awzP6C+PUtetGeSOvfg/jqg7vS7qt2YzRpGq1
         YiNHWe3ftkfBRRIeH2NucjqkSnDPi6KI2Vwn7lRH1NJh8jRemBWXC2ohkYsVTwLElAlI
         02QA6peuXRW4sjWO5howTqoubJ0A6ryVIsRWXNuVEuaoi0+QEiUdqLqFFsFDIy/p6u5U
         30Og==
X-Gm-Message-State: AOAM530SjOA/VGrLIHSUgnBCp/5E+0vW+aKCoUnfK8JRG9pNUArJxxSG
        ziE+SupkHMVE5rbsO0O0EYQ=
X-Google-Smtp-Source: ABdhPJwtrAG2FWI+khpVtPUig0amsxnQGdDTAGByGD0X+rSPF0F08DoZ59Jg1jOIX7UA+NhmyRRWyA==
X-Received: by 2002:aa7:8ec7:0:b029:13e:d13d:a137 with SMTP id b7-20020aa78ec70000b029013ed13da137mr1676726pfr.31.1600995055255;
        Thu, 24 Sep 2020 17:50:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:49ed])
        by smtp.gmail.com with ESMTPSA id c185sm610932pfb.123.2020.09.24.17.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 17:50:54 -0700 (PDT)
Date:   Thu, 24 Sep 2020 17:50:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org
Subject: Re: [PATCH v6 bpf-next 4/6] selftests/bpf: add bpf_snprintf_btf
 helper tests
Message-ID: <20200925005051.nqf6ru46psex7oh4@ast-mbp.dhcp.thefacebook.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-5-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600883188-4831-5-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 06:46:26PM +0100, Alan Maguire wrote:
> +static int __strncmp(const void *m1, const void *m2, size_t len)
> +{
> +	const unsigned char *s1 = m1;
> +	const unsigned char *s2 = m2;
> +	int i, delta = 0;
> +
> +#pragma clang loop unroll(full)

Shouldn't be needed?
The verifier supports bounded loops.

> +	for (i = 0; i < len; i++) {
> +		delta = s1[i] - s2[i];
> +		if (delta || s1[i] == 0 || s2[i] == 0)
> +			break;
> +	}
> +	return delta;
> +}
> +
> +/* Use __builtin_btf_type_id to test snprintf_btf by type id instead of name */
> +#if __has_builtin(__builtin_btf_type_id)
> +#define TEST_BTF_BY_ID(_str, _typestr, _ptr, _hflags)			\
> +	do {								\
> +		int _expected_ret = ret;				\
> +		_ptr.type = 0;						\
> +		_ptr.type_id = __builtin_btf_type_id(_typestr, 0);	\

The test is passing for me, but I don't understand why :)
__builtin_btf_type_id(, 0); means btf_id of the bpf program.
While bpf_snprintf_btf() is treating it as btf_id of vmlinux_btf.
So it really should have been __builtin_btf_type_id(,1);

The following diff works:
diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
index b4f96f1f6830..bffa786e3b03 100644
--- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -45,7 +45,7 @@ static int __strncmp(const void *m1, const void *m2, size_t len)
        do {                                                            \
                int _expected_ret = ret;                                \
                _ptr.type = 0;                                          \
-               _ptr.type_id = __builtin_btf_type_id(_typestr, 0);      \
+               _ptr.type_id = __builtin_btf_type_id(_typestr, 1);      \
                ret = bpf_snprintf_btf(_str, STRSIZE, &_ptr,            \
                                       sizeof(_ptr), _hflags);          \
                if (ret != _expected_ret) {                             \
@@ -88,7 +88,7 @@ static int __strncmp(const void *m1, const void *m2, size_t len)
                        ret = -EBADMSG;                                 \
                        break;                                          \
                }                                                       \
-               TEST_BTF_BY_ID(_str, #_type, _ptr, _hflags);            \
+               TEST_BTF_BY_ID(_str, _ptr, _ptr, _hflags);              \

But still makes me suspicious of the test. I haven't debugged further.
