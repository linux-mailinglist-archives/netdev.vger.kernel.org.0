Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BF73A4BE2
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 03:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhFLBQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 21:16:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11992 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229622AbhFLBQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 21:16:05 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 15C17Zwd005720;
        Fri, 11 Jun 2021 18:13:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EuM5JbqlBn2hj7xEa+oAB0sqMMWU4iS01a6/vQrv+ZM=;
 b=JCN7GvJvIrzOXxZr3vT2aH52plLfW5SLYDjC3xXW7mjvuvt/G1DDSI4cL4dsPqzY/6w7
 fCi2GMRAWkCBypv6+QhTLJXGC5Xgun77MZUzYS8Q9YGf3I0lnPdhDzR3bgsDTGo42bCG
 p+7IU9PAx63Z00cHUgg6bluXFjPeEFGNRbY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 393skjrckb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Jun 2021 18:13:48 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 18:13:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsZvAaMi/qOukq0dbd14KpajpM76CQvmfsRkj+olh2Q8UPIsZrpCkyw1ckAuVB89J3C9VfJWhiCzO5xM8Sj0VFtLwu6aisJC4VA+S0naT8GMPi3JhpFstlB/2I5My81ZRjsyjnYSshfYaogav5rxy7d5DGez8Z6IiXNTzcUjt2Vv7aSMGQWPgBNZ1ry6nwiIMP8hMCbWlV9c9cUdFCHnqjlIj6HxJLsEAm+SibBJGIg55HkAmr7MThG3SISrtgcWYm27+t9LfEK6vPkpEnE4+L/o5tC24I8126yTWV9ufWGFGb8EGzvnPousZ/KUC7Ds3xzxaHb4VhLroGlIqv3L9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuM5JbqlBn2hj7xEa+oAB0sqMMWU4iS01a6/vQrv+ZM=;
 b=TswEck79jnu38AfFvdy5qQoM30723Ut3D8jK7RVD7ALjMIYkU0ipjL8NOHB3JMNdhQYFt7wmrT0Z7OpL2E1OjmmEbw+hVGHY445TxDC3gbnv/SHamFdatjt1qnugMxPk/tJWGU5P2dMYip+giIAXFOyOzsf1kIxuSk9l7L4272c8eztPYAs0vKJTK2PkGyWu3TXULzZSgo+C/qqqA4KP/RN2HX7tnsW4uW4UfJhMF1PAOuDQpaVp+9GI8pqwMKlCa2ruXr3cwuEXjMbBbQ2fZWlUBTVLZ0GtN2Zu4FKz/Jpu0kOkGRafgW2ab75rCUz5izmPLCzeP9CNYklHlHPduA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by MWHPR15MB1327.namprd15.prod.outlook.com (2603:10b6:320:24::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Sat, 12 Jun
 2021 01:13:44 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9136:4222:44f7:954b]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9136:4222:44f7:954b%5]) with mapi id 15.20.4219.022; Sat, 12 Jun 2021
 01:13:44 +0000
Date:   Fri, 11 Jun 2021 18:13:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Tanner Love <tannerlove@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next v5 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210612011342.2aywi36zfe6a5qh5@kafai-mbp.dhcp.thefacebook.com>
References: <20210610183853.3530712-1-tannerlove.kernel@gmail.com>
 <20210610183853.3530712-2-tannerlove.kernel@gmail.com>
 <20210611064912.76eoangg4xgyb3v5@kafai-mbp.dhcp.thefacebook.com>
 <CAHrNZNgDfpWEdVK19cZ5CLK5T3RbKQSWPVx20e5S-_+zGJ7n=w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHrNZNgDfpWEdVK19cZ5CLK5T3RbKQSWPVx20e5S-_+zGJ7n=w@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1216]
