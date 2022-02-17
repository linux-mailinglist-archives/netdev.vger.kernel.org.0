Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16364BA326
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241944AbiBQOjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:39:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241849AbiBQOja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:39:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254012944DD;
        Thu, 17 Feb 2022 06:39:15 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HCuPAE002480;
        Thu, 17 Feb 2022 14:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=pE6faqcvMSF84SEdD2rJQ+Tf8gPSo8Z77EBJ2wr+RlA=;
 b=nCjgtGnwgdc9ViRSArYGK4hhZnJP0/I3Ph+xZbUS02ueOHQfDfgsE5FGtL7p6eyr+zJR
 hiLx0Fp48UJmPcGr8mCf1NWGw41ZjoctIhvO43v4eVMu78czdvlvpNNEkb4q/QBRp6rU
 uPCNXz/EDhaAVbXKkEB1/GzqNwqQ8mFx/oZQY1rUJQYxLlV+IJ+snexSBIeNRcaM/+NJ
 4ZZAGTzigC5TThLz2d+D3z3fRDwT3LBtN6fvzTFZV2H/KLezYibEo+bwcM2blFPN4n/h
 7ZYg8iIoMxAsPF4aMpgTe3uxxfgFtErJmlqCJUwOvddexAnXY/e674gLpr3WoHJHo/3L sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3dx58a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:39:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21HEWUAo005474;
        Thu, 17 Feb 2022 14:39:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 3e8nvty763-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:39:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHVzobPZh5R9mSshqkAH8RzWxeWVCQPIYIiWPO2oyoLhYxxxLPwIUzkzAyfvf17GpaFr6J2trtMcKzqGtUOVRzkChfI8U12G6+roilgdSWVitgMIVku9OtOvExQY4yl8sW1J+IKlPFGi96OR8qyQHOoE0apUUaPIExuykAxQXDc0bpae46OqT+3aOntnKjZ5SbhokS4E5zvhBtQAk7hdweVUyrvbBZN35+lDWSWYItReR9bQGjzCpo1S6mg6nh6tcGKxxrAcUD2L7iGM4Ri+ld1rWl8I8xRTyZ3s0KGe4HMYodkERyd3B/2sZeXFygJiq3Y/GwHqILO5bHUcBYRDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE6faqcvMSF84SEdD2rJQ+Tf8gPSo8Z77EBJ2wr+RlA=;
 b=apUR54a6HI9o/mn4GlIdZk3olguBlN41P6uAz7TlLZppH8KDrcP8awthSQC3ikuviVrhbTtCKmD9Evqb4N9uBfqK9sjZoAUAeX7QpVAu+8+lnwK2Q7blkrpoZHGn77drMZaJADjiE43yuqp9w1gbRlKN0iPNf0ZpmeAAwyjC0A0yHhS5lGP4d75ckDBHVU6iwAI3giCbpGGdCaWoi5zn+dwxzJbJGU5aqhdE74HGRNuN9tATR6T+dIoydnIK+e78WwGY79gS10mVJd7uf0F9lAcdzmMQzZhGLIJ8YkybkU7Y9WzGrHKn6ykHOiVYcJHGlnUp98ope9NFqRYhMVPLhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE6faqcvMSF84SEdD2rJQ+Tf8gPSo8Z77EBJ2wr+RlA=;
 b=uKhcpPssZBVFaC8MU2J1YAkwNTVFzs2er/IUPYtxth+dFeNpTGPgqiOGwsdb7/9V4dN2kPwz4iF87x/RVOgoiKx15/71+q5FvIzXg/FRhn573cpdpTmcCEl0FE7FQOKPcHsnUnQlOYXwMTcrww5xZq0HYXli+Mw/t6p8GQ5+cFE=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN4PR10MB5638.namprd10.prod.outlook.com
 (2603:10b6:806:209::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Thu, 17 Feb
 2022 14:39:00 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%3]) with mapi id 15.20.4975.019; Thu, 17 Feb 2022
 14:39:00 +0000
Date:   Thu, 17 Feb 2022 17:38:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Joseph Hwang <josephsih@chromium.org>,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/3] Bluetooth: mgmt: add set_quality_report for
 MGMT_OP_SET_QUALITY_REPORT
