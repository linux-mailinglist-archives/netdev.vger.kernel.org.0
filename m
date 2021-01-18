Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5372FAC36
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbhARVHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393981AbhARVD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 16:03:26 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8180FC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 13:02:44 -0800 (PST)
Received: from miraculix.mork.no (fwa136.mork.no [192.168.9.136])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10IL2ap7021374
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 18 Jan 2021 22:02:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611003756; bh=AXyaLc9G6y6vQFeOkRhfn2o3L9LKR4Nlqt0P4sHTcYs=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=lHyv8R61bYDx+PUZLcExF7NT+d3JoOdRPPXptoJ2rJ5UW9Lq5FDG8jf9mgmmnA9Zd
         7Jb2rjHnlpI2azbjgLVF3PvrZq8suig7K2qJW4IS76FUDLg3Q7RmHLaZBO0yYZNDmh
         H75414plpeguiG8b5yYA5p40H/KugpyFhpmF+2RU=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l1bfY-002WNb-4Q; Mon, 18 Jan 2021 22:02:36 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Giacinto Cifelli <gciofono@gmail.com>
Cc:     Reinhard Speyerer <rspmn@t-online.de>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
Organization: m
References: <20210118054611.15439-1-gciofono@gmail.com>
        <20210118115250.GA1428@t-online.de>
Date:   Mon, 18 Jan 2021 22:02:36 +0100
In-Reply-To: <20210118115250.GA1428@t-online.de> (Reinhard Speyerer's message
        of "Mon, 18 Jan 2021 12:52:51 +0100")
Message-ID: <87a6t6j6vn.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reinhard Speyerer <rspmn@t-online.de> writes:

>> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
>> index af19513a9f75..262d19439b34 100644
>> --- a/drivers/net/usb/qmi_wwan.c
>> +++ b/drivers/net/usb/qmi_wwan.c
>> @@ -1302,6 +1302,8 @@ static const struct usb_device_id products[] =3D {
>>  	{QMI_FIXED_INTF(0x0b3c, 0xc00a, 6)},	/* Olivetti Olicard 160 */
>>  	{QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},	/* Olivetti Olicard 500 */
>>  	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
>> +	{QMI_FIXED_INTF(0x1e2d, 0x006f, 8)},	/* Cinterion PLS83/PLS63 */
>> +	{QMI_QUIRK_SET_DTR(0x1e2d, 0x006f, 8)},
>>  	{QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},	/* Cinterion PHxx,PXxx */
>>  	{QMI_FIXED_INTF(0x1e2d, 0x0063, 10)},	/* Cinterion ALASxx (1 RmNet) */
>>  	{QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},	/* Cinterion PHxx,PXxx (2 RmNet) =
*/
>
> Hi Giacinto,
>
> AFAIK the {QMI_FIXED_INTF(0x1e2d, 0x006f, 8)} is redundant and can simply
> be deleted. Please see also commit 14cf4a771b3098e431d2677e3533bdd962e478=
d8
> ("drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x1201=
")
> and commit 97dc47a1308a3af46a09b1546cfb869f2e382a81
> ("qmi_wwan: apply SET_DTR quirk to Sierra WP7607") for the corresponding
> examples from other UE vendors.

Yup, please fix and send a v2.  And please use get_maintainer.pl to get
the proper destinations.

Thanks for spotting this, Reinhard.  I would never have caught it with
my current netdev reading frequency....




Bj=C3=B8rn
