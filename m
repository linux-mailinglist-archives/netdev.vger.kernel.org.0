Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9F584516
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiG1RfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiG1RfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:35:17 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359F46151;
        Thu, 28 Jul 2022 10:35:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so2904095pjl.0;
        Thu, 28 Jul 2022 10:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=QspELtFwrGd992ER4IywagKhOwPAd04XFlDr4WU6NiI=;
        b=mr2y8Nixp9iQYiaPkk1ld3aAvfXUbpKTeQ15WW56UqOrHJT7F6ygOyrLj1DDaCkTiT
         Btb3DBlO0KaSYzChaNk/QE5FisTCujb6TIsaKo4sDfHWGqDOXRI4z6wzpsc71giBkXAE
         UhjaXLzeSQ2FYrOgzCYkyCnkLpH0GqfV6Nyk/MXzhQHa6peGkiIqaB74rxQlVlC4CRMH
         0m98YNTpKu9tGdkZ38JBZ7DKi8bs2oCmbjDgzVxUBHk1Hvy75bihPcG4YlLTiseIQnl8
         KKQA0QK0h3Dm+kDcrY67cJ6p/LBOkjXG3TRzWjzbNxxOvxuxKDD6/OsYCaLaW7q16zWD
         FPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=QspELtFwrGd992ER4IywagKhOwPAd04XFlDr4WU6NiI=;
        b=cd7rWHuNS5uDB7il2YX4eDJx0qj+jLnLXs/4kxa3TC/DKhvsacr0iWVVPP97fMw2Iq
         BjjXkN03w/KU1CqbJjiXG1JEINRRimJbg1PzUFtksfVPI6fcJ5spYVRrhCgVn/FXWgWb
         zxmKjRWq4DRhYhIdJxBuKfSqSBtnTIV24tMiJs/th93BPNHSzzt8EBV3UEPf/VrGfj+r
         PSfVV9SDH3bzxRLtMd3zcSxY1SdTpyQ1V8Bi9I7txolqPj914Z584ASgk73P+kBNHM8B
         m6W39kMpz/TlwFKwJqRC4id/uVY4vRiSJ278/LwefAzvqGd/6yWu3Iwq5yXP27NcU9WG
         phlA==
X-Gm-Message-State: ACgBeo1FzFWIEnXFKBKHvfddWEEQXFyHY7aQ+Hz5/c5gr4BB6EhLnVuL
        yulW5q2pktzlWSXh7N7WmBNpeJ/zMjM=
X-Google-Smtp-Source: AA6agR7okzIQnyApf+9UYpAca/XBs/2oCNUQhHi1ypbpfNRIB7ZTqTSnbha72zmPDlumuwhqNZoOww==
X-Received: by 2002:a17:90a:4809:b0:1f0:59d7:7ee2 with SMTP id a9-20020a17090a480900b001f059d77ee2mr464354pjh.240.1659029716495;
        Thu, 28 Jul 2022 10:35:16 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id c204-20020a621cd5000000b0052baa22575asm1035532pfc.134.2022.07.28.10.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 10:35:15 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 28 Jul 2022 07:35:14 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Message-ID: <YuLI0jh8Csq0mErM@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
 <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
 <CA+khW7gfzoeHVd5coTSWXuYVfqiVMwoSjXkWsP-CeVdmOm0FqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+khW7gfzoeHVd5coTSWXuYVfqiVMwoSjXkWsP-CeVdmOm0FqA@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 10:20:46AM -0700, Hao Luo wrote:
...
> is a good feature of this convention. My thoughts: It seems that ID
> may be better, for two reasons. First, because ID is stateless, the
> userspace doesn't have to remember closing the FD. Second, using
> different identifications in two directions (userspace specifies
> cgroup using FD, while kernel reports cgroup using ID) introduces a
> little complexity when connecting them together.

Yeah, you can pass the IDs around different processes, print and log them in
meaningful ways and so on because they're actual IDs, so my preference is
towards using them for anything new.

Thanks.

-- 
tejun
