Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826A0315312
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 16:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhBIPop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 10:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbhBIPoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 10:44:38 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3437C06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 07:43:57 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e133so19168661iof.8
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 07:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hy5AMyt/1iDdiYBeV3iuNw2opMX/pw0egMrX8pOxXhw=;
        b=CaBOVCbdkdiMy5O+fztAZhk4EjVlVPZJqTgBAbOdsOKR0ODk/UAaA+mRwzcqNUyfUs
         B0SFUKrj47b4CgjoJ4+Ta+TRrUQwj6EtHUNMIQet6Kq/5di5yArA/ogiDHHEkz+zH7Q2
         9tg1kMfms89feyIXuWeD6MUiP0IsZeB98oTWlnmf0jFItuANiDCVnv85uLLCMAlcq/1i
         O+l7rTU2GiXRgcbeOh1SPqZbDB3T7jIt75V0lcHI2USfhjGT4q9JEeXi7q6ggsFGdmL9
         GhYAGDqCuTnVt9CckvebUXc6I1SbsncE3gSNP/pu6h3jI2M+FQpSUb5Yk46C+0Hr7ARs
         I1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hy5AMyt/1iDdiYBeV3iuNw2opMX/pw0egMrX8pOxXhw=;
        b=fJ2MzD4HoZvs9UQfgZ4mM9wpdKHZrKVzJ8PWbzjDuCldenu4XwtUUTz34KpYtzjtUR
         HkWnMKLKiEVghrAIkJtqEgxKzrDhoLnbHEhOhnJvHOmaqn3HEU3dRRAH8OmjgTg0Mva2
         cllaZq9rtm/wOT+WK7WJlE3a/JtClviV8eoegcypx6rkRo8OLEZO/hQt3JWr1lOU3Pe1
         BiuMEmF04EqLwRbcBrqzcJI78e2fTGLEZdJ35awW9eiVXdhJ+MNYrbrtXsELzH/ifICT
         DUqnaMBlJLKzxsha9tTQFoZHHClohUvo3JnA0bceZ5F/rJ+sNucpdjBlYIPCam9/yszT
         cojQ==
X-Gm-Message-State: AOAM531Qnp0YvP8i9CnQ340pIDeeqbEGG5GAbMQGgDu8HhnA9SL01/5c
        e1TX1SFhcqB7f8AA+D66J44zBn09pdBKaeXxHHY=
X-Google-Smtp-Source: ABdhPJwnLQFiZ912pB9EloPC2QbEQlPLJGRrbaKH7f/NdgU6tZ9eId1mQyUTxvSBlwVvbMH+vTVFZ4TwjTSXzPPr0p8=
X-Received: by 2002:a02:7710:: with SMTP id g16mr22789096jac.83.1612885437108;
 Tue, 09 Feb 2021 07:43:57 -0800 (PST)
MIME-Version: 1.0
References: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1612849958-25923-1-git-send-email-rahul.lakkireddy@chelsio.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 9 Feb 2021 07:43:46 -0800
Message-ID: <CAKgT0Uc=48siEFQ0kEx9mCzriZ1Dd1OuYkUXFimHpgSbkSUUHg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] cxgb4: collect serial config version from register
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 10:10 PM Rahul Lakkireddy
<rahul.lakkireddy@chelsio.com> wrote:
>
> Collect serial config version information directly from an internal
> register, instead of explicitly resizing VPD.
>
> v2:
> - Add comments on info stored in PCIE_STATIC_SPARE2 register.
>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> ---
>  .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  3 ---
>  .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 24 +++----------------
>  drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |  6 +++++
>  3 files changed, 9 insertions(+), 24 deletions(-)
>

Looks good.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
