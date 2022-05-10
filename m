Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF55520BCA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiEJDQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiEJDQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:16:09 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5300124FDB7
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:12:14 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r1so1682878ybo.7
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHi9RNkB7XZSHgSK6QOmdps1P8KQxpHqzUrDDknPUdk=;
        b=jaHmC8OK/f5Xq9Kl2b12PRvh2WJwAJRemcCDRsXxWjSpgnT2NbkzL+FB+7UzvVEsVC
         Ox/8b7hVI10yyBob+hjI+2dvOZZsQBbBCuzVUrEnOp1i9r/hBphqR3V5U6k4WMifupYN
         epgdEXXhGAxsbalGMVLztCQPmHGQm9JZTDiv5A+Q23/EwhF/qxGEXNqTpMjL3rnxsaNd
         u0t0YqmYw3f/62TLNtbES9i3KRTec8djTofjl/MioNlUnIwdPnLeHO3dHernZ3VUqwud
         oU24UjlZlLxSGfm4W2W14y+wIPElGSEv1OQzSg8TQMrTO8741G6xrx3C2OLFzw4hFQ0H
         mYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHi9RNkB7XZSHgSK6QOmdps1P8KQxpHqzUrDDknPUdk=;
        b=E4Af4/PuiZ9KHWCSoKc3cA+MZSbjvmZHU8F1zjJLZgqA/56T+NEGaRfcoSOo+rKLKr
         MmZso5lR/AtCdGvNMj+pCUyWndulOnbS8cTxYC0s0H7Aty3iz+s0cHUtNVo2qlT/AR5C
         BKtujTAc26xzRpXb3tdRFzf6SzNoK/eqcTcxetoTYDG32UCQqS5TWg4h9pC1wh+mYGQj
         0Iw4GnuXjUjVuG0i/GcUubrZNaf8h6bwoMlFzP9wa63qpfUzvoGmqsT2ojQYHD1lm3wD
         Kqv/dm+DxFwQoTcjePysrJtZE34Ig5PXV2k5KTRBIsxk27i2vUcPXVuulyQ8juf7go+v
         TAHA==
X-Gm-Message-State: AOAM530naNLCKB06C23luEue6gD8HD4GkyS3wbb2fqxErRbPOArsvNjJ
        W853XwtOCwbYSEpIL2LDhzpSFY7ublQC6hApVlKx+Q==
X-Google-Smtp-Source: ABdhPJwScZ9FNN5Qy7mDT6+oLGGA6dVcuooWSirAeK4HLkuzYaM9xY6QYc7ZUNBRCh8svPeA8p1bEXQodWZk4yxM+T0=
X-Received: by 2002:a25:230a:0:b0:64b:49c:c67c with SMTP id
 j10-20020a25230a000000b0064b049cc67cmr2323738ybj.598.1652152333243; Mon, 09
 May 2022 20:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220510005316.3967597-1-joannelkoong@gmail.com>
 <20220510005316.3967597-3-joannelkoong@gmail.com> <CAJnrk1Zn2sy=bVC5HBggRHTTkjqqXZAx1VyO1r8PWSkLBY7KRw@mail.gmail.com>
In-Reply-To: <CAJnrk1Zn2sy=bVC5HBggRHTTkjqqXZAx1VyO1r8PWSkLBY7KRw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 20:12:01 -0700
Message-ID: <CANn89i+iNZTQP1Etm60sC7gix=_zyj5RCoaa7dWVBordoh1_Ag@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] selftests: Add test for timing a bind
 request to a port with a populated bhash entry
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 6:01 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
>
> Eric, this is what I used locally to test the bind request. Depending
> on what you think about this bhash2 proposal, I am happy to clean up
> this test in a v3 follow-up.

Thanks, I will take a look at the series tomorrow.
