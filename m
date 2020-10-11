Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE2628A52F
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 05:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgJKDzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 23:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbgJKDzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 23:55:54 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAFFC0613D0
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 20:55:52 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 144so10399852pfb.4
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/9/JEfyeVvXPulJoe6wfMF+6Q/pba2GZK8yoyU5M2PQ=;
        b=XF5piBpF65qi3mgVVI3xtGW3B8rthQem0Ar1PmIYUFny4yiqbYzpPJekDkscyO3V5J
         QtVMqchX1Nn3gfT9oguOijVF9BXdO1V8za8tsOG/Ww086N+4eEPgdnVX8Tg7I5simNdq
         z/ddjv1QmUb7ET64uMa3CxU8AM5kjJDZ2QsCHxITVT3VCErQg9h+5v1S2zO45NOL6Cah
         Id24usY2+/QAyElxigEBdT+/16GLkODHAOs8jQKrZs4fbzoqlXLjH7JqQ0/YtrwLj8F/
         yfUetiFCua+4iKwo+QHEzGqwrbIIT0FwI/vzUFt1Qe92bea+nhJUrbQUuoNYtpgf17Bd
         CgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/9/JEfyeVvXPulJoe6wfMF+6Q/pba2GZK8yoyU5M2PQ=;
        b=bD+JRJS23JvLUab/XXbT2Y9MI4O5dd4WlMPMR5zdjuPNhWJsQAVN8J6M6OAzqVV80H
         NBgvwkXFFOvAUC8QJrNoBBO/7fekuLrALyxLDSijerXyaSrsAh1uPPTDDBakDhjPWxnv
         Slz98jvOH7W0wPaVtrUtenc2nbpKQFEw3DHf/rowcBt8Nq2jhzvh5eEMDK1DjbMia5xd
         JiXpqjNxX6WjZ5XghuCF6T5a6rGUiiY+k3YT+7L/Q7zHW8YXif+TzwdwtbCSuAOUpj8x
         Q8liZRwRB9sX3WGiwZ5kbVZe8h1wSPXCPHZd3pTsylkYqIVVEEPjf+JmSOz9BZubVLkr
         RN1Q==
X-Gm-Message-State: AOAM533H2YALLCd4oXNCxvVUmnLOFv+dAWJIJDDNBGQILi2LhDpGB7Lq
        1YwNa378iMgdmTEfOqadRcOz2waqAstTIxyj/X4=
