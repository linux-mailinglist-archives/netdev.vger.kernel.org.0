Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8EB3875C7
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243704AbhERJzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:55:35 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:13665
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241006AbhERJzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 05:55:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bzty9kL/qPu4vYKLcHGc1UCpGHFoD7D5pxcCCMU7JKWoqm8JvOyl4kQPHUWnJ8jzr6TOVHQyHvWxd5bZKhPn1PbYMxBr0tyybSiWhgfforlpEQNPwmjj2+tBE7Uwt4jNROBTTwMVCFlw7Af65+GIsw6lt1issFc9tZmcRCRiPVPuDefROg15YVsoAwePhZHvoNE5mX5RpOBjv78FjJ2hfQKj1xfutUx1lzOQ+Dp8jb6mhPcTUVUvgfhp1tOP2wZJr5//q9x2INN2XkEJYPDoSYNjA8WAXs5PUVfJ+XPNOGaCH3HZuB9m3omwRe2OYzZW7YqDeIcI6i1PxiovUt609Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHV1G0arD6LNHZBH9aCDSe2Lty9O7IIiW6TGq6igs4A=;
 b=iw43MsFFhaK0ZQw4DfMaNRkfuWU0v0/jJs38OA/Tjgxdwc3PNUUnM4qDsH0qO7DpiX3mIBX1Au4vX/dWMnG6TrAnS1GfIXQG8PJfPvctjP5nRDsGmfTP+JAlgnCXCTjhGy9sVmMTuJZ7Tf7dp5CyLzV94xfcTEFFdimvCWu3qsCFNA84CXjVYFYX5SV9ZKkrgZBmZRZi9vvWCb1gvZbWGTRwppVPnjb04zI6lJHMRY9LFIxnKEm0GRZfaVNQIhc5yi1s9lx6gtO1eBLMKjeouST3NirxHiG72UJdyhokgZroWEVad2866BQ44Kz319XXeTWDa9noU8x0FgenIkaBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ipetronik.com; dmarc=pass action=none
 header.from=ipetronik.com; dkim=pass header.d=ipetronik.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipetronik.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHV1G0arD6LNHZBH9aCDSe2Lty9O7IIiW6TGq6igs4A=;
 b=OuMoqq1w581NgPjd95TjWszuQjwbeutqhsyt1BaDZH/FdfO3xSwCiPcfJ0d3QwI7SfVeH69Cy3BDSsOqrKdcLSZIpAZ5d/lxPLx975uwgwAo6ZA0sxcnl8UrKhiz5OMjuJZtbzauOmR1Hj9nKrFsGfePziLSmnqRpeJqU1nq4ikjmb+rco3avBS8ihAnxK4YnnjDA+R9HE8Qn5ObyRbhKEbpAe1UhdZok5alMMnbSB9Nxk59pSFYub/Bk+C9xJ5Goij3B+Kk+rhgVm9K6cX1SOQ0OqkfFXs6AmtbsOimkTefaSlbAaTSI77HoEDlKg5jfc3FSENwjV19Hoakq+DDJA==
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=ipetronik.com;
Received: from AM9P193MB1572.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:307::12)
 by AM8P193MB0980.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Tue, 18 May
 2021 09:54:14 +0000
