Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C9040F980
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240961AbhIQNsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:48:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44952 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234565AbhIQNsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:48:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HBUOjL024345;
        Fri, 17 Sep 2021 13:46:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=vArAVfLXiENIO/evu1hwzHJAqUjFSd51B0qAhYFQpfE=;
 b=z6WqGizlMnhsfo9jYSi0/THjIHREsU3jLIwafWd5jXriiPb9EScjar1N3GU+ro+HDYg/
 Gd0oURwXEGLjqdx6lPjYxdveOUmsmnXgTcWzZyfL7R2STeAQFeMLvSK+mK0OfV3GmXMv
 e4hyeNTTlGo3efkPekDUwO9i5MldowhF/oJCtVFlril7MTAdol/mgG17amIooBcDO7q4
 LPOXfxbjo6VHzp0DzGfl1CawgvNyR+nfVVJs1getAT5HAl8PQwVslKnP0e4QD+7Xoi7U
 H2GYhuxfGq/ENmfVxi/6xYVjdmfkyGcQlgfUYJ8zk7O33NLE6Ua35ZaFtbF/catB3wKE Zg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=vArAVfLXiENIO/evu1hwzHJAqUjFSd51B0qAhYFQpfE=;
 b=hVE1lWmHBC9tlLpGE9vcy+uHbxx7mTNo4NOqUkCHYa82F0thIMQUf8NFI1pG59wUUoKz
 yBCjX1mCMtauVPzKno3i4qrTC/rcbxpTNRUy5K/zwAjrOA7NQqBJJ7ksYlfM4Cagx2hz
 wfxw3/HBcV4pgVOUHmu5ldA6MPKCbi/C7WBP3+RifPTkQR2BPXaFKqILmmWVIcIHmDxF
 dDNNozmH0Tqc7TGatN2/fO5cmpoDFSYMKWWv3Zhuj39/t1pstee7dPdzFPTQlORkex6U
 vjZtPgZ2LjWpCOck+EYEpU8oyQdl60tuaIjDkTdqvp1hAXTb9CbKcWQvfNWXm4N88tHB 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b4qv9gvqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 13:46:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18HDig7q069853;
        Fri, 17 Sep 2021 13:46:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by aserp3030.oracle.com with ESMTP id 3b0jghnsck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 13:46:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnYlcFicNhEJ6gWVHh3xmz0qlaU0oaiJ8pFh5iDpQDpxU0Ls1O/i+IiMcRqiA252l1fDZWbGRHEtEYU/jkpbyYaYJ9jJza1D2AsaW2k5xTxFrqUGgPQIrIM7/LmXObopfzpNgHUuvdm5IszCCviK+ZqWYucHhNmVEyPRSG3BnRN0hHitkPzl/kehXCXOqJL3ufrkiLIzHdrmBBbr7MoiiRXPGYw57YYEVUKtANqrnIW0G8sq33fn51NGBJsz6aUhhOcH8xlAluI2qiIFDgrOIwDd3uA7hhu5Z/ObHnGLE10zlnAz+JVhYHH+IuEEP6Lp3X5lFVNm0uWRaDG4Wd5QxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vArAVfLXiENIO/evu1hwzHJAqUjFSd51B0qAhYFQpfE=;
 b=mFGwAh1fnUJ3tNE1uNAvt+TMrc1dIWx5RWs8ayG5aAqeRG5gJH5dZCyMurbn8Sq6B+jFgUJtELtl3nXHNymXHxoxu2lBo+NlPUschyCuV29c1xVXpJQpEmv+nxgZtkQFzuW7fxi5uQSQQ2HGDGklaOaC0kPeRYRg/ZE8noK35cdUIDUOCkv6RcQYW9z28uvtt84abRuWc+xFkyC4goCfym8eGGi1DZqrCoX9eKnd4ECiItxND4k5NX9CIFfS3Qd4sSDeFqm6AlL8dAFCGXET7k8n6CnSL5+FkmpCH4d6ro0QhI7UYn8Qiq1OcjTtE77SXw/GggGUqhD1vc1z65GKDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vArAVfLXiENIO/evu1hwzHJAqUjFSd51B0qAhYFQpfE=;
 b=PqGnn87r4CQj5CQ+IyYlLIVSVTYNoTPRwEOzbua7d2fU07aiRhPMMFZLfGgeHyQcCCp3d26VqH76sBLCDaCFnEOLRHsI1mtfG8NctYDJPfdHx3z6CQCt+iX5FchCxS59+qs4eCQ23cHb39NS8bHBm07enjSEtEHrbddylhr+2vA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO6PR10MB5553.namprd10.prod.outlook.com
 (2603:10b6:303:140::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 13:46:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 13:46:45 +0000
Date:   Fri, 17 Sep 2021 16:46:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] qede: cleanup printing in qede_log_probe()
Message-ID: <20210917134628.GM2088@kadam>
References: <20210916135415.GH25094@kili>
 <20210916081815.25ec31ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916081815.25ec31ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0044.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::32)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0044.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Fri, 17 Sep 2021 13:46:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d4a317-8ab1-4c6c-9280-08d979e1967c
