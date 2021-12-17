Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1097A478583
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhLQHSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:18:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:45184 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233620AbhLQHSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 02:18:12 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2b1ws013696;
        Fri, 17 Dec 2021 07:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=pKiYxHoxfY+cU4E33/EZTD5SPMvt7IIPJRPcFE//i0I=;
 b=sipClES/G1+RYVSRNoQtRzdXhYgk28ehkrhx6TZrnuINjREKl+cnqYlX0lOY8vwJNOYN
 /V7XmySCH7qn6MHOql0rf//twAS6Q82pm+UtJD3CrT1P1CcxJrmNdVIfawllaDSxcH9G
 qJV+WoL0Mu4j4Hu6sXFSLZorK7lXdREWoDIHgLAUOUaB7FPxZapuKkcAyxX55isyNGEz
 midg0PKdbJw80GlOmxQch4yYNqnkqfGmvZUsCMaA23WcIxwd6I5Dvthc+vdLMwMzUTzB
 yXuXuh61ZPOBs7BAACJPevM01EcSgRahgQkrkS15Q0RqBkfE+nzQugUEp2Lh8JA8ER2Q zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknc506d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:18:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH79sSJ133042;
        Fri, 17 Dec 2021 07:17:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3cvnev5m07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 07:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ubnn+rsz5k/eiqRhpOs43gNWdEk7p1KmI1JDEvGj5JMSBubiTWC7BpDnI+k2YQRNkktc8bYt1y2o2ea3BRSM+/GipXXNaX4GTAIBe/G2GL2kXu1EREBLkbxfGX5gzGRljmrC8YLeGhhw2f16ar86BSHJC8/fcf9dBWC1mzaJ4WI7zqfzQeoMpH7LobbvaqBl06lHpJA9kCKTOJ27T65Pk1taEJ6oM464f/tVuv7NxyXLEOjvKCXl3duPTQ+GCrsYirVSO6c+fpThIbzFLpZzYw87r9e2DMsFTas+8TFvawPV5XXaye6XzAlXTRnQM5ICQmoAFM+yz1gwWjL/3Mb7Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKiYxHoxfY+cU4E33/EZTD5SPMvt7IIPJRPcFE//i0I=;
 b=bzwbmR2GxeFxfKBZ4grCnRBHmYz/GRpEJyYxDzBBP2sgw8FjtzhKAFKn4qnhr01g5/u4TLZKOrW1iEZup8tvQZldU3k38RuGTAKs3hDykZrrPMf/PP5GwzU1QJZ1lwKrRFjGhI3qFe2NCVL7qNUNDBBRHJQWPQj5aOyTjJR8BuSFlP5a8y+lws/PqB3D8CpeI1ZmbxLA8cc6SfktEzMEWs5J0qg3aMFfQkWuaoJ3/zyD+tIashIYOM6IPSbGdtx+hG8aWbO73ey4i70U12tHyIajHD+ir30zYJQvelDLvZKz0iHRWzjLTyXM1jIcQEOfwxcdsAZsucBAmUwuZJXiyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKiYxHoxfY+cU4E33/EZTD5SPMvt7IIPJRPcFE//i0I=;
 b=aegqYZO9LDkyKb9sQ8N9g/n/8KrOrLLoYEbSHq/sxZQC56kQ86V3iWTEZzfTS1VUhM3coRoQt2xH+Pzv+HcWJvT+wh4vbVj0/ZWL0Rfoq6l402ttBUKzwNn7cv3mKRMaM/6NRnvGqgnoiF2u6++FgBNqrg+9rEZnjaw1UHbJwCg=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by CY4PR10MB1941.namprd10.prod.outlook.com
 (2603:10b6:903:11b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.15; Fri, 17 Dec
 2021 07:17:45 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::38cc:f6b:de96:1e0e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::38cc:f6b:de96:1e0e%4]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 07:17:45 +0000
Date:   Fri, 17 Dec 2021 10:17:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Manish Mandlik <mmandlik@google.com>,
        marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Manish Mandlik <mmandlik@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [kbuild] Re: [PATCH v9 1/3] bluetooth: msft: Handle MSFT Monitor
 Device Event
