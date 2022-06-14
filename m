Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F6154AA8F
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 09:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354428AbiFNH1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 03:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354400AbiFNH1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 03:27:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7E73DDF4;
        Tue, 14 Jun 2022 00:27:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E7Oh4d025264;
        Tue, 14 Jun 2022 07:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=U+hNwDrUtPWfXGF9B94Q6u8Uj59Tn6Q8OhZImLk1Lj8=;
 b=rREld7WtZKLWiuI3XNXTZOwXoTn+oj4rvRWFBGi/nzbJWafer1CIk4DfiUOIHvG4V4dy
 AM9YzLN75Hcn+nLZK3DAlD1Y4d9FgMwowCYgy0e8epV9BU2I96DJs+KJf3muc6EK/6li
 x+95/w10faOWwN9wQR88V+hfg04Y35Uo+WqloGJAZCrS3I7srwgfg4CEjIC0+Z59A9yr
 Pve/LEHR53MH5/YO2FmZ/3KWk2e8U7JUwP7trk6iqBDgS5ZDbaDQtpmVBPlHu04Fvk0m
 02UfZm17O+FAh53NinDXQ8qk1Ii4HlJsvrFYJ5KdsqZ6qoQXsq0TOV8FiYKipKPWnvRQ fQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn0d1v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 07:26:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25E7GEE3012996;
        Tue, 14 Jun 2022 07:26:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpn2msgyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 07:26:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCb++eyBhQWTQpTbUV2J4isUaH/f7PBvQa1POPNjTZs0Ou2RlOWDjdsEirFSxnXIVva29x1hYV5FfRln/K9SYm/lqzsd5JubAbWuAqS4N6K8oCCDMToaJKzynuF/vSjVZ2TbpQuYHG/fhuM3lPgKUsCg1mXadU2ZHl+iyKBNtjZnfSqLxzkn5S2vYl6cWhD6QH1tzppDSLXR7eEugbS2grJbB9b2lBZ32Ecrq9itQQEjytAluICkrkYGMIGrcz/nGm+046VTGL7yPuxZUpoLuUGk0mfwCypnUmTqGr/h7IQQjUrQbejTyynTlqQL+jtt5SesgZ0lCu+0oOj2vPQfQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+hNwDrUtPWfXGF9B94Q6u8Uj59Tn6Q8OhZImLk1Lj8=;
 b=J9hfPbOj7RHId326IEedujIIiUxlWPfNZFmWk+OGbiFZamP3eHb+Zdpw+dSONk99uwx2JRR+58klqeBhcGsI81qPADRt9IembFld0gRO7awALpaVPsxgB7iG1KHT0kqRhnL/AL6Hz0rwfZd3TzJRM8lVAqmbKSUeb2kMx0x7Yfqbp6xsb3giE7PtuayOLwqWYzOAq5WLG3KP+JRSA20mCooJEPWG2eVD8M7q3ZwgYhfAgaemzDkcxMyd3EScmi8STiXJPt2JvFpVl6oUIi/OPgzXXGnowUkMbjiePP0ddQUS3plynnUI76pigZtMmtAlhUwrM6UnEVdDQVdzMIs84w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+hNwDrUtPWfXGF9B94Q6u8Uj59Tn6Q8OhZImLk1Lj8=;
 b=H5p8GGDGY5xOwJ2ZYEXUOBHDBSUOOjQojAotJLYnT5reU6A7YHRo1Xufqg1MyqbiY9QMgbgn6QYOC3jTQbl3QvzyYesZzK5NanpvScuT4WU7l32Q8IORsxVIax5yDNyrdoCSa6IAamDY6IC7ByhwQ0OoAckpy0j38Dn0eUzNYHY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1548.namprd10.prod.outlook.com
 (2603:10b6:3:13::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Tue, 14 Jun
 2022 07:25:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 07:25:52 +0000
Date:   Tue, 14 Jun 2022 10:25:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Message-ID: <20220614072505.GH2146@kadam>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
 <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1837cddf-1b59-4ebf-1781-08da4dd71c87
X-MS-TrafficTypeDiagnostic: DM5PR10MB1548:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB15482FFC4DDC41E31043E3878EAA9@DM5PR10MB1548.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmcZ5o9LmjXRijP6v5+sq86KxABxjWEF9NkBVmSHO8ZJ1k6oQ/PqqiJzYtnm6A096O1dJHvBkoIq1sZJaGHGZ4dffzZ3gcik/QsjydlqHhkaSp7jTmMWvRv09K7QYicakhKmnE9J/Ulbo6kMRYDC4wjRj7lNu/LAX7pswgW97tjActPk20JTUha/1yJWZ+kZ5jvxWpGckRrR6crwccvZaFseIblXfpJhKNQaJXVq/IT6oveRS5sJUt81Bb4PHZsIca+ZGZaZ2vXLsuapq8wYhgWU26vboYkoRpLZOH4nVzBG8qzHpX4yK4CVj7ZSRuvZmsJA1IMpIKn7FiK8cseREtmEjuYwxMlNsSZR5lbnFKapumH/6wLIwny+m+hTDxtbXEZtp1uyE9lYSJyjel8u7ocV0rxz9tyxxLI7MrUZzxZp1PH8xqhqaD90UMm2Jg/fjWPltB3CmPQmWy8ZXrDSZbSy61j1wVyq9JtnX4+jFL/mq7YpjQXxWOpO6JSv/H09Vjr8aMyQzULaR5iEHI0trceHsIaIqZezwav6gnOO5Ig0t+6Hy8A9S9yTRVOzdd4FUiHhkie6GYPsaWGTV0e0o9fQELVSUECMp2WBTJW2YUKai/BVnjIfQ6/KieMR4vw5jA56qbXR80NwZ98cdQCrjZU8IPN4rto521h46jFk3NQnJWALFnrvrtGB3IHwMHNc6Axa9T1WmNUfFs5UhN3tCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(316002)(54906003)(6666004)(26005)(44832011)(38100700002)(6486002)(6506007)(52116002)(508600001)(86362001)(7416002)(5660300002)(6916009)(33656002)(38350700002)(186003)(1076003)(33716001)(6512007)(83380400001)(9686003)(66476007)(8676002)(4326008)(66556008)(4744005)(2906002)(8936002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nNEKfb9K1OC6S6gjVpJeRf1LMF3JZbK/kcT0b0CSYbp2QxWGQ7w9De5bNt82?=
 =?us-ascii?Q?kmwXc9xW1K7XRYuyUKhbeoEciHF9+q+UQAOy0aanS4m4DGosM1CDNsCCR8Pd?=
 =?us-ascii?Q?gz793iZoDEhxu+/6zdEv8njmUAUKVQcSihJXz8vEK1w6X+0QxGGuIc9KnQdb?=
 =?us-ascii?Q?BmBKW7nv7ymeSwJyadQbqH4XxlXF8rE6p/EVf5UEINdHjffSxFss3D6IMi7V?=
 =?us-ascii?Q?T8rqvRzc0cuCmNpAhSJDsvHkZqLAORZ6B/TM3qHfaE6dTM5m/yaz5pWa94Jz?=
 =?us-ascii?Q?OABFR3IJCTcaH5RFmnQJBdlarxehkP1l6zG/ILNbN60LX8DhSlzZBNBOlUYO?=
 =?us-ascii?Q?nevedoaXAJuraanVmTqzu3IbLrLBzCLXYw2lKLuks+O/A6u2N2VuKiJGG6yO?=
 =?us-ascii?Q?bskYG1Y6ziIfGkYFNUVUH8PWVsc7b++pdJ5RJIxOHnOUlNNL1zhvBPPvHa2h?=
 =?us-ascii?Q?1sFtje4zPohHWlfYnVI2n+/7cNzB+UzkeoetSty6hdy53DZmZPxI/84G7ijS?=
 =?us-ascii?Q?aoBK6ZWziF9WDwOROASj/oZxaXx9W9PAxizGSyHajI3lfVRBGXJSs1+zs52P?=
 =?us-ascii?Q?dx/tpJUjyCIT7nsAD9p1Vo+giz7UIbi2LJ8rckU+kBi4UGafhvQBJrQ7dsSh?=
 =?us-ascii?Q?SNQL2+zywZg3OUivajNS/wj1MMuwEVVPSVgWE+4MHwd/HvuytycayVrxMJRN?=
 =?us-ascii?Q?F7k6HFCa8knaM/LrmrGCtOOrYBS84ps4wPpHQnje0ynvfASixxsyxMT2fzIR?=
 =?us-ascii?Q?AgZbCgtrVICU0pgBD+LF0xVDigHPvZkf82JDEB4RkmauL1W7Q/2ltQU7gorQ?=
 =?us-ascii?Q?an3t1S0fPYfJWLE1Ummg1pg0eAAKvxJ+G5K4iIO5FEWs2JE+Hi+IEZQbzC1W?=
 =?us-ascii?Q?NYWKPiuJLdIXM+TDpRr0cebTcKqbaBULAUE52LWnQntC7XrOObSKe0vc4Dx9?=
 =?us-ascii?Q?n7M6t9d32eRvvtn6zgyYQBnPQHGUz2eW+Xf72f/6VeAFOjVU0uZjnerct9p7?=
 =?us-ascii?Q?AjJkNjiDll9dm3zzfMyFYeqbtRoFAR/+q/jJQ4k1nmtWiFuqegmaabmkdVd8?=
 =?us-ascii?Q?AN+eh075XwF0RSBI6ekIOdV/QK/k0VB0OPq+UHc/goN2irHWnNjpgWueS0An?=
 =?us-ascii?Q?9ZTuo13H7uqSvziSnHapx2hr7vRQ8xxTpDi+SDu6iAbpRCop2dzHJFuAHukL?=
 =?us-ascii?Q?TXCK9NfBP4z6HhteYN+yFcMcerFHAypeP/GcJ6qjvytS2O52UHtez0v0kVK6?=
 =?us-ascii?Q?EeCF4989e0+AIAtToyrNPCY/tJ0l8d2lfq1yOcCyd3rIAB6R0aG3AgIZtame?=
 =?us-ascii?Q?7Wg4UGU1uPRUFSWrHg2mm9myLMMGABBqzUbLcpFX+9bBkGHDfQMzqxA1Ftuf?=
 =?us-ascii?Q?l+I33rbDB6K+tn/iGOIylzDVy2ZoMmUjTnjb9O3E7hov8zI8YtRjOvt+Zc71?=
 =?us-ascii?Q?mQSrXG7XnqruOmUFt4C6TLKrmam+CUpbGGYL+dnPlPH1ottQ5phCEeqO3Mp1?=
 =?us-ascii?Q?2yqpF9dgHaqTE9eA2RCtnPtx2dDUtN7PLSii2XJoxHDvk0bz3P8X24TV6ZWk?=
 =?us-ascii?Q?CBLCXHw9pBoBzQDJrduAyCrR7A6v2X+kfXKCpYvypKqhyGdIK0kQ4N0Lu79F?=
 =?us-ascii?Q?q/Vt0xt1RkoPC/MMdJWEV3IGkoFc2vlezeR+EOMXVqxmk+zDlTPLv2mNehZc?=
 =?us-ascii?Q?OjWcMFj4ykANintvAz87/ttB9mG+V1h2woqwgh8vN8fyVYllXte9wmMU3hdP?=
 =?us-ascii?Q?6/QbZ+oEL2m5ickX58rE7IEa9ac/dWk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1837cddf-1b59-4ebf-1781-08da4dd71c87
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 07:25:52.2800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHSr+cWysPxRuapY78k1M4kyN2f12XAPZoogfDPGNWPj9wEx/MDEIaSjpZH8W4w7QYj3A+W9pVDq7DoKrHaFfmuxH861e907hEyQsIhofww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1548
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-14_02:2022-06-13,2022-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=990 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206140028
X-Proofpoint-GUID: JgsZ-gBOeWW1eT2mfBtAX3Q6TMBVX5Ma
X-Proofpoint-ORIG-GUID: JgsZ-gBOeWW1eT2mfBtAX3Q6TMBVX5Ma
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 10:57:25PM +0200, Christophe JAILLET wrote:
> > > ---
> > > v2: reduce diffstat and take advantage on the fact that release_firmware()
> > > checks for NULL
> > 
> > Heh, ok ;) . Now that I see it,  the "ret = p54_parse_firmware(...); ... "
> > could have been replaced with "return p54_parse_firmware(dev, priv->firmware);"
> > so the p54spi.c could shrink another 5-6 lines.
> > 
> > I think leaving p54spi_request_firmware() callee to deal with
> > releasing the firmware
> > in the error case as well is nicer because it gets rid of a "but in
> > this case" complexity.
> 
> 
> Take the one you consider being the best one.
> 
> If it deserves a v3 to axe some lines of code, I can do it but, as said
> previously, v1 is for me the cleaner and more future proof.
> 

I prefered v1 but with s/firmaware/firmware/...

regards,
dan carpenter

