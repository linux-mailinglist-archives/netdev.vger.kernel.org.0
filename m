Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1572D36AF
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731591AbgLHXFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLHXFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:05:23 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2F7C0613D6;
        Tue,  8 Dec 2020 15:04:31 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id q3so13647588pgr.3;
        Tue, 08 Dec 2020 15:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g8w99bOKMQaI7RPq3aVN4m6AgRC1N9XlkH38wDP/7fM=;
        b=ak87JjrdvsGHZ5n7pU6IGyTOSERizarxesthjoXv9ydXz5RIN9VixN2OhBCUmGDrdP
         Dkiy4sSoiAkWzuLoOsEcqscxA/ObreGetTNqjDnPYwtFEcPIYtIv7EP9hqNMUU8MC2xy
         2k2BHnuG7D9iX8tG8r5r8scRrHUWblve+HysN3bR+qgrfHlzXAmnO7fN443fQf5oeZ6j
         3ohncBz0hVkFZbYnY0g/xR+XHHZoGDEtSPx5eajMqeV4axF45/tGoBwcA6tX22lzvOap
         r2PY+TlJPq6RMqMgkrSRmyGq53x+dOTP7nrT2jEkL2eP5iDxaLBK7mgbW/0hfKJ1RzeK
         Bkbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g8w99bOKMQaI7RPq3aVN4m6AgRC1N9XlkH38wDP/7fM=;
        b=mvwBYZrPR5apzBG0qtWSzsacl60MEX8oFp55CpeD8OiHMxm6vu97mKb9NQ63OzAgU9
         Cl5vHQl/P0pPmmHBY9FMNYxMi4porQuy8Vj1lUTPdpw+w+vvPfesiww5UZO4N1ZQc6uE
         Fx2y0prMK+WSM/UvHvt0MQIlpW1OvQpRqWGCyrw+ra8zdpvyB8pTdgy1zGRiduO7162F
         5x4WySJXEUO9yBEj6qp95wFS3wEWxH0NwzJEkF6g4GONn2vjcxv3fyzkGyASAh2UWoh1
         REs5xcISb2jFAnTHDgstMWYpUjIiNgBJ0xt2IYPlVhAl+fBBLTpQBFcuzLvSra6ePZzk
         fmxA==
X-Gm-Message-State: AOAM531FCKCbP5jtc3weqR5TpxIRFlnhjNPzvAAYMfbACIzl7tWtwHIK
        R/HT5YO2IlQ2UGWUHV8IcoA=
X-Google-Smtp-Source: ABdhPJxgKAmJWS/Ey7kpXXSlNZYb9aJ62AElXl3aXXb0zSwv0dX1dq2hOvKDfUFD7nOXmY9KXuvWkw==
X-Received: by 2002:a17:90a:6fa1:: with SMTP id e30mr40040pjk.32.1607468670850;
        Tue, 08 Dec 2020 15:04:30 -0800 (PST)
Received: from zen.local ([71.212.189.78])
        by smtp.gmail.com with ESMTPSA id x4sm5352pgg.94.2020.12.08.15.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 15:04:30 -0800 (PST)
From:   Trent Piepho <tpiepho@gmail.com>
To:     Joseph Hwang <josephsih@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: define HCI packet sizes of USB Alts
Date:   Tue, 08 Dec 2020 15:04:29 -0800
Message-ID: <9810329.nUPlyArG6x@zen.local>
In-Reply-To: <20200923102215.hrfzl7c7q2omeiws@pali>
References: <20200910060403.144524-1-josephsih@chromium.org> <CAHFy418Ln9ONHGVhg513g0v+GxUZMDtLpe5NFONO3HuAZz=r7g@mail.gmail.com> <20200923102215.hrfzl7c7q2omeiws@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, September 23, 2020 3:22:15 AM PST Pali Roh=C3=A1r wrote:
> On Monday 14 September 2020 20:18:27 Joseph Hwang wrote:
> > On Thu, Sep 10, 2020 at 4:18 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
> > > And this part of code which you write is Realtek specific.
> >=20
> > We currently only have Intel and Realtek platforms to test with. If
> > making it generic without proper testing platforms is fine, I will
> > make it generic. Or do you think it might be better to make it
> > customized with particular vendors for now; and make it generic later
> > when it works well with sufficient vendors?
>=20
> I understood that those packet size changes are generic to bluetooth
> specification and therefore it is not vendor specific code. Those packet
> sizes for me really seems to be USB specific.
>=20
> Therefore it should apply for all vendors, not only for Realtek and
> Intel.

I have tried to test WBS with some different USB adapters.  So far, all use=
=20
these packet sizes.  Tested were:

Broadcom BRCM20702A
Realtek RTL8167B
Realtek RTL8821C
CSR CSR8510 (probably fake)

In all cases, WBS works best with packet size of (USB packet size for alt m=
ode=20
selected) * 3 packets - 3 bytes HCI header.  None of these devices support =
alt=20
6 mode, where supposedly one packet is better, but I can find no BT adapter=
 on=20
which to test this.

> +static const int hci_packet_size_usb_alt[] =3D { 0, 24, 48, 72, 96, 144,=
 60};

Note that the packet sizes here are based on the max isoc packet length for=
=20
the USB alt mode used, e.g. alt 1 is 9 bytes.  That value is only a=20
"recommended" value from the bluetooth spec.  It seems like it would be mor=
e=20
correct use (btusb_data*)->isoc_tx_ep->wMaxPacketSize to find the MTU.

> > [Issue 2] The btusb_work() is performed by a worker. There would be a
> > timing issue here if we let btusb_work() to do =E2=80=9Chdev->sco_mtu =
=3D
> > hci_packet_size_usb_alt[i]=E2=80=9D because there is no guarantee how s=
oon the
> > btusb_work() can be finished and get =E2=80=9Chdev->sco_mtu=E2=80=9D va=
lue set
> > correctly. In order to avoid the potential race condition, I suggest
> > to determine air_mode in btusb_notify() before
> > schedule_work(&data->work) is executed so that =E2=80=9Chdev->sco_mtu =
=3D
> > hci_packet_size_usb_alt[i]=E2=80=9D is guaranteed to be performed when
> > btusb_notify() finished. In this way, hci_sync_conn_complete_evt() can
> > set conn->mtu correctly as described in [Issue 1] above.

Does this also give userspace a clear point at which to determine MTU setti=
ng,=20
_before_ data is sent over SCO connection?  It will not work if sco_mtu is =
not=20
valid until after userspace sends data to SCO connection with incorrect mtu.




