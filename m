Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7511B21A74C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGISwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGISwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:52:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652EFC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:52:03 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so3463634iox.2
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZooCL9PPARHlwydV9l8f4EzYCu6zTnYlexGeRz277XA=;
        b=Ny3JJH3Tu1rhhl5gZVFc8efiJrD4RHR/NwkThysStw92Ar870no0mbFgpt19JXC4fO
         VY8O7PPM30HVMxv9CI/K5ACfBwMrmJ1jactGiz6/2E3zJkfWDRgJGXCsEL2dj3FmJmlk
         i7jvs91bIaQfH3aXw837vnvvXua38NKPow39QUAI2eNlm1oeeUVLa/YKKPY0LREF3aKG
         Y/HECA3p/749vF7fl3pG7BngKZmyt5gwn8BgnVDYJCCgRSFVCnEZ9wuzbPmGBxWCKuft
         KxBOcWjzlwBQLl0FtcG2gHolygdyxH8RlJuF3g1q4aM+BjrgnL0scyz77NrOWICL0XCk
         m8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZooCL9PPARHlwydV9l8f4EzYCu6zTnYlexGeRz277XA=;
        b=WwG1NW1NpQFDTqcAMDwm/fixdRTMlrCq5oUNoRvsiwJdG7B1H/OCUpz+Ibp/Zre8el
         uoi61fy4kzSZHMYXhk/62xDdazkSQjcGOUxjyjEGroJ6iNCxBQqWsfTrB+qR632PElyo
         ngW7VJmEThCkSqOQLkW4Bx3MWprQS+08nDPmT+viY2CwR22lMyLvdNxDaoA0K00r462x
         PVxdUgChZbfSCbkv2/sFgHairmMKwAqS71/KdG1Q+h5MbNmqJ/bX56wJjoAYgxBN2MrK
         iczawYHWlv0jHkX3vgZ0ZPnl3n7938DfpYLEJIlWahnytUft5P889W1mk54L9i0jkHE9
         63Sw==
X-Gm-Message-State: AOAM531GbHfN0JuDTarInqpjlgD5pDMYIuTLUjjXFCDIeDL4SUzTfRCO
        qGyRxsrsy0XypCh5nWogmPP/FilYTVVzVIftGAM=
X-Google-Smtp-Source: ABdhPJyh8s9ECzea4wrdqWe2qh/gNcRc6tfuwQ7D67o0h0aQTNfqfG9vY0BpnnXlWhrHtPvoVTCzaU64/57lo1C8Z1I=
X-Received: by 2002:a02:108a:: with SMTP id 132mr52974266jay.131.1594320722738;
 Thu, 09 Jul 2020 11:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
 <20200708153327.GA193647@roeck-us.net> <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
 <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net> <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
 <38f6a432-fadf-54a6-27d0-39d205fba92e@roeck-us.net>
In-Reply-To: <38f6a432-fadf-54a6-27d0-39d205fba92e@roeck-us.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 11:51:51 -0700
Message-ID: <CAM_iQpVk=54omCG8rrDn7GDg9KxKATT4fufRHbn=BSDKWyTu7w@mail.gmail.com>
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Content-Type: multipart/mixed; boundary="0000000000005669d605aa06b8dc"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000005669d605aa06b8dc
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 9, 2020 at 10:10 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Something seems fishy with the use of skcd->val on big endian systems.
>
> Some debug output:
>
> [   22.643703] sock: ##### sk_alloc(sk=000000001be28100): Calling cgroup_sk_alloc(000000001be28550)
> [   22.643807] cgroup: ##### cgroup_sk_alloc(skcd=000000001be28550): cgroup_sk_alloc_disabled=0, in_interrupt: 0
> [   22.643886] cgroup:  #### cgroup_sk_alloc(skcd=000000001be28550): cset->dfl_cgrp=0000000001224040, skcd->val=0x1224040
> [   22.643957] cgroup: ###### cgroup_bpf_get(cgrp=0000000001224040)
> [   22.646451] sock: ##### sk_prot_free(sk=000000001be28100): Calling cgroup_sk_free(000000001be28550)
> [   22.646607] cgroup:  #### sock_cgroup_ptr(skcd=000000001be28550) -> 0000000000014040 [v=14040, skcd->val=14040]
> [   22.646632] cgroup: ####### cgroup_sk_free(): skcd=000000001be28550, cgrp=0000000000014040
> [   22.646739] cgroup: ####### cgroup_sk_free(): skcd->no_refcnt=0
> [   22.646814] cgroup: ####### cgroup_sk_free(): Calling cgroup_bpf_put(cgrp=0000000000014040)
> [   22.646886] cgroup: ###### cgroup_bpf_put(cgrp=0000000000014040)

Excellent debugging! I thought it was a double put, but it seems to
be an endian issue. I didn't realize the bit endian machine actually
packs bitfields in a big endian way too...

Does the attached patch address this?

Thank you!

--0000000000005669d605aa06b8dc
Content-Type: text/x-patch; charset="US-ASCII"; name="sock_cgroup_ptr.diff"
Content-Disposition: attachment; filename="sock_cgroup_ptr.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kcf5djlm0>
X-Attachment-Id: f_kcf5djlm0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvY2dyb3VwLmggYi9pbmNsdWRlL2xpbnV4L2Nncm91
cC5oCmluZGV4IDYxODgzOGM0ODMxMy4uMTcyOWVkZWQzNGFiIDEwMDY0NAotLS0gYS9pbmNsdWRl
L2xpbnV4L2Nncm91cC5oCisrKyBiL2luY2x1ZGUvbGludXgvY2dyb3VwLmgKQEAgLTgzNiw3ICs4
MzYsMTEgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgY2dyb3VwICpzb2NrX2Nncm91cF9wdHIoc3Ry
dWN0IHNvY2tfY2dyb3VwX2RhdGEgKnNrY2QpCiAJICovCiAJdiA9IFJFQURfT05DRShza2NkLT52
YWwpOwogCi0JaWYgKHYgJiAzKQorI2lmZGVmIF9fTElUVExFX0VORElBTgorCWlmICh2ICYgMHgz
KQorI2Vsc2UKKwlpZiAodiAmIDB4YzApCisjZW5kaWYKIAkJcmV0dXJuICZjZ3JwX2RmbF9yb290
LmNncnA7CiAKIAlyZXR1cm4gKHN0cnVjdCBjZ3JvdXAgKikodW5zaWduZWQgbG9uZyl2ID86ICZj
Z3JwX2RmbF9yb290LmNncnA7Cg==
--0000000000005669d605aa06b8dc--
