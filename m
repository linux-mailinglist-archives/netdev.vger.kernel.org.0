Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB44311D9E
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 15:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhBFOUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 09:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhBFOUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 09:20:40 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623F4C06174A;
        Sat,  6 Feb 2021 06:19:59 -0800 (PST)
Received: from miraculix.mork.no (fwa145.mork.no [192.168.9.145])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 116EJsjh025481
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 6 Feb 2021 15:19:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1612621194; bh=xDWEM83Qi1MXdyyOBM+i3n05LwuDlQxJCv5yycFe8/I=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=k06qOhlIoBHRZMk6AhB8u28oCZPCmeZpDw6UzCPh+/MkOx5fAsLcRAGa2l6H5Xlid
         doDyw30X5hFCcWqLlPAhAXArAHfSMnUdk40yNMZnEygCW+qFEutbOSMNHzVr1KkIGO
         a7aVDA5eoEsxqOy4CnFrug+mAc3aNy1EqGF0NbPw=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l8ORF-000JHQ-KJ; Sat, 06 Feb 2021 15:19:53 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: support ZTE P685M modem
Organization: m
References: <20210205173904.13916-1-lech.perczak@gmail.com>
        <20210205173904.13916-2-lech.perczak@gmail.com>
Date:   Sat, 06 Feb 2021 15:19:53 +0100
In-Reply-To: <20210205173904.13916-2-lech.perczak@gmail.com> (Lech Perczak's
        message of "Fri, 5 Feb 2021 18:39:03 +0100")
Message-ID: <87r1lt1do6.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lech Perczak <lech.perczak@gmail.com> writes:

> The modem is used inside ZTE MF283+ router and carriers identify it as
> such.
> Interface mapping is:
> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
>
> T:  Bus=3D02 Lev=3D02 Prnt=3D02 Port=3D05 Cnt=3D01 Dev#=3D  3 Spd=3D480  =
MxCh=3D 0
> D:  Ver=3D 2.01 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D19d2 ProdID=3D1275 Rev=3Df0.00
> S:  Manufacturer=3DZTE,Incorporated
> S:  Product=3DZTE Technologies MSM
> S:  SerialNumber=3DP685M510ZTED0000CP&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&=
&&&&&&&&&0

This lookes weird.  But I guess that's really the string presented by
this device?

> C:* #Ifs=3D 5 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:* If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Driver=
=3Doption
> E:  Ad=3D81(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D01(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> E:  Ad=3D83(I) Atr=3D03(Int.) MxPS=3D  10 Ivl=3D32ms
> E:  Ad=3D82(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D02(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driver=
=3Doption
> E:  Ad=3D85(I) Atr=3D03(Int.) MxPS=3D  10 Ivl=3D32ms
> E:  Ad=3D84(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D03(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Driver=
=3Dqmi_wwan
> E:  Ad=3D87(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D32ms
> E:  Ad=3D86(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D04(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> I:* If#=3D 4 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3D42 Prot=3D01 Driver=
=3D(none)
> E:  Ad=3D88(I) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
> E:  Ad=3D05(O) Atr=3D02(Bulk) MxPS=3D 512 Ivl=3D0ms
>
> Cc: Bj=C3=B8rn Mork <bjorn@mork.no>
> Signed-off-by: Lech Perczak <lech.perczak@gmail.com>

Patch looks fine to me.  But I don't think you can submit a net and usb
serial patch in a series. These are two different subsystems.

There's no dependency between the patches so you can just submit
them as standalone patches.  I.e. no series.

Feel free to include

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
