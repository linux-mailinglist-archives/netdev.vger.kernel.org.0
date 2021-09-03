Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FBE3FFBC7
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348289AbhICIVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:21:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:55958 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234836AbhICIVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:21:05 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1836Ffh2014570;
        Fri, 3 Sep 2021 08:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=bx7V2zfbFmGATzxGXL9k9x/XEwjkF2Sf+f51miWhHhs=;
 b=CLO45qJ1AAsTa0R4wQ8slcjnGK4Nq/5Lm90gWaSVPHKx/wvgI49cVKes266GmRTkeM0d
 RzsX2PwqNBTD/nbq11iEqvY0+oDMyBtWpOwXEaplUXA9Mt9aHRqau3/p/+tMw0Lhh5Qr
 hYWltZ8nTUFba0cpoUInI3ObfLMR659+Gmgi7V4zh999X1/iHQUSOFCh3a46GnNXxsyx
 +bjoZpDbB85mU56QIGNHdMke1+Vmhxi5TDZXDxmSq1p15AxTOoJIFwWRWALw0fHVBwB3
 iVyrUlGun4MWNlL0sOQJL5b2/PHRsJGAp1hqo4SY3U2CIhCi++06U9rBRTwHxlOob/Bt Kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=bx7V2zfbFmGATzxGXL9k9x/XEwjkF2Sf+f51miWhHhs=;
 b=jvKPONwjFwEZY8MtQnqpudHkjbYyYQoxVR4ZG6O/PVqeorpD0ew4edhJIxfc6N+0F1wF
 AxO9R77UfxV4sAzB7eeU58MTRff74beDvyWJC+0MRggP+uTpRehaggzM1E9QF6JALhrs
 o91QsT6WJNfMDU1rP7fqPdjnb4LDaPpH4rzfv9HKMpkBkCZDjCMst3nKN55KBKNPe+Mq
 I71QoOfYgEUNiZJ6JyI7k9Up66hsvt2vZ0NvxBdJOY4ak6DnpcRkpVps6uvp0XuVRvaZ
 5+Ay/v7i2DUxJ7DGn1FySlKvXtj49H5XsCvmvzDaSsWr/FL9P3TD10vSsx8VFlBhxoSb IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aue9fr971-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 08:19:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1838A0gP033321;
        Fri, 3 Sep 2021 08:19:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by userp3020.oracle.com with ESMTP id 3ate017bgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Sep 2021 08:19:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcuRaOQmoo1sRRURa6k63s3J3QBisvOCb7TNRhWPCNUjgAn8riy2vc8YWVZvXC0SL2aBTlcpqzY3yy9KOrx3o/xWAuubTi3m3JptDIt8F3EkTOo5KsLoplBOVwARe6YZnhCAs8Vz0ii1whCYdaW/aXI0j5RtTBGNucJ3BSGnoyhIfJ+A5VSGCaeIEe+8BisYjGf5eapRym2xqH6NWiCbgpBj9H+Pl9D3xmQ6sUysUaUbhC03o2KuZrMpsscsyHkhu4U0I7irLGXFELfM/NT9lJFcPL3IjRXBmGJE2I0jfr91B0BDt6p4PdgQn6c9CiHmvxB2UiuY59vjtMyVW/iJEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx7V2zfbFmGATzxGXL9k9x/XEwjkF2Sf+f51miWhHhs=;
 b=P1t7/tMDLE49v+0a6Yr91yK6l87rz/tNUf3pxiLuO02muvbX3A4Ba11hNgg5kfODCY7Hya4y/Pt70BEkfioleT5gTSdQd+Is1meK1FrstJ4ZA4FK+Kz+Eipj/wb5lyixlu/JRc29oBQXkVe/Lrnoqqzf/taiXtsRH+pEIRfvmZ62DU3Mkl3TWpZk4NUxTHU2BHGIm1K8B8C8a56w7MbyDaLhmAoaWA2u9P3rDCTlEjavJNePHgUt+CQXM8P3IFCInMSN9V6RtBam1inDPwm3bEL28WwShuxIbshWn8rcmMMKTvyLV3U2PWLOM0b3M5/C/dfTqOt1V2NHwAOPCR531w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx7V2zfbFmGATzxGXL9k9x/XEwjkF2Sf+f51miWhHhs=;
 b=GetmRLj9u0NAG02g72ReLjgnfd3VcZ/SN3HK2mqhcjZeq0cMaDfDHtt+qq0a+nTUlsWZMkzPsxTQxoCXWqQieU0YoseGLrUP1Hoqk5YW7X6i7H43WJmNKULcZqlnGr1lGNaGvehH3TYuC/MIpBNflWUYVo9DStusjFjbxSUDo3k=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1248.namprd10.prod.outlook.com
 (2603:10b6:301:8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 08:19:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 08:19:49 +0000
Date:   Fri, 3 Sep 2021 11:19:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        pierre-louis.bossart@linux.intel.com, drorx.moshe@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pnvm: Fix a memory leak in
 'iwl_pnvm_get_from_fs()'
Message-ID: <20210903081929.GB1957@kadam>
References: <1b5d80f54c1dbf85710fd285243932943b498fe7.1630614969.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b5d80f54c1dbf85710fd285243932943b498fe7.1630614969.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0008.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0008.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 08:19:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b97f81c6-03b3-469c-cdc4-08d96eb3988e
X-MS-TrafficTypeDiagnostic: MWHPR10MB1248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB12484BCB05B396BC9C4ACE3A8ECF9@MWHPR10MB1248.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yjyOl8h1bCKEyA0tW8dbPLyBqeft01itfary7mzFIgBB9bkSmN4CxS/M6WFT63Fx/QIKCN7D7RC7wheOTeDO1BMo0yWh3Ny7yKWgeVBelVn9OHty/VuxePa4KvwZEB0/j94UY61xdcduMUE1+5Aqtpx8Muu9Ldu+58dIJ26ov+A+RkjOZxhPNPc3LrU5nWrdhhi08n/PkKllq107izZVZbgnPX/YWzYucKRnYQ9XRTwBCtNwsuLrNIQCe3IowFjwlArH/e2lQFTXigpW+LOBzCCpLzAZ2xXl8sO5a+B1qAqCrjVveRUiduHUfLELgH+41e6mjCBlkAavgExxKRNy74qAJ7uLNr6RHktHqYYm7Lsa8oTVrU2b7UwKyxqWftlmRzSU+I0m6Cy7AGv0dSbPqbzPiBnmdfx1VYMlaBaG6U0e+Yu/PvW67kxznvSeNYi+TU69i7bH6uAGm+ktpCIvohdPMN6wY/IdMy8iD79HdhqAsB+8R4cuvbbOewVplq7MdxKt85Kvk5+W1W0CC/dAL4KdtP4ORbDH1RPWaUs5wwSvzqpwlIjFTC3p/+GCbRbwTeVbFAtuN3DmX/TMW7l2bQ3KTlvl9LzTNJBCe2LHxP0U7AhUodaStD59BQNJ7WyYQPYqo/wEkiUUse7r62PuFvG/a1LAtZTr3IF64h/bBQI2EZ0HPkGkZvfZ++H+DSJYIQ/qPgE/5IzTDN1mbCpa5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(366004)(396003)(33716001)(66946007)(66556008)(38100700002)(38350700002)(6496006)(186003)(478600001)(52116002)(66476007)(44832011)(5660300002)(6666004)(26005)(9686003)(2906002)(4326008)(33656002)(6916009)(55016002)(8676002)(8936002)(86362001)(316002)(83380400001)(7416002)(956004)(9576002)(1076003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Er59UJ+wZ4TkE8d+BMOYugREaHqugcubcWZEcsppvf9R8YNRg83KP8Oo1UPe?=
 =?us-ascii?Q?2CvfWl0waa8Wtz+T7QwgUnKXdEzCxw6b629LpgxkVGYQw75P2iQ937QH+nKP?=
 =?us-ascii?Q?6L4MuqHeMQA6I5PTeQzyFHAxkcIOSlsWFe1sI4YxwW1pEBK2YJN78HO1dmGN?=
 =?us-ascii?Q?Rv3Q5Huc4UJ4H+DixkVxtMk7t1y58GKVW81zex5Rs+FhubblKegv2tgvahfz?=
 =?us-ascii?Q?aWouLOzIOLPwl92NIzg7Morsyma18urHgBsA3uZF6BdEzw6Es04aueAdcAyl?=
 =?us-ascii?Q?atJDcd3rX8O5rlAx2Wk/ZBpsWiYqZpMtDhZZlTh3EWMblwPBMxzlhvJhDpoX?=
 =?us-ascii?Q?T+gtjhsMhBdoCMhMp2N7o2LCeuS/Q3T6ZoaCzrFpT3x1j1l3toP1j1rP/4dx?=
 =?us-ascii?Q?tNnVuU4mH1D/Qe1e6lcnLjukGTnvH7lpKtOKvVrleYcVls/1zR7MsMuQ8Sy0?=
 =?us-ascii?Q?RIl2TQ58Z3XOABOhJWnFqmL2nToiLRzlw0b3ZzRismihzquNfrEkaXiT2hx0?=
 =?us-ascii?Q?161dyLPPsxifa4KW+/pFHPEH0XMJpbPmL5bFbuPuwRpGQ09B3j4mKJyMBoVw?=
 =?us-ascii?Q?7zsLuNYMJyCOXwGVYq68o4Cu8cw9GSJ7FW1MrDEsKQjwt+2AOWYLCympOz2i?=
 =?us-ascii?Q?cge5PiuvqpjoE3rbpK86C4UZRd+gmA1MXaPLi31oa38dAB03beUsmkqRgPVZ?=
 =?us-ascii?Q?GinA4U/uSyqGHIndJoObL+9nLqKwv3FoHhfIF7jXEJppJ1Gqz0lGMZApSBVA?=
 =?us-ascii?Q?+TMVHWsNcqsHybioa9k1SK1JfbRg48PZGFz3SbIx4DDRzZVGqPvyNDOMg4vx?=
 =?us-ascii?Q?q45FCoxYwhoI0ec/kpxJKj5/a4EdC51CNq1sfucub075t17/xSFmUwUUy+Qq?=
 =?us-ascii?Q?ZSftiEjhbIYBPltNltXXkDYKrOfJmjAL2dhDyyc+b6L873zejDtAu8iGrDgL?=
 =?us-ascii?Q?sde80JIPK7TXEpVomeCztigxvLfblcpawCU7zl0+3BNg7bymT381tKR08+xV?=
 =?us-ascii?Q?RvBemslIrNcBY0lMuiI8Itxf9GyncGUlrS0PzxAhoj6VZ8aaT2XaTlEW5DUj?=
 =?us-ascii?Q?Nv3vFnhRY7zuCRytQWzFf00blmndbeBvG66ujJQ/poR5+aP7htRQqpk07h+6?=
 =?us-ascii?Q?k/jiTyjDSlpy7ONvSkAEJyca4L2D79uNYEiQBRH//ven7DEokguUm2MBmzAu?=
 =?us-ascii?Q?IqAG/x69vsvJfPcNz/tWLNcMLsPB1We1J7Zbc8PyLN1lRBbsaU6WWNQDqAI5?=
 =?us-ascii?Q?F5J9C2Yeio4YjXasvOgJp3Uw0H4R6lDcKOy6750GuL4/PeTCssg4CvADoKBv?=
 =?us-ascii?Q?UGVDIsUPsQJZLQ5qYrC8TY9w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b97f81c6-03b3-469c-cdc4-08d96eb3988e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 08:19:48.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAg9NjhvQBGwxJ8GDzht6L+z+Z+cWJnXQlxq1abLKZSnO8yHeULoUVlJ/yMlrjQJIpF3tVeOdyjgv7QPeqIUuPjlpR40tyI+XsnCxBUfGis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1248
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10095 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109030049
X-Proofpoint-GUID: tOuq-YDE7MWPqpV8aDqKcgsccchGkLMF
X-Proofpoint-ORIG-GUID: tOuq-YDE7MWPqpV8aDqKcgsccchGkLMF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 10:38:11PM +0200, Christophe JAILLET wrote:
> A firmware is requested but never released in this function. This leads to
> a memory leak in the normal execution path.
> 
> Add the missing 'release_firmware()' call.
> Also introduce a temp variable (new_len) in order to keep the value of
> 'pnvm->size' after the firmware has been released.
> 
> Fixes: cdda18fbbefa ("iwlwifi: pnvm: move file loading code to a separate function")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