Received: from AM9P193MB1572.EURP193.PROD.OUTLOOK.COM
 ([fe80::61dd:f44:3cc1:6126]) by AM9P193MB1572.EURP193.PROD.OUTLOOK.COM
 ([fe80::61dd:f44:3cc1:6126%7]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 09:54:14 +0000
Date:   Tue, 18 May 2021 11:54:11 +0200
From:   Markus Bloechl <markus.bloechl@ipetronik.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        markus@blochl.de
Subject: [PATCH net] net: lan78xx: advertise tx software timestamping support
Message-ID: <20210511161300.3zsn4ufutgwzvst2@ipetronik.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2001:16b8:2d18:e300:228:f8ff:feed:2952]
X-ClientProxiedBy: AM3PR03CA0065.eurprd03.prod.outlook.com
 (2603:10a6:207:5::23) To AM9P193MB1572.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:307::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ipetronik.com (2001:16b8:2d18:e300:228:f8ff:feed:2952) by AM3PR03CA0065.eurprd03.prod.outlook.com (2603:10a6:207:5::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.32 via Frontend Transport; Tue, 18 May 2021 09:54:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8802749-715f-458e-22ae-08d919e2e4c2
X-MS-TrafficTypeDiagnostic: AM8P193MB0980:
X-Microsoft-Antispam-PRVS: <AM8P193MB0980B2F43800237A3742EC5B922C9@AM8P193MB0980.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zifY0FZOdE9atCWVwZRZYTpPHvfWfSXU9rz4yoqaVndu17hjs0CjhEcrzKj607gQFx3elPeSCplytu3IG554SnQ81IE12tGrdkCSFj5W1ikXRUtFVpK/aL8rnOvpaQVW5Pq+WJCxRd6STvG3dzkBvOh3i1ZPUr4HFLdCy7nL48D3NNkcjQYoROc5T7N3Myq5/mVCUHQfYOihE4C+gOcplZnVrPuPSXAIg9MCg3lEiZ8hbJ0enlm2SBh75YSAeo2CYTNf9xv/58zy7UVm5PwDI05r7EZCDbcFWlChCM5BsmWtpxu7RkEh8qOqKDTVLAiv5F9Vmv/avNLlXNRAg3U7B+V16qdXfn/w12zx8axD6b0ZZDk2KU7vny7rSuY/yYkf9Gz94mo3lOxyKkBo/L4vUWSaGXoA2rUHw3ZkYm0D7DNL/JF3ZRt58joihzwpwfpgFzeL3hQ0vPOriKs5MHNod9EUXjKTRdM4OBbhy75icj8OQ/Hgqi21kNbQ/UU7SNN8Yz/nlwjaHeWGIQDwhzn6TaESuaA/zVqqtj6w1qJzBtl92pNm5Pg6sc0I39Q+w4aHUPzIUyt3/Rf+OABqEzw6/RuXlmm7y1XmvGaTvXrk6Hc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P193MB1572.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(39830400003)(136003)(376002)(346002)(5660300002)(38100700002)(16526019)(86362001)(36756003)(2906002)(55016002)(2616005)(8936002)(8676002)(8886007)(66946007)(66476007)(66556008)(7696005)(52116002)(1076003)(186003)(478600001)(110136005)(316002)(4326008)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Vzl0YThNUmJLT1NJb1JSdVpsdHFhbG1XVWs2a0xkOU9KOFpjQVNKNGpkdFpV?=
 =?utf-8?B?cE10eS9Oa1ZuQW4rcUFEckVGL3h0dlN3UUQyUldwWVRnQ3BOekxEN2d0emZj?=
 =?utf-8?B?OGZac0VnUzcyMEFWRXpXblE5cjlFVnpOalhYSWZheFhvK1ZFOWZBMXdZdGxC?=
 =?utf-8?B?ZUVwZU9DdE4zWlJSdW45Z3NVWmc5TTI5Vkg2WlFaMjg3a3VFMThwQkhhcU5L?=
 =?utf-8?B?aUVHeGdyQmQ0N0NHWVNQYWwyNjF4S2NndisxSytDMWdVOXF6c0ZoT1JYQ3RW?=
 =?utf-8?B?SjBvdURBV2t3MHZMdHJEd3pWQmhVdWt5c2FiNWg0NWJhWE1tT001bmpIcW9I?=
 =?utf-8?B?aEt4NFRMV1N3RUtGSDJuNitVbFFyQkVzWGc4NVVpejhXM0hGMFErTWJycUds?=
 =?utf-8?B?N1E5QjVQSmNwVjZxVjVCSmlGRU5HZHpSSWFOd3NkOXZITVpSRmFSOGovNGhD?=
 =?utf-8?B?eGE0dzFSWEZWSmhmWVoxYmdoK1IzZDdpdTlHN1V3cjc3d0VOUE81c1lGNW91?=
 =?utf-8?B?Z0FOVjFHT1Z3QkxjLzFZZHFNWnhudUd0WTFJVStnbnUzQ0lYVHBqYlNQaDF1?=
 =?utf-8?B?SWFOTmM4T05QVWVsUFNFZWUxSHFkWS9nOEFPR2RFZDlLbHlHRXR4M0dxRDlG?=
 =?utf-8?B?eEpxR255M2hxN0owbE03OURGdm9GWWQ2ajdNNDhzSnlnRVl5Rk8wTmZMNU9Q?=
 =?utf-8?B?dDd4TVdnbnBSMVhwM1Q2QTlHSklqRGRaUzNWNjBJRXlqUVFFTmYzSm11RU03?=
 =?utf-8?B?ZC9DdFlndjJSMk5jS2FoeEpCWGhlVy96bzRJQ0FDaUNiUmxWNzR0WlUrZmhm?=
 =?utf-8?B?bkxLN2hUMjBHOCs2U2kzWm9qWXNSdHFPcXZiM3ZLYmlKV1ZZUERmaVk5M0lO?=
 =?utf-8?B?QzZCRW5wclpGSzV6Q1A5d0RCNWg5dDg1WElqN25DWHE5d1ZKS09YNFpML1dk?=
 =?utf-8?B?aHRiMjNDSHgyckFkbGl1L3BwYXFwNUJhRTFsSzZXOXZsU3dteTJ2K2xqUlJL?=
 =?utf-8?B?WHpZQVdiYkRtQWpBUkg3Z0MxOHdDRi9hdDZpMGRnOWcwMnJPZytVZmdQYlVG?=
 =?utf-8?B?VWgwVkk1TnA3VktOcjFNSUMyVFR6M3FsWk1oRDQxNnZMZG5pSStuTFg1U2JR?=
 =?utf-8?B?ZXdBa0N1bGpGZ1Y0emlzOEpicU5DNWJ4RzNocTlXZDdoZVFVK09aTGtkc08v?=
 =?utf-8?B?M3NjQzdHT2Z0a3hCL1JaTTJXOTJrdTJNS1VVUEZydXVXVzFlcFU1ZlhUN0wz?=
 =?utf-8?B?eGFLVmdqNVhqNkF3ZDBKNy8wRjRwMkJXSnMramlRZC9QREk3SnVSMUYwMk5s?=
 =?utf-8?B?UjZ0TzVLajZSa0VuSWNud0lFOCsyQ0V0R20zbmlseXZUYVV1a1VGeVk2N0dp?=
 =?utf-8?B?Q3JPemdaMnVGRnUrSkVOaXRzNFAvU2lpVGFUaWxtVlNZZzJPdldwVlR2U25I?=
 =?utf-8?B?amVEVkxnL0NDYjhOZ3BUaG9hMFgxUzZadzNZK3NGUmt0ZzB3T1BzRFArL2VI?=
 =?utf-8?B?U2NweGVjVnhNa3RHbXZ5Z0x6WUprUHVuSDlWd05yU0hIbDBlU2NXZmZzdFAz?=
 =?utf-8?B?Y2szVTNLKytWampxcHhtRDBsSExmNHhyOXVtNkNYMTl0WkQrdElpalhseU1F?=
 =?utf-8?B?NWo2TUhvdVVWbG9iS1p2SGxHZEg3UDFIWmRHK1Jlajh1UjI0L21OSG5JK2hl?=
 =?utf-8?B?S1VzRGtiQkNkczU4a3E2eHlkMnFRd1RlVk1GNi91VDlGcGUxMVpybllzaFNh?=
 =?utf-8?B?NGsremdmMHgwZitKdHorSGIxWHNQM3pDTEhyZ2I2ZWd4MGltMTE5ZjVsclZk?=
 =?utf-8?B?KzZwbitWVDl4eU1oMHF6YUlUM3N3bTVsVGxodnNNbGFXemZRUVNOdGpiLzIv?=
 =?utf-8?Q?7fXkg9jhlGIDi?=
X-OriginatorOrg: ipetronik.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8802749-715f-458e-22ae-08d919e2e4c2
X-MS-Exchange-CrossTenant-AuthSource: AM9P193MB1572.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 09:54:14.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 982fe058-7d80-4936-bdfa-9bed4f9ae127
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdPtC87PxxqnnkOQLK7bUKxmThdgIMa0AtLMlrvFh6s8yMSejbZA7Lvm7fmbxUQPVhxDrqy8nhvrs8Zmk4fjmNr+u0wNAIgGJBfjwSaO2tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P193MB0980
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lan78xx already calls skb_tx_timestamp() in its lan78xx_start_xmit().
Override .get_ts_info to also advertise this capability
(SOF_TIMESTAMPING_TX_SOFTWARE) via ethtool.

Signed-off-by: Markus Blöchl <markus.bloechl@ipetronik.com>
---

Notes:
	The main motivation for this patch was that e.g. linuxptp refuses
	to start if the driver lacks support for the required timestamping
	features.

	I also recognized that many usb ethernet drivers which use the usbnet
	infrastructure do not override .get_ts_info accordingly, despite calling
	skb_tx_timestamp() indirectly in their .ndo_start_xmit handler
	via usbnet_start_xmit().
	For most of them the .get_ts_info override from usbnet is lost when
	they override .ethtool_ops again.
	Should they all receive a similar patch?

 drivers/net/usb/lan78xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 6acc5e904518..02bce40a67e5 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1645,6 +1645,7 @@ static const struct ethtool_ops lan78xx_ethtool_ops = {
 	.get_strings	= lan78xx_get_strings,
 	.get_wol	= lan78xx_get_wol,
 	.set_wol	= lan78xx_set_wol,
+	.get_ts_info	= ethtool_op_get_ts_info,
 	.get_eee	= lan78xx_get_eee,
 	.set_eee	= lan78xx_set_eee,
 	.get_pauseparam	= lan78xx_get_pause,

base-commit: a6f8ee58a8e35f7e4380a5efce312e2a5bc27497

