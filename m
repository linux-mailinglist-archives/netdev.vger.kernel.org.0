Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34883122DEC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfLQOEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:04:39 -0500
Received: from sitav-80046.hsr.ch ([152.96.80.46]:60866 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfLQOEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 09:04:38 -0500
Received: from obook.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id ADAA840148;
        Tue, 17 Dec 2019 14:56:22 +0100 (CET)
From:   Martin Willi <martin@strongswan.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH netfilter/iptables] Add new slavedev match extension
Date:   Tue, 17 Dec 2019 14:56:14 +0100
Message-Id: <20191217135616.25751-1-martin@strongswan.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces a new Netfilter match extension to match input
interfaces that are associated to a layer 3 master device. The first 
patch adds the new match to the kernel, the other provides an extension 
to userspace iptables to make use of the new match.

The motivation for a new match is that in INPUT/FORWARD, a base match
for the input interface is done against the layer 3 master device if
the real input device is associated to such a device. This makes
filtering on input interfaces within VRFs difficult.

In output, the packet is passed to Netfilter with the real output
interface as well, so output interface matching in slavedev is not
required. Nonetheless are the arguments named explicitly for the input
interface, as it makes the meaning of these options more intuitive
and the match extensible.

An alternative approach for better filtering within VRFs could be to pass
the packet with the real interface to FORWARD/INPUT hooks, or even pass 
it twice similar to the output path. This is very likely to break 
existing rulesets, though, which should be no problem with a new match
extension.
--
2.20.1
