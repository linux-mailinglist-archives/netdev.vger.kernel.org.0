Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733131C08B0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgD3VBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:01:23 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:40279 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgD3VBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:01:22 -0400
Received: from A1K-Ubuntu.lan ([209.93.117.199]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.179]) with ESMTPA (Nemesis) id
 1M9Frd-1jYv08364V-006Pty; Thu, 30 Apr 2020 23:01:15 +0200
From:   Darren Stevens <darren@stevens-zone.net>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     oss@buserror.net, netdev@vger.kernel.org, madalin.bacur@nxp.com,
        linuxppc-dev@lists.ozlabs.org, chzigotzky@xenosoft.de
Date:   Thu, 30 Apr 2020 21:45:14 +0100 (BST)
Message-ID: <4f9f07dc2ed.5db66924@auth.smtp.1and1.co.uk>
In-Reply-To: <20200425001021.GB1095011@lunn.ch>
References: <20200424232938.1a85d353@Cyrus.lan>
 <20200425001021.GB1095011@lunn.ch>
User-Agent: YAM/2.9p1 (AmigaOS4; PPC; rv:20140418r7798)
Subject: Re: Don't initialise ports with no PHY
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:fmf8xDnUzK1WedA9cWQE5LSLSxbFn1of7nHBxBR3yRKilFW0fF5
 OJ6HQwSUJOCx6rl52kdtqC/xPXc3MQKFito5V+n9aKOJ3dQ3GKqLuVUOgYHMvNJdnGnsT7Q
 lm5/5CZwJPyBdWsByEm07DZCS54J6Bkx2j4n1pIXzRBlK3d/vrvgoc5EqE760My03JZf0ze
 mFpToSbM9vHUJ2kOUsONA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6z6v/dYPaI8=:GaDS2hOxqcRk47vz2BwL0J
 siNhhZfVPtxhsQyPCWW+31UfkS/FQZsDT083a2mXCOxOp99UF/GBUJlpgtrimM8rg2blGqx25
 nxnvjTAabzkKsqjGxKdC3Sjh7riMTnNCviDmm0kr7v7IWQKBwsfxaOc46M9bDYQrJNJbCnwYB
 +ey8biZi9vJv4m9HbIUSgCsnSan617agjv2gZpq3mTASk2nHVxVPG//ku/W0/T4yEtfAMix7l
 9ZKIE7X2tol5c2We8IQjJuuSWk2SlwvPjms3Ae+KBJdxiXdlX2eXJf5aF650KSI4QE3AiToMf
 dsPECAEGaFtVVMzMp36jOuwPK2xw85TrZSJ76Aamuq0rs5mygw64ep7PpBLm/F7rt8fcAbZ4w
 HKrWeAGPdp8fEdZySSeGXpLUSyXYXkrAp8EFKdeamA2ba1ddX2nnd6f8R3ixXl2N+Re68a3RA
 f6y4ZaHowRiz+e9mQcRsfreJfi5gM0iuc1utXB1totahrgBIxGzXFoFFK/ne+lol7n645/bjH
 sfL42JFuASIGPGr9jlCxdiGEDAs+txFLU9dfRdhuH26s4xGC3cI4IWlFnJMarWAH/FeFXFHzo
 DaCBEZFkgfrWaJmhpqWLNVHkVYl4YrPyfxc5Z6uBGQgQ7DqwOECz51l6eXc7mURyrNzixSghx
 vr4GDLB26F2VuVKv7BHwn6fHh8CnRDCmDxDzIPFDY20lM45B7g69FyoANF+dHeGOVwi0FSuOO
 jiuk3cMB8UuImYM81jRGZvDsSmwgYQUnc4D9rWJBnwPlDe9eOQ4EcFf5NBCqEU+Q1NZijMqtx
 xhJs9ebagTT1VIJtXHJHcKYdbQQVUP1QalGmPHIaxE4kaUkWSljh3FTqmMYbfjEBFDTyFYD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew

On 25/04/2020, Andrew Lunn wrote:
> On Fri, Apr 24, 2020 at 11:29:38PM +0100, Darren Stevens wrote:
>> Since cbb961ca271e ("Use random MAC address when none is given")
>> Varisys Cyrus P5020 boards have been listing 5 ethernet ports instead of
>> the 2 the board has.This is because we were preventing the adding of the
>> unused ports by not suppling them a MAC address, which this patch now
>> supplies.
>> 
>> Prevent them from appearing in the net devices list by checking for a
>> 'status="disabled"' entry during probe and skipping the port if we find
>> it. 
>
> Hi Darren
>
> I'm surprised the core is probing a device which has status disabled.
> Are you sure this is the correct explanation?

You are correct, the core is detecting status="disabled". My mistake, the Hardware vendor's supplied dts always relied on only supplying active ports with an IP address, and it didn't occur to me to test that they could be disabled.

Sorry.

Regards
Darren

