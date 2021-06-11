Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254323A44DC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhFKP0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:26:23 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:38374 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhFKP0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:26:21 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BF93ko024796;
        Fri, 11 Jun 2021 08:24:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=f3yzJkJ3b8DcesJNGxv58s107zaJUGuIZYhDN31lYfo=;
 b=fC7vsqxPr7FcUGTCROlOS8xP8fKrGXPQrPHHKrAG3kb1pVHsKCjKyHcwz0ZAyiub16W6
 zXMJFVMWioRxUzgJUrJkGkXZVIhXVN8IIT8AuiYUDboHRUUXPCZOQdpwFcHhYAPBjfFv
 hxYIm6wDrVebnOIP9GSnM0zWmfMdihUE/YotK2nsFA5/FayZLA9YgX0RhfdO6xDruNO+
 SEljVG3Yy+95/alT1vnppTTqCfXJ0CVWTsIaz/fQF8RwHZbgslBs1m1WJ+tjLJCPrWIP
 SXQ8d8Bfnl/igcSiTYmjNkv95SjoLQ1HYWXczqtDEjkHEl4VXG9LugSZEiV0dDvYVFC0 Mg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-002c1b01.pphosted.com with ESMTP id 393jd9k00k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 08:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcJgrlmPiXLbDs2R2+WaIcgwxILZUr3nv4Xmv1+S/ykLeZPVQimaTuLb6jEB0WEVSam3tauj3lDCriBPePAa6ehZGx8dW6XpAXd90Zz3ThGwAyeIl8wojpYcEqu2CS9cLOi8/0nw1NtyEg5SjuDEtmScjGETdWeFIuXqi9IAioXvmduiDoNP9FxshrxyTbkXwMlhZVOgvXkRioQOYB/psad2A0D1vioVoBVMQkepvhgjHG1+qnWH29iUVqkRRlI+WBoHCh9d1s+w1psMtH6dherDO6qH3+kRHEqTcSJX/CWqp882E4qQ1nF6BCv7tYlyvI7onvXymQyJVFIQ96m/pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f3yzJkJ3b8DcesJNGxv58s107zaJUGuIZYhDN31lYfo=;
 b=Killj3e37TeaJ8+Wdc6TDizfo8mKHdAY/x2CCC2TQHbLc1jsvat94t03z8ZokhOIDUZOFFzSTtPGZe6BfJIAKuXWsufKc7zsKdL2cbZG/eXcM/Qjo3KW1BImwvZ9KeD+E762WaqbEu/Svf4VRNOAEtPcWxUZFf6OyZpfFyfry4cxOITunjyOjL/D9M6Ssl/vwc7g6+zVpXTfvzw1hriYjYLr35/JkjLPL0PFLpJ5mcBX5ABOqyBju8fwczO6ENssjDXKb6/xwv1ZQXTHppZKshu9y8d4MhiNsQ+L4z+opdCxv1UGSnnmfZKF5dK3+EFsdvEqd82/RAbdLBrFHqQVKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=nutanix.com;
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH2PR02MB7016.namprd02.prod.outlook.com (2603:10b6:610:81::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 11 Jun
 2021 15:24:14 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12%7]) with mapi id 15.20.4219.023; Fri, 11 Jun 2021
 15:24:14 +0000
