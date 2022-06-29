Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B25560187
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiF2NkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiF2NkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:40:14 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB10115825;
        Wed, 29 Jun 2022 06:40:11 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id fd6so22245286edb.5;
        Wed, 29 Jun 2022 06:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qTC2bv1e9/i2DY9yoyJBZYcQ52UQ7X3XJtMOFo6SMV0=;
        b=qJwkVZW8LKFm/SKPapzY3ew0vq+YIMWU0/aIAelxS3mKVz+RwGDfI9H2ZmSF7zePk+
         WBMb2NK78nQr37JpWWUSVaBqMcT/kC7o0iWdZjjQSoG8BNzqBEv/GoBioy0XQEq0dk55
         v5fBiQBkvSb32EaZvmFLCbgcJOlZjaM5UrlH9tyLAdiDH/07QgnL3KKWEXxgjwovb7OT
         gWKoSOCfV95Dval9hDMjL3l/GH1WGA86oVSPfePC9wHvnfp4O/a5IQd6ARlDbp/wZRd3
         2pCczifWys9rbABw8xoKtIRUuvpW3qiURv/nJo1iffIyD7dDCbe/U0Grjz5FNBDCx/8e
         xWZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qTC2bv1e9/i2DY9yoyJBZYcQ52UQ7X3XJtMOFo6SMV0=;
        b=h9yBFrRkfVpMGub7U7w0dYlahDWL5vyMcd1U4Mv+JGbi5iMPbmdRajKnWQHCiLj+Mx
         NlDfeeZmVk0EGr0ZYQiwaZtLq7OgeeJQauSSVcGBAKnhgfe6AL952zbh5g+8hEhpKAze
         TDdEh/8wo2QfvNXoWCGj89XbIZKwCPjlI4EgofYsTTju1BZB7uKq7R/Pl50gxVoV2qhU
         p5z2dvy+14LIQ8YjzdHIyNgLd1X8jwtou5226Ss3Q3LaUgooIcTVbQwtU/VrPjfpie5d
         eedSDUTJ/sYQ51zBNXhqc7gNt9q+nImdmxu4/7fdTBkZsFdC0v0vxUEJRTLhy3xWdyCW
         nrOQ==
X-Gm-Message-State: AJIora81XToR+/WfIskumU53xcSxv+CqjrVTBWjKaXjVU29oLxrBZoDl
        bTGEhwvymTryHAlMYJRMv8h/hjFqMbylv3Bd+S3ObDN6G44=
X-Google-Smtp-Source: AGRyM1tIoYbDNPtWBH2LU1XGPtsAK6BgpwHm5+1JP908HO3wcqqebKy/1EvwJTftaQaAmtBTFe68abzvoEhcNwAnqBc=
X-Received: by 2002:a05:6402:f14:b0:435:7f82:302b with SMTP id
 i20-20020a0564020f1400b004357f82302bmr4300100eda.57.1656510010334; Wed, 29
 Jun 2022 06:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com> <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
In-Reply-To: <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 29 Jun 2022 15:39:57 +0200
Message-ID: <CAJ+HfNgBXTWLWOthG1mOmy8ZZyzLAggpZLq9qOzbdzRxxmK77Q@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
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

On Wed, 29 Jun 2022 at 14:45, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
> TL;DR, I think it's a good addition. One small nit below:
>

I forgot one thing. Setting napi_id should be gated by
"CONFIG_NET_RX_BUSY_POLL" ifdefs.
