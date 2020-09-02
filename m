Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFB925B4EE
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgIBT7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIBT7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:59:11 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105DDC061244;
        Wed,  2 Sep 2020 12:59:11 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h206so441608ybc.11;
        Wed, 02 Sep 2020 12:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dctRj9FkN1xtqcXVH0tBs6B0vLunYjNi7SUO+aJoeME=;
        b=rHieMzZEpXStpVzoSr4NPIORLpysJWlzHMg63OtuRCiYc9B5/bEPiaJNMT7vjanLW/
         gaaQu/3huXgO6nKXhCI2gHFtNbMHg6Fv/pfqtx+FSfjKs6iEh2J8Ig30y5Yqhyl41lXH
         wLEqCfsuHtD6rbUBfGLpyOupndZ+NN9r2aIXMZn2s5BWgPeX3kdB+ReuPwQV0H5tb8Ke
         qpejqaTLDsb2fmesU+zu8zsF4AFWlTRg840xRAnBpJkRxrF/+Rn0XyKHueI5eOjRldkX
         0pOPNnOoHpgA+EuoExY82eJMA3wlp1fUk/JSMre2PDTj2pXxilUlyk4BrOSIlbh1WNMY
         oDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dctRj9FkN1xtqcXVH0tBs6B0vLunYjNi7SUO+aJoeME=;
        b=sNKTMUYyzhJeSScnqZCLzVutCdU4ZFLeNVBmnTDZhsacYP2rRexFLblp5Tw6LLjoao
         iBe5HQQv/1d3qB3/1OcNhV4wUzSkztM8OSDJl0kkRXXsurRpIiy7V6VW7N+fDDDV8hjU
         D2Zd+cDfi863gCDXi4tElcZB1RV+eVKeH5dmkRLoCm8TuBua4+TeNwQh4hBzdFSa2QoO
         +ICA6AlqbzrdLx4KdSffX60txHRUuv3lPKPM3dQAcHDcI0MSCqpxyY93Ld3kYHw6DfVv
         O5CntrX5bfEgAIlxwvNXlnmT8NjArqzYCnd40XoX/vDvzoDnVoDg1nQRBWUl0xfL38c5
         aTag==
X-Gm-Message-State: AOAM533ekhKiG6/A0pkGTFe2TV6kbDnl46Ztd1SVS4sOdXKh0gksw8mM
        oJdFoqOAdzY9EAtoSBHgirqoIIDZpCMkSmccD9Q=
X-Google-Smtp-Source: ABdhPJz608GNSqX0brCsITwsE/rZUQrRrWH4yp9E2FD8RCk4qEWXr8FNqPta4zxr9yhwBhPVSGsWXxmznT6BaBpaj6c=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr8475930ybg.425.1599076750072;
 Wed, 02 Sep 2020 12:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200901015003.2871861-1-andriin@fb.com> <20200901015003.2871861-15-andriin@fb.com>
 <20200902054643.bvbtteoii2p7xyix@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200902054643.bvbtteoii2p7xyix@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 12:58:59 -0700
Message-ID: <CAEf4BzZrbF3G4GXDqgbNK3W_t2M=GdcBV1c9JgAeTsBm5OWDBg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 14/14] selftests/bpf: convert cls_redirect
 selftest to use __noinline
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 10:46 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 31, 2020 at 06:50:03PM -0700, Andrii Nakryiko wrote:
> > -static bool ipv4_is_fragment(const struct iphdr *ip)
> > +static __noinline bool ipv4_is_fragment(const struct iphdr *ip)
> >  {
> >       uint16_t frag_off = ip->frag_off & bpf_htons(IP_OFFSET_MASK);
> >       return (ip->frag_off & bpf_htons(IP_MF)) != 0 || frag_off > 0;
> >  }
> >
> > -static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
> > +static __always_inline struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
>
> similar concern. Could you keep old and add new one with macro magic?

Ok.
