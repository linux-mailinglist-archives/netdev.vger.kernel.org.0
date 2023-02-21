Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B6F69E196
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 14:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbjBUNpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 08:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbjBUNpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 08:45:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E595D1D92A;
        Tue, 21 Feb 2023 05:45:02 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b12so17389517edd.4;
        Tue, 21 Feb 2023 05:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BPwLlLuY1FKXO4A9ZDz90DlqJ7cLNLdUerGapUJa9gU=;
        b=aJwwRq2AZqVoYb4S5cgh9zg0KB/eBoVpq6yYEPRuMFEShiJ9+rm5Ddt1nUKN9nTtUo
         soZ5Bddg38c8bJVtW9MVPr/89ASau8m4KN+vRyeJ5Qg+V+n6uTZEcDJRUw3553tGWbpx
         Ywac+kcC6WOxXzOCkkpTZ66SyZBP0T0llTQFsKvRcRO8A2KCC9QJH9MKJ09IK59aMjNx
         fGj7pcFQcwFxBRWQeM9e0F5D4UWImh6ct84Dis2m3WZl0bnCqZjJNHPRQNgQ8QVn0Vtt
         uodCnY814hiXawBcKH2DbT+gDZY2kWxlMry5ZKWEZ0FKPk3rj6jYWuXFxmcjCjPSTLDn
         +/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BPwLlLuY1FKXO4A9ZDz90DlqJ7cLNLdUerGapUJa9gU=;
        b=tRYRjdr5i/1yYEtmKxycArLFRHYHXIfpia9if7dalaJJJjeOXg3d+SQy2o0m05/Kup
         +v5SmMorSdpEHLhKwdKgP0PuRbL2Wkp5Z9fkbUWyoPqkio13lE6HK5ZAPBlUL/CVTFhs
         YotRwJHBGqdKdUWXew+sPSweYBsydNHyKmZwY82t0+/mSGn9GpnRjxNHGslNH00BvfPi
         Ni+KwX5Y5niYSssC3v/nWqyExDWQUh4KtuhPRQNKT7NlY7b9PKQQu5Q0AG4w9rxGIZ+1
         akOegyIc6DtJuNMMq41tS1XgHa8FgaaEuOf1psNjVNKUVYpIXhCHSdS4QitzW0Ntq1BV
         vpuA==
X-Gm-Message-State: AO0yUKW5p+ourVM7QZmRJKi2gi4PvMjxSZX0V/57Qs+E+drvIXyXPyMZ
        //+aAymjbJZ0N4ayq0TdjDcPrUjp6wwPIr05iHY=
X-Google-Smtp-Source: AK7set9xbFUj3ZmBDzg5UHj5LvyEdNutY/k8pkGpLbvIr6LYPYh+rw+c2EgdXEggmi+3a969dCfkYIB1Fkq0WCWVfIM=
X-Received: by 2002:a17:906:9396:b0:8dd:70a:3a76 with SMTP id
 l22-20020a170906939600b008dd070a3a76mr1542482ejx.11.1676987101312; Tue, 21
 Feb 2023 05:45:01 -0800 (PST)
MIME-Version: 1.0
References: <20230221110344.82818-1-kerneljasonxing@gmail.com>
 <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com> <CANn89iJjCXfwUQ4XxtCrNFChdCHciBMuWcK=Az4X1acBeqVDiQ@mail.gmail.com>
In-Reply-To: <CANn89iJjCXfwUQ4XxtCrNFChdCHciBMuWcK=Az4X1acBeqVDiQ@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 21 Feb 2023 21:44:25 +0800
Message-ID: <CAL+tcoAdYO_NnkWLYbxxRgw0=muhM0TJo3FBEeCBYtBmsnfWUw@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix memory schedule error
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 8:35 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 21, 2023 at 1:27 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Tue, 2023-02-21 at 19:03 +0800, Jason Xing wrote:
> > > From: Jason Xing <kernelxing@tencent.com>
> > >
> > > Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
> > > and sk_rmem_schedule() errors"):
> > >
> > > "If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> > > we want to allocate 1 byte more (rounded up to one page),
> > > instead of 150001"
> >
> > I'm wondering if this would cause measurable (even small) performance
> > regression? Specifically under high packet rate, with BH and user-space
> > processing happening on different CPUs.
> >
> > Could you please provide the relevant performance figures?
> >
> > Thanks!
> >
> > Paolo
> >
>
> Probably not a big deal.
>

> TCP skb truesize can easily reach 180 KB, but for UDP it's 99% below
> or close to a 4K page.

Yes.

>
> I doubt this change makes any difference for UDP.

Based on my understanding of this part, it could not neither cause
much regression nor improve much performance. I think what you've done
to the TCP stack is the right way to go so the UDP can probably follow
this.
Calculating extra memory is a little bit odd because we actually don't
need that much when receiving skb everytime.

Thanks,
Jason
