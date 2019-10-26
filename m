Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E68E6005
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 01:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfJZXip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 19:38:45 -0400
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:59079 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbfJZXim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 19:38:42 -0400
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id E6875C11D0;
        Sat, 26 Oct 2019 16:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1572132596;
        bh=V6pz8vspEzqVX3J4enydcBDlTE7FVRPAf/j4/lEcbnI=;
        h=From:To:Cc:Subject:Date;
        b=doSRWIXIX36Cc394Euf/wD1Q3+tFP7FiK4/mkPS+nDF6euL/ZlaQpRjbPPqOCLdiK
         m3C80dvJqpTLOLFTgIKDnFGOcDvwxl+NKfchacvuMfhvW2hX7ZAYzJ9dDS8wRWC1hN
         e1gWnoI0a9uCcaLMv5oAXoclZFIfHJV7pHcPx7xY=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net
Subject: [PATCH iproute2-net-next 0/3] pretty-print 802.3ad slave state
Date:   Sat, 26 Oct 2019 16:29:51 -0700
Message-Id: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the bond slave 802.3ad state in a human-readable way in iproute2
The 802.3ad bond slave actor/partner state definitions are exported
to userspace in the kernel include/uapi

rtnetlink sends the bond slave state to userspace, see
 - IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE; and
 - IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE

These attributes only send the state value; the kernel does not export
the state field definitions to interpret the state's fields.

As the 802.3ad port states are defined in the 802.3ad standard, export
the 802.3ad bond slave state definitions to uapi/ and pretty print
them in iproute2.

net-next:

Andy Roulin (1):
  bonding: move 802.3ad slave state defs to uapi

 drivers/net/bonding/bond_3ad.c  | 10 ----------
 include/uapi/linux/if_bonding.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

iproute2-next:

Andy Roulin (2):
  include/uapi: update bonding kernel header
  iplink: bond: print 3ad actor/partner oper states as strings

 include/uapi/linux/if_bonding.h | 10 +++++++++
 ip/iplink_bond_slave.c          | 38 +++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 4 deletions(-)

-- 
2.20.1

