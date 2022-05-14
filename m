Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069AB527381
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 20:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiENSzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 14:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiENSzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 14:55:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B462B7DA;
        Sat, 14 May 2022 11:55:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24EFC8oQ016834;
        Sat, 14 May 2022 18:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=vzJtN8L43ZDs28cd5Sm23sqPSRdBaBvSHXpgRzPOfCU=;
 b=LbORFxYE8ownyCYZ6vldV48hi4dODapB3tOFx0e8PoLTX1Ev7GJLWfH1WYkqJ/zJcIaT
 KLeWmDyZOmV+P0sZNapGzRqVzDI2gpAKtOe5zbh1tp6tCMqaO0tVoiQdsa3GOI05+ium
 azvaPt9iPnlzpaLglrNTIN5CWxw4BTwjzWNBvC0oCd9W+traeXSBEu2L0hMas1V59Xx/
 A7x9r8WPBnHPIHOf2nXd07EKu+bAlyKb0gOY6f0v5oLTCxo0NCBL0z0ZVk5tuwU4Yk+h
 Et4Gde4t3EheBMzXRfWy1o+yZQj1DSk0mDzydEZe4+O8n33amwP3+aOgEtMiZP1s4p2E Bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aa8pbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 May 2022 18:54:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24EIot0X006924;
        Sat, 14 May 2022 18:54:51 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v0n74r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 May 2022 18:54:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEIo+24c8A3VpgZej1dx9KTmnz4ExfyR/YGb3TtvlRpFs4QeVNEa4p7tmp8w4V6C+Uxd1ShPvTxtYj+tITg05vOsUOfELN5d8IG2JtKCcGV73h0U0xBVwGNSfHG8rrGBFpVByI6zZiItaD6+PqEPTX03TAz7f8Ed3fs5KgReF+8Y45hi1YBumQ7ZoStmPvK5ALk/vUWST7mB7x8PTGpLtYIzmMYma+20/AvwSSBaSI9G0oC7IS9Lxi+68tKEG9kF3IxE93y7MZcyCD2zHW0YKBr5kXCUQ8RVXtvkNdaMBQgOh2qeTuAYCF0G28XYtjTOdp+mh4FehZf1eXrG6E6YzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzJtN8L43ZDs28cd5Sm23sqPSRdBaBvSHXpgRzPOfCU=;
 b=SRZyUf1T5hm1xIWrvytyaB9QAAMzxHTwYpiHY47JCDlUzj9briPyD2Zxde+qjR3qW6tgSkOG+E4ctBW4amHN9J9lwd/EhOev7XfPGQ3JtQi9XkalxDMg8sLzcKBtgGEmas+V4OKCWEGwQEVzDXL1c1VZlZqLMtaEcH79UCi9n9A9x8d05giIFSLLcxIAvwLkvUSBQqUral9h+O6ejQAAsByydzfpEkCbWq5kdi2ZL90dB0ER8mQnjkAJklMPFbc3b6bE08EqreBINRvlt5yHg5SENXkf8vMuOGV0+HjZ43vIpLrO0uXmR7EArZoHF6APBEe7zfQR64pAbquHg26ICw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzJtN8L43ZDs28cd5Sm23sqPSRdBaBvSHXpgRzPOfCU=;
 b=iG9JU5I2WO/19DHmQvSyL/UuL6ZUDi+ybe1gDH+0SzY+4opH6HmZEnp1beYZx4SfuNB+beCbj6dy9c5YLKN6K7JE1xPDWMZyBOLPBTmeOIIFE3IK+H9srFkqjfioAxARd/h6pvErdgpepLkj5oEH/G3hiyarThfZ21YQcHXB+iI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR10MB1898.namprd10.prod.outlook.com
 (2603:10b6:3:10e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Sat, 14 May
 2022 18:54:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::c053:117c:bd99:89ba%5]) with mapi id 15.20.5250.013; Sat, 14 May 2022
 18:54:49 +0000
Date:   Sat, 14 May 2022 21:54:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Message-ID: <20220514185425.GI4009@kadam>
References: <20220514133234.33796-1-k.kahurani@gmail.com>
 <ebf3adc8-3e33-7ef3-e74d-29a32640972f@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebf3adc8-3e33-7ef3-e74d-29a32640972f@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0058.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::6)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cae2dc1d-672e-4af3-4192-08da35db38be
