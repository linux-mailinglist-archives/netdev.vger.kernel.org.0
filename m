Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A73752F5D7
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348835AbiETWq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiETWq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:46:57 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2A8AFAE0;
        Fri, 20 May 2022 15:46:55 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gi33so9566628ejc.3;
        Fri, 20 May 2022 15:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7VSmTsrf2yRmDPUJj7O4mhbeh8I71iXxthfFzi3aXkY=;
        b=IDKxeJ8SiDdIfH863/nqT0j9/oK9RffxHSoBU/YfUbDXzroET4eYNRV1zNCUxEaWnG
         Pkot+DctHiLZHSYTz17WCwyNwWLNSzhphRyOXbp7mEMH/Oc3vAfXrQ7e9HjTaV7CeG68
         SHLv0AIKUUdwf0seJRCjZgNvM1AHSlgRsgPwxlwX3l88C+2TFL4lU1u5IpyhxM57s0hb
         03acGg740tRQaowRW+Qs5heTK3Es+GTTDJwJ5faZBiF9W2eDzTMOQUCymSVSElXBl31R
         jUbpANF3T8Nh0O1Hn1TbalyTbIiNMo0UengQkfo8Nc1gsWFK5p3LNP53QTP5oOKsFJ/k
         XMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7VSmTsrf2yRmDPUJj7O4mhbeh8I71iXxthfFzi3aXkY=;
        b=LU3yUXwmc/+eNNtxI9XRQfwdD41o6Vd9RE4k8pX2gNN57d4Sezz+l/naTpP1qVlMzE
         ZQE+63rW+mDR3AY/6S+tqsn3dvyT5LfaySIrfoUPXQU2kK3SNDpSE5wX+ZtcZL9ZyzFM
         yD0VOxwkE8WfMRIEwjubzuBPS0bgvuddaxqVGC0fjtV6QFsYu8vBGMDMpqjOC2eJlaw5
         UStAG1GxX3YYdep+Dui6C+i4IlLCUZtrLOpQ/yea9XGDLpv71ujDx37UvEjiE2LN3AgJ
         Gr4cjEl4Qs6T7Iy07mTkI88pbtL4kesch8MxnCTn9M2HCsUZlLeO57RD2rRwRp404OjU
         mWFw==
X-Gm-Message-State: AOAM532g+01YLCZr/zZd31jrTDghvLKDg2QjsaLW3b4LnYgvmTpIyZYG
        z4UGWMXOSviUUAhehnvmNUVymkDKUclXkJZaGCI=
X-Google-Smtp-Source: ABdhPJzv2U16Vzaku4966umMnfoPWOcUFGVy3bm7ySb9ND5HlqxVQMQuqiT4pmFn9OVXCr91+j9mXw9nQIm8v9wjJe8=
X-Received: by 2002:a17:906:9753:b0:6fe:aafb:31a6 with SMTP id
 o19-20020a170906975300b006feaafb31a6mr4663290ejy.502.1653086814409; Fri, 20
 May 2022 15:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220520113728.12708-1-shung-hsi.yu@suse.com> <20220520113728.12708-4-shung-hsi.yu@suse.com>
In-Reply-To: <20220520113728.12708-4-shung-hsi.yu@suse.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 May 2022 15:46:40 -0700
Message-ID: <CAADnVQK8JcV8n4J-FgryKxgLBnNHLMWftjSiEZ3zPuCnFgkKrw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] bpf: verifier: remove redundant opcode checks
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
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

On Fri, May 20, 2022 at 4:38 AM Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:
>
> The introduction of opcode validation with bpf_opcode_in_insntable() in
> commit 5e581dad4fec ("bpf: make unknown opcode handling more robust")
> has made opcode checks done in do_check_common() and its callees
> redundant, so either remove them entirely, or turn them into comments in
> places where the redundancy may not be clear.

I prefer to keep the existing checks.
They help readability on what is actually expected at this point.
These checks cost close to nothing in run-time.
