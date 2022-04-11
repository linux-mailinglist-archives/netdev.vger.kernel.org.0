Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465694FB33F
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 07:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiDKF37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 01:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244722AbiDKF34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 01:29:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571C711C34;
        Sun, 10 Apr 2022 22:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E57BB810B0;
        Mon, 11 Apr 2022 05:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A628BC385AA;
        Mon, 11 Apr 2022 05:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649654861;
        bh=6JE6CkkqvT8gpFPt73wO6bnBz2niQMz0KlSZdcAsTSA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Iq9yf3lVtexXUjbRqzQny1CMaSYeGwPVcTvMO2Z0/fMJfOWpklp24nRGEua3uzLHM
         hu9l1xlZ8Wj1gzQfFuGjYIhdnoxH4Qv3+oBgHkE3KGleM5QfpyAyNDicGWbpMZUWtW
         4HiomU7Tf+ZYXsR1Q5DENHkAEIg0WuGWO90vKk2Njh6lKaMeA5N9wzHe9UV9T280FQ
         BGTvTK5ZekwMzFMYDSgSfwDXnBl6FY79cumDyqBawDwdSpawTX1lbMkH82JZpuU0V3
         LCfaOj4fyYixjwMGdvR7ixxcHBS7nCWLASKgu2PrKUGmnepFCSKmY63JU8HlHPj/FO
         EXGODQNSFdsUg==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2eafabbc80aso152374627b3.11;
        Sun, 10 Apr 2022 22:27:41 -0700 (PDT)
X-Gm-Message-State: AOAM5321runTeOMRWh8Z5g8tf4Xp+j9XfforJH4f1n9WxlNiwKxmY1oR
        jH5p7nUx9INGpv4RdMQFBGoBfTpTD9xOsCU7bbQ=
X-Google-Smtp-Source: ABdhPJwtYGn9UBaXm1EN0MLwH89tzIV9mtnD0TSpP8BwumcTUPwnohVUkCkR1v/UgybJKo4GFibVTzLOOLBoXeHtSmo=
X-Received: by 2002:a81:8685:0:b0:2eb:3106:9e3d with SMTP id
 w127-20020a818685000000b002eb31069e3dmr24585075ywf.460.1649654860740; Sun, 10
 Apr 2022 22:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220410060020.307283-1-ytcoode@gmail.com>
In-Reply-To: <20220410060020.307283-1-ytcoode@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 10 Apr 2022 22:27:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4CZL9XBLc5xsCLOCyh+c7vC2_0nggYu7x2+8ZB9X70Jg@mail.gmail.com>
Message-ID: <CAPhsuW4CZL9XBLc5xsCLOCyh+c7vC2_0nggYu7x2+8ZB9X70Jg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Remove redundant assignment to meta.seq in __task_seq_show()
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 9, 2022 at 11:00 PM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> The seq argument is assigned to meta.seq twice, the second one is
> redundant, remove it.
>
> This patch also removes a redundant space in bpf_iter_link_attach().
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
