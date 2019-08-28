Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954429F8CC
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfH1De5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:34:57 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37375 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfH1De5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 23:34:57 -0400
Received: by mail-pl1-f196.google.com with SMTP id bj8so537560plb.4
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 20:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=RXaobjdqlgSt/1ck9fGBGHWnt/UzN4DZlECk9V+Gqvo=;
        b=rlVnYBTahH4jwwYWX1o133QZMerNZs2XLqx2EiUbZcTH0Uw79Pg8ExfKWHrUujJZQB
         NavqUwlzDgJaHKqb/ZdvGc8V9MHLCm69+1JpDi53cKTXi3/c0MnmpJqwMXMmersBE1US
         V+ITqN20efkjwOfBtwfErKGkoftVb9ZmJACwiPpEMywlDKfnFxkJl62HeiPs2oKsCCV5
         5kAphXw2zjX/hgNyeZB2BFS7Ux55RoG9V2ElKcIzjo5lCx+rNJSqHpA4XLKmUqSmkIVa
         l85YYHon18LdDgTWVYXXI7JeTr/+w0AAlsExyB0c0eP1LcLCAU5ANu2jKm/hXf5goa8p
         K9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RXaobjdqlgSt/1ck9fGBGHWnt/UzN4DZlECk9V+Gqvo=;
        b=BkSEs2nv25cEkuNILDdsOrTOLezxRbeQNJJ32gbLTNbG+rrRaHYVoE1dF16YfcR1Bb
         HAVGkeqnET1O6qbUoaJ3nt2rQsCKaPkRFEr/wKgW6gMOeibvQ/KIO8Q5+K7oAIBXlbTu
         Fd9sJRf9RhyR0ETtNET/ZmtCegXBZck5mXFXmcCimyIEEJ0WniUpwGs1SRhqviniQo4d
         4My7G8CnTc7rYGc8aYs8OzvuTFnGUYeeXXuMq1C0Q98BOXFxAg+GNJi/zOObaNa8EE9G
         gItrrfdj9kpIhVnX2J4lrdwSd7nhJYabMCt8VHm7Loap1h4+P3hYri6n2l07XtKDjblI
         SnJg==
X-Gm-Message-State: APjAAAXfGzDX345pUIjLWkOfRWGBErK37OlgZM3oaPHiCOoI6bCJmeex
        thC0chsh9W80FcUHyhGnrDGvMsJr/6o=
X-Google-Smtp-Source: APXvYqxPwlhwpx+pRDutR6O8Nkv/AIX2MoXkdPs1zLzclfgu5b7WieTnslKPtRW/nRoiu1etHHdBTA==
X-Received: by 2002:a17:902:2b81:: with SMTP id l1mr2198172plb.107.1566963296721;
        Tue, 27 Aug 2019 20:34:56 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id b30sm918220pfr.117.2019.08.27.20.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 20:34:56 -0700 (PDT)
Date:   Tue, 27 Aug 2019 20:34:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190827203439.320664ce@cakuba.netronome.com>
In-Reply-To: <93a16cf5-b8a2-8915-4190-b81607058eb2@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
        <20190826213339.56909-3-snelson@pensando.io>
        <20190826212404.77348857@cakuba.netronome.com>
        <a2ed5049-14c6-749c-9a9b-f826d9a88cb0@pensando.io>
        <20190827201646.2befe6c3@cakuba.netronome.com>
        <93a16cf5-b8a2-8915-4190-b81607058eb2@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 20:26:59 -0700, Shannon Nelson wrote:
> On 8/27/19 8:16 PM, Jakub Kicinski wrote:
> > On Tue, 27 Aug 2019 14:22:55 -0700, Shannon Nelson wrote: =20
> >>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/d=
rivers/net/ethernet/pensando/ionic/ionic_devlink.c
> >>>> index e24ef6971cd5..1ca1e33cca04 100644
> >>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> >>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> >>>> @@ -11,8 +11,28 @@
> >>>>    static int ionic_dl_info_get(struct devlink *dl, struct devlink_i=
nfo_req *req,
> >>>>    			     struct netlink_ext_ack *extack)
> >>>>    {
> >>>> +	struct ionic *ionic =3D devlink_priv(dl);
> >>>> +	struct ionic_dev *idev =3D &ionic->idev;
> >>>> +	char buf[16];
> >>>> +
> >>>>    	devlink_info_driver_name_put(req, IONIC_DRV_NAME);
> >>>>   =20
> >>>> +	devlink_info_version_running_put(req,
> >>>> +					 DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
> >>>> +					 idev->dev_info.fw_version); =20
> >>> Are you sure this is not the FW that controls the data path? =20
> >> There is only one FW rev to report, and this covers mgmt and data. =20
> > Can you add a key for that? Cause this one clearly says management.. =20
>=20
> Perhaps something like this?
>=20
> /* Overall FW version */
> #define DEVLINK_INFO_VERSION_GENERIC_FW=C2=A0=C2=A0=C2=A0 "fw"

Sounds reasonable.

> >> Since I don't have any board info available at this point, shall I use
> >> my own "asic.id" and "asic.rev" strings, or in this patch shall I add
> >> something like this to devlink.h and use them here:
> >>
> >> /* Part number, identifier of asic design */
> >> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID=C2=A0=C2=A0=C2=A0 "asic.i=
d"
> >> /* Revision of asic design */
> >> #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV=C2=A0=C2=A0=C2=A0 "asic.=
rev" =20
> > Yes, please add these to the generic items and document appropriately. =
=20
>=20
> Sure.=C2=A0 Is there any place besides=20
> Documentation/networking/devlink-info-versions.rst?

Nope, that's the one.