Message-ID: <202202160942.cEiT1MKh-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215133546.2826837-1-josephsih@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0021.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::33)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4166ec73-e230-43b6-dde7-08d9f2233c4a
X-MS-TrafficTypeDiagnostic: SN4PR10MB5638:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB5638B83611CFC14A2F756B248E369@SN4PR10MB5638.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L/EIue5azxn2z5ZvA29y9L/KEL1FJl3K53EBGDis8Xc69Hk4tEgXaCwl0bGFyePSNthIjJCu3+cgBEUedHIPOdMOIpd8MbfR0u/shGJhaW2HHhD8t3+pTX+yJBAExaBTWDlx6OsHV/Ww+51PwM5ivuT5l9wPZPMlA8867/sPwOMllgXANHhxL0uGMbeUCrIUpJlrvA0izbjSFmy0HfePkaHjWSBlhicuuJnaRAG6tidIrIp4szLYU7PrDHKBuZ7UMfb9mQKKy/TyFhY/4fSrNZE/dLF/7l6iKZ+B2KU3RhAC+78YP1UGT9Ir2Loe/izDSLhuAkDC4J6IN4sfw5Fph7w7X3ZxaVZW/ezlmlHb+rMcU9gjg1nuzqchiotvAonQDfeVolQRGK26UjDTfq33C0jHpm3KoWSqOY51LICv0N2BJ5BXqQ90x6bV1qTYoqnpswop7Kdw+FSY+ZCJUSzDNl9szJjlRk5V+tci9uHwBhFCadmH2Mz6QQcrHLbbuJlBOJBEzKPv0xFlGoG9f0nsUfFJFkaM44/yW+OrOBchQb/2JZ/He0NHtielXOHr3g9abP1Jb1l+yQ287WtHpgibPR746A2ImO5tTwPmJoyoLXIonp04IkLJgs5qjdZ56GiDWRdrIGBTTVKZfDHLkA5gcH7DKugcx/CID3Nr2VQZX8kcZQ72gD1P1YBnGw5i8O6e2DumPfYLgx07mMfh7mlLx8LMf+vjOwh/w69ge/fz3zhj3rAEPnX5tlvKOJ85nPJxGSvgPmbvwdn1C9bVl7nykN11bTawqLI9VrsQRC9EaOQBOpd5lVQIj0jvk17vLEwijoMK3dVHcET3+pKNXxufpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(4326008)(966005)(66946007)(316002)(38350700002)(36756003)(66556008)(38100700002)(66476007)(6486002)(1076003)(186003)(26005)(4001150100001)(6666004)(7416002)(6512007)(9686003)(2906002)(508600001)(54906003)(52116002)(44832011)(8936002)(8676002)(6506007)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/Cz5UgTeAvfxNl3OlmBBk8iVA9w0q6MzdRdN/SmtOCXPlszJwf9/1A867Kh?=
 =?us-ascii?Q?/zUFWBwxyhgu5MFlT3VZqwO/8Srem3MlXAqiO5sEFJKbU8BYxw58i/PFVfDC?=
 =?us-ascii?Q?FtjV17tK7NnFARpk9rCKaWty2CObtLM0yhL9oUmm6CQii9DyM0dccfmQpzpY?=
 =?us-ascii?Q?0J/1I3F0/3sPibpZK7TWcHw62oO1ErggD3YpB0YE3r9Idwe0/4qtVN4yinVe?=
 =?us-ascii?Q?TsBOJVgqzNrJ21p6u8CW836GDNOeCjo77TXaKFp1fCh6c2olPb5Apfh57yNa?=
 =?us-ascii?Q?aEWouyBvZiwjHucbyXAOleCANlnUe5PrjQHJ9qr1ehS7JrQHhhL1RIR/Y3+U?=
 =?us-ascii?Q?ZuUbB/IpED4zKavXl5EySUnnvCIqbWNDhwOiSMzV+aMdYQcEUPCQaxSlHcG4?=
 =?us-ascii?Q?nJ0NVy/a/w36uqJZ9SiawvHjuQOsCrR1ImF4ttxr+INBvdkEXh+3KVTx3SPc?=
 =?us-ascii?Q?q+9K3rmi342N+7c7bqzw8JAXVhWmjVVmUihSZFwoMikZrX8Q4RXd16CswdqU?=
 =?us-ascii?Q?mENm6zAAKVduNX+xK0chSs28+P15sytkHjoEFRAiyMPoxOzekdRZiVo64p+S?=
 =?us-ascii?Q?DlLlURkignCZOOMy3BSo1bsbiyb+ZJTUVtuYMLohO/f3KFeNY9V3uLMDEUk3?=
 =?us-ascii?Q?jrQ7wcg++knsQBEjDNHe4FYKun5dMIKBUyh2PaSMk015O+yFKIkIIx9zS6mi?=
 =?us-ascii?Q?niz9GTDf70rzqQxO/Esl0LBp1gq7TtcjUtAsf8WJu7Eyn+A3YFGn9wkNAZsF?=
 =?us-ascii?Q?k2Ua4Xswd9DXgwdcp8GxzdGFRJ7QQh3mNYnSnJsGHBqt8z1M7xLkdIbcrwvu?=
 =?us-ascii?Q?lzf1vXFOqWEDw5E+3Uvj+k0ZkYTaXRFQEoNPYT8oPGQZbFmiU+SCbxktZJqU?=
 =?us-ascii?Q?+zD6CH9Yzb+3CGOGV4Qk5dGViJAaGAE71bwy/SDu5EQ4lVAUh5OvuPMLYcB0?=
 =?us-ascii?Q?nWrLE1/o/LHz/OGNTaNWB5NH6sxYuPYi44aMDEls6D+AqpDSp1ZLOGca3Y8k?=
 =?us-ascii?Q?dyAPZxxnLZrXXyoqUycnTe3OiywSFfkUQ0VHeW1/vxKTDSgJizIDLyBogBFy?=
 =?us-ascii?Q?WDem1BAw+XVH6dWkPNh+xQtHn8LYShOx6nQ3sNOvPM17KFrq+I6sBEfFXALN?=
 =?us-ascii?Q?wFqBewY6FYH962fGYTYtXU8wZNz8Jpekf7TxlrE2lo2p6k3lPpDdW1qBZ8wG?=
 =?us-ascii?Q?YOCMWlgQVZqZRdirM4VdxJvaZnOpYRvmZlfEGuw8K6Oq3JF3QyXQQU8Ihep4?=
 =?us-ascii?Q?g13ZYzuLYkKm8HX2pesuw88dYDn8gHlPr6tce8lA3rSE7GA0qdrv030J8Fr1?=
 =?us-ascii?Q?ZK1G3tci4grqt+sE8h7LjoKlT+PRDV9CnYIDmp/DJXy4lqJdo7x9BscclSLk?=
 =?us-ascii?Q?/JECG9hddqLl/+3lybVGX9uN9SMQon2/zLxsB9RXcqKFEXsKq3rcBbowVf1S?=
 =?us-ascii?Q?oNXkoaXDZVp1VVHaVyWKSsM0TaodoYaHJ0lwsFRPVjlx6GEHL7RSS3L0Cf77?=
 =?us-ascii?Q?y0jGEQMlD4/2W2QA+J9/FhipP0FptEHgn73E5ZKLJhaV3hYmayHG7NInAq9p?=
 =?us-ascii?Q?GqQsmbeCe0PmiIA9vM6DilZVyTbiGMr1b00ZUfMuBrhNlfqYc+Tzui5Ygusv?=
 =?us-ascii?Q?Yb2IkN0VJ7nz85eKSsHocgS0zgUIwMB2xIkUOnv9csTtxS5l6Eedkyp9htZR?=
 =?us-ascii?Q?8DlG4A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4166ec73-e230-43b6-dde7-08d9f2233c4a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 14:39:00.2077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3vINu1qIPbvFvRWn3vGdTvKc69Uy6SKLXMbMKFXxRyd18cyRRABNG9R1bUOGGAjA4gT8UImI2opMHgZiOFNxcYDD3mdWdX3iJTUWq0zF8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5638
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10260 signatures=675971
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Proofpoint-ORIG-GUID: BhHlRcE2xRC_-8k8itIbebVv58UDVxYR
X-Proofpoint-GUID: BhHlRcE2xRC_-8k8itIbebVv58UDVxYR
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FAKE_REPLY_C,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

