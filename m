Return-Path: <netdev+bounces-12150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A35FA7366C3
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A6D5280EEA
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:58:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357A4C147;
	Tue, 20 Jun 2023 08:58:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F4F848A
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:58:01 +0000 (UTC)
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2043.outbound.protection.outlook.com [40.107.12.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4331708;
	Tue, 20 Jun 2023 01:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSIx/PAIIU7HuhVAsC8IEmVEPaNFl9MFQRWQpb2wO3ER9Clo+Bk5fgvr6wL3LMdXY+aHq3dG0ek1ypThv/tfggzMXPh6xq5imlSJ+8g0JVPwBggU+nJFAtlY9FQcYugkVdtevQTbBomu0qhtTasYcciz+TIzyUKWCHqtuXIsv7jZYMBuNV5CWA64kv4h0bsygELm7Uiiax83wMRKIQ/m2hZEiJOF/hTHrE9CBB2hQ8mZcygDxyr7xmVajY3uVoXMC58RGyAI9CYHg/5ilIBFpkUjlrVxiEnDkKiM2RoeoVcfuKfgFEW/4sLErySraE5I6xqusni3/WlZYA7/SUudDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fC/Jb6R30cGYs/J87811RrpiPE2r2t7JMNktTYK0uik=;
 b=HBufZU7LrlXRMYzQivhdqzfRHZdhPsppZ/4mdOyKozkKRhT282+qsbRdofLVIcrCfZQ99P1aV5nVUNb9MFk4lve9W+vdOyTadpOTyJSDEfFy1B/c8ZnTB4O9dzdLKP4CJ9xkYQvGRy0XjT096MzFzJp6df8G7H19xRNwdkPrMvoGySTqgktcY/hLtCMRYFNyuyyMzRATPYl+eaoN9Dmi/Xsd83kYLUsjLXmpzDYHX7cfQ0ixxx6BcwI8RvCfzqtiiEi/BNY6MjGV9oOX4+MOD/WI7xoi29JqicMk9d4C7ETuaVZOHIm4wbfjNl4uNtVILa9SEUaQkXc1xjMRlrFmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.6.166.170) smtp.rcpttodomain=davemloft.net smtp.mailfrom=softathome.com;
 dmarc=bestguesspass action=none header.from=softathome.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=softathome1.onmicrosoft.com; s=selector1-softathome1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fC/Jb6R30cGYs/J87811RrpiPE2r2t7JMNktTYK0uik=;
 b=RDWQLvklk97tdWaW8DdQMGf/T+pGpQ4vi8MLsaEZA+QbmVYI1iwgI+DSUeFx/LLO6B7CqtftchkDDB2GsyZmOa+UAt9qf+ssynHLLUqPzCKDSfHrPwXFZybuT3KWTk/+JIMdOGmfGg7hOz6QbQBUvfRPDQUo49vClnAnInnqAJ6kZuEjPU45ANpNK/LtLTyG9nl7zzj04r6L6cE0Gn6Do7uhh8xjgYMhX6dRPZpLunlsQ5ktcHK96gCwumlCAL/mEGDPXv1jqvDDB4W77vHRqcbo6RzbV29fiFPxHX3BYxkyWoR8fH7Me8lWSe6aGNmVkL70rAb4uFguAByb3J7Raw==
Received: from MR2P264CA0051.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::15)
 by PAYP264MB3439.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 08:57:55 +0000
Received: from MR2FRA01FT002.eop-fra01.prod.protection.outlook.com
 (2603:10a6:500:31:cafe::7) by MR2P264CA0051.outlook.office365.com
 (2603:10a6:500:31::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 08:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.6.166.170)
 smtp.mailfrom=softathome.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=softathome.com;
Received-SPF: Pass (protection.outlook.com: domain of softathome.com
 designates 149.6.166.170 as permitted sender)
 receiver=protection.outlook.com; client-ip=149.6.166.170;
 helo=proxy.softathome.com; pr=C
