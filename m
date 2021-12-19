Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D531479F37
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 06:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhLSFFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 00:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhLSFFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 00:05:30 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFDEC061574;
        Sat, 18 Dec 2021 21:05:29 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m24so5361457pls.10;
        Sat, 18 Dec 2021 21:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKlHcb/+a/+TIswdxAYFbQO/TW7Mb5GfbwGgKVPxekA=;
        b=fNK8NXziUwUMfacYtFD8DxekMIpi/o6br4Kq5IkLXdtqVR+mgIesvYHMAs6H50hNEc
         PNMTBQp3T+MyR1HxCC5ZNRFKY7O7mDQ8Iy74XPmOq56hZ/GHq5eA766+bQ1kPmGZxDTz
         vTnCnB/CWtrupCqovqX1dddnfCbPw9Y2bDabf2W+cxSdgGjiNbXnm2ddrsfkjksPYS2W
         RHKspWP3/ZMMewt8xM2MrbBmwVqWr7zA+U6hj9ar7D0a3VZr73E9Q+uraEHZEWGLYwdb
         xxdoLU5yImYw57S+rjKl63VseTS3iAK2ZYON3w6Tg20Qzi7QMe7MhZQTOdM7EB7CUkJQ
         5x2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKlHcb/+a/+TIswdxAYFbQO/TW7Mb5GfbwGgKVPxekA=;
        b=m/nJxhSMq02Gq6mATsve5WfVHFgh8yR7lrIBOKVyOYmzFdU0HthWgosDCz+dEPCIya
         DktwDeYUvc3CsP1rGP138lRV2rtNxGBit+9EhTIUUarg/NuCpBsCp3tqs8s+O4NoQ3cl
         vmDVLRaSkb9w+xaHD4nbiPcyCT583nvDdupb9nShsY8lH9Iu7EgLh0eCFfx+aO5iaqDQ
         02409aOr+TM6TuaoarjBL9JuT8dMgpZcg9bKz6CEO7lO/d1u9IE9Hr/fXkPUW9uZdO+E
         MVoo/Yeq7gtB6jaWdtoz4rumh0VWTisxKK9I30ZM19XwSk3YqzRMDFC5JuiaWeKgVIgC
         7aTQ==
X-Gm-Message-State: AOAM531NCxdyTra1KLYypxmGPcxaISS6gbapE1/pccZGxYfiJFwiob34
        B9wH+0H+pZ26aV1k/80B0Sxf/LfvXWL6tl33c0U=
X-Google-Smtp-Source: ABdhPJzPBKpoYAI9l/FmEWILykSkdeIX+56IGgjKAsCKC1IU3AI8wndMrl/nr2NU02bf5XledeEmtzkKKIDPuaRKKes=
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr20970684pjz.122.1639890329314;
 Sat, 18 Dec 2021 21:05:29 -0800 (PST)
MIME-Version: 1.0
References: <20211217015031.1278167-1-memxor@gmail.com> <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp> <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com> <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
In-Reply-To: <20211219043349.mmycwjnxcqc7lc2c@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 18 Dec 2021 21:05:18 -0800
Message-ID: <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 8:33 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> It is, but into parent_ref_obj_id, to match during release_reference.
>
> > Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
>
> It's ref_obj_id is still 0.
>
> Thinking about this more, we actually only need 1 extra bit of information in
> reg_state, not even a new member. We can simply copy ref_obj_id and set this
> bit, then we can reject this register during release but consider it during
> release_reference.

It seems to me that this patch created the problem and it's trying
to fix it at the same time.

mark_btf_ld_reg() shouldn't be copying ref_obj_id.
If it keeps it as zero the problem will not happen, no?
