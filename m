Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6962B265
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiKPEhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiKPEfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:35:13 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08914317C0;
        Tue, 15 Nov 2022 20:35:11 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id f3so9171510pgc.2;
        Tue, 15 Nov 2022 20:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OkDSjRlgYKUaqauXHboC4dqw2EdxTIxbOhDrWsy32O0=;
        b=QVPUVGd1U5hS8Vo5q5E1xABpxtbzSyQmp3UDffHwyaBaHJqTzU7U9u3NPAUNj619r0
         8lV4n3ylXhHYGBpeDquoEOq2f+nswbBVc2SqFWFLTezjKdjMCDjXQggBWlvYZLUu7YAk
         RfKSBmJRurcgLGl7Rw5Ps++zgEo6SOcZ9xLonR7DO9/seVNDZOxlUd/mHHg1GPn8ABIM
         Z2anpYnjD+bpAa/w4Z/KC3H7sl50mnGVh3T3rrhkTlg9v1Kp8VyDoxSBbLmgIQHNm0rq
         C4qbYedx68XqfwlSX6QuA/N/6Wc+3eqvkPGKXkuPC4kvfXsyhwviqKrjLmhleU7ELEwC
         qB5g==
X-Gm-Message-State: ANoB5pkpoZk/FMuemdFx7pvWE+u5/kO8kabn7fkfxWTI0vBlujCK/S05
        t8kH0eExjzmg17aPzPc8PLbNf93/MKqDgs8z32XHHrEXa7ElLg==
X-Google-Smtp-Source: AA0mqf4rk3DvyKaONbvhMiFnUwzYmAE5+F5Luiuu2z7bwtUxej+1bV4AfI/f0WiQBOdZHWtEzvDeVXm6QAs4FSyxuyY=
X-Received: by 2002:aa7:880d:0:b0:562:3411:cb3a with SMTP id
 c13-20020aa7880d000000b005623411cb3amr21734674pfo.60.1668573310469; Tue, 15
 Nov 2022 20:35:10 -0800 (PST)
MIME-Version: 1.0
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
 <20221113083404.86983-1-mailhol.vincent@wanadoo.fr> <20221114212718.76bd6c8b@kernel.org>
 <CAMZ6RqJ-2_ymLiGuObmBLRDpNNy0ZpMCeRU2qgNPvq2oArnX8A@mail.gmail.com>
 <20221115082830.61fffeab@kernel.org> <CAMZ6Rq+Vdbt0rGwS1zCak4THPk=PY1DPxtUxXmLbvgFnnMmV8w@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+Vdbt0rGwS1zCak4THPk=PY1DPxtUxXmLbvgFnnMmV8w@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 16 Nov 2022 13:34:59 +0900
Message-ID: <CAMZ6Rq+mQ0M9vEE5p3fFhFpay1B3ixQEaqTekine=QNH+k52QA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] ethtool: doc: clarify what drivers can
 implement in their get_drvinfo()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 16 Nov. 2022 at 09:30, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> On Tue. 16 Nov. 2022 at 01:28, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 15 Nov 2022 16:52:39 +0900 Vincent MAILHOL wrote:
> > SG! Good point on the doc being for the struct.

That comment just made me realize that actually, struct ethtool_ops is
also outdated:
https://elixir.bootlin.com/linux/latest/source/include/linux/ethtool.h#L462

Please ignore the v4, I will send another patch to also fix the struct
ethtool_ops doc.


Yours sincerely,
Vincent Mailhol
