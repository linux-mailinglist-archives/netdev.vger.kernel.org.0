Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929815FFF4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 06:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfGEELe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Jul 2019 00:11:34 -0400
Received: from m4a0040g.houston.softwaregrp.com ([15.124.2.86]:42527 "EHLO
        m4a0040g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbfGEELd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 00:11:33 -0400
X-Greylist: delayed 959 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jul 2019 00:11:31 EDT
Received: FROM m4a0040g.houston.softwaregrp.com (15.120.17.147) BY m4a0040g.houston.softwaregrp.com WITH ESMTP;
 Fri,  5 Jul 2019 04:11:09 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 5 Jul 2019 03:55:00 +0000
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 5 Jul 2019 03:55:00 +0000
Received: from DM6PR18MB2489.namprd18.prod.outlook.com (20.179.105.16) by
 DM6PR18MB2617.namprd18.prod.outlook.com (20.179.106.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.15; Fri, 5 Jul 2019 03:54:59 +0000
Received: from DM6PR18MB2489.namprd18.prod.outlook.com
 ([fe80::c953:1927:cc0a:dcae]) by DM6PR18MB2489.namprd18.prod.outlook.com
 ([fe80::c953:1927:cc0a:dcae%7]) with mapi id 15.20.2032.019; Fri, 5 Jul 2019
 03:54:59 +0000
From:   Gary Lin <GLin@suse.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Fabian Vogt <FVogt@suse.com>, Gary Lin <GLin@suse.com>
Subject: [PATCH] net: bpfilter: print umh messages to /dev/kmsg
Thread-Topic: [PATCH] net: bpfilter: print umh messages to /dev/kmsg
Thread-Index: AQHVMuVq9g8KWKKxoUWlkj3q2G+15A==
Date:   Fri, 5 Jul 2019 03:54:58 +0000
Message-ID: <20190705035357.3995-1-glin@suse.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: DB6P18901CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:4:16::20) To DM6PR18MB2489.namprd18.prod.outlook.com
 (2603:10b6:5:184::16)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=GLin@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [202.47.205.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b44212e1-23e2-4b23-61dc-08d700fc8c71
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2617;
x-ms-traffictypediagnostic: DM6PR18MB2617:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR18MB261755828AB002A4E84266E4A9F50@DM6PR18MB2617.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:236;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(376002)(366004)(136003)(346002)(199004)(189003)(6306002)(53936002)(1730700003)(8936002)(8676002)(81156014)(81166006)(80792005)(486006)(476003)(2616005)(6512007)(2351001)(305945005)(7736002)(54906003)(316002)(36756003)(4744005)(15650500001)(2501003)(5640700003)(6436002)(6486002)(2906002)(71190400001)(71200400001)(86362001)(66066001)(102836004)(5660300002)(26005)(25786009)(68736007)(52116002)(386003)(6506007)(256004)(107886003)(4326008)(72206003)(966005)(66446008)(64756008)(66556008)(66476007)(14454004)(14444005)(73956011)(66946007)(99286004)(478600001)(50226002)(6916009)(6116002)(3846002)(186003)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR18MB2617;H:DM6PR18MB2489.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bML6x9x134yO1xSjSHZPt9m+gvP1E5COTz05/qTopEneCS3Pgwm/3VingXY9sl7dJL+8tz8iyaiPSNGPOvEPGzY/APlE5FmlVeLI8hUPn9jU05NOCdvEKJD97gFsN4yc4nXDo1MyfbpohX0no4q62C/RF6ZUUvoyecFQ2sxhavHizAtRDyClM/HVkukLHym/vEiEnEq8U+0W4MxwulLrtWR/MCEPYsxAfurXtYlVHUAzOCFJYElX4DPipeRrBufKF4G1qdf9yj2CYRMHlby6U3QffYQ4Vkrzx0navKTVSpuLvhWOw7AAZSmXsmTzxlmHph4p1R3G0NA+tksDC2wq6JHMZg+Wm+7fPLh6S0g2wZRL6ZnZ4PIS9guPAicUGruzfbnytkRVnIyeWGXGsMw+BOyJos/0by2U1jo8W/WJRLg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b44212e1-23e2-4b23-61dc-08d700fc8c71
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 03:54:59.0000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLin@suse.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2617
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpfilter_umh currently printed all messages to /dev/console and this
might interfere the user activity(*).

This commit changes the output device to /dev/kmsg so that the messages
from bpfilter_umh won't show on the console directly.

(*) https://bugzilla.suse.com/show_bug.cgi?id=1140221

Signed-off-by: Gary Lin <glin@suse.com>
---
 net/bpfilter/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
index 61ce8454a88e..77396a098fbe 100644
--- a/net/bpfilter/main.c
+++ b/net/bpfilter/main.c
@@ -55,7 +55,7 @@ static void loop(void)
 
 int main(void)
 {
-	debug_fd = open("/dev/console", 00000002);
+	debug_fd = open("/dev/kmsg", 00000002);
 	dprintf(debug_fd, "Started bpfilter\n");
 	loop();
 	close(debug_fd);
-- 
2.22.0

