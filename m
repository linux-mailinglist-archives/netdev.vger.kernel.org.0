Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1D21A765
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgGIS7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgGIS7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:59:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5BBC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:59:21 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q74so3491232iod.1
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m6GitzY9QcjxbRL3DH9DYzM1+ZX9b1hBzZSxeJfnAgM=;
        b=iYrh2dWVhROLSI827Oqhd/Nkpzz3CQ/Gzl6J37KtNuFDIPc9Wtx4d0fC3ADOM8WG6u
         SY0oci7o59McHxHhS9+P02RUAIHfMRHsgo2BM91rR9/gLK5Xmg273dp2lEUwrKfbOFke
         YlKd+x4KTQKIapWCBywVemMB3kAFycutci9b8GqUyu03p2wUb+wJxlzaSY0Bf2cWW25b
         dAu7Q1etI+Q5RO1U5EY209pVQtpw/NZ54ubeqBI0tqWc/uVk8uLYLC3Etf1lkWjqHYN4
         BN7pCJ5P/D/fJGrrr9RVWe6YbFG1Ya6U2Sr35I7Mc/znciitlU2jztu5tGlSGOfTV3of
         5/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m6GitzY9QcjxbRL3DH9DYzM1+ZX9b1hBzZSxeJfnAgM=;
        b=NJbtcSyQ16fpoI3LZj7g0ThBluaQlkz96zaJLSPwkc23RfKuvfESOvFq3thr7X3Uys
         8J/bY48rYi6CO1/VEjvjHpyA5H0vDCykzMmi/G8BxqDv1x/48ALQtoVlvDr0gBMwX0eG
         488/xY8u9Rr2PW/NR6wVrZwXKN+KwPu1YCqsuNEi2MGJfdO97kzWE6EJIEQ/a5Aa+e/m
         Z1K0GmpIcbk3W/3itvB/xaooYHjA+wymUki9cToz7CVfJZSusGL1lo9GRDF/kTjldYPU
         jfj9UdeOhhyk5S/VH8IOhJE/8xVBMxFfoEpOienRl1VGlhHzyzPjDRe1YP0znqvJSy1T
         Mbzw==
X-Gm-Message-State: AOAM533ox7h++RJtBrj9a5+YcKkSwF0U2eDI+RQsAUZzRjqe0AcG22q9
        SXAGgW/XNSU/5/ggqdg2CXWiTthuN4wdHbwbZhs=
X-Google-Smtp-Source: ABdhPJz3wi9LseMMYz6HStAQOFvDAIMX+4xQxKuxHNhEyQWYy8i31Uyb/X1I8Ni0XyJgMduM5TQzZihg8LRk3i+GqsQ=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr42149305iol.85.1594321160931;
 Thu, 09 Jul 2020 11:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
 <20200708153327.GA193647@roeck-us.net> <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
 <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net> <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
 <38f6a432-fadf-54a6-27d0-39d205fba92e@roeck-us.net> <CAM_iQpVk=54omCG8rrDn7GDg9KxKATT4fufRHbn=BSDKWyTu7w@mail.gmail.com>
In-Reply-To: <CAM_iQpVk=54omCG8rrDn7GDg9KxKATT4fufRHbn=BSDKWyTu7w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 11:59:09 -0700
Message-ID: <CAM_iQpWaWcJYG_JWkHdy__=Y5NYPFaX2T+W-c6MskYoZ8G7rRQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="00000000000074c35305aa06d294"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000074c35305aa06d294
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 9, 2020 at 11:51 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jul 9, 2020 at 10:10 AM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Something seems fishy with the use of skcd->val on big endian systems.
> >
> > Some debug output:
> >
> > [   22.643703] sock: ##### sk_alloc(sk=000000001be28100): Calling cgroup_sk_alloc(000000001be28550)
> > [   22.643807] cgroup: ##### cgroup_sk_alloc(skcd=000000001be28550): cgroup_sk_alloc_disabled=0, in_interrupt: 0
> > [   22.643886] cgroup:  #### cgroup_sk_alloc(skcd=000000001be28550): cset->dfl_cgrp=0000000001224040, skcd->val=0x1224040
> > [   22.643957] cgroup: ###### cgroup_bpf_get(cgrp=0000000001224040)
> > [   22.646451] sock: ##### sk_prot_free(sk=000000001be28100): Calling cgroup_sk_free(000000001be28550)
> > [   22.646607] cgroup:  #### sock_cgroup_ptr(skcd=000000001be28550) -> 0000000000014040 [v=14040, skcd->val=14040]
> > [   22.646632] cgroup: ####### cgroup_sk_free(): skcd=000000001be28550, cgrp=0000000000014040
> > [   22.646739] cgroup: ####### cgroup_sk_free(): skcd->no_refcnt=0
> > [   22.646814] cgroup: ####### cgroup_sk_free(): Calling cgroup_bpf_put(cgrp=0000000000014040)
> > [   22.646886] cgroup: ###### cgroup_bpf_put(cgrp=0000000000014040)
>
> Excellent debugging! I thought it was a double put, but it seems to
> be an endian issue. I didn't realize the bit endian machine actually
> packs bitfields in a big endian way too...
>
> Does the attached patch address this?

Ah, this is too ugly. We just have to always make them the last two bits.

Please test this attached patch instead and ignore the previous one.

Thanks.

--00000000000074c35305aa06d294
Content-Type: text/x-patch; charset="US-ASCII"; name="sock_cgroup_ptr.diff"
Content-Disposition: attachment; filename="sock_cgroup_ptr.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kcf5mxhs0>
X-Attachment-Id: f_kcf5mxhs0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvY2dyb3VwLWRlZnMuaCBiL2luY2x1ZGUvbGludXgv
Y2dyb3VwLWRlZnMuaAppbmRleCA0ZjFjZDBlZGM1N2QuLjBlN2E5N2I1MGQ0OSAxMDA2NDQKLS0t
IGEvaW5jbHVkZS9saW51eC9jZ3JvdXAtZGVmcy5oCisrKyBiL2luY2x1ZGUvbGludXgvY2dyb3Vw
LWRlZnMuaApAQCAtNzkyLDYgKzc5Miw3IEBAIHN0cnVjdCBzb2NrX2Nncm91cF9kYXRhIHsKIAkJ
c3RydWN0IHsKIAkJCXU4CWlzX2RhdGEgOiAxOwogCQkJdTgJbm9fcmVmY250IDogMTsKKwkJCXU4
CXVudXNlZDogNgogCQkJdTgJcGFkZGluZzsKIAkJCXUxNglwcmlvaWR4OwogCQkJdTMyCWNsYXNz
aWQ7CkBAIC04MDEsNiArODAyLDcgQEAgc3RydWN0IHNvY2tfY2dyb3VwX2RhdGEgewogCQkJdTMy
CWNsYXNzaWQ7CiAJCQl1MTYJcHJpb2lkeDsKIAkJCXU4CXBhZGRpbmc7CisJCQl1OAl1bnVzZWQ6
IDYKIAkJCXU4CW5vX3JlZmNudCA6IDE7CiAJCQl1OAlpc19kYXRhIDogMTsKIAkJfSBfX3BhY2tl
ZDsK
--00000000000074c35305aa06d294--
