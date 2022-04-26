Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E40050F0FB
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245211AbiDZGd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245396AbiDZGdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:33:53 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0C012C6A5;
        Mon, 25 Apr 2022 23:30:45 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q1Nh94018247;
        Mon, 25 Apr 2022 23:30:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0dVHx/Mlj/Pw+KMEZsIA3c0XxEMUeQhjq2B/957aboQ=;
 b=DVio0yEZHauTeo+/y+6rlPjTsKiVVOZ5B8ZFo+ZHHeszRaBIWWw0sPv7AC4jM8ySwqLo
 bZraUBLX8WEMis8rPjp+BmGxzNvvFuw5RnrD6H9psUH/kWMh0nwp305wEnj4AsBP4hzL
 pACtlFYlbsmGhXEqcNnNtzSCc8ns/yMWUBQ= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp6a8996p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 23:30:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyvbU2VkWXOsCrMRfflrpM/LC3SUZFKqTbsP5/QU8HhqrawBtFOTAXVK3Qi1WZTkFJY3ncHuhtPq6YAlumzY68HZ4i/8PlYVrRaDeNGTQm+kKVmdxHctsUFwfgjY0Hwo+yJdKJU6HQxXu6FhUpjLEEOwolGkbPphriqrf754InSq9ZMdkWy2EjY0XsywMKy3lCO7IqW5+IPJ4e66Ehy8CTUhRxHUcG5FiWTLmxfLtsBInPEZry5JXfi2+0va3zANBNkkg+4OP54QbEe2cV4cXaTgb8LQGGuj8FJ0Ap7YPSYyTuc88lyhYEUx7o8NBK/C3xIsuw6R1ga1YyxXxdnNnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dVHx/Mlj/Pw+KMEZsIA3c0XxEMUeQhjq2B/957aboQ=;
 b=PoRDpKnAkEvYrVXypcF364K3rTUFIVTjewUjkTBKuolRFgLQSk9lbTwMMDsQGTJwkoRJrvSojPqTkw0Yyi4IHryHDAcOhyxbK5h6XxqnG/hofjbaTobr7JFqD1fx/iLEpYXax3SimRQDsYZxfZKiArqiZd/UwlQ+H6J6MOuq/L2lH1JrfzJbZXASXoXeaK3izru99RXgW+1fAqnaTV4DbSB49mITI1S5fn+daVhVyDvoW+Qq0Lp7wraiq3s3AqIx7apGsuO189F3TlQ2xGz6iRkYxKyTfv0LCpyk8+IOoZw2+oWuxsxXpWviaZ491fErghoT4Az+wyashT0B7FIoww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB4007.namprd15.prod.outlook.com (2603:10b6:5:2bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 06:30:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::100b:5604:7f1e:e983%5]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 06:30:28 +0000
Date:   Mon, 25 Apr 2022 23:30:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v5 3/8] bpf: per-cgroup lsm flavor
Message-ID: <20220426063024.4hkgajqzm6edf4u3@kafai-mbp.dhcp.thefacebook.com>
References: <20220419190053.3395240-1-sdf@google.com>
 <20220419190053.3395240-4-sdf@google.com>
 <20220426062705.siikmhdj5vhsffjq@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426062705.siikmhdj5vhsffjq@kafai-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11eab4e8-de61-4c7a-ad71-08da274e410e
