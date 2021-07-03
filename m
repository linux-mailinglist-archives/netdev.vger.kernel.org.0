Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6667B3BA82D
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 11:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhGCJwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 05:52:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57330 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229981AbhGCJwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 05:52:30 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1639lCPf018898;
        Sat, 3 Jul 2021 09:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=5kfS2EGXNPFBMlsgCSre09THnCJjwsWMakvRnmjKSwQ=;
 b=D1/Tb5TOp/GQDTAUauQzD9hLCWHBSptOnBspqGUNpfmyq+HGS4mBanBgCQ8AZRn1jqJG
 inVt0/TrWMBvZVfGvcYZZ0Ml2CI+W7XAkSL27MS4KIyGUpZUfYUQmjSK6AppYQGxFMiA
 ezQAJ8UDdJynvh3L0ktAUczBVVY4vPGlIhJUKsOoWkx9P+ujBclopt4nYf7bEmcgXOCi
 T6Sli98HPq2Kkql5hlxNUny5Fv1GqUFoRi8Q/GeWK7jiYJ+tTETTaJBmFzJrQPD2zkBk
 YtcbbnMrMWZyCNugvWw4nV/8zFvLS+EoKahvTxNhnyQLefnSRwOboY1pcKMSBgMUZDNf jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39jeg1g9ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Jul 2021 09:49:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1639k4FV043061;
        Sat, 3 Jul 2021 09:49:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 39jfq2vyaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Jul 2021 09:49:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/VDZRNeu1zWTF5akNbMFXL/9TSAdS/e9+SuLcwi2A0aPGFU92DoL3kjpy0hIfCK2QUcHN1zt7/kcbswgg+x8ilOdVqg4lSiftk+lYLdGhNQBJ53q0Qx19ZwOG3iLAKMq2DOYMrdClxr/JB/jBmaVsFKDd8fddz8V6m4RDcX0pLkgQd/KKTrYQr0Z7HaOmqnOVQecyGrrHXmFV1Nn2d3Q/00oyphIyyE04l+FHN5ewogmF7LZLujbpeWEPhRXkFSuOmjgN2m0gIP64Dl/xEvVA1H7o2lK5kiePFS10qeW5OZ+TkoJX9kIpRuuaVCANti3hqCTGhV2zzkZO1XPQaH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kfS2EGXNPFBMlsgCSre09THnCJjwsWMakvRnmjKSwQ=;
 b=A3fBXhpNY0N1+jNSFxpJAbYSGEbox0hyGWb9ITukZvjAy5au+DvpzAqfJK81ngOQe0AlKP0MnF5KTFpb9wfSjROo2cyEOIQtSsCUgvs6idP5/e7AicWVgMKfTEvrBC7dN3Gf/2Gb0yb9Rc71x2Gnq81xIXAnjEqze1RfR8MIPdoHxH9tMN9aw/DL+CZbrT4HZE2pT7HQzEgdi9nVxp6SHPVV9wnA3EKB57jNRB1cNn4Yu9TPBg9efe2A25H2yhTOSuxGG+NDPwAYHAjqZE07WAQOfpYe2qK06m8mQ/Z1Sfzhjm12Oofr04W49iAMlJAcFSmMVYF23RUHvnNAeIntMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kfS2EGXNPFBMlsgCSre09THnCJjwsWMakvRnmjKSwQ=;
 b=HnQWjGkvu4UcDEjE28dYJY06zVj9xU5DKzJg7k+JQnKH8IdQg8qjA2qNXpyQiGLANEx7jxYz3CPuaNhwhid7lTEIavv0Os4Ws95hg90/6uWeS9JHDfuVG2MZjjnzwXYfys9Dn5VyJSgGBQl6H6rosejtPfzwj/H4DRRhTSUPHGg=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1568.namprd10.prod.outlook.com
 (2603:10b6:300:26::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Sat, 3 Jul
 2021 09:49:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.030; Sat, 3 Jul 2021
 09:49:47 +0000
Date:   Sat, 3 Jul 2021 12:49:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Colin King <colin.king@canonical.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kbuild-all@lists.01.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iavf: remove redundant null check on key
Message-ID: <20210703092040.GX2040@kadam>
References: <20210702112720.16006-1-colin.king@canonical.com>
 <202107030209.xwGHO2JN-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202107030209.xwGHO2JN-lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [102.222.70.252]
X-ClientProxiedBy: JNAP275CA0037.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0037.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Sat, 3 Jul 2021 09:49:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e3f4213-dfaa-4613-0b6d-08d93e07e49f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB156851EFF19F361D8C8A41208E1E9@MWHPR10MB1568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:534;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Se7n3l9kyXiRxGxO7FsL0kYxqq3QId9krR3sFwD0VUTE3ousu6aclvjLsy8HWJ1Z/G6MYvlXkZgyMEZQaxm6VsjvovGXJIupDKlYaWm9Ez+EiiNqTH/ljz6W4kYWM0wxMrj+knlxQZIsASZcLKTA0cdT31aGN4cqHiZQQyIYHSSvW6CMmzlnNB9GsnTQYTuzL42yQmUjFF9aOiecgGnxUqGtXSCMkFODjhXb3IXt8+2h7TGAr+/+27rOdJoaB8t7xGpiEGExqkxvZk22IcidwL1hv0kx8GQ5HbU7Aq1mzZ5/gWHa2MWhR7vcBi3/DnHx1eloiVvBwVAM1w3aEktWegWJSKzLHMUdIQWIp2ydk4Su2UOflc1Hk3Akj6t9j0bOxVaX5qxxQBUSNbJTIrhlB0M4BvaqjrLEURP/1qpmwZlgSUjMzzcOF1mf3kCBPtyIFQMY6FmfWUjvu6CN58aPz2B+HyTedyjcVWKWK/dSv7LUy9JXnyEfxmLGQTIYlX7m33dSxMpmKdXbjCmkrXNzrurAgy3QrHpuoBYnM58Nn6Qt80685EoPJq4jLyH7rksIob/FHA/3Pj5ejiSgHWVpVCd8L3lVtWUclK8muUKwzP/Bpk7cIOPSOrMLaajR7n6orTrWXAhM2SF2Q+0mZaFF/tS+jTK/7L2+8asGil1PazUSmR3IZQM1xvZU/TWAkVDp0mfKXiGLfDtQnfyvz5CVDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(478600001)(7416002)(186003)(66946007)(83380400001)(4326008)(1076003)(33656002)(9686003)(9576002)(33716001)(26005)(66476007)(66556008)(8676002)(54906003)(6496006)(6666004)(55016002)(316002)(52116002)(38100700002)(38350700002)(2906002)(16526019)(4001150100001)(5660300002)(8936002)(6916009)(956004)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EeelIUiTXAuIzCW5z03SGzSUvsqQ8McBcfQV9f8AynQlwX5cBvGDAVfsECe6?=
 =?us-ascii?Q?HOUifd96viK1B1i49GMN8iZjeX77fV0YvDkYtZW+0NtdEvOCAepNLoie78Sn?=
 =?us-ascii?Q?WN3rM1bnOY9QX1zi1auN3GgC3qYTd7USdx8DNwv/ScI/hd2Fed4KkJoNQhHn?=
 =?us-ascii?Q?Cz8iS2MHk+e8Av1XtxK1iDh2LHd6w+XvSINwiZqwIfO7ZTgen6j9boVVJyRi?=
 =?us-ascii?Q?kvHAFmOYn9f9jkCOjCDKP+hI4BMVpW5wEeDVAMq60o7VcoJDHpGLehxFSth0?=
 =?us-ascii?Q?a6z3/iGZr16bx7hSN+enZ0w7r3ZlxeRnpEL0foQdjgZhdrpxn7WteRDqY1pm?=
 =?us-ascii?Q?+UR5nrJDPFGnLzoHqj4EzFawUAPbtz8gJNMPYI7T0khclKeBMbtZY/I0mhSS?=
 =?us-ascii?Q?f5Y02xXmjmsBL7g+nVto/fsGvCB7QAjWV0t/hh5HIf0aQHR0p9OQRyUCVmtP?=
 =?us-ascii?Q?W/abmuxsAh8RFQ3fivKjLNAPIiibDz0K8ky1m2mRgafD/5xxYRL+/yhPEf3B?=
 =?us-ascii?Q?h0k4WYwdT6wcKEh8/42KAs+A2phCOTVjSqawlc6Aj4xQHYHPsdGvKT2w06lO?=
 =?us-ascii?Q?W8Yz0ve0ukzQV7sATglaUE7fZeq5nlF/tOPXjFkV9/5/CVq/O4Pvu7rWibKc?=
 =?us-ascii?Q?gpO89OJFd0Jwsk+ELpAEjAdaXFONGvKl2Vx6iEvOq+D+cUOdrl3Grs0cId02?=
 =?us-ascii?Q?JtTN3P+IWBf/OY1BKpcebh4fvtcOYGXfK8lkYUajvgcS0cT2glVAUysV6PNL?=
 =?us-ascii?Q?aGA+Eb4eSLyBptgldeuDn0bEo7W619+fennfwkXjniGq+JUdzIxeQPGG2gi7?=
 =?us-ascii?Q?pSUIlKTuHORkrwiRJ1OExQ7M6avAKfrtfSe+Vh5H2u87bkAT+P7Opm8k020C?=
 =?us-ascii?Q?AzJk7xJaHA5lddPmGgpfP2w7RWQjlWOnmAsDwCy75lksDg1laWaqKFTSCu+v?=
 =?us-ascii?Q?mH99swXBkZSSW3k1mmJGXRFCjndqaTqvU/K1xxY7zGN9UcmKQB05qCAfrxy3?=
 =?us-ascii?Q?2Y+2lRDehX8hKj2tsWw+8VR7CSzd1reRg1SydbTTiZ3o5IVKC+y+qWHy/gmZ?=
 =?us-ascii?Q?89WgNjn47/Vr9lDps9Zo56HbAhnpXc9kIjhm8a87VBXXxDlHoan9C6xQ2pLn?=
 =?us-ascii?Q?XpuAo91d0fOuxHS7o2AqOmMZ8pW0oLNvZAkuCQrBK5pNkgi0gvsJSp7HK7ZL?=
 =?us-ascii?Q?M3BuM5lf0yoRW4DDD6Yu2BQwrbkPHKGGbLpeCRUo9Iq+02FXoExPs5QUiUyM?=
 =?us-ascii?Q?7VqHjizuFAlKeo7JZOU6Qb4W+Ab3v33ieZgLLYktptO9sDPKQiUYfKcsvFkm?=
 =?us-ascii?Q?X5gGIN89kjG8I7o5B6Nx5PeH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3f4213-dfaa-4613-0b6d-08d93e07e49f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 09:49:47.3795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0eJp1wgOsZD3j8lyqrFxAmM5af15jSGZbdmLyhWftzxxX0LWUYlgFbmhRlXYPEF2M1SE6WpylXFNTH7yGl6akl3UBIZUpWNdB9sMVw+HSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10033 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107030060
X-Proofpoint-GUID: xT7QdpRBXMKJmHTB0Xom3jBLIc_aAjLc
X-Proofpoint-ORIG-GUID: xT7QdpRBXMKJmHTB0Xom3jBLIc_aAjLc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 03, 2021 at 02:43:46AM +0800, kernel test robot wrote:
> 129cf89e585676 drivers/net/ethernet/intel/iavf/i40evf_ethtool.c   Jesse Brandeburg 2018-09-14  1899  static int iavf_set_rxfh(struct net_device *netdev, const u32 *indir,
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1900  			 const u8 *key, const u8 hfunc)
> 4e9dc31f696ae8 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Mitch A Williams 2014-04-01  1901  {
> 129cf89e585676 drivers/net/ethernet/intel/iavf/i40evf_ethtool.c   Jesse Brandeburg 2018-09-14  1902  	struct iavf_adapter *adapter = netdev_priv(netdev);
> 2c86ac3c70794f drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Helin Zhang      2015-10-27  1903  	u16 i;
> 4e9dc31f696ae8 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Mitch A Williams 2014-04-01  1904  
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1905  	/* We do not allow change in unsupported parameters */
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1906  	if (key ||
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1907  	    (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP))
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1908  		return -EOPNOTSUPP;
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1909  	if (!indir)
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1910  		return 0;
> 892311f66f2411 drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Eyal Perry       2014-12-02  1911  
> 43a3d9ba34c9ca drivers/net/ethernet/intel/i40evf/i40evf_ethtool.c Mitch Williams   2016-04-12 @1912  	memcpy(adapter->rss_key, key, adapter->rss_key_size);

Heh...  There have been a bunch of patches modifying the behavior if
"key" is non-NULL and no one noticed that it's actually impossible.

:P

regards,
dan carpenter

