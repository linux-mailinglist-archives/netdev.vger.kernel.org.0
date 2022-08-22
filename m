Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707B159BDCC
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiHVKqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 06:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbiHVKqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 06:46:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E002BB29;
        Mon, 22 Aug 2022 03:46:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MAZquY001191;
        Mon, 22 Aug 2022 10:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2022-7-12; bh=OQnXDpabuoU6FI3Ho7SCfYK3QLSRR8cKmIr4TKdQX18=;
 b=Va41fYlkL8paUrAqhg1jPlr4eKxv7SLH9kan6Heoo5pyceBsET6llfG2MNKjEaC4DbLd
 /w1Z5UUSXhvCSSuPQ/TZHm2837omqTFeLqz/EzdFXq5QDILeHYE0bOqvdhkaDgqjnC6T
 /f0B/uiPTpBRre2BlewIgnCsWqsvJslCaFNE0ce0Pe/YehP663KxOHV5P3KZLJmr/uoU
 Lk7z6JrDdlsZ7qRCpsMKo+B1FU9DnV/IH7XDp/cPNNpIq0mwnqkjUZT0sk2D+WX6mAy2
 2sjwW100FTt8Nfml2ao4CH0nG4aIGV46stBqdBl0pJccvOj07XLQKc4dqPCz/JALnzi+ pQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j486gr0s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 10:45:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27MAO39j003933;
        Mon, 22 Aug 2022 10:45:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mkfv8w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 10:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/7BaMWRHP4oHUhYMIIObmqyn+gsLeqqvpu8/ChaLxO5k/VBq8ocweb/7HOEBF09TcTf+qspTEoDA52gZ1aJ/9K0D/Qr0hgZxkW0GRnC10RRlLKs9dryobUqISYzZftBLmzF48I/7MC1kPqVQFL7dwhuVIkC3tQkojbfbJ/6QnpegHeovVfFScg9FlSrkOBON7JoJ3pKWfULJoRzjZTEdjW3ci1uGp8IbcYUn+KIkwo4dpA7tfdKXI3EqLkARwyOZhxNPPIcYfVLQKPbLsvK//kata2Lt1e97cEMMq3tmZ1I3XEKTMPhiUapCVJ9y5pQyIWEHVN+1/8VnHyNySC/WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQnXDpabuoU6FI3Ho7SCfYK3QLSRR8cKmIr4TKdQX18=;
 b=mQBgsmvMU3bMLrUNML4fH9kJWckhhzsXeAbuuPXtneyLHB3axkNi1A63uPVBnUahRzPlYuZZK6NHSQl4FJa7ztQGBSM8pBtehzNYJy4BnnZZF7ghGhfTWs1xrojq43q78GrryI1KXCzfUmuFg7Q9DOIk4ShTgrR+I/Ys7J6ckmXDhLVIiU0bS2HRLOTneNrefjt7g4TUHsgSJdhfLacQZCOHN49KCTB2W6VVJkX6YKu0XVZrY4UlGyXn99maV3GQNKj88z9LBTy8mnSXbUXg5jj5+SjnrSvZtzdg80VO1BNGUrTMXIJPno4ZIjY21QNgeOTMS4rCwgi8Al+WZARHiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQnXDpabuoU6FI3Ho7SCfYK3QLSRR8cKmIr4TKdQX18=;
 b=JcZQge//Nr9BqNbJdK2yph0hacZSXlUivmAyjW3kv/geNW0hpaal1IPsQo/9x4y0OC3Uk0UOxTHdha6qnG8yeNXZ+S6WZiohhQD9FmPWtpkDvr+9WYYrSmWAJoTGgLZ71HN6d0J4mIi4FTUqbYJkfTJk/2YCTFwdeStrxphKavo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BYAPR10MB3141.namprd10.prod.outlook.com
 (2603:10b6:a03:154::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 10:45:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 10:45:43 +0000
Date:   Mon, 22 Aug 2022 13:45:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Dmitry Safonov <dima@arista.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 02/31] crypto_pool: Add crypto_pool_reserve_scratch()
Message-ID: <202208221817.t5uzfegL-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818170005.747015-3-dima@arista.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0003.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::8) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 389ab2eb-4191-4bfc-dfc0-08da842b7629
X-MS-TrafficTypeDiagnostic: BYAPR10MB3141:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aWkwTwnzX5gJHwtkDCV1rckrq3zKnTvQZqx/vvl1SGiKhrMFr8C0yL7oqbrmefGLJ7Avfp2MM92mc8zC58moWq8NDB9pDXw10I8dLKgYM3+ss/Jgmi1nyJNv7Q3tE3zYmldWYhCpxnycUETPUMFjDBfljsdf4tirsQXS0ijlJAhpd4wup1CI6k94tYUA5exaHixw4CZoNiGlg5WJXvTkhPGScpekCTdYL6/qlPlHIanIDIWZxp4+sdwtOK5LPh6erIPgiVbTTcf31eTonRjzCSESnT4AMK/Sgmymb0I+7YL5OvBsHvi08TkkEpOnLwyOQ4JR3+MJstWvJumBRMDbNXohMd4cT2IprHS6tpAo5lzc7nniQGKmFfpxhNKe6sKSyP2zvV75GdrZeECkrEDdnHcszuNZJ/0XMJh80x++BybHgeAlpdkEZYsl4pOncxcOtiCS1jslv1bE8WnRkROnfc1YJ6vo7BZqXImpW8S3hZJ+7rEU6mueNUDG3ZmF9q2qDM9tZIHc7x7gq71jDtPHLv3KcOR+RVovOkpYWXeG3vi0aotBR7ztHFosiyztL0dalQV6MtrRumE83pnIsZF5uTR6CSRNEMI0193hCUFt3cCois3BzjfNOrgY2DrQcWJq7K9agUu13bevXlf3xTflhnG5wJ1rXg9QZGYseK4PJemoEc02TdkVboV60Zxt79bXGXDStGPFUcQNiBzy1jqKa4M1ioVEpmqIF0woaFms+bYG9U1BMj0tlz00gCgpLjajro0rhXwQBvlMPMtZJ13Cr/ZxLzVjX1AcSXmU3aMJLBMmt+05TJq3lXexkRYSCehI5OSaQpw6oCIHC7zGfmykCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39860400002)(396003)(83380400001)(1076003)(186003)(38350700002)(38100700002)(36756003)(8676002)(4326008)(66946007)(66556008)(66476007)(110136005)(54906003)(316002)(2906002)(7416002)(86362001)(44832011)(8936002)(5660300002)(9686003)(6666004)(6512007)(6506007)(52116002)(26005)(478600001)(41300700001)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5/E0nQDhDCM8Z1nR/Bn0RGOk72rkLffTnIQnGrzjhkhW/ANig9bFvQn81jVn?=
 =?us-ascii?Q?geVjZSDgxPopuBTINhGCO6VWBcsvmi4DjKr+0XW9jK/J5ge4dMCzE26/JC1D?=
 =?us-ascii?Q?v4itPzQFcBGv3Z0/PER61LM37DjsyjYVNN9wErdjRnqSLGvrJZqX3XY/tsK2?=
 =?us-ascii?Q?DQ7KRi7zsmJVnb1Mk6LNsvPliuJvTFP0iV62/7PJs7BCPol79eIUXD81FnJj?=
 =?us-ascii?Q?+mK61ysKkdULl2aFy5u5J1ER/pKxmj6ZkBMR3HdAPKxgx+u019cF/a0wQ92M?=
 =?us-ascii?Q?QubQbzKvfWXPRjQGFJ2fvtQSy2YlWf2Eu8veMYh2ARUqFad7uQkU2BlYKQSu?=
 =?us-ascii?Q?Y0ekE7o/dZu6qVcQm0DUDtu6kCoxV7sQJoHmC7qTBAiNQrGjUdAOU2bYWseS?=
 =?us-ascii?Q?bWulKKaQmCFtq4I0NostAL22GN6XBh+RjGS9roJecKJDHA+hJOg7pIKRL1bk?=
 =?us-ascii?Q?yb+tPn5Oy3yr4cPYaeBMoB7Qo2gHb4eDjmSgu4JIrcsWB6xMUz9sAuq1crLv?=
 =?us-ascii?Q?NOwxIHBkVxPEmdG4P2zySe9JQ2PsVzx7nzP9AuLRIDi3p+1HiciaE2tsqHq1?=
 =?us-ascii?Q?eMGJogZaZrdNRum9PhZIsMnO71DBp63iiyz8yWpt0BoDdLYI/17grJ3JymBm?=
 =?us-ascii?Q?UbAahAlqYUBOjnJ8u73RcvNJi1SNuWqNSsy//MzW9i6iDBmQRCd/oxXOW6+w?=
 =?us-ascii?Q?jeMAN9JLdy75SmN04uW7qbrM/BSEwyHXgIbCvaOOakOhy5KPfEqaDz30XfPz?=
 =?us-ascii?Q?89DLtDJHTvd+R3DvlOsdEU+Z0p20Zljj4B74c9ZLuUQIGDjpzqxKmCAAAESv?=
 =?us-ascii?Q?s8KZoq44v4qwDV0r6ojEAWJZ0VNmy7N9skgJvX4iXalHsm63NZK/dHn/G5Eb?=
 =?us-ascii?Q?Aa2ygB4BquZFDA8L3B6152VCqMlhYz1lfNjK/cuj6tDoiBupBtAJronou/ai?=
 =?us-ascii?Q?XsJ6dIokPOovQDly+9K4tZnXX9YtXyqzcZbEI85eP8p7eS7i4NFOFpvzEhcj?=
 =?us-ascii?Q?IlLgz+fDdoXzwSs5/O5H2HAUNnmT+EGGig/5dy7ALsAfOpWEZCTBRmeDH+Ix?=
 =?us-ascii?Q?o2G81V8OP/Q7Y1ucxf6IQ42F95I+xsPvIPF7RjadlUR5Mh1mmYxgWu13aGmN?=
 =?us-ascii?Q?fvM/omrd6ldFiF0/7YOzIgO/lud5kkKXoeUAykFMPRfUYGv6fAAGCkCeGoIH?=
 =?us-ascii?Q?BE7eKCBaoEnn7c5kyOiAGw6pFalMFJVu49Z9SpmeEqu50Kj7+UVvaSneMOkZ?=
 =?us-ascii?Q?lrPX3aTK+5OQefoY/08QyUGR5CA3P1cDGGWY4i5zL9h+Sg7t1jruMxeOWCzW?=
 =?us-ascii?Q?jpb6yQ8w0ToAQHKQb+/Dw114PhXyA9eO/Q6mJbBccLexqg3xNE5GTxWLP+ed?=
 =?us-ascii?Q?gaM++rpsVCX+1VdE0FGTmph28eiAxW5WFh2GXf2jAdaDl90+ocnteWbDrVUX?=
 =?us-ascii?Q?ScvejfwAngu/pTzW7tI55dZFQW8ahH8l44gQb+pvX4hEO7V3pZGsq6dOD2FA?=
 =?us-ascii?Q?Y6wAHKlCcXIvY77o1U8M94P46gBNiGBBX8xDGN0g7eyBfJQRyJlnd8Sx7jAb?=
 =?us-ascii?Q?BBf3/UUfvTpTV75H4ICanJAEoKV5kHEMdR8dwd+7kDZ+/3mhRZwiCwZAmztp?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389ab2eb-4191-4bfc-dfc0-08da842b7629
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 10:45:43.0387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZI1jtFNOpb7CejJk7v5FPGBjJbc3MarrugRymhGQ8lKlrLEgnB7ZGO7tKfup2m2iXmk/mb7Yd9x7jkDRwKczTjJt1GQuTVZPTEfPhr45VhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_05,2022-08-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220045
X-Proofpoint-ORIG-GUID: sYxoYpENIwlC-DBNveyVHHAL_jjKW7To
X-Proofpoint-GUID: sYxoYpENIwlC-DBNveyVHHAL_jjKW7To
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FAKE_REPLY_C,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Safonov/net-tcp-Add-TCP-AO-support/20220819-010628
base:   e34cfee65ec891a319ce79797dda18083af33a76
config: x86_64-randconfig-m001 (https://download.01.org/0day-ci/archive/20220822/202208221817.t5uzfegL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
crypto/crypto_pool.c:203 crypto_pool_alloc_ahash() error: uninitialized symbol 'err'.

vim +/err +203 crypto/crypto_pool.c

f4c3873630fc8c4 Dmitry Safonov 2022-08-18  171  int crypto_pool_alloc_ahash(const char *alg)
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  172  {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  173  	unsigned int i;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  174  	int err;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  175  
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  176  	/* slow-path */
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  177  	mutex_lock(&cpool_mutex);
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  178  	for (i = 0; i < last_allocated; i++) {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  179  		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  180  			if (kref_read(&cpool[i].kref) > 0) {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  181  				kref_get(&cpool[i].kref);
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  182  				goto out;

"err" not set.  It was supposed to be set to zero at the start.  But
better to say "ret = i;" here maybe?

Why is i unsigned?  It leads to unsightly casts.  Presumably some static
checker insists on this... :/

f4c3873630fc8c4 Dmitry Safonov 2022-08-18  183  			} else {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  184  				break;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  185  			}
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  186  		}
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  187  	}
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  188  
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  189  	for (i = 0; i < last_allocated; i++) {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  190  		if (!cpool[i].alg)
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  191  			break;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  192  	}
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  193  	if (i >= CPOOL_SIZE) {
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  194  		err = -ENOSPC;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  195  		goto out;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  196  	}
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  197  
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  198  	err = __cpool_alloc_ahash(&cpool[i], alg);
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  199  	if (!err && last_allocated <= i)
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  200  		last_allocated++;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  201  out:
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  202  	mutex_unlock(&cpool_mutex);
f4c3873630fc8c4 Dmitry Safonov 2022-08-18 @203  	return err ?: (int)i;
f4c3873630fc8c4 Dmitry Safonov 2022-08-18  204  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

