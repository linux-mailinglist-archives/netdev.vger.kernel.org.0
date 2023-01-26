Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07367D1E6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjAZQkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjAZQkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:40:32 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08DB4483;
        Thu, 26 Jan 2023 08:40:31 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id s67so1416619pgs.3;
        Thu, 26 Jan 2023 08:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Zsu1XXuoF2/96aeBfEHXZNf0ZiITGZdQYd8L9imSFJM=;
        b=G2DhB6J50kohw6MFhszVAkdEzfccit7sgqjhotiBJBmbBC5Rben9zQqn7AkvpSOONC
         ZmwdNFrBFeY6t67lZ8Z3DEWfCpLc1v3JY1SYQR1hyl5c5UXYdftgi51UrlwIA+g8k4rb
         Uqn7e8+KvSI29Sii9OK/ek5+NB0ANTzRj/dz0rymJvS1VcnCSnYziAeh407uVfMiBkFv
         tt+ggp3nhpuSkL0v4WqLZo3+zVYP2/ZnwOXl6+oSoOouDSZxkFgVTqT/QQdvZzmajcYl
         KjQTgHq2h5eenl/tWx5TXH7yq9hOWqbwDf5Qmc8ursfwWn3ehVfgzC0G0Bc1e+uJTYd9
         EMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zsu1XXuoF2/96aeBfEHXZNf0ZiITGZdQYd8L9imSFJM=;
        b=JeJ/Dd4qK2T3v2u5K4gWmJJpJl7fSS6fK9QNdndUhjo99iRwTFXAcZLqjCDWhaxxLW
         F0aaDecAaiWs9Rx2fEeayPrE+D4J4mdp+0vzmap/f+1qG35BnstRXmQiPGX/CGjy3Mkp
         N/NV1qwK+2cBIHnO4sHQztNZH2FPkPwMlYAoaRVzht+cIrEo8/ERH269j7m9Xp3eH8nt
         nN27NJlMgHFJLUMbcps+0eWNZcMxm0Sy6z7twV2X5Hn/8G8+JnoKzdEm/Hlmz6nfRzVR
         UT9VrZOd3Is84bwISbGSxN+9ffvKmITyK/tSzUuEKPMP3ebSRaDSE03DJ1m7sWiP9BqZ
         otrQ==
X-Gm-Message-State: AFqh2krXl4uOC+GoiHwYa6jcqzQHAaO947bmUOxoYvZDbD45Kqb4OT2X
        +8TZ7k4X3y2e43DHEA+sKnAjc2hBXge+TPf51fI=
X-Google-Smtp-Source: AMrXdXtXMPrQNDhCGq+W1jMAH/lYgZoI1xz+u0p+Ha+FNVeDDc/1UrGzG7S35E2P47oA1JasBEWiaxsV60Utpfl3OAI=
X-Received: by 2002:aa7:8b57:0:b0:589:1130:d3ce with SMTP id
 i23-20020aa78b57000000b005891130d3cemr4555176pfd.66.1674751231260; Thu, 26
 Jan 2023 08:40:31 -0800 (PST)
MIME-Version: 1.0
References: <20230124124300.94886-1-nbd@nbd.name> <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
 <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name> <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
 <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name> <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
 <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name> <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
 <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name> <a0b43a978ae43064777d9d240ef38b3567f58e5a.camel@gmail.com>
 <9992e7b5-7f2b-b79d-9c48-cf689807f185@nbd.name> <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
 <148028e75d720091caa56e8b0a89544723fda47e.camel@gmail.com>
 <8ec239d3-a005-8609-0724-f1042659791e@nbd.name> <8a331165-4435-4c2d-70e0-20655019dc51@nbd.name>
 <CAKgT0Ud8npNtncH-KbMtj_R=UZ=aFA9T8U=TZoLG_94eVUxKPA@mail.gmail.com>
In-Reply-To: <CAKgT0Ud8npNtncH-KbMtj_R=UZ=aFA9T8U=TZoLG_94eVUxKPA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 26 Jan 2023 08:40:19 -0800
Message-ID: <CAKgT0Uc88xF5AjEhpBnr7m_+gnH5WVAoJFC=AVEPY0+qN1BNsQ@mail.gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented allocation
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
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

?

On Thu, Jan 26, 2023 at 8:08 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Thu, Jan 26, 2023 at 1:15 AM Felix Fietkau <nbd@nbd.name> wrote:
> >

...

> > - if I return false in skb_try_coalesce, it still crashes:
> > https://nbd.name/p/18cac078
>
> Yeah, I wasn't suspecting skb_try_coalesce since we have exercised the
> code. My thought was something like the function you mentioned above
> plus cloning or something else.

One question I would have. Is GRO happening after the call to
ieee80211_amsdu_to_8023s? If so we might want to try switching that
off to see if it might be aggregating page pool frames and non-page
pool frames together.
