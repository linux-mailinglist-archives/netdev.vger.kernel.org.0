Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690116A72B3
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCASIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCASIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:08:41 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BE623C78;
        Wed,  1 Mar 2023 10:08:25 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id cw28so8274557edb.5;
        Wed, 01 Mar 2023 10:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8JirHVQ09DhBCB5aPmkX9jdoyQBJV9YAIL+MUHS2yNM=;
        b=IZHKB+uoEHe+hnmk2HtzKaLj4D/0BFRsg+AgXv4L2aksVPeBZ603ETTuvXUFgoxDRF
         6hZTR5TLesypgd28YzgpGtp8ceuFIl1pK5BRL1j5X+utL4CLkR5a7NOzba9MmoHn5lWy
         tO5CpmELmrnn8P7CSiC/f7bJKLt5RNm7w3AFIDN3mMTXqtSRzy8q6VWtF2Mkr9bSemrA
         XVnIaqtrFcm496f8inG91Ne0qik8s9KpujSnVogbk4GXOyKqqnwaCAlUHsRwQ9zCJhUo
         P+lSJedU1o4XV8kNNBy+sc70KcpOK6I0h56FBouqllkM7Rvg5ahMIYI0j8OIpFoRWb/p
         +FJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8JirHVQ09DhBCB5aPmkX9jdoyQBJV9YAIL+MUHS2yNM=;
        b=Ir6MO309opZTl+GaFy424MMp62NLuL+NjKsTkzcWM/tU8Y8ro8o7aD3IuSdgdVcpsE
         0rCqps4hi1Hdrbb1+Y28iNhouDXQglNJld6Xb8nXsMQz7TcrC8YRUGG8DhlsZjJE363a
         /2QjIhmgeBKX3eLmS9dLIm3TW8vykdx215LXeQVqZhVLfEmDuYorQhxOPcsbc1LoVZ3C
         saM+EeW6XmYiMCxyrctxZIKGffh+Oxm5oIjHaDpCP/QsWPPazMBTosvtGIrGgZaBizqp
         xIdIYtb43Soh9HfN3S8Vla4llD7mzK7v0JLwwTfwT7omM0lMQNu7NA1dgloukNsOkct5
         9lzQ==
X-Gm-Message-State: AO0yUKXNek84a/CgHPiiU3pYH1vYXt1doBH+2k/Yy6sIC8ofQ86dg47Q
        kZX6Zrzvk0JyDunGVgTY4OcgN+MxU413ZKYuARs=
X-Google-Smtp-Source: AK7set9Va+klVdUMOwc6oFL4qHIMZ46EeIofw5YR6yENkfuFajULNCdLWIHUQZmROVVVZn/PbaXSb9oTzEZzkbq+TDo=
X-Received: by 2002:a17:906:a46:b0:895:58be:963 with SMTP id
 x6-20020a1709060a4600b0089558be0963mr3578596ejf.3.1677694104038; Wed, 01 Mar
 2023 10:08:24 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-1-joannelkoong@gmail.com> <20230301154953.641654-11-joannelkoong@gmail.com>
In-Reply-To: <20230301154953.641654-11-joannelkoong@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Mar 2023 10:08:12 -0800
Message-ID: <CAADnVQJCYcPnutRvjJgShAEokfrXfC4DToPOTJRuyzA1R64mBg@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs
 to parse skb and xdp buffers
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 7:51=E2=80=AFAM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> 5) progs/dynptr_success.c
>    * Add test case "test_skb_readonly" for testing attempts at writes
>      on a prog type with read-only skb ctx.
>    * Add "test_dynptr_skb_data" for testing that bpf_dynptr_data isn't
>      supported for skb progs.

I added
+dynptr/test_dynptr_skb_data
+dynptr/test_skb_readonly
to DENYLIST.s390x and applied.

Thank you so much for all the hard work to make it happen.
Great milestone!
