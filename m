Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E15554BFD5
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 04:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343802AbiFOCxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 22:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiFOCxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 22:53:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A81F2ED70
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 19:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655261612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+psGn1HbD1ddfcHcN+3MfAY7nS065MYabWrtHtxzgJo=;
        b=CqhB66fWzDfsL275I8IYbkxJrnPELG6vw0n4KmwDUgj9IDXnwq478BFSN0xiN8/kK7Jmwu
        pnT8MrGoJDp7KIf9JhaGVk5MCnKXujWcBh7jh7YdlM2LHh0WYWBob8fpQv+VE5VvmPfznx
        x8JOTHsPlA1YBdy4xBKn+2K+hFK832A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-HS177Z3NMiise7H9us3cGQ-1; Tue, 14 Jun 2022 22:53:30 -0400
X-MC-Unique: HS177Z3NMiise7H9us3cGQ-1
Received: by mail-qv1-f69.google.com with SMTP id r14-20020ad4576e000000b0046bbacd783bso7262532qvx.14
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 19:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+psGn1HbD1ddfcHcN+3MfAY7nS065MYabWrtHtxzgJo=;
        b=TOU9Tsaym1q5BJhiB02kdrzbAUz2y3GN5O2T6VLd1pNSzU9bF5WdLSrCtXDcvgFU4Z
         CMz3vZvy4hH8OC6RjEj7IjjG4TIn0YN//kUF0o4DNyhYgaj6tpo+f/R6FTy+IFj3lnZu
         u6+A0kQ0jq+4Qghzv5wG+lwfyNcBIhQvBnCva1BQbAdIetNpWS1tGo0xHH3vOatzKM2B
         7HMhLf2Wm+9XQPjjcBUqUJ+UCL+gO/+yPv/oW4h3CRML6Oh7/rcBD9dZ78nN1oHH2fKe
         8A0zFzwo2wKLC8O8i2S4yQLs+l4kP4Yq/oktPeW10honLvfwvWF0201uYI13Rt+9Uyut
         4qKg==
X-Gm-Message-State: AOAM530aVIdPHyLY320PyOvGEVFRe1Fg+aWePz+xl2nv1idRRvoFDDwL
        uJA4c3r3rZgeL6sxDfrpgksqI96ircglFmfc5k4yvcBXQYukrh9BBRruSGU7tmTPvelNwHchjM3
        FuKLlkA4+r3RDdbiiOHTrTdUgiqvUVz+x
X-Received: by 2002:ac8:5749:0:b0:305:1ea5:4a7 with SMTP id 9-20020ac85749000000b003051ea504a7mr6799824qtx.291.1655261610342;
        Tue, 14 Jun 2022 19:53:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJozBKiWIIRK2SoWxW71uiM6m1ijR9laogZS/lkB354NOpSjaTp93daJqxAGR2o2gRD2tO9VBCFoSgWJLub18=
X-Received: by 2002:ac8:5749:0:b0:305:1ea5:4a7 with SMTP id
 9-20020ac85749000000b003051ea504a7mr6799821qtx.291.1655261610152; Tue, 14 Jun
 2022 19:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220613043735.1039895-1-aahringo@redhat.com> <20220613161457.0a05cda0@xps-13>
In-Reply-To: <20220613161457.0a05cda0@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 14 Jun 2022 22:53:19 -0400
Message-ID: <CAK-6q+ioLUC=M-i00JX4mq8a9dh6+Jh=q4ZhYgmZmeoS8WMN+g@mail.gmail.com>
Subject: Re: [PATCHv2 wpan-next 0/2] mac802154: atomic_dec_and_test() fixes
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Jun 13, 2022 at 10:15 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alex,
>
> aahringo@redhat.com wrote on Mon, 13 Jun 2022 00:37:33 -0400:
>
> > Hi,
> >
> > I was wondering why nothing worked anymore. I found it...
> >
> > changes since v2:
> >
> >  - fix fixes tags in mac802154: util: fix release queue handling
> >  - add patch mac802154: fix atomic_dec_and_test checks got somehow
> >    confused 2 patch same issue
>
> I've got initially confused with your patchset but yes indeed the API
> works the opposite way compared to my gut understanding.
>

not the first time I am seeing this, I fixed similar issues already at
other places.

btw I told you the right semantic at [0] ....

> We bought hardware and I am currently setting up a real network to
> hopefully track these regressions myself in the future.
>

I wonder why you don't use hwsim... and you already mentioned hwsim to
me. You can simply make a 6lowpan interface on it and ping it - no
hardware needed and this would already show issues... Now you can say,
why I do not test it... maybe I do next time but review takes longer
then.

- Alex

[0] https://lore.kernel.org/linux-wpan/CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3d6PrhZebB=-PjcX-6L-Kdg@mail.gmail.com/

