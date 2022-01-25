Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BECB49B951
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586448AbiAYQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585918AbiAYQuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:50:55 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFCAC06173E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:50:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c76-20020a25c04f000000b00613e2c514e2so38464911ybf.21
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1LKOjXAIIlgntfyDu9pWO5nPxeTOqnqZePeokqECWZ8=;
        b=cgm3vY4Th8XQrtpStt6Fqu+Hh5qHMW957MGyWX2qCfrii1XennUHAIe7Sxg7j2Xa7W
         nu1Tg7f1D0TKEO2xo5EIndrqJBcWTDa4cvlieWMh1g8iNbtYqPVoxGLwSepm90wa4CNO
         MxxH00859CJRNyHgVYzjf+obf/lWNhXV0ayq3gi8EJpUCeW9+xOMwEZLxrvQ3truURS4
         Uip5E3B1jcf2Otn4KohiLqme3w7r450DWUPq11cJrhfvx/AQLAFAiemWCXSFVd50QSGZ
         p5h317iwXIBSX0lOFgdV4iypTdc9kak11cV430da7PpJmGxPMO1/JZLyUazpPiSjHfXd
         yVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1LKOjXAIIlgntfyDu9pWO5nPxeTOqnqZePeokqECWZ8=;
        b=zFQ7asVTbCRXm0BNWvvMBmehOy7zYcYK4IbVZR0iQDZ3p+Y6WzIfTBBoctVKzN+yfW
         3wnDnqfCxdxzgWj2spkMsxrd4oBEuwj0H+oUG4cULFACT6c0g2Ufw3ked5+h73UumWAs
         +a6HsXPsKXeE3uMAtpk385XR5pQiU+bQxYlNVUMK0seGVjWq+ns+mnxSdO1ajXaRQiLb
         u1go9I5XbwKb4O07IH1CEaEjZ3Hbe5c0xrLXjumecx4rUtg6DAq9MX3soJe5vVfl19sX
         Z1nLrPWTQ1vb5q4j3sTXYwJkNXN1Pg8m8RZcDCooxmrP9wBQ2ARm5cIbRK3P2g+buKyX
         pHjw==
X-Gm-Message-State: AOAM533ES6gy8NzrUGn8NJ1NG7nD2jTe/rQ75ZACWjm8tMeUdBN+DBFc
        LNb3Q8Pe0etUpvBZY4HcRDmQnp8=
X-Google-Smtp-Source: ABdhPJykEDOOJxvn21e7Y+nCib6sl+vVR0yK1mJF/wcjfAc4VIVm76e6o0csqr+H0c4Nh5Ndqhc2jy4=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f696:cb26:7b81:e8f1])
 (user=sdf job=sendgmr) by 2002:a25:2415:: with SMTP id k21mr29485748ybk.345.1643129453923;
 Tue, 25 Jan 2022 08:50:53 -0800 (PST)
Date:   Tue, 25 Jan 2022 08:50:51 -0800
In-Reply-To: <20220125021008.lo6k6lmpleoli73r@apollo.legion>
Message-Id: <YfAqa0iVZ8IHiUtH@google.com>
Mime-Version: 1.0
References: <20220125003845.2857801-1-sdf@google.com> <20220125021008.lo6k6lmpleoli73r@apollo.legion>
Subject: Re: [PATCH bpf-next] bpf: fix register_btf_kfunc_id_set for !CONFIG_DEBUG_INFO_BTF
From:   sdf@google.com
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/25, Kumar Kartikeya Dwivedi wrote:
> On Tue, Jan 25, 2022 at 06:08:45AM IST, Stanislav Fomichev wrote:
> > Commit dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> > breaks loading of some modules when CONFIG_DEBUG_INFO_BTF is not set.
> > register_btf_kfunc_id_set returns -ENOENT to the callers when
> > there is no module btf. Let's return 0 (success) instead to let
> > those modules work in !CONFIG_DEBUG_INFO_BTF cases.
> >
> > Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Fixes: dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---

> Thanks for the fix.

> >  kernel/bpf/btf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 57f5fd5af2f9..24205c2d4f7e 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -6741,7 +6741,7 @@ int register_btf_kfunc_id_set(enum bpf_prog_type  
> prog_type,
> >
> >  	btf = btf_get_module_btf(kset->owner);
> >  	if (IS_ERR_OR_NULL(btf))
> > -		return btf ? PTR_ERR(btf) : -ENOENT;
> > +		return btf ? PTR_ERR(btf) : 0;

> I think it should still be an error when CONFIG_DEBUG_INFO_BTF is enabled.

> How about doing it differently:

> Make register_btf_kfunc_id_set, btf_kfunc_id_set_contains, and functions  
> only
> called by them all dependent upon CONFIG_DEBUG_INFO_BTF. Then code picks  
> the
> static inline definition from the header and it works fine with 'return  
> 0' and
> 'return false'.

> In case CONFIG_DEBUG_INFO_BTF is enabled, but  
> CONFIG_DEBUG_INFO_BTF_MODULES is
> disabled, we can do the error upgrade but inside btf_get_module_btf.

> I.e. extend the comment it has to say that when it returns NULL, it means  
> there
> is no BTF (hence nothing to do), but it never returns NULL when  
> DEBUF_INFO_BTF*
> is enabled, but upgrades the btf == NULL to a PTR_ERR(-ENOENT), because  
> the btf
> should be there when the options are enabled.

> e.g. If CONFIG_DEBUG_INFO_BTF=y but CONFIG_DEBUG_INFO_BTF_MODULES=n, it  
> can
> return NULL for owner == <some module ptr>, but not for owner == NULL  
> (vmlinux),
> because CONFIG_DEBUG_INFO_BTF is set. If both are disabled, it can return  
> NULL
> for both. If both are set, it will never return NULL.

> Then the caller can just special case NULL depending on their usage.

> And your current diff remains same combined with the above changes.

> WDYT? Does this look correct or did I miss something important?

I initially started with this approach, adding ifdef
CONFIG_DEBUG_INFO_BTF/CONFIG_DEBUG_INFO_BTF_MODULES, but it quickly
became a bit ugly :-( I can retry if you prefer, but how about, instead,
we handle it explicitly this way in the caller?


diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 24205c2d4f7e..e66f60b288d0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6740,8 +6740,19 @@ int register_btf_kfunc_id_set(enum bpf_prog_type  
prog_type,
  	int ret;

  	btf = btf_get_module_btf(kset->owner);
-	if (IS_ERR_OR_NULL(btf))
-		return btf ? PTR_ERR(btf) : 0;
+	if (!btf) {
+		if (!kset->owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
+			pr_err("missing vmlinux BTF\n");
+			return -ENOENT;
+		}
+		if (kset->owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)) {
+			pr_err("missing module BTF\n");
+			return -ENOENT;
+		}
+		return 0;
+	}
+	if (IS_ERR(btf))
+		return PTR_ERR(btf);

  	hook = bpf_prog_type_to_kfunc_hook(prog_type);
  	ret = btf_populate_kfunc_set(btf, hook, kset);

Basically, treat as error the cases we care about:
- non-module && CONFIG_DEBUG_INFO_BTF -> ENOENT
- module && CONFIG_DEBUG_INFO_BTF_MODULES -> ENOENT

Also give the user some hint on what went wrong; insmod gave me "Unknown
symbol in module, or unknown parameter (see dmesg)" for ENOENT (and
dmesg was empty).