Message-ID: <202112171439.KaggScQN-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216044839.v9.1.Ic0a40b84dee3825302890aaea690e73165c71820@changeid>
Message-ID-Hash: XQNOLXJGA3F5OBASPSL3PFU5HFRQ6SZY
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::24)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c8917a1-c439-466e-9047-08d9c12d529b
X-MS-TrafficTypeDiagnostic: CY4PR10MB1941:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1941C8E835AE6FEE4A49C6398E789@CY4PR10MB1941.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W7iHQ01gXGOtdM2oLuYwFS1UQhsGn6oZstpCU3KiEPJVqqg2jTHyYWMuZ4hpstTJ61PFsZ6I2iZcN3uq9ibYFTCZ4Y2NoLnVs9CP37qIMsWAcfisxOEJyxMmoZgYACjJkPtlZvHmoERKxSigj73ahGXxONzGVZdZycrpAeDfR1X8EcdckgowH2rGIt/oFEQ+gomwm3ssvLhmQS3F1wk+AORUUT/9voRy6DZvn5jp/EovI0XivpkTBGExzqGEoSHpEF2bzzE9+38ngP+BdITHWQdsdmdG8yauP/O75O2HnLDT3UQyAgu1O7v5bR/rXWD+1zVs+q9HqC4pzJ9xY1h1UiN7hHzMZOL1zdqDikJi6dGir7Zv/Dj32Z1uQVeWjWMYGmZVNpWBwmAOa7f3wcqe/wSi3M2hCeHwwygWd2sILTnYzrNKNGgQn3X4u3iVhFnayNjc8Y6jUyY36YnqS/KOnqhzSWF+hfuZpDYLXtu6YwOYZa7z5DPXXCOEVV1QZGFuYYjaStF5PqMzu08pvpCpR50/wNeLzXuaWL9SYkOXuhA84k8qyYLQVh8dEYsrK1mzWcoSxhRErWu9ftgtr4rDSO8TrF8bfbouze3AHozQw8ShFabZD//FWyGAeMT+9UoiTuQXlElplmJ7HZVAm2Ayi8GeZT3uP2uXY3o80J6cS/FhrGfR6ZpUKwHrz050GNOCbC9TQW+yQny+jN3uLhRZPeO7wYqfnIHmHVO1qs59Trh45bBbcXPbHtYNVi5xRILeda1RV514IyltZ4K4t/R2/pA7JeEvntmqL9/MPOuVlZ+d6DIirccmgfCXdrieXQy28Oh27n0JLYXzjMgzKlTnxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(52116002)(9686003)(8676002)(36756003)(2906002)(66946007)(1076003)(86362001)(5660300002)(54906003)(26005)(44832011)(6486002)(508600001)(8936002)(316002)(7416002)(966005)(4326008)(6506007)(66476007)(38100700002)(66556008)(6512007)(186003)(38350700002)(83380400001)(4001150100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bXma+RyyXLJUIWocGvevlDq3KysUgSGpRi1yhfDUHPwj9hzS937SdnyRe/Si?=
 =?us-ascii?Q?RwNaeBMOVbY/p8PsNpMqZQZu1kwOPXKZE/JUJiHiMQXs59ZRas43uGQUoBK7?=
 =?us-ascii?Q?LO8YReCATB6UMiPYZCBk0LFitXeWOXUv/GP7691K9kGEeBv2UdEgJ1mjSRL3?=
 =?us-ascii?Q?MEruLzlKSzunk+UmS66CR6tqCOSCdOpI72gg6ixTb2krM4UKMbRQ9fUluXl2?=
 =?us-ascii?Q?8jlhNrp+XtubRddAw2UjnmPDM0etVCMKlwLh8gyI1GDo9q4SzFUIKelqBmf9?=
 =?us-ascii?Q?CKHbavDJy++Wsc+KSafUc1G2WNjG6Z2ckrWRAif2HU/xYz7BHfaeJsNk7mFh?=
 =?us-ascii?Q?YgHf6CZL6NBunvesXfu1zPLEKzBYgMHXzwO/zv4VrPALQk78Vc0rSRdVjJYx?=
 =?us-ascii?Q?h554YfefWv76zTnansaKGESxMqKEL3WtNByWpjHocBHks4Zb3UN7qc6E+mDf?=
 =?us-ascii?Q?qa5mVs2oJOOSKjtRK9tPR32dop5hVo0kipVkVhoPa26/tNeh2nFa4XtU4sdS?=
 =?us-ascii?Q?rgX8RIi9imdRjB1FheMWs9AGYs+oWWBnVKHim/QX6WeTgT6CmZcr5akMTjqO?=
 =?us-ascii?Q?/jWjUkwNjs3qkbrQkxiXaVq8MAZBkrCwJJ/348CBCfsEpKbhTGNuOeLYr+yU?=
 =?us-ascii?Q?a3BCEt6Hy9wN/hFIZXOsbXyJ67FJo/KheFo5xkoQSs/7v+LKvhzuGne5R3Pp?=
 =?us-ascii?Q?wZFOxLcQaMN3Efqh0dN4Ad3Pp5TOeXcCnzGwJSpWm4qLaYdugiG1oItdE45w?=
 =?us-ascii?Q?JKMUfttx0y371dXUK96cYqm6GPt1+aBBLEJ9ex9LvyaZPf/CcMwx4x/Z3lC2?=
 =?us-ascii?Q?O5IV0MVaxOgxjSFzFrKYdmeZPozRqQ7xZdNb3dZvVq7bcFO4oV3l9oWn6afS?=
 =?us-ascii?Q?/HzKpwLcrGvsiogZqudR+Aain/ksyaMPmQS16Ynlh5HCjcdYqOpPvFnV7L/u?=
 =?us-ascii?Q?ykJyU+YUVHXn5Jq+wbI4nVBbC2bNySWKZJgKM55//KkHYvqyJHIgn/IBMXQQ?=
 =?us-ascii?Q?oZOuULmYoNgikhHoqFgwTwnEmwb66aUCOVLLE3Ua1ykqu+tOqoO5vKfVs5h5?=
 =?us-ascii?Q?zFwqWjx3ykTRAsVX3JpfbDNURplYX9aT+RdwsWGwAsvMUCG3adWws4PNCjPK?=
 =?us-ascii?Q?/tHxvELJXp4EY5eTv8bzPU3QUAbpPs/TudP+YXxqmr4qvIPM48l84zt8zTrw?=
 =?us-ascii?Q?45ynyv/Zw+WSvl2h2HWz7tn9fHZafPyVSc7hiU7Cnt9xvklrgOgiUCal8T58?=
 =?us-ascii?Q?/dUj8CP2JYRtcvXGRxUrFlMYuP5XSGTdNbLhTYb9tNBp8wKulxuIqeMbhZrF?=
 =?us-ascii?Q?M3nbWsXn7ZMD4FtrQrl6QIlpmBF1DMWRpYY0Xk9gE+AifUfXgm93yW7te4WT?=
 =?us-ascii?Q?rDaoCbvB+Xq7BHMwyxbmvCrXsxQMVqZXJvtYqWtU4Xz4AxpXAhSDA/inQiCD?=
 =?us-ascii?Q?dFgTqL9iNYpz8L/8M3ckku8JH6zYTvVXPexGqarnawfc92GlRiXucBhrmL3e?=
 =?us-ascii?Q?hmtxnCismZc66ZMNb+GfNbF3NLOfOKcCo7DcdfFWlfUpmsQAVhiOnhqaWnZp?=
 =?us-ascii?Q?bsohVKlo4mWEhHHQMvWcTQe7PGUIHriIAomliWyswaxMbKk/k9IFQWUXEiPm?=
 =?us-ascii?Q?n6LW6r1mxjOE7mQ9dBkArjo1PUU6NamrMA+6jrYOivATFP8DAxX7zWOdcBjK?=
 =?us-ascii?Q?Ahg4Dr7VlWveXAgwhFFq2FRO1fM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8917a1-c439-466e-9047-08d9c12d529b
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 07:17:45.5751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRE6S089ejfU41DLJJ2yN3zarSFolqLnE/Da1gzTsw/zzHMbEK/l97+ccWcu/vByYpswyRf2SFcztQltACYNPWRccG3sMLps5vQpEutUN4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1941
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112170040
X-Proofpoint-ORIG-GUID: REYPQpoBKas1wV8qnVTzZLjOPBy7W1mJ
X-Proofpoint-GUID: REYPQpoBKas1wV8qnVTzZLjOPBy7W1mJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

