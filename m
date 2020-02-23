Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1E41697E7
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 14:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgBWNlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 08:41:04 -0500
Received: from canardo.mork.no ([148.122.252.1]:51357 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWNlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 08:41:03 -0500
Received: from miraculix.mork.no (ti0136a430-4331.bb.online.no [80.213.107.248])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 01NDeudj024858
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 23 Feb 2020 14:40:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1582465256; bh=B1r3vsmiyMC3FCbqyArVqXmIUybokSxxlEfgZ5SJV2A=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=M8Z2LYITKJ8JLHYmQEDQT5rgkQgAVKkjXkg5ol3KPbdGNVDV2NAKrVhZ7Yny1CQd7
         ssbCDK3Kp1G8Mz6ltJAPSXCCCf4Dz2Q+P6RGSZXhWIo5IhfLVxWSdJtvc79YFTXg5c
         vX9nlINbO/5swgCy8Xhv4amXjaj31U6L008jFjeQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1j5rV5-00075G-Be; Sun, 23 Feb 2020 14:40:51 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: restore mtu min/max values after raw_ip switch
Organization: m
References: <20200221131705.26053-1-dnlplm@gmail.com>
Date:   Sun, 23 Feb 2020 14:40:51 +0100
In-Reply-To: <20200221131705.26053-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Fri, 21 Feb 2020 14:17:05 +0100")
Message-ID: <87eeul5sm4.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> usbnet creates network interfaces with min_mtu =3D 0 and
> max_mtu =3D ETH_MAX_MTU.
>
> These values are not modified by qmi_wwan when the network interface
> is created initially, allowing, for example, to set mtu greater than 1500.
>
> When a raw_ip switch is done (raw_ip set to 'Y', then set to 'N') the mtu
> values for the network interface are set through ether_setup, with
> min_mtu =3D ETH_MIN_MTU and max_mtu =3D ETH_DATA_LEN, not allowing anymor=
e to
> set mtu greater than 1500 (error: mtu greater than device maximum).
>
> The patch restores the original min/max mtu values set by usbnet after a
> raw_ip switch.
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Great! I tried to look up the origin of this bug, and it seems to be a
hard-to-spot fallout from the 'centralized MTU checking'.  Not easy to
see the hidden connection in usbnet.c and eth.c. Thanks for finding and
fixing it!

This should probably go to stable as well?

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
