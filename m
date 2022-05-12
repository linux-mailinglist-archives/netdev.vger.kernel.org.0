Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB675524222
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 03:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiELBjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 21:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiELBjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 21:39:18 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3321BADED
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 18:39:16 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id j2so7287158ybu.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 18:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fFj3zTRqPz6qgPmLgoj9A7MJ+Yxz/7b7l1r37/Uh1pU=;
        b=OtbtggIT9wxaBBASc9D9VEEEswA/MYz7jWczkEJ2j77Xc/TjckbbXIf6esUo7ETkb8
         kAxvVRf3KqCcVnN0qrBL1DgK+fXbzKJ3qfCBxfYSlctUDBFoJghBSKC5mr8JgYN2Bt5A
         9/orbaoTQsFe/5NMacqE4PjYA/oTo4gNRzu2Pvi+RXzXBqwCOIZaXM1nvihdIm95+CM1
         jii9RS6sGYV2N+V9B3DAWm+HaJbQUU9CAzACqYlucWXm92nNgvu3Z/3QtUZL6y6JzFsf
         m/S1i8TucXKG3uwkwBOzxt1fy/LHy/w0D1Ht8CQKZ0fDvFqHenQB54jFZ0Y63K+7dqKg
         0urg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fFj3zTRqPz6qgPmLgoj9A7MJ+Yxz/7b7l1r37/Uh1pU=;
        b=pXf7LsUtSV2A1R3HVG6kd2nj79ltXa3xQlNFq1O6FpAT3isChLHgSzsJy/HPDzUegQ
         8nPjbK5anphziZf42G/Csgu9hvY58czisjR4AY5fOae1xXYYZasLZiP+O8IEnhukHUJ5
         2g5y9RrzM9+fuSA+eoN/8JltQyGn86lQ87PYoBZOmXBwuHPqOnwf0ZRFHXv75WjpnapA
         edp5mn+tDmgMiAdsYc2C5rPAGgUCcVWBqXZCimvO7gQQLnSmQfpOXptOJpJcJ8agsW6n
         ibkjPQ2rLQ3B0lIobAUdgse/URqDsz9cptr9giTF2d0kKiO/D00C6q6xflKK9qXy5pBU
         RG0w==
X-Gm-Message-State: AOAM5319aJtS1fFbmPZMBLqo6gboxf0ZiHy7tuHX9+lMP70t44tJzLvZ
        ZDit1AiQYB5r6PPCecC7QUlbMq3B8AgyzrMqiKoP8A==
X-Google-Smtp-Source: ABdhPJz2WQnoKR4ccRUeXk7ZI9i0dn91M4qxEvpcOa6bGQiHid26APTKphfLm6xOfJ5mYnuxDA8XBUJo454XcgFXxKM=
X-Received: by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr26667281ybx.387.1652319555506; Wed, 11
 May 2022 18:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220511000424.2223932-1-joannelkoong@gmail.com>
 <20220511000424.2223932-2-joannelkoong@gmail.com> <CANn89i+nAZAYB+VcrO3fAW9F7RmbFcKzmFUr=-dSvL-v61DJEQ@mail.gmail.com>
 <CAJnrk1Z+33HXn+5UGF-3146QfUGnLjNxmU60QbCsm=yYtitRZA@mail.gmail.com>
In-Reply-To: <CAJnrk1Z+33HXn+5UGF-3146QfUGnLjNxmU60QbCsm=yYtitRZA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 11 May 2022 18:39:04 -0700
Message-ID: <CANn89iL-9jMLLOQe9i4SzcYFad=sRi_juBGQ9FP7zQ7bn+kbyg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: Add a second bind table hashed by
 port and address
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
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

On Wed, May 11, 2022 at 6:09 PM Joanne Koong <joannelkoong@gmail.com> wrote:

> Ah I see. Thanks for your feedback - I really like your suggestion. Do
> you want me to fix this and send another version or wait a bit?

You can send a new version at your convenience, thank you.
