Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 847C14A0D9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfFRMb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:31:59 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37257 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfFRMb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 08:31:58 -0400
Received: by mail-yw1-f66.google.com with SMTP id 186so6631431ywo.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 05:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2zjjaR0MJ6NCbQ2tNDKmWvCG8E9amxT1DIK1jQtxlWw=;
        b=PT1Qlvo71aLKxUQwCTqmeZ4N6sNBlKRFpZv3vzbAfnR55ezeV9DkyI+37sHYq2F5+v
         ZI7hAXS9LNNDh7Qgo6PE+503R7wclSAotEkoeINPTfY+bJwjCaALF8kifRkod8xh5TIJ
         STBEIhy1kACDq8eJcufi+agQluKNKJVpns5JosCrupD8uj8K6FGdCY2D0LldV+3JW5VG
         khVDOHYzdZ06h4sGzxQa7XINy9I59z4lA4QbKrCW7TbYUwAdrHPqY7lXA0hk3jBa9Xg/
         2uhhRVYHp4x+15fUatdzO5CtTPGNlWvjC0h7dlZfEQ0PpdQ5mQ16GXimqBx6syysDT/o
         7C3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2zjjaR0MJ6NCbQ2tNDKmWvCG8E9amxT1DIK1jQtxlWw=;
        b=ToH/rL/ydG+A2KbczndVmsVTRJCYyOXIKdPI/UDVdBiBp/cQvy55rzr2TzWMzJUh0D
         1BA3mFXvpmEMi9pIRyZy8wyoxu5/Pb2cA+RT2Mupnv6s8Q6KQ7Kp6dVq6iG1SSP+3/S/
         6LZ+v3Aj2u03x6E8sgvegk8cmqZvLMbns4TqAl3XL6PlpjWw+AmQonw58hpj1jcsMdwB
         j5e5D/D3MX+k9J8yAqn3j4FCQPoj0GqecvRcu/WnfrIIvpoyXw6wfE4T6F8X/fH/fUbE
         f1h/t8hbYMRrBtduoW4YCX9SjTjJ+Ebxot85LSw3jED8+WO0E9/OSv+iCZthSbjpSp2n
         CMQw==
X-Gm-Message-State: APjAAAUAhqx3LT61o0u0MJdLLVjV22SE9FTD0RgLxvcaTNdKpEXMv+o3
        ecZn4izDnb+HAYnEX06dwXELwDz4
X-Google-Smtp-Source: APXvYqw62YlR1EtrXXzeQbnx6g/YguesmTJzb5Igqhr+9hIMveLG14XMk/HsXRnfL0X6WG+88W3OnQ==
X-Received: by 2002:a81:55c9:: with SMTP id j192mr63981363ywb.161.1560861115971;
        Tue, 18 Jun 2019 05:31:55 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id l5sm3876361ywf.11.2019.06.18.05.31.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 05:31:54 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id x7so5981812ybg.5
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 05:31:54 -0700 (PDT)
X-Received: by 2002:a25:d9cc:: with SMTP id q195mr59718440ybg.390.1560861113644;
 Tue, 18 Jun 2019 05:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs2+-yeYcx7oe228oo9GfDgTuPL1=TemT3R20tzCmcjsw@mail.gmail.com>
In-Reply-To: <CA+G9fYs2+-yeYcx7oe228oo9GfDgTuPL1=TemT3R20tzCmcjsw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 18 Jun 2019 08:31:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
Message-ID: <CA+FuTSfBFqRViKfG5crEv8xLMgAkp3cZ+yeuELK5TVv61xT=Yw@mail.gmail.com>
Subject: Re: 4.19: udpgso_bench_tx: setsockopt zerocopy: Unknown error 524
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 7:27 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> selftests: net: udpgso_bench.sh failed on 4.19, 4.14, 4.9 and 4.4 branches.
> PASS on stable branch 5.1, mainline and next.
> This failure is started happening on 4.19 and older kernel branches after
> kselftest upgrade to version 5.1

Does version 5.1 here mean running tests from Linux 5.1, against older kernels?

> Is there any possibilities to backport ?
>
> Error:
> udpgso_bench_tx: setsockopt zerocopy: Unknown error 524

MSG_ZEROCOPY for UDP was added in commit b5947e5d1e71 ("udp:
msg_zerocopy") in Linux 5.0.

The selftest was expanded with this feature in commit db63e489c7aa
("selftests: extend zerocopy tests to udp"), also in Linux 5.0.

Those tests are not expected to pass on older kernels.
