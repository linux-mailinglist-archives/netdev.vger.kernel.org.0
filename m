Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72CD4F66DD
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbiDFROb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiDFRMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:12:47 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4C6334130;
        Wed,  6 Apr 2022 07:33:53 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k25so3098774iok.8;
        Wed, 06 Apr 2022 07:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SDPT/7XOwVJA5stp6aCZ2hXWWrYq1jMxAHm5GkzEDuc=;
        b=WX+y8x8ZuriiwRWLrv5L2YmO/NTIzmrzF/kye3v2pg88FUSKz9paK+LJRObBjsUrah
         W1KgujRrUP01TatSladWtutsjA3C77eBPX3LymphI+mwhSGSn7rZrOnbOya2xGw+yqU+
         f5T6TuCugRAx/Da0SnJg+vFSH/Fm8NctFNwid6KXkKdK9U+dr2Et0/Vl96o4wlawu1j7
         vZ13oKeFxct7fswPHPEqDdht2Seuul0ehtIDSyDgpm/Hn5CO4MSaxcxNR6I92sM44bC2
         lZtzdLOAm6AX9IdIqpjn1FxAOxVN7yInhspb2Tbr97lsbBeMyPYJpyW+9hn+mIrAgwQ0
         xO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SDPT/7XOwVJA5stp6aCZ2hXWWrYq1jMxAHm5GkzEDuc=;
        b=66F5azhdrEDOwWXN1/ev2vNPAiCQBbt5wkgJMDVMoZh09LztA7WUVQJsp6o57xlZWY
         iyFEKZ2Ar49hJv+4jCzRonblgAUH5vEv7bE7+hPKpGj1232naF/x57bel/FC9eL6jHKm
         CmKU31LdjHuM9KMt8uf5RlYXYOAMNZ4/04V7ymeMME4jHORxfLJUoSo5ztnHnCrtXF6b
         S9ULOiJHpKSCqL1bQhcCpm6bZzlI25TjbN73Ivphp6SZ/nWF32Pkr6xXyzbfaXXp2afh
         uYucrNK/e//lY+kanYtZNHuS3+DgtBjHu3R/qDwSBCV5AS2yK1GbPQBmQOCtaKgq2Q+7
         2x9w==
X-Gm-Message-State: AOAM531by7uX+cZTrNm3cAhnJfRx1ATaDvsU8tUMu9TOAb+/Latjiydl
        z90ildhVk+T4MiEMI5PnZo4U9jtIHpMTZPaiMrc=
X-Google-Smtp-Source: ABdhPJzI2QYvo+0uHCEiHux5uJO44L2+UJtWDzdNUQzgJLHxUw5SlW8gjEvjeLI6qPYr/wRXun1SmwfO103sTDW/NFY=
X-Received: by 2002:a02:a48e:0:b0:323:62c6:bae8 with SMTP id
 d14-20020a02a48e000000b0032362c6bae8mr5015902jam.140.1649255632687; Wed, 06
 Apr 2022 07:33:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220405130858.12165-1-laoar.shao@gmail.com> <20220405130858.12165-8-laoar.shao@gmail.com>
 <82b87aee-09c2-fbad-7613-4e298bcb3431@quicinc.com>
In-Reply-To: <82b87aee-09c2-fbad-7613-4e298bcb3431@quicinc.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 6 Apr 2022 22:33:16 +0800
Message-ID: <CALOAHbD_kftnnN4Qg4rwwL-Sb_idJiBE4D_M4r9n0wtUzRypbA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/27] bpf: selftests: Set libbpf 1.0 API mode
 explicitly in get_cgroup_id_user
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 4:47 AM Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
>
> On 4/5/2022 6:08 AM, Yafang Shao wrote:
> > Let's set libbpf 1.0 API mode explicitly, then we can get rid of the
> > included bpf_rlimit.h.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >   tools/testing/selftests/bpf/test_dev_cgroup.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_dev_cgroup.c b/tools/testing/selftests/bpf/test_dev_cgroup.c
>
> patch subject should refer to test_dev_cgroup
> (currently has same subject as 05/27)
>

Thanks for pointing this out. It was caused by the copy-and-paste :(

-- 
Thanks
Yafang
