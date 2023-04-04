Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4041F6D6EC9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 23:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbjDDVTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 17:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236442AbjDDVSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 17:18:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F404F19BC;
        Tue,  4 Apr 2023 14:18:32 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id ek18so136118590edb.6;
        Tue, 04 Apr 2023 14:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680643111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5EuWHbwdKEeX6a2AZ9C4RTkT1vujytrUzBt+0O0v3M=;
        b=BSXijNbZJBXiMzykKh9QRkhLXFK6izNgWu+k0ocaV1CceHyXMI0uOy5rdcziqYvFbF
         OYcGiiIVlIsZVibw9dKrakGQcKvTmg3aFIdX5pwLXe/wNBO1qAyoY38icHP8bA4QA2Ok
         eAV0nm+Q+R0Cj897TespCICHugQbjPBztEWmFc80+KrrIaLrvphirsz2Hqrwvm2hw8k3
         sKvYwITZz8mQfX4dmjry87ipHywHWXsonh3vXKZJW+yfg2dRIVbhuLKtGyLn2ZkJvFcy
         qCqWIw2TVkaXxK89SwPji2nm4YVXePUFJi5W5noK+GlgvlSB+9tf+f02+OgczQzRwwZB
         JJCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5EuWHbwdKEeX6a2AZ9C4RTkT1vujytrUzBt+0O0v3M=;
        b=Koib8eZMUmB1VNTRMUV4jynD50RknFQre/OgVMyxkC9+S2Ms+qvulwQWBKObEJTOsH
         5Z0by3mi3VOKvBK024KVCPYwLyrKt0PGWlHYNB7iBY5aQ5lsj7QO2upFT3o7ool428QU
         7rc0NGOuJofq1SOqTlHGRlwmxB296aWYu1WFuU46PwEHS4X+32o/q9HGTu96Fzi+k7YB
         DTm6tDqw0ZuJ3mCaY/X1atG6B1mNRbPYd1kvMbwItXPwKDno0jdIINhaMnOGMDZWhnII
         bQ9ff16tornttdg8iO5W9afcHLXikwZ/oBpD4JcWi7Ci3CYF9rrW+dHquYokE5eyEw/l
         uUlQ==
X-Gm-Message-State: AAQBX9dYDDijULuFk46aoroO0OibSAY6mbBrc2Xd1s4xw8F0EN0I4U+T
        IuheXFzEwKqyKaKcyNLvW0A22KPlvk0029TK6kk=
X-Google-Smtp-Source: AKy350bHAXCKtxXDYnrXHt+8nlQqZKE9To9ryn9MAf9sz41QNTGUz5+aTiDSXZhU533fiWr5/jy5JXzsVw31iqiq4Gg=
X-Received: by 2002:a17:906:b6cd:b0:8b1:cd2e:177a with SMTP id
 ec13-20020a170906b6cd00b008b1cd2e177amr485125ejb.6.1680643110980; Tue, 04 Apr
 2023 14:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20230404091442.3540092-1-michael.wei.hong.sit@intel.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 4 Apr 2023 23:18:20 +0200
Message-ID: <CAFBinCBqsrRZbjFOe8p3e2AzgV9jqL4Qo5db6vBBmak2jqk0_A@mail.gmail.com>
Subject: Re: [RFC net 1/1] net: stmmac: skip PHY scanning when PHY already
 attached in DT mode
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 11:15=E2=80=AFAM Michael Sit Wei Hong
<michael.wei.hong.sit@intel.com> wrote:
>
> If PHY is successfully attached during phylink_fwnode_phy_connect()
> in DT mode. MAC should not need to scan for PHY again.
>
> Adding a logic to check if ovr_an_inband is set before scanning for
> a PHY, since phylink_fwnode_phy_connect() returns 0 when
>
>         phy_fwnode =3D fwnode_get_phy_node(fwnode);
>         if (IS_ERR(phy_fwnode)) {
>                 if (pl->cfg_link_an_mode =3D=3D MLO_AN_PHY)
>                         return -ENODEV;
>                 return 0;
>         }
>
> Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY"=
)
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Thank you for working on this! Your patch fixes the issue I reported,
Ethernet is back on my X96 Air so this patch is:
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

My understanding is that Russell King is asking for a second iteration
of this patch with his feedback incorporated. I'm happy to test this
second version as well if you keep me Cc'ed.
For this second version you can also (unconditionally) add:
Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>


Best regards,
Martin
