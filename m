Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB1A6B7F8F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjCMReT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCMReR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:34:17 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9AA1DBBB
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:34:04 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-540cb2fb5b9so151033777b3.3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 10:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678728844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8OoBtnsiUhLio1XkxWQCxxFKn2qFyy0u1AAbg2mfZs=;
        b=QoXlhRk3GPVQklHmVFD/RvvwrG4rsWGzRLtWigCNCjQeM/YHzeXLMdctP3DzSwmLbW
         nKm0lsxuQb7j44cFIOPPJ2Ao+Fef3MSEw3h9PT6h9n6hOLpLq9M19QAa5Hlrs3kRvUXc
         Uyg60hpvOloUlp9vNs1bHEeWZX1U/vUUNW89tQMiZoly3hB2J+wJ3myg1wFat6FY3NCv
         7i3yodw9Ob2wAUQBgqFKf4iXFWHRfUtOI1VWTpPcpyT70gOTZZ8FqeiAwdVlXDFYJ7kZ
         A5a+Bfg0VIdcDa46Y4GxoAiTPfeC8ekSDO9WSfwrmFyYoIO2+u4PTuXCf/YhZ3wwCJDD
         /k+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678728844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E8OoBtnsiUhLio1XkxWQCxxFKn2qFyy0u1AAbg2mfZs=;
        b=fpCaibneOxpJeIu6EEpGwctl5BcvF8OBXvM88ue1kxIuCBDW/GPzrpO8BZAwLw1ke1
         HMv134a8laGzAvRNH8e6WNQvAMMp7xEY6RFwFCB9zLPalPV1GTeTidymy4spmWGf5Nme
         RZutQ2V9Eq7OUe5nEAFs/0kO0EvLg9lCWxAXIV2MV5lRmksIHo0AK80R4wGQfdre1gF9
         df1eHRbcunTEeYh8WJg808iLkNNLkWyuMlqP96wNNmjjnuxhtJaaOIW2T1iV4uZgvoPc
         tAaPEvs1fK8hhhoKt2TZ5A++9mm+kzstPQSsMewsCwAG7PMioHh0jSgZoV7ECR9pT5Uw
         sfHQ==
X-Gm-Message-State: AO0yUKUDfTa7LaFwoYgfRtQyW79KxzdZ3pGOuSA1+OdWwaX9wr7zL/EO
        d/PY95/GqW5bw0JIEu7t0+5Uf8aCY7xh9g63ikatgA==
X-Google-Smtp-Source: AK7set9x56RnCIOXJlBDAjoX6Fz8Cex6878uDmkPuKM363zKCV7DFGJhlh5PcV0Cyp6RA37TExWl2Z3CGvctByMLalk=
X-Received: by 2002:a81:4520:0:b0:533:9d49:f9c9 with SMTP id
 s32-20020a814520000000b005339d49f9c9mr23458033ywa.0.1678728843816; Mon, 13
 Mar 2023 10:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
 <CANn89iKWewG7JZXQ=bmab9rSXUs_P5fX-BQ792QjYuH151DV-g@mail.gmail.com>
 <CAL+tcoAchbTk9ibrAVH-bZ-0KHJ8g3XnsQHFWiBosyNgYJtymA@mail.gmail.com>
 <CANn89i+uS7-mA227g6yJfTK4ugdA82z+PLV9_74f1dBMo_OhEg@mail.gmail.com> <CAL+tcoCsQ18ae+hUwqFigerJQfhrusuOOC63Wc+ZGyGWEvSFBQ@mail.gmail.com>
In-Reply-To: <CAL+tcoCsQ18ae+hUwqFigerJQfhrusuOOC63Wc+ZGyGWEvSFBQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 10:33:52 -0700
Message-ID: <CANn89iLWTie6bZZR3fkuOPfVWgjmiV9er_6MPbbcM2AE13ZQLQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len separately
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 10:16=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.=
com> wrote:

>
> Thanks for the guidance. Scaling is a good way to go really. But I
> just would like to separate these two kinds of limits to watch them
> closely. More often we cannot decide to adjust accurately which one
> should be adjusted. Time squeeze may not be clear and we cannot
> randomly write a larger number into both proc files which may do harm
> to some external customers unless we can show some proof to them.
>
> Maybe I got something wrong. If adding some tracepoints for those
> limits in softnet_data is not elegant, please enlighten me :)
>

I dunno, but it really looks like you are re-discovering things that
we dealt with about 10 years ago.

I wonder why new ways of tracing stuff are needed nowadays, while ~10
years ago nothing
officially put and maintained forever in the kernel was needed.
