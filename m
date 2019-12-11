Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E841511B1BE
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387967AbfLKPch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:32:37 -0500
Received: from forward104j.mail.yandex.net ([5.45.198.247]:38358 "EHLO
        forward104j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733213AbfLKPcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:32:35 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 10:32:34 EST
Received: from forward102q.mail.yandex.net (forward102q.mail.yandex.net [IPv6:2a02:6b8:c0e:1ba:0:640:516:4e7d])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id E16404A2357
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 18:26:06 +0300 (MSK)
Received: from mxback9q.mail.yandex.net (mxback9q.mail.yandex.net [IPv6:2a02:6b8:c0e:6b:0:640:b813:52e4])
        by forward102q.mail.yandex.net (Yandex) with ESMTP id DB1B47F20018
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 18:26:06 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback9q.mail.yandex.net (mxback/Yandex) with ESMTP id fGxSieXO82-Q64Gum2S;
        Wed, 11 Dec 2019 18:26:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1576077966;
        bh=CfllutZEi8hDAtjr0RdTtlxlytAMc8qebPqNH+ty01s=;
        h=Message-Id:Date:Subject:To:From;
        b=A2eU3o8II5jFl4Tq69K1/XktwKeKMAtUCtk2LCQBse9ZM/5bAJOYxdVcIOesIGCFZ
         iQ5j0KPXSnV5rdI47NydR3oGPpg1T+GGyxcWnW/xOVHVQ/c8vIUuVArGtbLMukxmSi
         56/1Rfi939F5fQVdErnCH/nDxsZPABv8A2jbd19M=
Authentication-Results: mxback9q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla4-87a00c2d2b1b.qloud-c.yandex.net with HTTP;
        Wed, 11 Dec 2019 18:26:06 +0300
From:   Aleksei Zakharov <zakharov.a.g@yandex.ru>
Envelope-From: zakharov-a-g@yandex.ru
To:     netdev@vger.kernel.org
Subject: RPS arp processing
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Wed, 11 Dec 2019 18:26:06 +0300
Message-Id: <83161576077966@vla4-87a00c2d2b1b.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, everyone
Is it possible to balance ARP across CPUs with RPS?
I don't clearly understand how hash is calulated for ARP packets, but it seems that it should consider source and target IPs.

In our current setup we have one l2 segment between external hardware routers and namespaces on linux server.
When router sends ARP request, it is passed through server's physical port, then via openvswitch bridge it is copied to every namespace.
We've found that all ARPs (for different destination ips and few source ips) are processed on one CPU inside namespaces. We use RPS, and most packets are balanced between all CPUs.
Kernel 4.15.0-65 from ubuntu 18.04.

Might this issue be related to namespaces somehow?

-- 
Regards,
Aleksei Zakharov

