Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD505840DA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiG1OQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiG1OP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:15:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECEB951A24;
        Thu, 28 Jul 2022 07:15:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89C2C60A0C;
        Thu, 28 Jul 2022 14:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A63C433D6;
        Thu, 28 Jul 2022 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659017758;
        bh=XQKBFaRErqdItQZJM5OYfXlbertewK+rSTKbx2xq4I4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0eEmVmFz13qB6U6VeRedMt5HPRU/h3Xq0SaITmNAc6WwSgmSLvzGTFLHpUIPOGnN
         Udh26BWJvfDBphvUiaXjvTJsZxu/pfNERXXcS8oups4euwN04L2APt/q+hl4VF2CYA
         llalfkOOnc1p4t0hViMmkjmX2kGwAEJ8CSVjkeBo=
Date:   Thu, 28 Jul 2022 16:15:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 13/24] HID: initial BPF implementation
Message-ID: <YuKaG18WXkkQlu8e@kroah.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-14-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153625.1282007-14-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:36:14PM +0200, Benjamin Tissoires wrote:
> diff --git a/drivers/hid/bpf/Kconfig b/drivers/hid/bpf/Kconfig
> new file mode 100644
> index 000000000000..423c02e4c5db
> --- /dev/null
> +++ b/drivers/hid/bpf/Kconfig
> @@ -0,0 +1,18 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +menu "HID-BPF support"
> +	#depends on x86_64

Is this comment still needed?

> +
> +config HID_BPF
> +	bool "HID-BPF support"
> +	default HID_SUPPORT
> +	depends on BPF && BPF_SYSCALL
> +	help
> +	This option allows to support eBPF programs on the HID subsystem.
> +	eBPF programs can fix HID devices in a lighter way than a full
> +	kernel patch and allow a lot more flexibility.
> +
> +	For documentation, see Documentation/hid/hid-bpf.rst
> +
> +	If unsure, say Y.
> +
> +endmenu
