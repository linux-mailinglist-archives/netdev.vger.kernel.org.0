Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEB459C15A
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiHVOHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiHVOHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7299726AD6;
        Mon, 22 Aug 2022 07:07:06 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MDxesm005131;
        Mon, 22 Aug 2022 14:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=7mMh2wmAwFDISx/lo2+0IvdS3dnBmWNLnDQe1qU2eHo=;
 b=X0I5WwolzeSfR6DThO4bTbIEpRuxarxwxmr+nMKT2q9q9eFbgXANewdzP6VL++d+uRtK
 gtOQQtJb4OXdO8grf66CfK53VpoqVlxTIHcD83f0zef3lXC180Qg1FIez/BE1HVjV3l/
 1rvGs3swqINLGjURkmgSZfxJbr3nrYCHixbPmGRzQxBqkxiD17UchJCaqCWYiPZ43mse
 DfhUYijX4SgiM7XMIebIxZ8Q8j89Y1vmeXmvypXYGbPNv7X3wTguWEYYPcezhKVjOq+H
 ndJHaVhYJNFAmA0Da8MPS7YxEPzbALmLvKRXSxupfIN4Y5qskWek62ZH/QzQkb+vrMvg 6A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4axv82h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 14:06:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27ME4OOf005074;
        Mon, 22 Aug 2022 14:05:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mn3s3jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 14:05:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuPQoE09/lHdoMQtJGJQE9Ymf4zGTEpxXm8LyRTvCo2x0OGai5Gus5daBYxLKgOc1TPZqek9A9I9yw7QKjmynpUdAa08MMRymUoMJll7yQ3p1a7r2//LHZHK7iOtmL1I0jlfy2dnC2Fn4kWC1W91IjT9hoaQ6HO30/EIC1wjfzbRBiXhP7Ev5DBpttfQt5o/CrqWGqp9i8jmSPS9OawjJIa8Cz22Lb0NDfnQI3ahqQXQ6R16wub7gVYPRxUo+rlFyB2en0TVCD8USSEIahRIx33JnYoYk95rzSQoxh48CTAlgDghVjYke4+AjBjpmbRhNlFHZaG6dWrKS5ghV+opGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7mMh2wmAwFDISx/lo2+0IvdS3dnBmWNLnDQe1qU2eHo=;
 b=dxaJrQqSNjBGwmzP6et8Hn3JKr2IIehyq1SejTyFKB7gHN8AcUaS9nmATeI4ZFE2Swx/ifoJkJJwZ1A024ttykJWki5vW7iyzMDzn4JIdTB9c+7AopmYz1WKOcrqqAMdMWxCQhBgGyTUvq+YmkUAe/CkCy3ABgORo2YT1QlGo8GP9as7ystKeCPF8Vn2FJ9jB49IJP8LGU/hIzHVkjN8IK6ZXL1XJA+VFe2A/o3AgtdEa8UT5wkbKc78ZMi7jo12FhvIPa2OyPNpQi5hcAf0dHLQtRGYj41R5xrf7WnlDBI6yAjeKm11cYUiow2ivtlt6uHKbYlWIxa/Sa1ZLsfyMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7mMh2wmAwFDISx/lo2+0IvdS3dnBmWNLnDQe1qU2eHo=;
 b=v/npvwqlyYMHjM18pc5fUAlpISsMU15y7ZwnvouoLBUI/vPlOsXhRqkDkam0idlDaOkXkoy9WwevabGUEYG5yGgzrvoMfiELnKKlvjjkrBrpzr1DJGcGasG2AkyT56uayEPS4vuhtydgN6ytqVLyWekdPorCghdZ5lCpFmE6w/E=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2317.namprd10.prod.outlook.com
 (2603:10b6:301:35::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Mon, 22 Aug
 2022 14:05:57 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 14:05:57 +0000
Date:   Mon, 22 Aug 2022 17:05:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
Message-ID: <20220822140532.GF2695@kadam>
References: <20220822112952.2961-1-yin31149@gmail.com>
 <20220822130414.28489-1-yin31149@gmail.com>
 <CAABMjtE-XKa-_kW-aREvHDiyGwcs-GZWjtSjZEeF577FKcUTAA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABMjtE-XKa-_kW-aREvHDiyGwcs-GZWjtSjZEeF577FKcUTAA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::15)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 157238b0-4e83-47a5-d64f-08da84476f2c
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2317:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Cass+fMd6e/0WjZD9DpJuum2wuusxsr164l7b867pypkImE819+BBBysULQQFNpIWzalk6OZ3UTBou0Wipc/myLVIO/nJqbss7q61xuOe6Hjx8HPJQnvpt5P8Jbj91asxC9U2JflswBPip5B64RN251kSlVtiwF0hhom7D7Wq74BeQzcYt6tK66cq+bkcKd2X/qliglNpsnNyGRTmFouj7RKl2MLCMVsu+Hod3PTGUzyAib0/yfnXlH7bPhkzLtI6OfO6JEkxn+FGQmYrwuB/mU69ZP4Uyok2DI+CF2pCginguqllTB2et9bHgi9JFX34vfA4KjNBJNJeisqBxcqcgtHyfVNRPqKEK8VzuuZuAi0A8q+QL+lqJv0lhLEdRuHhiTAfDzZBIb8ptduR9dRC+imQpmA+nHOySrXz+HYpY2mO0uixZtPuXW5XVBn+ntiveOgUwdtlrEmMy0FLQmI5tGyGmgTGgcfnyVMc7RAGEgFwiwP4f1uz2yUdIgynrQ6Ivh04zQNa/ARrmFSBtXyFSkogkehDnZzut7Qm9bZLR60KlzO/YxoC5bQwE0LZfY6GYz6u1ff/p8PXC3SB7RPU0g1MhqA7iabfVSPGJPR1XexzGPDsPymGO4oQSRdqFkAkZetShX0e+3e7P/TJ2gO3qNzzPvLDEhBHjWgXrPlKf23yyTo3Yvbo2nqiIpWBilUE/BCSn5L6mtJBZHmeCyTLJJieGiIrj2BQwmULrqhQe5+Xg8sSIQZb3uDM9N81RUn3Bj+s0vAKAf8hUczfeAKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(396003)(346002)(136003)(376002)(366004)(6486002)(6666004)(478600001)(6506007)(41300700001)(83380400001)(186003)(1076003)(9686003)(52116002)(6512007)(26005)(2906002)(5660300002)(8936002)(44832011)(4744005)(7416002)(33716001)(316002)(6916009)(54906003)(66946007)(66556008)(4326008)(8676002)(66476007)(38350700002)(38100700002)(86362001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/fDPlDPm+CdS0WXgGNQI9og7HO8M494aLTuZTKB4RNVsMTQko4utVD5v7v5t?=
 =?us-ascii?Q?3FcUX+eVPYsvmHp08PPk3UZZ8kTOX9x3/mD4M/bKgGFls+Vztp/TmFAieyJr?=
 =?us-ascii?Q?mQOKQA/+jPFbYWEU24KXU+PcLSgutXhKUBcLL9SUw5ZdRz8E+H2AXISeiToZ?=
 =?us-ascii?Q?MrMQHgFyXN4n1lmNL5Di5HitmzzTw6zQ0x8PRcg4C36gwWf0lTHNu87cj/YP?=
 =?us-ascii?Q?/DXLz/EcjJplF9x2Gtz1sTmNj/mwrzfRkepREbw9CL1DBvQJgAigGHvGcpDx?=
 =?us-ascii?Q?95T+OkBq/x2VdwD/fe8HkGLfW5AfU22hV7oF/JPwiqdZDZJG33F/T2pKgk9+?=
 =?us-ascii?Q?luzaDaXFVQDDtINdVKmJOlfAlsQrHMtqYHCdYRtq6ZcOf4NvYSWmw8+21xYX?=
 =?us-ascii?Q?t0AK0drmCndPsbANlCnRoXH1txryM1j480xTuK0ohJzZAKU+QBxO7uT//62I?=
 =?us-ascii?Q?DJ6M9vXCQaxSqXI3CLLdmT/1j/JhTczWwumVb3Jdnvf2M1LDf1Ec3Rz1+qZp?=
 =?us-ascii?Q?fBRjyMD6/tzXTNGgcmQ2VQeteKUYpyBz1a/8APmoMIXbTAf1g7+8n8ezpAmo?=
 =?us-ascii?Q?zMy9wCrXDrxAUUJ1H9mPevL6qszQlqzXJ8dgb0vKKg2EyHG42cdFBy6QvvOf?=
 =?us-ascii?Q?eIM4LYizEIvkJ1jCWSZPJyqlZQ00gW9Ad2Z4efMi+JDcVMcOnDBDcqWhsWud?=
 =?us-ascii?Q?nEDQSNzRsoRRy1BJCqDhG5GUJyyrriyE496ttm98+3naiFeNjhISvXu4EL8L?=
 =?us-ascii?Q?+BrnG2yGzgn5tV4fIRUzQrA4LScuMSYVUIQg++Yo8zpB5Dqmv7LleQM0zaJn?=
 =?us-ascii?Q?EMTnDFfMB67d8x58Ndp+q7ZcEInqdV50w9R9uyC0f96AOEfmc/vPOFKd1zs2?=
 =?us-ascii?Q?NRPrsX+C7PNchsBvTby/J6+f1nJa7NsZyjpgeLPSMJs1gzW7bAKTOoPLoiK5?=
 =?us-ascii?Q?ECMoPLXzxgr0wQADpxbaKbwzJG/uDwPaZUtPBSWeqtgxJyoSmNczJuoq9eco?=
 =?us-ascii?Q?CuBLJUR2AOQCDvkpt14rQotBDysQIo2U0sBygnlH/wr/bQQjKyaYHZ0CChW1?=
 =?us-ascii?Q?ImBEE+8hfApYHZ8wZxsoCgGVk0FuUptg71Q8YpuRcAoxOorqVPnHfmrDREWn?=
 =?us-ascii?Q?IwKWQyfIH07cmTX5l4Jpv+FwC7DGLVqZ3tDyYhPOQzjf/Y4MzBFq3jG4IhJV?=
 =?us-ascii?Q?4+5Rz2MzSIHFlZNaCtdjyDsipJeM/0hge27F1tPSKqr7PR+xlUsQhstMx6zi?=
 =?us-ascii?Q?Tdokk8ijMg9mEa184C8BoyIdNoxvdb5MMoIsxmStlvHskHaPTWEH/KJT3NBd?=
 =?us-ascii?Q?KBgV/PkgiY5Irdg/pGzHSm45hGQkR0CLOrh1pAxS26WN1qxURMQY8JfR9nGv?=
 =?us-ascii?Q?0LWd6xTgwDcEbSsJQYhiCBmuFYU0zmllqoS4JCtbuzNeiIIzgWCrh0TyO7/8?=
 =?us-ascii?Q?jpbJCFXM8hgFtB6ZHvH3iXQl4cUZ2HsVupTG9oUwdHmXNHPhnj7R5a75h5OL?=
 =?us-ascii?Q?VKy+KrbON9iRfNXa6OXJH5t7eXnrSbKp1gqfwQsjdKF+LzNzm2iwGcmTJsDK?=
 =?us-ascii?Q?uJ0AVyVuvqZHNEKi46Fluz0O+fbz5Zzo52+Qn+xtaxmkfXF3ndnBIOKgadAy?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157238b0-4e83-47a5-d64f-08da84476f2c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 14:05:57.0662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/ixHirNYlNaXnmmcn6jhgHWW5Ry8/3ANZrGrnAYZVPjcx5E8jLSzx0QO6tWLovS77m9yYZUjLFr3IdfQeedebY5kfz/sa1cbZuRx8B5doE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_08,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220059
X-Proofpoint-ORIG-GUID: JrvNn4A7g9dYcCSJL0b2qG4DWvR3EKOu
X-Proofpoint-GUID: JrvNn4A7g9dYcCSJL0b2qG4DWvR3EKOu
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 07:55:27PM +0600, Khalid Masum wrote:
> >
> > /*
> > + * @holding_mutex: An indication whether caller can still holds
> > + * the call->user_mutex when returned to caller.
> 
> Maybe we can use mutex_is_locked instead of using the holding_mutex
> parameter to get whether call->user_mutex is still held.

That doesn't work.  What if there is contention for the lock and someone
else took it.  Locks under contention are sort of the whole point of
locking so it's highly likely.

I do kind of feel the code has a layering violation.  I'd prefer instead
of "I am setting this variable to true to reflect the caller blah blah",
the variable could just be set in the caller.  I'd probably flip it
around and call it "dropped_lock" instead of "holding_lock".

	bool dropped_lock = false;

	...

	if (!dropped_lock)
		mutex_unlock();

That way only the callers and the function which drops the lock need to
be involved with setting the variable.

regards,
dan carpenter

