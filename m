Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737823C7BBA
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 04:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhGNC1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 22:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237422AbhGNC1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 22:27:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98345C0613DD;
        Tue, 13 Jul 2021 19:24:31 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h2so965288edt.3;
        Tue, 13 Jul 2021 19:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xIRCf2+dkLK5/B4kVvO1NnIiKozWSuAMYOOSSKMhOFE=;
        b=AoddE8ZsiCEvSYYUzUXWkS+7kruOL0EVvBDV7+Yr9mXgpts5XNh9SG9ydJc1sftSYh
         i0bMsQamtfkDBTGHj+Rw8/5q2sLO7ldviCRWDx1jMw80SEd4Dn0QM5oKluOd4oCMmP/+
         mpTycrgEvqBMh8UBXnruIW635b+nU/lPELORa9bFNE7Y7+mwatN6InZcoxX/5hNbSBSw
         vjtk6ibL4hxAXvelpSLDPUSiIULD5ew6VSEa86uBt0TKom1ltmWAmjas+ysSLNFUQQZB
         XBXDEN/+NFCDQ0lWahRZxdma8jKPVEMWBtdgtzmcM4qjfSQNM6AxVDk1njz5XWy7vr1B
         mVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xIRCf2+dkLK5/B4kVvO1NnIiKozWSuAMYOOSSKMhOFE=;
        b=A4QLwLcHH8kYCp7zRkI+dHtmRmpv8qxLGXS1c6GIYynDR5rppbYdBSabULGkewK/F1
         Jo9VcosaBZuuJCwkiojzA9TM6suaqHScOF7n9M/OqzOiPKtmanc6edyS1O0vVR+ktMQN
         gX+gSqW6+ElGcaey5E41ood31gyY9xjWy3Wb0uTQDyGl0wpUuoVJ0tYUqFHNihxgaa/A
         RAOVH/wG/8EteZXsFSUxvkOcmKUv6sS+Km0CqNGyjqbxUEm6M6TAUaDeNwzx54vDuKYC
         TGPsOZYo1po8PAT3U+Zgcu/oWC7KTqiTf7Wd82DO638HpHJEUzKfiWyxvg6zcb9Hb+DX
         hiQg==
X-Gm-Message-State: AOAM531xCsozuLZATb0VRkairntkVCLQ5ji84OS53P1wxxrrcSl1eoWs
        rXJ9JqV05eu625fKLgf8YKzmSirvhssHli8+bo4=
X-Google-Smtp-Source: ABdhPJz0+lA29ScaqgPQp3jxxE+/cjFx2y81DS7sl/Whk8Ix+51QXNlfiByuzy5xTnjkPhOqmEEfarSW9kEe0IDvXXE=
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr10082121edd.174.1626229470044;
 Tue, 13 Jul 2021 19:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210713122028.463450-1-mudongliangabcd@gmail.com> <58d854d9-a371-7689-d396-de1c26b34bfa@pensando.io>
In-Reply-To: <58d854d9-a371-7689-d396-de1c26b34bfa@pensando.io>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 14 Jul 2021 10:24:04 +0800
Message-ID: <CAD-N9QXthA5JpsXkchx2rrgqWL6Z82FrVt4zF=ygRW9sYXFamA@mail.gmail.com>
Subject: Re: [PATCH] i40e: Fix error handling code of label err_set_queues
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <shannon.nelson@intel.com>,
        Catherine Sullivan <catherine.sullivan@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 11:16 PM Shannon Nelson <snelson@pensando.io> wrote:
>
> On 7/13/21 5:20 AM, Dongliang Mu wrote:
> > If i40e_up_complete fails in i40e_vsi_open, it goes to err_up_complete.
> > The label err_set_queues has an issue: if the else branch is executed,
> > there is no need to execute i40e_vsi_request_irq.
>
> This is unnecessary: if the else branch is executed then control will
> goto err_setup_rx, skipping over i40e_up_complete().

Oh, yes. Thank you. Please ignore this patch.

>
> sln
>
> >
> > Fix this by adding a condition of i40e_vsi_free_irq.
> >
> > Reported-by: Dongliang Mu (mudongliangabcd@gmail.com)
> > Fixes: 9c04cfcd4aad ("i40e: Fix error handling in i40e_vsi_open")
> > Fixes: c22e3c6c7912 ("i40e: prep vsi_open logic for non-netdev cases")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >   drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > index 861e59a350bd..ae54468c7001 100644
> > --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> > +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> > @@ -8720,7 +8720,8 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
> >   err_up_complete:
> >       i40e_down(vsi);
> >   err_set_queues:
> > -     i40e_vsi_free_irq(vsi);
> > +     if ((vsi->netdev) || (vsi->type == I40E_VSI_FDIR))
> > +             i40e_vsi_free_irq(vsi);
> >   err_setup_rx:
> >       i40e_vsi_free_rx_resources(vsi);
> >   err_setup_tx:
>
