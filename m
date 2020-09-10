Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B07265075
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgIJUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgIJUSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:18:31 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C206C061573;
        Thu, 10 Sep 2020 13:18:31 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id m7so5743862oie.0;
        Thu, 10 Sep 2020 13:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSr7eas7UCDLiKtUST/yM6eCB9mwn3Ox+Iz05goYcYE=;
        b=r56ZhkM8MWuEk4NFvpByh9i3ZdtUzZWXhjkRd2EzXIg2Sfau4kHXKkSSBLZa9QBEFT
         itkol48c5GEGnp0ZUc5Wr10Np6/9a2c7entfNmtsPCnzkbgG3qH24ccHkIzwM48IBWPJ
         3E91Fbnr58thL/NQ9RoZIf9kwJA02dnCsQ0c+bsWlsEuYxalgH45L4Uaro2usEvkxTYv
         Xmox3OoV9qZusirQNXVJ5FWTf5nPiL8ecsH2Z23Wp2qUeYSuD7dNdZ5xLU6Pj/vyB4Lv
         6+UgeV/Uxh0X2q4mZKQD4xBizWSpBQ8iU7/IjhaNsQNkmD6IugWxjSxFVbDlYuIvEjCB
         0YYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSr7eas7UCDLiKtUST/yM6eCB9mwn3Ox+Iz05goYcYE=;
        b=raZYZLgVkUs16UeA+TdhRfy/mZjxpXOpJnj8rWiSgnYgX3Cw4sSLJUd1de8i7hwQ3k
         qBr+BLngMHUVwcuCS1dGmoEGD1bPlDnMyQaZrLQzNjBemjaLRiInN+F9hfvQuc2anzwz
         tpvAnrILOIymwDLY3ErCxtEKemk8BPGk9Rr08BL+zkZubsST6ZcSCzFDjTd821Jplyyb
         +5upOcyeU9dbH3C0Si1Rb1oh1i5wM5xtz7jcM6PJ1XDVVWl2HL1EMjWZl+LBTR6glvPi
         d1e+hyLV5OMXllAIPPzShnR0Lf2+5vQHFy+JGYrCcFb/yCI1U2m3m/odTp40iNS9Npca
         1UBQ==
X-Gm-Message-State: AOAM531xK3+xphhyFIaqUE8fu+uEB5i6eE8lPCUN3HdXk+dqHkfDFkBc
        FPTmuIYhmL4tEqiTpOTzGndED6rDmVtTG5OyeKM=
X-Google-Smtp-Source: ABdhPJymd4I2EOBxmI6F95jez1rOw0pgdi8yiUyaZEMNCtIFgLRvOwIxGKLp4uP0upI3nruy5b9z3OoUn0zrlwWHLng=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr1158424oij.154.1599769108191;
 Thu, 10 Sep 2020 13:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910161126.30948-13-oded.gabbay@gmail.com>
 <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com> <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910131629.65b3e02c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:17:59 +0300
Message-ID: <CAFCwf10XdCDhLeyiArc29PAJ_7=BGpdiUvFRotvFHieiaRn=aA@mail.gmail.com>
Subject: Re: [PATCH 12/15] habanalabs/gaudi: add debugfs entries for the NIC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Omer Shpigelman <oshpigelman@habana.ai>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:16 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Sep 2020 23:10:47 +0300 Oded Gabbay wrote:
> > On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 10 Sep 2020 19:11:23 +0300 Oded Gabbay wrote:
> > > > From: Omer Shpigelman <oshpigelman@habana.ai>
> > > >
> > > > Add several debugfs entries to help us debug the NIC engines and ports and
> > > > also the communication layer of the DL training application that use them.
> > > >
> > > > There are eight new entries. Detailed description is in the documentation
> > > > file but here is a summary:
> > > >
> > > > - nic_mac_loopback: enable mac loopback mode per port
> > > > - nic_ports_status: print physical connection status per port
> > > > - nic_pcs_fail_time_frame: configure windows size for measuring pcs
> > > >                            failures
> > > > - nic_pcs_fail_threshold: configure pcs failures threshold for
> > > >                           reconfiguring the link
> > > > - nic_pam4_tx_taps: configure PAM4 TX taps
> > > > - nic_polarity: configure polarity for NIC port lanes
> > > > - nic_check_link: configure whether to check the PCS link periodically
> > > > - nic_phy_auto_neg_lpbk: enable PHY auto-negotiation loopback
> > > >
> > > > Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
> > > > Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
> > > > Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
> > >
> > > debugfs configuration interfaces are not acceptable in netdev.
> >
> > no problem, but can we have only these two entries:
> > > - nic_mac_loopback: enable mac loopback mode per port
> > > - nic_ports_status: print physical connection status per port
> >
> > nic_ports_status is print only (not configuration).
>
> Doesn't seem like this one shows any more information than can be
> queried with ethtool, right?
correct, it just displays it in a format that is much more readable
>
> > nic_mac_loopback
> > is to set a port to loopback mode and out of it. It's not really
> > configuration but rather a mode change.
>
> What is this loopback for? Testing?

Correct.

Thanks,
Oded