X-MS-TrafficTypeDiagnostic: DM6PR15MB4007:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB400718E5AFC358F936568E91D5FB9@DM6PR15MB4007.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WU1PFjmea/anWN6PVCHvTRl6VosfDahS6NBASoDECdh3dQvu5LUTC1QebEl5ZnKKHuos2PG23rgFoVvvU4feXPZSIfmIL+OooNXSotW0p9DwSDZXDBmGYyxnPAq3OGhjiTF9wuQDvzkTX6W9LH1wH3c9koIR/xQoU/LH4QDUzKH+qMsG6W03GI8YfPv5ddZhkHuV2DXKV0Hy+pULQyoFTPbXWQ75aidW8487xDQITiTEmTtXtMMRnMg4Ze/NrIW6viiWNE7rxAqSB4UGC5fdosnLIzhkIGXyNXIErm+SVNcVbPGcGSfDlwjZMGA2SolFwsLflQbYBM8h4wqdyuRJ9eVOgG3iBc+6HYs5dUlGYZ7gMrsSIqL++VrFvaEgSLLuY8cuU2/Et9nU6/CYzJ2gw1H4o2z27qs096Xj1OgmPIIrfA5Lxy+FjI9Zz3v88/gjHAJExJvtCL9RTNdRp1hwlnTfimbIIFC3VwAx17k0ObMUQOk5LHJi99SzETmPIMiwCP/g70LUbnYG9Ix+z/+9mtA4uxIHCFuW3SeKelyov5B6/jmxrXGQni8ipFbhIf64uYx1kIIJKS7TbFEqiK0jvYJnHq8gWdnvoKYL3Idk8Y5gg6oFKES3Nht0SGToZqXyeL0F8n0TQRpzbAUIZc6Dag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(316002)(38100700002)(66556008)(86362001)(508600001)(52116002)(8676002)(6916009)(6512007)(9686003)(66946007)(6666004)(4326008)(8936002)(5660300002)(6506007)(66476007)(1076003)(2906002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WHO5sLMnlDYCymBFuYg9LaRPoShyGj48Py1SI/Tj1FscShIcRzT2sgTsNxP0?=
 =?us-ascii?Q?d2rYog2X8BvXdwxqhnfXJX7gK2stFvmUsBm2NmqjKjqm10hrLiYg1nLe8kfh?=
 =?us-ascii?Q?sg2Cd8UkMrBJZak+k9sjbCPJaa2bL6v55C9iBCDjKaie6DXhtMXnAVnjA8gQ?=
 =?us-ascii?Q?E9gL/Ef7ZmTu2fkp4Ce7koconlx4bzTgz6sjmJvg4oIDFhedlGPd7hCfoG/3?=
 =?us-ascii?Q?p2lyLMN6Op0LCWa2uEWfB9ASMNS8gAUGgXgahw6rOwGurJ5Mzw/FFzbxCYI7?=
 =?us-ascii?Q?WmobwxR4Sp0wlfKGy4d1gic8kJ2oJeeii8HWuYwqmKx7BaOhCVthdR7tweWh?=
 =?us-ascii?Q?ZHUfj71MSExajC3KRN5dpmq4xc2AV6fSVQSXGWDJx0K5G1l9ZJwpZgKPexOD?=
 =?us-ascii?Q?UF0NrUOUjHa54x7hlu0Gmcl3Fium8gHGwFgIHRkNWOslFNThyxik55O76yoX?=
 =?us-ascii?Q?o11J2V9dKEr2zZq3tg1Nt8hfHjOTqiLgmxaVOsNU928+eBavM8JaVnNP/Rpi?=
 =?us-ascii?Q?KVLNKd4yM7h3b+w6uuTQy9o8vfWBbtgtxdqXfwsbuYBxqTArXTO7iGGgjpAY?=
 =?us-ascii?Q?EFk0u9m3CLZGm4SAHszNGwW4hXa3p3jZ3aeFoR0TEFunDDhTeNPm3drWNEkQ?=
 =?us-ascii?Q?gRBMP2e7aDscvI49M/vWGJCmCxElF90GaCwu/CuvV1q3Ccs2TVBVamOyKUdT?=
 =?us-ascii?Q?LOuJWGsbjq5e+4uNwwwkFrN8C0hiYoi4+VWFCQGNWqKc8ueKUTQEzwxun+Ri?=
 =?us-ascii?Q?6nntYhQurSyq+4OPQhCF8uY/hULybR72j7PrcL1zbm2zkW9oqFflIXZJZq2m?=
 =?us-ascii?Q?CgU/t6z8dujeKW9KISxEdbH0fkkV9q4oSgTBOIxVS0VC/Sjvu85r398kjnZX?=
 =?us-ascii?Q?VlsjhWb0YX5O5dV0VXd1O+XkSP0pZjbJk0VLSYuNrLvJeRaddFjCeH8X1n+Z?=
 =?us-ascii?Q?53EkuJLyFO0PgRCewe/mM/g4q/UdxuhioQYK2+tiN79Sfl+xlFqocVkF16Ap?=
 =?us-ascii?Q?80Tl26RS+cl8wroFMfLHg249j3RCTzqpvFsUpQ9znA9+F26XwOJ96YQnGkKf?=
 =?us-ascii?Q?y7chG4gl7fzyaI0fvKFisDG1XCIGk3ss1li1EPFirXwcgIHMTmczUslTD3nG?=
 =?us-ascii?Q?W9Zi/MTNp6VzO3Bcm9NGaTD8lSNI2eD/5Yv4JirX2IINOPzFvyw4HhKWx/vo?=
 =?us-ascii?Q?Ta9lqz7PslwbCwoxBb0mTOLcYfFtRlFKmY25KCmRcQ2DiTTd3Xye3Jj6fkOu?=
 =?us-ascii?Q?d7sb0pWN0+zSfn/jXicZCWNuulqfFYYDF5YXTieUwmV38pluMs+MNT5FbO+r?=
 =?us-ascii?Q?WsCD0Z4O9sK8eZqBxR52rVeBZkpRyCAkMdvp+pzUhRRSUvJtQKUl73fo+liK?=
 =?us-ascii?Q?nJXYAu9NM4MksGGowaT3M4eME+8PfLDfT4OHTlAnhBcpKJ1wQ9lOwhG4OFL/?=
 =?us-ascii?Q?rS2xHs/g1MZuuENQM2AT60kZitClVtYHPRaGB0NcUF3ADxbxm68gSX76cuga?=
 =?us-ascii?Q?tzXPUGj+t7Bhwg9cDalsvA6pjeq12/GwJ8gzPmQtPqmwElPdTAZyx6+dURfa?=
 =?us-ascii?Q?WE+XY9C2LB+Wge76Eov0oR4Xzla+Th0OsG/hRFl/4nBJWhjBc8Re61/e0Rly?=
 =?us-ascii?Q?/qYaH+US/h7wreOPlq4gBPM0vBnbDE6EoZg5Holrw/C87QtFL9i0S8Yz3wYf?=
 =?us-ascii?Q?GG24/rFLLI7QyuCo1VvcIYDfHQjUrbC2tdDqgbGAKDDsaiBTxGsw5hpt9bsi?=
 =?us-ascii?Q?5hjQ7IpuI0FmYADd0Sbbq7hMKBZAviQ=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11eab4e8-de61-4c7a-ad71-08da274e410e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 06:30:27.9852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a3HIpLF5r/QALOFYQ9iB9TsRbvI4QXrEnFVsHgWrMYuC9ON9qYUnc5UQnu6/kgJP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4007
X-Proofpoint-GUID: ph3AYeVdtuwSAONEO2qtTeAtBGekyZWv
X-Proofpoint-ORIG-GUID: ph3AYeVdtuwSAONEO2qtTeAtBGekyZWv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 11:27:08PM -0700, Martin KaFai Lau wrote:
> On Tue, Apr 19, 2022 at 12:00:48PM -0700, Stanislav Fomichev wrote:
> > Allow attaching to lsm hooks in the cgroup context.
> > 
> > Attaching to per-cgroup LSM works exactly like attaching
> > to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> > to trigger new mode; the actual lsm hook we attach to is
> > signaled via existing attach_btf_id.
> > 
> > For the hooks that have 'struct socket' as its first argument,
> > we use the cgroup associated with that socket. For the rest,
> > we use 'current' cgroup (this is all on default hierarchy == v2 only).
> > Note that for the hooks that work on 'struct sock' we still
> > take the cgroup from 'current' because most of the time,
> > the 'sock' argument is not properly initialized.
> This paragraph is out-dated.
> 
> > Behind the scenes, we allocate a shim program that is attached
> > to the trampoline and runs cgroup effective BPF programs array.
> > This shim has some rudimentary ref counting and can be shared
> > between several programs attaching to the same per-cgroup lsm hook.
> > 
> > Note that this patch bloats cgroup size because we add 211
> > cgroup_bpf_attach_type(s) for simplicity sake. This will be
> > addressed in the subsequent patch.
> > 
> > Also note that we only add non-sleepable flavor for now. To enable
> > sleepable use-cases, BPF_PROG_RUN_ARRAY_CG has to grab trace rcu,
> s/BPF_PROG_RUN_ARRAY_CG/bpf_prog_run_array_cg/
> 
> > shim programs have to be freed via trace rcu, cgroup_bpf.effective
> > should be also trace-rcu-managed + maybe some other changes that
> > I'm not aware of.
Will continue the review tomorrow. thanks.
