Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A8053AA8A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355907AbiFAPym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 11:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355899AbiFAPyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 11:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ECB4EF57;
        Wed,  1 Jun 2022 08:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AF166154D;
        Wed,  1 Jun 2022 15:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005F3C341C0;
        Wed,  1 Jun 2022 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654098879;
        bh=e6Mna80ZspxyJQOd2dpH7QWG2Ug46f911yLUGDUxQH8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qYdX9qlassQM7uQXqDKZoHY7KTJKw4/j7zbd0Mhde2G2/ja+4TOlot9XhOJil0tAP
         eUWqcNUFfMu5pwVN3mP+7r7MgnTATy33duaB3sNXt4yvfsYyB/x+BbpvlFA6zD3NwF
         iSf8rOqtf3L01B6EyzEQ3726rXnpBPPCKTxawfWQpD6PEr7/4zt/DS/lkOoBu3o9za
         Gqa5M5vOkZtuqamHNEasH2EtYeCsyJoIgPGi5CbKnGFUXA8EU6hzfW6SF/utaCmTGT
         HZf5xG17afh6QsGAqHSw48ZhnF1eBe16CPgjnN6axsMANWzF0punFxi+bGGo8yR4ro
         FBs3g5DPWQntQ==
Received: by mail-yb1-f177.google.com with SMTP id i11so3647200ybq.9;
        Wed, 01 Jun 2022 08:54:38 -0700 (PDT)
X-Gm-Message-State: AOAM531S/hS3G/glsTbFnbFakCS19dJyDUC1Tpf3n3PB+/uFZGe48Ux7
        /4iyVaPNYC8qWBMCPk4rYgaCeTh5DvUsHp3mYQ0=
X-Google-Smtp-Source: ABdhPJxDULUZimykAAiyTJY1pmwtfTjTIeATsCu98SHFPpPlNMPxRzB8uBI2GLQQP9FV4OEh+S7pU42zj4IPRo35WtQ=
X-Received: by 2002:a05:6902:114c:b0:641:87a7:da90 with SMTP id
 p12-20020a056902114c00b0064187a7da90mr388126ybu.561.1654098877958; Wed, 01
 Jun 2022 08:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220601084840.11024-1-lina.wang@mediatek.com>
In-Reply-To: <20220601084840.11024-1-lina.wang@mediatek.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Jun 2022 08:54:26 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7jxdpWSKm8+PAAJYBLRvg3bsE0w=TGXkPTy4VrYSGttA@mail.gmail.com>
Message-ID: <CAPhsuW7jxdpWSKm8+PAAJYBLRvg3bsE0w=TGXkPTy4VrYSGttA@mail.gmail.com>
Subject: Re: [PATCH v2] selftests net: fix bpf build error
To:     Lina Wang <lina.wang@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej enczykowski <maze@google.com>,
        Networking <netdev@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>, rong.a.chen@intel.com,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 1:55 AM Lina Wang <lina.wang@mediatek.com> wrote:
>
> bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
> including path.
>
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Lina Wang <lina.wang@mediatek.com>

Acked-by: Song Liu <songliubraving@fb.com>

PS: When sending v2, you can include Acked-by/Reviewed-by received for v1.

[...]
