Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB23481BCF
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 12:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbhL3LwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 06:52:22 -0500
Received: from asav21.altibox.net ([109.247.116.8]:41592 "EHLO
        asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbhL3LwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 06:52:21 -0500
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 06:52:21 EST
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav21.altibox.net (Postfix) with ESMTPSA id D5434802CD;
        Thu, 30 Dec 2021 12:43:52 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1BUBhmdB2291702
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 30 Dec 2021 12:43:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1640864632; bh=kKNCoJkwn3Optv20/yPybXW8/W7o/0YhgQQrNE5ttWc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=orQj+Mrc9Hk00mUnGf7Vh6qR8Iq+JX8OzOaEWxyGdL/zPyFc8g/CktyD/znMjilSZ
         B9UQLYpHAHYZ7VB5VnlfWW3AmQFimXKA1VJMLHIi+hnCWrsCHF/JMSH4YjPEm6y8f/
         3MXZuOo3uF+HxfmlZF2hnKzHTQWnNY4NHawiLoIA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1n2tqW-000iTH-AD; Thu, 30 Dec 2021 12:43:48 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without
 diag mode
Organization: m
References: <20211130073929.376942-1-bjorn@mork.no>
        <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
        <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
        <877dclkd2y.fsf@miraculix.mork.no>
        <YathNbNBob2kHxrH@shell.armlinux.org.uk>
        <877dcif2c0.fsf@miraculix.mork.no>
        <CAOZT0pVXzLWSBf_sKcZaDEbbnnm=FcZH0DCLZbKW7VXo013E_A@mail.gmail.com>
Date:   Thu, 30 Dec 2021 12:43:48 +0100
In-Reply-To: <CAOZT0pVXzLWSBf_sKcZaDEbbnnm=FcZH0DCLZbKW7VXo013E_A@mail.gmail.com>
        (=?utf-8?B?IueFp+WxseWRqOS4gOmDjiIncw==?= message of "Tue, 7 Dec 2021
 00:39:57 +0900")
Message-ID: <87ee5ul3m3.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=ZLv5Z0zb c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=IOMw9HtfNCkA:10 a=M51BFTxLslgA:10
        a=G_zE8aRVZJIWuSZ68loA:9 a=QEXdDO2ut3YA:10 a=vpHKiH_-uj8A:10
        a=QYH75iMubAgA:10 a=rfbVjh9QSgkt5OmyzezM:22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E7=85=A7=E5=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E <teruyama@springboard-inc.jp>=
 writes:

> I will test Russell's patch in a few days.

Hello!

Sorry to nag, but I didn't see any followup.  Did I miss it?


Bj=C3=B8rn
