Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2024570E66
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiGKXmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGKXmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:42:14 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5BF2B63D;
        Mon, 11 Jul 2022 16:42:13 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e15so8109683edj.2;
        Mon, 11 Jul 2022 16:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=huQyBNaLi+rnS6hPpdKZkF89bhus7inuhiN+hMoHvBQ=;
        b=jxY/JP45BhlQP3lBMxyWEQEllqy3vEWLHl/BHPMe7fWuTRohdf6wV789EFvMz8fIFr
         CRRkuLci2+pUc1YhdDkQpTcyq6peF74XMedvlpbdpcvsWr7+z/+jygiQr3RjHWm27LA6
         42gGkliM2JwIpigwsynlfwwKIoqGX8Bslj1o5eWyO3ZttFFInnLvQSAvykjwkdf1COiJ
         uCAGKU7gQc6zag4a6Gwz+kwAtyG1YC4Ji+JZ54CB8TAYXp6E1IjSWuQm3zes/NqQyBea
         FuwNwGreba8kf1KzXqn8p6UK3xA/LBhvxQAAUF07dbtH/0vqlCyuxNjM6OnNfE/TvZ14
         ZLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=huQyBNaLi+rnS6hPpdKZkF89bhus7inuhiN+hMoHvBQ=;
        b=N/hVbHi51dWlhIS/snYAYOCsqELy1Z9yQIRmbDyH7R+HcF/hr30C4GwrB4pBB8naj3
         /LC3e6zqkVUeDnkM28ToSO5TaLQilW/0KA/26S/l/U8DBto36O2vfvW0rAQlNjbdoru+
         I7zpQ6FG3/Kwc6up0OQKg/H9h2rjySw72mZIcAzGskujgq3NnMknwc9xujxAcD5Ln724
         4ZqlPMSpsDemQsyyiwjl5zkZO99Yi2Yq2k1BjJwZAacClTSi7K1kZ+uf82d/auoIx8XJ
         AOhpOmpYUasHblkxl3vmVmk0JG3CzbOAWPT49ETJlp9bWVV5bk8E6YNV2KZE8eB51+dD
         4Luw==
X-Gm-Message-State: AJIora+EccIhob835XgfNt508SpYk58aPWBz+uGwV8mq1JpQhERjbiwu
        KVsn9peSUFU02DJAuTPealxqV7/MjFXq4fmePwN57C0Le6WqfD3nwfw=
X-Google-Smtp-Source: AGRyM1tADoJ8vpBzLJhYUlDt5dcMRWq3oWM7vQBq9gmCutDrCaff8R/RW16I4Y/5eLa66hNqg/e31QjQzazoy8YuRw8=
X-Received: by 2002:a05:6402:5cb:b0:434:eb48:754f with SMTP id
 n11-20020a05640205cb00b00434eb48754fmr28441808edx.421.1657582931539; Mon, 11
 Jul 2022 16:42:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1657556229.git.jhpark1013@gmail.com>
In-Reply-To: <cover.1657556229.git.jhpark1013@gmail.com>
From:   Jaehee <jhpark1013@gmail.com>
Date:   Mon, 11 Jul 2022 16:42:06 -0700
Message-ID: <CAA1TwFDoA2ZbjAY2Z2hmweJs1bnemSH2SSmj-9AeE74zmqJ8xw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: ipv4/ipv6: new option to accept
 garp/untracked na only if in-network
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, shuah@kernel.org,
        linux-kernel@vger.kernel.org, aajith@arista.com,
        Roopa Prabhu <roopa@nvidia.com>,
        Andy Roulin <aroulin@nvidia.com>,
        Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:51 AM Jaehee Park <jhpark1013@gmail.com> wrote:
>
> The first patch adds an option to learn a neighbor from garp only if
> the src ip is in the same subnet of addresses configured on the
> interface. The option has been added to arp_accept in ipv4.
>
> The same feature has been added to ndisc (patch 2). For ipv6, the
> subnet filtering knob is an extension of the accept_untracked_na
> option introduced in these patches:
> https://lore.kernel.org/all/642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com/t/
> https://lore.kernel.org/netdev/20220530101414.65439-1-aajith@arista.com/T/
>
> The third patch contains selftests for testing the different options
> for accepting arp and neighbor advertisements.
>
> Jaehee Park (3):
>   net: ipv4: new arp_accept option to accept garp only if in-network
>   net: ipv6: new accept_untracked_na option to accept na only if
>     in-network
>   selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and
>     accept_untracked_na
>
>  Documentation/networking/ip-sysctl.rst        |  48 +--
>  include/linux/inetdevice.h                    |   2 +-
>  net/ipv4/arp.c                                |  24 +-
>  net/ipv6/addrconf.c                           |   2 +-
>  net/ipv6/ndisc.c                              |  29 +-
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../net/arp_ndisc_untracked_subnets.sh        | 281 ++++++++++++++++++
>  7 files changed, 360 insertions(+), 27 deletions(-)
>  create mode 100755 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
>
> --
> 2.30.2
>


I forgot a few cleanups. I will post a v2 soon.
Sorry about that!

Thanks,
Jaehee