X-Google-Smtp-Source: ABdhPJy6dS6jIH1eeMgDfSpzgHEghJG5Nk+s5nPTcekRVBhswah+vuaWnR2bHZRscjbHO6qNaWCcelt3i0Puu8F1pS0=
X-Received: by 2002:a62:6383:0:b029:151:3ddb:a126 with SMTP id
 x125-20020a6263830000b02901513ddba126mr18606668pfb.4.1602388551898; Sat, 10
 Oct 2020 20:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20201008012154.11149-1-xiyou.wangcong@gmail.com>
 <CA+FuTSeMYFh3tY9cJN6h02E+r3BST=w74+pD=zraLXsmJTLZXA@mail.gmail.com>
 <CAM_iQpWCR84sD6dZBforgt4cg-Jya91D6EynDo2y2sC7vi-vMg@mail.gmail.com>
 <CA+FuTSdKa1Q36ONbsGOMqXDCUiiDNsA6rkqyrzB+eXJj=MyRKA@mail.gmail.com>
 <CAJht_ENnmYRh-RomBodJE0HoFzaLQhD+DKEu2WWST+B43JxWcQ@mail.gmail.com>
 <CA+FuTSdWYDs5u+3VzpTA1-Xs1OiVzv8QiKGTH4GUYrvXFfGT_A@mail.gmail.com>
 <CAJht_ENMFY_HwaJDjvxZbQgcDv7btC+bU6gzdjyddY-JS=a6Lg@mail.gmail.com>
 <CA+FuTScizeZC-ndVvXj4VyArth2gnxoh3kTSoe5awGoiFXtkBA@mail.gmail.com>
 <CAJht_ENmrPbhfPaD5kkiDVWQsvA_LRndPiCMrS9zdje6sVPk=g@mail.gmail.com>
 <CA+FuTSfhDgn-Qej4HOY-kYWSy8pUsnafMk=ozwtYGfS4W2DNuA@mail.gmail.com>
 <CAJht_ENxoAyUOoiHSbFXEZ6Jf2xqfOmYfQ6Sh-hfmTUk-kTrfQ@mail.gmail.com>
 <CAJht_EOMQRKWfwhfqwXB3RYA1h463q43ycNjJmaGZm6RS65QGA@mail.gmail.com>
 <CAM_iQpWRftQkOfgfMACNR_5YZxvzLJH1aMtmZNj7nJH_Wu-NRw@mail.gmail.com>
 <CAJht_ENnYyXbOxtPHD9GHB92U4uonKO_oRZ82g2OR2DaFZ7bBQ@mail.gmail.com>
 <CAJht_EPVyc0uAZc914E3tdgqEc7tDabpAxnBsGrRRFecc+NMwg@mail.gmail.com>
 <CAM_iQpU1hU0Wg9sdTwFAG17Gk4-85+=xvZdQeb3oswhBKtAsPA@mail.gmail.com>
 <CAM_iQpVhrFZ4DWg9btEpS9+s0QX-b=eSkJJWzPr_KUV-TEkrQw@mail.gmail.com>
 <CAJht_EO99yYQeUPUFR-qvWwrpZQfXToUu6x7LBS+0yhqiYg_XQ@mail.gmail.com>
 <CAM_iQpX0zjZUDE_iuf4WWXiodwb2UpqyjjQPYrfD0CMXnMSymQ@mail.gmail.com> <CAJht_EPQ8OXUeRxn7Q2AU9NsEuFB14Vs8Q0xBs-j9ka36RUVWQ@mail.gmail.com>
In-Reply-To: <CAJht_EPQ8OXUeRxn7Q2AU9NsEuFB14Vs8Q0xBs-j9ka36RUVWQ@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 10 Oct 2020 20:55:41 -0700
Message-ID: <CAJht_EMo4bpzv_T0G5xx6t=dr4HgyTPHtk+m_NyMqEmAD5uo3A@mail.gmail.com>
Subject: Re: [Patch net] ip_gre: set dev->hard_header_len properly
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 2:49 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> Another reason why tunnel devices usually don't provide
> header_ops->create might be to keep consistency with TAP devices. TAP
> devices are just like tunnel (TUN) devices except that they use an
> additional Ethernet header after the tunnel headers. I guess that TAP
> devices would usually use Ethernet's header_ops to expose only the
> Ethernet header to the user, but hide the outer tunnel headers from
> the user and let them be constructed on the transmission path (so that
> TAP devices would appear exactly like Ethernet devices). If we want to
> keep TUN devices consistent with TAP devices, we should hide the
> tunnel headers from the user for TUN devices, too.

Actually there's a "Universal TUN/TAP driver" in the kernel, which
passes L3 packets or Ethernet frames (that are being sent) back to the
user space and lets a user space program add the tunnel headers.

https://www.kernel.org/doc/Documentation/networking/tuntap.rst

In this case, we are not able to construct the tunnel headers until we
pass the packets / Ethernet frames back to the user space to the user
space program. We can only hide the tunnel headers.

To keep other TUN/TAP devices in the kernel consistent with the
"Universal TUN/TAP driver", we should hide the tunnel headers from the
user for those devices, too.

> Actually, a lot of devices expose a fake L2 header in header_ops,
> instead of their real L2 header anyway. Wi-Fi devices usually pretend
> to be Ethernet devices and expose an Ethernet header in header_ops. So
> I think it is acceptable to not expose the real L2 header in
> header_ops. (This is also what needed_headroom is created for - to
> request additional header space for headers not exposed in
> header_ops.)
