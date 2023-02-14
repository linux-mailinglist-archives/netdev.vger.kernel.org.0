Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317C86968B5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjBNQCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBNQCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:02:45 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2111.outbound.protection.outlook.com [40.107.241.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319012BF03;
        Tue, 14 Feb 2023 08:02:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEXrwto8p/T0S6D6r5AmpfWF0hwhQhFWdtR1aU6EmSeTiuN8jN6dfSlW9IstACi0UY0xS5sesHdXBFki872p36DHg/bIG/YPw/eYGSf8Z4BPVetqvEEnravOq1J/xSF2pDnQ0r5fuWexeLbg6GC/uCuRlTJzhDHmy5AproSj/mCH5fNG2sra+dczDyrHpmWU7fJ78UCN5NGUvLlBEvVx3WiPa6oQfLi8//rrLz7HfTC4nTc5W6SMvbnWaIfuEfWGM/l1Sat290oVisTNV1m1+jK86at0nyQLrx9jBBpEW9tNDmSZIXk39HQtg7ROrqZZO8WsynxtZzVQKKKpsudVjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZ7crUH7ogiA9pYYJzwdP6/8qOecBgv3FRlNza3gMog=;
 b=WEEYW2ZJPA8heXUu5BXvpqmFS30Uq7xFlP+VRNc9/OtRqzeBUHIOJ1u1gkcSDqnYJRY1/lqYRG7Ut+yw9cXzDmiqmc8NuK4y2iIKVB4+OF9hji0+HiunWHlrrjI63JkQaRxnn1ZdALTByISUWdsesHTLq8nJoChOZjLlg/g/WkRs488rdiYTg1xP+YRZEXFRxVkRCGWJYC31IbYRa7Ov4PDmNVV+O4/wVVk8KYD/oMWayx9pc9J2x6EJ0YWqdpB6mKAiOYbTDx9VYzWBP+U8JR588VTFnGJ2+GqXqNKiAzPgPrq0m4wXHhJAKNW5Sc9/xPfHZoR0EI/CljC0ZNwZCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZ7crUH7ogiA9pYYJzwdP6/8qOecBgv3FRlNza3gMog=;
 b=Nag61gW9U8QjEtud4GscEiO2j0JoEtzXNmQcA7X8fpNqJh8LPSSs5AGXTAmcv8WkmX83FAzAd9PpaKfgKPkdHitQZMDWZq3fi0Ui6T7QzTx2LBXZlfSA4J1QHEOn5DZrxP9ZgnJTZK96vDOJPDTKjytT4ndKnwV/i855aKPvVm8=
Received: from FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::15)
 by AM0PR03MB6196.eurprd03.prod.outlook.com (2603:10a6:20b:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:02:32 +0000
Received: from VI1EUR06FT032.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:1e:cafe::f6) by FR0P281CA0090.outlook.office365.com
 (2603:10a6:d10:1e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Tue, 14 Feb 2023 16:02:32 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT032.mail.protection.outlook.com (10.13.7.224) with Microsoft SMTP
 Server id 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 16:02:31
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 8DAB07C1635;
        Tue, 14 Feb 2023 17:02:31 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 7C8292E0125; Tue, 14 Feb 2023 17:02:31 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 0/3] can: esd_usb: Some more preparation for supporting esd CAN-USB/3
Date:   Tue, 14 Feb 2023 17:02:20 +0100
Message-Id: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT032:EE_|AM0PR03MB6196:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 90b4db36-0cfa-4f38-9d7e-08db0ea4e146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qos/81rnq23GG/ZzeQ5FpZVRqDc9AKzuTanJppRV2z3Fs17IYLBrUeNi0Qy5mOoVkPXKGAsEuFQ/PEZ5Qf1ppdwuDeSr0FQz4hbc5Op6yDBZpGztXl+ahRu1e5UAn+hZIeq1IuMP1Qtypk/s6xiHZmlVx2RX9/qQtEj6a3K81ejijmf1aVDJKy/ucwHZQ31A4FzipLqZDmU5iRCXX7oqgl4Ko8Iht9zfGL51RlQJ4/hUiqAuRSoD7wHib6mdx59NA1T7+mr8+4Sy5zmwOH8vz13xknvQvPZ9j6VLQirVDwIR9yzjsyeCGipuGPSuvlDO5wJYai/LpD7Iur8rXQmwJfb0uS0HAWfl9oAjQ+/I8OWMtQFnge+0BCYBQ2l0KAwtAQzIwOlvvAYRMGVRrZTwYrK8vZKQn1YsQKi6zoICdKjYddHW1GheahNwZfnrf0ME6z337wLFOAYkPmkcAfhJCfuu4isATSf1VOySgNOSCk4IfrpRmU7lEVUH+lrWw4Fi7hHkg5/Ga8AxqjiJSEgEj4XmUj7GQoLP0B5f+6uaTMX7XPPA8O0pZp0cDtqIeOAt29701gJBv3Knf7EOoJgBaNo58mkGkMEwb7BEYhR/a1mrAv4iofT8CaEJDaNtIej++VzuVFQRdAPrpkP/hYqwK4ljCqFUXh2YQ40GaEtCScA=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(136003)(376002)(396003)(451199018)(36840700001)(46966006)(1076003)(356005)(40480700001)(5660300002)(44832011)(6666004)(336012)(81166007)(2616005)(36860700001)(26005)(478600001)(186003)(6266002)(47076005)(83380400001)(36756003)(4326008)(8676002)(316002)(8936002)(70206006)(70586007)(966005)(41300700001)(86362001)(110136005)(54906003)(42186006)(2906002)(82310400005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:02:31.9202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b4db36-0cfa-4f38-9d7e-08db0ea4e146
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT032.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB6196
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another small batch of patches to be seen as preparation for adding
support of the newly available esd CAN-USB/3 to esd_usb.c.

Due to some unresolved questions adding support for
CAN_CTRLMODE_BERR_REPORTING has been postponed to one of the future
patches.

*Resend of the whole series as v2 for easier handling.*
---
* Changelog *

v1:
Link: https://lore.kernel.org/all/20221219212013.1294820-1-frank.jungclaus@esd.eu/
Link: https://lore.kernel.org/all/20221219212717.1298282-1-frank.jungclaus@esd.eu/

v1 -> v2:

 * [Patch v2 1/3]: No changes.

 * [Patch v2 2/3]: Make use of can_change_state() and relocate testing
   alloc_can_err_skb() for NULL to the end of esd_usb_rx_event(), to
   have things like can_bus_off(), can_change_state() working even in
   out of memory conditions.

 * [Patch v2 3/3]: No changes. I will 'declare esd_usb_msg as an union
   instead of a struct' in a separate follow-up patch.


Frank Jungclaus (3):
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (1)
  can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (2)
  can: esd_usb: Improved decoding for ESD_EV_CAN_ERROR_EXT messages

 drivers/net/can/usb/esd_usb.c | 70 ++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 30 deletions(-)


base-commit: fa1d915a624f72b153a9ff9700232056758a2b6c
-- 
2.25.1

