Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CA56A8986
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 20:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCBTga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 14:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBTg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 14:36:29 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B142A4A1EA
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 11:36:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cw28so1445290edb.5
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 11:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677785785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMpeUvEYrqUYBTl3i4/HldERmQW4oJNrULU8+QHVKzQ=;
        b=BYcaYhUQ79fOBo2EK8jHFq3LJAUm28rvGs9w50RmJ9Gz1doBd0D267u3oxGDouE0EB
         tCQKgKrRQxslclGIQD3ZoHCxY43t8dy7cfOcxsOxGJeJWnUqALQojMPJfF+x1M69JaFZ
         O33PKirJtz92OKV+gl3/6j3dhLVUQLwQjWPAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677785785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zMpeUvEYrqUYBTl3i4/HldERmQW4oJNrULU8+QHVKzQ=;
        b=Sz3cW9594TgAxsdQeYBS6aItMqlqGcNlbBvTAnXzl1DNhMsZXjmhnNpgMvuBPyTU+w
         YtBixPt6dN4haMhMC0SdXaYKTaCCjQTatKn6IJ4SXR/oLme596KW563yYDoCDZuOlt98
         COxPA4TPAyxXXAMvzSGYFlcrnFP8INGvG92VRWJh0boGCsVjBSn3N7K7h5dWE7Geafzq
         VYrQirNJs0OcPtc4YRMOiEpE8BkA/uAi+g3Xp1aOnu+abDbvDfaqgdGZWsnHibyGyia3
         bKigN+Zl6eJ2ZeSfljOyMCm8f89z/BQySk5kCeIrcbMYsFiZzPUeM7QUZew73IU3fSmS
         LZjw==
X-Gm-Message-State: AO0yUKWc2qWwzlMHLa93rpQo33T0FSx16R6ECGEB9TfcURl6IUHZUutU
        P2VCSiH+ZV7RSTA+r3yotcbVml/2U3eZOHdilco=
X-Google-Smtp-Source: AK7set/LM0ELaoznnMO0QtKgdlNGxYB/YlqZFFmX37ZkfmnBw118byo41nU19wAVIKQyhsuIe7lluQ==
X-Received: by 2002:a17:907:2cc4:b0:8a9:e031:c4b7 with SMTP id hg4-20020a1709072cc400b008a9e031c4b7mr13993915ejc.4.1677785785038;
        Thu, 02 Mar 2023 11:36:25 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id ku17-20020a170907789100b008def483cf79sm33678ejc.168.2023.03.02.11.36.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Mar 2023 11:36:24 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id d30so1461538eda.4
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 11:36:23 -0800 (PST)
X-Received: by 2002:a50:9e26:0:b0:4af:70a5:5609 with SMTP id
 z35-20020a509e26000000b004af70a55609mr1981413ede.1.1677785783066; Thu, 02 Mar
 2023 11:36:23 -0800 (PST)
MIME-Version: 1.0
References: <20230228132118.978145284@linutronix.de> <20230228132910.991359171@linutronix.de>
 <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
 <87pm9slocp.ffs@tglx> <87bklcklnb.ffs@tglx>
In-Reply-To: <87bklcklnb.ffs@tglx>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Thu, 2 Mar 2023 11:36:06 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi=CDyS_ebXw745OCXnhwDpVLnahNveQNcZOPrzE5QiQA@mail.gmail.com>
Message-ID: <CAHk-=wi=CDyS_ebXw745OCXnhwDpVLnahNveQNcZOPrzE5QiQA@mail.gmail.com>
Subject: Re: [patch 2/3] atomics: Provide rcuref - scalable reference counting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 5:05=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de>=
 wrote:
>
> The result of staring more is:
>
> get():
>     6b57:       f0 41 83 45 40 01       lock addl $0x1,0x40(%r13)
>     6b5d:       0f 88 cd 00 00 00       js     6c30                     /=
/ -> slowpath if negative

[ rest removed ]

Yeah, so this looks like I was hoping for.

That PREEMPT=3Dy case of 'put() makes me slightly unhappy, and I'm
wondering if it can be improved with better placement of the
preempt_disable/enable, but apart from maybe some massaging to that I
don't see a good way to avoid it.

And the ugliness is mostly about the preemption side, not about the
refcount itself. I've looked at that "preempt_enable ->
preempt_schedule" code generation before, and I've disliked it before,
and I don't have an answer to it.

> but the actual network code does some sanity checking:

Ok. Not pretty. But at least it's just an xadd on the access itself,
there's just some extra noise around it.

            Linus
