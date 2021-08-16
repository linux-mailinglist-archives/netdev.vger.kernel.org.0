Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70323ED2F0
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 13:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbhHPLOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 07:14:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11844 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231652AbhHPLOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 07:14:34 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GB5JJw016981;
        Mon, 16 Aug 2021 11:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=Y4ne2cwVmRz4jiaB4or+5JFrtWMzjfU8LZZz6K8m5nI=;
 b=IJ4LHg6CKY6hpxekC85j57ogNOSNXz1XfK+0FeQ1sfNvpSNOlNij0R6DrF4oeTU4L/ls
 A8Ta2HQHhqIGxBnsRY1wyZZrl5ONEU6b6bI+48EuUhTq5j1bh4JAxewgbp7k5P9SJvrw
 3U20SBYPhJt2EnGFHRuafVMNJxBoEcowkOMrdXleZ5EsC9NX9JVwGk86xEqeZNU58XVp
 h3FZiqCWRGrXlZNyPfbmneHeKuZqkNoY0cCDigSW6xbEPPp8Sc/tZCZ2W/fpasQG2fP+
 83qGaik5Sf8QOwL3jwNHqvztB0biMCcT/hc5sLx95dJJomdq0eyftf2tk0B82nbruj6M GA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=Y4ne2cwVmRz4jiaB4or+5JFrtWMzjfU8LZZz6K8m5nI=;
 b=wJePtbbdRKUmbbxmVinMrWhfLLjLOlJ28w+TIZ4MGwLIfoRCRSGOrgL/8dKsuRd7B8F8
 kxoyiG5wekNz6Lyf5qYWt71cRoE3FfSErMM2zyOkJLk+yuP8Xd5cUkAby2sdoqfv4jBr
 4hiH7pXgSFZkOPcaSIxlfw+O1uWO4PTYNj/HbpltwIgQiJcIqoI4G10AhHkwrtbCHrwz
 1qNI1TgoitJEQcruCynh6djUS8zNeVRaGqaur/Br94TxIysPbUhPq1z/vYuh26VhpsDj
 sXs3bqq5XIcNtayas7SptNsGWffmMn0ycXUXmLAQ8kgvyCyb9mjdIcfWEfoi5RWcugix Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpggsm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 11:13:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GBAkgc140294;
        Mon, 16 Aug 2021 11:13:55 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 3ae5n5gyq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 11:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q93xWE63YmQdyepx5ewkGmSSgqktUNVPabF4iIuzoS78L/roT7e9KTPzswP8mDL3UyF6CUGJQ10CR7f2MR+ysa17u9yoD6LQguWCXv2PUI4zF3IYZs6cA0iv7A1ZlOIhTpJWjxPrxV7TJo2cla4aPq3tLZIHZyEkflR9kuJU8fw/Uj8o0WD02Ifgy6h/fvGu5YA5MMg3FgKePvbuzXLooFvwVQ3sdgh7/8MerNTJSP60X47WUzZFbeXDwA+FBg6CaBTxGPdWiV5gBV0pfVIC4nTXAZLNwf/dtt+949e1oc5o/4wY0l2ZVIcrPTnKawM+zPky3aaRndGmHvC7Z7zItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4ne2cwVmRz4jiaB4or+5JFrtWMzjfU8LZZz6K8m5nI=;
 b=HvVv6KW6BRVMoU09JghQXUAYPTLgWA540KXkYSJfEX3hGSr641tluduKLsxcUgODzoELOyck2qvJN3HU8VyZcN7OfMN//gHkxHGV1ldd/BggctBBsn1L6G01fHH/G0zpCoQwK7Fo+n55ik/GP9DG/+AqmeCzvoBmaLp4c8BpzjphorMy7KcbepjfLUpXWqCcrvmJOWAm3yXfNCW1EVTOBwY1yc3zDFWTZshpAFEwMO1q2tztSYbCqxkH4YHUQtDA+wH/BKKVwo/aRnaRnPVtbbNwXzV59aI/uWpoXCcaRLIW1xl8GZ2spq42pucWK0S/PZLdm8EmwpeBncjhhOPRwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y4ne2cwVmRz4jiaB4or+5JFrtWMzjfU8LZZz6K8m5nI=;
 b=TrMhI6a9ntKBm4vebxahOCdmz2aKf5KkPs5vI0EDsz7eDRZdxZZq7peq9EoGteUBPGso2zKDGI0qnNRd6ChZTdviReWvG8gg1g1jl0qFqt/a3VSI8SVsvKRfx93JNVIYCJ1s9D0zNBEImLFlo2dDtjyU4CGV7I6yCsIeNyJ5vOY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4449.namprd10.prod.outlook.com
 (2603:10b6:303:9d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Mon, 16 Aug
 2021 11:13:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 11:13:53 +0000
Date:   Mon, 16 Aug 2021 14:13:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Solomon Ucko <solly.ucko@gmail.com>
Cc:     Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        security@kernel.org
Subject: [PATCH v2 net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
Message-ID: <20210816111333.GE7722@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5008D7714F0D224A0778857ED7FD9@SJ0PR11MB5008.namprd11.prod.outlook.com>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNXP275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Mon, 16 Aug 2021 11:13:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f22b529a-c84a-49e8-1c0f-08d960a6ee6a
X-MS-TrafficTypeDiagnostic: CO1PR10MB4449:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4449388940AFB8FC538B3F188EFD9@CO1PR10MB4449.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7K/QQYiMx98HUY+u1mD6xoJAf16EaPiTgEmySXrDanxoK89rLBHtuSOXIrLdf5TrENm/HBCL8RruPFnuhJI/Sc1LLLp+si4qs+LbuwsNagHKiZScwHtNpVBo8PuAha+xIm7McEIqfbNOLqqkYbH+ubpuji/YxFD4r58zvhA4dcd1dHmQScKM4ca3BtH03gjjQxRFVnl4zzzXC1CResvp+e46vjhR913+m+E2V/glDlMfYvroYOWAeoUCFdAZtgI8r7TjDu+CWx+8pZWVUcKr58MIa2dnXJIeU7QJn+zM0R0H7/8wtYVe0hOv/YAJVXfaS1sbX2yLMolTiOPPakCm6wINE1qsT+/TMrBCZweJ1IwOvXj2EnEr0mGHV6ccBCyMtRDD+KQwoGJw4UQIDTc3UucuJRzjNsoUP95dERlGHh/qjGFtV0uJD75W5zmfLtZAuptXEoWeWLpruKgIqPQvGqDfeaplAqEONI61J1Yoj7qUE5kQKeZj2mpU+EKbt1Fkc938aNLLc8bO7q8xlSe+KlEp0lTXPGJXwzVsg8ZwcGojwBqpQIqtIR1k57nYb6UGLYy6crmeAqdq41BGy1P0T7isNkCsSsxHyM6+o0FYA0I6sRfJjiIH7uIoFAHDFzwNqGK54ar2ICF8r9A9RKV9xu8j+VxN9toGopiqliDFV6KC79ow+hwd1GniS0MydP0VrwOot/hR6JaU/ijz+8GTLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(110136005)(9686003)(66946007)(2906002)(33716001)(1076003)(8936002)(4326008)(5660300002)(316002)(86362001)(66556008)(66476007)(33656002)(508600001)(7416002)(54906003)(8676002)(186003)(956004)(55016002)(83380400001)(52116002)(9576002)(38350700002)(38100700002)(6496006)(44832011)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W0DzBH/X6v/xPlZUhHZM0AywMcoYUgzgt2U6b2mjdqBU55+wiXFm7y5LpKpW?=
 =?us-ascii?Q?I+aA5tIKBOXAEndnC8ktbqH+C5c50P9O+d5Lz8PZj6lmfckei1mIF6rBF1AK?=
 =?us-ascii?Q?YCMZPMs5TBYeGYCd4CNYmfrVxZjE6DZvQSNSONhLvERDyNwQzVsDsPC8R+/g?=
 =?us-ascii?Q?HkK64be88bTUAuF/crnLSZ+9CjRRFX9ZuCuGUE7AShMhUr3zHWXJ7yyX54++?=
 =?us-ascii?Q?igfZHKfNaBWMEtBJkvpVVPntTFyzdRy6xikGtVykHCkUTAZ2Qc6h1/Dk0izo?=
 =?us-ascii?Q?H2uBx+C/oXBAfwx4CV3WgTxHyNCmcCNwfGjyNC5dozVBflS/qaHIXBUnd5Fq?=
 =?us-ascii?Q?qrdz6m4fd/S8LhFm+L8Vn4YJ2Shs/+9fUSHUErAlYKPOmGtAvYuvGzgVuDzI?=
 =?us-ascii?Q?+pVfecEoIBUAUFYvd5DQW1N9cy7Bvz8muhPmrUxzuJF38/0Lh6mtpY5a2d9J?=
 =?us-ascii?Q?eQdQSM423XwPSoRGNc8Yjf4ZUIfkxYdyqbEoa/7kYGc57o54h9+HXPRD6Stn?=
 =?us-ascii?Q?YYY9nUKSd/5dzvNMjTEQBK/NR5jmEqgNQ79N1OmBOqPhEW+8tYonMbpUFP5V?=
 =?us-ascii?Q?EApzQjGQlQjFTO106zyQEsvr450IZ+LvlP0bHRAD7YfM3NQuKvzYy9MyqLFH?=
 =?us-ascii?Q?/ZGvpFSoQAi9AcfAET8zD0WVRRMNqWmQfT/RsFV+8YkbHjfp/LwLsj/8CufE?=
 =?us-ascii?Q?UcUNJP0q+hagEwA6HktQFeAWspjk6M+0qgkxOTHO/20bKhwsNOE/N/61/KK3?=
 =?us-ascii?Q?hhHzF/ovbP3M7fM6JkLtLImX0wGZSksjMlqS2boosm8iuh/5oVEwErVtUPDS?=
 =?us-ascii?Q?spBQhs12/jq3O/Ru5TG95+WnMJJuT7nbK5/hMTQMhY6+/XjfhZJm5Y2dM+0P?=
 =?us-ascii?Q?OOebWVzXnDIkewZOt5pVI9OG7Io3AZJrEf+Nx8Dbh9rma+vlN5yCrrQEA4HV?=
 =?us-ascii?Q?ZdIL3sQbar8BpNREC2wA7IJwIWeReBbwV+NHFg9ZUDnHvQ3ru7+mxVLRS1zD?=
 =?us-ascii?Q?+p70nVRU0zicsGwSQ6VeDG67rPkU6Y+PWWR/cvqDElIQtQMOYHGWO8VVGNuV?=
 =?us-ascii?Q?ad6VphMklg/KwIUP+pZAsmlB/lQ27XhaeyyBs8scFSZjkSXTr1MjVtYgC3qW?=
 =?us-ascii?Q?jyA3cSqt7MV+NfQtaq5StkHcI2SyU659wZBt2ZPo5BYZE8L9s9MAAscKPT2m?=
 =?us-ascii?Q?v0/0dr9h9sx8GIj6ZTBqSHktWIkvvrfpv16kkKzN8r1Y48mxTBLz8h5s2RCD?=
 =?us-ascii?Q?hpa4zwWD8VqAEfmY0+OvV9LxeDpAeTEnXqnTioFci/w3JHE2vMmpi5XAnRSL?=
 =?us-ascii?Q?w8fSw5b8qf2ZY76D0xz5pE9A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22b529a-c84a-49e8-1c0f-08d960a6ee6a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 11:13:53.2033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TYu3oPnsFHVSTfe1MLUkEFJWV+lgeRJ3joopnDiY4yZHW9vH2fV6hvtmirMyohmrDeMz/yeXCdmjbnIxEeUyJaL7H/QB/Ewwmho/yfRk5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4449
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10077 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160070
X-Proofpoint-GUID: aMfVvvepCjk1TvpEnGwiigkx3dIf834k
X-Proofpoint-ORIG-GUID: aMfVvvepCjk1TvpEnGwiigkx3dIf834k
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bounds check on "index" doesn't catch negative values.  Using
ARRAY_SIZE() directly is more readable and more robust because it prevents
negative values for "index".  Fortunately we only pass valid values to
ipc_chnl_cfg_get() so this patch does not affect runtime.


Reported-by: Solomon Ucko <solly.ucko@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Remove underscore between "array" and "size".
    Use %zu print format specifier to fix a compile warning on 32 bit.

 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
index 804e6c4f2c78..016c9c3aea8e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
@@ -64,10 +64,9 @@ static struct ipc_chnl_cfg modem_cfg[] = {
 
 int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index)
 {
-	int array_size = ARRAY_SIZE(modem_cfg);
-
-	if (index >= array_size) {
-		pr_err("index: %d and array_size %d", index, array_size);
+	if (index >= ARRAY_SIZE(modem_cfg)) {
+		pr_err("index: %d and array size %zu", index,
+		       ARRAY_SIZE(modem_cfg));
 		return -ECHRNG;
 	}
 
-- 
2.20.1
