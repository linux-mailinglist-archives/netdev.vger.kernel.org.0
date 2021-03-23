Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8D5345707
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 05:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCWEzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 00:55:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44960 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhCWEza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 00:55:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4rIo4029592;
        Mon, 22 Mar 2021 21:55:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QqTSQr1YopmI9J0zXcIKFanJVX6nFX0UgExlWh0RaWE=;
 b=j2rGoQRDtUgnrWzRFkU6m6v7zFiksHvBKthOkkODomiChbhc8QD+LS3RDAQSiVxL3lug
 NQBrkPrJxQXFFr2OZ8TbqaJrZroAdY7uJWKPsc2kLY65J/dcW99nN2W3Xzcqg4dZamiO
 d7US+3ymL0V2MsnkYrq8PgHbgtBpL7jCpeE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37e0rhhk6w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Mar 2021 21:55:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 22 Mar 2021 21:55:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbJgEDgpZbuk75HHOzgTutj6fHqwJm/xGyZ4vvwsc3KSbigYYM1sUQetDYYzdXgBkw1O010t/NsnEF/jMZlqKDOfKLf/vZI3uE0qNNZjDlKBpT1jwTjvVKoPjf6yiR4qkigqkXTrgUf4I/QgpRV6mrGC9/ZYYbu60/YtmJVvDntEvAz0V3v4NhCyLZtfEJokX/bkc0q1CBbsqRDIQq+6yvBtb7FgzdsTDG+f2DNDPiCD8RTW8NGIEe9ACLtE2OTRcrIwx34YO+eMVF7a+3/zIkkGIP7SKYWLo3RoGaYZaoG1Q9F59le1KOWHYCZdown0Nas6Fb3+1mZj83MC17wejw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqTSQr1YopmI9J0zXcIKFanJVX6nFX0UgExlWh0RaWE=;
 b=RVZtuvOpEZPNjehZFILkPsY4qdlJYc5gL1TgifQe0zZjSXLGyW9dMQhLKHyyUlUFCcHIrEts+iTkY6AdCa/Obhbae/ySt/Epa5hHKr14RSRSLppsFsAT3oesRq0GFnKxHfaqame9m27ypPNP4coUBA80igwGNEGTn3ypiDDTQn+hg8dT5LaNI0xQdpLq+5StlyGBztTVPlzznpiLv3FErXmBE5qeV2INVmuEJ2GpVSZ5WTKN+n1WdaTFXt/w3b6PRTrLXPvd0f1XLwIOEgsO1gjlZeq9snz9pAbn/K2GJtfVTaMcWZTsyDl9A/XxCgpUVcdf14t8zMBIcdiBqKhH4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2951.namprd15.prod.outlook.com (2603:10b6:a03:f7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 04:55:12 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 04:55:12 +0000
Date:   Mon, 22 Mar 2021 21:55:08 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 02/15] bpf: btf: Support parsing extern func
Message-ID: <20210323045508.k7gmz6ndgkftew73@kafai-mbp.dhcp.thefacebook.com>
References: <20210318233907.r5pxtpe477jumjq6@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZx+1bN0VazE5t5_z8X+GXFZUmiLbpxZ-WfM_mLba0OYg@mail.gmail.com>
 <20210319052943.lt3mfmjd4iozvf6i@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbFOQ-45Oo_rdPfHnpSjCDcdDhspGNyRK2_zJjP49VhJw@mail.gmail.com>
 <20210319221950.5cd3ub3gpjcztzmt@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bza6Fiv+AFJc9-L=S6Duvm7wyyjvqoDGEED3TDTmwiZvVQ@mail.gmail.com>
 <20210319224532.7wlmhrgtrvkwqmzg@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZm1o-ZqXTpUcVnbZDX57pGqARwjHjm_=aspgj3ahHZLg@mail.gmail.com>
 <20210320001313.xhwiia46qsjh2k7k@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzaJMmmz3JvUJs0ja5yrx_WEssE_R7t_uPAwEHFe+SY9Nw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzaJMmmz3JvUJs0ja5yrx_WEssE_R7t_uPAwEHFe+SY9Nw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:8f1f]
