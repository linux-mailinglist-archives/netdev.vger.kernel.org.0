Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8226CA984
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjC0PsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjC0PsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:48:10 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2D19C
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:48:04 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-17aaa51a911so9703632fac.5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1679932084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjhAbXfLwMD4fZvY33c8F1cyy9GpcEGUAmxuGqRe4Aw=;
        b=AYeTP5UAdC0YDNqxbhv5yKuh1bqqzfuhNGjaekZjTEfnVLLd9+0VaUjeXcyEtYevbv
         e2o4lB14y0mxUJr//Txv9iKZooKSc0fzqnGhTTqxxkfi/4iwWNgn1bn8c8C034JWzmNy
         jy67Do7ja1yJDQdEzsA6NmvC8Dz5ztQD8AgVnAfsa9pG9251lyf79m+Gg1svCdHNKEzv
         nMCeZ2QKeIBXjZR3ei5IT/cSNq/9/Fs4z1FUtDGQpoHFWuqVNxOpHefhLcBVTul3ppQu
         pj+T07c0MLPDSKT7IhykMXbyYsy7+TZd5oEe9cbx6xymUzgpkwoWHa2JSqjZjtxfLT4u
         eYsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679932084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjhAbXfLwMD4fZvY33c8F1cyy9GpcEGUAmxuGqRe4Aw=;
        b=kUfB8ZIBPwiQq3JYi4dLKasDep8pRXAEZfElcNbf9Aom0ax2BjonnGg5+iOtC4Cb7m
         3Wx9hYWo1NACtW7GXauZq93oiCauhXKOslBhmX2KaLOoXfF1ZgsUCLkxpxV8nGpDA3QW
         2Tluyiuda+lxzH7bl4F6UvRs6FA7nmODzLrcJmOBLf1Mpi7wv7uYhGCVjuIxJ+Fjl9lt
         2UNiZM1ArSFXjTMUErckXqgho1Z/3YAoM+90nKY13i3rW4xL42XFRMD7Ad7onXDKm0Gz
         E4aVSiWdHGhxhm1baf/A0AWLlUbOjjeT2WLZxmqQXa4obiXDkn194M1fN7Ha1m22Ev0J
         K7ew==
X-Gm-Message-State: AAQBX9fxuV+hW/T1VY2U9KwmESRrPe9tQCiBHgtiiqxOpJNv2kKIo38j
        FQ2nAeoAQLcy7+jPkBo/jdBoB4GjRIXM/OfiEXR9Eg==
X-Google-Smtp-Source: AKy350YcFFBKlNWaKINEZi9C42Be9emLrpW9aO7vwCoPxPxTvlgfWLVvQolA5PNce6iZXR/sm/EQeq7quVMhDFS7UeU=
X-Received: by 2002:a05:687c:10b:b0:177:b393:4007 with SMTP id
 ym11-20020a05687c010b00b00177b3934007mr3845925oab.0.1679932083764; Mon, 27
 Mar 2023 08:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230325164029.3lmv4yikyei6yst6@Svens-MacBookPro.local>
In-Reply-To: <20230325164029.3lmv4yikyei6yst6@Svens-MacBookPro.local>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 27 Mar 2023 17:47:52 +0200
Message-ID: <CAPv3WKd4=ANVHDfrgu4_OHm9em3ZSHCk5rvLMdQhRLrd65uYKg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] net: mvpp2: classifier flow fix fragmentation flags
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, kuba@kernel.org,
        davem@davemloft.net, maxime.chevallier@bootlin.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sob., 25 mar 2023 o 17:40 Sven Auhagen <sven.auhagen@voleatech.de> napisa=
=C5=82(a):
>
> Add missing IP Fragmentation Flag.
>
> Fixes: f9358e12a0af ("net: mvpp2: split ingress traffic into multiple flo=
ws")
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>
> Change from v2:
>         * Formal fixes
>
> Change from v1:
>         * Added the fixes tag
>         * Drop the MVPP22_CLS_HEK_TAGGED change from the patch
>
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net=
/ethernet/marvell/mvpp2/mvpp2_cls.c
> index 41d935d1aaf6..40aeaa7bd739 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
> @@ -62,35 +62,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_=
PRS_FLOWS] =3D {
>         MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
>                        MVPP22_CLS_HEK_IP4_2T,
>                        MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
> -                      MVPP2_PRS_RI_L4_TCP,
> +                      MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
>                        MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
>                        MVPP22_CLS_HEK_IP4_2T,
>                        MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
> -                      MVPP2_PRS_RI_L4_TCP,
> +                      MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
>                        MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_UNTAG,
>                        MVPP22_CLS_HEK_IP4_2T,
>                        MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER=
 |
> -                      MVPP2_PRS_RI_L4_TCP,
> +                      MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_TCP,
>                        MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>
>         /* TCP over IPv4 flows, fragmented, with vlan tag */
>         MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
>                        MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -                      MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
> +                      MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
> +                          MVPP2_PRS_RI_L4_TCP,
>                        MVPP2_PRS_IP_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
>                        MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -                      MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
> +                      MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRU=
E |
> +                          MVPP2_PRS_RI_L4_TCP,
>                        MVPP2_PRS_IP_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
>                        MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -                      MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
> +                      MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_T=
RUE |
> +                          MVPP2_PRS_RI_L4_TCP,
>                        MVPP2_PRS_IP_MASK),
>
>         /* UDP over IPv4 flows, Not fragmented, no vlan tag */
> @@ -132,35 +135,38 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_=
N_PRS_FLOWS] =3D {
>         MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
>                        MVPP22_CLS_HEK_IP4_2T,
>                        MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4 |
> -                      MVPP2_PRS_RI_L4_UDP,
> +                      MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
>                        MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
>                        MVPP22_CLS_HEK_IP4_2T,
>                        MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OPT |
> -                      MVPP2_PRS_RI_L4_UDP,
> +                      MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
>                        MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_UNTAG,
>                        MVPP22_CLS_HEK_IP4_2T,
>                        MVPP2_PRS_RI_VLAN_NONE | MVPP2_PRS_RI_L3_IP4_OTHER=
 |
> -                      MVPP2_PRS_RI_L4_UDP,
> +                      MVPP2_PRS_RI_IP_FRAG_TRUE | MVPP2_PRS_RI_L4_UDP,
>                        MVPP2_PRS_IP_MASK | MVPP2_PRS_RI_VLAN_MASK),
>
>         /* UDP over IPv4 flows, fragmented, with vlan tag */
>         MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
>                        MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -                      MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
> +                      MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_IP_FRAG_TRUE |
> +                          MVPP2_PRS_RI_L4_UDP,
>                        MVPP2_PRS_IP_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
>                        MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -                      MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
> +                      MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_IP_FRAG_TRU=
E |
> +                          MVPP2_PRS_RI_L4_UDP,
>                        MVPP2_PRS_IP_MASK),
>
>         MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
>                        MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
> -                      MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
> +                      MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_IP_FRAG_T=
RUE |
> +                          MVPP2_PRS_RI_L4_UDP,
>                        MVPP2_PRS_IP_MASK),
>
>         /* TCP over IPv6 flows, not fragmented, no vlan tag */
> --
> 2.33.1
>

Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
