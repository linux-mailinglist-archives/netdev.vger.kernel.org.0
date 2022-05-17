Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67B752AD8D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiEQVbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiEQVbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:31:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D795DF37;
        Tue, 17 May 2022 14:31:09 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKFPdQ006394;
        Tue, 17 May 2022 14:30:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=dSYhIp4DY4PBq+5YSzNlmYgLznc6DpsJU51piczUdfU=;
 b=doqJG7Oz/XtceI99oU7E/Pu4oDIU7ZRE4hgq7KIfLwsXy8yFicQz0G5AZP5V4MiRRmrl
 dlKiBLziCGZZisEszETQTL7fw+Q6jkrWJOnHOve7vJ/5I9yaNDKdVXaJixYTAoHmRNp+
 PwzsTh3aepedhBHtctt2KntnMQa3QE8tWpk= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4de9u7eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 14:30:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVKLmDFEjlSSZMtiRFKUL82WcKIAhlwwX05s/+jnweBMKiXgLqlgHW6KrCGkJ8hX9V1ly/NbxkdylpgMPa1yQ1zPBn0wjWAybzC2tc3Ws2/ZI9PcvyA/1+gV0JnwxFg+tDYNQDlhAjMbxkOio+UGVAAQGJh/4NodeNX/FULq54ANiW31lgd9ZIObGqbcrB5hQ3mVVDRoGY8e/mx8/sH6vnlmsYfQdj575pFcnM3qbuld03IkLq5B5ZwPRWo6t+5dUszh8a+q7F5CXT9AUJ2IPtUt6kRooYtAxEOUc6Y8MGV3pi6BmIgFQaHHPg1twgUZuFzkZ2hL1ocMFg9gsCeqaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSYhIp4DY4PBq+5YSzNlmYgLznc6DpsJU51piczUdfU=;
 b=EbDTKGZJLLhfDwh5NYfHyZeqUfna3az8Oag6pH1OhanVbVJDCOvWYpQ/da4nba6zoM8F11yGsCO8ei3/0BVW4d3FGLq5BrU4fMu5Tciuz0BqcuJ+jblTPjnaUYwfF/blmG/l92x1dmaKEN48iZcmkq6TMzVsooQKu/aBJzeofCpAxIvS/LdOk0dIb3+fnvdEwv3nPoVpgviKly47SkRzCss/Wpr1FzjG9QBc+IE0SE0SsvOayxB0SEm3UMHoLsImlx3C4corOK8Bvs4bDFCDlomebnnl5FYE+Ai0Zg0C1hqKqV1NQYdht3e2LY7AD2TJ+mhzai5Fk5vdj0xc3B0oEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM5PR15MB1195.namprd15.prod.outlook.com (2603:10b6:3:ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Tue, 17 May
 2022 21:30:36 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 21:30:36 +0000
Date:   Tue, 17 May 2022 14:30:33 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Geliang Tang <geliangtang@gmail.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v4 5/7] selftests/bpf: verify token of struct
 mptcp_sock
Message-ID: <20220517213033.ytz3kaploentusln@kafai-mbp.dhcp.thefacebook.com>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-6-mathew.j.martineau@linux.intel.com>
 <20220517013217.oxbpwjilwr4fzvuv@kafai-mbp.dhcp.thefacebook.com>
 <CA+WQbwuenfY9Pxet6g0Tvo++JOAmU98+QymuWVsi-2iRpPq3oQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+WQbwuenfY9Pxet6g0Tvo++JOAmU98+QymuWVsi-2iRpPq3oQ@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 845e7eaa-3e2c-4bd3-6fc6-08da384c7b16
