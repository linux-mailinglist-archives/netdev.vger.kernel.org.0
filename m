Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C054DC25D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiCQJNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiCQJNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:13:54 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7B5E728B
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:12:38 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g6-20020a9d6486000000b005acf9a0b644so3091616otl.12
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OOcPrm7+1BaiB6IY26qx5qjC3P9Q5mgK5BYX6RsuHGM=;
        b=PQ+asg6xmOOOTHaNKQcg1OSvpvw3SmKnuBDzqDr+o3LSYh49vgC2PL9PcCS3n6KLfO
         6gTJo/F11c0GB1qG8lKTv2q7RPPLbQtxIjYcmGHKtOEbOGYJVbl/TsdnEUd1Jhp/AYxs
         Fv+Ku41xF6wVEebkd2VdLnDL/PtXFBUQEr0YwD2vI66i/pKqTGvqBKP8//rtcR7yyL5C
         zBGOcjWAAIU+fMn1DSi33o7DQj8So60Se/K1SauVrjjK3dcs5twS8DInS51WcvJ8+oaQ
         sqNZe/RXPVT+rZlKcN7IX7bLowJjwSbSfnY8eFlTE43pcUwDm+KS85Bu2Hry7HrzHtet
         OFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OOcPrm7+1BaiB6IY26qx5qjC3P9Q5mgK5BYX6RsuHGM=;
        b=Eb3BCzWIEVMWIgVhE3st6iJC+nn+4utTbkHfiqDGT/DdieHp+ascWHtIjodiPwMOPz
         FT9Bttbt8SFlTibIsUbmG/fUMV/YibY8FVMpEHrxPJznrtfqwwvDo7s2G84d0KDewn5b
         +nzZd2XkKv5s/LF7d1dKKdYAKgihkmoy+IaMO/mCaC08bJj8sSYAbSlflXORYJCZKV7j
         bzlBFXZgGxk2fbglWzD2wzZHHBeQgQM49VLkBjXr8IND5EQLQ8m6Igy7/pEqgY0p6qeO
         0tAoA+gFRKgfaSbaRigYCF2W+64gHqav98lRjVtBYkP5UC6/JS4xC+/EKS/q+BPiXgsy
         MQeg==
X-Gm-Message-State: AOAM532gpgvHUphUtMALv6DueIZ35gvU5FD7Yt6QvnKaOUEEL+5xqKwe
        +Lo8drQrBFz3Q+Zd+jQ2wvzWG/Dhz6zokeA7I4m6cA==
X-Google-Smtp-Source: ABdhPJwkYR/5ItOquqx2su2atvvNFklEK++1KNTM3IQ59TFr6K3nHoKR7RrfD/L/D0a9NIW10E05CLyU3atWkh1naUQ=
X-Received: by 2002:a05:6830:1b78:b0:5c9:48b3:8ab with SMTP id
 d24-20020a0568301b7800b005c948b308abmr1241746ote.235.1647508358212; Thu, 17
 Mar 2022 02:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220316075953.61398-1-andy.chiu@sifive.com> <fc427c42d37489935c5f71acf02860904f6150dc.camel@calian.com>
In-Reply-To: <fc427c42d37489935c5f71acf02860904f6150dc.camel@calian.com>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Thu, 17 Mar 2022 17:10:40 +0800
Message-ID: <CABgGipV6ezNqtaf_aP1fYcwHVOKJQS9oNahu48L1Q6-+cWrwLw@mail.gmail.com>
Subject: Re: [PATCH] net: axiemac: use a phandle to reference pcs_phy
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the kind help and suggestions.

I will submit the v2 patchset with an updated flow that supports both
cases, and include a binding document. And use the correct mail
address.

Regards,
Andy

On Thu, Mar 17, 2022 at 5:15 AM Robert Hancock
<robert.hancock@calian.com> wrote:
>
> Re: https://lore.kernel.org/all/20220316075953.61398-1-andy.chiu@sifive.com/
> (looks like I was CCed with the wrong email):
>
> I think we likely need something similar to this for the use case (I assume)
> you have, where there's an external SGMII PHY as well as the internal PCS/PMA
> PHY which both need to be configured. However, we (and possibly others) already
> have some cases where the core is connected to an SFP cage, phy-handle points
> to the internal PCS/PMA PHY, and the external PHY - if one exists at all - is
> not in the device tree because it would be on an SFP module.
>
> Also, as Jakub mentioned, it looks like other drivers like dpaa2 use pcs-handle
> for this.
>
> Possibly something like: in the 1000Base-X or SGMII modes, if pcs-handle is
> set, then use that as the PCS node, otherwise fall back to assuming phy-handle
> points to the PCS. It should not require that both are present, since even in
> the pure SGMII case, the PHY could still be supplied by an SFP module
> downstream.
>
> --
> Robert Hancock
> Senior Hardware Designer, Calian Advanced Technologies
> www.calian.com
