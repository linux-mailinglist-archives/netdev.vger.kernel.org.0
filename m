Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18D95A7B61
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 12:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiHaKgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 06:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHaKgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 06:36:07 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138B99E11F
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:36:06 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id u3-20020a4ab5c3000000b0044b125e5d9eso2431717ooo.12
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 03:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4XVWQsnyTN8TrpfpiHWB/WH1aPqpj9mPCQMD13VTXUo=;
        b=r4JOpMQCwHRwg86CS6zPb6F1zvt2OSVU/2vJ8S07FWE/DWdv8jJ9Rh8+Vsjzf57n2u
         5y9RliqZBgg4ZFihdfQDv1/qCsi80D6rxCJUJijaUyPrGX9waws8dZ5daMV7HS346nk5
         mauZBSuu8mYeWo6nXl46z6iMpjs/qfx8DulEDr2p3JLCnJxycAy6H/jH65JjSHDe+e/i
         Iav1diceRpkogMuvyzSUfBbyNn+wg09/HO0JgNqmNT1oKN8J2PvvaguEqoFvkVb9ifnP
         XbB0ncRKZ5d54Xw2LF4Ceq4bqIzWwj/aPgA89lY2vJVrzhM2x8oiQJDwEPrmbO506LcL
         tlww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4XVWQsnyTN8TrpfpiHWB/WH1aPqpj9mPCQMD13VTXUo=;
        b=OKkiUi8GGpPbc6TxY9ZR9SrldPycgp+KOg5DIjMPcw3LG6fAw2eZ55NryH9FYEizNx
         hs6mVK93nQEgeJ1Asg4m5ekLl/Ovwbnb7Cx/mL8QrJMn12IMGVguWeJf2djzWqbrRuLZ
         vNXQFONdMsJiTrW8EZY8L257EXyNhb1FnLshCX2vdptx1PCuWO8+L3QOsgtVrXIXmwXR
         ltzDh2/PkMjxJJzbeyl9Vl0MJ6Dmnf5R39w/WyNvz8p3aonO26NjeT/R6tZUkUek27p7
         cnmq5sKuoUr/h4L8VSWg9SZ2L2n6LQ6S6DuSHW4+yWHRjT0S+XNYBlRExWEDN0h3YGOq
         4nyA==
X-Gm-Message-State: ACgBeo1tUiFaqa5CYIfFEr/Wa/CqEHCO62zgzYuUF+K4l+dSXChmnbFP
        fKxe4cJlOzStdriiBXuxDIll03/PhMlWWN9aizNjJg==
X-Google-Smtp-Source: AA6agR4TMTMRG0rieQcHb4YmWNcMKN3+dvQU2Et1lmkn+PmytsI4aaqLooGfzXnS27McD6HYB3ogmgLITewSpN7GSK0=
X-Received: by 2002:a4a:1787:0:b0:44d:f068:d0e2 with SMTP id
 129-20020a4a1787000000b0044df068d0e2mr6048063ooe.27.1661942165446; Wed, 31
 Aug 2022 03:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220814112758.3088655-1-jhs@mojatatu.com> <pwfk72r10zgjfy.fsf@ua5189936247a55.ant.amazon.com>
In-Reply-To: <pwfk72r10zgjfy.fsf@ua5189936247a55.ant.amazon.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 31 Aug 2022 06:35:55 -0400
Message-ID: <CAM0EoMkRJ30QM6P-Sm0Tme0He5X1O0E6mvOnSB=OG=900s5O6g@mail.gmail.com>
Subject: Re: [vs-plain] [PATCH net 1/1] net_sched: cls_route: disallow handle
 of 0
To:     Anthony Liguori <aliguori@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuznet@ms2.inr.ac.ru,
        cascardo@canonical.com, linux-distros@vs.openwall.org,
        security@kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 11:26 AM Anthony Liguori <aliguori@amazon.com> wrote:
>
> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>
> > Follows up on:
> > https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/
> >
> > handle of 0 implies from/to of universe realm which is not very
> > sensible.
>
> Hi,
>
> This was posted two weeks ago and now that it's merged, could you please
> post to oss-security?
>
> I don't think there was an actual embargo on this one.
>

Apologies, not familiar with the process and wasnt sure if this was
addressed to me.
Are you asking for this to be cross-posted to oss-security?

cheers,
jamal
