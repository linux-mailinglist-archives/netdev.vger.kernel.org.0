Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674AB490AB0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiAQOou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:44:50 -0500
Received: from asav21.altibox.net ([109.247.116.8]:43006 "EHLO
        asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234355AbiAQOou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 09:44:50 -0500
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav21.altibox.net (Postfix) with ESMTPSA id 2FB6C80080;
        Mon, 17 Jan 2022 15:44:47 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:8b0a:1e21:3a05:ad2e:f4a6])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 20HEijZE3014571
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 17 Jan 2022 15:44:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1642430687; bh=9RRMAJXJZ9tKwzgiZz2I+v/+xBcTNFchPWdcY3QWacg=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=NCiqXHMJqFibUWnlyjbC0GkNOy1gtvecVfeN6ZmvbCGnimV5l00qhLvwMMrB/Za/7
         MVBjNDZ8hSRI1+k6Y/iGyaWEPcE5ZylE+BaxtpiyzXmFwtqqn+8NhxbkZva1ZzJ3d1
         H20N7vjOkqTE2HSDzXM4SJvQoZvSe/snyQezCbkk=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1n9TFQ-0027wN-8I; Mon, 17 Jan 2022 15:44:40 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA?= =?utf-8?B?6YOO?= 
        <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without
 diag mode
Organization: m
References: <20211130073929.376942-1-bjorn@mork.no>
        <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
        <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
        <d4533eb7-97c1-5eb1-011d-60b59ff7ccbb@gmail.com>
        <YeV8BwzyXuuvxvBN@shell.armlinux.org.uk>
Date:   Mon, 17 Jan 2022 15:44:40 +0100
In-Reply-To: <YeV8BwzyXuuvxvBN@shell.armlinux.org.uk> (Russell King's message
        of "Mon, 17 Jan 2022 14:24:07 +0000")
Message-ID: <87wniys9pj.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=ZLv5Z0zb c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=DghFqjY3_ZEA:10 a=M51BFTxLslgA:10
        a=PHq6YzTAAAAA:8 a=yv0qbTKVZAAS0E9g4UIA:9 a=QEXdDO2ut3YA:10
        a=ZKzU8r6zoKMcqsNulkmm:22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Russell King (Oracle)" <linux@armlinux.org.uk> writes:

> However, I'm confused about who the reporter and testers actually are,
> so I'm not sure who to put in the Reported-by and Tested-by fields.
> From what I can see, Bj=C3=B8rn Mork <bjorn@mork.no> reported it (at least
> to mainline devs), and the fix was tested by =E7=85=A7=E5=B1=B1=E5=91=A8=
=E4=B8=80=E9=83=8E
> <teruyama@springboard-inc.jp>.
>
> Is that correct? Thanks.

I just forwarded the initial report.  All credit should go to =E7=85=A7=E5=
=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E
<teruyama@springboard-inc.jp>.


Bj=C3=B8rn
