Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3409F8A4
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfH1DRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:17:04 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41736 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfH1DRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:17:04 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so586497pgg.8
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 20:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5nVCH2M/JFHWBdYah6jU/PmtJqLzYNylK7PPfqNYBZM=;
        b=xREPhcNWzTFl0ugObT0M0KG1PSL5pnjtlScO1UaV2EUVeDrXh06tO3qeVlo83e98jX
         pcVig1SJe1q/YB0XHVwIT6LIOit7CfwXczUqpMuamrrhfJG/kC7A17+ci3+IniF1NRGb
         EJfypwK8qNeD0FsBzz5y+SbSxcQWti+K4pi1SzvYOBFrf2t/WNY0sTB6QQnkOZ5TYSzP
         q4pe2WQPQmzcspsNAttUxqK5tYPjBBKTvxd5f1vb6qhHhDXEvvs2Op2l/OyuaueIEISX
         ELI+YUXqVplQJw2zhqsC7f5K9xOFPYHwTTN9r5x9MxC4h1ICgQETILPy6kLY2g2V/kjr
         JYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5nVCH2M/JFHWBdYah6jU/PmtJqLzYNylK7PPfqNYBZM=;
        b=cWHSJwqROOmeAZSwoN8TL/vj8NHPPrFp+w5SYf0bRmmQxGVDw6V1iKqt29TQpo5aBn
         PIAyAbeJSFoHL3Fa5QaF4O4L4EeeZ27NCffuAS3PcoeaxshPXjmYZYGohYCt0w9MNO2D
         i9tZrBWpwC+tf1fFksUKCtZVlZv661oaSjkJ2E+hISKn5rle3PAd18RLbhcN3L5Q4Jyo
         iA8apzg71Ff3L/g4PxggZPLC9C7WQO5lmvebcHxsSXKZrgFrRcwgg6Q6MBmsdUjsY8yB
         9QXrO20Y/maZ1+dz12O3SEoRcboFWdcdTyYiGIrScG1GGrC7lSaTqltanxX8SW08Icby
         HH1w==
X-Gm-Message-State: APjAAAWjik9X9OBP334rXVs7H6Rkkstz1G+k8VHtc3Rp5x+zfQIeqsnE
        CaGYowiIcNquCvpOGlLJ2CCa34H/ZFg=
X-Google-Smtp-Source: APXvYqzUD0rVAoWmDpCn+CZeSZJsoO7H7T4IhDkA172IKQKzSn8q/CFteW58zSUX5qteD+79Geroig==
X-Received: by 2002:a62:144b:: with SMTP id 72mr2191223pfu.42.1566962223803;
        Tue, 27 Aug 2019 20:17:03 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id b123sm837100pfg.64.2019.08.27.20.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 20:17:03 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:16:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190827201646.2befe6c3@cakuba.netronome.com>
In-Reply-To: <a2ed5049-14c6-749c-9a9b-f826d9a88cb0@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
        <20190826213339.56909-3-snelson@pensando.io>
        <20190826212404.77348857@cakuba.netronome.com>
        <a2ed5049-14c6-749c-9a9b-f826d9a88cb0@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 14:22:55 -0700, Shannon Nelson wrote:
> >> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/dri=
vers/net/ethernet/pensando/ionic/ionic_devlink.c
> >> index e24ef6971cd5..1ca1e33cca04 100644
> >> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> >> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> >> @@ -11,8 +11,28 @@
> >>   static int ionic_dl_info_get(struct devlink *dl, struct devlink_info=
_req *req,
> >>   			     struct netlink_ext_ack *extack)
> >>   {
> >> +	struct ionic *ionic =3D devlink_priv(dl);
> >> +	struct ionic_dev *idev =3D &ionic->idev;
> >> +	char buf[16];
> >> +
> >>   	devlink_info_driver_name_put(req, IONIC_DRV_NAME);
> >>  =20
> >> +	devlink_info_version_running_put(req,
> >> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
> >> +					 idev->dev_info.fw_version); =20
> > Are you sure this is not the FW that controls the data path? =20
>=20
> There is only one FW rev to report, and this covers mgmt and data.

Can you add a key for that? Cause this one clearly says management..

> > =20
> >> +	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
> >> +	devlink_info_version_fixed_put(req,
> >> +				       DEVLINK_INFO_VERSION_GENERIC_BOARD_ID,
> >> +				       buf); =20
> > Board ID is not ASIC. This is for identifying a board version with all
> > its components which surround the main ASIC.
> > =20
> >> +	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
> >> +	devlink_info_version_fixed_put(req,
> >> +				       DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
> >> +				       buf); =20
> > ditto =20
>=20
> Since I don't have any board info available at this point, shall I use=20
> my own "asic.id" and "asic.rev" strings, or in this patch shall I add=20
> something like this to devlink.h and use them here:
>=20
> /* Part number, identifier of asic design */
> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID=C2=A0=C2=A0=C2=A0 "asic.id"
> /* Revision of asic design */
> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV=C2=A0=C2=A0=C2=A0 "asic.rev"

Yes, please add these to the generic items and document appropriately.