url:    https://github.com/0day-ci/linux/commits/Joseph-Hwang/Bluetooth-aosp-surface-AOSP-quality-report-through-mgmt/20220215-213800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
config: i386-randconfig-m021-20220214 (https://download.01.org/0day-ci/archive/20220216/202202160942.cEiT1MKh-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
net/bluetooth/mgmt.c:860 get_supported_settings() warn: variable dereferenced before check 'hdev' (see line 826)

vim +/hdev +860 net/bluetooth/mgmt.c

69ab39ea5da03e Johan Hedberg          2011-12-15  816  static u32 get_supported_settings(struct hci_dev *hdev)
69ab39ea5da03e Johan Hedberg          2011-12-15  817  {
69ab39ea5da03e Johan Hedberg          2011-12-15  818  	u32 settings = 0;
69ab39ea5da03e Johan Hedberg          2011-12-15  819  
69ab39ea5da03e Johan Hedberg          2011-12-15  820  	settings |= MGMT_SETTING_POWERED;
b2939475eb6a35 Johan Hedberg          2014-07-30  821  	settings |= MGMT_SETTING_BONDABLE;
b1de97d8c06d9d Marcel Holtmann        2014-01-31  822  	settings |= MGMT_SETTING_DEBUG_KEYS;
3742abfc4e853f Johan Hedberg          2014-07-08  823  	settings |= MGMT_SETTING_CONNECTABLE;
3742abfc4e853f Johan Hedberg          2014-07-08  824  	settings |= MGMT_SETTING_DISCOVERABLE;
69ab39ea5da03e Johan Hedberg          2011-12-15  825  
ed3fa31f35896b Andre Guedes           2012-07-24 @826  	if (lmp_bredr_capable(hdev)) {
1a47aee85f8a08 Johan Hedberg          2013-03-15  827  		if (hdev->hci_ver >= BLUETOOTH_VER_1_2)
33c525c0a37abd Johan Hedberg          2012-10-24  828  			settings |= MGMT_SETTING_FAST_CONNECTABLE;
69ab39ea5da03e Johan Hedberg          2011-12-15  829  		settings |= MGMT_SETTING_BREDR;
69ab39ea5da03e Johan Hedberg          2011-12-15  830  		settings |= MGMT_SETTING_LINK_SECURITY;
a82974c9f4ed07 Marcel Holtmann        2013-10-11  831  
a82974c9f4ed07 Marcel Holtmann        2013-10-11  832  		if (lmp_ssp_capable(hdev)) {
a82974c9f4ed07 Marcel Holtmann        2013-10-11  833  			settings |= MGMT_SETTING_SSP;
b560a208cda029 Luiz Augusto von Dentz 2020-08-06  834  			if (IS_ENABLED(CONFIG_BT_HS))
d7b7e79688c07b Marcel Holtmann        2012-02-20  835  				settings |= MGMT_SETTING_HS;
848566b381e72b Marcel Holtmann        2013-10-01  836  		}
e98d2ce293a941 Marcel Holtmann        2014-01-10  837  
05b3c3e7905d00 Marcel Holtmann        2014-12-31  838  		if (lmp_sc_capable(hdev))
e98d2ce293a941 Marcel Holtmann        2014-01-10  839  			settings |= MGMT_SETTING_SECURE_CONN;
4b127bd5f2cc1b Alain Michaud          2020-02-27  840  
00bce3fb0642b3 Alain Michaud          2020-03-05  841  		if (test_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
4b127bd5f2cc1b Alain Michaud          2020-02-27  842  			     &hdev->quirks))
00bce3fb0642b3 Alain Michaud          2020-03-05  843  			settings |= MGMT_SETTING_WIDEBAND_SPEECH;
a82974c9f4ed07 Marcel Holtmann        2013-10-11  844  	}
d7b7e79688c07b Marcel Holtmann        2012-02-20  845  
eeca6f891305a8 Johan Hedberg          2013-09-25  846  	if (lmp_le_capable(hdev)) {
69ab39ea5da03e Johan Hedberg          2011-12-15  847  		settings |= MGMT_SETTING_LE;
a3209694f82a22 Johan Hedberg          2014-05-26  848  		settings |= MGMT_SETTING_SECURE_CONN;
0f4bd942f13dd1 Johan Hedberg          2014-02-22  849  		settings |= MGMT_SETTING_PRIVACY;
93690c227acf08 Marcel Holtmann        2015-03-06  850  		settings |= MGMT_SETTING_STATIC_ADDRESS;
cbbdfa6f331980 Sathish Narasimman     2020-07-23  851  		settings |= MGMT_SETTING_ADVERTISING;
eeca6f891305a8 Johan Hedberg          2013-09-25  852  	}
69ab39ea5da03e Johan Hedberg          2011-12-15  853  
eb1904f49d3e11 Marcel Holtmann        2014-07-04  854  	if (test_bit(HCI_QUIRK_EXTERNAL_CONFIG, &hdev->quirks) ||

Unchecked dereferences throughout.

eb1904f49d3e11 Marcel Holtmann        2014-07-04  855  	    hdev->set_bdaddr)
9fc3bfb681bdf5 Marcel Holtmann        2014-07-04  856  		settings |= MGMT_SETTING_CONFIGURATION;
9fc3bfb681bdf5 Marcel Holtmann        2014-07-04  857  
6244691fec4dd0 Jaganath Kanakkassery  2018-07-19  858  	settings |= MGMT_SETTING_PHY_CONFIGURATION;
6244691fec4dd0 Jaganath Kanakkassery  2018-07-19  859  
edbb68b1006482 Joseph Hwang           2022-02-15 @860  	if (hdev && (aosp_has_quality_report(hdev) ||
                                                            ^^^^
Checked too late

edbb68b1006482 Joseph Hwang           2022-02-15  861  		     hdev->set_quality_report))
edbb68b1006482 Joseph Hwang           2022-02-15  862  		settings |= MGMT_SETTING_QUALITY_REPORT;
edbb68b1006482 Joseph Hwang           2022-02-15  863  
69ab39ea5da03e Johan Hedberg          2011-12-15  864  	return settings;
69ab39ea5da03e Johan Hedberg          2011-12-15  865  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