X-MS-TrafficTypeDiagnostic: DM5PR10MB1898:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1898B969E2B3227F0F9AEC8E8ECD9@DM5PR10MB1898.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EgSHdEggApg6lA042UgZ7uDs2TyxHYc4skaB6fyIlu5blXO2UBsev065YlM1lrcouW6L3vHTRAZaP1j6ngBN0Icq134E8mCC5fGMIYlfa5mXVNmMH8a3Jqh8dlthHVQsdNMpIr4MWuLY8tuewwyRQf1R+Vo7mMaiF+hbR8Sq9LOsX/LrT9hz+muNPKawc3GgvglkS/ijIOvLmcZZ0p0HXInit8ATB9rs/iky0L6BvRDDoRIRs3I4AAQ+wwosBys1R8aVcO914f+j2J1AeIPTC3NHl62/6LpO3KpJ3ip0UTcaboF1//l5tIJYAR0B//LWheO6BA3sbIHdQas3+wbkEy1mNktmiPmtx0dkv6ptUhVUVIkW0bYmkxsCCjcQkPH5S3WkNKiD9Ms0UFk1LQj+wACWUL6JFWmRWc7zDCjF4zpceRyL8fNQsQuAuJx2lum5PjxynzDHJxO0iI4wclvTA0mMc74RemLKtAXx0wiLMlWFYnfkXpSZq+3LE/AvCbDzTOvNZLwMZFOGaXmcFsUes/V/r0yywk06ziKeps1yc2uCEAwaKMYK6Dx0QvawC32FKGNnJV/lAwFDsBGZE6N0g6v3n8vXKrQZCONmTvmWn9CNNoErmxwb3Oj7zRIcHMCwVfAQVbXIq/+y7I8xt9E95Ldw56Zbar0xU+KOK2uQXVM0UC9Vk+F42W0cHmYJwFL26Ai0lF4FFjj5k8Zx3WowAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8936002)(52116002)(6486002)(9686003)(2906002)(1076003)(186003)(45080400002)(7416002)(508600001)(5660300002)(38100700002)(6666004)(38350700002)(86362001)(33656002)(44832011)(33716001)(4744005)(4326008)(66556008)(66946007)(66476007)(8676002)(6916009)(316002)(6512007)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vYQU3mrStjNQwVptu84OYglmZRl/780hvEm93pHV07GMAGkEi4a2tKEpD1se?=
 =?us-ascii?Q?xvyYAjxFS6FRo9yITC3Gp5mecLl3u1KLhah48lZSQLvcYNsHQCJKPpc5/mkj?=
 =?us-ascii?Q?OgfVonIaKl/feqOe5rpyDPNFDRg7N76sS1IHnDTVgQLsFnR0HbD0TlOVrrA4?=
 =?us-ascii?Q?AAqFVRRvU25xIz2mLWf+gZaA/j18G+42Kgxi3vRW6RSu2uaIdwzLplD5tAcp?=
 =?us-ascii?Q?+YxNsE1V5krNWFjwedJgXiZRI/EuZKwqxm4UiJEluL5DVg/krOjJulTpYiBs?=
 =?us-ascii?Q?83nsah4cXcq42RMr0rku94cEbjfzLIIXMCoaExUWdyRv+K4qJnkATUUicI2B?=
 =?us-ascii?Q?xyM+7v9CnKoxbUOwBO+Ci62fjBMokapSU+DMFoXTSXschw5F55h1JjxKe0RX?=
 =?us-ascii?Q?hQtgAohzgDZkMlh41LXHxW3hdL4t7YJRPOxl3sMTpu6MvjtJwnx/2hjj5rDl?=
 =?us-ascii?Q?yrrHpN+yZS7DBxxuVsglluU6+zVA171yxl+QtYcWj6cmPha/H8Bt0cEh66yO?=
 =?us-ascii?Q?sD0i/a9EkwUpmsshypetUSbRWEfURLReBp81wEW4bQZX+ITbcntxJbESyhr3?=
 =?us-ascii?Q?/zhqsomFC0WrQRVfGZcfa0W3lJHHMiaulSQAN5bTYQlLVHwfYeZ2gSIpFh9z?=
 =?us-ascii?Q?FhLlXFdeTviDsTT9DMqyABYMPsUM7fBPku+nX8tTdM8D4/s2OFrN1uHtg/ew?=
 =?us-ascii?Q?1nmczxQbWuDJDU0Ale4ZyYFuBdTko05b0LxBAR6kui9Cg8xyjyf4AyfoIQVO?=
 =?us-ascii?Q?cpJvsSvCye/4S+mXGrcBTGJbSeIgAb0/hv/C5norkNFXa5wT8/JdQKtB4K6N?=
 =?us-ascii?Q?NvxTfeZ1rQlLjWAzwSZz3v88a4KLWLf1+Sghn7iNyQAY2c+NGhnWrE4Rqmmp?=
 =?us-ascii?Q?JK+rcOVP1J/yjme+2UY4DKmOerbZ9r7jQmP2ZtKaDV98aSrP7Hy03C1cKa47?=
 =?us-ascii?Q?er8/hmnrUcHnkX0gsWKzupAKeggCMdCF7wTywpmO+QIy9oVxH/CXTMdyUfUD?=
 =?us-ascii?Q?wx4/Wv2aKhSVqL6QZqS1no1C+oPovpwKjvZdO31Gv7H1mim5egkonr0XwGS5?=
 =?us-ascii?Q?6kAice9BtVFEC1a3dy0HiWAyZY9WjJMw6U5YuOs6pMPcKbw6PII3Lk0wWVNT?=
 =?us-ascii?Q?grEYujjc5IoWO0bI4yLgdPVCtfy1WVH4+nfmmw4m9PBKJ8g8SNEgBJwc1B4k?=
 =?us-ascii?Q?4uESazm+QJxCC8xkSrKAOfs++2WNmq0/3LHyrp9TS/+5UMFKNtgQIIBJuVf5?=
 =?us-ascii?Q?nDFljcWT6e9jCZRT6PaDmwaYuUjiqB6OjsjYX41I2fDN8KwIA9AUmmjRsLkh?=
 =?us-ascii?Q?AIn5U23LLiegSBOU3C/ze9Np13a72ekh1TSocyQ75OYBXTU0kPA7VoHNTuCH?=
 =?us-ascii?Q?t7112Z2jT13T5sFL1r9l3VIHka6F1pHyBOrQqZ5wXdo6PA9qIsY/w23EfS1a?=
 =?us-ascii?Q?Ayw4jlzwBlsfVEeIH+1NuQ0x9LBXVwZdl0MhRNviNkuvWQ0ww9eUJRkKLybl?=
 =?us-ascii?Q?+BxkjynsxVk5k4+O0l3xip7eEK5/IrxOHkoS/r7M8OFyXmo/VD1kNwD7aDY9?=
 =?us-ascii?Q?a4NSzPguAwguzrq1ZpnRqg03aMFQzU/6HDVCNVIzlT+lOAVA1G4kOpbYWX8s?=
 =?us-ascii?Q?E7Km0BdQT/FaR2Qp5VDjl8UTKpbHFFglKXD0dGqZArXjppsP76VEtcYnrZKs?=
 =?us-ascii?Q?N8ton0Y48raMwALaqJO+MfvAQcOABA2TkPP0S0C4ZxTkUOcXJdE6fY/1NCa+?=
 =?us-ascii?Q?laM1KAl5NuvJMoS5MNq2MePySjyOH8Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae2dc1d-672e-4af3-4192-08da35db38be
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2022 18:54:49.4792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gz+Lt+jAMh4hwdgaBBBXbLc6pFKr6YXgYJx0+XfrMucRgw87cMAFq2nN0Oyw2L40NxoLjLfLA6VcAGuT51FJmBbVYrsSQXQFS3XUCN6dyXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1898
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-14_02:2022-05-13,2022-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=916 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205140097
X-Proofpoint-ORIG-GUID: 5DBRJfWNoc5N2t5HBl5uQLpv5une_yl_
X-Proofpoint-GUID: 5DBRJfWNoc5N2t5HBl5uQLpv5une_yl_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 07:51:12PM +0300, Pavel Skripkin wrote:
> And you can send new version as reply using --in-reply= option of git
> send-email. It helps a lot with finding previous version, since all version
> are linked in one thread

This is discouraged these days.  It makes for long confusing threads.
But more importantly, it apparently messes up patchwork.

regards,
dan carpenter

