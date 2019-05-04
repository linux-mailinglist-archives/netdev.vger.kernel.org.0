Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639E513B05
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 17:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfEDPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 11:50:00 -0400
Received: from mail.thelounge.net ([91.118.73.15]:52073 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfEDPuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 11:50:00 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 44xD391PdczXQW;
        Sat,  4 May 2019 17:49:57 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: CVE-2019-11683
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
Date:   Sat, 4 May 2019 17:49:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is this fixed in 5.0.12 and just not visible in the changelog?

because if not there's no poiunt to reboot a over a long time randomly
crahsing firewall setup which *appears* stable now after replace "LOG"
with "NFLOG" and remove --reap from the xt_recent rules

----------------------

https://www.openwall.com/lists/oss-security/2019/05/02/1

syzbot has reported a remotely triggerable memory corruption in the
Linux kernel. It's been introduced quite recently in e20cf8d3f1f7
("udp: implement GRO for plain UDP sockets.") and only affects the 5.0
(stable) release (so the name is a bit overhyped :).

CVE-2019-11683 description:

udp_gro_receive_segment in net/ipv4/udp_offload.c in the Linux kernel
5.x through 5.0.11 allows remote attackers to cause a denial of
service (slab-out-of-bounds memory corruption) or possibly have
unspecified other impact via UDP packets with a 0 payload, because of
mishandling of padded packets, aka the "GRO packet of death" issue.

Fix (not yet upstream):

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=4dd2b82d5adfbe0b1587ccad7a8f76d826120f37

----------------------

https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.0.11
https://cdn.kernel.org/pub/linux/kernel/v5.x/ChangeLog-5.0.12
