Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2293539D75
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 08:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347079AbiFAGwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 02:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244719AbiFAGwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 02:52:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B06488AF;
        Tue, 31 May 2022 23:52:40 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VNxH6U018522;
        Wed, 1 Jun 2022 06:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=bB0SnwIPoRDTgtMolyWxGaZzOSk+vi7xglvB/+pBeco=;
 b=bTG/qqV96chhzvX5H1sKqpL0qEK1Uh1Jn+sRDX8BuvXjWxkk4ZjR40o20qh2dx+L8J0O
 yEs6rbVySAgggQIj7/5qyVqlMz4VBGDwIwmurEC8/Lmhe7RiuS2lgg2X4W43kGAA3h4j
 wVAiOzdgNEPADVKkytv37CbWSz/hgx7jZLDLGfLckNqNJSWTzw494nHDTixKRGG81eAV
 q/OXYfu7R1wUaExJm2g76f8XWd+Hy+ylWZFrOJ90IDunZwJygN7um89KiOzoXZrc5PNm
 gbV45Bmki3hBX1P7WAQapXb4vjNAiC3OAk3CYuDtM50uchVdA4LQp2Ha1SIi6IV/vTpT FQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7kprqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 06:52:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2516aD3O034602;
        Wed, 1 Jun 2022 06:52:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hwuyrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 06:52:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNMlAedKIs5fix7tVLJGmGXGaiH5Rv8ju/PD6nuDYp4pBPUJk/4Xotwj3B5bp8TwgyYLYq4i9IdbJKic7PHzzDS/dphBW1n5DRHT5ivkPewX0IjrEqKnUKO2su+JFgsywOiQKGMjNwpg1dvaC/UkP0EheYXyly7RPLtP1V8K3H5dO8ukm6mXgCdbYCNtyjifTitKDMgn3keWMn5DhevkMxcHymmcSqZWBMLtryALAjtmXHZm+m5CZdRM4Nm7+EIy4Ad7G/hN6dJGudQZZjKcIRGjYnR+/6mTwpvIXuEz74zleG2+uBq8TR1BJLHe5KlI00faWiARFtITMrQUkQ5+GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bB0SnwIPoRDTgtMolyWxGaZzOSk+vi7xglvB/+pBeco=;
 b=gw81elV7ZsapXDrv1+fDfcafCU9i8h477G6FyBMS4VOrB13FzsWFq84uJzIhw6abtBy3K4n29mS6BF9yBaCYLn9l0zY0QxKlh6Z3xVsAPdFgBppOOD1WHN/zKpVeasACuZvL0FZGRfdsZVSeYIM+zdTMOSd6X0iP1cPIusddVyeD+I/N4+ozuvt/q2Ix7CxZ9+A5dMGtlW8TBmA0B70CG2dtr5Ukcb5ZDIQoHiyYQj+u/QNB9k1WzHWBj15yew2pTEcm9Bh8azcreHg5R1sulz9P3SoOwACy2AEzpdmKD2e1uB1JX8DgwrgPIyAt8Hm0mjiBd590TRifXelG0sFciQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bB0SnwIPoRDTgtMolyWxGaZzOSk+vi7xglvB/+pBeco=;
 b=urYoVvcMJLw4/6Akem7o9QI7A8VOBySeraLB9IaBdkmVEz/yNJHKR8crl1qBmCMoXC9tA/Gq5YHXP1MVo/JalLMhpRLwOOIoVlPKwlHVto4Z/TrmbDmYUQHOZAsaGOI+u7l2jFnmYr6BNMmbj2RB0o5jMDoblfZSE1bVpSe3nt4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN4PR10MB5557.namprd10.prod.outlook.com
 (2603:10b6:806:200::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 1 Jun
 2022 06:52:28 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Wed, 1 Jun 2022
 06:52:28 +0000
Date:   Wed, 1 Jun 2022 09:52:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH (mellanox tree)] net/mlx5: delete dead code in
 mlx5_esw_unlock()
Message-ID: <20220601065209.GY2168@kadam>
References: <YpStOhUL4j7KBSqt@kili>
 <20220531201125.46ecnnnzrqsqtejr@sx1>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531201125.46ecnnnzrqsqtejr@sx1>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0023.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::35)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff3289ec-a7df-4a09-ebb2-08da439b4ae1
