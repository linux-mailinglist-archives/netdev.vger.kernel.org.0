Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758E35239EA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbiEKQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344655AbiEKQU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:20:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081BC2380E2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:24 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y21so3211527edo.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=svG1L/bGhyxGAlocPxyHJusAcsDTJHaGb4g7JRnLN34=;
        b=SLYn3yafpxhPinrhVN+KvALYpBdGm6IPDJeU17IYRguThw4zYzuAUMO+wgE8mES8b4
         TAvhOMEIzlAjl54FO2fajRhHHQdSYqfX00mqyItYDD3jbYNbNda6kImAMtKkUrF3hSa2
         naE7anfld7oOW69AFhZbUG91usyzFIculkTzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=svG1L/bGhyxGAlocPxyHJusAcsDTJHaGb4g7JRnLN34=;
        b=Rh4yAm1nJ2sB3nKdAXLmN1UqU9djadOK74xNmRieKEpJ2Z25olDDb/AYORwUi6bW/e
         sjaXS8SGKqPNZNLw7D5bJGVXb4ZpIshltb3fEgAKkcY6LeHPedvUozAx0p4751Dw5e4n
         j7yyKA05LG+nUddPFKJc+ut12CPHFIKsxXKcn4Jo8RSN4eS7CP7phFvBVTnexJOR2bj7
         NKJfspmPTpU6MzRkctp2/JWe2QUv0pALr3Xtp3EdYJKhp9x28EkJAE3lhyG3KcB7JWfc
         IoeR3vWnfw3B1gDElgc4drEh5n9cAvqlcywy1xPNV2n43x5EuGO1Sr+omh+anTbjE6l+
         E5mA==
X-Gm-Message-State: AOAM530GDDmw+BvNu6MlcaNZa0v7Z6V9aXvez9Z2OPDLi/AbX//SDKSg
        BTLyLbvGQE7/VAWF1CsSRjM2tV6BtQ3pNQgNBM0=
X-Google-Smtp-Source: ABdhPJzwd1V8XZikOLj6D3ILnxVooOhmB3dC1IfAfM/n5eAVfZHIDaXZ5TjK7T93rjPemYTxb3CY/g==
X-Received: by 2002:a05:6402:34cd:b0:428:1043:6231 with SMTP id w13-20020a05640234cd00b0042810436231mr29932889edc.274.1652286022318;
        Wed, 11 May 2022 09:20:22 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id bu17-20020a170906a15100b006f3ef214e24sm1148571ejb.138.2022.05.11.09.20.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 09:20:20 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id i5so3683890wrc.13
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:20:20 -0700 (PDT)
X-Received: by 2002:a05:6000:2c2:b0:20c:7329:7c10 with SMTP id
 o2-20020a05600002c200b0020c73297c10mr23431402wry.193.1652286020296; Wed, 11
 May 2022 09:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com> <87czgk8jjo.fsf@mpe.ellerman.id.au>
In-Reply-To: <87czgk8jjo.fsf@mpe.ellerman.id.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 11 May 2022 09:20:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
Message-ID: <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 3:12 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Which I read as you endorsing Link: tags :)

I absolutely adore "Link:" tags. They've been great.

But they've been great for links that are *usedful*.

They are wonderful when they link to the original problem.

They are *really* wonderful when they link to some long discussion
about how to solve the problem.

They are completely useless when they link to "this is the patch
submission of the SAME DAMN PATCH THAT THE COMMIT IS".

See the difference?

The two first links add actual new information.

That last link adds absolutely nothing. It's a link to the same email
that was just applied.

                   Linus
