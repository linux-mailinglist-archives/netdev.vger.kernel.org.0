Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707E141C2D2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244507AbhI2KlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:41:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3106 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244269AbhI2KlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 06:41:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T9C54G013615;
        Wed, 29 Sep 2021 10:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=4kjU4uk9Mbk9oqYiT25HSbZkOBJYnjyIAEKCPqtyk6A=;
 b=EQTtCdzZSzswVCgYEVY8noxB9I/JBUDD2yxjHDqzgUVc+aML/p9CTjgluChV78QgXGtM
 Op8ktJdmal9hTpTRslv8yhssh7qqbgK3rf6BwcxKLLB4wLzEJQeZecCWNjZS5d70Lqxc
 hv1tAbr40OwUFZbGCNEWd0Yjyfn7HnCY5ahaJjbSpHnsHcIS18bHdvqU9oDbHFgpXf/O
 oEszhslhk9hzOXHN0/I+FvfQFu+hivaJnvFMbr6HP2ZW7w2SW19Lpef38w9dmpBRDLjF
 By/Vk88ixCckN3h+aMzNCUkWKlpbUBrALBI25ZIexFjQQ0IKxHJ+zS3T2J2ES6Tgz26Y /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcf6ct7er-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 10:39:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18TAZe86131891;
        Wed, 29 Sep 2021 10:39:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by aserp3020.oracle.com with ESMTP id 3bceu5826u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 10:39:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYJv8fLdKMOTG408RsQCH5opz3chMP9SgE0Xe+LqVEV8uvxaNbWOSo1MpR7XwNjubTRZKuiQk304KMekJ6F1Y6g0FKwze1CiTie2a1XYqpU7KE18kKb9wrakZhIjvxJV+5KD4ODumwT20tDLilxxfv/2UtOAvmYPuIFt5o6Ava6tVyCn0o/w7ELMf8KxSTx/sJLnbp8Q4373xmFx76204Er+yPmNWe/5AMRB1YtlJP1YYtUdtNCfHfIw3P2AIPVOJ5qNQYQyqYCtEn7371jwTcLQLe6AEXShGviGSo2v+9NXKRyEE6wOK4YiXkeuWOeJrATcTDxVOIu/INj356oZew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4kjU4uk9Mbk9oqYiT25HSbZkOBJYnjyIAEKCPqtyk6A=;
 b=jW047Xr09ThsB/yhSY7IxZP2EjRgAAMs+goW6PbpScVnfZQA76f+oxigYAiO5CCgYmmtqKDl8kBpo3OzjXZkXhobGy5xaaQfr/r3TFGgmMS/6eTTd36cOlowB+avCpiHMbt7iVfZNvVqv9BkWG3P0ME4kZuFqIeICWBlH3MvD3rLtCOLMmYIOnPPl8yV//HtewOslo2sqliKFrX1lt7ztRUI6tTOp0JtiMofM0o5Ld8zDn+yf5LRV5qCPxfOJsvf9xKegBq1qiCUSEwADbU0m91qyNp0ta2DtJkNzMkNJjMOpnGw1eukeXxH196ccwacXJtPdfx3PUo6JwAEmhqEnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kjU4uk9Mbk9oqYiT25HSbZkOBJYnjyIAEKCPqtyk6A=;
 b=a9h1lxvtjZpY7HrOBnmZLqv8UW2Hw1lK0GWz2rKSKy1m+hQ3Y3FXgP5iAisIOrgw60clDV4yeU4YIkdgyNnXydQ/Pk318dIjnWjF8cj7SRHdljmnknvHWkX8jensmXMGNaaWifBBGLYbWSdIeM7uYfRDRo49S8F0i38kdLOX42k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1357.namprd10.prod.outlook.com
 (2603:10b6:300:21::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Wed, 29 Sep
 2021 10:38:59 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Wed, 29 Sep 2021
 10:38:58 +0000
Date:   Wed, 29 Sep 2021 13:38:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, Ariel Elior <aelior@marvell.com>,
        Bin Luo <luobin9@huawei.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Coiby Xu <coiby.xu@gmail.com>,
        Derek Chickles <dchickles@marvell.com>, drivers@pensando.io,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        GR-everest-linux-l2@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        hariprasad <hkelam@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        intel-wired-lan@lists.osuosl.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Linu Cherian <lcherian@marvell.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        Manish Chopra <manishc@marvell.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@nvidia.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Satanand Burla <sburla@marvell.com>,
        Shannon Nelson <snelson@pensando.io>,
        Shay Drory <shayd@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next 3/5] devlink: Allow set specific ops callbacks
 dynamically
