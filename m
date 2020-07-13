Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DDC21DAC1
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgGMPuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMPuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:50:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B34BC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 08:50:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so17026499wrw.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 08:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FV3TlvetHfiODgbo1tETv6lN+AjF+4eaqfiBuIZr0Ys=;
        b=BlLd4ljj6DCcC23q7F7riZ81sqaWHjr8yZNaCG7KDjqAfbLDOvTWROcFOhnsyWADzs
         YJqOvG0D7rM+bPjyrdez9Kfwk5JIhhSKCXEpLJXYLMergRLOrWgQAjjBkdNdBMUvcrvT
         RxZwVHLCGm7j/gNorVup9J6OoYnmxu1Ari2GVU+Cp6QUzTVfqvOVdDN3vC/mUxQdnJjg
         SmYZdiH3/6E5EcEWfhYFy0j6g+yGDlJEKurT1cqJpFOf0QgWdxnUQvol0Ks4pypvyeYc
         iPinkHhDLuyymMIni34BIazDKXY2WNa/vkZroB1R6iOmHJDQVuvQsrXiq+clafXNu1xb
         fOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FV3TlvetHfiODgbo1tETv6lN+AjF+4eaqfiBuIZr0Ys=;
        b=fjLauDHoVb5RSMaYmbjnwQKmCjM9BZwuap6jhzxVRtsXeMYEn6I8Z8BP4CnSL9IYGZ
         4rRiyE2gBPZ3prfh0UHawRZlL7v1Fwa9oXaEbbwj/6RXYAzgHZRj2DmP+hM7eZFWVp3+
         lioh9zcuhVwYJkrrxXOkSUxxZDr7rQ27RjrbGyEGbgepuEwDPLz8JXK++YpqfrsgHr+d
         JGycR0vH1Wf3bjBRMTRPW1kFmWe6wD51Z10qMrOdVBLbLGADxIRhjTfbR4sa6WvOtMmI
         l86kfvLrmJ4nLD/zvrOMSmUIUu4bULNj6k1px1OFYp769MRnlkZKzn0ncaVAJfy33P2D
         zTzA==
X-Gm-Message-State: AOAM533qd/WdZ+mBLwIlQf9AMTJrkBsfGKbt56+mD/0NUz8Mko+Olg01
        OaRbp6YnEytlWZ7SbvsT4qHKMLm1vlqcfDOZuns=
X-Google-Smtp-Source: ABdhPJwRG3yo7Gt4x+K5AIxtES2KfgT4ADbmMuIxuHwIKu9tlFjPhJG8c4d7Sg+/N8bi24ObQPwBiIHil1cOXk8eGCg=
X-Received: by 2002:a5d:4c91:: with SMTP id z17mr44211222wrs.267.1594655417430;
 Mon, 13 Jul 2020 08:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
 <1594301221-3731-4-git-send-email-sundeep.lkml@gmail.com> <20200709160156.GC7904@hoboy>
 <CALHRZuoVtuHLFjwW_bJsWxVFYN=PYxwsj+YabNH4p=v82u-MVA@mail.gmail.com> <20200713132557.GA27934@hoboy>
In-Reply-To: <20200713132557.GA27934@hoboy>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 13 Jul 2020 21:20:06 +0530
Message-ID: <CA+sq2CcS3Purx+E0duOMHpMt2EwD=d3ViryvwiH1RjX89M2LLw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 6:57 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Mon, Jul 13, 2020 at 11:40:34AM +0530, sundeep subbaraya wrote:
> > > > +static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
> > > > +{
> > > > +     struct otx2_nic *pfvf = netdev_priv(netdev);
> > > > +     struct hwtstamp_config *cfg = &pfvf->tstamp;
> > > > +
> > >
> > > Need to test phy_has_hwtstamp() here and pass ioctl to PHY if true.
> > >
> > For this platform PHY is taken care of by firmware hence it is not
> > possible.
>
> This has nothing to do with the FW.  The HW design might include a PHY
> or MII time stamping device.

In our HW, ingress timestamping is done by CGX device which is a MAC.
Wrt PHY,  the serdes, PHY etc are managed by firmware. So no 'phydev'
available in kernel.

Thanks,
Sunil.
