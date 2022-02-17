Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966054B9654
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiBQDGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:06:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiBQDGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:06:48 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDE1F7D
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:06:33 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b9so7406434lfv.7
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X0to7YyLGo61S6kN6kMkhVeb7PaU9Q2Vj/AZY1exOew=;
        b=F9NWwzp/liCkekQs6E5lNPA3Q6cU3zshwTxqAMD465ddzGBBoqcaG5Cs1UDCX43Bf2
         SeBlTieVbNXmMwTCbQM2ZSTtcKkJLzmFHrfOSCOO7lo/SBiXIjgOKVWsaO68fxuM9MVJ
         4P//ox2wXVHGp4LXzZ44XSZJUXJwzBIwN1cK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X0to7YyLGo61S6kN6kMkhVeb7PaU9Q2Vj/AZY1exOew=;
        b=l0FC9WK+DHS3Fd/bNOt3IQDcZL/HdXSFg5I8aYyGTOM1c+WsIRaRPhUGRnjQb6PE6w
         0NxFOp7YVQ5grA6EGpGhmgujkCtinff/QibT2GSFiQHsc6OxFxZS052gOgb9jGU2bSvg
         PhG6J7J5zR5m73gw0f6Yr3L37EHOVjIvBVl5p7XMhPXvyqdvGfeF6MDc1p+G8k5C9Z5V
         yIpeB3qFqbuNBk84afWKNCepOASzTel4g2t7kLBVJmvIpUIKihGU+PvdBURwjzv2PPhC
         UaUdIHDPTuntABxwj3Wzd16L/XuiH3m58eaYy4iV7Cg72qGHk//5xfrAJvhoNE5ICTmo
         hmRw==
X-Gm-Message-State: AOAM532wRLfN5BPSh+YxQQXXvPMq/XuMv/Qbp5pDu/qV51I3Z1kpEPxD
        Ksz1b+DKX65awFdgJaK+ONiivVmvP7LCP2lZvokpfA==
X-Google-Smtp-Source: ABdhPJzp+zIXbuJdtwvEsV3oI9LO2M5LW0A/Db8pkMCSd4SARlYBCAB90kdRKgFhG+Xt4lcFlifc8LyDgMgXvlR6HqY=
X-Received: by 2002:ac2:5478:0:b0:443:6754:acca with SMTP id
 e24-20020ac25478000000b004436754accamr735871lfn.51.1645067191552; Wed, 16 Feb
 2022 19:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20220110015636.245666-1-dmichail@fungible.com>
 <20220110015636.245666-4-dmichail@fungible.com> <20220112145110.1ba09f3c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112145110.1ba09f3c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 16 Feb 2022 19:06:18 -0800
Message-ID: <CAOkoqZnvbj81BPgAfW+2ap5qa5jp-UePVYwejQd4sLznkMfLSA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/8] net/funeth: probing and netdev ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 2:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun,  9 Jan 2022 17:56:31 -0800 Dimitris Michailidis wrote:
> > +static int funeth_sriov_configure(struct pci_dev *pdev, int nvfs)
> > +{
> > +     struct fun_dev *fdev = pci_get_drvdata(pdev);
> > +     struct fun_ethdev *ed = to_fun_ethdev(fdev);
> > +     int rc;
> > +
> > +     if (nvfs == 0) {
> > +             if (pci_vfs_assigned(pdev)) {
> > +                     dev_warn(&pdev->dev,
> > +                              "Cannot disable SR-IOV while VFs are assigned\n");
> > +                     return -EPERM;
> > +             }
> > +
> > +             pci_disable_sriov(pdev);
> > +             fun_free_vports(ed);
> > +             return 0;
> > +     }
> > +
> > +     rc = fun_init_vports(ed, nvfs);
> > +     if (rc)
> > +             return rc;
>
> Also likely needs locking, not that sriov callback is called with
> device lock held and VF configuration with rtnl_lock(), they can
> run in parallel.

Yes, I think you're right. I am adding locking.