Received: from proxy.softathome.com (149.6.166.170) by
 MR2FRA01FT002.mail.protection.outlook.com (10.152.50.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.27 via Frontend Transport; Tue, 20 Jun 2023 08:57:53 +0000
Received: from sah1lpt481.softathome.com (unknown [192.168.75.142])
	by proxy.softathome.com (Postfix) with ESMTPSA id C0A811FF1E;
	Tue, 20 Jun 2023 10:57:53 +0200 (CEST)
From: "quentin.feraboli" <quentin.feraboli@softathome.com>
To: johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quentin.feraboli@softathome.com
Subject: [PATCH 1/1] wifi: cfg80211: Allow multiple userpsace applications to receive the same registered management frame.
Date: Tue, 20 Jun 2023 10:57:51 +0200
Message-Id: <20230620085751.31329-1-quentin.feraboli@softathome.com>
X-Mailer: git-send-email 2.17.1
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MR2FRA01FT002:EE_|PAYP264MB3439:EE_
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-MS-Office365-Filtering-Correlation-Id: 3ed9ebe7-94b4-40c0-325c-08db716c6f28
Content-Transfer-Encoding: quoted-printable
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WFvu8aFI1n8xathtM16Fm8GE6Qzfkhs+o0yLxo/NJkVqxGnkFuMwYySQymtNQzbARsjlGsA2iJWbDebRIZabQFE8F3DBrjB3tpEIS6l8DrYJiRNebVavVbE1y/UHp92N/lncvNQRnIP/HEwm4DPj3zitS3lHrk+wtDvHwyhDMDlSyJvI1nGAq1LXE/i/LFnkXJYW7oH0PA/GGM7lCVemswDPbBYwG3H9ZcQ+LFqjJHeQdYWxFbWgNaTglqilX+CEWmNek/qma+eAgY2GD+0XVpOJ8RpFbjZ2+Au4KWhd1ZnpgZ2gVC6ZyGUEntnPBwjtyy1AidJrWbKlD/nr74tSMhW23Kml2c7TR4fW04NHsc4lp2FS2+pTbBqTTtCQspBoWE5+qYK8eNS0ptSgxHWCrDo0NTFfDJG29ueBnvcc1sImlARVHmqG7Qk0N4f58yVdliHwjvTKUmP0GK/wjspRQ4YyI2819ixNxn8iK9uIzvIm51XwPigzicX5UyTmcYO2s4MCRDpCcTv6W18WvIho39hbq9sOpMv7Giu5QGaq9ajVcL32YsnaAT2XrwNYFyU70g3FqFPEoP1G/O5qQNnjqpohsA6v5jORBcY5tvzaeSk+JQfgpeSigdvBG3YR2gUSS6OtYLN9wX19NwUs0NlXkqSNeoSfg0kTCH2hnhSv4DbYeFTPYpIIwf5qKMkxgwJPQnyumPb1crsOM/LjTJBFNTE1T+MnqlXH8GOzgeTphinmnHpFuiDJFWPRgxbMxQNW87y46dD5ZaU53buGg11ylA==
X-Forefront-Antispam-Report:
	CIP:149.6.166.170;CTRY:FR;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:proxy.softathome.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(2906002)(186003)(7696005)(82310400005)(82740400003)(356005)(2616005)(81166007)(83380400001)(82960400001)(426003)(1076003)(26005)(336012)(6266002)(47076005)(36860700001)(41300700001)(86362001)(478600001)(6966003)(316002)(40480700001)(70586007)(70206006)(8676002)(8936002)(36756003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: softathome.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 08:57:53.7587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed9ebe7-94b4-40c0-325c-08db716c6f28
X-MS-Exchange-CrossTenant-Id: aa10e044-e405-4c10-8353-36b4d0cce511
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=aa10e044-e405-4c10-8353-36b4d0cce511;Ip=[149.6.166.170];Helo=[proxy.softathome.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MR2FRA01FT002.eop-fra01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAYP264MB3439
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, only one application can listen to a management frame type.

Signed-off-by: quentin.feraboli <quentin.feraboli@softathome.com>
---
 net/wireless/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index ac059cefbeb3..0f2e83fa63cb 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -572,7 +572,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wd=
ev, u32 snd_portid,
        list_for_each_entry(reg, &wdev->mgmt_registrations, list) {
                int mlen =3D min(match_len, reg->match_len);

-               if (frame_type !=3D le16_to_cpu(reg->frame_type))
+               if (frame_type !=3D le16_to_cpu(reg->frame_type) || snd_por=
tid !=3D nreg->nlportid)
                        continue;

                if (memcmp(reg->match, match_data, mlen) =3D=3D 0) {
--
2.17.1

-- This message and any attachments herein are confidential, intended solel=
y for the addressees and are SoftAtHome=E2=80=99s ownership. Any unauthoriz=
ed use or dissemination is prohibited. If you are not the intended addresse=
e of this message, please cancel it immediately and inform the sender.