X-ClientProxiedBy: BY3PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:217::35) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1216) by BY3PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:217::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Sat, 12 Jun 2021 01:13:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1b0a1ce-01a5-422e-c5d5-08d92d3f52bf
X-MS-TrafficTypeDiagnostic: MWHPR15MB1327:
X-Microsoft-Antispam-PRVS: <MWHPR15MB1327F2210F433BD7FAB72B90D5339@MWHPR15MB1327.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mFu6WAJr8qh7yJ0oGkG6Av9bOsxbZg9+MkzNXCJexxjd06OQEBsFkiIM7Pi05DBET63YQGiPN6p2wqzmAxxBFMwhfwTg/GgkDdzrXKKkTmFYOa3KJvzVN8dWL9PuCfXSuwwED3bYzYj70T0QfiKQHpMU7QjP/5Uf7PxhQJQ8yMnRmhISoxeiFbQ/Zjx7GUnjAkDFAmAfO/Wm9O1S+R+GBYtHUAkQn68iJMhz8FaE2VbKrGGdnUM1Z8+GwPjqgGDnfHZOUPPGI0zbZrUn/l0M/usktMfKPaJzBcpdAU+NAboYBnwzH4cyGlXaDRA/1I8cncJwsXFeO2PyPinS7hea61vmwjIEy3WvDkDdhrMm52k26j4QERTGAFl11Y0vyKpGnh6COmmeXIKCCg4PIYQxtiYBg2dH9eGmnWUgh+gj4mjfIaA4kuQetckj27d8fbwFCThyHS76MBMk874U8MGCLa3qSEVijnEsWGFAVbqoYAr1PRHduDIq8kwY9KGoNGjlLrs61Mp0QaH82C9hF0dJUFo9vPZWQb5zGKkXAyWziGhNwKmKiBs7Nst9J5FiTv+rP6yywcItoc5lN2J1GNwAfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(4326008)(83380400001)(8936002)(38100700002)(9686003)(5660300002)(6916009)(55016002)(1076003)(7416002)(66556008)(6506007)(66476007)(8676002)(16526019)(186003)(2906002)(54906003)(478600001)(66946007)(52116002)(86362001)(7696005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lS/mEmIOy5mzyjNG9qahVxV6ZAcMDWgEeaBSeZo6gs34qmxF4vYx1uOukMhB?=
 =?us-ascii?Q?jPJ2F+gzarOWn7etdf57RhgmeEG0+y73c6adkMnvOb4DhwXU+Ucs7Fa8orhm?=
 =?us-ascii?Q?kvWzwdUBEATXFCePYKh9HZ6lDyE5kAgxGSpskYrc5OKQCXX7t2T+rPq1SiS+?=
 =?us-ascii?Q?YlR8f3RMB51mTxWQR8a0AutCNJLJULoOS8siiKb/OuOwUK+Kff+wTaBDoecM?=
 =?us-ascii?Q?1fqSgBsmX1sQJT6cmp0n49mMR+tYz1fdmYPD7s2IfMQxSoV9UsKTUt2fcPd0?=
 =?us-ascii?Q?azDlK4Xno0HlUB3dh8OPJThLXbgzw366xpHs+QmnzzyMvt0mw6H0kDGH8Zvp?=
 =?us-ascii?Q?2mB3e0P9XpNhCTul/iZYgIfA7J/RHpzYb5VTKUZ6XTudEijExpgxhMmeBKLk?=
 =?us-ascii?Q?m97YsHz2W7E5aFMJoKOOt1ZxpO1qRnvfJ4NOuie/YAqWh5RO+FdvSiUkb9+X?=
 =?us-ascii?Q?crN42F50Yfe5/e41MM19SRA/OQ3yono+mXej3qjEQ431M6PPMh+oR8wmnByr?=
 =?us-ascii?Q?X+jK/coq2x40xPW8jULWnUldwh5mxRV0aMUWtaLZaVbDPNnPKi7Jpni9xlku?=
 =?us-ascii?Q?G7ZdlAYQ1LpUNLXj3h6kA3A0C4sKezSY+Eaf8cT7+B6P5aH4+pc9tf5DDg+T?=
 =?us-ascii?Q?sq4qj9BesUJkdZ+TeyQFLYFZLG7LMdt1zG/REiUoaT2+2I+yvYAG9M05kQHc?=
 =?us-ascii?Q?6WsSuoNnF5v7wC52IPTPx8FL7knD4T34xKCtKZu3VNuJTvdeH/wKwhPwXkJT?=
 =?us-ascii?Q?zFKs7+Jb1AtOPuRPMqMJhs0imd/Spwfy54htw3FP/DOXcGNgC+gDPK7d1fCT?=
 =?us-ascii?Q?4quFQc7Q9P7OwtH3wYG0RrF+9KAmwHZvFwZITiQDTYBI53UR6TOllmSYK0hQ?=
 =?us-ascii?Q?DUadDwHO88pI7GOJuC/kdZiTfXbcr8VP0ebDRC16087TPFxpeZSEp9I2P52h?=
 =?us-ascii?Q?ZVgSH4LgB+OoVVUueCQN9lSNEbeEXzq/rvcCK5hVZj36W1xoPBGzviIMzuv/?=
 =?us-ascii?Q?MuBohI8JpK5DbvG7uyYo/bAoP/cFnMH09lt42/6OSeYwLeZeFKxv8Wm52lC5?=
 =?us-ascii?Q?767FGrWZtclmQ0JNXz/dUICPGowo9u6COW7OHbQyrdANWfXGqwaKYYmeJ/ge?=
 =?us-ascii?Q?7Hrzpk4JrZqkucE3f467DxP/B5t0q0m2rjWDzhuujpl2elZyGHWSdT9dKbbE?=
 =?us-ascii?Q?RaAskN+KYLD86Ar/FI3MnRnY6vgl0wAQzpLIBINjtEb5SqfJq5A7E4VNXsAC?=
 =?us-ascii?Q?d3kuJIgwUrjxfs7hPfirUpHH871rCTQoyLFC07RPGsV+Uv1EYFA2D7/+i5DT?=
 =?us-ascii?Q?97ObzYWfDzaxzZa9LwB0Vw66EpY9l2jRETIqQS6rUWnwNQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b0a1ce-01a5-422e-c5d5-08d92d3f52bf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2021 01:13:44.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fa2xL4ePIQhQcHI7tSn1QvteTFpjV9NpqkJoFWEkqqqrbm7yOn27rX+5AfsCbGhh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1327
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: YjX0W2wSMU34J4MJgR7U7-rUTWVjEbIU
X-Proofpoint-ORIG-GUID: YjX0W2wSMU34J4MJgR7U7-rUTWVjEbIU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_06:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106120007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:07:10PM -0700, Tanner Love wrote:
> > A nit. It is a good chance to move the new BTF_ID_LIST_SINGLE
> > and most of the check_flow_keys_access() to filter.c.
> > Take a look at check_sock_access().
> >
> 
> It's not clear to me why it's preferable to move most of the
> check_flow_keys_access() to filter.c. In particular, the part of
> your comment that I don't understand is the "most of" part. Why
> would we want to separate the flow-keys-access-checking logic
> into two separate functions? Thanks
Right, actually, the whole function can be moved.
I found it easier to follow from flow_dissector_is_valid_access()
to flow_keys's access check without jumping around between two
different files.

> 
> Additionally, it seems that we don't actually need the
> BTF_ID_LIST_SINGLE. Can we not, instead, set
> regs[value_regno].btf_id to
> btf_find_by_name_kind(btf_vmlinux, "virtio_net_hdr", BTF_KIND_STRUCT)
> ? (And we'll check that that value is not <= 0.)
BTF_ID_LIST_SINGLE is resolved during compilation.
btf_find_by_name_kind() will be repeatedly finding the btf_id during runtime.
It is not like a killer but still unnecessary.
