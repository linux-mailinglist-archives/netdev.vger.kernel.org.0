Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E68C4F1EFE
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbiDDWSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350957AbiDDWPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:15:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0B44E3BC;
        Mon,  4 Apr 2022 14:44:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234IlZg2024458;
        Mon, 4 Apr 2022 21:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=XphJAyd529xFC8+G/rakPYLZQoMCCiDHRWlsqtpTprk=;
 b=kkubom0YExgaenIFqretsHFinykR9HT5LbyMrjaFuMsyUKp2z+H65zEQkbdN6YQwYzmS
 xSkaSmFqQYH94dE90kHOGwbA37qz6MUstXb2x/LETy/t7q2/6/q34JUQq9K95U8I2O5j
 9m5nhdrci2roP0j7UI1udrPYnBwQKMORnFDR9vyCxzfnobD2SWlwr8lEHfOG7TUjxb+5
 rzcGEVkIpY9PC4jD0MlPEgMZXhyXuje0DVT2KDj6RcYrMIT+LomWjKmjo3dBLPUYAblH
 A77oMMBG8ezH1t3tOqROjPMGhJu9RjjAGvVrb7ZIHQw/VP4658oOH0rIM8aC4o8WPGW/ UA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t4gtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 21:44:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 234LQkcf006295;
        Mon, 4 Apr 2022 21:44:03 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx30u48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 21:44:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXf1PSZHAbOWxRBrTwc3HFzWs3lHNCYGcP4ZGKg0b+h+hbkQrqqOg/U2ATlg28tO2bOMmRR08A6KpP7fpoGylCapaGBLCiezN1MlhN559sn18hDxZ//hPw8kl5L+l8o6HRMNDGXusi7o0vAYNX0qtlr6OMuHWShGTC+z1NzVYhZok6qFWLq7Z9ISc5Yol8XfNhlJxd3zjoxo91vbCCvNZFZXETphFev784kIchaoJeI47vAREtKcl5SXATqYEsLAFnbfTcR/lJV6F2Os8Xbf3VNBX3qd1IhQBn6gracS0Ml551K0GdZk0l0uNptVP1rT9/tJFthe+R6vcCuX7y79IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XphJAyd529xFC8+G/rakPYLZQoMCCiDHRWlsqtpTprk=;
 b=fYbvmWkDPhTnOLup5UWvuMR3qhNxNzO7uIqzIPApc14zLZEopluv6g/VekplVSFhsxb6yaJyAavj1DOCFZOpyhmEmhUXnrLIda8fAmz8OKx3z5J0ovT/qmTYaU70U4PMAnTWpWZSLh5tRJmYzYYwP8HVbOV2YyWek7lxJCnMeeQd9XFmHGWpTYyi/VXjzZcTlBufGEPMBiYvEbvhrYdDkyeMtYYM8eF/ld9E50fAZ3lp9jJJ7+oqEeaIVzVM4ePd+9Xy8wIVebsvw1VHqjZXCabglGcpQ1+FN/rPvmB6Pawoo004RQ26LL176L5K1iB3731QTW7+JLRlfJSZlb+0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XphJAyd529xFC8+G/rakPYLZQoMCCiDHRWlsqtpTprk=;
 b=OT/Ba/3hsr/bUrR0nZs/IERNQNJ9d38jCHv+GT+Zafa8nI/L8siPnFYVyGdhMWWpOuvitNqUvnpNuVrRjjfu5veSEWx2Ufyhv/aLuASYx1hNoanAc/Nd35IUvUPR4QTbdlOgYxvEswqueTBxLK3j5nLkiOLWpw3tyWoN3Qe6LfA=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 21:44:01 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 21:44:01 +0000
Date:   Mon, 4 Apr 2022 22:43:46 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter
To:     Ilya Leoshkevich <iii@linux.ibm.com>
cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 3/5] libbpf: add auto-attach for uprobes
 based on section name
In-Reply-To: <55ff4df690d18faa4c88d05009ebe6d0c70ad37d.camel@linux.ibm.com>
Message-ID: <alpine.LRH.2.23.451.2204042228270.6114@MyRouter>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>  <1648654000-21758-4-git-send-email-alan.maguire@oracle.com>  <CAEf4BzbB3yeKdxqGewFs=BA+bXBNfhDf2Xh4XzBjrsSp_0khPQ@mail.gmail.com>  <CAEf4BzZ5iLi=Xuw=+Ez30LWqPQuuVK8hGaVwfyHL5A+XDkFWgw@mail.gmail.com>
 <55ff4df690d18faa4c88d05009ebe6d0c70ad37d.camel@linux.ibm.com>