url:    https://github.com/0day-ci/linux/commits/Manish-Mandlik/bluetooth-msft-Handle-MSFT-Monitor-Device-Event/20211216-205227 
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git  master
config: i386-randconfig-m021-20211216 (https://download.01.org/0day-ci/archive/20211217/202112171439.KaggScQN-lkp@intel.com/config )
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/bluetooth/msft.c:757 msft_vendor_evt() warn: inconsistent returns '&hdev->lock'.

vim +757 net/bluetooth/msft.c

3e54c5890c87a30 Luiz Augusto von Dentz 2021-12-01  714  void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb)
145373cb1b1fcdb Miao-chen Chou         2020-04-03  715  {
145373cb1b1fcdb Miao-chen Chou         2020-04-03  716  	struct msft_data *msft = hdev->msft_data;
e5af6a85decc8c1 Manish Mandlik         2021-12-16  717  	u8 *evt_prefix;
e5af6a85decc8c1 Manish Mandlik         2021-12-16  718  	u8 *evt;
145373cb1b1fcdb Miao-chen Chou         2020-04-03  719  
145373cb1b1fcdb Miao-chen Chou         2020-04-03  720  	if (!msft)
145373cb1b1fcdb Miao-chen Chou         2020-04-03  721  		return;
145373cb1b1fcdb Miao-chen Chou         2020-04-03  722  
145373cb1b1fcdb Miao-chen Chou         2020-04-03  723  	/* When the extension has defined an event prefix, check that it
145373cb1b1fcdb Miao-chen Chou         2020-04-03  724  	 * matches, and otherwise just return.
145373cb1b1fcdb Miao-chen Chou         2020-04-03  725  	 */
145373cb1b1fcdb Miao-chen Chou         2020-04-03  726  	if (msft->evt_prefix_len > 0) {
e5af6a85decc8c1 Manish Mandlik         2021-12-16  727  		evt_prefix = msft_skb_pull(hdev, skb, 0, msft->evt_prefix_len);
e5af6a85decc8c1 Manish Mandlik         2021-12-16  728  		if (!evt_prefix)
145373cb1b1fcdb Miao-chen Chou         2020-04-03  729  			return;
145373cb1b1fcdb Miao-chen Chou         2020-04-03  730  
e5af6a85decc8c1 Manish Mandlik         2021-12-16  731  		if (memcmp(evt_prefix, msft->evt_prefix, msft->evt_prefix_len))
145373cb1b1fcdb Miao-chen Chou         2020-04-03  732  			return;
145373cb1b1fcdb Miao-chen Chou         2020-04-03  733  	}
145373cb1b1fcdb Miao-chen Chou         2020-04-03  734  
145373cb1b1fcdb Miao-chen Chou         2020-04-03  735  	/* Every event starts at least with an event code and the rest of
145373cb1b1fcdb Miao-chen Chou         2020-04-03  736  	 * the data is variable and depends on the event code.
145373cb1b1fcdb Miao-chen Chou         2020-04-03  737  	 */
145373cb1b1fcdb Miao-chen Chou         2020-04-03  738  	if (skb->len < 1)
145373cb1b1fcdb Miao-chen Chou         2020-04-03  739  		return;
145373cb1b1fcdb Miao-chen Chou         2020-04-03  740  
e5af6a85decc8c1 Manish Mandlik         2021-12-16  741  	hci_dev_lock(hdev);
145373cb1b1fcdb Miao-chen Chou         2020-04-03  742  
e5af6a85decc8c1 Manish Mandlik         2021-12-16  743  	evt = msft_skb_pull(hdev, skb, 0, sizeof(*evt));
e5af6a85decc8c1 Manish Mandlik         2021-12-16  744  	if (!evt)
e5af6a85decc8c1 Manish Mandlik         2021-12-16  745  		return;

Missing hci_dev_unlock(hdev);

e5af6a85decc8c1 Manish Mandlik         2021-12-16  746  
e5af6a85decc8c1 Manish Mandlik         2021-12-16  747  	switch (*evt) {
e5af6a85decc8c1 Manish Mandlik         2021-12-16  748  	case MSFT_EV_LE_MONITOR_DEVICE:
e5af6a85decc8c1 Manish Mandlik         2021-12-16  749  		msft_monitor_device_evt(hdev, skb);
e5af6a85decc8c1 Manish Mandlik         2021-12-16  750  		break;
e5af6a85decc8c1 Manish Mandlik         2021-12-16  751  
e5af6a85decc8c1 Manish Mandlik         2021-12-16  752  	default:
e5af6a85decc8c1 Manish Mandlik         2021-12-16  753  		bt_dev_dbg(hdev, "MSFT vendor event 0x%02x", *evt);
e5af6a85decc8c1 Manish Mandlik         2021-12-16  754  		break;
e5af6a85decc8c1 Manish Mandlik         2021-12-16  755  	}
e5af6a85decc8c1 Manish Mandlik         2021-12-16  756  
e5af6a85decc8c1 Manish Mandlik         2021-12-16 @757  	hci_dev_unlock(hdev);
145373cb1b1fcdb Miao-chen Chou         2020-04-03  758  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org 
_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

