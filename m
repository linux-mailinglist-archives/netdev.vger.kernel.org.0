Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43DF6C729F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCWVy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWVyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:54:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09D3113CE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:54:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ek18so742723edb.6
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679608462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwF4PjfX50G0tO1s1nkfZf9mTnmPVFCblQ+X/mkUZqQ=;
        b=E9yb93D9vJl2xfJOVLj0UIRZ0hZs3DiPYLnTS/7VQ/BdIrdAeww1WuyMmSMl4bFreV
         LPDpnsKQmCeYn1nLfPseVfjE0x28g2Kh5OsuaAKcHn1kXxQAW0SYdYYYlpH1NxID6pIh
         YH13e13dhKszTvD9Zo+ak7xgtuXUXf4LHq0kM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679608462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwF4PjfX50G0tO1s1nkfZf9mTnmPVFCblQ+X/mkUZqQ=;
        b=wZ6fAF6QYExUaP0UFlcOoVmuy+JNdr+G4ARqt7wH5RAo06FXSKeIRRRHfDn4dKiiY6
         Y9qbUMhvFN25kSM7nU1Tpg3WAuC3fVR+bnqu9JwULVOYoTqs14Z8JneJkRLcBui99WaW
         tnrZlPWziBEcai9PdEv0ZoIb3PnekoA8ZZl1N+OyofGlMWYGrsTfOwygLSNa794e/PR5
         Ot+hHgiS6aV+A91+Kf0Dp6/xZ2XYpYkyP2t+vYFJnCSzkWWvLv5bW+aJm71FMnKJN9YE
         4rLizY2xHs/0VvWSYtTHivJpuMJ0s0FiaTWN6S4AkOEWo9T7GUQh6sCShEecJ/rz7Byx
         jn+Q==
X-Gm-Message-State: AAQBX9eWMR8rbStrYaamZUle88qjVOgdF3cMDJ7MKSg4IHzIasOeV90W
        vvHmkg6gNNjyeaiRt686RRpFnvxbjlltp7xF3r97Bw==
X-Google-Smtp-Source: AKy350bsdy+s9/BiTs0GpVpndmijsrqahXc/dn3N4g79vzme1J+Gdm4FOzzAZY9d/vkfU/nK0TZTvQ==
X-Received: by 2002:a17:906:40c8:b0:921:d539:1a3a with SMTP id a8-20020a17090640c800b00921d5391a3amr539763ejk.58.1679608461796;
        Thu, 23 Mar 2023 14:54:21 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id g13-20020a170906198d00b008c16025b318sm9160018ejd.155.2023.03.23.14.54.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 14:54:20 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id cn12so776551edb.4
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:54:20 -0700 (PDT)
X-Received: by 2002:a17:906:2456:b0:8e5:411d:4d09 with SMTP id
 a22-20020a170906245600b008e5411d4d09mr252006ejb.15.1679608460276; Thu, 23 Mar
 2023 14:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230323102649.764958589@linutronix.de> <20230323102800.215027837@linutronix.de>
In-Reply-To: <20230323102800.215027837@linutronix.de>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Thu, 23 Mar 2023 14:54:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVN+bMsYjTWQZehtRJNifGDuoMsgQg8789aZ9QT1pfjw@mail.gmail.com>
Message-ID: <CAHk-=wiVN+bMsYjTWQZehtRJNifGDuoMsgQg8789aZ9QT1pfjw@mail.gmail.com>
Subject: Re: [patch V3 4/4] net: dst: Switch to rcuref_t reference counting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 1:55=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> V3: Rename the refcount member to __rcuref (Linus)

Thanks. LGTM,

                 Linus
