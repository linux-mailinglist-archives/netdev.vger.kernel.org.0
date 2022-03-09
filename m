Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B074D26CD
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiCIBTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiCIBSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:18:46 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B2E1107E1
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 17:09:23 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id u61so1209337ybi.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 17:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vfg54W7tSp0DEPmUswpML/GwWD2rV07vtR5aJI0hleA=;
        b=lLl+rKj248qk140tfRHE1ZPJKI3Me0kNI6B1qgZNlGda/3kJZjzD9e0lFclybLGnPB
         GPcRw8SDvCrlQ3voMT7M7v41Bs2WG4VX/R39wYzQgQmmdPHxLhqOXis4SUltWp3Tq2N8
         yET3dlui+6ibvvgzLqfEzl4arvES0O5+ZgGHhRHEY2pu8+nNmeykPqv8g8bQcr2iDUlV
         P0S+1L65gag2LgPZtal0EMAmVvHjDv7D1M5fPsQhgPHa79sfs/wVAZU6QQhHC9fkIwI2
         usO+/TdhMSXwRlnQSHCReXfREd14eD/OU1Ra4Kvzt0T2WzZTcwfE05P0p8o98dx0OkHO
         mevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vfg54W7tSp0DEPmUswpML/GwWD2rV07vtR5aJI0hleA=;
        b=3Y1Duk6Q2AuO56f+c6I0m4SNHPIl49hdKpVyuhs8BxvOT42VUu4vq2BysDjApIQGwf
         jK7jKvcqDolZssNOpvv2t2shGHyIUyEkmXcdTG3PpBUV1WjksTO+GZAxkJwf7NlD0aQm
         W1VMK4ZwYHFocYN0NY0/e0mKT44MqweUuRgzbI3ikUSLsS+jpmSStclGza4pa7V/8kKC
         9cWtNfgwX/3/ezib+HD1JeJCeOJtvKh/7ilCDDFDP07AxXrRYglP7YV+Se7qR4jJsJi/
         N4PhQBoBjWr1/ENK9DPUK9tWGtS0sk/HZxtcW1Aieem8V0Pr1kA6QzrbXi21IdSVYKMy
         aSmw==
X-Gm-Message-State: AOAM53139n7yCbLgKgJGNoJo8aX8yZfZWV9pDyY6r/CJlAMheh8Cix50
        06b4o/ceRGR6ndx10uI3LBFTT0iyz7rqEc6ApuPPgA==
X-Google-Smtp-Source: ABdhPJwf+Ytcb8rsES8lov9DZ+AAN514ijLqF3SbgN6+hQwLd/X0uP7xmeGeXUySOv9BCDDqbUMomExhKaeneZLhq9g=
X-Received: by 2002:a25:f45:0:b0:628:b4c9:7a9f with SMTP id
 66-20020a250f45000000b00628b4c97a9fmr14463365ybp.55.1646788160177; Tue, 08
 Mar 2022 17:09:20 -0800 (PST)
MIME-Version: 1.0
References: <20220308030348.258934-1-kuba@kernel.org> <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
 <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com> <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
 <20220308161821.45cb17bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220308161821.45cb17bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Mar 2022 17:09:09 -0800
Message-ID: <CANn89iJe3bmMFjN2B4wiwSWWh_PWQMnbRmMdjq8CX5RQR_Y4aQ@mail.gmail.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
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

On Tue, Mar 8, 2022 at 4:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 8 Mar 2022 11:53:38 -0800 Eric Dumazet wrote:
> > Jakub, Neal, I am going to send a patch for net-next.
> >
> > In conjunction with BIG TCP, this gives a considerable boost of performance.
>
> SGTM! The change may cause increased burstiness, or is that unlikely?
> I'm asking to gauge risk / figure out appropriate roll out plan.

I guess we can make the shift factor a sysctl, default to 9.

If you want to disable the feature, set the sysctl to a small value like 0 or 1
