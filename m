Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8FA5B5951
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiILL37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiILL36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:29:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE60C6F;
        Mon, 12 Sep 2022 04:29:57 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CBTXmS029246;
        Mon, 12 Sep 2022 11:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=eJGOHSNdQBYs36AR60TIw8DDdyia9tCvZJzmxpQgVGc=;
 b=wArBUPWg4yZwEAN5yewngGLsOmEmOIqkP1X+FxbXBLdAwjjjkcF4rO4QaA3IvdGH5xnq
 xmuYsH1sY6v8/tJ78HVbXMesSsFzm7ZGMcXfZZDxnnSSst26PbPkkGGo4u78RO75txI/
 EeulUZRr1a/F01B2edDJoGdMQw0DTMdY+yLVAfiQmnaKNqLfEXtmV1MPHeKB+4sjA6R7
 qRNlqbSKYF783zxnVqrT2napO+9VoTB06eGDSUvUTNUWluks/9nR4QONXqNq8xpkofzp
 HeTMJPn4OVgRGQNPVm9E/Ru60l/LL+leGtWXpgb8lnawTaKvmjwz3GVfEl/kDL2SYPGX Vw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jghc2k7y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 11:29:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28C9rM69021492;
        Mon, 12 Sep 2022 11:29:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh12ebmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 11:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lG6Qo7SVhHkz0H7eoxjwsJq/s3fsVsEN8e+x7DmeCLMWszkKkKG/TcdB3KxTXRsOLrdXV64gRAvlqfIFmqi4l5YfAHABfIKximtHuA/pP3ym46eAGVNZtDri9QTaH+u7jx+G8qs3knpv8ib5VzT/mC5Dp02gS/pBuIkw+DnjVC3HLZVvbluwanXiCl0Hh10D5pron3j4oSqBTnUg7fEaPupRie+AwTTs2WJil2x1f3teMLjsQtZyumhtuAHidVO7zTGgwCyQpk+hC8dZO1LOcema4Cpvh7BEMS68Hlm8fvZwAGqhHLaHxlaZycokLallu02fLNcAgOq6XSzfBgWypg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJGOHSNdQBYs36AR60TIw8DDdyia9tCvZJzmxpQgVGc=;
 b=f7yqoLiC0J4/eZSekZXHZakZ+S+eEoKf+9UzizxaOfSgGJN5jsq7NdQe/em8Txk+RhLl9Z7el/Ks62qdAVjlzqVo5+QxwN5EryYkTfDdpyivSP9ZzBaXgVX732qidoGwr5fUZ+pRxjOpx2IuL/dt+/9uEkjOeCZDcRB2fq3SijvmdMwFAUa9p1TrDGAR+icIDgJDgTE/d0XHXYLzdG/KmSzASqYoFLUFUle3nXPRBiSz9pG4Ki59VxARztyzacABV7XXZlbO6rHhb5s8+djw6lbW9IFYwHlNZ9hBXhQcwj23twHyDOEAXCiw4mcUDTusUr94DEAjhZelSO2ykJ5Hcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJGOHSNdQBYs36AR60TIw8DDdyia9tCvZJzmxpQgVGc=;
 b=Hu2/OrCVeJM/Vy5xqxcNZJdHHERwuBl9WCWdX7LETvZ6hnHgFaE/CGSRnUA6lDhGsksvTP3NYwIcTX9pGEkhGwM1EimIZZvGH9BOVaw2zhNF/tXGJsepQuroiT4sDAUqTt5xE3TaEwKlCqAIJSMIX4SY2n4JEXOMjru3f/Nf1Xs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB5227.namprd10.prod.outlook.com
 (2603:10b6:610:c6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Mon, 12 Sep
 2022 11:29:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 11:29:27 +0000
Date:   Mon, 12 Sep 2022 14:29:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yu Zhe <yuzhe@nfschina.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        liqiong@nfschina.com
Subject: Re: [PATCH] net: broadcom: bcm4908enet: add platform_get_irq_byname
 error checking
Message-ID: <Yx8YDUaxXBEFYyON@kadam>
References: <20220909062545.16696-1-yuzhe@nfschina.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909062545.16696-1-yuzhe@nfschina.com>
X-ClientProxiedBy: MR2P264CA0023.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::35) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|CH0PR10MB5227:EE_
X-MS-Office365-Filtering-Correlation-Id: e341feab-bc50-41d8-4a28-08da94b20cce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FoJbfwit7X2sEA4gpOJ+wPaaFIYNCLF55y92v8uHKhc5Ukfsqyx1SrW0uuv4FviZlXWsda9p0EBlBqP8hSJRgIZHx8uHZNtAnTQpuMlzMm+qjWUmv5Pt70nWUBdGnN54+aUcP6MWKoYvcNEpuMIDKXoHleO67LcE8KZ5kguPX2EBOucAG52rVKiHtBinNEil916SC2dqcc5V6BP6Yku+2kTRNbnUK2wKA6XlXWoGpzy37uY1x2PUXXvF969nV6QQZV/PzpgXzaCthYwcKTKh5gWDir5XM53a7UraPVaT3zqZ+/Znq+13zLc1I+9Qvg99Fkf8WRR6Wo339UzxEPBNaf/pTTkgJ2WcBd2l/OLuQ7rXz4OK6kOpTR8OqLJPbfbPpgD4eYo3MeWnPjypNXODxZuqfKT8u/hmGI9OSHbIqvrGsuc6e7xbBakfv3aHPiZzHmsd4be6avh6Y2a0tPe+DDOHJxx8kj7Vla75DvQhpVSqYtbOVJashXKIBlIw4w5X+P8cC0uDcRycH8UIx985gK9taxyCpC6EZwT2mR98s1hyCCWH0T6Kbo6ViC6RXkRlzgPzuVEezP9CZUF6DYtFoTykX3lcnqQqWY6nJqq2rhn2fDvoSCvr14d1Qg0OVYe34KzNtm+/hE1mQgiBrAh7QsPFll69RxCSaQsuF821if/Qvra41cB3lRYE7qnMBl2PLXCS9VtiMkZcj9blaVTzwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39860400002)(346002)(136003)(366004)(396003)(6512007)(9686003)(6506007)(478600001)(6486002)(6666004)(26005)(186003)(2906002)(44832011)(5660300002)(8936002)(7416002)(33716001)(6916009)(316002)(41300700001)(66556008)(66946007)(66476007)(8676002)(38100700002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FNe31lG6pVYZc6ZKQt8DnVp7PulC12pntGsWDN+LbydpQ3tlWDJYb7OiruaE?=
 =?us-ascii?Q?WWEY5yI7JMwiL6Y+NZd7CnVtBTA6Bp39ZROq26UgooU7mBi1ALwSwXZuqRcc?=
 =?us-ascii?Q?zgJNnnxHK4kkWFPpjHF7nEjUjZgpgx1aswaxdoTxf2lnoAbUw6BCa74nLpsp?=
 =?us-ascii?Q?BxOX0cP75NKQYFdPKwj0ShPymH8AOcLQ/j+ts75iFXg5SpXreUykEGR1dVGE?=
 =?us-ascii?Q?0i17mw+Gwsoi/JgE+fL+9O6JMFNfEW02b2TKUiYIH62VZtvmkp7Ffs8Br+25?=
 =?us-ascii?Q?QlTFCfGjCWaHwmR7kbdxUgC7w3kT8LxPclRm8hUqXF9ava8zIAjnYwTHp8fF?=
 =?us-ascii?Q?m07cIUX0jQBQFby01ETfEW4/EFOkZFbs25PvSvwvaEW5Nrf+cj4z3bpOOT8N?=
 =?us-ascii?Q?n7w37UGrmh6dVK7h9kG+7CW/mlc9ZbjBC++Ox1ouI1C5TifCapvhDRLlIVl+?=
 =?us-ascii?Q?S6fepL0mTHHqplqW8jt705xlp3/jEsrC/mvd8xH0Yb/l5A/97WuAHOF+N45a?=
 =?us-ascii?Q?rLN9/1iuvCVlTqbsNeyBeoBFgBouCKxXsT3wuhy04f0x/HsTfnUbUhPQyR/T?=
 =?us-ascii?Q?rbvwii/J/O1DFn6bCrMvgKEwT+bEu/Av+Y/yw61x36OOCSn61ddn0N6UfSfy?=
 =?us-ascii?Q?JrfsjlcxiuhxhmgkysOaKGqeAc0ydbe8zG0rH7G8/CoXLcy3g0uOMUdEljuD?=
 =?us-ascii?Q?Aanj85tyBAse/cvMVwWvkPNJfB1orJJ2leCfllylJqeKHGYVn/jK6PywuWHo?=
 =?us-ascii?Q?yt8QMQ4Yk+4Msje5PBqSC7XYCF0GqbEvLv94n21JKM/NBnJvjceC36BGXNN6?=
 =?us-ascii?Q?5y3DLIElIA8VZVo6eedGjATx+ebzHbOTLhEP6OTe9vNYIzzW8+rMpvgTd/cn?=
 =?us-ascii?Q?rLSz1949D2LkQ0UsCrpqo5DYu6L6tx4DOLZoJJTVu/QFaMNdz4XTaDoNaLre?=
 =?us-ascii?Q?VPS1tAqBeIJQFDMCG9H1n2FjT994w7Z6Bkm1Y+K4/s7rUoRYIp7VM1soZH2k?=
 =?us-ascii?Q?xzw9LpVYPeywXhgV6jzbqElMv3Dm345p/3vqJPkgvbntL3VXFrhpzdTV1lve?=
 =?us-ascii?Q?uAMWEIr7IFcYKPPXVWu1RjaBIW7QZflvXafDg5ExB11ETALNn/A6oGtwS0Xy?=
 =?us-ascii?Q?B6+vdQlQibs+eyOdlIt+HpRViLWOPr6dflhhOsx5HzkKIk1OWdxhB5gdl9we?=
 =?us-ascii?Q?DYKb66/ihXNEgcb5HMo1YlP49d8C3p6orYYFP+earCr6vkgbn1XfkaUhf0vd?=
 =?us-ascii?Q?McjEroCL0/ysO02wd+FIAc9pXmN/PvuPQu4UsOiYm4oIoZjAXkPj8rOBZYBJ?=
 =?us-ascii?Q?nqT34EbTVdUIZlvVWpS6Zu9RKPNa9/RnXcpEz3eaFQhS5Uxm5ZN9LwFd8gpy?=
 =?us-ascii?Q?MaHzE31QBjrm3TtaC+xopr8HfRh0JtKJUf1JEWlS1FSE28zz3k2hBFHjeHnq?=
 =?us-ascii?Q?h+iG/3wvSJBf32osi1DMITe+whU5o51YVAwNPm5m0Y325XL0tzcuMmJzqR7j?=
 =?us-ascii?Q?GDmsetDMXc8IVSAERwvZNUkDgfoJPVsSY/6kdl6jaWFZkVt97AT+JjN+7Qlz?=
 =?us-ascii?Q?Yo/OBxcuFJD/9d6R96Dcba6n5hL3TmRMIfNeFmF4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e341feab-bc50-41d8-4a28-08da94b20cce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 11:29:26.9250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rujjmSeLCFOb8Ywx6CAJO7OATKRBqDSJDO5XQKLt9lmwk292bDm18m0kmFTA2MRsKUEJO9wP8tqSTbkssdBnDhAbM0f8DEhK9fFwVhLTSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_07,2022-09-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120038
X-Proofpoint-ORIG-GUID: lUE19dp9hoFFe2NrrWre0TmFbaJdHzGN
X-Proofpoint-GUID: lUE19dp9hoFFe2NrrWre0TmFbaJdHzGN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 02:25:45PM +0800, Yu Zhe wrote:
> The platform_get_irq_byname() function returns negative error codes on error,
> check it.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> index c131d8118489..d985056db6c2 100644
> --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> @@ -705,6 +705,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
>  		return netdev->irq;
>  
>  	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
> +	if (enet->irq_tx < 0)
> +		return enet->irq_tx;
>  

If you read the driver, then you will see that this is deliberate.
Search for irq_tx and read the comments.  I'm not a subsystem expert so
I don't know if this an ideal way to write the code, but it's done
deliberately so please don't change it unless you can test it.

regards,
dan carpenter

