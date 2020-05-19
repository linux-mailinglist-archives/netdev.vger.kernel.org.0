Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E037D1DA509
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgESWyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgESWyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:54:03 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C37C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:54:03 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f83so1647788qke.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MtweFRV6F2gcMWELMZaS0mKyVw4wDA/C6Il3Hj6EF/g=;
        b=O7mmn9YQB65a3UeBxmOiCHY0tzz0yMUzxioCyT6LAhMmK3ASdShwGi+CSQWUWip3ej
         wJ8wQsXlc32l2E8JeQuSjN67TX2qVGZjGIgSM1sYxCPgVfrJR1LQOB76pSzPIrjheg+4
         V13Z1tBTH3Ed7n1Qi4mVUNMPMbH18fT0GqMOSGbjFmurTGShwGEkXyMTidDf83vbeyIA
         U5nkSlqg5IQLd37N0awDFOzbIM1zeE+kLlo38rqiRJ909nhr6FiS/PrrVfxNs53XnLZg
         K6/KcTgxt55F9rs2U1qqwhx8ymtlVs5E1QsRDbuFi/EhAWa8HneqhPFq9jaTB/kt35yn
         y8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MtweFRV6F2gcMWELMZaS0mKyVw4wDA/C6Il3Hj6EF/g=;
        b=EZjuTKUAYLvVCTVgd7YKalfoEavLptlTLgWZgqLJiGqoPjeGKHaX6ip7x5EOmlAfSh
         1DC9vf4nYNElx9kxME6PI3RHxChJ3zM4QM8ZJ8nWr53cSDM2syGeG/bEgAYeNTyfUGeU
         9qqx0lj7hWSFcYmB2mQnuLocaR9ClTYlWyVC9Il+68gBuMdokRzbXYuwZLQd4kQ6Ms3f
         IP0MULSYvtQk+ZQU6oy9cNzRg4YJZ8uexzmL4RN/6umGPZuzHN4VKTllrbptxm248tWa
         wmGBJP0NPt9cBsMDkOsGQrvDTej5DSvddEX64YBYNVAh5tK0+ZBvqRZ2CAhZa/6CX1qb
         sEUg==
X-Gm-Message-State: AOAM531wZPFjO4U9rlw3uxD5LKNljNgP76uQ97+rNlBgMCkMExGFBorQ
        yG6HhrXPUhA1kWLOD4rdRLay6BErPESMTN60yGv/dg==
X-Google-Smtp-Source: ABdhPJxmKF2Hm2N8jlEFp7eZhK4TnJiEIY/gEpTCDn0ffXBqt6Z7yipajPyC5N3KviNkL3XBdS2vNOrCuXGRhZv64O0=
X-Received: by 2002:a25:6f86:: with SMTP id k128mr2699985ybc.520.1589928842512;
 Tue, 19 May 2020 15:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200519225012.159597-1-edumazet@google.com> <20200519.155305.1235405039792201660.davem@davemloft.net>
In-Reply-To: <20200519.155305.1235405039792201660.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 19 May 2020 15:53:51 -0700
Message-ID: <CANn89iLBjDj4aOxUgnkyOfT2SwYXEzL3ZXpfG4voSALejUtfXQ@mail.gmail.com>
Subject: Re: [PATCH net] net: unexport skb_gro_receive()
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 3:53 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Tue, 19 May 2020 15:50:12 -0700
>
> > skb_gro_receive() used to be used by SCTP, it is no longer the case.
> >
> > skb_gro_receive_list() is in the same category : never used from modules.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Maybe this is net-next material instead?

Sure thing !