X-MS-TrafficTypeDiagnostic: DM5PR15MB1195:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB119506AC3C6D8F0B53E07B18D5CE9@DM5PR15MB1195.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: op4TfZKdDbrVOkR03mH6RQKRzc9Oa/lr3QscbLy2LQL2xMRxCACtpylp282rUGWOhaKY+U5apd8C+aWV2OpJfKm/UT4F5x4Ymsmersp5exPzd8qF00VWnsSSN7RcVjqBbEq9vNnixr6pkGuZk/60BzcTb04lnxs0l9u6QOxGzAHYR33zp4m6T0sgI9w+ZdojDNG4AhKrY7Y8NVSs44mjWMJTLdkxSE7KefJbKhgDmD0ZUIYte+3/r3lC7lqgVy1C59GIX1xy6Q4sYCK4mSCCJHs8cJwWbeiMHZECqqljeYyG7etVO3kumNVV7xTwJ06XROTb81F9xfGlNpsv0t4SCFglv3L72WdmxWnaQoBJrDl/OQAZNvzawAF40YsmE5hiK2VyejYJQZeq/pBocQ2XgCVCOca2Gr4gpicZmSCApHx1e/gWZEuuT9t6LLVAW1x4Yw1d/Vvq2Ehl9BRjelYzeZuD/s8vagC5J1bjvpXlY/dizfx9IfhXeaU01bMI4KNU0MNgQb/pjl4MpJCY6ooSGRyWtV27SKeWlCLn/6rp2If4zkt+bl0Fx/SH1nHW6ICvm4x4sM0a3sLJT46dzfG7C5NUtzgrvB2k0S9BCyajvXxSR+RBUINZ+zRmtyzOYuUQ4QoqxXvzW+uu1YFcu9+RHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6506007)(186003)(52116002)(8676002)(4326008)(66556008)(66476007)(508600001)(8936002)(66946007)(38100700002)(6666004)(7416002)(5660300002)(6512007)(9686003)(1076003)(54906003)(6916009)(6486002)(316002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnJJYkZKQUlBT2tzbXlKYTFROXg3RStXcDRzRWpHcWpucWVhZEpXa0JLajVl?=
 =?utf-8?B?czBqOStxV1BnTHlrU3JRVUNHSXdtNHhPRTZYRkZjL0dOOEF4QlRhamtrVlQz?=
 =?utf-8?B?dU9hMThmcnZvSUYxM2xiYUtmMUUvQTZzNGRNOXNXUEd5VW1YbXZZRHNZcFkx?=
 =?utf-8?B?b21mSWx2TzY5R25UUlZMdXZNeVNGanEvZWhXVTlYMDBQdlFHU1hsTVdmNEpl?=
 =?utf-8?B?SmtBcWVSRnNIRm50eUlHNEdsV2Y0TVluQ2Q5QkFoaXZVT0YzRFJCV0lSanN4?=
 =?utf-8?B?RWdFOHgwMFE4VldCMG1KTmtvQkhuK2lyTDVrdEI0d3UxdWpzcWpaYnZhV0hq?=
 =?utf-8?B?VTN5YWpCR1REc2UyblY3elVHQU9KdjNxKzNHYnV2SzByNWRrcldoanViZWcv?=
 =?utf-8?B?cG84RDM2SzFFY3NRaHh4M3ZEN092QUQ4K0ZFejZCcmx4T24rTWhvclhZeU01?=
 =?utf-8?B?eTVpcEY2d1ArYjhPZmh0bG4ybjFMWEpnWkJmYVQ3ZUhuZjFHMXpmOXBiY0pj?=
 =?utf-8?B?TDhEK3JqZ3FQRS9ObU96WWdnbmNIbE9Ec0hMd0J4L1lTVzNkRXJSL3F6UGdF?=
 =?utf-8?B?M3ZRL0laRmRHb0JLZ2FTaFRvVHJPWXRtemsvL2FOcTcrbk42aHFHZ0lCT21V?=
 =?utf-8?B?Rm1QRXRHd29YYmRMb01nN1gzTnEvcG9lWXRCd0FLZDM5LzVLN2NKQytja0FH?=
 =?utf-8?B?UmlEZ3l2dHN0Q044Y2I2blF5VWZHTEJGK0FTcEROdGMzbmVaZkEwbzI0dDBM?=
 =?utf-8?B?cmtyRURwYUsxalNKNlpQOWJSV3hWWjhkaFZZK2NrbEdkQTJtZ3Zyd2dwWXRn?=
 =?utf-8?B?SEV4S1RQYURNUmlIY2hmenU1ZUN6QUhpVzA5Y29HOHRIVHZvS245NC95aVNu?=
 =?utf-8?B?K2M0QUdyemd0N0dnNkcvZ2E5SzJsbWxESkdPVGJQazFtS2FMYkxaN1ZSYU54?=
 =?utf-8?B?Z0RjRFFPRmErV3VQUXBiMTlsY09PaHd4VU02bjhUUVVycnlNWGw5M0NyTlgz?=
 =?utf-8?B?VVFGdm93OGZlY3NoSGRXdEdVTHNXYjJGZy95b2VBZFJyMXEvVE1OREJMSGUz?=
 =?utf-8?B?U2ZpcE9TZG9GcTl3OUpFUDJ6WWJBN0E4UEkrT2wwNGliVHZPQ21DMC8ydUVx?=
 =?utf-8?B?cW5sQXF2OHZJQklyN1JUTFJ0YmFVbG5CaCtYN3J4aldFUXZmeGZnYW9valY4?=
 =?utf-8?B?Rk5acGVOSVZFMVRkeVJBMHRlOWE5S29EODQxSzBGV1VaMS9HSEY2WW1HNWNB?=
 =?utf-8?B?ZFk0bERNYXpGcHZkdEh1Y04wMXNhT29UREdDaHRlNXo2S1RRUE1MdHM3cnB0?=
 =?utf-8?B?ODdSYzNVOFBlZnlXVkVUR250RGNQSldGUVFyeUVzNDNWL2x6dGRYNEZTK3VB?=
 =?utf-8?B?WjVITFZ2TnJVQjlBUUxBTDRkVy9MM3Y1NDhERU52SW85M1hxTUwzcFQ0UFJJ?=
 =?utf-8?B?czJmL3ptUnZrVUZybW11M1lOVGhSbnhBTGVDR0lRbDVVYnR5ZjFtOXN5cXFU?=
 =?utf-8?B?VzRKRzJGRW54NEJsMnlCZFhSYloxZm1SSmtNVzNVOVpGdmFqaW9QRDl5emdJ?=
 =?utf-8?B?dEJkeXQ4d0FqemlNMXFjUXlpcTllQ0xZNEI1SUNweHcvZ1ZVTWVDdlkzY1Fy?=
 =?utf-8?B?OHZ4Sm40TkpkZm0wNE9ua2Q1aWlMSnRXcTdiYllGTmpyVFcrZjVlQnZqVVRl?=
 =?utf-8?B?NXNHTFBTMW1ZV3gzai9pY2swc1hkQ2NoU1VLSjZBS1dTTU93R2taVjVzcnlV?=
 =?utf-8?B?bG1kRHhidVgwTWtuRkdHZnErbXBkbi9vM1hjOHhsbzJnS0pySkFleU1yakcz?=
 =?utf-8?B?NklZRFpkWDhoR1lPQThMaHFUZ3hESzZhaVpFYWhoZGg3UElySFZ0TkQ1dEpz?=
 =?utf-8?B?dkUzVm1BZk9CUnFCbmZOcVdtMllId1p3WGlDYmUvcko3ZGZWOGNnZEVOeE5I?=
 =?utf-8?B?S3VTMlhjdEdjVkt4cGhjWU9NWWk3K3psckZuZ0RxWWExbzFQWVlxcUVWT3h5?=
 =?utf-8?B?dzV2bkJpRVMwVjlaWDFOcWl4cVYxSzY3VDlBK3Zodkc0Nk1DeXh5Mm5tWUlr?=
 =?utf-8?B?a1JxWlFna1FVVzBvVXZwelB3MDFMTVFDdUFSUWsvaUFyQnBTKzJ0bzJqUWo2?=
 =?utf-8?B?bE51M1RiNEdVaGRBcUttNlUrQ0pveFJnZ3d5NTJReGVacmdYdHhiQWgwRHZp?=
 =?utf-8?B?NVBQNWhISk1Fb0dmSTd6U1I3UmVudXlpLzN3SFVycEFiMHdUN3NVeUs1djkz?=
 =?utf-8?B?bGNua1l5UGtXSS9OLy8xMDNPMEs1dW9tbWNhcVhDRmJPcUJVdTVHOXR2SENU?=
 =?utf-8?B?c0hGcXozVFNLeXIvQldGRVk3anoralhPc3NEaTVCNll5TS9Ib1lSTHJKZVJG?=
 =?utf-8?Q?aCrsrICzDk2UCQp0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845e7eaa-3e2c-4bd3-6fc6-08da384c7b16
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 21:30:36.1646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzz9OJNWdXT2W+qsEJ+1V57U3UTGS6yi4a2bd8RwkAMsDiKK2/4D8yUE2StTNq4k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1195
X-Proofpoint-ORIG-GUID: 4yTwl0ixBDcRxlQD9LVRgOgdUV-PG9Le
X-Proofpoint-GUID: 4yTwl0ixBDcRxlQD9LVRgOgdUV-PG9Le
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 01:19:38PM +0800, Geliang Tang wrote:
> Martin KaFai Lau <kafai@fb.com> 于2022年5月17日周二 09:32写道：
> >
> > On Fri, May 13, 2022 at 03:48:25PM -0700, Mat Martineau wrote:
> > [ ... ]
> >
> > > +/*
> > > + * Parse the token from the output of 'ip mptcp monitor':
> > > + *
> > > + * [       CREATED] token=3ca933d3 remid=0 locid=0 saddr4=127.0.0.1 ...
> > > + * [       CREATED] token=2ab57040 remid=0 locid=0 saddr4=127.0.0.1 ...
> > How stable is the string format ?
> >
> > If it happens to have some unrelated mptcp connection going on, will the test
> > break ?
> 
> Hi Martin,
> 
> Yes, it will break in that case. How can I fix this? Should I run the
> test in a special net namespace?
> 
> 'ip mptcp monitor' can easily run in a special net namespace:
> 
> ip -net ns1 mptcp monitor
> 
> But I don't know how to run start_server() and connect_to_fd() in a
> special namespace. Could you please give me some suggestions about
> this?
You can take a look at the open_netns() usages under prog_tests/.
For example, tc_redirect.c.

I would also avoid string matching from "ip mptcp monitor" if possible
considering the command may not have support (test skip) and the
string format may change also.

One option, you can consider to directly trace some of the mptcp
functions by using bpf fentry/fexit prog to obtain the token and
save it in a global bpf variable.
Search 'SEC("fentry' or 'SEC("fexit' for some examples.  Then
the iproute2 support testing and the test skip logic can go away.

Suggesting them here because the test will have better chance
to catch issue if the test is not skipped or failed because
of string format not match.  I won't insist on not using
"ip mptcp monitor" though.
