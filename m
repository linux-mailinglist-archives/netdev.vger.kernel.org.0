Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E21323337
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 22:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhBWVZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 16:25:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31850 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233543AbhBWVZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 16:25:20 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NL9h6P023509;
        Tue, 23 Feb 2021 13:24:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xcTsljDXlEfyoxuVYhySRAmBTZ9UhONYW9BZuvgH4r4=;
 b=MFTkcYod90Mmr7k4HNqHEQ3gdflXVyQ4sc8/fSJ9Gq1ZLQK8n+YUXExvei4kwnH3h2te
 tNednzxjtjkKXHoFOEwS4UB3ztFw8e8SV6XwegVizv1Ft/F2+hUxk+7DdWU4T24CTn9+
 krYE1GsV2JN3fKL5DueGjNQigJp1QWAerYs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36vyp0kb67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 13:24:20 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 13:24:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXmCjOBWhWMbUQEaxYE+DG5Qvi7ajRINLOrX+19FJK4IM3x/ScoEozSTmTxFZEot0mMxM0tIXfb0TIEBsPKlWzBVIEtbOYTNpyindVtx9CVh7C8OdIheQtegqrhVjjuMKDKqRj0qS3/yUgm+NJDNIDSlKXxHyZ6/E/X6RezWHFuuFbcZdbPy2NrbsGIir7AvxrvwMj4VobIfTzy5AltkytIX+NnhAprDlI27CuZ9VT/L7Hr5XTisYQgbvrLmDg7osopNGrL2OxQxFNl202BiwqdW9Y+3BZ50yh3p9OxhxuScHT4HY30GlE12v3MGOJPQsFpZrzm/THUJOomjXPnnXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcTsljDXlEfyoxuVYhySRAmBTZ9UhONYW9BZuvgH4r4=;
 b=ehn7plaj1xGAxDZdTTelO70SSg82pWA34w/oIR3Q1/g1vDotI9/rAtqqK80idP7yON2C6T3Rr37chgTY6XEAAQ2d4e/Esu8+PNzne0+c+mXRBPk78LBm+2AyscZRwD7qUwrtbqZwOCr0W80rVSo8vlcmCpXdZT0j9KYM1ppbmn8oolEa9GUL6t3hEFGcuycBZPOXP7xm6mxy+g9yvH7/XoSRc3GT3UYPAagCgnbbXOjvB93DBjeMX+r3z32JqjxWIuchEmHD+AiskPXuHi0+FGLAxkuDtA+WXIoWZPbR5MNeTYDwiTBMR5Mdityr+j3i1q4moWBHsgJeK7jkhmUDzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4246.namprd15.prod.outlook.com (2603:10b6:a03:10e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Tue, 23 Feb
 2021 21:24:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3868.032; Tue, 23 Feb 2021
 21:24:17 +0000
Date:   Tue, 23 Feb 2021 13:24:13 -0800
From:   Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>
Subject: Re: [PATCH v4 bpf-next 5/6] bpf: runqslower: prefer using local
 vmlimux to generate vmlinux.h
Message-ID: <20210223212413.fdipqdu74xojh26m@kafai-mbp.dhcp.thefacebook.com>
0;95;0cTo: Song Liu <songliubraving@fb.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-6-songliubraving@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223012014.2087583-6-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:512c]
X-ClientProxiedBy: MWHPR15CA0030.namprd15.prod.outlook.com
 (2603:10b6:300:ad::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:512c) by MWHPR15CA0030.namprd15.prod.outlook.com (2603:10b6:300:ad::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 21:24:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 530a2cc3-3af1-4021-1486-08d8d8415f85
X-MS-TrafficTypeDiagnostic: BYAPR15MB4246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4246D354D0B4F398DB97B317D5809@BYAPR15MB4246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1T44qtpQg/NDiwd4TodXnla3xRz534eZbIVh2Nxu8wBXCFuntO/HrFufh+oBzSeQoyWevFawsJgKznb/ylI15LLVdOdfe7RSPq7OKRb4oLZ0vXd1frjnjaAap92U+a7Cjxjozl0OLbyYToznP90Vz6LFX27mc0k+kHui4yhwqYpDI0JORbJg+g5UjY+lOtrLK/ksUcfIaKBWkaapoPq7pQ4GBcIb3jUwRY72ZBe2puhSmeY3LceTotvHyKp/dvPD+47TT+NOPxcOetVkuobAFHAz+TEczC7S4LP/Njzixa24/IlgJDAs1/vcHSZkbqpfZknunZDlJKv0yuZWNOy0xkqsy91aaReqEcR+Z77nzTIBFK+/w2dIg9QWzW5F/emrvM2Wz5flqvY/M+ihvD7oGIUwr+k5FUzNsuINbz3ovjbUvoDwM8Phe+Ce+HRd6oitFeBMpFrrMgepCZRVjVgGxTgCkDYefQhqcG9nzxsWTj65rqY1eCtZXt6sR9iwglA1Vn+dU8oXcduhTZKArlj/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(83380400001)(7696005)(186003)(66556008)(2906002)(16526019)(109986005)(558084003)(6506007)(1076003)(52116002)(478600001)(66476007)(8676002)(4326008)(66946007)(316002)(55016002)(8936002)(5660300002)(9686003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/2D92FMPOhWlR1OwKyVpSr9oc5hHV8XrOzHd6vwjwKRg1gIUlDy5iJ1JiJk5?=
 =?us-ascii?Q?pmqd9PnMki0ms5iQaZwhYPlbRs+HcMEMMqp2PHQaW71a+3LG9WpFIlODsiA5?=
 =?us-ascii?Q?hDbE3snUPjFaSKzw0sZMtFbpG1mc3Hr3beDu00OjutW8sPdEtqYqQqgXJpyi?=
 =?us-ascii?Q?8A7f9bXNBiA0Vs+v53lrfYdOa6ZAon3OfsufdqfIl9CjtOa6gDZGMuuhR3bs?=
 =?us-ascii?Q?LScIBQZPtuvBFpYAUgE2QB5EP2R5qU1o1b+u006P9hK2Q+08H/jECSztxHZu?=
 =?us-ascii?Q?iD20d7NM013G7DYNj4/Z3fzyfomGw8EPNrR7nQDPextOyxZdgzP5b/NeDyg6?=
 =?us-ascii?Q?SNB8cFxgQdANvhixmy0U5V5UBytwUk99rmj9QKe8PIHUsDI9d6JZFR6/z2oU?=
 =?us-ascii?Q?lVJu33M7sCM+7abPh/TtbZYWTyfTb/TuIQmA323SH6TAmNx/WtR5kktRxSYj?=
 =?us-ascii?Q?5J/WkTdeL4y+3qeml57CiZ2G95vKZUVwF9oD2tViwwz+OjvCB55BPGvZ0txQ?=
 =?us-ascii?Q?dB+38Wdc7Uqa4fGB3UQyaWT81hTEcTbex2VwwK2snul68zQYXCmeTZELqzSe?=
 =?us-ascii?Q?jofr+RCSK+KpZwq0+1srxG4PdkO7VAtz0fUL/gpJEhZoVJMeqRTXJqlmPbYM?=
 =?us-ascii?Q?yr47AzPc9mWbiztS9pd0VFhSDdspwPoBw306WHkXye1DgJStOs7Ceq7OJtbX?=
 =?us-ascii?Q?Fc9lZMY/pO1EWk7TtkxwAiNSDWIKlri9nARcIig4awfnyLWg2zUMRjTOn0PR?=
 =?us-ascii?Q?xB2QwLB36T3f8peJ/qCSu60gTrlKW+MhEcoMu/NWuP4ABJ8vKXWmp/jMx5Y6?=
 =?us-ascii?Q?G9983gAaZ5jPYAmwO4Ckm5+rpmeSAsIhhPVk8HrEEECNSAu8eFycmt5bZHdo?=
 =?us-ascii?Q?oxiyqSRfqpapEyfKt4SGM5I0Fl/ECOTgol9bbwlvVkJUoVi+y1ivaqYOICrB?=
 =?us-ascii?Q?ry04Oi8KJ/j0w6EUEV5rQHzIPR59lgJp/68L9fDKH+y34P7w8CkhbuYVJOrM?=
 =?us-ascii?Q?LJ6uRY4RruISzV+qq7lX9Y8LwEvmLoEsZgESbcYnxmnBRRjz7MG0yx9ZJ5lQ?=
 =?us-ascii?Q?42a/buYrqL3GtRgr74JfqHjPo3i8WYFZRgYE/qRZ88usq1kzZgCb2v+SVg0M?=
 =?us-ascii?Q?IIw8MiIoc+QJj9wAqIRmqu3QzNFpVBDy/cescWYq/r4wqXqOAY/iDp1CWANM?=
 =?us-ascii?Q?+OkCPNCW3CrdBINq+CFXeETCDceX44TpLqF8kzPrPiZJ7spmRZxs5nbZvMrf?=
 =?us-ascii?Q?3U996aiThT1yYNN91bMi3Ss9ek7UOEokBQ3kC1i4LBcSdR5948IVLsIKvGil?=
 =?us-ascii?Q?Gy+pSVn2Mx5935XDZaZlPltUCbxzHw0hMWcyhxQjX+kDbVkB1lqoi5PAjsjq?=
 =?us-ascii?Q?tb0CnD0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 530a2cc3-3af1-4021-1486-08d8d8415f85
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 21:24:16.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bErjanagI5OTjctMn1gHLvjxffn1EU4YMAyT8EvVUI3JdhVOrOdQ4vPFt70P5QFI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_11:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 suspectscore=0
 mlxlogscore=598 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230180
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 05:20:13PM -0800, Song Liu wrote:
> Update the Makefile to prefer using $(O)/mvlinux, $(KBUILD_OUTPUT)/vmlinux
s/mvlinux/vmlinux/
