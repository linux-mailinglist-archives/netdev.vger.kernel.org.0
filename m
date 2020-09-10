Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4BF26505B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgIJUOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbgIJULU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:11:20 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D49FC061573;
        Thu, 10 Sep 2020 13:11:16 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id i17so7150236oig.10;
        Thu, 10 Sep 2020 13:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PIaw4viVscD0xciePTKoxfM/fPGxfckTUhgAPLwZWUs=;
        b=F3oiey2grTNpBYbsJEvFtUCJHyYz7k3lOnbE+yuhGY5ji8Bjbk6qzqq1WlUZLXCI7l
         KvC8/vqPXdHZUYMkYXA8/RpJvvWfnwrhYnPHOPFIwPN37r83hes12G8KnvEGrZRZD22r
         CSh1RdNpvb5xDXNX9/wuKRoI61zyo4wahZOwp9n79/K1whLaqHYrgCiwYxGGYGH4iGuw
         sdHE7sjomnaHm70GtcQuhqY1eH4sKOcsaBkTkOoKjntzVFwnoesE21cnArKlOioSBSJA
         G29iOiMrBmZqn1pGXrb44n65vkf6SU+towPk8Ky5JV43LPHvBuz0tckD0BC5mArzhOyW
         YKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PIaw4viVscD0xciePTKoxfM/fPGxfckTUhgAPLwZWUs=;
        b=BpKAMaGHHw4MXQKZHW/k1BmEjlwS0oHL+cPJZ9hVJZ269I7IUujsKBVGAm/4v5JDwC
         TtP8EETY+5x85cL4wo570M1rIuHLrcFqXP82tYbDmibVQui8Thybi567XPUVd5PytUmw
         fP0BygGCTH+dyHNNIm9cKtXAaxyTxMiERoahwA+/CY3KZevG3z1z9Hb9qByfXPAHgeDS
         7j/RoPZVXzthpCSCcgqwzJHtkUIGh1rbtSl+fSO1hOCX81SNlpA4Gc+PUJzlU4Etdasi
         SbZIP0+VJonn5jCaM9q62Q7Aiqcyh3MeazylstNZdSUIOQRR4Mv8qrDDKb/xe3tXpmVR
         zpGg==
X-Gm-Message-State: AOAM533ZsCP1XRgXwcPqQ6kX+0Ix0Xqu+Vb8+dJEHE/PzesMwjFRq/6u
        95H438MFz+YbVa59HVO7NfxgZ5PYF9SQPosll0OrrBshCMrElg==
X-Google-Smtp-Source: ABdhPJz2APy1qRsuVPEiADmwZ0os2nfZdnFyBncVhvPhiY7hJleSOr4sZiGeIwiwC6mBjq5qWzxi0lcxYT4JFmz0E24=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr1139541oij.154.1599768675322;
 Thu, 10 Sep 2020 13:11:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910161126.30948-13-oded.gabbay@gmail.com>
 <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910130138.6d595527@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:10:47 +0300
Message-ID: <CAFCwf113A_=da2fGxgMbq_V0OcHsxdp5MpfHiUfeew+gEdnjaQ@mail.gmail.com>
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

On Thu, Sep 10, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Sep 2020 19:11:23 +0300 Oded Gabbay wrote:
> > From: Omer Shpigelman <oshpigelman@habana.ai>
> >
> > Add several debugfs entries to help us debug the NIC engines and ports and
> > also the communication layer of the DL training application that use them.
> >
> > There are eight new entries. Detailed description is in the documentation
> > file but here is a summary:
> >
> > - nic_mac_loopback: enable mac loopback mode per port
> > - nic_ports_status: print physical connection status per port
> > - nic_pcs_fail_time_frame: configure windows size for measuring pcs
> >                            failures
> > - nic_pcs_fail_threshold: configure pcs failures threshold for
> >                           reconfiguring the link
> > - nic_pam4_tx_taps: configure PAM4 TX taps
> > - nic_polarity: configure polarity for NIC port lanes
> > - nic_check_link: configure whether to check the PCS link periodically
> > - nic_phy_auto_neg_lpbk: enable PHY auto-negotiation loopback
> >
> > Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
> > Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
> > Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
>
> debugfs configuration interfaces are not acceptable in netdev.

no problem, but can we have only these two entries:
> - nic_mac_loopback: enable mac loopback mode per port
> - nic_ports_status: print physical connection status per port

nic_ports_status is print only (not configuration). nic_mac_loopback
is to set a port to loopback mode and out of it. It's not really
configuration but rather a mode change.
If not, what's the alternative ?

Thanks,
Oded