From:   Jonathan Davies <jonathan.davies@nutanix.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Jonathan Davies <jonathan.davies@nutanix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usbnet: allow overriding of default USB interface naming
Date:   Fri, 11 Jun 2021 15:23:39 +0000
Message-Id: <20210611152339.182710-1-jonathan.davies@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-Originating-IP: [192.146.154.247]
X-ClientProxiedBy: SJ0PR13CA0089.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::34) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nutanix.com (192.146.154.247) by SJ0PR13CA0089.namprd13.prod.outlook.com (2603:10b6:a03:2c4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Fri, 11 Jun 2021 15:24:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fcbcfd5-00e5-427f-7603-08d92cecf8a4
X-MS-TrafficTypeDiagnostic: CH2PR02MB7016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR02MB7016CE94C9E03F8ADAFEEDA1CB349@CH2PR02MB7016.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEmy8e7tpMCLH09W7ofL5kbQ5GK6O6drt72UCefNCIN7/AA/u7IbMSm9uuh/PK+lyftoC4J187H3SIG+15C5IRUoL7oB4EkuLySEYVjwpTHxpB8fIgLm/6DCqNtXBa98LRSNniSnU4HtDaxfIVdzRinAWIF1lK+W6+SPo1eKfRRhiy141RS7LcqxtyMERtMjuAGe/3Qvn4JfC+l1loAyXC4jNy6COOjqsCGDB5pyF8dbxOH4sv2r+LXGSgmDCaMUvK/javPp5nDJaEBsW8xm2zIuWhQEYgKy5qHA3HDplGitwo3I8oDgc8g5qqJYdaMqQrXV6gmN+6RXMUwl7gaW4/OyO+kfhrXyC2WdRgZVsrN2+AKl6JtQOiu/vKrrenFsHqdGRat1CH94qAb8WGfAFX82WSSD2VhpvkBJzoP6zrIb1/PaJBhUgkaj6YzFQyhuOcZKgT9pkkLsDqXUz5Xbd/PGUw7T9r3JNCPjBB42XS6mPnO/SBJrIA3d+gfVUASf6dRWJ7X13Gsp1xdOunOqaAKQY6PCyMuVGUm7S46eQuh4ok/RzJA6qouwViIfQabceRdQMCpYa4Ol6yjo2wNh9tkmfi6BObNgycCtHB3Ilr7tOMqdEyb6j/QYMehSyeu2Qryo5cHY5ZUctVGSa3Pb/kHnVuKSsQ/xJszAzVBR69k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(396003)(346002)(52116002)(7696005)(44832011)(5660300002)(4326008)(2616005)(66946007)(16526019)(2906002)(66556008)(316002)(6916009)(186003)(55016002)(956004)(54906003)(1076003)(8676002)(6666004)(36756003)(66476007)(478600001)(8886007)(38100700002)(26005)(8936002)(38350700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lnIXlw6ZAEB32ZQkLnx8+mJkCrpTINOFjyp373UDNgfLlPgBinWsJb3t6UIo?=
 =?us-ascii?Q?oI/FirP4iXdEc2i+s+02AT9Pg8v2zOkvpSQEyWaEMN0wQgX8Zjs+cpGIZhtS?=
 =?us-ascii?Q?oi53lP9auynhtjGrvnNcEcYdRCCDIo3ZRFtUML1XpHT525bcYgzLKlh+SXHt?=
 =?us-ascii?Q?GuuL5wXRkkc1KisHAeVsqd9KVXrOAr79eMLoO408Odzy2Ivxn/wwSNjb9a0V?=
 =?us-ascii?Q?GXsAbBvsCJ572Osj+YQtYJoysx+6ZeqK4rUSY5bmv4a23c66ikfrjnAPpcGZ?=
 =?us-ascii?Q?bN5Q1w3Krj9Ew4cb/Ykus4CkQHV7304h8m9cklP9czYkJjJWg1/MSlGiVCyl?=
 =?us-ascii?Q?OoQhljqAqcvO2JsgdBtW+F0Pm1gwCazRUAQ+NdH+LmTynpyVZvKqR/mC47Ok?=
 =?us-ascii?Q?ECJu6O9OcU+k4ryNLofSHW75oPj/hvD+655j3OQf+L4YNTIJefojvFTTgahw?=
 =?us-ascii?Q?Q54C7rN6h/4bN2g8d3s+pCzspSCXQUa9S0UZKQBDUW5MpO9JewbhrRfbcn5P?=
 =?us-ascii?Q?klZamRA28O6brlk8F6BsFc7zclLxAn7z0FxQaVYXvJoQfgRI+Gk99Ejyvyu9?=
 =?us-ascii?Q?OATb+6OaphEeM+zmA9A6TxlUnxtkwCaFvcio/M62U/UVtUga81m061UC9ncb?=
 =?us-ascii?Q?xI6IPvC9XmI16RycQhSBEhOE0lX9Mo9JqO4SY7VwCs6aDLiwg0hvL54ua6lw?=
 =?us-ascii?Q?z09YOMqykO4UXeEOyoU5SgzyWxmRa/MOp1KLSSb7J6166te6OwYOwjzir/VA?=
 =?us-ascii?Q?MdKCOZbkj+urov8QPmqmVScg9szvjUHDM7DY2fqo+3FecreP034Rel2HG/Yq?=
 =?us-ascii?Q?1zeiqr6JDzO1ziclsmDZzPaG1Sm4QN3qMMmquFOxR7C598cAmcqbkkfpkGXy?=
 =?us-ascii?Q?+8jQOgJnT7ENNDJ5sDstoWfP3Dft4DFDZ8XHPReRQ3LQSSdLaf7T7WbSvVKa?=
 =?us-ascii?Q?dBV9sKy4j6XIIBA4ZBae7HePa45b9F2l1gtct1Ibz/dyornvMfmtNMqcY2re?=
 =?us-ascii?Q?jM/56Tk5C+QeId6WJdeXBy9lpzq/KXjGgl0HrC8gKHHN4JFHeobG1sXF4GHb?=
 =?us-ascii?Q?cbG3bEtiA+w4qED6ym8VPO1IGI3PIRRGjA7F5KRxo+sPGKggt+d7fPiXMyq0?=
 =?us-ascii?Q?Nf38Bknj3cxOJErNq06lN7r5uv56ePbYLchiGISs3iCgV1f+fZl4Njmt+tYl?=
 =?us-ascii?Q?hhjnoQMgUYAjHLCUymb6IMtPvs9uIf8m2uIDo1W1vhrxdAh53d5r/GiWKtUn?=
 =?us-ascii?Q?nehWQFDsgzPlCB2QfZXaf7Uq2XejCmmgE3TApgHwMgGrTDjJdHIbnfg8gFaD?=
 =?us-ascii?Q?ZRk2qJ6EObk5suGRrsa3yRcV?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fcbcfd5-00e5-427f-7603-08d92cecf8a4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 15:24:14.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Lu+SWUdNXXlerje2oHW5OoustLox31eCkZ9ZYHflSLf1//c06vuecGooRx5oLm36aEWaL+L0WQBzlCUZGeP0JQLzzOKPvGJQYg5gIfYbC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7016
X-Proofpoint-ORIG-GUID: -I_K0HvNz_SHJRUxPGIzde34QTNCribt
X-Proofpoint-GUID: -I_K0HvNz_SHJRUxPGIzde34QTNCribt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_05:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the predictable device naming scheme for NICs is not in use, it is
common for there to be udev rules to rename interfaces to names with
prefix "eth".

Since the timing at which USB NICs are discovered is unpredictable, it
can be interfere with udev's attempt to rename another interface to
"eth0" if a freshly discovered USB interface is initially given the name
"eth0".

Hence it is useful to be able to override the default name. A new usbnet
module parameter allows this to be configured.

Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
---
 drivers/net/usb/usbnet.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index ecf6284..55f6230 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -72,6 +72,13 @@ static int msg_level = -1;
 module_param (msg_level, int, 0);
 MODULE_PARM_DESC (msg_level, "Override default message level");
 
+#define DEFAULT_ETH_DEV_NAME "eth%d"
+
+static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
+module_param(eth_device_name, charp, 0644);
+MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
+				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");
+
 /*-------------------------------------------------------------------------*/
 
 /* handles CDC Ethernet and many other network "bulk data" interfaces */
@@ -1730,12 +1737,12 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 			goto out1;
 
 		// heuristic:  "usb%d" for links we know are two-host,
-		// else "eth%d" when there's reasonable doubt.  userspace
-		// can rename the link if it knows better.
+		// else eth_device_name when there's reasonable doubt.
+		// userspace can rename the link if it knows better.
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
 		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
 		     (net->dev_addr [0] & 0x02) == 0))
-			strcpy (net->name, "eth%d");
+			strscpy(net->name, eth_device_name, sizeof(net->name));
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 			strcpy(net->name, "wlan%d");
-- 
2.9.3