X-ClientProxiedBy: MWHPR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:300:6c::30) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8f1f) by MWHPR04CA0068.namprd04.prod.outlook.com (2603:10b6:300:6c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 04:55:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67db12cf-4148-4249-09fe-08d8edb7d79a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29511CAAE598430FC2643452D5649@BYAPR15MB2951.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8+uWDW502/hMd/9Wr/cNip4V3O4hvMjgJZGdhQ4rT0TH2ZO+smc+IVBdEWVQrWZboPP8D/5gBq43MJidlPSuR1ckGESJyN/BYaX+PqsJLVncNYZt7eW3Z1DlawGTccdzZRpOhCsO7OvPBRspIrrSO6ROZXMHuipc9WISx5H4zMwMcOWx1wspH94C74kCGlaUJV4LAIwnfezTrTydDjg+/9Spv8UyhCTx2oIC6SNuHz6OITFhsq1uMGz8TfGE9+PjfTsJTPN/pL8St3lA0DL3FAM+cTLxUxAPsyF78jef4RNLFHBk94S5xzdAkDyHxvOY7Y/6EBPav/AKTWk6KuvkPVdKSxLSLc7yqx5hhSEogS+CqgAZAuJ8J85QLNbGpsVBxmBP4y6UvP8y+cuqQgsUoDYfYSuqB8y6a1xrvshgf4S+Cka9uca+XBmdFXtgG0597JE1DUO9qNpBdegGTlYvuFNsJKFiUvz1SsUtu3Dj0amHh6MvbWnWJ68d+e9n/+RTph2N2rVOyXWWDPZbc3YhxMT31CvC8jbJ3n0G6Ua6mNz+NSNxu53oTULQXsPmtVWSlGM92ovBko289KLyMIhILqx8lDTDbbIlB1iUa1Vxzr7swlzUnml4W731DFX2PY/TjNUaL5Wd0qryz/OODdfHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(366004)(376002)(8936002)(66476007)(7696005)(83380400001)(66946007)(52116002)(54906003)(86362001)(66556008)(2906002)(4326008)(1076003)(38100700001)(16526019)(9686003)(5660300002)(6666004)(6506007)(478600001)(186003)(6916009)(316002)(55016002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?41GVSzO+FgPntlzx6wlDD7FDImo+XIoAsxzKAGIUX2IV0S4iplELSd5fQySE?=
 =?us-ascii?Q?5Shnnmu6lWBJmA4MFlrFMmTOXjTVcdZdfvdWs1jael2Oy/hQyWafd3IIYJGT?=
 =?us-ascii?Q?eNcT6gT0WLP+Sjcct4koeqBmCKU9UGVLXHanJkp01pFjJUjKsO0tm+Y35mYB?=
 =?us-ascii?Q?IHGVt/iThlLRc5pZttrP+IQnLMl6/23eeSwZt8F0H/WShsZpeMf/kg8RslxD?=
 =?us-ascii?Q?XoHUdHY1Nh4Mmt0lbJ9S39xtvXZGOgm3/d8UkgoePrBg7NV67nTHuO77mAx+?=
 =?us-ascii?Q?Ndje3fA1NUbDp08HjX5JohnQfDVN4OL9UfO33jZck1izDhXGe17SYo+BQ/Rs?=
 =?us-ascii?Q?ZuomRGMnySVaFVqkdhEBh19c27nMLQE4xV0tswzdCByOopwOkcjHP5q2uggy?=
 =?us-ascii?Q?bEOlM+PaknHkE4pRCqL+QdFe0eMtsYGu41mJAfRe0xFRZ8SnrgLqJYtsoNHN?=
 =?us-ascii?Q?INXw0OTVgyLP+FE8eQ5aoWIU49gsRtsB5+BLAx+vVk6lUC7nJRl4SG1me2wg?=
 =?us-ascii?Q?wkWu9W/SeqqoKgyy1ZBSWI4wXSAwo7sXl1w+yfInR8wAfaBeuxgREzv7Qebv?=
 =?us-ascii?Q?glL+bu0obG1cB/8EMHbhkc14fnqeX12VU3IEJM7jsiIokWd8OWBHfinH2HVa?=
 =?us-ascii?Q?fw5S8LR91Qf6FtmJZKo4AQRXhW8d3vj/Hks9JFOyksIcsuU3Nzhd8M/SvsyW?=
 =?us-ascii?Q?sdVejjmbWhnw5TEAnAXNTS0CmSnJ/JtNM5fVSmA8aTMY3yQXzh1bH+Ob2h5L?=
 =?us-ascii?Q?OSSND47NeTLnwxUS2NQbKuE2GbA6MgUtKc4W0WKbmAwcHqiY/vrBejk6+apG?=
 =?us-ascii?Q?dFRR+gJcjTFkpnU3yZzSpMHm7lYpaBcRxqTMtE8rJdScqID+A66WCQr7BZCt?=
 =?us-ascii?Q?zUPDgN9hOj/MG4aNg/BR9IqAY8SbFyL7aAkJkZfv9zEnme0ID3ZORZPe6vSm?=
 =?us-ascii?Q?a5ugHiznXeUUfz2SUg2tBsLfFwIN78iE2LAiLHTTGv9CW+W0N/RnaJESbgkO?=
 =?us-ascii?Q?Hz6EVsBnnZu7yAxapjtBplo+whLr8eqZVnef94V3iCybqGqxallLypQwz8sD?=
 =?us-ascii?Q?D2vkB6lwsKMrtHVM6LyeDbz4CbOxQ2bfunwGORnmVZFi5YBkShDXnDgPDYdQ?=
 =?us-ascii?Q?nBxXWwczAgINP28fxV6uOaffqQbu9VhPlEg7vkYsEsDNXlikuUv/NMBmKRBG?=
 =?us-ascii?Q?T2WQpV6rd17KLHkWfKusophFVPXIz/SiBOsRlbs13ioUqgKg5LfYkTmpsaWk?=
 =?us-ascii?Q?qe62a4A1lYeC85gY021bVokWtj6nydi9mARTNinGS7fD7TapPenG2h+ybCNx?=
 =?us-ascii?Q?yGQOiWG3s4+G/gY8mGDGxh4A4wcNTTOtJNJrk6+tiHDmug=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67db12cf-4148-4249-09fe-08d8edb7d79a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 04:55:12.6808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYbqP/BA6V6wyQqcTRvN7fA+EzZKe1IlDOl1vBOQSob9LHdFeaOfBDrkS+w3Wf3c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2951
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 10:18:36AM -0700, Andrii Nakryiko wrote:
> > From test_ksyms.c:
> > [22] DATASEC '.ksyms' size=0 vlen=5
> >      type_id=12 offset=0 size=1
> >      type_id=13 offset=0 size=1
> >
> > For extern, does it make sense for the libbpf to assign 0 to
> > both var offset and size since it does not matter?
> 
> That's how it is generated and yes, I think that's how it should be
> kept once kernel supports EXTERN VAR. libbpf is adjusting offsets and
> sizes in addition to marking VAR itself as GLOBAL_ALLOCATED. If kernel
> supports EXTERN VAR natively, none of that needs to happen (on newer
> kernels only, of course).
> 
> > In the kernel, it can ensure a datasec only has all extern or no extern.
> > array_map_check_btf() will ensure the datasec has no extern.
> 
> It certainly makes it less surprising from handling BTF, but it feels
> like an arbitrary policy, rather than technical restriction. You can
> mark allocated variables and externs with the same section name and
> Clang will probably happily generate a single DATASEC with a mix of
> externs and non-externs. Is that inherently a bad thing? I'm not sure.
> Basically, I don't know if the kernel should care and enforce or not.
I have thought a bit more on this.  The offset=0 of extern var
can be used in the verification but I think it will still have some
open ended questions like arraymap.

I will use your suggestion in libbpf and do something similar as
the extern VAR: replace the FUNC in datasec with INT (btf__add_var() if
needed).

> 
> >
> > > But of course to support older kernels libbpf will still have to
> > > do this. EXTERN vars won't reduce the amount of libbpf logic.
