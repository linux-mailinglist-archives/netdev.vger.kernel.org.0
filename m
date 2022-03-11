Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11E44D623E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348844AbiCKNUP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Mar 2022 08:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348821AbiCKNUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:20:14 -0500
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Mar 2022 05:19:10 PST
Received: from mail.bix.bg (mail.bix.bg [193.105.196.21])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id D32D71C2DA3
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:19:10 -0800 (PST)
Received: (qmail 813 invoked from network); 11 Mar 2022 13:12:28 -0000
Received: from d2.declera.com (HELO ?212.116.131.122?) (212.116.131.122)
  by indigo.declera.com with SMTP; 11 Mar 2022 13:12:28 -0000
Message-ID: <d654c98b90d98db13b84752477fe2c63834bcf59.camel@declera.com>
Subject: r8169:  rtl8168ep_driver_stop disables the DASH port
From:   Yanko Kaneti <yaneti@declera.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     netdev <netdev@vger.kernel.org>
Date:   Fri, 11 Mar 2022 15:12:28 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.43.3 (3.43.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Testing DASH on a ASRock A520M-HDVP/DASH, which has a RTL8111/8168 EP
chip. DASH is enabled and seems to work on BIOS/firmware level.

It seems that r8169's cleanup/exit in rtl8168ep_driver_stop manages to
actually stop the LAN port, hence cutting the system remote management.

This is evident on plain shutdown or rmmod r8169.
If one does a hardware reset or echo "b" > /proc/sysrq-trigger  the
cleanup doesn't happen and the DASH firmware remains in working order
and the LAN port remains up.

A520M-HDVP/DASH BIOS ver 1.70
Reatlek fw:
 Firmware Version:		3.0.0.20200423
 Version String:		20200428.1200000113
 
I have no idea if its possible or how to update the realtek firmware,
preferably from Linux.

Various other DASH functionality seems to not work but basic working
power managements is really a deal breaker for the whole thing.


Regards
Yanko
