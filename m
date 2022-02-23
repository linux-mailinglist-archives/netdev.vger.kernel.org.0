Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30F44C1AC3
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243820AbiBWSSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiBWSRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:17:22 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F1E3F8A2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 10:16:53 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 29so16213223ljv.10
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 10:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73wDL/GVoaOR1Kvn57Br6Uw6XSipJJuyAsdU60NF+pw=;
        b=MXZnSysa/tiLB503dmDCFGagyhcoYgqb0vIUpyRFKvQVqOoeevSvUDk4MeqJ5Ent0f
         rC1lJxQQq0ubL4zg2d0mEpERBNMtSqWMVVUAyY1jut/y1twBRe/kozRN4KTOYHkgXY/Z
         ugMa5SlzanD3UYKxcgRKCT/7EoXtdgfGcXuSY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73wDL/GVoaOR1Kvn57Br6Uw6XSipJJuyAsdU60NF+pw=;
        b=Sx0dDqEALKav5mCfPur/DbUae925AsgeciCJ7r1bzg1FguHS6gwBWt4HkjdgILj7r2
         nGUG3griJJI+Y7HdmHLTIIf8d9+OP0Ux1HCkYCXzxF97NvOYNpxRPNA6XKurtcDK5s9x
         e9hpHyIgx4pNU5aTPCAhpJVidGGtGz7oglsCfSciV+wdxl+PvJtmfXQevvIcgaKvW35w
         qE1T03O9PvZtvBnd4IRba4Qz1MWU9YPn0g5BWrMF4X6prlvZ/qQW6/TDBJRCUN2th4SM
         UtrPJtszsRo1/DGnq1dolb08waONDAeehBlODmTVP17/4lSBihqhuqv8svU0P2QBhw2o
         AWJQ==
X-Gm-Message-State: AOAM533PkSArJU0Orizr/k5VTq+8NF4Scw63dwds0cwDTowEAQxZt9WL
        QvnLUy1WrCcyITLtBnQOo6Wi/oRHmitxU/fwa69yoA==
X-Google-Smtp-Source: ABdhPJx0EVmmw+N7ED1589E3w2CYdrLjdKkkNathexe+eFM/LW5CF40GsGD3Aq4VDn4UKUgJ7StNwvheeyYCNwMnSig=
X-Received: by 2002:a2e:a37c:0:b0:246:2ce9:5744 with SMTP id
 i28-20020a2ea37c000000b002462ce95744mr450725ljn.76.1645640211670; Wed, 23 Feb
 2022 10:16:51 -0800 (PST)
MIME-Version: 1.0
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
 <1645574424-60857-2-git-send-email-jdamato@fastly.com> <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
 <CALALjgwqLhTe8zFPugbW7XcMqnhRTKevv-zuVY+CWOjSYTLQRQ@mail.gmail.com>
 <20220223094010.326b0a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALALjgwm9LpmnT+2kXNvv-aDiyrWWjMO=j0BBmZd4Qh4wQQXhg@mail.gmail.com> <7a2d23b2-5a7d-d68e-1ae4-13f114c5a380@redhat.com>
In-Reply-To: <7a2d23b2-5a7d-d68e-1ae4-13f114c5a380@redhat.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Wed, 23 Feb 2022 10:16:40 -0800
Message-ID: <CALALjgx1Tn2KNXPKhzbdeFuUt+V10TePr093JiBDFERFqRPWNA@mail.gmail.com>
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, brouer@redhat.com,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, hawk@kernel.org, saeed@kernel.org,
        ttoukan.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 10:10 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 23/02/2022 18.45, Joe Damato wrote:
> > On Wed, Feb 23, 2022 at 9:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Wed, 23 Feb 2022 09:05:06 -0800 Joe Damato wrote:
> >>> Are the cache-line placement and per-cpu designations the only
> >>> remaining issues with this change?
> >>
> >> page_pool_get_stats() has no callers as is, I'm not sure how we can
> >> merge it in current form.
> >>
> >> Maybe I'm missing bigger picture or some former discussion.
> >
> > I wrote the mlx5 code to call this function and export the data via
> > ethtool. I had assumed the mlx5 changes should be in a separate
> > patchset. I can include that code as part of this change, if needed.
>
> I agree with Jakub we need to see how this is used by drivers.

OK. I'll include the mlx5 code which uses this API in the v7.