X-MS-TrafficTypeDiagnostic: CO6PR10MB5553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR10MB55536D4F57A8F3B15B77895C8EDD9@CO6PR10MB5553.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5n6ztVTIFU6GQZ6j7i08MR9lUcKZ8DxiVnlvjEvJn9gRulkJqbNhbcG61ode5ocYMLxhn9QVW+ldJ6wKfQ+dWCqiENrsJB1oBK5ltKm7kUgE7WI/s0/tA/XDWKr0sTULVAET5YYjxlE7pE/YPq990+nSaFpVnQsNrp/Z3IDOuSNjswr2/aKbRuM+TIHza/ZH2+IUvvXMy8J+c5bm2ZSLpyNBM8RfhUo/jLa9wFOQY73yekSqohRo5ntN6hbFkX+ChSwkza5dZRWgHk9UGll2vr/TxOFaaoDtesD/A7II0Owmgotbc/Lb+l4alf+VtRewqB03TRguRLpXROw1Vj7kiJkKgsR7+KUAr69SA2oA+TBY8OcDKkIX4PMVXwZcdk5JPAp5t52P3+gX+SFkwZhQ5HnlBPpP1pweVHdo3hTCNEGWbjDGRNiyBKUsPyyTC46p+Cs+eNR/OqTkvEUqzlZeThHhVzsmHz8ncD6C+OAqgnu8rP8GpEHa0YJRrcV21CiVmx0e22Xy+eM95+WEbfiyf+zbHBYFT038RKwwxelA/hZ1zgaptMtrVFshIDykdktnP0HrDCFZpBz/ZSwvIqUbEx4klA5j85+LVQ8EjfvDkpZ2wWAfPYH+tjo/2Hf7hk/IRUmu3rOOrvAeMTfJOvgLN/0CoZaPL3ChdkV/41i/XTiNqo2xC5Y15Pmo+ed5XobSnJwIU0EwQqE53JmSGmPOBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(6496006)(5660300002)(38100700002)(52116002)(26005)(38350700002)(956004)(186003)(2906002)(6916009)(55016002)(8936002)(9686003)(33716001)(66556008)(66476007)(66946007)(86362001)(8676002)(44832011)(33656002)(83380400001)(316002)(4326008)(6666004)(478600001)(9576002)(54906003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FhxcUQXErkfI3doGvDcq3QfRHwtICazZdWO/K/GKXN4IUz6vDaTblmYKsuR0?=
 =?us-ascii?Q?tdHZA4vJTKjxk6QRhiCub+UWSWDVapoRdmUfA0jlojnqJwWJWgjHdDeplK53?=
 =?us-ascii?Q?HbVvVWjBbKoScojkOzwuRErMxSDHesZt+dYt9XaOloOGJycB+7BG1o9l0HSi?=
 =?us-ascii?Q?hjmMCnvsHDeZowtoIr469Ln1WHQ5XU/nWTy6qmW+k0HAgkTwQXswivtzd9cV?=
 =?us-ascii?Q?uT77H+kSpREy3xMAG3d93DuJBjPBe9kMQd+LZA76Ew/vtxSmRepjShMmWPFj?=
 =?us-ascii?Q?4sdqrD5m0FAEKwSE1olhgpeBjdx1yk+aPh9mbuu6khRZ8vGRHoHLCqnWFbIM?=
 =?us-ascii?Q?5T4xT4/H1ht1buWMZMZ8wR5ljZMc15V9B2Vqukw6XBELTVYpBqoXN6PUVNyE?=
 =?us-ascii?Q?i7pZLuTniR7KxfRrep8mhnfWSL9c2Wjyghq5B97UnpUhRTRhLMO4fOJkPcIh?=
 =?us-ascii?Q?+Ncaq2CuFXBWfhmDSqHOOHknCyOx5C6jtvCIRlNE6yRd4S1lDcZ1RfE2HMHh?=
 =?us-ascii?Q?zaGxpTH6mwyVzWYx3Kl9f3NXz41S7N+AAuqy1ueZlbMfvOlcFmThxjgEyGkz?=
 =?us-ascii?Q?8TV4pnsphdtpCPa5748UW1cyzX1K/TB2Th+Pw2rh4vTSMoP76A+YUvcFV/VV?=
 =?us-ascii?Q?RVVSCkjRtvXtqgA5v6WGaBO/CeHn+CGMVVVdC2gymPc/s5uzUlGbFRdbJxJT?=
 =?us-ascii?Q?1hbo+mfWbmDCRli5kV0UesLR/+jNmtTuqTdjDujZzgt0lPEDKHyrDkQzakJc?=
 =?us-ascii?Q?ywu/FVNmsWbN77yD6jpx7WD4HLEXJTCt6QG3+I0Oi6paLIvif2AKBaaaD6/m?=
 =?us-ascii?Q?cyxuinysowhFZ2vdZLbejLh6Yy4TPcsw0h7ZoWF5e+lnNqrafxjmHbvggS6k?=
 =?us-ascii?Q?1x7dyGIQ03RhvV/+rgTji1kjFHUAHLzfAJM2LLYEnM8OCjM+FNJpqXHxumJB?=
 =?us-ascii?Q?QHsBQl+x/ghz9j16SbIZkuZqhLDkIGQina1wqcgawyOz2s2sBfERPt2t3/b5?=
 =?us-ascii?Q?BdFmoHPL2/6aKd1riqc+sMoie8zCuLSUlMQ1zV3+CT7nOISMdqMysQlP0LCQ?=
 =?us-ascii?Q?FnfjHdd1vQvaYw2TgYdfegoDQpxP+whXeA1c47xfY1jtT5hjDbx56D101/zX?=
 =?us-ascii?Q?4z2FZ7aJJ/97g80MZPArpZeurqeMin74ovCWJzDcCrfshhr/Fke9GVnFPCei?=
 =?us-ascii?Q?kk/jwf8Q4c7n3WOy7/bEaDYkaXdiOc6dvb+v/EqQfXxOuYvoKQanmqad9du4?=
 =?us-ascii?Q?wXyr7ivEbn5J7z2eFVgEthXj0+VGRvnCka+vpKi7xfZ4eSlNwwGXZvoD5fGz?=
 =?us-ascii?Q?b5fd80jHKVdptpnyZhn69FXx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d4a317-8ab1-4c6c-9280-08d979e1967c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 13:46:45.3222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qmE0FoVwdRrk6X4FsVBHcXxiUF6U2zW6BQXP6gwK9IuE4ONdQmZ8SO2RyzPucXnU070/N5HTCpPrWYerGauwCHfHrpQc90wB8jAqKazd7m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10109 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170088
X-Proofpoint-ORIG-GUID: dnAh03KalzqiTtDhI3TfTBrf9QXUz2Hh
X-Proofpoint-GUID: dnAh03KalzqiTtDhI3TfTBrf9QXUz2Hh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 08:18:15AM -0700, Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 16:54:15 +0300 Dan Carpenter wrote:
> > This code use strlen(buf) to find the number of characters printed.
> > That's sort of ugly and unnecessary because we can just use the
> > return from scnprintf() instead.
> > 
> > Also since strlen() does not count the NUL terminator, that means
> > "QEDE_FW_VER_STR_SIZE - strlen(buf)" is never going to be zero so
> > that condition can be removed.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/ethernet/qlogic/qede/qede_main.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > index 9837bdb89cd4..e188ff5277a5 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > @@ -1087,9 +1087,9 @@ static void qede_log_probe(struct qede_dev *edev)
> >  {
> >  	struct qed_dev_info *p_dev_info = &edev->dev_info.common;
> >  	u8 buf[QEDE_FW_VER_STR_SIZE];
> > -	size_t left_size;
> > +	int off;
> >  
> > -	snprintf(buf, QEDE_FW_VER_STR_SIZE,
> > +	off = scnprintf(buf, QEDE_FW_VER_STR_SIZE,
> >  		 "Storm FW %d.%d.%d.%d, Management FW %d.%d.%d.%d",
> >  		 p_dev_info->fw_major, p_dev_info->fw_minor, p_dev_info->fw_rev,
> >  		 p_dev_info->fw_eng,
> 
> Why not adjust the continuation lines? checkpatch is not happy.

Sorry about that.  I'll resend.

regards,
dan carpenter
