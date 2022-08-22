Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF1559BF35
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 14:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiHVMEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 08:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiHVMEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 08:04:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EA81EEFB;
        Mon, 22 Aug 2022 05:04:44 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27MC3nd4023501;
        Mon, 22 Aug 2022 12:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : content-transfer-encoding :
 in-reply-to : mime-version; s=corp-2022-7-12;
 bh=GMvzHbgmTDychvH7/nZzrsICv+ODHaLTNkpdkiXkpzc=;
 b=Vs4aJFpv8IGyIXc3Ttfp9dnb0VIWxOI/XMOwK72NIC6m1jymDpSltEzwcZC4HQtC3Cu9
 DnyW6eAaiSUgSd8ANopiOjZNZimNrWA0ZgfWqSh8Bod4V/RN8QWMQJ3ZU5SnZhWzWVHh
 Ym6k7nb47B6aRaV4d75PPxo3IT6SUX6CZWHX1hBdU6I2YiquDWtZja4jBGzqD7d6qLVz
 Nfe7dpypbRMKOm5Gf8ylIPzhaH9Fd8D1gKCEF2OJBXX0y+T93fUCCqWskPqLXCaMHCD7
 UNLrSWQ/PXxtJW0TDGSXy6wtWMl/1T6GfAE6aqEzNk9XU1IWejClW1aH25fF3h/YwNPg 5Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j486gr6ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 12:04:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27MAO4Wj017743;
        Mon, 22 Aug 2022 12:04:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mn3nw3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 12:04:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZBpvHBURPsl+S36Mnz/hm3/l0rh02mBIBR4oOFEnQr+LMIvRntjjyba8KmGV62wQnoxKegMjx/gXUbhXEjOfMXrCc3AUcK4cjCQdY6GAwVjsE5D8TeYBUVuUNPAeyi/5mXDtph41J9cKRPUygnZsYGc0gENbbXNXzEbe2ZFY23ksUOKjtQ5iOvACWspHmghETU3O1Qc5S2uruFKbgsbbcNU5ZATLMlLYMaVEXAAP6FKFajNiAT21OBmP+erj2e5lPU9qtSjuodVqIM/vWzQyVCgDR3uNq7MJySnM9a7HHMawBILTUWuZqiGKo/nlmK1ZBdYRytCXdJgLVdt+Lsx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gj62K5Sn60FIHAcT1ulDvvNC7YzBs447CFDLCJP8e5I=;
 b=IRca8oljRsG44DhX9dFDJcKNMDjL53d9Su/F9rhNlDSEo8v+Zy/UMLL3p3kXqk6wwVPiQbdyTgMqlCZNX5Jv4xRvjNg6FBs3bD/WjBQGGIqYmgiE81rE9g9jHCHDSvFA5+mrJr/X6C6IxFJGR5TmzJCoNW/Mcu1xvh8OxEfONsZ5oYp5Hdx74qrj8rXDyr3beqk37EQ6KMgjnZHMK33TnqcVx6lmIqFp1zypLYDJnKSAN4I+RkxZC4D6A2SFwfpuA6Cnh2uXaAu1vuSy3OU1bOz5OaMkkAE7KhfsdfANHgdz2S2RSqeqg9PgtwdWEH/hbDM24ULaFY24T1/xbPK69g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj62K5Sn60FIHAcT1ulDvvNC7YzBs447CFDLCJP8e5I=;
 b=wv4sBi0CjXtHwI9aGc+KqRhPIRW0fGreY7E1BtMCQTsx8GqcPJSc5fbDtpifjniw/BOHO6ZLhRGUVQQBx3Qj4W1yDWrt6QdMhKrAq8r34nueSCNyW2gfoPRHxvCAUj26+Hpl+xLKQ8JaX1u0m4BLMojriEkKxZmdA4oWdzTPBLU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SA1PR10MB6341.namprd10.prod.outlook.com
 (2603:10b6:806:254::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Mon, 22 Aug
 2022 12:04:15 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 12:04:14 +0000
Date:   Mon, 22 Aug 2022 15:03:40 +0300
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
Subject: [kbuild] Re: [PATCH 11/31] net/tcp: Add TCP-AO sign to outgoing
 packets
Message-ID: <202208221901.Fs6wW5Jd-lkp@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220818170005.747015-12-dima@arista.com>
Message-ID-Hash: YQ3E53LPCOTHYE7BJ3JPUUF2WIMNASKR
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0042.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 726fbf0d-cd74-4e5e-b0d7-08da84366e7c
X-MS-TrafficTypeDiagnostic: SA1PR10MB6341:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AHXvcKlIvb9ZsdRu8is6+DBbUqWg9U+dj7Y8Kd3MqKUSfaxXHnNKqpXLOridPSScgqO1HB5QP4SlAlWYB8rq/nw/8P1j4DUArIEFQ974KkSPsDyDtxVziR4FBad4ZWf9MxN8sJrpWbvetlOg9frX5RTB9zONhCFzALRUGh8dnULSayaT9X7d3Qi5cws4qvp9d0H7ECIozPsmuwonA+eoR8R0r2q09kY4RFR+HCHUXaWaX9PEUHS7oQrAbXZVDSBxr/TflXr6SoiDlGWjHG7K0UK9K+1EyEU8FGOavVfQbpKRqSAylsaNl2eJDf2rpwJc/R/e/9q2/O2CfNASYxMF23PaX6raB58EZWdYQJgurlj0+qUHz3C5hD18nulzJtE1vT49achF+lSrDfnftfmWv6ll181FurU2UWcjZnqS/8Vf8kNvfyjPQ6q1m/8cZPQgtelxp3KB7005jOwBfq1nVbfq2q4oFsam3mqbayjBLI4S+6J/xKMcrP29zP7rTzs3cI8yGnHmp/jrAuhCTE1EGwoQWAmqKy3z3a7EQCh1NneGvIzIK+VgmJf8XfSkYzBB6byeptG36FVx1xP1s+GkrwiCloIZuTeqvZo3yxg/3CUNKvr0oAePYX0ifDp2b82d7RwW/8BjlLuPUMARXeQWaJQfD9FGG+OkAeSf0bePicfajNE9HOsHu2d2nKKFox2dEWqAv+mCL84OFwhzMFSD6fjtonMFxXCg/ESb+gLkhOKCTmZ1kbnCPCbh4G484ieraqEYC/p7XA0JjUNJ16Zs5KjKE81MNQ9joL86PnphsJyzWDuNljC1Q64bS28g8b6TzgGjvcXpgYe9bjEg2H6Qkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(366004)(376002)(346002)(396003)(1076003)(186003)(83380400001)(54906003)(316002)(26005)(86362001)(52116002)(36756003)(6506007)(41300700001)(7416002)(9686003)(44832011)(5660300002)(6512007)(6666004)(38350700002)(38100700002)(966005)(6486002)(478600001)(66476007)(66946007)(8676002)(4326008)(66556008)(110136005)(2906002)(4001150100001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?M/w8dA8uk7DBKwi2ij6cjYmckSXlL+b2seu7W1/GndLEtgUNaVQOejubqv?=
 =?iso-8859-1?Q?6nnKkk/0cvhXU9jb46Z7VlFtWDQQ2o/Do6iSUPrmGJe95KhQ4Zce4PuBy5?=
 =?iso-8859-1?Q?PclJTkyqhwNDk5Pk9wGg1pf5uUT0g9hwgjez1Zjn+wVcvGa8sEllHgGWib?=
 =?iso-8859-1?Q?ARfEdi4EmNB1Hkk40vF3GcLE7mSJ4Q7v1qo0jsrCYwCAf9sZ/cVnC5YfQr?=
 =?iso-8859-1?Q?l0mZI2qEOdyqEMg00s5wSTL4Pkgp97n/X4RdeGTdvsGE59dUcv+32DPCEj?=
 =?iso-8859-1?Q?PVxA2nRMaVQ0pLYRwiKVY+2T41Q/Plt7o2LsDFgKNBcWlcX8KGa20m1AZk?=
 =?iso-8859-1?Q?EZuGdEJn9l7UvlyxGw0syvL+O3Zt3x3K5HJSZcySVDjlsipTm6ehrjm7Dn?=
 =?iso-8859-1?Q?Py6M999a5weo1lCGvHFwbVqdGQceuQccYzGXhcMQD38vZBNZ0G5CSDNerX?=
 =?iso-8859-1?Q?yTrvjRsonQuA/F26lqZx6mI4MF+kmLQW/nyoKPFIoFoasBxOAg/m+26Q50?=
 =?iso-8859-1?Q?oRMGQUZDA+gjLkwUhRitS/cszw1+KKljtuoEkkoiAwB/biQjvvcpLcWozO?=
 =?iso-8859-1?Q?VTKdCRb2KjKNceIE+pkueWi30Kxtdtmm5ctOdeg+NDZJxYzy5Cxckg9Vxb?=
 =?iso-8859-1?Q?7kwkDV+Sy6JO0Ju54Zqs6O9IkTo9EL5KzqXTIhsnfNJy3Dtq298muU9i/v?=
 =?iso-8859-1?Q?PwBYL3iovR/RTcPOBOYB63DxiQv+IZpHuaZTRyafXAbjHNgUUOo86Td80Z?=
 =?iso-8859-1?Q?RSwi8nZHbqW5KpNK/qpLJMlTvFgCnFx8mR2MYtOXXcqnop7Vs9Fq3Z4tWs?=
 =?iso-8859-1?Q?JPHgkOMzRCrkdh+C7A7WKphoo2PPMRFWb40z85zHyNi2oR5SLcBdMcIk4O?=
 =?iso-8859-1?Q?tU9anMaZ+RWh3n8Of55O2aHE5Rohdkb4OT0eoovPALp6LVQbaFMMGLK8uq?=
 =?iso-8859-1?Q?F0epuwVkCfluzTPl6T+8ZW45MPc6AjcyOTbxEACnwD+daZU4jUv6DvSuIp?=
 =?iso-8859-1?Q?rsPewlX5RHZYYo3JD1y+lOEXgfObE+swEKz4jHDQwZxhkH2srDOWTK2GRV?=
 =?iso-8859-1?Q?3v9A4keZSfAeDIvgoQx2wLgZ71B9j1FgYNoQ23UA6VMS9djIyCiCgHSVCV?=
 =?iso-8859-1?Q?lLhjXnE5ufB8LXfUqNqxa0AUv+mkhoyM20fvhq/ybAxidzYrapLFMtbXeA?=
 =?iso-8859-1?Q?wBdtq5zl7h0gpseQkfHBqCcEk34ffwHbNHKBl1/M2V0cQaDwt+Dce5T03+?=
 =?iso-8859-1?Q?RLIzQ0d1BvXNYpP3vvYET02TeaipJPD32K9EwfUZaCqpheEMUrsKMsvEjb?=
 =?iso-8859-1?Q?nXeNM48oB+I3qQc2go9B/cWjC/z46v9ksey+cwmpW9aLXKAZkRqbt2FSKv?=
 =?iso-8859-1?Q?RyAuhikBylpiRqGKMUovifvrR5ou8F4PC1mZOYyaOj4fiaEZ/wreHzl7vb?=
 =?iso-8859-1?Q?djLt6/bjsDtLMmGDaXJ5zSWirLAFRi2Z7VVhoLQwUoUCWgkmuRW/hMcGPA?=
 =?iso-8859-1?Q?5oGE6SatISrM63CZ5sUod/rTN9CrMcbMDA+9Yp+OOeeo2DwUZH/UvwC5vI?=
 =?iso-8859-1?Q?dUpA4oGxJL8VnUHbUAigh5VM0/3nRl3Pq0jjFrMlCoPOWFjJ8WEsP4U/0O?=
 =?iso-8859-1?Q?Rc5SYq/aUO4X7HKd5gTa2KmAjM9zS2Vz7FayaNPOunLlC8F0Ef97WYYg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726fbf0d-cd74-4e5e-b0d7-08da84366e7c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 12:04:14.5612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuXPgzF8IHIhNhnkXQmoidPc1jx6mclqOenBORZFWd0/TctfThwOEc18c5HWRSwq3CpXIqc09Dnj+/B1oAc92Wor6UJb2cavHgsbP7Jn/6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6341
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_06,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220051
X-Proofpoint-ORIG-GUID: KqDEf11i0zffQoKITnKC5vQyfUaEc-pi
X-Proofpoint-GUID: KqDEf11i0zffQoKITnKC5vQyfUaEc-pi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
config: x86_64-randconfig-m001 (https://download.01.org/0day-ci/archive/20220822/202208221901.Fs6wW5Jd-lkp@intel.com/config  )
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/ipv4/tcp_output.c:640 tcp_options_write() error: uninitialized symbol 'maclen'.
net/ipv4/tcp_output.c:686 tcp_options_write() error: we previously assumed 'tp' could be null (see line 626)

vim +/maclen +640 net/ipv4/tcp_output.c

ea66758c1795cef Paolo Abeni           2022-05-04  608  static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
85df6b860d509a9 Dmitry Safonov        2022-08-18  609  			      struct tcp_out_options *opts,
85df6b860d509a9 Dmitry Safonov        2022-08-18  610  			      struct tcp_ao_key *ao_key)
bd0388ae7707502 William Allen Simpson 2009-12-02  611  {
ea66758c1795cef Paolo Abeni           2022-05-04  612  	__be32 *ptr = (__be32 *)(th + 1);
2100c8d2d9db23c Yuchung Cheng         2012-07-19  613  	u16 options = opts->options;	/* mungable copy */
bd0388ae7707502 William Allen Simpson 2009-12-02  614  
bd0388ae7707502 William Allen Simpson 2009-12-02  615  	if (unlikely(OPTION_MD5 & options)) {
1a2c6181c4a1922 Christoph Paasch      2013-03-17  616  		*ptr++ = htonl((TCPOPT_NOP << 24) | (TCPOPT_NOP << 16) |
1a2c6181c4a1922 Christoph Paasch      2013-03-17  617  			       (TCPOPT_MD5SIG << 8) | TCPOLEN_MD5SIG);
bd0388ae7707502 William Allen Simpson 2009-12-02  618  		/* overload cookie hash location */
bd0388ae7707502 William Allen Simpson 2009-12-02  619  		opts->hash_location = (__u8 *)ptr;
33ad798c924b4a1 Adam Langley          2008-07-19  620  		ptr += 4;
33ad798c924b4a1 Adam Langley          2008-07-19  621  	}
85df6b860d509a9 Dmitry Safonov        2022-08-18  622  #ifdef CONFIG_TCP_AO
85df6b860d509a9 Dmitry Safonov        2022-08-18  623  	if (unlikely(OPTION_AO & options)) {
85df6b860d509a9 Dmitry Safonov        2022-08-18  624  		u8 maclen;
33ad798c924b4a1 Adam Langley          2008-07-19  625  
85df6b860d509a9 Dmitry Safonov        2022-08-18 @626  		if (tp) {

Can "tp" really be NULL?  Everything else assumes it can't.

85df6b860d509a9 Dmitry Safonov        2022-08-18  627  			struct tcp_ao_info *ao_info;
85df6b860d509a9 Dmitry Safonov        2022-08-18  628  
85df6b860d509a9 Dmitry Safonov        2022-08-18  629  			ao_info = rcu_dereference_check(tp->ao_info,
85df6b860d509a9 Dmitry Safonov        2022-08-18  630  				lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
85df6b860d509a9 Dmitry Safonov        2022-08-18  631  			if (WARN_ON_ONCE(!ao_key || !ao_info || !ao_info->rnext_key))
85df6b860d509a9 Dmitry Safonov        2022-08-18  632  				goto out_ao;
85df6b860d509a9 Dmitry Safonov        2022-08-18  633  			maclen = tcp_ao_maclen(ao_key);
85df6b860d509a9 Dmitry Safonov        2022-08-18  634  			*ptr++ = htonl((TCPOPT_AO << 24) |
85df6b860d509a9 Dmitry Safonov        2022-08-18  635  				       (tcp_ao_len(ao_key) << 16) |
85df6b860d509a9 Dmitry Safonov        2022-08-18  636  				       (ao_key->sndid << 8) |
85df6b860d509a9 Dmitry Safonov        2022-08-18  637  				       (ao_info->rnext_key->rcvid));
85df6b860d509a9 Dmitry Safonov        2022-08-18  638  		}

"maclen" not initialized on else path.

85df6b860d509a9 Dmitry Safonov        2022-08-18  639  		opts->hash_location = (__u8 *)ptr;
85df6b860d509a9 Dmitry Safonov        2022-08-18 @640  		ptr += maclen / sizeof(*ptr);

Uninitialized.

85df6b860d509a9 Dmitry Safonov        2022-08-18  641  		if (unlikely(maclen % sizeof(*ptr))) {
85df6b860d509a9 Dmitry Safonov        2022-08-18  642  			memset(ptr, TCPOPT_NOP, sizeof(*ptr));
85df6b860d509a9 Dmitry Safonov        2022-08-18  643  			ptr++;
85df6b860d509a9 Dmitry Safonov        2022-08-18  644  		}
85df6b860d509a9 Dmitry Safonov        2022-08-18  645  	}
85df6b860d509a9 Dmitry Safonov        2022-08-18  646  out_ao:
85df6b860d509a9 Dmitry Safonov        2022-08-18  647  #endif
fd6149d332973ba Ilpo Järvinen         2008-10-23  648  	if (unlikely(opts->mss)) {
fd6149d332973ba Ilpo Järvinen         2008-10-23  649  		*ptr++ = htonl((TCPOPT_MSS << 24) |
fd6149d332973ba Ilpo Järvinen         2008-10-23  650  			       (TCPOLEN_MSS << 16) |
fd6149d332973ba Ilpo Järvinen         2008-10-23  651  			       opts->mss);
fd6149d332973ba Ilpo Järvinen         2008-10-23  652  	}
fd6149d332973ba Ilpo Järvinen         2008-10-23  653  
bd0388ae7707502 William Allen Simpson 2009-12-02  654  	if (likely(OPTION_TS & options)) {
bd0388ae7707502 William Allen Simpson 2009-12-02  655  		if (unlikely(OPTION_SACK_ADVERTISE & options)) {
33ad798c924b4a1 Adam Langley          2008-07-19  656  			*ptr++ = htonl((TCPOPT_SACK_PERM << 24) |
33ad798c924b4a1 Adam Langley          2008-07-19  657  				       (TCPOLEN_SACK_PERM << 16) |
33ad798c924b4a1 Adam Langley          2008-07-19  658  				       (TCPOPT_TIMESTAMP << 8) |
33ad798c924b4a1 Adam Langley          2008-07-19  659  				       TCPOLEN_TIMESTAMP);
bd0388ae7707502 William Allen Simpson 2009-12-02  660  			options &= ~OPTION_SACK_ADVERTISE;
33ad798c924b4a1 Adam Langley          2008-07-19  661  		} else {
496c98dff8e3538 YOSHIFUJI Hideaki     2006-10-10  662  			*ptr++ = htonl((TCPOPT_NOP << 24) |
40efc6fa179f440 Stephen Hemminger     2006-01-03  663  				       (TCPOPT_NOP << 16) |
40efc6fa179f440 Stephen Hemminger     2006-01-03  664  				       (TCPOPT_TIMESTAMP << 8) |
40efc6fa179f440 Stephen Hemminger     2006-01-03  665  				       TCPOLEN_TIMESTAMP);
40efc6fa179f440 Stephen Hemminger     2006-01-03  666  		}
33ad798c924b4a1 Adam Langley          2008-07-19  667  		*ptr++ = htonl(opts->tsval);
33ad798c924b4a1 Adam Langley          2008-07-19  668  		*ptr++ = htonl(opts->tsecr);
33ad798c924b4a1 Adam Langley          2008-07-19  669  	}
33ad798c924b4a1 Adam Langley          2008-07-19  670  
bd0388ae7707502 William Allen Simpson 2009-12-02  671  	if (unlikely(OPTION_SACK_ADVERTISE & options)) {
33ad798c924b4a1 Adam Langley          2008-07-19  672  		*ptr++ = htonl((TCPOPT_NOP << 24) |
33ad798c924b4a1 Adam Langley          2008-07-19  673  			       (TCPOPT_NOP << 16) |
33ad798c924b4a1 Adam Langley          2008-07-19  674  			       (TCPOPT_SACK_PERM << 8) |
33ad798c924b4a1 Adam Langley          2008-07-19  675  			       TCPOLEN_SACK_PERM);
33ad798c924b4a1 Adam Langley          2008-07-19  676  	}
33ad798c924b4a1 Adam Langley          2008-07-19  677  
bd0388ae7707502 William Allen Simpson 2009-12-02  678  	if (unlikely(OPTION_WSCALE & options)) {
33ad798c924b4a1 Adam Langley          2008-07-19  679  		*ptr++ = htonl((TCPOPT_NOP << 24) |
33ad798c924b4a1 Adam Langley          2008-07-19  680  			       (TCPOPT_WINDOW << 16) |
33ad798c924b4a1 Adam Langley          2008-07-19  681  			       (TCPOLEN_WINDOW << 8) |
33ad798c924b4a1 Adam Langley          2008-07-19  682  			       opts->ws);
33ad798c924b4a1 Adam Langley          2008-07-19  683  	}
33ad798c924b4a1 Adam Langley          2008-07-19  684  
33ad798c924b4a1 Adam Langley          2008-07-19  685  	if (unlikely(opts->num_sack_blocks)) {
33ad798c924b4a1 Adam Langley          2008-07-19 @686  		struct tcp_sack_block *sp = tp->rx_opt.dsack ?

Unchecked dereference.

33ad798c924b4a1 Adam Langley          2008-07-19  687  			tp->duplicate_sack : tp->selective_acks;
40efc6fa179f440 Stephen Hemminger     2006-01-03  688  		int this_sack;
40efc6fa179f440 Stephen Hemminger     2006-01-03  689  
40efc6fa179f440 Stephen Hemminger     2006-01-03  690  		*ptr++ = htonl((TCPOPT_NOP  << 24) |
40efc6fa179f440 Stephen Hemminger     2006-01-03  691  			       (TCPOPT_NOP  << 16) |
40efc6fa179f440 Stephen Hemminger     2006-01-03  692  			       (TCPOPT_SACK <<  8) |
33ad798c924b4a1 Adam Langley          2008-07-19  693  			       (TCPOLEN_SACK_BASE + (opts->num_sack_blocks *
40efc6fa179f440 Stephen Hemminger     2006-01-03  694  						     TCPOLEN_SACK_PERBLOCK)));
2de979bd7da9c8b Stephen Hemminger     2007-03-08  695  
33ad798c924b4a1 Adam Langley          2008-07-19  696  		for (this_sack = 0; this_sack < opts->num_sack_blocks;
33ad798c924b4a1 Adam Langley          2008-07-19  697  		     ++this_sack) {
40efc6fa179f440 Stephen Hemminger     2006-01-03  698  			*ptr++ = htonl(sp[this_sack].start_seq);
40efc6fa179f440 Stephen Hemminger     2006-01-03  699  			*ptr++ = htonl(sp[this_sack].end_seq);
40efc6fa179f440 Stephen Hemminger     2006-01-03  700  		}
2de979bd7da9c8b Stephen Hemminger     2007-03-08  701  
40efc6fa179f440 Stephen Hemminger     2006-01-03  702  		tp->rx_opt.dsack = 0;
40efc6fa179f440 Stephen Hemminger     2006-01-03  703  	}
2100c8d2d9db23c Yuchung Cheng         2012-07-19  704  
2100c8d2d9db23c Yuchung Cheng         2012-07-19  705  	if (unlikely(OPTION_FAST_OPEN_COOKIE & options)) {
2100c8d2d9db23c Yuchung Cheng         2012-07-19  706  		struct tcp_fastopen_cookie *foc = opts->fastopen_cookie;
7f9b838b71eb78a Daniel Lee            2015-04-06  707  		u8 *p = (u8 *)ptr;
7f9b838b71eb78a Daniel Lee            2015-04-06  708  		u32 len; /* Fast Open option length */
2100c8d2d9db23c Yuchung Cheng         2012-07-19  709  
7f9b838b71eb78a Daniel Lee            2015-04-06  710  		if (foc->exp) {
7f9b838b71eb78a Daniel Lee            2015-04-06  711  			len = TCPOLEN_EXP_FASTOPEN_BASE + foc->len;
7f9b838b71eb78a Daniel Lee            2015-04-06  712  			*ptr = htonl((TCPOPT_EXP << 24) | (len << 16) |
2100c8d2d9db23c Yuchung Cheng         2012-07-19  713  				     TCPOPT_FASTOPEN_MAGIC);
7f9b838b71eb78a Daniel Lee            2015-04-06  714  			p += TCPOLEN_EXP_FASTOPEN_BASE;
7f9b838b71eb78a Daniel Lee            2015-04-06  715  		} else {
7f9b838b71eb78a Daniel Lee            2015-04-06  716  			len = TCPOLEN_FASTOPEN_BASE + foc->len;
7f9b838b71eb78a Daniel Lee            2015-04-06  717  			*p++ = TCPOPT_FASTOPEN;
7f9b838b71eb78a Daniel Lee            2015-04-06  718  			*p++ = len;
7f9b838b71eb78a Daniel Lee            2015-04-06  719  		}
2100c8d2d9db23c Yuchung Cheng         2012-07-19  720  
7f9b838b71eb78a Daniel Lee            2015-04-06  721  		memcpy(p, foc->val, foc->len);
7f9b838b71eb78a Daniel Lee            2015-04-06  722  		if ((len & 3) == 2) {
7f9b838b71eb78a Daniel Lee            2015-04-06  723  			p[foc->len] = TCPOPT_NOP;
7f9b838b71eb78a Daniel Lee            2015-04-06  724  			p[foc->len + 1] = TCPOPT_NOP;
2100c8d2d9db23c Yuchung Cheng         2012-07-19  725  		}
7f9b838b71eb78a Daniel Lee            2015-04-06  726  		ptr += (len + 3) >> 2;
2100c8d2d9db23c Yuchung Cheng         2012-07-19  727  	}
60e2a7780793bae Ursula Braun          2017-10-25  728  
60e2a7780793bae Ursula Braun          2017-10-25  729  	smc_options_write(ptr, &options);
eda7acddf8080bb Peter Krystad         2020-01-21  730  
ea66758c1795cef Paolo Abeni           2022-05-04  731  	mptcp_options_write(th, ptr, tp, opts);
                                                                                     ^^
Not checked here either.

60e2a7780793bae Ursula Braun          2017-10-25  732  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp  
_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

