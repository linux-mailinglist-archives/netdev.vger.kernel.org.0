Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500C14ED390
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 07:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiCaFzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 01:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiCaFzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 01:55:44 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FDC62D1
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 22:53:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso1668190pju.1
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 22:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wBAARHcHgzlzlWdiHaCBnvCtRvTi9D3KNQJGVxIXYok=;
        b=MDLnwUYZZ7wpitYZPND+Asf7k38Gf+SIxRUohmf9+477Ym4wwEu2gojLoMCUGrPeix
         KXr1t0gLp32c+NUc7Q15tvka1nhglJ+JZoXnAnIb4FR77goskW3xqnupUeJu2dWnMSly
         vAKAAVX6RUkRlW4V7QKlk2EzozmLobn3RgOjksJEfG0kpAJ+WEx8/OXCagCJUVtuplf2
         1elkj/pgXfeyUTsziAxo0biVopoU0rt1/XIm46hmc/3+UzioyMI93EWGsw4LecTOtCrA
         NlgArPJFQ7buzE8PL1apC3cNg4CmB++2bFyY59/RFoJlkfFOHftXOOP6OG7FSycdoT5K
         KmuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wBAARHcHgzlzlWdiHaCBnvCtRvTi9D3KNQJGVxIXYok=;
        b=He1YrUqhdW3euJnWc8dG7YTEFb09vRtcqS+4Qy9WERAnY3ZzEwPDbkKQfiJC9+hl96
         RPQ0Cam2bs3mqi3uoORzVuBck5+G4w2/CCcn0WLH3MFcxOgwUxi4xGgpPfleR9mfMuT4
         3b4Z3N+53IlGxuMmvdjyeXIJWb4W6QjkSUktXtz9wt5yg7BBz0NfNar1mTEBSWnIApX+
         FvEH2jlQYtw+cvdHHSONRMwjgWMXmWPSd7gAvbtAgNXGVcPbzDsKav5UkdZX5TxeXqJV
         6wbvBEhqtJAJZKVFpE4Jxxs0PrtH/iBU57ofBRQ0RPI0oubExWjwCwxQrU/9JeVqg0G5
         zRtw==
X-Gm-Message-State: AOAM532LpjNxqGRsLYgLT0s9wcsfJap2xnTiZTwJsC502LbYawc7ttH9
        LOApBfk77Se96h4/8eyhahUsi/FftSfxuba8UZg=
X-Google-Smtp-Source: ABdhPJzx9eEh4LWaoAlOCA/aS6CxDTGu/q2Fgp9VOcmYE8I0olOzAXE37MY3uccgh+nxK6QHmU0n/ujB0ahsOYW1nJc=
X-Received: by 2002:a17:902:d2cd:b0:154:38c5:f91d with SMTP id
 n13-20020a170902d2cd00b0015438c5f91dmr3452730plc.59.1648706037269; Wed, 30
 Mar 2022 22:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com> <20220105231117.3219039-4-vladimir.oltean@nxp.com>
In-Reply-To: <20220105231117.3219039-4-vladimir.oltean@nxp.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 31 Mar 2022 02:53:46 -0300
Message-ID: <CAJq09z5PccRNoE8LZ=Ose--zGCVRRGvmp1Lb6NWh7rZHnHjznA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/6] net: dsa: stop updating master MTU from master.c
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I think I found an issue with this patch.

> At present there are two paths for changing the MTU of the DSA master.
>
> The first is:
>
> dsa_tree_setup
> -> dsa_tree_setup_ports
>    -> dsa_port_setup
>       -> dsa_slave_create
>          -> dsa_slave_change_mtu
>             -> dev_set_mtu(master)

The first code from dsa_slave_change_mtu() is:

        if (!ds->ops->port_change_mtu)
               return -EOPNOTSUPP;

So, when the switch does not implement ds->ops->port_change_mtu, the
master MTU will never be updated. This is the case for
drivers/net/dsa/realtek/rtl8365mb.c. Before this patch,
ops->port_change_mtu was optional. We either need to turn it into a
mandatory function (even if it is a no-op that fails when mtu is
different) or change the dsa_slave_change_mtu to only return
-EOPNOTSUPP when the new slave MTU differs from current slave MTU.

Regards,

Luiz
