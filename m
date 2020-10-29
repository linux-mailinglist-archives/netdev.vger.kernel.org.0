Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3A029F3DF
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 19:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJ2SMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 14:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJ2SMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 14:12:19 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19358C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:12:19 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id k12so958808uad.11
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBFG84kffdpQB3q/alZtOLyCicYkmdPQjs8ew6gGoVE=;
        b=NfXSnV6sTc9qSLHs/t/lTP89PaxjOTdrrN7d8kvKf8nsoWOcJon7z5dl6LpXeBMtBp
         EbdtZxqckRI+2nGatsn1UQJox9gEJg+mcnK+3xWylbZe34MRneK3hcVunFuivZrhyEY8
         cscAxyEiyTeWP5IPRaPzLFJ3OdZxZPbii9WWgT6XvRKRcqM449cKJnhAiwjD8HIoG7Ap
         1giF+1w1zdBhPeLJtAMKKVK5K0UaQr9rxTdthj2rIM/EVviuCdhkEJdHrpOOdqMElCVm
         sP59BuHXk4puBhKde3CDSXjZoxdR1Z2+r1QMvkUHERa001Cz/A0bvg24ECDpXjjtlIAc
         WKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBFG84kffdpQB3q/alZtOLyCicYkmdPQjs8ew6gGoVE=;
        b=XxbPQLpqgiBGVb9xIf7JUaumnF1fbQ3P0tAVx+v13s9Q19SP95l/5tCJdfcCG0LSF4
         pFi6GnvrFQy8lQ8/wjaccRwRZMQ0XWfhWbRGhhXkWomt7g/AEIVIMFdrTeYBU58Oit2K
         cUP8Qe7JVHltcD281eMpRGxQq6YgyCYwXcnCq1iOP+dPnFVfXr8HnXq9Q3i14iD1ll4U
         mxB2d3IRGN/ze2Wi7PKzKcjnYVn4gb+wo5oZ7C9iqsOCxvSht1/SmQnuwEUMLwQOTk/B
         YqELFymzOHnYJfDkOy8fhHbDuolf+B+vLew8AkzCMVfoaLM0+dCS6222BO71wCmuOcrl
         iUGA==
X-Gm-Message-State: AOAM531KQhjDsAg3ifruBrnO4W5+/wAdGjF5q81hbA4jKfcyDH/x4E1Y
        n0IbbzYU7p1uxnoMuqidchcVJxtu9rE=
X-Google-Smtp-Source: ABdhPJywBmdw9qt35sfGdIPs57+V8z3lv1O8pKuWm4Jhl6LT3Z0dkl5c+tuQ+iQ7E10DcW/iLdtNfw==
X-Received: by 2002:ab0:55:: with SMTP id 79mr3818082uai.59.1603995137352;
        Thu, 29 Oct 2020 11:12:17 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id z200sm412308vkd.52.2020.10.29.11.12.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 11:12:16 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id b129so2055701vsb.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 11:12:16 -0700 (PDT)
X-Received: by 2002:a05:6102:2f8:: with SMTP id j24mr4439947vsj.13.1603995135673;
 Thu, 29 Oct 2020 11:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <72671f94d25e91903f68fa8f00678eb678855b35.1603907878.git.gnault@redhat.com>
 <20201028183416.GA26626@pc-2.home>
In-Reply-To: <20201028183416.GA26626@pc-2.home>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 29 Oct 2020 14:11:38 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfs1ZsEuu4vKojEU_Bo=DibWDbPPXrw3f=2L6+UAr6UZw@mail.gmail.com>
Message-ID: <CA+FuTSfs1ZsEuu4vKojEU_Bo=DibWDbPPXrw3f=2L6+UAr6UZw@mail.gmail.com>
Subject: Re: [PATCH net] selftests: add test script for bareudp tunnels
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:27 PM Guillaume Nault <gnault@redhat.com> wrote:
>
> On Wed, Oct 28, 2020 at 07:05:19PM +0100, Guillaume Nault wrote:
> > Test different encapsulation modes of the bareudp module:
>
> BTW, I was assuming that kselftests were like documentation updates,
> and therefore always suitable for the net tree. If not, the patch
> applies cleanly to net-next (and I can also repost of course).

I think that's where it belongs.

Very nice test, I don't have any detailed comments. Just one high level:

Are all kernel dependencies for the test captured in
tools/testing/selftests/net/config? I think mirred is absent, for
instance