Content-Type: multipart/mixed; boundary="-1463809791-294283372-1649108640=:6114"
X-ClientProxiedBy: LO4P265CA0077.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::8) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99ab4f53-31c0-4839-f91a-08da16843b20
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB4306FA3B949D6B5032F504DEEFE59@BY5PR10MB4306.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /n3bL2sOeh6viJyXOdSUsa+xONUa0dGqP9zdiCSnhrIg/X6wM3zXQ5uiuJgtK7j3VWs7wnRALr8EPMhOV5961HqRiZNiIRd/phFt8Z6RUFc2qFBYLudU22rxWvLrrUMpEDFoqurWx0t9CoBlHGBgYTyuG+A9Du0Youfni5YaATnR1Qd1kNuE+eaC8iPanBG+2J1r5k8oVsFxGYxT1gWua/SpeAtNXlCDS8I0NOcDc+fgVkYUV0WNVv2bPtUCDnr8qCzdpSgGboMGDFO5yd/Bk0tnfcye1NlEWTiG4yeyoiIMWN4MqXuyiXHuPDOqQPMKWgfspMuh/cQZAVqwh3AvP7hOgxVsvBUsN57lN5wC73ZunjEeCwLX69OpVAPzKrMJcZ/7EJ8rAyXnGKXqmo4kRr/1nowDvTjpezi6YU7DRRCsmEFFtVPb242tx6148eGTU31bQEr6wpkhc//0iWoAtQdICA7zGUFBDEwqOIgolvN1hL3+Sg8njUag857FPvVgMw/MdY2sLZZFYFYKrAsBlVW8nwJAU5vUaUPUuLDAozYIfZvgUVymlmUh6nFMBxOe4gAmHwVFQVlfE9pea/XOR+kTjjNLK24HAfhHdFldYXhH76BMqvy8fbW/of+9grG2tip6acIX9eai85EugrAKQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(86362001)(8676002)(83380400001)(66476007)(66946007)(186003)(66556008)(33716001)(4326008)(8936002)(508600001)(44832011)(7416002)(38100700002)(5660300002)(316002)(2906002)(9686003)(6486002)(6506007)(54906003)(6916009)(53546011)(33964004)(52116002)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eG9QV3FIMGwrTlBmbGNhYjZoLytxUlJjRGp6dnpSazIvOStrSTlhOERqemxj?=
 =?utf-8?B?QU51VFhKTzZLSDltak44OUFVMndHUDN0UUU3R3BZeDFqM3pmY1VTRHBOUGdD?=
 =?utf-8?B?ZFhHWXllWnUxWmNmT3NWZzlsYnRvS1owMVNOeWgzVSt0ME5VaktIY3VSZjlU?=
 =?utf-8?B?Ti9Oc1gyMXc1d1Y0ZnpsN0NWQlNYVXYwblM0VXVTcExqNmhVV1dSQmM3QVAw?=
 =?utf-8?B?MU44NVdjUTlMa0VNL29kVnUxMVlnRFNqaHpyTHpyYUpIeW5Xb2Y5ZkV6Nldj?=
 =?utf-8?B?c1NjRzJVdXVDKzZERXpEbnFiajk0Q3FBajZMNUVVR1RjRWlqVUNvd1NQY1N0?=
 =?utf-8?B?UWhmVEhpZWRlUm9RVmtISWo2OUNIR2hEd2NNV05jVnpLNFVDd2VPdUpxU1pn?=
 =?utf-8?B?Wk9JNkMxU016NTR1MGN0ZjVqU252Y1ZDYlptYW5pWmZzNkxDQjlSVFN4ZWMv?=
 =?utf-8?B?a2QrMEI4eGpxNFNNQ0kzMTRsamVTUWo5VDRUT284WHY5V2w0V21kRGEwN2NQ?=
 =?utf-8?B?aDF2dzBON1FLMkd0K0lJem1xdHdtaU5NODg0NDZVS3N4SkxXNU11T3JxUld5?=
 =?utf-8?B?anBiTzVhL0FWRkNkQnZPR1c0aFBMWFFoaFdscmRRQjBzYjc3ZmduZWdjUHFk?=
 =?utf-8?B?ZXl2c2phcWtma1VPY0pHdlN6SlAwYmRBOFJwOXhVcDlHbGdWS1RwdGVqaXZu?=
 =?utf-8?B?bFJDakJLYkxTdThjN0JYSUpEMGJzYnhORHE5ZWFQUWdjMjRvam41ZVNUUEc2?=
 =?utf-8?B?MDg3dU5RTEpjdTRJMDgvQU5JaHJaSVplaVF1dm1qamhXVVMzVTBwbS8veE1q?=
 =?utf-8?B?UkNMR0U0VEN5Qmc0MEdjcVBSVWZ3b0xheEhoaUlid01iV0xvM1V3eGc4MzZq?=
 =?utf-8?B?NUtYdld5REZ6ck5od1U2SURac1BQVFBTY1dGMzBxeGQ0a2cvejJoQTN5NkdB?=
 =?utf-8?B?d2RxaWU4RjZZNWpHZHRFVGl1NVBLTTV3aG5YUG1FYWkzL05lSW1WcGZ5LzZp?=
 =?utf-8?B?cFpGQ0w0Sm5IMnJiOHNka25ZYmN0clRaVTQ2RElSMVdQK3FzcGFBZUpCdEdo?=
 =?utf-8?B?VnlTVS9oa0F2SHV5SnpwaWZCNG1GMDJZNEFuS3lYdDdLdW4yZ29MYnAwYUw5?=
 =?utf-8?B?NVBubUhGVlFyVThmZlFsZzVoSlVRNi9kNkpJSTB0NWQ2bEIySDRNYXdNQ3g2?=
 =?utf-8?B?WUJFQ0pjTzBnVTBEZUROS0hOc1RRUWNIY3hjdVRvYjN6bEs3MGFidkxHb2Jn?=
 =?utf-8?B?cjRRZGdBRWZRbnFKNHBTa09sWnBZRGJnWVNMQWJCQzRhUjJJbnZJZ0dVQldm?=
 =?utf-8?B?dEo2Smo2bkVCUnVocUpqaUw4NkZ2VDJadWIvT25kWG1ib2NBWE45VU82bmlW?=
 =?utf-8?B?bWIvR0syNUdPSGRUUHozMllZZUJyVXpleEV4Ti9XVTMyanVFUXZUYUE1cVJn?=
 =?utf-8?B?QkhyRVZKT1d1ZjFWanhmSVhJZUgxRFlVTyt3TGxkM2JiKy9vSWxCUUs2YVRm?=
 =?utf-8?B?azVZNXNsS2VXWldON3N6MlJnKzNWM1N5SFhlK1R5cUljNnZsWEZ2a05wR1A4?=
 =?utf-8?B?RkY0UDcrV3lUSzR6TXJjdnNkQ2VENHU3NmZUNkx0aWxzdW16eVo5L1NkV1h4?=
 =?utf-8?B?ZUg2RjhXWXdndWlqNlNJaXhLbDY2L0xmTGQvZU9mZHYrN1lqUEFEOGxrR01M?=
 =?utf-8?B?V2NIWmNJTU1qOUpsUk9kVHRyVXlHbEhYZDMrTCs0bFppaGN1WTdvTjBzTXJR?=
 =?utf-8?B?dkIyYVdrdGRueTYrSS9zQ1VtcnJRUXZDbVJheHJzU0theXNUR1pPbk1JMWlS?=
 =?utf-8?B?ODBIRFJ6RkdDYVM2QlFoN1ZkdTBiQldydFRrVFhGNW5QSVpJUi9Rd01MdG95?=
 =?utf-8?B?YlJZQTdhR05MU21JeW9vaTljWWlCWDUwVVB0U1pRbllmYVNYVXRQUVY1Zkdt?=
 =?utf-8?B?T3oyOXNwVmJiRy9mVk56MENnSnZCbE9NbjJtd2FCOFllNnJ0UmFFMDBJdlp3?=
 =?utf-8?B?b0ZieHYzajlZQnFMMXpLcUtSZHc4OFJOTWhLcHRGWFN1TVNiaUZGYnZxNzdw?=
 =?utf-8?B?U2ovS0xWRzZ0N2U1OTNJV2gzOFZqaXRVUkhhVncvNUVGYy9LcnIvVlFLUjdS?=
 =?utf-8?B?S2Z3RDBCN0dSejRoTzBraWVPYVV5TzFjcDg0NHFwQXFncEFuaHpzajgzSVFF?=
 =?utf-8?B?TXJKa2k3bWEvcTNGWXJOQS9TaGRBa2lOQXVRVHF0TnVwTDlXU2RmalFzUko1?=
 =?utf-8?B?dE9RUG8vU0t1RDNQV1lUSnllMGJUQTZRaVFuc0RaY0hmRlZLeUpoMUFrbFBy?=
 =?utf-8?B?NzZ5NzRLOXkyOXBvYkllNU14dFk0QTVKUGFvUGZMMnBLWlBDQ2RQY1BjQzB5?=
 =?utf-8?Q?32XwADfrlH1DX+bhrjD0QdUoVSaw/ysggHebs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ab4f53-31c0-4839-f91a-08da16843b20
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 21:44:01.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qY54XWG3fTAkBN+mfKvLK+oWFmclRvxZXM4x3BtaCucYcAQ52SXtOfSXLSMWNz9yL9Ci6zdG/kszQC9pb9YI3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4306
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-04_09:2022-03-30,2022-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040122
X-Proofpoint-ORIG-GUID: UCPztk2ztLAVTNvehkpDaRJo8TJdOkVI
X-Proofpoint-GUID: UCPztk2ztLAVTNvehkpDaRJo8TJdOkVI
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLACK autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---1463809791-294283372-1649108640=:6114
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 4 Apr 2022, Ilya Leoshkevich wrote:

