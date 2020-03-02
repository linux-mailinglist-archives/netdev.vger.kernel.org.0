Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58EB176016
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgCBQgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:36:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbgCBQgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:36:25 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022GQXpg013432;
        Mon, 2 Mar 2020 08:36:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZboQ5T8Ctl1UeauQzdCd/TkkPWMcPFwNb/qu0y1IGhk=;
 b=pBHzEyEXICn1Rp/8av/60Rit6suO23wfY5S4K+c6bk3zoilSbHAH6LC3gB1ogjMYKJIk
 283K5GCZPsoqTgXVaNW9mX3KOrTIZbmV3byJmJpcLz1yVvsoOqnkWScIQmFLyK9ws+jL
 SSqUXWcMeHeJrsKci/2reyMoomlMEq6MuOU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yh53508v4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 08:36:12 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 08:36:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSVc5oDB5aKtvTWWw7FThiVdqY3taQZz687+YW7/JhNxA2NO881JfaYhOhbKRFl+mMa5PBir3+vtv3lUlKobsfPQY/qQQqi2HfRIr8R6DWpl/qqlFuS6c13uLyR436rUMle61El77EWPAq11dnHw+BE31t9bWbaPbvIQZ5D6/rTFxkAb3jwvfszUtl117vcvQg+ElBxR/oZBWHfmxuUMaC7Qn+yMm2ipdOM8XgWCwg5muw/rexyRiQGu+SsjLybSmhfcZfpXltiLd4Zms1AwJupNxjjogwyvwR0GoKRliu+DXIpWeYjw4lPM50S4Oa70ykhUE276aeuHWm7x9Uqz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZboQ5T8Ctl1UeauQzdCd/TkkPWMcPFwNb/qu0y1IGhk=;
 b=Snorf4gWOkziCzgOr6/h37uTeYvArfQ2+sk6j2Y4bLsyJ6PeT2KABq12HkvelR2hZUg93WzUb+h4A1DfV8YzXadwG2tI6Gfecw7uwx1S+t2v7r9T6xtN+P1DCazToPl7riQj4x9WifDsju9brOSd5vF05zxFkULq+Z/5SDdA3JqkB455V6BbpeL3nWH6fddJfG9olMIEBgQU6W02oblq7DV3xxsn2r/qeqO1ZiGegkdU61NNlycbt1eVZpThny6QXZEAfV41z+MvowplCABHV7aXuX0wnsL2OfmkBaWmun2ohuC1pVbUP/5iu3ANaf4GDGVI9MCPYvpOnKYwek8+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZboQ5T8Ctl1UeauQzdCd/TkkPWMcPFwNb/qu0y1IGhk=;
 b=BO1ouKpKQiC9rQlUt5c76gSaRRqjtxs8odeOF9SOlilHA5aUZB77H88xoTKJWyEjE9B4Nv9qLXaw4jmMhir8IMdUgiV+TTi+NhWXt38emwq9v/DXuZX4xhonJh/FagVSS5GiWeKTh75SiXJOl/2fbVLrNtBowwd6CSO65SwalmY=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB2905.namprd15.prod.outlook.com (2603:10b6:5:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Mon, 2 Mar
 2020 16:36:08 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:36:08 +0000
Subject: Re: [PATCH bpf-next 2/3] bpf: generate directly-usable raw_tp_##call
 structs for raw tracepoints
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200301081045.3491005-1-andriin@fb.com>
 <20200301081045.3491005-3-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <41a654b1-db73-1c18-221c-e055e2d3ff37@fb.com>
Date:   Mon, 2 Mar 2020 08:36:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200301081045.3491005-3-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:300:6c::12) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::6:87b3) by MWHPR04CA0050.namprd04.prod.outlook.com (2603:10b6:300:6c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 16:36:07 +0000
X-Originating-IP: [2620:10d:c090:500::6:87b3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bcea00c-dc53-422d-ab73-08d7bec7cf85
X-MS-TrafficTypeDiagnostic: DM6PR15MB2905:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2905F58D987646A54FAD6831D3E70@DM6PR15MB2905.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(6512007)(16526019)(8936002)(186003)(8676002)(31696002)(86362001)(478600001)(2616005)(81156014)(81166006)(4326008)(53546011)(6486002)(36756003)(5660300002)(66556008)(2906002)(4744005)(66946007)(66476007)(316002)(52116002)(31686004)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2905;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1YZP8m9FKHoG9ObK3nYtflA7MBWssdV39HdDHADhZpAn1o5nX0uSgLNwkTA/3KnTGXyW+vVs+G7lzhZF6WQy+KN8EEKgW4IYqmkaqawv+rm51CA5RRgQJVXyT1ofgeXT56mM5gYXEfEWacJF6ILAth2QTBPux0davWiHFWDVhvhtQIZRFVduyaC38stKdljJyRdHX2C7vzndTiTMQb1Dhv0SdtaKW7X2hYYNB5U3xjzXuJIx7GVBQwUrY9nQZ7jG/H4h4nsnyXZSHyd8F0jfy6pKD0k85qph+idci8iflStjHrNCu6MX2TY0s0VmOygmeYN05449qz4hy37snwXJJMNN7fvMYLdS/ygPqHG60SquugU7CtCU0VYIZm96uifeZerAMvuSbCmkLG8bNbrA7c8MmKKfQEiqYbYNro5/uEadLvbiVVETv2EXGKpBioF0
X-MS-Exchange-AntiSpam-MessageData: ZueUpksv3o1XPeGCWpX8dglGdQU4j4rtXZqM7GJqVsgLlluV+aa1T1s+STtvIfBiF0cys1jvs8nJES9ZuZLcPX2Ykb9snRFZISywwX8/RkFZVv4neDOIt/5o9um+cl0QGdZxFFioIEu+NpzXfpPegHFDRRT7/QnIF52bbkRZOYAoyeCRYkiXRtQvlPgvwtqa
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bcea00c-dc53-422d-ab73-08d7bec7cf85
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 16:36:08.7146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PC929XE/fOtGBoiqfOBKa2yDTXJK63cWlGUuguqSDW2nhpG2m6gjUPugEJiD/Xe1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2905
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 12:10 AM, Andrii Nakryiko wrote:
> In addition to btf_trace_##call typedefs to func protos, generate a struct
> raw_tp_##call with memory layout directly usable from BPF programs to access
> raw tracepoint arguments. This allows for user BPF programs to directly use
> such structs for their raw tracepoint BPF programs when using vmlinux.h,
> without having to manually copy/paste and maintain raw tracepoint argument
> declarations. Additionally, due to CO-RE and preserve_access_index attribute,
> such structs are relocatable, all the CO-RE relocations and field existence
> checks are available automatically to such BPF programs.
> 
> runqslower example in next patch will demonstrate this usage.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
