Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3139EBC9F5
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394099AbfIXOQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:16:49 -0400
Received: from mail.itouring.de ([188.40.134.68]:53616 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390765AbfIXOQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 10:16:49 -0400
Received: from tux.wizards.de (pD9EBF359.dip0.t-ipconnect.de [217.235.243.89])
        by mail.itouring.de (Postfix) with ESMTPSA id ED148416C07D;
        Tue, 24 Sep 2019 16:16:47 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id A2F9AF01602;
        Tue, 24 Sep 2019 16:16:47 +0200 (CEST)
To:     Netdev <netdev@vger.kernel.org>,
        Igor Russkikh <igor.russkikh@aquantia.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: atlantic: weird hwmon temperature readings with AQC107 NIC (kernel
 5.2/5.3)
Organization: Applied Asynchrony, Inc.
Message-ID: <0db14339-1b69-8fa4-21fd-6d436037c945@applied-asynchrony.com>
Date:   Tue, 24 Sep 2019 16:16:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I recently upgraded my home network with two AQ107-based NICs and a
multi-speed switch. Everything works great, but I couldn't help but notice
very weird hwmon temperature output (which I wanted to use for monitoring
and alerting).

Both cards identify as:

$lspci -v -s 06:00.0
06:00.0 Ethernet controller: Aquantia Corp. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion] (rev 02)
	Subsystem: ASUSTeK Computer Inc. AQC107 NBase-T/IEEE 802.3bz Ethernet Controller [AQtion]

In one machine lm_sensors says:

eth0-pci-0200
Adapter: PCI adapter
PHY Temperature: +315.1°C

This seems quite wrong since the card is only slightly warm to the touch, and
315.1 is exactly 255 + 60.1 - the latter value feels more like the actual
temperature.

On a second machine it says:

eth0-pci-0600
Adapter: PCI adapter
PHY Temperature: +6977.0°C

I feel qualified to say that is definitely wrong as well, since the machine is
currently not melting its way to the earth's core, and also only slightly warm
to the touch. :)

Both cards also reported wrong values with kernel 5.2, but since I'm on 5.3.1
I might as well report the current wrongness.

Do we know who's to blame here - motherboards, NICs, driver, kernel, hwmon
infrastructure? I believe the hwmon patches landed first in 5.2.

Thanks,
Holger