X-MS-TrafficTypeDiagnostic: SN4PR10MB5557:EE_
X-Microsoft-Antispam-PRVS: <SN4PR10MB55576E22EADAB1CADC7B596C8EDF9@SN4PR10MB5557.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BFqq5UsmW6aVns/be4aKnBnzdLj7qHKqOFSKx9yqD9nZZ1Po3bH6hiJTU/HoCczCMmIuMny+2uSE5N2wm3UBeEff+EI3pgNoKUNG+aNWLDFAb/Z9zfDquXPMOmNS2ED/toiPVjZ16Ro1EAD8gS422Rx9h0M0rf84eDj4eflEkhfHG4v1qwLFC3juspl3lHTqmUX4cNRhwqPBmojGGtM6t2nmjiCd3qdjNm8ZMBugiFOdxzwA3hCxbInT9/mEAr2zl029Tr/UH+b7VkPHuVBkRD/fsCiUAw5QpBClwZCfI1k/SkB3jKzVyOP1l1jHMROzQx7H84euzsBAXytRzeWqUXUG/gyGxtZ+cbp2KoZrOJcSd19F7ghwVYModuYfYwh9uuHiAuaqkx0fzyIwSlxjRKze53jjg2LndNhirxJp22Alarj51nH7D466/9QbpNLxMZdzK9t76w4ph3Xjp3X0NJB8/gjwtSERGhctKIrpMBcDMhnfspEomLASoLTTeBgTyrmv0/b2KRWlhf8ETwefFxPa3aH1ZPsSAHTWNb41ahUY1B3HwBW2OHOImZe+sWtZLsc4OvMS25HKedlxo55SDkLoIvUyHwJgfD/TvJa2pOakopt8lhlySATxFgCGn7kO3mUb23/RZNUK1omqeco32MiaoNGmkAgbm+w8/AG06HpHBRzXnM0vJ5C8Wchn0NlJrpueXxqqD5OYF5InRPBxFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(66476007)(4326008)(8676002)(66946007)(316002)(26005)(6512007)(54906003)(33716001)(83380400001)(6916009)(38100700002)(186003)(38350700002)(2906002)(33656002)(1076003)(6666004)(8936002)(86362001)(6486002)(52116002)(6506007)(9686003)(508600001)(5660300002)(44832011)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eYLk8RUMc4SPMVBpatRWTyTXmO1nDdg0Pdn9qlhYrafs9ZDllN+MrNK5TUmf?=
 =?us-ascii?Q?vjk4MC3WuvItg8fCxdOwtX4h3+rHnMo3xIh35yO3KyvkRxFxhzyFQc0DGe9+?=
 =?us-ascii?Q?eOeDxI6XVpToOZ/ClfbFWIMlJ0nSiYJmbxH65xxFlxvFsfYuUWLG1g1RANbR?=
 =?us-ascii?Q?yFLgvYzhl14tkeStGRfa6p++p5Susiv03+kz+en+LkrhpOt0fbjYovOa+kjR?=
 =?us-ascii?Q?sovP1wsYfJQnk30fwsbpgTrhXltfrr4b90OvzZOYNd25jcwfj7r70l9l2qEv?=
 =?us-ascii?Q?S/Ad26rL1g8i4XJO0E9ynE0WUPsWt7hZ+qvpy2CCr0XbKGkaZ9roRbPWpSEG?=
 =?us-ascii?Q?IrXvhf+oP7pN0fMjvm5Ea/KFBPuuwE6DfpqWCIqUnNO61ZrqXyqCVGYQbIPA?=
 =?us-ascii?Q?ZfO1IC3oKKZUBMtniuy6uSDyARdzHVui8fGyiKs8ubv56AYVQkNtpyvVF75F?=
 =?us-ascii?Q?08CLP3Y2KgS2WUJ+KiQMMbmQ66nXrr6F6O5NebsE8vUiG7xXSQYJZoppKu/i?=
 =?us-ascii?Q?96OiLbxGzeA7sQBRCo9P7twHI40NdZS/7ifB/uIahZXHn+9H2KVt9tvtCZVD?=
 =?us-ascii?Q?Csyjlq6+dDOFFje70sN6DfXokcbJquclaVz6OrmLlQKItnN5JHGY9wNj0wBf?=
 =?us-ascii?Q?XD3s3/VxaJoJ/OfbgIMiv4HzMryb6/GTJf4DTcJNalQB+d11B54Ner8wBGmx?=
 =?us-ascii?Q?EJ1/LEBw63vQPfb2l1pailytoDcdkZLT8q+8xsQvs10FNZsNWEoSebedxJL1?=
 =?us-ascii?Q?WTRTHMdxa03PrtDvANVHHqxvAgbVupUUkxiZZ12q+9MsKuVrCW2xDbnhsLRf?=
 =?us-ascii?Q?hufGHBUafmNjUNXblVnhC12YDOlHb2iPpw6p0ciyKb3uNKPNQp36b28ECAAs?=
 =?us-ascii?Q?1voxh7J5HoeoHNHzBb7Xr4jazLzi4VeUpEUIc+8VSXvaYPHfuAf1amf8PJTm?=
 =?us-ascii?Q?4q0n2fXNPtseV+hCzRjecuNDTbkE4b0HJ2Ut4Q9MvKmf6OT4jabM4BnGyvFu?=
 =?us-ascii?Q?js+Vgaxnpj6KTYg7A3lfWHe8B97+NjcTAkNDzeObf04E4FGbGKvHdk7pvymr?=
 =?us-ascii?Q?IiWfgLAoMcD3XgGBenCx+VpC3swRB784R94YgvV+2cG4TO7JYpevRDQ/DuNm?=
 =?us-ascii?Q?03Nw17e6jPx8xbdzewyWX080AlnyiG6XrWw/a7guY3h+YNlOwx9uErj79UTj?=
 =?us-ascii?Q?T+V8i3rxk/UJKrYLonCX0qu8F+t4LLr5lRYQUJqrZyhyF5rX9/aeuIpFsG5k?=
 =?us-ascii?Q?ph0m8UtnPbyRTBJvvu+58aaI9zN3luGw+PlfGarYRMUSpSxE3hBwppXEx5TJ?=
 =?us-ascii?Q?Jbky+UTeR4Ocm30STZE/1Xx9UOUSKDJYbbPrWFMMuQWLgcG9eGqFXCHnStvs?=
 =?us-ascii?Q?AJgHFmYipBAfo8VeouyBnbxE0IJtQmMNDYA90hKT4Umx6mrAJ4qnnonpv/MF?=
 =?us-ascii?Q?EBzCyDzONlk4HYkJl98nwq5VNtS2emhZ7hSwiMltY/qqCgbEwq4QQ0N7/z/0?=
 =?us-ascii?Q?mdLBAgzNueeZmAp83EqmRGHRUSDAaIpCXgpCgvbSOy13sF7dloQGgQtadJoK?=
 =?us-ascii?Q?wSrhMoKDU/w70zqcAed5foUWfBw57S0jJ+DYCXgHGrA48BEt64yOgvJUUNtb?=
 =?us-ascii?Q?IToS62ml2Kk8fYnalh6yzylUbRuvj+O+dFkLVUo2JpMabMbU2HEVYWT3b1v7?=
 =?us-ascii?Q?q7k3YVrOuu1YDAOxKp+XRs/ev80ecVp0jkuspaZH3+JNY71aQ+d4sBNgf6/e?=
 =?us-ascii?Q?6lG40A6KEmypj5wOZurVhHN28E8r0Xk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3289ec-a7df-4a09-ebb2-08da439b4ae1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 06:52:28.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFUl2gJktL4AhOQoKFBOtzyUm4LUDX3EXEOAp5Gq8ou46I7Isa7JHAy8SzGOjQ0AvSTJR9HLn6/XP3fYYQVZZfxzfSzBmXkaoXMww2Mleko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5557
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_02:2022-05-30,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=758 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010030
X-Proofpoint-GUID: mGjLqC8x92abqn54gV_Z22ppfnviCo3w
X-Proofpoint-ORIG-GUID: mGjLqC8x92abqn54gV_Z22ppfnviCo3w
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 01:11:25PM -0700, Saeed Mahameed wrote:
> On 30 May 14:40, Dan Carpenter wrote:
> 
> You can use [PATCH net-mlx5] for fixes and [PATCH net-next-mlx5] for
> none-critical commits.
> 

Realistically, there is no way I'm going to remember that and there
isn't an automated way to look it up.

I try really hard to get the net tree stuff correct so when netdev is
on the CC list.  But putting the correct net tree in the subject line
is quite a huge headache and I quite often get it wrong.

> > Smatch complains about this function:
> > 
> >    drivers/net/ethernet/mellanox/mlx5/core/eswitch.c:2000 mlx5_esw_unlock()
> >    warn: inconsistent returns '&esw->mode_lock'.
> > 
> > Before commit ec2fa47d7b98 ("net/mlx5: Lag, use lag lock") there
> > used to be a matching mlx5_esw_lock() function and the lock and
> > unlock functions were symmetric.  But now we take the long
>                                                        ^ lock ?

Heh.  Thanks.

regards,
dan carpenter

