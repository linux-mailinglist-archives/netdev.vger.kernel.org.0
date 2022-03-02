Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C204C9FC5
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 09:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiCBItc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 03:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbiCBIt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 03:49:29 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386D434666;
        Wed,  2 Mar 2022 00:48:46 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id v2-20020a7bcb42000000b0037b9d960079so2791559wmj.0;
        Wed, 02 Mar 2022 00:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NAr1yVsp752ZMzsPgKRFJJwUy68LPTnH9CBBM9RWaAI=;
        b=LXyIolK3Bd9PXgS3yc68jUcjclz23IjbY6nOu2QfMlRzjlEJusak7H4hfXCGaIQj13
         NS1YuKUK7LPqWPKpVRg1vyTqyK/+tmh08+4Ls8BbWzPlRT8PK0XwdSet4NvFyD/ZipI+
         2UcuNs7qVThAFgaaxfP/uUALR8oUyFKaMRKIh+vr+2pw7m2HXBRAPeJ71GTCF0SdlUsr
         iWwD0vF/g70DiPQGSSRW4XhuJ7piTFF+H9BlTVZDaaalGCrKUOh7NteNld6QIhjBce4w
         XeBHBRWWsxYupvmG9+SBU/Nq0fOqn6ICHNEPY2lfv3jto/ZQO1az8CGtA11pk7MdGDd7
         kBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NAr1yVsp752ZMzsPgKRFJJwUy68LPTnH9CBBM9RWaAI=;
        b=lgcohCJEe4FAM2vQ3vZq+x3HvWFvQGebmRO5hxD/NdBm5ULnMsREgi6UuybZacge5m
         77YQmcjznh4daujIJ5IwAPYCY4GNGikwyVZTvS05CWdsAwFWdVxbBp3oHvNpcsjASBHA
         zeXlFs/hoA286qykLDhikvSEjlBK4omP3puSNiptMBSL2VwpT0sXb7PBrHp8UUY8V+hD
         SAa1IbHo7oZlfzVdeYnnDVKovQFzvjepobltHI/ASzx8Vf0vkRUpTJVDcWbvw7H4XhZq
         SoOQoE0g3n+7kY25G2svjiBH1fr6D8NTlWwYgc6w5yNGyVR/4HtFw+ZfD2PsRgp2hmmR
         Okrg==
X-Gm-Message-State: AOAM530Z5cowXDdsLukWmJ4Ebw8i5vo7NCECwnPrFk03OxLmgbNFUh6l
        Uw2DkengvMLxtwwuYExzd6EEcJenbuJp8QN1s4Tk0je353c6sjoo
X-Google-Smtp-Source: ABdhPJy2trScQjrVlon+5f1nz3EmeISoPsgtOCPX4BHWGXAtnPR6QBIB2U6iKsfJ1D2Ei2ZZA3nASqBFPKRABehKtgo=
X-Received: by 2002:a05:600c:190c:b0:37d:1f40:34c2 with SMTP id
 j12-20020a05600c190c00b0037d1f4034c2mr20380299wmq.115.1646210925279; Wed, 02
 Mar 2022 00:48:45 -0800 (PST)
MIME-Version: 1.0
References: <20220301132623.GA19995@vscode.7~> <CAJ8uoz2y2r1wS3_sSgZ8jC2fkiyNCW_q4oQdc_JYe2bKO4NoJA@mail.gmail.com>
In-Reply-To: <CAJ8uoz2y2r1wS3_sSgZ8jC2fkiyNCW_q4oQdc_JYe2bKO4NoJA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 2 Mar 2022 09:48:33 +0100
Message-ID: <CAJ+HfNiXD_T4qdA7hMep0ncTDnPCNdtV74F8P_oTWb=2ZVoG+Q@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: unmap rings when umem deleted
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     lic121 <lic121@chinatelecom.cn>, bpf <bpf@vger.kernel.org>,
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

On Wed, 2 Mar 2022 at 08:29, Magnus Karlsson <magnus.karlsson@gmail.com> wr=
ote:
> On Tue, Mar 1, 2022 at 6:57 PM lic121 <lic121@chinatelecom.cn> wrote:
[...]
> > Signed-off-by: lic121 <lic121@chinatelecom.cn>

In addition to Magnus' comments; Please use your full name, as
outlined in Documentation/process/5.Posting.rst.

Cheers!
Bj=C3=B6rn
