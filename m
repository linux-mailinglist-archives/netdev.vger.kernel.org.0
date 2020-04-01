Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 359E219A9E7
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732229AbgDALBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:01:35 -0400
Received: from 243.11.169.217.in-addr.arpa ([217.169.11.243]:59424 "HELO
        chch.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1731343AbgDALBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:01:35 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2020 07:01:34 EDT
Received: (qmail 1376921 invoked by uid 500); 1 Apr 2020 10:54:52 -0000
Date:   1 Apr 2020 10:54:52 -0000
Message-ID: <20200401105452.1376920.qmail@chch.co.uk>
From:   Charles Bryant <ch.4g7vxy-nbkl8p@chch.co.uk>
To:     netdev@vger.kernel.org
Subject: two bogus patches arising from CVE-2019-12381
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe two patches from last year are mistaken. They are:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=95baa60a0da80a0143e3ddd4d3725758b4513825

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=425aa0e1d01513437668fa3d4a971168bbaa8515

Both of these make a function return immediately with ENOMEM if a kalloc()
fails.  However in each case the function already correctly handled
allocation failure later on. Furthermore, by making them exit early
on allocation failure, it (very slightly) makes them worse as in some
cases they might have correctly returned EADDRINUSE and not needed the
allocated memory.

I think, therefore, that these changes should be reverted.
-- 
Charles Bryant
