Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7291B50EC27
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiDYWhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiDYWhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 18:37:16 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98916F8952;
        Mon, 25 Apr 2022 15:34:10 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0B439C009; Tue, 26 Apr 2022 00:34:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650926049; bh=FO8lBDbgbFDnZpS6QEZLDuT4Og863KeNmQh+iSxsAos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=4p5bDOi4kml8LAfT3y9DVdbqrU9AHDOLFRViKm0GcHmpdfk88q+p+pBWZI2QNN1r2
         leaw/ggHd42no9n5L6wVZUTRKLMgI9TD8vRfNYrmZ8cicfWcjV+Ds0ZsZnNANOVImK
         ENXAWv8H08j6U/ADSTHA7Bi+k2PtwfiMJVIRi6VCk+ur16DjOVEe7QZZC1/VPNO6EA
         S5IaZ2VJNJQttpagCfiF4dmZdxMmCVcjNxx5GmN4WcuK7Foqjq7RCHJ8+JhVjJlf7V
         Sdk7yDmRrq+FtTtpAOwmMMlylXRCP5vwd5SLYDgvYE93Sv1MKgQ7Z3bTn7kU9VYacc
         7fJYAflviWvmw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 17F84C009;
        Tue, 26 Apr 2022 00:34:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650926048; bh=FO8lBDbgbFDnZpS6QEZLDuT4Og863KeNmQh+iSxsAos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vnlE41CTMa82HWCJ27fSorsXxGCcFFmWdefNZZNWKm42GWrkP6o7JuA0S8JAQhI1L
         Ex6RtE5Qj3N0IeuF1lrcNCmNI4j8ANCzWdm5ZanNbXUpJMd2l6VolZk4E+0tRBMFWH
         6z7WA1o8Dr14Dkt7NLdQ5wp15ClTp0Z/cP03W7PUiT744N2jFc41moSBiRtqt3u11A
         3VCJSN/c+KiWOHdaZ/ertGicVTAvXQxFdRmvJCHnzRid7gW9/i+F7fXhuVlUtwicve
         3noPTz7eZ2VUhMrZ9O3EvAwNrzCG/qTt0IM3rKcVzFaVzcGIxU4ON+7aaENHN0zvtr
         IrjZFtAJaCksw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 81b62d03;
        Mon, 25 Apr 2022 22:34:00 +0000 (UTC)
Date:   Tue, 26 Apr 2022 07:33:45 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 1/4] tools/bpf/runqslower: musl compat: explicitly link
 with libargp if found
Message-ID: <YmchyUOkfKW1Qzxf@codewreck.org>
References: <20220424051022.2619648-1-asmadeus@codewreck.org>
 <20220424051022.2619648-2-asmadeus@codewreck.org>
 <YmT1GxK1HimY2Os9@codewreck.org>
 <80728495-e1fe-21bb-9814-6251648f8359@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80728495-e1fe-21bb-9814-6251648f8359@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote on Mon, Apr 25, 2022 at 11:35:41PM +0200:
> > I've dropped this patch from my alpine MR[1] and built things directly
> > with make bpftool etc as suggested above, so my suggestion to make it
> > more easily buildable that way is probably the way to go?
> > [1] https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/33554
> 
> Thanks for looking into this, Dominique! I slightly massaged patch 3 & 4
> and applied it to bpf-next tree.

Thanks!

> I don't really mind about patch 1 & 2, though out of tools/bpf/ the only
> one you /really/ might want to package is bpftool. The other tools are on
> the legacy side of things and JIT disasm you can also get via bpftool anyway.

I was thinking the other tools still had their uses, but I'll readily
admit I've never had a need for them so wasn't sure if I should package
them together or not.

I can see the use of bpf_dbg, but it's occasional enough that people who
need it can just build it when they need... Let's drop both patches and
I'll remove the other legacy tools from package as well.

My last concern would then just be to build it more easily. I just
noticed I can actually 'make bpf/bpftool' directly from the tools/
parent directory, but there's no equivalent for _install rules.

Would something like this make sense? (I can resend as proper patch if
so)
----
diff --git a/tools/Makefile b/tools/Makefile
index db2f7b8ebed5..743d242aebb3 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -112,6 +112,9 @@ cpupower_install:
 cgroup_install counter_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install vm_install bpf_install objtool_install wmi_install pci_install debugging_install tracing_install:
        $(call descend,$(@:_install=),install)
 
+bpf/%_install: FORCE
+       $(call descend,$(@:_install=),install)
+
 selftests_install:
        $(call descend,testing/$(@:_install=),install)
 
----


> Given this is not covered by BPF CI, are you planning to regularly check
> for musl compatibility before a new kernel is cut?

alpine doesn't update the 'tools' subpackage with every kernel release,
I'm not sure what the exact schedule is but from the looks of it it
tracks LTS releases with updates every few months within the stable
release or to the next one.


I don't really have any resource to run a regular CI, but I guess I can
check from time to time.. If I ever get around to adding a linux-next
test to work's CI I can check bpftool builds at the same time, but who
knows when that'll ever be.

OTOH I had a first look last year (back when I tried to push
ACTIONRETVAL to musl) and there haven't been any new incompatibility, so
I think it's fine to just deal with minor hiccups when alpine upgrades
once in a while.

-- 
Dominique
