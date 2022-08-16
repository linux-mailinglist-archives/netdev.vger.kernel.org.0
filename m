Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B42595922
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiHPLAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiHPK7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:59:40 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57085F9BA
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:26:11 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 53-20020a9d0838000000b006371d896343so7149327oty.10
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=mj2ljsSpXXh0hu81/FEohv+AXmxb3uGRWKA3mBNJ+xM=;
        b=PijiMDgHMMZHWJwCqS2wLShY4SuNGd/F40fHInxiAz96eisqUVwGdI1jbKHN5LIPh4
         eYV+8T6T/b/I+BdRxtcKUNagq/0d5eDfOEWpdz7nahWyetRHTeFVi2nkuGs6D57L1KEg
         IG1VXUwwv+9ibq/Ra8h7gFIcnQHN35DBF/EZXJ2kt/smGav+yHuUg0BZriM7kjjgfhNA
         7tWKgp873nESntrL8RLvCP0X5ebngNHM4NxYK+9dgPkwLLl8xcshRbip4zrwd3AyCjsZ
         quYJx6GVNQPNVRhBTjbsZaqpK852xG4UqeQJH0AMOEMgQ4R4Pqs171D6fe2xBNcZ71Cs
         DRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=mj2ljsSpXXh0hu81/FEohv+AXmxb3uGRWKA3mBNJ+xM=;
        b=ejNiJm+Y6/yUcRRTavZo4Ct5W1/ph0qsyeZvzr6brZByxOm1FbUUixmseIXk7Wo6Ai
         T+CyHOdgEbbwsmLRul0cfypI6HjVE25UYKjeWMsBgEnhJhOL095HLVHOPx63q06aUaiI
         HZa6p/gIjdCSs51tsLpGXjJhG7/MC0yA+o03A6hhPk551i1QTks9YmX9CzCs6oj2/RdU
         5/CcZtSM5SimjzRU71dcUvq/fAm0T3f/eekip1mIZW9BX/psiolXViNWRyMQErq6Rg2H
         kyRIqftACVZxLkYdBpkA6SHnOmyytMYVAgnvvLxAejSUiYJXbmeGfyLTlZbti/jRBkX+
         +ccw==
X-Gm-Message-State: ACgBeo1fi4OABtaS3yhY3eCvFneKJ3ojulByzma0MUC8FPBKjTk/dhGA
        8x0/PlvyVMmemxSKrGeZCrTC8vz+ziU33O46qDpjFQ==
X-Google-Smtp-Source: AA6agR4YtIG+iVIiaFOp4OzGBQYJSzyqb0bl1urPagGrMUHUjSaaE8dx8R+lXQPZFoNRCip/PcUWnvSMDws680dphn8=
X-Received: by 2002:a05:6830:34a0:b0:636:f7fc:98bb with SMTP id
 c32-20020a05683034a000b00636f7fc98bbmr7413577otu.223.1660645570139; Tue, 16
 Aug 2022 03:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220814112758.3088655-1-jhs@mojatatu.com> <20220815104434.052a53b4@kernel.org>
In-Reply-To: <20220815104434.052a53b4@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 16 Aug 2022 06:25:59 -0400
Message-ID: <CAM0EoMn=nKz+MVRDgYG8T-aUB078x-5X2bO3tQmd+CMLP3vfaw@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net_sched: cls_route: disallow handle of 0
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuznet@ms2.inr.ac.ru, cascardo@canonical.com,
        linux-distros@vs.openwall.org, security@kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com,
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

The earlier discussion was to let the other fix in to plug the CVE
hole (I had proposed
disallowing handle of 0 in that discussion).

cheers,
jamal

On Mon, Aug 15, 2022 at 1:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 14 Aug 2022 11:27:58 +0000 Jamal Hadi Salim wrote:
> > Follows up on:
> > https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/
> >
> > handle of 0 implies from/to of universe realm which is not very
> > sensible.
>
> Heh, I was gonna say, but then you acked the other fix :)
