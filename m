Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5658E79F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiHJHI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiHJHI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:08:57 -0400
X-Greylist: delayed 746 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 00:08:55 PDT
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2986796A0;
        Wed, 10 Aug 2022 00:08:55 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 27A6tsd3588953
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 07:55:56 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:961:910a:a293:6d6e:8bbf:c204])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 27A6tlsr604953
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 08:55:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1660114549; bh=jreNYZmBDW3E+iK6TgCwzCr9t13dtx1ddnlZG0dgdC8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=iQ08mWYQIEtRxjLzdutxpMyanUUgfpzkWKbR81TWZnCNiVdSycBOgYrOxDgh/LIJp
         AqEj6Q3NNxVRXjhdu+Cm099gPinGDml9MILsZtMJnRUJxCk3xC/ie2JF+xsqMSnnKP
         yJtrhf0ogIe1wnnXbKE5WmA418PpzNhcRKT473w0=
Received: (nullmailer pid 478119 invoked by uid 1000);
        Wed, 10 Aug 2022 06:55:42 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
Organization: m
References: <20220810014521.9383-1-slark_xiao@163.com>
Date:   Wed, 10 Aug 2022 08:55:42 +0200
In-Reply-To: <20220810014521.9383-1-slark_xiao@163.com> (Slark Xiao's message
        of "Wed, 10 Aug 2022 09:45:21 +0800")
Message-ID: <8735e4mvtd.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.6 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slark Xiao <slark_xiao@163.com> writes:

> There are 2 models for MV32 serials. MV32-W-A is designed
> based on Qualcomm SDX62 chip, and MV32-W-B is designed based
> on Qualcomm SDX65 chip. So we use 2 different PID to separate it.
>
> Test evidence as below:
> T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D02 Cnt=3D03 Dev#=3D  3 Spd=3D480 M=
xCh=3D 0
> D:  Ver=3D 2.10 Cls=3Def(misc ) Sub=3D02 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D1e2d ProdID=3D00f3 Rev=3D05.04
> S:  Manufacturer=3DCinterion
> S:  Product=3DCinterion PID 0x00F3 USB Mobile Broadband
> S:  SerialNumber=3Dd7b4be8d
> C:  #Ifs=3D 4 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D50 Drive=
r=3Dqmi_wwan
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Drive=
r=3Doption

The patch looks nice, but I have a couple of questions since you're one
of the first pushing one of these SDX6x modems.

Is that protocol pattern fixed on this generation of Qualcomm chips?  It
looks like an extension of what they started with the SDX55 generation,
where the DIAG port was identified by ff/ff/30 across multiple vendors.

Specifically wrt this driver and patch, I wonder if we can/should match
on ff/ff/50 instead of interface number here?  I note that the interface
numbers are allocated sequentionally. Probably in the order these
function are enabled by the firmware? If so, are we sure this is static?
Or could we risk config variants where the RMNET/QMI function have a
different interface number for the same PIDs?

And another possibility you might consider.  Assuming that ff/ff/50
uniquely identifies RMNET/QMI functions regardless of PID, would you
consider a VID+class match to catch all of them?  This would not only
support both the PIDs of this patch in one go, but also any future PIDs
without the need for further driver patches.


Bj=C3=B8rn
