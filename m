Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECC16265CB
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 01:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiKLAHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 19:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKLAHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 19:07:13 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30580252B0
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:07:13 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 140so4697403pfz.6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 16:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MSkqSoSGpW7vsl2Ge2ZKxrPL0oSevep68D5QpPhlWmU=;
        b=Wr1p+Qu9NxiPhXS6A6LX1cM+HPlSztD/UsD4JEDRqquqq7Z0D3LykN3AL93uMiKRNB
         wmMUK14+rCqMjo5HUxXXpBk2fsWSptdG0TrfexdfSJ7dz6J50GXXfUCO03DDz62piS9X
         apGF/VHCrwoUXZgr/WAAav3FRYc1v28ALzDYUdFZw7DDUPHFFISfaEvP62ObNLt1rrlF
         VhtZK1Kr2LfcxVaKD+vJ1mRUnxLfg9MS1AAbadTolTOLezbCPMolLIJCLQ3bPurBMUW7
         EbAZiIFk7j+duITgNi6EoTIh5gUN7q7ne83k0T28k/7qwqSvYqcY0OBPKlWy87mQgpVG
         oynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSkqSoSGpW7vsl2Ge2ZKxrPL0oSevep68D5QpPhlWmU=;
        b=R1CjSIR5KvNvds8GC82wRuMoZKgKh0lqdUhubU2mPBuwJJV0KSMC806w2kCErc2GUl
         yNfSVH44gsFOi9u7VEj0aIRHLX8/TxCdd9ow2y+d0Dl2d6w09awCdNRHxfm335loCeqo
         r7Saq1s971RiR70evuVlsgc2uqVd1ee7mfluL+ujO/mDMVPYG0wH3WqiJc9shc8wWlXI
         2x58zTr8vmNYODjJz38eeikebJk77a/97TwYlQCAG3iSjj2u04FIF60HjQISBs9iQaVn
         A4+xGe8RSCaEeY4l21kf+ppyGBwuKUIrPSM+Ww9wHLXuwzsSd98kJCj1BtbdFpMs50Dm
         ArJQ==
X-Gm-Message-State: ANoB5pnIuAhnVzzXfSIzkqJoUVUHEdi8r0LfTTNk2tDrl8CZh5Nq17q1
        AaRzu7RidkGsV2Oxdqum3D2SrYFLsO0MWVrbz5w=
X-Google-Smtp-Source: AA0mqf6kXqmXdfVDP2iyclTAKjz1oHt4hgu46JT4+dXFByYtiVR0DzNU4kCs/LnR5HWy1L00J7rtSkl/ISWShWgkzes=
X-Received: by 2002:a05:6a00:f99:b0:571:8aec:ac4f with SMTP id
 ct25-20020a056a000f9900b005718aecac4fmr4772257pfb.78.1668211632673; Fri, 11
 Nov 2022 16:07:12 -0800 (PST)
MIME-Version: 1.0
References: <20221110124345.3901389-1-festevam@gmail.com> <20221110125322.c436jqyplxuzdvcl@skbuf>
 <CAOMZO5D9shR2WB+83UPOvs-CaRg7rmaZ-USokPu0K+jtvB2EYw@mail.gmail.com> <20221111214127.pzek6eonetzatc4a@skbuf>
In-Reply-To: <20221111214127.pzek6eonetzatc4a@skbuf>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 11 Nov 2022 21:06:57 -0300
Message-ID: <CAOMZO5Ar1ZYwruj7N0w18eihkbe1oSH2VU34uSrpTDvp8o2TzA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow hwstamping on the
 master port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, netdev@vger.kernel.org,
        =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
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

Hi Vladimir,

On Fri, Nov 11, 2022 at 6:41 PM Vladimir Oltean <olteanv@gmail.com> wrote:

> Yeah, this is not what I meant. I posted a patch illustrating what I
> meant here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20221111211020.543540-1-vladimir.oltean@nxp.com/

Thanks for your patch, appreciated.

I tested your patch and it works fine.

Cheers
