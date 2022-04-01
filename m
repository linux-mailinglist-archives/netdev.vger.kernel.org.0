Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780E84EEC42
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiDALVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiDALVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:21:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2091.outbound.protection.outlook.com [40.107.92.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E47218DA95
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dF7eENEXWmXmNWGrx/hJp8UdaI2Vb0IHKmitNt4hpBk+oO6uayP1sVs1J0jiiA+WLF1bWI3qrLoTArGsp9o3mtB9zH1+OxM2vjPN4YZbQfXfNQcyOKk59Ja9QgLrRIKZOj1T2MNWtBrIoXouSVrGePXmCE1GpCc5rrqh1M3SKvPlfHJ1opvI79CMSkFS4lg0jjKZX5ONSBPgfApngdwHr676xHhiHkZ+27T7beGBtMlXt/j+hzaPedvH5CWlAIdojb6PqSD762rNe2JXqCTYNaUj97KOqSS3+XRhCh+nn8E79eq9FaoVqavt2wg/XexuAUJIU4j/0EMSuGa8ALNsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ZziwLNX4shRnI1YVjJ47JlNKNCQoCjjUlRQW1vOnUo=;
 b=bwzDY0oR/LRM9DziUPSKX5C6qg0MjzW4WBg0g62LyUjsq9jMjCEfb9dh+ImRYlblAWxT12mILeWqxzYLWi2L9miVzLnky+9dk0Oo+F/22NVdya21aBxBOPYbrkde7UpLf+xXE9XGTM6mMkCCh+ujhUXNcO7zlnmq4+b71SLeiEl+gvMRvtmrQ47xLqJc5ZldGG9YVzHOkpw4IYIXPIzf9F3oo+LKd3itOG/eQasULd6CbuGqziluIC5QPo2Hgfro0VQsKFH5NRWfYcN3qanAxU/Fe5ML1JKhkVmY8fRuVuv5nSakHNo+j9f1BrngCG40HlWttcdOu/is227TJPXJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ZziwLNX4shRnI1YVjJ47JlNKNCQoCjjUlRQW1vOnUo=;
 b=uE2Ky2DSiyXG7MRe7uHnfb6YrijjWEc2Qc8bwy0HuP7pLX5lt0iTeFnUfiuu6g70C8wVXr9cKyLDHhWI4qtrJn9z+9V7THAxxQOx7A3qagmhDFu7SdAZ677TLye255W3RoT1nSsRrUnlF79W3kDcxbdhPbPS3vLvN/wKINffpck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4625.namprd13.prod.outlook.com (2603:10b6:208:320::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.11; Fri, 1 Apr
 2022 11:19:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5123.021; Fri, 1 Apr 2022
 11:19:54 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Danie du Toit <danie.dutoit@corigine.com>
Subject: [PATCH net] nfp: do not use driver_data to index device info
Date:   Fri,  1 Apr 2022 13:19:36 +0200
Message-Id: <20220401111936.92777-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR07CA0029.eurprd07.prod.outlook.com
 (2603:10a6:205:1::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74a5374c-85b6-4b1c-6097-08da13d18bcc
X-MS-TrafficTypeDiagnostic: BLAPR13MB4625:EE_
X-Microsoft-Antispam-PRVS: <BLAPR13MB4625026CF1A4836340BB39D8E8E09@BLAPR13MB4625.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0DwS+5x78CVvzP9SVqPQPXrcXA1pRvYqHZSijP2OqiJLduwGuwQWHqSuIdG1ZGKuJT/1IwY2rQHQsTu5dnQWdOXoTK8LM2B2naheEl2w3hUlDrMGvV5Q2yLzvY22Pzuf1BgrnOB/e3zs1Uh/JD42R6516tW9HJ6omdI9R3E875SqeDRG2j5bnHhmyV/CJowDhPX95dVbxLkA3RkEUVnmX38he+7gISWxcFjcLXPQ7IxHMw/67WnHzlcBf97CN6jxDk3v34bievjuuW8ATdOp6ZYpRysO0HA5ZUjQFmAbxtno+7Ae7I6bqhinpHl5GWV5fjf3vWxt210IzQvJoZTZlHKQ5aYZAnb3tG8fv2ZrQmkPzkfvPbwfT8bSK1iMtn6maryYPvtRdD7wQ16W1Yt6Cws57xWvlQDblspYYhM21+sw6p28/e5DPGptQj7VpusG2gicaT6RxvfK9u+25exM7qO9BeL+0ER5Bu4/FkiSz03GIKOaNFv0jhNf98RYg2biHlvHYNpuxuSNRP5NRjwrajlLiy31tJ8X8goRHy9zu1XuQQRCDNwO7BayMUNJUmqz9KZnh5il0FCGNkqty3ZJAVXKvgddHx5Un+5PIU85C0SEOCs6eH5ljcUpLOFSB3oxg45i2/mKboiUFCYIBBofxoKQ+nPzCM/bPz7b7uFe+9cuFreIyO5CKj2CJtdS9o/kE57ql1Rp5YJutPzWnCOFDRGokP2qxf5rLBicrvILGp5L6WPAW10q349pq2DeOrm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(346002)(376002)(136003)(39830400003)(6666004)(36756003)(54906003)(2906002)(8936002)(6486002)(6512007)(107886003)(38350700002)(508600001)(110136005)(83380400001)(8676002)(66476007)(44832011)(186003)(38100700002)(86362001)(1076003)(6506007)(2616005)(66556008)(4326008)(316002)(5660300002)(66946007)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekxDKzJ0K0djUVZOSkNHMW51K2g5MUlpU2dFcmdRQy9nM2FFdFNCUXVTazgv?=
 =?utf-8?B?V2tGR0xtRHhaRzRKT1JMM05qWUtzVUhsSzdrQjQrQkcxSTN2c2ZvcncrZ3Nw?=
 =?utf-8?B?U2xsTmIzMzBzRXI1L3VzN2ZuYzNQTjRJNTQ0MVV5THlNWlFLeTA1UW5XcXJY?=
 =?utf-8?B?UzN0RDJ3YlhsSGhWYkIrUWZTNlRCYzB4eUxWOTN0bldqQU95UlFDZU5STUZl?=
 =?utf-8?B?bW1SQWl4c1FUVFRwdEZrMHRUOTdyVlhscHZ2R3FYUEt5ek8vR1NxWVBBd05P?=
 =?utf-8?B?SnM5Y3F1NXNCckZwY1BQWEVrUjR0K0VzNDRZUzNHU1c1QjNFOG53UzZxamlZ?=
 =?utf-8?B?TkYvTjNiZ212MmV0SkQ1MDJJWStad2F4cHI1VVMvM1VUbi9LelJDeUNmTWlT?=
 =?utf-8?B?aHFUQVNhZVFRZjZueGwrL2JtSy9JeVg5RjJyOXg1ZGpYOWdQMlpaUENIM0Np?=
 =?utf-8?B?VWFlNWY2aHkxZlp1MVIyNzhmUVNZSDdUV1BJb2RnTmV5RzV6ZGdGMmpxWHNI?=
 =?utf-8?B?RUhHTUhBdXNHQWhQOEpqU2ZwUDB0RXhxVFVGYlhxMmU1N3YvNUpSZ1RQOUlC?=
 =?utf-8?B?OHdOWkl3T3dENTBobXdRWWszY0NQc0tnSVRGMGFaNFFnR1V3d3UxSzRPckcz?=
 =?utf-8?B?UGIwSkppVE9seWc3NWxwc0V5cFIzRFZQY29FMWZtVnNiUzZUQUtIdTZic29p?=
 =?utf-8?B?U0lCUzkwdm9YSWhVcTA2MjRXejFFY0NTOTRRWG93dGJ0aGNPdEUrd0ZCRU5V?=
 =?utf-8?B?L1RtcWQ5RmRtQVZPMmJ1WXk1RnR2R3pzYWdiMTVhMHFQUjdjUE1DWXkzNFlk?=
 =?utf-8?B?d2tXR3k1Z3Rnank3anoxbG5JeERSY2RPWDlaSE1Ja0NwM2gwV1U3M1NIVkUy?=
 =?utf-8?B?NUErUVJsYkRRYVZXcWxnaklDWmtJVnFTZTQ2anF4eUlyaEd0Uko5b3dlTzE4?=
 =?utf-8?B?VGF6TjdHWTRVaVdrM1dERWlKaXpoZ0dnMi9Eb0VUajJtRUErRXphSllnejFR?=
 =?utf-8?B?ZlcrdkV1d1ViLzd6MVNLU2J5aGc0bk12OElaRDlQdkpVaEs5SUpLR08vVjNw?=
 =?utf-8?B?WndBMDVUWjg5eW5vU0V4aFh3UWhlRVh3SUJUODZvL0h2NkZFUlJwNFdaTExF?=
 =?utf-8?B?T3pjTEc4V29qL1hoSmZtcU56dSthZTNLUzZIemowWUdZRi8xaU5UaGJTRFJk?=
 =?utf-8?B?TTYvNjlwOGY5WVJOT3htTDJSS245dXNsOGJERXVTdEtOSmxEVWRJRW1qQUtn?=
 =?utf-8?B?SjVYeTNjYlMzeXVMaWNJMS9LQ2hQK202SXBheXVjcjhpWmcvdUNPVS91bmta?=
 =?utf-8?B?RHQ0WlZEMFhYUXBpVVJnYkxmbndLcll1djlzN0MwcVpXQTFMcHNZU0FHQ2E2?=
 =?utf-8?B?RXkwN21LU2l6enUwUVM5emxqRnJPWG5RWGJFUXIyd0dRc2YwZFpNWm9wV2Zr?=
 =?utf-8?B?SERTRWVwVld1eGg4UG1JTWpuNmJaU0xkc015Tk9iZitpZWpBZkNJTmJlTzZH?=
 =?utf-8?B?a3IwSTc0QkhMaG5UR01zQXQzczBZN0trQmNrTEI0Z1hMVzR2OHlFQXViMjVR?=
 =?utf-8?B?SXhrbmxCeHNkOWltenZRdlhOdjNyLy9xenk3c2J6YytiazVKQitCbVZ3VTFK?=
 =?utf-8?B?Q0Q4by9STHVuKzdxY0dQYWZTRW56YmVxWkJSNm5hY3A2NEg3cEdTUGZ1MkxH?=
 =?utf-8?B?OVVGWFpaNXYyeityNndmQkRoNTIrbGxzN3N3cjZPM0NsSFQyektDZEVyOG92?=
 =?utf-8?B?N0phMUtOQW1UYlU0TGZKbi95OWE1dzJ0TEhQaGJpY21ISmFKT0pwTEFOdmtS?=
 =?utf-8?B?RjhyejVwUEgrQ1hxeVVmUlh4OUUxMTFOU2YxdXJqRktVSnlhR2hCV01Ld2Zw?=
 =?utf-8?B?MXlSNzJEdmUrZllZRmVwUlVzZ1pIV2RIeEh1QUZWalcrWW1URjhkeWZaUlhK?=
 =?utf-8?B?NDNDeEdTa0MwYkhvMVM4TmhYbmhxWkpXOFlSTXRwejAyN2FxWUJRQkJDT1E5?=
 =?utf-8?B?cHFUOUlZa2VnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74a5374c-85b6-4b1c-6097-08da13d18bcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 11:19:54.2115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FUJeS5djzqcFZUMZMQm0+qjVP74/RYKqdP6JixUe0ar+uPYMfM9OU20fzUvKQxyZ2IdMHaDx1NaaSIMzuJnhYUSorbUB6xuzWuWp9JNpM9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4625
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

When adding support for multiple chips the struct pci_device_id
driver_data field was used to hold a index to lookup chip device
specific information from a table. This works but creates a regressions
for users who uses /sys/bus/pci/drivers/nfp_netvf/new_id.

For example, before the change writing "19ee 6003" to new_id was
sufficient but after one needs to write enough fields to be able to also
match on the driver_data field, "19ee 6003 19ee ffffffff ffffffff 0 1".

The usage of driver_data field was only a convenience and in the belief
the driver_data field was private to the driver and not exposed in
anyway to users. Changing the device info lookup to a function that
translates from struct pci_device_id device field instead works just as
well and removes the user facing regression.

As a bonus the enum and table with lookup information can be moved out
from a shared header file to the only file where it's used.

Reported-by: Danie du Toit <danie.dutoit@corigine.com>
Fixes: e900db704c8512bc ("nfp: parametrize QCP offset/size using dev_info")
Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 12 ++++----
 .../ethernet/netronome/nfp/nfp_netvf_main.c   |  8 ++++--
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.c  | 28 ++++++++++++++++++-
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h  | 11 ++------
 4 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index eeda39e34f84..b60f2c8b6f4c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -35,19 +35,19 @@ static const char nfp_driver_name[] = "nfp";
 static const struct pci_device_id nfp_pci_device_ids[] = {
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP3800,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP3800,
+	  PCI_ANY_ID, 0,
 	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP4000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	  PCI_ANY_ID, 0,
 	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP5000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	  PCI_ANY_ID, 0,
 	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	  PCI_ANY_ID, 0,
 	},
 	{ 0, } /* Required last entry. */
 };
@@ -685,7 +685,9 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	    pdev->device == PCI_DEVICE_ID_NETRONOME_NFP6000_VF)
 		dev_warn(&pdev->dev, "Binding NFP VF device to the NFP PF driver, the VF driver is called 'nfp_netvf'\n");
 
-	dev_info = &nfp_dev_info[pci_id->driver_data];
+	dev_info = nfp_get_dev_info(pci_id);
+	if (!dev_info)
+		return -ENODEV;
 
 	err = pci_enable_device(pdev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index a51eb26dd977..c14a76b6f5a0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -40,11 +40,11 @@ static const char nfp_net_driver_name[] = "nfp_netvf";
 static const struct pci_device_id nfp_netvf_pci_device_ids[] = {
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP3800_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP3800_VF,
+	  PCI_ANY_ID, 0,
 	},
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP6000_VF,
+	  PCI_ANY_ID, 0,
 	},
 	{ 0, } /* Required last entry. */
 };
