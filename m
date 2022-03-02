Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7004CA057
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240340AbiCBJJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240336AbiCBJJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:09:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72E691AFA;
        Wed,  2 Mar 2022 01:08:30 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k5-20020a17090a3cc500b001befa0d3102so684885pjd.1;
        Wed, 02 Mar 2022 01:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ySiLPgYH/u2rMj5lQJfbuMpcBYv7gbQ8mWKz+gY/4zY=;
        b=atIejbu9P59oD0B57rP0GdhXIO3q0MYSyaL5TpMJF4UXG9sXg7PqByFWvt+MApkXQ1
         G6TdS71PjUaH/or86+5eY3/A9WQrwVbX37G86sR1sc6KTEw+rPq4P+uFvmSersWmN7E3
         NWc0x4T1WPNcpaz03KNU0ukL2654ly05m8NYJW6Xq5hL/LnTDs63/PcHNz5dKSZHaxCo
         LG5FQcyFxL856CaYjKb2zfGkpaXT/jVd4gQ7kz0bW7XpGft3F+1iks5Dm/dk3Ei6y6wo
         0qF46BVJTUD7TVbSTU+frlkWkk34zUsTn22f4XpDGMkQhBJxlJxQLKbWt59SvEl14ZUn
         rjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ySiLPgYH/u2rMj5lQJfbuMpcBYv7gbQ8mWKz+gY/4zY=;
        b=Uy3bZP7i07wRVHd0HjfRQX71EvX4hvuv3lfIIJK3SnaOe/eXU5yuz4UeSJgYRvhmZL
         tCeu7aaQ9UYB8Fy7dBht6bh/RuHS1Xxnk4y6sfixd52op0Tp3jGfWbbFu1wikzZTh4W+
         TG+u6jbqvEmX33MfQWWE1Ng7pu93N4TgxPnbyPaGBFfcrTNbwDzCbfgh/vqfN+qNx64J
         u8IJyu6HZSn4EURHki5A2kNX9LBvSkIPcGkvhk2pQhD5N8xfmRVU4+NJghcq9cHMafjW
         PrbKQHkaeHO3Fo+UpWG1ZGs1IbuckqNbGJNPIP8cMozIMf/aBvcxgVt8ILqbd9TpQvHU
         EGHw==
X-Gm-Message-State: AOAM53134ZvQt08RiZd3TS2TkmirIJcZGrd1cri1Z973iwA5hTe0DUWP
        xzu2H9HN0rlT7WHylvrDrhUfC56pdIWwDJPi0FI=
X-Google-Smtp-Source: ABdhPJw3TqNQxmcFegrhU+yx5hnzCVskvVT3GGKvBtmDF7Irs+QT4lO9XhK5vv54xXZ3NIj3UVGpMHriBtq55I0N/q0=
X-Received: by 2002:a17:90a:550b:b0:1bd:1e3a:a407 with SMTP id
 b11-20020a17090a550b00b001bd1e3aa407mr19744597pji.112.1646212110063; Wed, 02
 Mar 2022 01:08:30 -0800 (PST)
MIME-Version: 1.0
References: <20220301132623.GA19995@vscode.7~> <CAJ8uoz2y2r1wS3_sSgZ8jC2fkiyNCW_q4oQdc_JYe2bKO4NoJA@mail.gmail.com>
 <CAJ+HfNiXD_T4qdA7hMep0ncTDnPCNdtV74F8P_oTWb=2ZVoG+Q@mail.gmail.com> <20220302090603.GA12386@vscode>
In-Reply-To: <20220302090603.GA12386@vscode>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 2 Mar 2022 10:08:19 +0100
Message-ID: <CAJ8uoz3LDVFDXyGjhqaHiyL5=fCPJKrFNyjA7LQVv8x-VX2ZTw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: unmap rings when umem deleted
To:     lic121 <lic121@chinatelecom.cn>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 2, 2022 at 10:06 AM lic121 <lic121@chinatelecom.cn> wrote:
>
> On Wed, Mar 02, 2022 at 09:48:33AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Wed, 2 Mar 2022 at 08:29, Magnus Karlsson <magnus.karlsson@gmail.com=
> wrote:
> > > On Tue, Mar 1, 2022 at 6:57 PM lic121 <lic121@chinatelecom.cn> wrote:
> > [...]
> > > > Signed-off-by: lic121 <lic121@chinatelecom.cn>
> >
> > In addition to Magnus' comments; Please use your full name, as
> > outlined in Documentation/process/5.Posting.rst.
>
> Thanks for the review Bj=C3=B6rn.
> Magnus, please let me know if you can correct the full name when you
> apply the patch? Otherwise I can create a MR in libxdp repo. Thanks

I will add it.

Thanks: Magnus

> full name: Cheng Li
>
> >
> > Cheers!
> > Bj=C3=B6rn
