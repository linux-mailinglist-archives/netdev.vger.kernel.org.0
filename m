Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6582311C013
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLKWrr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Dec 2019 17:47:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56546 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLKWrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:47:47 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1ifAlj-0005oS-B6; Wed, 11 Dec 2019 22:47:43 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id A30DC6C567; Wed, 11 Dec 2019 14:47:41 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 9CEC0AC1CC;
        Wed, 11 Dec 2019 14:47:41 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Andy Roulin <aroulin@cumulusnetworks.com>
cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        vfalico@gmail.com, andy@greyhouse.net, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] bonding: move 802.3ad port state flags to uapi
In-reply-to: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
Comments: In-reply-to Andy Roulin <aroulin@cumulusnetworks.com>
   message dated "Wed, 11 Dec 2019 14:30:58 -0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15325.1576104461.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 11 Dec 2019 14:47:41 -0800
Message-ID: <15326.1576104461@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Roulin <aroulin@cumulusnetworks.com> wrote:

>The bond slave actor/partner operating state is exported as
>bitfield to userspace, which lacks a way to interpret it, e.g.,
>iproute2 only prints the state as a number:
>
>ad_actor_oper_port_state 15
>
>For userspace to interpret the bitfield, the bitfield definitions
>should be part of the uapi. The bitfield itself is defined in the
>802.3ad standard.
>
>This commit moves the 802.3ad bitfield definitions to uapi.
>
>Related iproute2 patches, soon to be posted upstream, use the new uapi
>headers to pretty-print bond slave state, e.g., with ip -d link show
>
>ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
>
>Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
>Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_3ad.c  | 10 ----------
> include/uapi/linux/if_bonding.h | 10 ++++++++++
> 2 files changed, 10 insertions(+), 10 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index e3b25f310936..34bfe99641a3 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -31,16 +31,6 @@
> #define AD_CHURN_DETECTION_TIME    60
> #define AD_AGGREGATE_WAIT_TIME     2
> 
>-/* Port state definitions (43.4.2.2 in the 802.3ad standard) */
>-#define AD_STATE_LACP_ACTIVITY   0x1
>-#define AD_STATE_LACP_TIMEOUT    0x2
>-#define AD_STATE_AGGREGATION     0x4
>-#define AD_STATE_SYNCHRONIZATION 0x8
>-#define AD_STATE_COLLECTING      0x10
>-#define AD_STATE_DISTRIBUTING    0x20
>-#define AD_STATE_DEFAULTED       0x40
>-#define AD_STATE_EXPIRED         0x80
>-
> /* Port Variables definitions used by the State Machines (43.4.7 in the
>  * 802.3ad standard)
>  */
>diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
>index 790585f0e61b..6829213a54c5 100644
>--- a/include/uapi/linux/if_bonding.h
>+++ b/include/uapi/linux/if_bonding.h
>@@ -95,6 +95,16 @@
> #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
> #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
> 
>+/* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
>+#define AD_STATE_LACP_ACTIVITY   0x1
>+#define AD_STATE_LACP_TIMEOUT    0x2
>+#define AD_STATE_AGGREGATION     0x4
>+#define AD_STATE_SYNCHRONIZATION 0x8
>+#define AD_STATE_COLLECTING      0x10
>+#define AD_STATE_DISTRIBUTING    0x20
>+#define AD_STATE_DEFAULTED       0x40
>+#define AD_STATE_EXPIRED         0x80
>+
> typedef struct ifbond {
> 	__s32 bond_mode;
> 	__s32 num_slaves;
>-- 
>2.20.1
>
