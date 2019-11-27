Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1996A10A751
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 01:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK0AEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 19:04:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37995 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0AEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 19:04:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id t3so9400649pgl.5
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 16:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2u1niDBuA2mwnKES4Z6zoRj9jCaAUwZCD4ei61VlG7w=;
        b=Q5lK5df6RQSWPuSj35u3yqgjI+awEGam2sKU9+YoBWDoQ+zYTUsXdJwxxg9hbWBbn9
         EUJB7nPadGtf6wh6edZrAAvZczE7bsFyeLSW6p4bvgTkbad/S+GK5tdfarxTAEg8d4AZ
         UO+vrZNF12JWxMNa3VGOALQu1OEgapgNhrfW6QX6PXlP9PnXGS56bmHC7TOJ0QSDxuGI
         aH9UmTQjGa/xIW732TpsZbel/2Pj3QTZkCHl383z6Jfc4XQ5sWugjn2sPHB31dkOOE75
         OGVdFANy2/emRaEU19bUZfTmtLZNxwqKHDZO/CxP+kSop9EoCW/5JN7yBCOVEMnNDsWV
         xhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2u1niDBuA2mwnKES4Z6zoRj9jCaAUwZCD4ei61VlG7w=;
        b=AK5PR1u4OSRQRDPKDmd8iCuX0eS3S2OOJojVMwZyi6/b0kvOtOWSrmJY7YfH1aKXz5
         pbQHCAghbuG8x7YseafYFZ3OGU/zCT1Dpj/fNZHlYOvNIIl0H47LS12NH8BD8kueBOcG
         57acWYZ7SZ3yvnQwOdY6sfIekza0P0BaeEOZQufiFm0V0+/8aSGs/1GZO5v8SAqzJAVE
         TXK/VcWasuUhxe/3d5JwPByHbFweMDW0YhjqLFMJ0S61kf8sl6P+v38v8NooRjAvXdSZ
         uBXuZiiH2BYvlmR4S6dQx0/NTINvFzqSZpFQk0XAzEnq82WpmBab3m+HbbE+wJv+vYAw
         Ol8Q==
X-Gm-Message-State: APjAAAUfQTnR6I9m7MHkXWtqT/FzezGjy4rl9EXSIXLELyBMLyTc0AmS
        KpeBM5IZxwUH44dX2/mGO3dLDQ==
X-Google-Smtp-Source: APXvYqyQx7zDFZ0XAqW+phA9jFvADaB8ZaYQZLxZaOWh+6abeFUQvq6FS/jeEApI3KWt0Qm1uGDLHQ==
X-Received: by 2002:a62:7982:: with SMTP id u124mr43329219pfc.98.1574813061626;
        Tue, 26 Nov 2019 16:04:21 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id o188sm13934034pfb.124.2019.11.26.16.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 16:04:20 -0800 (PST)
Date:   Tue, 26 Nov 2019 16:04:20 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v2] bpf: support pre-2.25-binutils objcopy for
 vmlinux BTF
Message-ID: <20191127000420.GG3145429@mini-arch.hsd1.ca.comcast.net>
References: <20191126232818.226454-1-sdf@google.com>
 <5dddb7059b13e_13b82abee0d625bc2d@john-XPS-13-9370.notmuch>
 <20191126234523.GF3145429@mini-arch.hsd1.ca.comcast.net>
 <02a27e2f-d269-0b04-a4ef-ebb347e3c918@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02a27e2f-d269-0b04-a4ef-ebb347e3c918@fb.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/26, Andrii Nakryiko wrote:
> On 11/26/19 3:45 PM, Stanislav Fomichev wrote:
> > On 11/26, John Fastabend wrote:
> >> Stanislav Fomichev wrote:
> >>> If vmlinux BTF generation fails, but CONFIG_DEBUG_INFO_BTF is set,
> >>> .BTF section of vmlinux is empty and kernel will prohibit
> >>> BPF loading and return "in-kernel BTF is malformed".
> >>>
> >>> --dump-section argument to binutils' objcopy was added in version 2.25.
> >>> When using pre-2.25 binutils, BTF generation silently fails. Convert
> >>> to --only-section which is present on pre-2.25 binutils.
> >>>
> >>> Documentation/process/changes.rst states that binutils 2.21+
> >>> is supported, not sure those standards apply to BPF subsystem.
> >>>
> >>> v2:
> >>> * exit and print an error if gen_btf fails (John Fastabend)
> >>>
> >>> Cc: Andrii Nakryiko <andriin@fb.com>
> >>> Cc: John Fastabend <john.fastabend@gmail.com>
> >>> Fixes: 341dfcf8d78ea ("btf: expose BTF info through sysfs")
> >>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>> ---
> >>>   scripts/link-vmlinux.sh | 7 ++++++-
> >>>   1 file changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> >>> index 06495379fcd8..2998ddb323e3 100755
> >>> --- a/scripts/link-vmlinux.sh
> >>> +++ b/scripts/link-vmlinux.sh
> >>> @@ -127,7 +127,8 @@ gen_btf()
> >>>   		cut -d, -f1 | cut -d' ' -f2)
> >>>   	bin_format=$(LANG=C ${OBJDUMP} -f ${1} | grep 'file format' | \
> >>>   		awk '{print $4}')
> >>> -	${OBJCOPY} --dump-section .BTF=.btf.vmlinux.bin ${1} 2>/dev/null
> >>> +	${OBJCOPY} --set-section-flags .BTF=alloc -O binary \
> >>> +		--only-section=.BTF ${1} .btf.vmlinux.bin 2>/dev/null
> >>>   	${OBJCOPY} -I binary -O ${bin_format} -B ${bin_arch} \
> >>>   		--rename-section .data=.BTF .btf.vmlinux.bin ${2}
> >>>   }
> >>> @@ -253,6 +254,10 @@ btf_vmlinux_bin_o=""
> >>>   if [ -n "${CONFIG_DEBUG_INFO_BTF}" ]; then
> >>>   	if gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
> >>>   		btf_vmlinux_bin_o=.btf.vmlinux.bin.o
> >>> +	else
> >>> +		echo >&2 "Failed to generate BTF for vmlinux"
> >>> +		echo >&2 "Try to disable CONFIG_DEBUG_INFO_BTF"
> >>
> >> I think we should encourage upgrading binutils first? Maybe
> >>
> >> "binutils 2.25+ required for BTF please upgrade or disable CONFIG_DEBUG_INFO_BTF"
> >>
> >> otherwise I guess its going to be a bit mystical why it works in
> >> cases and not others to folks unfamiliar with the details.
> > With the conversion from --dump-section to --only-section that I
> > did in this patch, binutils 2.25+ is no longer a requirement.
> > 2.21 (minimal version from Documentation/process/changes.rst) should work
> > just fine.
> 
> Yeah, instead it's better to mention that pahole v1.13+ is required.
We already have most of the messages about missing pahole or wrong version:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/scripts/link-vmlinux.sh#n111
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/scripts/link-vmlinux.sh#n117

They are 'info' though, but it seems logical to drop -s from make arguments
if someone wants to debug further.
