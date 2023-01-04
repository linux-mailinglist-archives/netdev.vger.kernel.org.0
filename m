Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AE365E0AB
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbjADXBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 18:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjADXA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 18:00:59 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6753B1901A
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 15:00:57 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id jo4so86263009ejb.7
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 15:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:references:in-reply-to:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XppnWxwUDd4VKlDQMnttNa0YhBi85GdHW05upV3mZfc=;
        b=fJM+bXf1CCW0+0edI2hk1VwRp1Om2TirjIk0wHeI+o2Fip0lBU0Jjm1kxWHjazNp4o
         U7EA36Jujv5wauB3KRLyhGE8X4dAqB+USfoatgowcTJX9nD3cULCxd8wyNaXl0CzG4KB
         q1HcvnOvh5jlGaNrj21gzpE7HMEp4pjmsP7U0gdGn3U2nrzuXjbw3rvKt+or7s2te/za
         cTZsWqT7aLlUTptqj0nR+jGau8aTt5qffhq0az4zHRkJrZ/+KF+czgYl+KjqDUkMbpwm
         8Z2dOoumlMeioBUESsiAN7mNa9ZlBhrKhuH62S0BQ34rCGnox6tZmLwDQqkVGFpc5ukr
         1eyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:references:in-reply-to:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XppnWxwUDd4VKlDQMnttNa0YhBi85GdHW05upV3mZfc=;
        b=yixNNwolmbRQiICW8GbfFzT809ltxCMVm4rwQAjjSfnGXM8GGNP7yJ6dbjUm7yx598
         M86VuTrO/VUMeIDGsFfAC7wMry1R+4AI6hmAyh8I4PvnnRCpKLgVzf2CwdntcqIvmMR8
         kHpy2i08MHTpGlG6iW1xd16t9BTMNY7mJaLheZ6HyohakEWB4YdCMa1dGaeHj1Db1d2n
         tvNjWzP1pctTPLpxFt1t5uWDlHi3TvN70vp5JfP0j8WXzboWUbuV1xFGfCLz46IUqGio
         a+igzaLq/XD9vPao9WQBlaJiS4MAKzppUeHu8UxAxhEYjMSt7091iNXhj+2VvCS903za
         cDuQ==
X-Gm-Message-State: AFqh2kpqkMRmY5LRVgAlKa4WF8DtqR/O9sEQo0tdLnRGK9Hdjzmdpst4
        SDcz2Vm8iaqaGRR16u8mJwLdhIcfw0iSxcMDBLI/D48qtCP5uw==
X-Google-Smtp-Source: AMrXdXs+eVvyiCxCKe24ziuU8uM070gry+IFf5pBWvFzFx3rMu2JixMyHB0JlUgCGg9QAI/vgJPYEC8PADaLxGNXkoc=
X-Received: by 2002:a17:906:7ac8:b0:840:758a:9157 with SMTP id
 k8-20020a1709067ac800b00840758a9157mr2678444ejo.434.1672872652893; Wed, 04
 Jan 2023 14:50:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:81b:b0:27:37f1:bc15 with HTTP; Wed, 4 Jan 2023
 14:50:51 -0800 (PST)
Reply-To: lisaarobet@gmail.com
In-Reply-To: <CAJ8KLPZKUxDZq39GHC=jv+B5FtcA3dQoRwAozXyT7mpDqtT2MA@mail.gmail.com>
References: <CAJ8KLPauCfukWsXYV4A=eUrGM8=Aa0FFD3dUDvGJt=CZTLaKVw@mail.gmail.com>
 <62eb867e.050a0220.0cc7.16e7.GMR@mx.google.com> <CAJ8KLPa5uwGGTPzicNhFHwz-0rZdKfrDTSwNBWxdF--Mfc8t2g@mail.gmail.com>
 <CAJ8KLPZKUxDZq39GHC=jv+B5FtcA3dQoRwAozXyT7mpDqtT2MA@mail.gmail.com>
From:   Lisa <smithgrace507@gmail.com>
Date:   Wed, 4 Jan 2023 22:50:51 +0000
Message-ID: <CAJ8KLPa5V8mMkqJ5HrpQXy=DunsCNFEus7aiLDDOTEgH4NQXmA@mail.gmail.com>
Subject: Re: Delivery Status Notification (Failure)
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Just wanted to check in and see if you receive my request?

Thanks
