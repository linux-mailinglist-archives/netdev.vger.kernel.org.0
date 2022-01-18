Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4BA493104
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350063AbiARWwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:52:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240919AbiARWwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:52:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 833A86145E
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 22:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A176C340E0;
        Tue, 18 Jan 2022 22:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642546320;
        bh=dN7CL2F5FXdNBh4p7yUMt5LhbdTk1TsyTDRcvL74qns=;
        h=Date:From:To:Cc:Subject:From;
        b=A+M7ZEIsnanLEFEbww4o54g/eDJjGSZKT6KcDfmCekq88XY2yw9xB7eRVpHVuAVcB
         nzBzMZYBNT1pDp93YAreIqfPJHKy3EPydkyQJtvkloZZdPiid07ZdLkSWOzOhZP4Fn
         Np6i8hvdyPiZM728HzfNuRAkfg6/XmPCZ8gH73DNfKrK4r7r+SCeQwGG1LTUk/VWp8
         kB5Lrr103C1JrWucoQmGJmkjT0sl+PtHTXrubm4lB5DjMbmLlY745UBSTIhSWnN0JK
         X7T7c3ZfO1nKX4fLs3QXzEz8mF7Zu0cBAnBp3uLtMKXPovwyJ3rjWVoIKU/60mYYw/
         Uazz8JaCjCdJg==
Date:   Tue, 18 Jan 2022 14:51:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, michel@fb.com,
        dcavalca@fb.com
Subject: ethtool 5.16 release / ethtool -m bug fix
Message-ID: <20220118145159.631fd6ed@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal!

Sorry to hasten but I'm wondering if there is a plan to cut the 5.16
ethtool release? Looks like there is a problem in SFP EEPROM parsing
code, at least with QSFP28s, user space always requests page 3 now.
This ends in an -EINVAL (at least for drivers not supporting the paged
mode).

By the looks of it - Ido fixed this in 6e2b32a0d0ea ("sff-8636: Request
specific pages for parsing in netlink path") but it may be too much code 
to backport so I'm thinking it's easiest for distros to move to v5.16.
