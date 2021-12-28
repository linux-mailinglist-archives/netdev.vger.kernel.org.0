Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F223480DAA
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 23:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbhL1WWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 17:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237488AbhL1WWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 17:22:51 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67945C061574;
        Tue, 28 Dec 2021 14:22:51 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id d198-20020a1c1dcf000000b0034569cdd2a2so10777898wmd.5;
        Tue, 28 Dec 2021 14:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4M2fYiV8osMi/K8zko/E+wLNgrYelg1lIier9ENbgz4=;
        b=MTKPBFoweWQAhvBXIY2VwrdoTs5ZERc088ZFz7/vRSsKUJDkmBhSTGP/gaPPiD8OQH
         OjaQ2FRKJ++BwUGIqqWroyrNS/UipVg0pDStLTa4ZU2aswCOg5JfOR71rXH1E83hwcZa
         /uJMCWnXKlyuBidjzrDACpO4QcJtP1MEm1Z+icdpOahf1g35t/N+YegnDtCJZI/SUtWx
         R8oLCbrZb8jdHBHtDaK914vY6A/7iNkvyanveUqZWaUSl1xpOZ8CODNKoBfxMIJSstDx
         tXAIhmZFo61uZgRy/E05mfrhfl0q6uyMCw7sstDkmn2jveTMPKZQrGrK53EAmQXQnFbZ
         E4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4M2fYiV8osMi/K8zko/E+wLNgrYelg1lIier9ENbgz4=;
        b=UkymKyGCTQFl/cOCpweELmgn6BJM62DUN8jIspMr6HNJaYeENkJQc+INt8OgLNndiO
         AY1+BY2cb/gno4xGXr7iyDHn8qQkF7jHviWHrJI1cTK7Z0j8PiRDtDzzBuwAytrGxQg5
         GRoPV9Aih8UQmFieUlqDNgn5dRmt6LJ+w/IEjN+eUFRtF5GLnXtWtZa+V/sQJJINEM5H
         MNYj7zCXLvO+N9x8CBy69GL1+cR6odGLWtAWO+w4WbtnWGGZ29uCUBfLwI2pIskJVgCi
         Pf7zq7gHKoPU+UFe5Dl7ZUO3HpreWJ2NGQTxV+hUdPOm1YcOPkv/4PMjMNobYywpvT6f
         VeDA==
X-Gm-Message-State: AOAM531MlL8SVky1TmgRozl77oPiI8yLEa0HHoePOom0QqTvF+z/Z7uF
        qv/rORzKXi+QIxPjAVAZLpek3qliIE1EOGnAeWM=
X-Google-Smtp-Source: ABdhPJxbN5uJV2qwOV1CevVgZ2wlylt+xml/HywNaRnBImF/FE4LIZ3QJQ//TL4sRCsZvSzPrxKW/TijM58nSoABn3A=
X-Received: by 2002:a7b:c745:: with SMTP id w5mr18697759wmk.167.1640730169930;
 Tue, 28 Dec 2021 14:22:49 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com> <20211222155743.256280-9-miquel.raynal@bootlin.com>
In-Reply-To: <20211222155743.256280-9-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 28 Dec 2021 17:22:38 -0500
Message-ID: <CAB_54W786n6_4FAMc7VMAX0nuyd6r2Hi+wYEEbd5Bjdrd8ArpA@mail.gmail.com>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN management
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 22 Dec 2021 at 10:57, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Let's introduce the basics of PAN management:
> - structures defining PANs
> - helpers for PANs registration
> - helpers discarding old PANs
>

I think there exists a little misunderstanding about how the
architecture is between the structures wpan_phy, wpan_dev and
cfg802154.

 - wpan_phy: represents the PHY layer of IEEE 802154 and is a
registered device class.
 - wpan_dev: represents the MAC layer of IEEE 802154 and is a netdev interface.

You can have multiple wpan_dev operate on one wpan_phy. To my best
knowledge it's like having multiple access points running on one phy
(wireless) or macvlan on ethernet. You can actually do that with the
mac802154_hwsim driver. However as there exists currently no (as my
knowledge) hardware which supports e.g. multiple address filters we
wanted to be prepared for to support such handling. Although, there
exists some transceivers which support something like a "pan bridge"
which goes into such a direction.

What is a cfg802154 registered device? Well, at first it offers an
interface between SoftMAC and HardMAC from nl802154, that's the
cfg802154_ops structure. In theory a HardMAC transceiver would bypass
the SoftMAC stack by implementing "cfg802154_ops" on the driver layer
and try to do everything there as much as possible to support it. It
is not a registered device class but the instance is tight to a
wpan_phy. There can be multiple wpan_dev's (MAC layer instances on a
phy/cfg802154 registered device). We currently don't support a HardMAC
transceiver and I think because this misunderstanding came up.

That means as far I see you should move the most of those attributes
to per wpan_dev instead of per cfg802154.

- Alex
