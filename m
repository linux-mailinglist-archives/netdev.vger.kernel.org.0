Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7AF588F83
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiHCPh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238019AbiHCPh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:37:57 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A7E167CC;
        Wed,  3 Aug 2022 08:37:56 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273EMPQ0008478;
        Wed, 3 Aug 2022 08:37:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tiGut+KgyhxM+gjga3MXQtsFww7wofyYzFuzJhNqPsY=;
 b=QPmcCxoijJ7QSSQnGCg5JInTemTLUIFoFIqtDNYOwf37OOx5+gywX4Tdjd1qbhnGfa3V
 ycMm7GM+44E1OT7tVgQoUofJFTtVYk6fJ5eMzBIzs2XiZjnmLKv7D56FtZdjfutcxMiK
 C9/mkuw8YhStYA1zgJgMbhGhTcch2If7rOo= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hqtqh8jpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 08:37:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyBsdjvSl1g/9MAtOTYOvRVgleFQi/gFo0tlaD/AT4lfftHZ1TjPGw/7zFaZVdzFip5qOi9r3HjYPMQwRPgJ1zt2yk6/MNhV5Vnbh1Yh2p7ZDUv6k/RCZLAdxM1mhGKeDAqOYNKE+Yh3si2Hsae26Kz7tzzF2Dx5A8HpUnjXjMIjAoRoyI4AZazk4Css+SN89DSosahU22Z+x1xgURkSuY8UuJVQBeOoFYRiSSRapec0wu7TWMSA21Ja9BTMQ3s5dwkeEXwhU5MJr+KaMtiQdv7633j2YvvuQkytuUlpH7pZLlhSEPP/6PdcK2Adq9qBlh+d7OCcDD7QNH0Vjs/Faw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiGut+KgyhxM+gjga3MXQtsFww7wofyYzFuzJhNqPsY=;
 b=Z7itrAxl9EGwnyv0sTIa3Yi6vb9g6RUtVcsp9huuLR8y0apkDG9laqFVswHOZQt1BS6rdHKS/jzhu1Xfg98FV9wi3K5ognf1Mo+FL/SkTuR2DkJfFI0lJge64HkRV2fDc9u983R0BCzhwNnyoc3kJhcPy68AthaYcHlx9+LkHCbSz+EjnvgtMHO39MqHQAjKhaRfENKpLimbzFjKKvDLD5JwquXoxjLC/CBRgDE4kB2rY9+vwxAYS5SVRGoavsIbSbbkXd9U1GcPn8q/TCZR9L1lzcwcBCT3jxY0f3r7HxI77Qn6OWUizeWjHX+WHnO9TjxjaVk0els/wEUQKH+iOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN7PR15MB2371.namprd15.prod.outlook.com (2603:10b6:406:8a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 15:37:09 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 15:37:09 +0000
Date:   Wed, 3 Aug 2022 08:37:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hawkins Jiawei <yin31149@gmail.com>,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kgraul@linux.ibm.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [PATCH v4] net: fix refcount bug in sk_psock_get (2)
Message-ID: <20220803153706.oo47lv3kvkpb7yem@kafai-mbp.dhcp.thefacebook.com>
References: <00000000000026328205e08cdbeb@google.com>
 <20220803124121.173303-1-yin31149@gmail.com>
 <20220803081413.3cc27002@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803081413.3cc27002@kernel.org>
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65e84283-4946-470c-8778-08da756606ca
X-MS-TrafficTypeDiagnostic: BN7PR15MB2371:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1pcsok/+/TPRcnY879ZfGrl/S8C0nTvvUNFsHJIeuiiM6ukfE+zaoHiJ+zhhhbs38dMj/WpcC+wA6+C+NK70RgESrhSDC9JKIJD0vtO9e5mb4uUmkE4stCca/4EhFw8+MSne/EWzb9ghDYpEvT55mmk0EdWgfYxrQ3hssTJW4KjBGzH04zfLjZpytmkAtN33axv4pFkJ8I2lJ/YP3VJkQuz9wAdIzxbEdNLaFnFkQHHBNUUyxeGpWCsIHbhJrYPQB7BUIaT9mKnUd822Xwk45yxLIaK1wHT/FnjHOleCSvX+ewxxNOMtw4wwl1Kd+ARpEHnmYFgu1jzwX8n0RClRLY14FMC9uFHRv4SDG4mKNBUu0KRWY7hJBdo7FOzPds9mg+qRXdHj9CqJ1lpMzl0H6tQdHB/KJZPFvMARaVhrO3Hzxmn5QE/4FjOdxTxbh9/+YUXvmWdFiNedGH+OsHa2YFbvQYXSxwuxQsrPlkqOkDlTFfYB7BiIX8upv/PnslX0TBpuDidGEMTvarHUGmZDUaCsXM90nLbwQiz2m6r3r84N6NJuOZQRwjN8/I1zz3ohZYPju4ze0k2yQ2NCOKJv3XOODwN+BnhyV3mEBWHrdBXfkUxyhuEZz8vjNzfQ7RTB3nKrqxz5puxrg/nkwC/769oswagyR5eLGuuwEJoxs3j/h7rkxs0QOiOPLRJGqb64SmV7uqYXXS397+OOB10KrMqsZyfGgVII7dker7uD5cBbI4fZ/6hnbXQw0kytNvC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(6512007)(9686003)(7416002)(38100700002)(2906002)(4744005)(41300700001)(66476007)(6666004)(4326008)(8676002)(66556008)(66946007)(52116002)(6506007)(1076003)(8936002)(6916009)(6486002)(54906003)(316002)(86362001)(186003)(478600001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kBjGcaZ0E33jyr8zGCmPwwM8jODcpJz5fRgte2D66EW/QtbTEzJWbxwqk2G7?=
 =?us-ascii?Q?sITuJ1xlhvMkoza5AYy35bCf6AmacD9k/VvoVAo13FY+CfaNWndXrsIZ/YL3?=
 =?us-ascii?Q?PlwvHoUAAvyGGAb2g8+ZzuqO+IK8u4hG4qAGnxogO3//hfD2AsGGYonhnPhd?=
 =?us-ascii?Q?XRNYyyAf3JRVeECD1+c7Xt3fcIK75lzEknSvMYzqDpPzdTOZATz9SB5yXNIn?=
 =?us-ascii?Q?d2GxVl3jPcHTO+CxI64oWa5O8e6HWo6sYnu08r+na5XctApDbMlYlIk+NPSd?=
 =?us-ascii?Q?h7Y3zLYmypAk1sm1rb7cvnDfLN5gygAxD0WrZR50ajKIDUwLcE6LbOeCKOzB?=
 =?us-ascii?Q?G7kC5IbtSkwxORvTjPJTFR8839PkcBtb1p6Q+0YXDKzfk5urel12vxjtfF/Z?=
 =?us-ascii?Q?tPIdqeVDQ7FnjdoqJQN8lA3Z+Vl9c4C2EQFN4pHj0h2j6vCnKKg0g1axNXQY?=
 =?us-ascii?Q?BachzY3Lh/D5q3ITL7+7HX5vDpbH9MnU+jMUwpKNUygG++tzFnl1CppbCgPv?=
 =?us-ascii?Q?J0BdQ3qQ9hdhUFtl9AawDgmVwaElucLWkb6TZ+ppESGLXqOR+voE3aUwbT/x?=
 =?us-ascii?Q?o2G25jRkxEkb5luH1ersJO45fc7JKBOxz2/HE+igKvi3nN8+DBQbkyMw2WS+?=
 =?us-ascii?Q?jLhdExgTknoezEIVBZcUahci+EoXJ7VjwDRzZTgOJQ3TvNeLQknXXqNuV/yp?=
 =?us-ascii?Q?J30zC+WmWLXtHqet4+Sm96zcjFynXQlrxqZHW/md69+kKqiWr6WnONWWNHYu?=
 =?us-ascii?Q?bzqK8HeGKmtjjKY2lSKZi5v1OC/2koO2ARF9D6iC7hN+qUZjTkt7PxvfaBMt?=
 =?us-ascii?Q?DrS86j8F1zMUvG7Wy9BGQ+B4mURMIzKmCcfjh+qdJ2SxQAIflIxvfpUDt6pb?=
 =?us-ascii?Q?Y2HD41uVAIISpOpBXF9f5N60DnwQ2dj4jOpIpMxTZviDPCWrta5tyEzBNX9x?=
 =?us-ascii?Q?ZVzjgh2VYmroSxvIyURj344LHE1a0qjOeKqijJKS3c3CQ0rLLfm4A+XSyQzv?=
 =?us-ascii?Q?Ge4UqoMggGSHc2CnfMxowqsUmT1/Ed+Z8AXPn7Ar7ZgmywD3flRYh4Abh52B?=
 =?us-ascii?Q?YNukprvjVd/0qN8iBtO1oTvw+bKaha5VNbEU30QQgSriPWWB7JtpLtMJ5GA6?=
 =?us-ascii?Q?uinh9Uu309rWG0BAdTKCM52nP/73zrdriNU0q+KIWjk2yDNgmaB071qQwzy1?=
 =?us-ascii?Q?ZDxB8pbEBzwlZ/sNinzyrA2MKt82fkHjZwgZiCrnbXc44xqgi08ao+v7w/pt?=
 =?us-ascii?Q?GcMstD5bBpqzeJ+QQQX71JXU6nIuXP3EClOvOVuz6qb0iKnTBNMQ6M+M4Blx?=
 =?us-ascii?Q?IH38bC8vpKwRSwbsZh6fSnBK4caz6iDcFE0/IzMHkmhpOuCKd2kGxXS57UX2?=
 =?us-ascii?Q?9HU8dZ6K63K4oWzU77HNkOLw+MNTe29XYXbbPRSNt8kDKs2A1teVFJtmwcN4?=
 =?us-ascii?Q?ikwJsnWsR8fs9t7xkqIXZzt964f028o6eJTBsQf/cpJR/wx1+rOXA/oBgi7y?=
 =?us-ascii?Q?fQxaZLTRh9tHtOOuHUGMPzKkaRVb7iC/MtchBN/cpO1vFiuEA1VPhrXy849w?=
 =?us-ascii?Q?ZsVzC1MG2Q060cWsOjcHUj+Zp1MljSTqjRjT3Bmeyc1r1bRQfEMxymoFRKo1?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e84283-4946-470c-8778-08da756606ca
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 15:37:09.0833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljPGSyUImIy4hvLvCEXHeHPVWFCx4DNC+s8daagzyMtSiOabs5biN3oehinBB2qI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2371
X-Proofpoint-GUID: Fn0e08rBnK0NF4kbhI77mmT8SdlxyMyp
X-Proofpoint-ORIG-GUID: Fn0e08rBnK0NF4kbhI77mmT8SdlxyMyp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 08:14:13AM -0700, Jakub Kicinski wrote:
> On Wed,  3 Aug 2022 20:41:22 +0800 Hawkins Jiawei wrote:
> > -/* Pointer stored in sk_user_data might not be suitable for copying
> > - * when cloning the socket. For instance, it can point to a reference
> > - * counted object. sk_user_data bottom bit is set if pointer must not
> > - * be copied.
> > +/* flag bits in sk_user_data
> > + *
> > + * SK_USER_DATA_NOCOPY - Pointer stored in sk_user_data might
> > + * not be suitable for copying when cloning the socket.
> > + * For instance, it can point to a reference counted object.
> > + * sk_user_data bottom bit is set if pointer must not be copied.
> > + *
> > + * SK_USER_DATA_BPF    - Managed by BPF
> 
> I'd use this opportunity to add more info here, BPF is too general.
> Maybe "Pointer is used by a BPF reuseport array"? Martin, WDYT?
SGTM.  Thanks.
