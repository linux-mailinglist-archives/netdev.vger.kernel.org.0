Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1AE72543C
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfEUPmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:42:42 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:55050 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfEUPmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:42:42 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 98326100097;
        Tue, 21 May 2019 17:42:39 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 6CFEF84C;
        Tue, 21 May 2019 17:42:39 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.32,VDF=8.16.15.54)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id 985FD6C7;
        Tue, 21 May 2019 17:42:37 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, thomas.jarosch@intra2net.com,
        netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Work around hardware unit hang by disabling TSO
Date:   Tue, 21 May 2019 17:42:37 +0200
Message-ID: <3878056.TXPIU5uV5l@rocinante.m.i2n>
In-Reply-To: <d308eb17-98ab-13e7-6c74-d701288e43b5@intel.com>
References: <1623942.pXzBnfQ100@rocinante.m.i2n> <d308eb17-98ab-13e7-6c74-d701288e43b5@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sasha,

On Wednesday, 15 May 2019 07:39:46 CEST Neftin, Sasha wrote:
> You are right, in some particular configurations e1000e devices stuck at
> Tx hang while TCP segmentation offload is on. But for all other users we
> should keep the TCP segmentation option is enabled as default. I suggest
> to use 'ethtool' command: ethtool -K <adapter> tso on/off to workaround
> Tx hang in your situation.
> Thanks,
> Sasha

thank you for your reply.

I did consider using "ethtool" to disable TSO for my use cases. However, I 
have no guarantees that a machine with the PCH2 device will not hang and 
render my system inaccessible before anything in userspace runs. No amount of 
connection outage is acceptable.

The problem escalates when we take into consideration that the exact 
circumstances that bring the device into an unrecoverable state don't seem to 
be known even by the Intel developers themselves.

This patch keeps the problematic device stable for all configurations.

So I ask myself, how actually feasible is it to gamble the usage of "ethtool" 
to turn on or off TSO every time the network configuration changes?

Why should we let the users run into an open knife instead of preemptively fix 
a known hardware bug via the kernel? Otherwise all Linux distributions would 
need to apply the magic ethtool fix for this specific PCI id.

Best regards,
Juliana


