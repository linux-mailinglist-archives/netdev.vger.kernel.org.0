Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66DA59C399
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiHVQBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236964AbiHVQAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:00:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE60515A38;
        Mon, 22 Aug 2022 09:00:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id 2so10355825pll.0;
        Mon, 22 Aug 2022 09:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc;
        bh=FvmQjkF9ZDVyA2Ag3uiBTxGfKnCghKIGSTohZ1i8iLk=;
        b=cFpOtxOtzfwaOsqhR7c/P3zSbO5PHe4Aej+Z/5qu74aoA7L+quYCbnIn/S99JrbZL6
         PD6Pi8OxWArtogsHXuK0ihoZSsvqkNvgBO7FdtcWCgu2qHt6ynk51RRP1aWdlYZua8+w
         gyArMnH/NQO4J2BidgzfPlHNYnvbekZidzdZRSquB8uKz8P4fu9jsZ6qwp2fEkQ+qKhc
         yQGPHJ6243rt874dTpW05S/lvzzfld9kNDo5y5pcoX8AsgPQpHPsl/A0jKmVEAHyw8Af
         0jsOvYB+6Tr8FxPMlIY07LTcu8Dp7xFRvmn0J3Zod+6dGBgQ8SAxQy4bsT0eSjwE4D9M
         iJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=FvmQjkF9ZDVyA2Ag3uiBTxGfKnCghKIGSTohZ1i8iLk=;
        b=qPdCEz9QqPZ+vFhBEd7HB0ZeweJ6LW/l2KGMj9n0xxFkHX5FmEB3xHQJyVqeK0nXJT
         Oq4oKg2ySP9ZPlUQHWoYM2Fx5scrsxzOCCXscFsstiGyXfR+3Bdgqbc/TRtHb2LJEfty
         N6zlXKBxnd79AjztNBrxOtgdn6V9cUaUnS052d/zHtUAoEuLMVSpf2E/0REaM101q19v
         kjNRBR4mFVf3bA8jPbrg0lmSjyCDIq28xEF3Zqy52mIhEfgVxraC+vOdJLDMAZLuWuLF
         7wh59aofs4jyGczzbCxcUhfYd75NBUliyTvZd4xJI96Hojg28FgOaRhw0ZO6fJ85NHfy
         Q5Cg==
X-Gm-Message-State: ACgBeo0L2SY6h0C6OUM46eOJgMFk+KwAnG7CcvCzMVSCrxZGTdllbp/z
        nbGd6Tp5J7Ls8pH8pne5ANs=
X-Google-Smtp-Source: AA6agR59LmQbdWEk89W5X/9af1tkd4/BZkxiS++0OJ8Sc4EFOQjnWk2t9ViZSha0gb8OweAPai7m3A==
X-Received: by 2002:a17:90a:ab15:b0:1f4:fc25:f180 with SMTP id m21-20020a17090aab1500b001f4fc25f180mr29314176pjq.144.1661184045466;
        Mon, 22 Aug 2022 09:00:45 -0700 (PDT)
Received: from [127.0.0.1] ([103.159.189.130])
        by smtp.gmail.com with ESMTPSA id g21-20020a170902d1d500b0016397da033csm8539060plb.62.2022.08.22.09.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 09:00:45 -0700 (PDT)
Date:   Mon, 22 Aug 2022 22:00:37 +0600
From:   Khalid Masum <khalid.masum.92@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>, dan.carpenter@oracle.com
CC:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com, paskripkin@gmail.com,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
User-Agent: K-9 Mail for Android
In-Reply-To: <20220822153944.6204-1-yin31149@gmail.com>
References: <20220822140532.GF2695@kadam> <20220822153944.6204-1-yin31149@gmail.com>
Message-ID: <0ED076C1-6250-43EA-A7BE-948DFAEE851A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On August 22, 2022 9:39:43 PM GMT+06:00, Hawkins Jiawei <yin31149@gmail=2E=
com> wrote:
>On Mon, 22 Aug 2022 at 22:06, Dan Carpenter <dan=2Ecarpenter@oracle=2Ecom=
> wrote:

>I trid this before, it doesn't work as Dan points out=2E I think
>it seems that mutex_is_locked() only checks whether there is a task

I see=2E
>holding the mutex, but do not check whether it is current task holding
>mutex=2E I also tried lockdep_is_held(), lockdep_is_held() seems can dete=
ct

Ok=2E
>call->user_mutex is still held accurately, although this cannot be the pa=
tch=2E

Useful to know! Thanks for the information=2E

  -- Khalid Masum=20

