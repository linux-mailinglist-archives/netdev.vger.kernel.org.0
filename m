Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B774240575
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 13:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHJLr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 07:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgHJLr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 07:47:58 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A99C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 04:47:58 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g8so7364675wmk.3
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 04:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dcGCiLM2YR8uQhwchg1CXb9gKLrJV3agYXbyePzTpO0=;
        b=ioaLuPsHpHLomOf7kC3vabEDcL48JrX75eLoZg0JJY4YxbrZdlSzK/8xx6atCiMzVz
         X4hZ/k2KukB2PvMlU+G3RZ1RkZtZkgL45sjUAIco+QK0Pz9P5qI2h1UAqZ2M3A4E0zM1
         uO+uW1k3zNbHIFoeKULpt1AXEw/VjfUuMxrkmNzKyMVlDOGViDlUAe+dyUZqka3BtbcF
         jzmvc6cs3UiM9C+MZy23bcR4bMnMorxYConVV8rHw3+I34SBQhzLoI8PeEjmlMRxWkwq
         rZ0DZJEkYacc5ou5g97xa+PsHHLtCUMd+rtiyo9JRTqxHlcx3tVKFxtEFHXGxTEOj4hM
         Ky5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dcGCiLM2YR8uQhwchg1CXb9gKLrJV3agYXbyePzTpO0=;
        b=BtqpBVrP7n+s7233wUEbTfeAdixOOSziPdFAsd5aXirkCTo99JsNnyyeyk12T+0mrR
         wmTcYKCTBjJK82b3JT8zBD6+JK4xayxfXpU9vbt/WqQ4X6NagDrXCrB3hz2JfalCBtMT
         XpRbqC09CTASUtTyGWyFTEulnFslSWWJaQQKalwYP76wjJpPv1gJ8XMcosBER4O/A10h
         29mWUp7zf8GCO2nqiw9uHpXHnoWMjFQRmC+aeNvz5vh9mKk4Uvq152jG7TAJ9nObo7MD
         n4kplkQ/9U253AjSPZ+ziN6Kv0TbI1bvnlD7aziZXXKBA2qr22GtkU9V/2Nir3M9rqeM
         nkow==
X-Gm-Message-State: AOAM53207cT5G7Y1GC8DtARTBv5KmKacwbfk6lS4k0ZSzvZA/W32o+tc
        sHXrAvsfnHwwqxmNbJnl2tz7UDjZVl7dPyI+jI4=
X-Google-Smtp-Source: ABdhPJyBxjb8RlP/L7ckaSW0AqhtcyWQb4E/Vl3NQok9R/8YNm7cIv2fU4rmwdeO5odPvK4i/ugNj+LT9eGb4aVDiK8=
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr25023663wmi.107.1597060077147;
 Mon, 10 Aug 2020 04:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com> <20200728131653.3b90336b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728131653.3b90336b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 10 Aug 2020 13:47:45 +0200
Message-ID: <CAJ+HfNjBCNcb+KO+V0hmSvo2i5L+Cf52F3=-+7TonXkGJ9dXgA@mail.gmail.com>
Subject: Re: [net-next 0/6][pull request] 40GbE Intel Wired LAN Driver Updates 2020-07-28
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, nhorman@redhat.com,
        sassmann@redhat.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 at 22:20, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 28 Jul 2020 12:08:36 -0700 Tony Nguyen wrote:
> > This series contains updates to i40e driver only.
> >
> > Li RongQing removes binding affinity mask to a fixed CPU and sets
> > prefetch of Rx buffer page to occur conditionally.
> >
> > Bj=C3=B6rn provides AF_XDP performance improvements by not prefetching =
HW
> > descriptors, using 16 byte descriptors, increasing budget for AF_XDP
> > receive, and moving buffer allocation out of Rx processing loop.
>
> My comment on patch #2 is really a nit, but for patch 5 I think we
> should consider carefully a common path rather than "tweak" the drivers
> like this.

Yup, I agree that tweaks like this should be avoided, and I said that
I'll address it in a follow up. However, I was under the impression
that this series would still be pulled (discussed in patch 5), but I
can't find it in the tree.

Thanks,
Bj=C3=B6rn
