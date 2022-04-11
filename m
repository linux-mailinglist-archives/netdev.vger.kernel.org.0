Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F44FB589
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbiDKIDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241013AbiDKID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:03:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17491E0EE;
        Mon, 11 Apr 2022 01:01:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B7txMj029741;
        Mon, 11 Apr 2022 08:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dgQwB8ITEH8KBc6kUJd503AGy98s+k70euFz0og6QkU=;
 b=jsxga8v62gxW6tYmUOCVeu13Xr+I9eeMa13dY4A3bZhUWlcPLnpTLlPw8n0C1rezOdtA
 TQdRwBjW4DwgGMvGoKE92QWapWjgWyKqPS1Lk9YDyFoVVMp4gAwfdiGmL6AqCV/jZC4k
 coGN9QL1h2MM7wVWAc5hv0Oes5uH/A8EmsuFopqr8Q/cNycdhFq2vMQhoKgecgHK3W6I
 rr++0uWMb3i2VsLJNI2kPjY3GgU4qZumXp7OVx2nolDlhf96Gpo8gQ+pm/U9Z/ZycZ/s
 xjGdZmpVX1d8viUPSFpvpIg5oDlihrgxxNyMYFiuWb+4HH15QCzseS4LH1tkZNHpDczb fQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jd2qu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 08:00:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23B7lC66000821;
        Mon, 11 Apr 2022 07:56:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k1tmdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 07:56:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNZoI/564LoX7GDEGE/t2lDIiQmzoFAxDFY+/6HWkvjXiOSi1CYHZPsZ+wyqnDdxRS+G7xcGGcobrGO7/PRSTXaHT0a27UPMVqcBSy1VmQRq0Drin/t7sJl7l0qxjWW2Kp10fnlVEk0+8KxGsfllSNPenn59mKKwkgQV+65NNgzIT8mRF5D8oNRF3mStk9D9Ah4HJFxxF/nP+BHLq8bZyKYbgRQmlzkpBwtCSPglVFqC2H2VuAfSEtSKbKOTASXfNtM88LWCpz9StGbUyyyBCNpLgxCpakuK7N9/ny1D4VGDX4CsgHcJ9KYHemF9GKp6nP9N+30CSLk/9Nf+DLRsig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgQwB8ITEH8KBc6kUJd503AGy98s+k70euFz0og6QkU=;
 b=NooQpt3s4RWXUPzT/7og2Dym7elOzQzdJmvVhB7tmuu2bpScmnfR9gaAybb2jc5v2Hm1dPDas+TDTe2jnOUvTGupapJururrFcdocSObDOnIUz0+9JMWBAE44CFx5vHavjEqsd8azRUNuwnfbm4lR8pixLsFU8d1iMri2+Hdf1rNZ5XScX/0aTd40Os8zGhYnSxZnVf2gR3vNIdyt7YNVgHyUm8nN6uWJLjtCqmBnx6loKO3d7WN5Fujp+YFEhMzgEW5BfG69Mu5K/dEihSvAvR9+75ps4hCuuxJlnCe5wZrqaJNMEI40JST4UomN1x44hUzeUdfV8rbRcezcYt9Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgQwB8ITEH8KBc6kUJd503AGy98s+k70euFz0og6QkU=;
 b=XOZPfyZRVaz3j4a8FT+Si9xz67AN/hh1ZG3Sw+pc3PeuhYzoskzHcdpuL1yn3i1wlE60B0cjPK/4QVNmhANn9wOFIOC6WBUkhXTlAqZd/R5b/Sh7wLCgrAaDdnyYEixBl7Lui6g84bRYCMSmt6hweXN6RHWKofSo+Yfr8sC6VBk=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SA1PR10MB5781.namprd10.prod.outlook.com (2603:10b6:806:23e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 07:56:56 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 07:56:56 +0000
Date:   Mon, 11 Apr 2022 08:56:45 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] libbpf: usdt aarch64 arg parsing support
In-Reply-To: <CAEf4BzYVGOnLksE+UXoqUr5tgvd9gXthSzkWX7jqEgJ+oib1GA@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2204110852390.15583@MyRouter>
References: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com> <1649458366-25288-3-git-send-email-alan.maguire@oracle.com> <CAEf4BzYVGOnLksE+UXoqUr5tgvd9gXthSzkWX7jqEgJ+oib1GA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO4P123CA0268.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::21) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ff84d8-7412-40e0-4487-08da1b90d961
X-MS-TrafficTypeDiagnostic: SA1PR10MB5781:EE_
X-Microsoft-Antispam-PRVS: <SA1PR10MB57815D74B6706A8001790626EFEA9@SA1PR10MB5781.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 90q3W2muWd9lpccpVFayCKh08Lr8JcDYdoaEMLKJ9Ats+s+M4oz2YamTYDpwflsGSFwHkMuxR7Hz5j3/N0Kq+euc+9pdketWfinS4NpLK0tEHTHeapHQx20m1OLCt6C8eXIK4lZxT/RpQnzkQJ1KiaFpyB3LBKLV6jLlN9oYGDY7MNj6hQOz4TXekpMsSFsPzqfWZLqVumz6couUju2DUeX8Y1SkTjQBE9ptiYNUmg62ygjS3iuPsew7+KaEp+qr689A589E+UqGaQC1Fr96K9Re2NJ0rz2GqwlBcBQ9gQ3Qfnu2yIIBd44DCQB9sehAeIIad2hdXRjJRQD2/THQQ/IUsZGRAk8ZZzJeXyhLpehjDkdzY2NUH04alBXKQ7FnOZoA0Gd3I54hhkVyI/lgGJbg4oxdFFDARYEGbtgebPNnBzjXu29rRJBn4IZyb8MhdE+h582sQgAGmzLH3SxPDDkyK5oinIsmjIFXDbAVtiU4FPureNdoHZnDhSnuEMmskIph8XwHRoADqS2Ys54L4DLuv6uZIW2Ftd5E076pksQV0CQnkXMq5RYwPJRDkTJRUq1RKfYWNcEWMVSIMkVlXXt58aaFSkrWGt2WxzE6E8FG4+iRVKxAUa7KnhxompeJVDBjCjvtxBp4Cdu5BVKq3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(6486002)(66476007)(8676002)(4326008)(186003)(44832011)(7416002)(66946007)(33716001)(6666004)(9686003)(6506007)(8936002)(508600001)(5660300002)(83380400001)(86362001)(6916009)(316002)(6512007)(38100700002)(53546011)(52116002)(2906002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JD5kxiBSol4MJZhzo6cQTNAv2itoXFggrD53/lafVh1jcRFEKTCfVhRv3hLJ?=
 =?us-ascii?Q?x8iMxg7KZYo/65li95YOgZ14jWgJo5ZdKp+MIVWHk3kPNu4y6a3WC6qgJIkB?=
 =?us-ascii?Q?rmzFvOirK90lb107Eh4hJv1qG9MFWjtvKrw3+PW0JEXBI/p9civSD74aR8i2?=
 =?us-ascii?Q?6TdLF2vr/h1AEMuGuZMy9kUf2H2Isb+6Zb+b0QyVKCXogc/RWojDmM4gAJHp?=
 =?us-ascii?Q?sgemIx0QT0KNyNN8K6bIiQajvBiskCoscqggUN3ShowcymhQAhFX/12njabS?=
 =?us-ascii?Q?cNh40bC88PKpd3qQM+pH+eCXQYrF+Uflm6T2G7U5OrabnGCMXs0dV29+HUQ/?=
 =?us-ascii?Q?PBdne5SN8s/eYBHzWV4pPSxZK5XaqK3kHtHZMqCDHTpw1K/RAWWnc2JNi4aE?=
 =?us-ascii?Q?kkDC78Ji3vi91FHfag4Ob55foKRj3i97C6CDAKw3UJ4nStpgiSVywshodJwv?=
 =?us-ascii?Q?cEZuyHZvHMXrVpIgRaOva8fywLR92jzTz369KH2DbL62erkXsEuwMBAtxRS8?=
 =?us-ascii?Q?Yj+Kk3i6CKHDexcyQjdrCAhYuuoOoI6EBOZvk7VkDXxMjAJCX+AaBV5KSAKn?=
 =?us-ascii?Q?H4TUzg3lPw43QLi9xq2H6s/2gcd3lhn1TIuG0+DtNqkWozDssp44OJKlvYfQ?=
 =?us-ascii?Q?IPXdIfa1QtNxOHRwjlLpZIHLWhUqzDoATKrPNwIQlJWWY+YowTyTwnZ2xko6?=
 =?us-ascii?Q?w0FqRowboocnhJOqsyZ5JqocJ2efI3vx7AGnK7EKWZ1T/gW/rrKOx6kqTamc?=
 =?us-ascii?Q?e4S/YCSj9WEh3AtYJWvH1SUIQdXL7SUoe/JrADvVmDiO9bzaI1OiVop/EdvH?=
 =?us-ascii?Q?9Ql3CbB0NhQWr6cNq/Fi/Fk6T7Fb09EqQYBAW2R2bcZp27MblHMMY8cUdOAE?=
 =?us-ascii?Q?8aAxX3R/YERRPmCIvV+Cc7bSy9J/CibSndKVPE+zDvKp9Tco+mtpNKBaoOLq?=
 =?us-ascii?Q?56cnfpHIaY9q3bbLn4zc9AhVFubRjlQHpd/aenhyDm8hMnoKcBecj9WuU1kn?=
 =?us-ascii?Q?mWC3YwfYvpkgiK/RCt1y1EmLiDcVSJhR0IJZDicOEn5AcBJtvn3nay91XtEI?=
 =?us-ascii?Q?lAUNjW2Ie20666sWquRWdKXACA0/0K2Alprojw2jquh/YkjU+jwl2eQCbuGd?=
 =?us-ascii?Q?3p3/PLrgJca7joBFwmWBkwdlgndgbt0zVQB4Iu/o7QA+5S7qvDWMvssTDh6E?=
 =?us-ascii?Q?GpLO4m8xh3j1LeVTxsFxzzeauDlf8FFU+455k56sKlk2BWkZH9MtjNZwesDS?=
 =?us-ascii?Q?8YrXzmR83JWipQ169Em/xkmLjBf1G5Uci5ec0HbbH4NiVD3oqITQp4ocEnNg?=
 =?us-ascii?Q?F1YifmD4H7UU6QaooB/dCzNR72kSrB7cf9TWtTaKh+yv6wyiQ055ptZCKDCY?=
 =?us-ascii?Q?wXj2JdW7Mw0As9xkEBZqKqiQv8ilzBhKnVWa2yH6gc3eGDrpg6U+a8MnZUno?=
 =?us-ascii?Q?k8eLpB8iCcFB7WcbOYvzdGEpjYTmGJqkjoVPSY78Kjzpmb7CLO1q6rslIbkr?=
 =?us-ascii?Q?7dYPmJ09p84XB4y+sj24L0rbYQlKVZc0A0+f5pE3Aq2DLmH4R+2dMv3eNmvZ?=
 =?us-ascii?Q?KfPAE34FG+JH56OqwU1mp/X+s2VfrwN/X5SJHE0Ea3yAj30g/xCydb48bgOS?=
 =?us-ascii?Q?7dUVMyYsZDx/DOF2wfLxhMB4hmkvIenuW48DEY7t72ty9EC8p38jiYbCDw9m?=
 =?us-ascii?Q?84m7MTu+BdG6VslVYkeBzE02zPATAzwtPnzL+fi5TT7X5cqWcV3t3S1n/4MM?=
 =?us-ascii?Q?qXhiRMiVDt3H2o8PW+oKD7D0ZXZqjlyLh+vrRMn8beVMJ3LV7i6s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ff84d8-7412-40e0-4487-08da1b90d961
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 07:56:56.4804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgauPl8J3+BKyBzmYDttlI47WO6nLEjNX42o/YD9I9klS+AE2tTIHilYBWP2kywKQS5Y84V1E8NfAiruYkzp6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5781
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_02:2022-04-08,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110043
X-Proofpoint-ORIG-GUID: 75fRfA-mj_Z7bTYMBiRqvMPopYTIXU3M
X-Proofpoint-GUID: 75fRfA-mj_Z7bTYMBiRqvMPopYTIXU3M
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022, Andrii Nakryiko wrote:

> On Fri, Apr 8, 2022 at 3:53 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > Parsing of USDT arguments is architecture-specific; on aarch64 it is
> > relatively easy since registers used are x[0-31], sp.  Format is
> > slightly different compared to x86_64; forms are
> >
> > - "size @ [ reg[,offset] ]" for dereferences, for example
> >   "-8 @ [ sp, 76 ]" ; " -4 @ [ sp ]"
> > - "size @ reg" for register values; for example
> >   "-4@x0"
> > - "size @ value" for raw values; for example
> >   "-8@1"
> >
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> >  tools/lib/bpf/usdt.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 49 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
> > index 0677bbd..6165d40 100644
> > --- a/tools/lib/bpf/usdt.c
> > +++ b/tools/lib/bpf/usdt.c
> > @@ -1170,7 +1170,7 @@ static int parse_usdt_spec(struct usdt_spec *spec, const struct usdt_note *note,
> >
> >  /* Architecture-specific logic for parsing USDT argument location specs */
> >
> > -#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__)
> > +#if defined(__x86_64__) || defined(__i386__) || defined(__s390x__) || defined(__aarch64__)
> >
> >  static int init_usdt_arg_spec(struct usdt_arg_spec *arg, enum usdt_arg_type arg_type, int arg_sz,
> >                               __u64 val_off, int reg_off)
> > @@ -1316,6 +1316,54 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
> >         return len;
> >  }
> >
> > +#elif defined(__aarch64__)
> > +
> > +static int calc_pt_regs_off(const char *reg_name)
> > +{
> > +       int reg_num;
> > +
> > +       if (sscanf(reg_name, "x%d", &reg_num) == 1) {
> > +               if (reg_num >= 0 && reg_num < 31)
> > +                       return offsetof(struct user_pt_regs, regs[reg_num]);
> > +       } else if (strcmp(reg_name, "sp") == 0) {
> > +               return offsetof(struct user_pt_regs, sp);
> > +       }
> > +       pr_warn("usdt: unrecognized register '%s'\n", reg_name);
> > +       return -ENOENT;
> > +}
> > +
> > +static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
> > +{
> > +       char *reg_name = NULL;
> > +       int arg_sz, len, ret;
> > +       long off = 0;
> > +
> > +       if (sscanf(arg_str, " %d @ \[ %m[^,], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3 ||
> > +           sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
> 
> I'm not sure about the behavior here w.r.t. reg_name and memory
> allocation. What if first sscanf() matches reg_name but fails at %ld,
> will reg_name be allocated and then second sscanf() will reallocate
> (and thus we'll have a memory leak).
> 
> We might have similar problems in other implementations, actually...
> 
> Either way, came here to ask to split two sscanfs into two separate
> branches, so that we have a clear linear pattern. One sscanf, handle
> it if successful, otherwise move on to next case.
> 

good point; I'll separate the sscanfs into branches for v2.

> Also a question about [a-z0-9] for register in one case and [^,] in
> another. Should the first one be [a-z0-9] as well?
>

probably no harm, yep.

I'll drop the refactoring patch too; I was a bit worried I'd break
Ilya's s390 code anyhow. 

Thanks!

Alan
