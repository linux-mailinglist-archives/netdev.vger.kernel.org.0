Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5811638039
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 21:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiKXUig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 15:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKXUig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 15:38:36 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2134.outbound.protection.outlook.com [40.107.103.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB006F0F5;
        Thu, 24 Nov 2022 12:38:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyzxwSMLy6b/EZ7w0FnY1GpOHrLpkZEtjTqxsMmppu2pGJAAy5+6GYgqrH/Fe/xTBHb/kM9djvR08dRlaKY/7Aqgsgpguyep6BUPqJsSdQhTUrjIcIKIR92fHq/lk0qOXFiKi5CeNxnZjD3VMWhNY888t3wtVE6ssI7wTS54eIc+IWa2kg/tqwR5fgZFxiolhLaTedgKBOGJGnmvYfygwbO+nx/Hbdcf1sl94hEa85SZB5mhmWP9s7CQ9aGcNdeSqZGGYE0GPX+jpPknrcCygdTFgtPYWzEmRpHiCe6slirkdJfEx6Voiw6wNpCw0jH+S3qCTdOUGJYitc9nHufIpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEpFpQvG2hQcrhr+X+kHFhsOWxJYu/hfLkAJ8Hj89Lo=;
 b=OZIqF9UQyr0XPlBH3Bv7k8L5CsEj96GMFiSjsDa8QxoU4nXr/YWaJ1elhsb/IgHg7cyIPCEAWgiKyOw89Ou0WlFBFQwCG2oeroRkHO512taS7IEeCBquQ8XTFIU0eP/m1SwlxTJge7hZAyn78qIpSi1EWGqWMQ436AXMOmaEl1SPW1eHSfHL7lLba9wusmE2pJ9MtfCbfSSa3IgmD+uV7MBnVjp1dlxjTP0WIXL/Z84iEkSpneiizeOt0T2X0UDgcpBGYqWLVRJoRZ4vIBmeB/nh5vQ0FXYZi/61I0Eulm51V9xc9F/93Nu4/oljmXveGy0nJL27bx+uym+EUJBRlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.14.233.218) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEpFpQvG2hQcrhr+X+kHFhsOWxJYu/hfLkAJ8Hj89Lo=;
 b=r+tz7h3NMakGDVLfc6Unjfamo7xRZ2i4xzspT48OWIj2BYafuLUezvJaRjzOlEs8OgAPZu4xxb2srhsL/JOHpwOpJ2sHeI6ZY8nA0FQ/Iqaa05bX4xSFlKGztIf9z3/GJ5uTtkMZSaN93XuJu1VBToiPN0PsfKF6Qm7Y7AVM7Ds=
Received: from DB6PR1001CA0027.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:4:55::13)
 by AM7PR03MB6563.eurprd03.prod.outlook.com (2603:10a6:20b:1c3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 20:38:29 +0000
Received: from DB8EUR06FT027.eop-eur06.prod.protection.outlook.com
 (2603:10a6:4:55:cafe::e7) by DB6PR1001CA0027.outlook.office365.com
 (2603:10a6:4:55::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 20:38:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 81.14.233.218)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 81.14.233.218 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.14.233.218; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (81.14.233.218) by
 DB8EUR06FT027.mail.protection.outlook.com (10.233.253.49) with Microsoft SMTP
 Server id 15.20.5857.19 via Frontend Transport; Thu, 24 Nov 2022 20:38:29
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 2E4867C16C5;
        Thu, 24 Nov 2022 21:38:29 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 202C52F0710; Thu, 24 Nov 2022 21:38:29 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH RESEND 0/1] can: esd_usb: Some preparation for supporting esd CAN-USB/3
Date:   Thu, 24 Nov 2022 21:38:05 +0100
Message-Id: <20221124203806.3034897-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT027:EE_|AM7PR03MB6563:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0d73e47c-471b-4ea8-3a11-08dace5bd87a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RdEUG3OF+X+Zfq3hbhS26TE6a+62ymUzBKu6dNYoX2AZokrei1DkQX9tChybSWrOR3r2hJLwvNRgCJnG/5QCtSBqdD1EO55IEC3HRci6CjRH0gdEPcBtIOnfRlK/YRyCJVlhE4qu5Jrye8e5DD67G6jwIv5deOdWca8kGgGDXgH/l7uO0MSP41bm+PlYrb6F3m3hz5rx0GouN6VGKz/TMaqkDRO5RJhbgklXz/w2yRDV0OCSccWWzeDWmmfgWmtUZhxu4O5/nMEDHB0TLcmrUn6w+xXWJ/mvfcApptP9CUvO8DbhUGY6guyJaH5+beLQx4qJaGnpzDOCA0AGiCzmC0g3JqT3xa1x/6S3BalppzPbcTdCJE/M7sDOjWYPviP6AbrevVYchahz06u3N2cUyM+zmfQLGck/UNf7sRmTYCSz/Zg0yIdTaJpLr+DdFe6/a0K5EiA/4sqJKWfPlwwl2D4WoJj0SmAIlMTjkVZrm48S/YOIqxM8Tf5NAjC11LokKrrePhbc+5NlmeTgQzyMO+PwcxcRfCCZe7sBBLLjQJm3+coC/sCfGws0RXSLZZysp47nc3dXz4Gd3IkIU+aG/a1XddW8vK0phJ5bwu5RUnOul2rVARGIO3GmLZ/Wh5dYpMyKHK27JbWCYtgcViwUMi12B0lTAGgOpY6SlmuvcONXWNGd+qF9IadWtEPwfindya91vnkRDHg10N/3ZpTnZQ==
X-Forefront-Antispam-Report: CIP:81.14.233.218;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:a81-14-233-218.net-htp.de;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39830400003)(376002)(136003)(451199015)(36840700001)(46966006)(54906003)(110136005)(42186006)(316002)(83380400001)(36756003)(36860700001)(70206006)(41300700001)(4326008)(8676002)(70586007)(966005)(478600001)(26005)(6666004)(336012)(47076005)(86362001)(6266002)(1076003)(186003)(82310400005)(2616005)(356005)(81166007)(40480700001)(2906002)(8936002)(44832011)(4744005)(5660300002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 20:38:29.4487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d73e47c-471b-4ea8-3a11-08dace5bd87a
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[81.14.233.218];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR06FT027.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6563
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Being sucked into another higher prioritized project in the mid of
July, my work on preparations for adding support of the newly available
esd CAN-USB/3 to esd_usb.c came to a halt. Let's start again ...

Here is a attempt to resend a slightly overhauled and split
into two pieces version of my patch series from Fri, 8 Jul 2022.
Link to the patch series in July 2022:
https://lore.kernel.org/all/20220708181235.4104943-1-frank.jungclaus@esd.eu/


Frank Jungclaus (1):
  can: esd_usb: Allow REC and TEC to return to zero

 drivers/net/can/usb/esd_usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


base-commit: 3755b56a9b8ff8f1a6a21a979cc215c220401278
-- 
2.25.1

