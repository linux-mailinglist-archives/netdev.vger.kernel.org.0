Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1747F140FF9
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAQRgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:36:50 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34783 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQRgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:36:49 -0500
Received: by mail-wm1-f66.google.com with SMTP id w5so9957144wmi.1
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 09:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v48U+esdwKCF2b5fbGlgDt9ujPJD2jU8u6+XU/nmTgQ=;
        b=f/N/SLefrwHavuaVU1LIp85tbnay0zgMOHJnpxm826H3PlASHok3cV/W3KjpfWt1/e
         R+1/vYyu4vIA1Ze9hxBthaeyLVnlswwtQ4z1CijVqR53VNdDY+syHScrYOB/VrOnx34N
         3gpRobDa4qCQyOFrPHsHMPcL9aZlecszwz9L8XflvCHi6c3m9ESifD7woxR2HDqzhQPW
         kIZnJsmf1lZr2QemSpRi49BuaBx+/+hFhseoVo14yVhCYJislUQoQLBCfuqBMPcQRwNV
         Tp05zfB7fKsm1J3ynp60vXnySOomHTPp4jePbeHpj0reEYLj9raTwaoQgMRAJ9HN1ZNM
         nRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v48U+esdwKCF2b5fbGlgDt9ujPJD2jU8u6+XU/nmTgQ=;
        b=NOSZO/wFxVKJaCUAOBXi9a9+3DR7/QUaU3rge1EhckL4ph83TMer/Xwzf5RgiWAy2O
         UBis+U1wC8/W7VRXCq3qjeNHT3MLU6gZ8z759UbBxIIx8sRCAuxoBe3QMsook743I7zZ
         kU9VXf6lXNWbmNwlgXoXBULzNSrWw5ZPsSTHD4GLmM3jMmkpDAtF6gU4rnK0lTkJBF9p
         8IHcIPldkJGxEcpVRvef+lBYKLcXSZhH0lqDZVsQSjqZR+dtKqkslJMMMCOoimrpstzD
         Qud6HtTt5bsxPi00ImW9FxpHN57LV3g3rSA9NDTPw6ra/oJdEJWzZ96ydfkKxuiBkApc
         Hpww==
X-Gm-Message-State: APjAAAWq9L8th07EXRuQnsRQzzdR578Dxas74Cp1N35asLIc/K+2ONNT
        PBR05tJeFdR7NcV2e86EfLMegeZH2BO+3umCLfU=
X-Google-Smtp-Source: APXvYqykJy+PtFMeS57Ap1x2vtXGtP2by/IUUg6tb3AsKJDSKEF9/I7HLwawgj1x6n/XWaZPHI5GlKMuhlm14cX2Ur0=
X-Received: by 2002:a1c:6389:: with SMTP id x131mr5909600wmb.155.1579282607452;
 Fri, 17 Jan 2020 09:36:47 -0800 (PST)
MIME-Version: 1.0
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579204053-28797-12-git-send-email-sunil.kovvuri@gmail.com> <20200116173952.58213098@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200116173952.58213098@cakuba.hsd1.ca.comcast.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 17 Jan 2020 23:06:36 +0530
Message-ID: <CA+sq2Cdqw7B42mdy-K7Rric1VTWZ8cPTB_ViTqAb+Gjc+5aZ5g@mail.gmail.com>
Subject: Re: [PATCH v3 11/17] octeontx2-pf: Receive side scaling support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 7:09 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 17 Jan 2020 01:17:27 +0530, sunil.kovvuri@gmail.com wrote:
> > +int otx2_rss_init(struct otx2_nic *pfvf)
> > +{
> > +     struct otx2_rss_info *rss = &pfvf->hw.rss_info;
> > +     int idx, ret = 0;
> > +
> > +     /* Enable RSS */
> > +     rss->enable = true;
> > +     rss->rss_size = sizeof(rss->ind_tbl);
> > +
> > +     /* Init RSS key here */
> > +     netdev_rss_key_fill(rss->key, sizeof(rss->key));
> > +     otx2_set_rss_key(pfvf);
> > +
> > +     /* Default indirection table */
> > +     for (idx = 0; idx < rss->rss_size; idx++)
> > +             rss->ind_tbl[idx] =
> > +                     ethtool_rxfh_indir_default(idx, pfvf->hw.rx_queues);
> > +
> > +     ret = otx2_set_rss_table(pfvf);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* Default flowkey or hash config to be used for generating flow tag */
> > +     rss->flowkey_cfg = NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6 |
> > +                        NIX_FLOW_KEY_TYPE_TCP | NIX_FLOW_KEY_TYPE_UDP |
> > +                        NIX_FLOW_KEY_TYPE_SCTP;
> > +
> > +     return otx2_set_flowkey_cfg(pfvf);
> > +}
>
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > index 557f86b..fe5b3de 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > @@ -838,6 +838,11 @@ int otx2_open(struct net_device *netdev)
> >       if (err)
> >               goto err_disable_napi;
> >
> > +     /* Initialize RSS */
> > +     err = otx2_rss_init(pf);
> > +     if (err)
> > +             goto err_disable_napi;
>
> Looks like you fully reset the RSS params on every close/open cycle?
> I don't think that's the expected behaviour/what most NICs do.
> For example you should only reset the indir table if
> netif_is_rxfh_configure() returns false.

Thanks for pointing, will check this.

Sunil.