> On Sun, 2022-04-03 at 21:46 -0700, Andrii Nakryiko wrote:
> > On Sun, Apr 3, 2022 at 6:14 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > > 
> > > On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire
> > > <alan.maguire@oracle.com> wrote:
> > > > 
> > > > Now that u[ret]probes can use name-based specification, it makes
> > > > sense to add support for auto-attach based on SEC() definition.
> > > > The format proposed is
> > > > 
> > > >        
> > > > SEC("u[ret]probe/binary:[raw_offset|[function_name[+offset]]")
> > > > 
> > > > For example, to trace malloc() in libc:
> > > > 
> > > >         SEC("uprobe/libc.so.6:malloc")
> > > > 
> > > > ...or to trace function foo2 in /usr/bin/foo:
> > > > 
> > > >         SEC("uprobe//usr/bin/foo:foo2")
> > > > 
> > > > Auto-attach is done for all tasks (pid -1).  prog can be an
> > > > absolute
> > > > path or simply a program/library name; in the latter case, we use
> > > > PATH/LD_LIBRARY_PATH to resolve the full path, falling back to
> > > > standard locations (/usr/bin:/usr/sbin or /usr/lib64:/usr/lib) if
> > > > the file is not found via environment-variable specified
> > > > locations.
> > > > 
> > > > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 74
> > > > ++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  1 file changed, 72 insertions(+), 2 deletions(-)
> > > > 
> > > 
> > > [...]
> > > 
> > > > +static int attach_uprobe(const struct bpf_program *prog, long
> > > > cookie, struct bpf_link **link)
> > > > +{
> > > > +       DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts);
> > > > +       char *func, *probe_name, *func_end;
> > > > +       char *func_name, binary_path[512];
> > > > +       unsigned long long raw_offset;
> > > > +       size_t offset = 0;
> > > > +       int n;
> > > > +
> > > > +       *link = NULL;
> > > > +
> > > > +       opts.retprobe = str_has_pfx(prog->sec_name,
> > > > "uretprobe/");
> > > > +       if (opts.retprobe)
> > > > +               probe_name = prog->sec_name +
> > > > sizeof("uretprobe/") - 1;
> > > > +       else
> > > > +               probe_name = prog->sec_name + sizeof("uprobe/") -
> > > > 1;
> > > 
> > > I think this will mishandle SEC("uretprobe"), let's fix this in a
> > > follow up (and see a note about uretprobe selftests)
> > 
> > So I actually fixed it up a little bit to avoid test failure on s390x
> > arch. But now it's a different problem, complaining about not being

Thanks for doing all the fix-ups Andrii, and to Ilya for the Debian/s390 
and selftests fixups!

> > able to resolve libc.so.6. CC'ing Ilya, but I was wondering if it's
> > better to use more generic "libc.so" instead of "libc.so.6"? Have you
> > tried that?
> 

I looked at that, and unfortunately it's tricky because on some platforms
libc.so is a text GNU ld config file - here's what it looks like on my 
system:

$ cat /usr/lib64/libc.so
/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf64-x86-64)
GROUP ( /lib64/libc.so.6 /usr/lib64/libc_nonshared.a  AS_NEEDED ( 
/lib64/ld-linux-x86-64.so.2 ) )

I tried the dlopen()/dlinfo() trick with libc.so, thinking we might be 
able to tap into native linking mechanisms such that it would parse 
that file, but it doesn't work for dlopen()ing libc.so unfortunately; 
it needed the .6 suffix.
 
> I believe it's a Debian-specific issue (our s390x CI image is Debian).
> libc is still called libc.so.6, but it's located in
> /lib/s390x-linux-gnu.
> This must also be an issue on Intel and other architectures.
> I'll send a patch.
> 

Thanks!
---1463809791-294283372-1649108640=:6114--
