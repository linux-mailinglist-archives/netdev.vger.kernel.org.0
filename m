Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3F7DA4BD
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407759AbfJQE2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:28:14 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46740 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfJQE2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 00:28:14 -0400
Received: by mail-lj1-f193.google.com with SMTP id d1so947149ljl.13;
        Wed, 16 Oct 2019 21:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9itVDfvQg1eQTz/ujhX3fv/gLuxI/FNToeADri4X1p0=;
        b=WpGx7HBMetecA3cVsAa0Wh1jIfZ0A02UQSCmCaEz88+57PSEkfj44hyQCVk3wE5/zZ
         wdKSJZQggS6TsiQEkzD62cQgQWGTO3rOJBsaKFpjGT5947uY2RaZ21siEqtftvErcVna
         pEgnMbfIZT03GL5KISp1uSaYMH+z7+ungwVgwJ13IfsnziDbglZ8JKTpeAMRMs8SZxpY
         UnlUcP1XtXW5XLY0FPVnFMHcDgxOVHtYAE3RaQoFqP/rJVbr0oRyUI5Vbqjj2RRDKX9n
         QnYCF1yRncVbv2Md7C+brq6M/0Y73bYpOFyNn9PFtT9R47cQBi1n6kPKg0rp/qbjVvf1
         NLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9itVDfvQg1eQTz/ujhX3fv/gLuxI/FNToeADri4X1p0=;
        b=fEF9l2RSlX+8/4gV2errZVqFhB0R61Kg+drs9mgREuaFEpWf+iBfDnhB2Gojb30I2k
         TYYD7omVtj+e8mO1qJttKYIbnVen/RqdgnJEykwzF2pJ4a/jBqVSyYyIXmooUQREjexD
         9s4ypTfLVNc05aXOrl757ycWakIriNfcdm8rAvbsFii/NuTBvOrBukprtHapAPFdMnnw
         dHWi43iiRD/AKzuLRPp1ct9jf4A46wHfhILpyMEY5w5YrP7hEcSmthUXi+dkrRP0sc6P
         AUZQo996jsC26pomLp2bLo5Pd/GUEb8NdtAspgnHvL4CvR46aenVOvFe3COM/2GPsG6k
         y4TA==
X-Gm-Message-State: APjAAAVMwQ8VyUAvA/Gw+WvMRYtlLzs2OUps7LBvmqMY3QWhvfuwhCoa
        VjrJk2ATDTN1pPTdChMigsY7qHb/WO4iagXGAcQ=
X-Google-Smtp-Source: APXvYqz8Ngeflz8UKqzBD+voi1UDp+cPzChWJ58O0xKkOrDH7qFHIWn6+8iFNrFujFp1KPIiAeN8Pof+lIuQGlJehPY=
X-Received: by 2002:a2e:9bc1:: with SMTP id w1mr953751ljj.136.1571286490527;
 Wed, 16 Oct 2019 21:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191016060051.2024182-1-andriin@fb.com>
In-Reply-To: <20191016060051.2024182-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 16 Oct 2019 21:27:58 -0700
Message-ID: <CAADnVQJKESit7tDy0atn0-Q7Se=kLhkCWGAmRPJSVPdNAS8BVg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/7] Fix, clean up, and revamp selftests/bpf Makefile
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 4:49 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set extensively revamps selftests/bpf's Makefile to generalize test
> runner concept and apply it uniformly to test_maps and test_progs test
> runners, along with test_progs' few build "flavors", exercising various ways
> to build BPF programs.
>
> As we do that, we fix dependencies between various phases of test runners, and
> simplify some one-off rules and dependencies currently present in Makefile.
> test_progs' flavors are now built into root $(OUTPUT) directory and can be run
> without any extra steps right from there. E.g., test_progs-alu32 is built and
> is supposed to be run from $(OUTPUT). It will cd into alu32/ subdirectory to
> load correct set of BPF object files (which are different from the ones built
> for test_progs).
>
> Outline:
> - patch #1 teaches test_progs about flavor sub-directories;
> - patch #2 fixes one of CO-RE tests to not depend strictly on process name;
> - patch #3 changes test_maps's usage of map_tests/tests.h to be the same as
>   test_progs' one;
> - patch #4 adds convenient short `make test_progs`-like targets to build only
>   individual tests, if necessary;
> - patch #5 is a main patch in the series; it uses a bunch of make magic
>   (mainly $(call) and $(eval)) to define test runner "skeleton" and apply it
>   to 4 different test runners, lots more details in corresponding commit
>   description;
> - patch #6 does a bit of post-clean up for test_queue_map and test_stack_map
>   BPF programs;
> - patch #7 cleans up test_libbpf.sh/test_libbpf_open superseded by test_progs.
>
> v3->v4:
> - remove accidentally checked in binaries;

something really odd here.
Before the patchset ./test_progs -n 27 passes
after the patch it simply hangs.
Though strace -f ./test_progs -n 27 passes.
Any idea?