@@ -83,7 +83,9 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	int stride;
 	int err;
 
-	dev_info = &nfp_dev_info[pci_id->driver_data];
+	dev_info = nfp_get_dev_info(pci_id);
+	if (!dev_info)
+		return -ENODEV;
 
 	vf = kzalloc(sizeof(*vf), GFP_KERNEL);
 	if (!vf)
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index 28384d6d1c6f..add14704c6e2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -3,11 +3,19 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/kernel.h>
+#include <linux/pci_ids.h>
 #include <linux/sizes.h>
 
 #include "nfp_dev.h"
 
-const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
+enum nfp_dev_id {
+	NFP_DEV_NFP3800,
+	NFP_DEV_NFP3800_VF,
+	NFP_DEV_NFP6000,
+	NFP_DEV_NFP6000_VF,
+};
+
+static const struct nfp_dev_info nfp_dev_infos[] = {
 	[NFP_DEV_NFP3800] = {
 		.dma_mask		= DMA_BIT_MASK(40),
 		.qc_idx_mask		= GENMASK(8, 0),
@@ -47,3 +55,21 @@ const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 		.max_qc_size		= SZ_256K,
 	},
 };
+
+const struct nfp_dev_info *nfp_get_dev_info(const struct pci_device_id *id)
+{
+	switch (id->device) {
+	case PCI_DEVICE_ID_NETRONOME_NFP3800:
+		return &nfp_dev_infos[NFP_DEV_NFP3800];
+	case PCI_DEVICE_ID_NETRONOME_NFP3800_VF:
+		return &nfp_dev_infos[NFP_DEV_NFP3800_VF];
+	case PCI_DEVICE_ID_NETRONOME_NFP4000:
+	case PCI_DEVICE_ID_NETRONOME_NFP5000:
+	case PCI_DEVICE_ID_NETRONOME_NFP6000:
+		return &nfp_dev_infos[NFP_DEV_NFP6000];
+	case PCI_DEVICE_ID_NETRONOME_NFP6000_VF:
+		return &nfp_dev_infos[NFP_DEV_NFP6000_VF];
+	default:
+		return NULL;
+	}
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index d4189869cf7b..b0ad581d5f38 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -4,16 +4,9 @@
 #ifndef _NFP_DEV_H_
 #define _NFP_DEV_H_
 
+#include <linux/mod_devicetable.h>
 #include <linux/types.h>
 
-enum nfp_dev_id {
-	NFP_DEV_NFP3800,
-	NFP_DEV_NFP3800_VF,
-	NFP_DEV_NFP6000,
-	NFP_DEV_NFP6000_VF,
-	NFP_DEV_CNT,
-};
-
 struct nfp_dev_info {
 	/* Required fields */
 	u64 dma_mask;
@@ -29,6 +22,6 @@ struct nfp_dev_info {
 	u32 qc_area_sz;
 };
 
-extern const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT];
+const struct nfp_dev_info *nfp_get_dev_info(const struct pci_device_id *id);
 
 #endif
-- 
2.30.2

