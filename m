Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736F2569E31
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiGGIx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiGGIx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:53:58 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3DC326DF;
        Thu,  7 Jul 2022 01:53:57 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id os14so983701ejb.4;
        Thu, 07 Jul 2022 01:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1sF2XMDrDIrENLmTg4wc3PUzzEIGHwWP0RdjfbNF4lU=;
        b=Tipu+mACDJpfXKSnaW5K+Bae9J+VXyid2QbSKIzCY36ylzUgygJUMlyzlOJ7W5J9KB
         a7e99nMEN+Kj5vj+iRqPMaQk2huetI7/o0KcvJd8sc6F8GxYQ3kHonTzN7cSnevw4jvd
         CyWYOuWAwyrwax3q1GUP9Ja6JZMtrHy/dOFKX+oL5FgPSDdffYRdeGoxUrDuQcIe/XlL
         jfg8grvmMwY4Namhj370L/8zaws4upCqPxXLyHnTjFAzmhHZnmvEvCXtSGL41QrrYBdg
         112SNwX53GXV/h6gGjudwU8HzPe6OjpKltDH5FwX8KsdF6qGlLDOt7O10zJs0Y833yGE
         tH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1sF2XMDrDIrENLmTg4wc3PUzzEIGHwWP0RdjfbNF4lU=;
        b=5VxDCmqF3i3apf86FQRSINSxrshMPAMrt2d4k0uLa3X4Ve+Jyl3aMnCXytsqjez6IY
         44Un/K8a6ulpUItYLre/8zgBXaZj4cDbxfmbfPw9sv1UikbvIvstxJElqDWOZbbGAtcB
         s+6Lf47Tcw7IMm5E5//+cMXX0h2aiBv104shKohwsBGVFahgh39eY8V4WTY/a3CMLq7I
         s5xzZxlZ4K5znJWA1HlZ7vaqFPTKls+bfR5SPoriXalvsfcmeuCSR2yvP9mBDKQzXU7f
         RAlUl/obIC1QdpLQUFXRPS3Q9NkRlVuj4L8PzOBUdWNInSEeOxPGTGsTxZCi663Zc8LC
         oT7w==
X-Gm-Message-State: AJIora8216IEi0R8akKAgjfd8OD7oBd3TUSeViUJrH76VpGpqfWqgaAI
        CTEJ+82Da81YbjI2vgdWKmtu8v/2yRWx1T+8dFY=
X-Google-Smtp-Source: AGRyM1vM5Wx+tHUl816pkMM1jdinhboCATvqb9d5XTmfPVkbQDVr0gJD0Y56NU/auYtfxmWQvHPngfVpcf8xJE3zPYA=
X-Received: by 2002:a17:906:794a:b0:722:efd0:862f with SMTP id
 l10-20020a170906794a00b00722efd0862fmr43121355ejo.650.1657184036035; Thu, 07
 Jul 2022 01:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220706140204.47926-1-dlan@gentoo.org>
In-Reply-To: <20220706140204.47926-1-dlan@gentoo.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 7 Jul 2022 10:53:44 +0200
Message-ID: <CAJ+HfNgvw344Gy4a1uOt1DeSsQ8aDRK8NXqJrS9_gxcVMrFRiA@mail.gmail.com>
Subject: Re: [PATCH] riscv, libbpf: use a0 for RC register
To:     Yixun Lan <dlan@gentoo.org>
Cc:     linux-riscv <linux-riscv@lists.infradead.org>,
        bpf <bpf@vger.kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Hengqi Chen <chenhengqi@outlook.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, 6 Jul 2022 at 16:03, Yixun Lan <dlan@gentoo.org> wrote:
>
> According to the RISC-V calling convention register usage here[1],
> a0 is used as return value register, so rename it to make it consistent
> with the spec.
>
> [1] section 18.2, table 18.2
> https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf
>
> Fixes: 589fed479ba1 ("riscv, libbpf: Add RISC-V (RV64) support to bpf_tra=
cing.h")
> Signed-off-by: Yixun Lan <dlan@gentoo.org>

Nice catch!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