Message-ID: <20210929103823.GK2048@kadam>
References: <cover.1632909221.git.leonro@nvidia.com>
 <4e99e3996118ce0e2da5367b8fc2a427095dfffd.1632909221.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e99e3996118ce0e2da5367b8fc2a427095dfffd.1632909221.git.leonro@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 10:38:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bf1bc9f-648d-4bcf-548d-08d9833557e5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1357D28504EAC8CA794FBAE68EA99@MWHPR10MB1357.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: scSDOhVSeH/Gkm7syrLKlXQD90HahosoWcnjWzYaxT4lxyLWUh+wXI53EC4uudNiDg2gLchnCDUmZKjUNw+a+U8NYYaGsjdHMS6x+dnfS3e3mryFiAzdbbWHKluLQBVyPMX+L3AZUwtJ2G+jP2IqHzsK+fKWPXPfgK7V0w+aSz11Quhq3JOxfDz+UetYZZi3j1NH0LjJAgwv60XLWHOI51FwfIEqjfTN6NPsQsOq7uXO9HaCG0RMXcR52mEhwel3bIg/rTaSQzrjf0zP0X9UETHDYLZeue1FF+/rLz49DyIGUB4byqg8zFA/UhW2qQsczinvx/ot2v4vT2KAW7YwD0F/SMYQDYntBQEZ458CrarrNLGDophlmJZv84yQLOtqHb6RaQCPXqetFDDDpi0Pl2L+vvi9ctScdTEq41c8KLGL7DMf4dgmw5qhIUCCzpg4B0R48/Se4IB8X/e5IQJrL3iVXCWGLTinZGvDhuoDQ6t+XftDYZ3kVixzbsPaC+wXfyH5LqsNrrwv8Zeurv33knaJXHyojDdaZBKQv4J3sZGn7HRRoIC0gIuIKHnHpnl6wONKSoQolhV9T29oTaz8nsPe7dCBhZx9DDXX4YHla0Q0r5iclFxO+B2vbqc1xCaFcYN3/4c3AegtZWUafBNCb4oBNNLhwfDLAAqcaD2NOWxFQzpziwVVkW6ftML+65BpSLRBt55uhn0erQwD4G5gRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(38100700002)(186003)(6916009)(9576002)(1076003)(44832011)(66476007)(2906002)(8676002)(508600001)(66556008)(66946007)(956004)(33716001)(38350700002)(4326008)(5660300002)(6496006)(4744005)(26005)(52116002)(83380400001)(33656002)(316002)(9686003)(8936002)(7416002)(7366002)(7406005)(54906003)(6666004)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uIfQ8Fehrm9tEZlVWjjz0zq5pNIXQ4hRUGgEzu+q66Pf41uFOuVxkThLUyHu?=
 =?us-ascii?Q?XSwQ/l3dTRavDtCmn7d6lkr7FnleWvo0NfzCdNpDtc6kS5cn17g4uasN8BW/?=
 =?us-ascii?Q?VefZUdyIPL1lrPhi/oDWWu2m3jdaVPWU1143tRPZS9K2x3tM1hV7VwyIMSgT?=
 =?us-ascii?Q?MggcCaxaMNzX41dRMld6NApDWJMMbzRIyanL+0nAP9cAgagasebJetEiZT8z?=
 =?us-ascii?Q?REdoyqCfJN7wPKekE+cpTQwkJANT1jxdntGlhMsDChE88m9S6cl3tnv6Jq41?=
 =?us-ascii?Q?ln6YziYaaC+DKwmtHxD/ZofzzbNCOQ/RZOT4TW/M2iwsk0Bqv37P1rZHaIgf?=
 =?us-ascii?Q?xRnFQku/S/tMmIVNBtTzxUnVwGnAvUfDpguMsf2S8OBIRa5PB3ty0I8Vk1G/?=
 =?us-ascii?Q?yD2ZRcMkiqtFIaJFOtg9evXb3zMQH0yhDGVosIOjsIQrWylbe5BCs+4geNrn?=
 =?us-ascii?Q?cMvrZ91iPH/AYQna75K/Dxt18YNOP01SgebDFkdm1UZQ/9YSZSEal7s+v5xH?=
 =?us-ascii?Q?/5unjC8r/Sm6tA6EqR6k3BbqSIlWgQuiNaOxnV9mgH7J0FMds1pvXiFcf0Jk?=
 =?us-ascii?Q?zRpnkZUAF3/FwOFMGALI7EEYLgl+bekknC3+mwAvPnkRzRdBTbUlXyzI2VzF?=
 =?us-ascii?Q?re5iml2WyIZ9v5f0sCZcHA5ihQccffx0bpNtoHFiJ0782Ap7WJOgxfzuwGo6?=
 =?us-ascii?Q?xNN72f5LIihJ1gXeDQn/tks5q9DPeBfMZD+pm+iRBAJtXns7pU8TSXSjFtTc?=
 =?us-ascii?Q?n/cB2gCqlGZUDH034nxjX3zi0donyUlqDfxn/J1xh0w3NqEmywSpmE4xYKDq?=
 =?us-ascii?Q?4PQxijFReZhMXzPv66uo/eD5ZqEVLghzvZRF6iGffUHSF6EUngCY5aX/5RJQ?=
 =?us-ascii?Q?eH1HMb9gimILdSvrmgDPabRYFPAu2hUj/s/y5hHNY8ztLKpWvB0Oz6ZXE4Gn?=
 =?us-ascii?Q?NuUaQ1a3og8tfLI4OpHTdgU0v6Z7Zt0gglZ1RsftjLj/NGCU6hvMUu4YX8xt?=
 =?us-ascii?Q?nRBWl0UwUMn0HedGdKQ2NRsfYhHhtucIM+D0tTHqAO85ajsL1RGQgNNY74rC?=
 =?us-ascii?Q?SMVX27pdBNNGFzav4HI755W/hGGJGtTiLHbbQbxEed300FdnYpERbqwmfwS5?=
 =?us-ascii?Q?aq1g77AI0ON9JuzrhPTiXyv7bEkUh5kK+aaxqDyN5xf9zMBtYViilJlGQ+EB?=
 =?us-ascii?Q?pOVCEU7oXaL8HZI2n3yhYTI62Rr+7NdirUMq/RR77U67bR18kEsksCPsoMBy?=
 =?us-ascii?Q?X12X8GDZj+P5dyHb5sHSijkTndGfSNgC4DfpyEATM+Vd16+t0XQGVPG43HsK?=
 =?us-ascii?Q?wOIKK88h83vX/EKOyojKJMni?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf1bc9f-648d-4bcf-548d-08d9833557e5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 10:38:58.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rlCtdwjpVkNY+6F+61rRo1x/kgCUSY30oFwGX00k+yKfXt7yK46bFwHO58/JIhpBe7r2GXBK4lzSFpBTsviumFuxCPvGub2pE4Rj7Q0Jx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1357
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290064
X-Proofpoint-GUID: HOEwaQlaaYXXR0KcftdVlVUNiW5OhuKo
X-Proofpoint-ORIG-GUID: HOEwaQlaaYXXR0KcftdVlVUNiW5OhuKo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 01:16:37PM +0300, Leon Romanovsky wrote:
> +void devlink_set_ops(struct devlink *devlink, struct devlink_ops *ops)
> +{
> +	struct devlink_ops *dev_ops = devlink->ops;
> +
> +	WARN_ON(!devlink_reload_actions_valid(ops));
> +
> +#define SET_DEVICE_OP(ptr, name)                                               \
> +	do {                                                                   \
> +		if (ops->name)                                                 \

Could you make "ops" a parameter of the macro instead of hard coding it?

regards,
dan carpenter

> +			if (!((ptr)->name))				       \
> +				(ptr)->name = ops->name;                       \
> +	} while (0)
> +
> +	/* Keep sorted */
> +	SET_DEVICE_OP(dev_ops, reload_actions);
> +	SET_DEVICE_OP(dev_ops, reload_down);
> +	SET_DEVICE_OP(dev_ops, reload_limits);
> +	SET_DEVICE_OP(dev_ops, reload_up);
> +
> +#undef SET_DEVICE_OP
> +}
> +EXPORT_SYMBOL_GPL(devlink_set_ops);

