Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF4A270158
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgIRPvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgIRPvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 11:51:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA89121734;
        Fri, 18 Sep 2020 15:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600444303;
        bh=W+eCP9/oq+d3ilRDMujo/7+OI25X5P6rKSJQZeOohuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jfqeQaffw4nL8qLcubuqqQJzqd3l8mfzXTzetXPN13LrqyMejyYDBY/+0/+ZmVorb
         1HV7ymQiKCCyIIei3AW6n1Vj8s3urXRPswpAszi8Tv0BwaKZnEO3rP7PaVRbjun5xW
         DyWMAIQ9Xxnl0itS6zJr7bPE7L6njFuE3s4k1kKM=
Date:   Fri, 18 Sep 2020 08:51:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herrington <hankinsea@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ptp: mark symbols static where possible
Message-ID: <20200918085141.4d247b94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918061013.2034-1-hankinsea@gmail.com>
References: <20200918061013.2034-1-hankinsea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 14:10:13 +0800 Herrington wrote:
> We get 1 warning when building kernel with W=3D1:
> drivers/ptp/ptp_pch.c:182:5: warning: no previous prototype for =E2=80=98=
pch_ch_control_read=E2=80=99 [-Wmissing-prototypes]
>  u32 pch_ch_control_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:193:6: warning: no previous prototype for =E2=80=98=
pch_ch_control_write=E2=80=99 [-Wmissing-prototypes]
>  void pch_ch_control_write(struct pci_dev *pdev, u32 val)
> drivers/ptp/ptp_pch.c:201:5: warning: no previous prototype for =E2=80=98=
pch_ch_event_read=E2=80=99 [-Wmissing-prototypes]
>  u32 pch_ch_event_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:212:6: warning: no previous prototype for =E2=80=98=
pch_ch_event_write=E2=80=99 [-Wmissing-prototypes]
>  void pch_ch_event_write(struct pci_dev *pdev, u32 val)
> drivers/ptp/ptp_pch.c:220:5: warning: no previous prototype for =E2=80=98=
pch_src_uuid_lo_read=E2=80=99 [-Wmissing-prototypes]
>  u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:231:5: warning: no previous prototype for =E2=80=98=
pch_src_uuid_hi_read=E2=80=99 [-Wmissing-prototypes]
>  u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:242:5: warning: no previous prototype for =E2=80=98=
pch_rx_snap_read=E2=80=99 [-Wmissing-prototypes]
>  u64 pch_rx_snap_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:259:5: warning: no previous prototype for =E2=80=98=
pch_tx_snap_read=E2=80=99 [-Wmissing-prototypes]
>  u64 pch_tx_snap_read(struct pci_dev *pdev)
> drivers/ptp/ptp_pch.c:300:5: warning: no previous prototype for =E2=80=98=
pch_set_station_address=E2=80=99 [-Wmissing-prototypes]
>  int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
>=20
> Signed-off-by: Herrington <hankinsea@gmail.com>

The declarations are in:

drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h

You need to split those out into a shared header and include them
appropriately.
