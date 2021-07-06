Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7559F3BDA71
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhGFPrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:47:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232774AbhGFPrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:47:18 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166Fbsn8021761;
        Tue, 6 Jul 2021 08:44:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=UUGgIhDcz2+bMBW+He/iOBj6yhJiuHVMM4vp0yJuI6M=;
 b=S06LNsF6MgOrZ0tD2MX9GJy91Qp8cuf2i9Y063NVSjln0eKt+Bg9rkCjOfMg3Qx/PyfO
 LqyrputKCzm7P0xCrwRm9Pnpf9lt5bp6odrW7wZHv7IF0/kLA6mer1+p9fYLGS5uWccw
 Jg/KDGmtUO1AGo3uyVq08ERRcetswMH55eM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39mmxmsxtm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Jul 2021 08:44:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 08:44:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOSIgzsQ+gqGwoC2DgKjC6uKzLzMuaOM79ThbeZk28UFyRiCCUEUG5v2aRJVQI/GD5oxd6zdVj3SWq3psTV1bhDGOdV6kENycWB7MPXbWjFLZoO13aCQzu2MGknQrSphMxstYVAzUGDyCUFBPziVPxGL5TlYYEZHMmVrHIhyjNVZDzGXduPaSpE8JcT5UquQ0wfByRVIT+HURP+sU2cU2DBKpgL9MshGuSAGXFZFWP/iBqE1GrF0dCnPiqs20lphvNnnzlOVzgIIfaXc0/YigcKqXErth+DfIAnWO0Fwb16F2eb8wNBaQqw45r99wooHOq8CEwTagDfwKGJ1drFj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UUGgIhDcz2+bMBW+He/iOBj6yhJiuHVMM4vp0yJuI6M=;
 b=QX1yDc4j3XYWBcAPlKay6ess6OAgjIBDbUJNiCaahUUH8g8p4vt0BH8ET+bySeMDqYKB+HzWpWnsJbJ8R1UHS7OjcGwaukmNSYPscsM0+SZp8d3UEznJ/veFupVLM15DdHonCNejOjB6QKf0wq8vSUOrWemd2ejLsvHRrHy9o/18x9aVVSV/XQtHgcpNc6ZhoYatdeo68gU2aNsiDMI/pnxaFnvlpOYW0LnCNrWQyUEpgQW68kPonh17uALY1hqjvfMEwzJnRrtUKOFbnoy+dMSb5mF1rQWOX0/e78A8TnTiNWo85YPhmzmQgoh6dg/DHYFfhH/1k3yO9B3Aaj0Bvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4609.namprd15.prod.outlook.com (2603:10b6:806:19c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Tue, 6 Jul
 2021 15:44:18 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 15:44:18 +0000
Date:   Tue, 6 Jul 2021 08:44:16 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do
 bpf_(get|set)sockopt
Message-ID: <20210706154416.v63cvb6ylr5cnyxo@kafai-mbp.dhcp.thefacebook.com>
References: <20210701200535.1033513-1-kafai@fb.com>
 <dbf6bb3450ac440a9b201fb14a49394e@AcuMS.aculab.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <dbf6bb3450ac440a9b201fb14a49394e@AcuMS.aculab.com>
X-ClientProxiedBy: BYAPR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::27) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f163) by BYAPR02CA0014.namprd02.prod.outlook.com (2603:10b6:a02:ee::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 6 Jul 2021 15:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd6935be-fb6a-4597-a73a-08d94094eaab
X-MS-TrafficTypeDiagnostic: SA1PR15MB4609:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4609ABA852A35EE06F0625BCD51B9@SA1PR15MB4609.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1265;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BT3bxhG9Q1mkPHx6eWhELkBbg2EsGXMN9IRRoBt3yDSJA1KXxJGsDALQYJ0l1GYslgxXwt+DAVhuiioEdoNIhLuWX9XsDpr8TXoq7Cxc2rCE2QwTCS3bvYi8V2gtqAJ60Yf+BLl3lBKyyA6obd7CQI86OGaQkqCt1IhX2fFf++HfSJAvTACsaxEorsQye8hC3R01l6cFRftIiArU8bRNhAZavhfulNTwztxs2AvE7WQul62oMjs8XKlZm/D0AxR4pm9h83dPymIYuYFr3214cQVl5NmirsiSJcMeMtLSWlQV/c4eaXN9LeTA5bUHz5WQc7047bklfsnPAZ97Elveg+MGKnOlCFarAkE1TJ4iioxMIT+cRR1LZgB2W0dyULAH3YHchZdgT1quIroUDB80NbbYW/NpuslWS9yqxv5Rk/X4m7WqLbRYr6qPJBDiVVx8hdN7IL1TnoXvCv35TwH0nfDsyDprx0jo5pRlYFaIPWW04d+V2auvcxnzN44ahvPw6QXfcuYb5v8Q8S7h4pcVeQ34yclyrbqQgRy2lvBfIxWZaKNXhmN0NRG8RsOW5qUQ7qKUtGUf3slHlmqgDbaUDSHioworMHoAxs9et+TqCpW9SvHursxaGZ2XRSzmMsrr6scfctA/Ixee6F478AfRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(1076003)(6916009)(55016002)(498600001)(186003)(8936002)(2906002)(7696005)(8676002)(52116002)(6506007)(66556008)(4326008)(66476007)(66946007)(4744005)(9686003)(5660300002)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rHoSvLk4t1sPI1gMfWxR9AA1m+91iDxrL+p4RcgLYGbDlTlWtH1uIxtzijEr?=
 =?us-ascii?Q?fN/cwke8T/m673GZDIAUvzZxxkJbyUI++B6ddstFbBT1iaHTbz3uVeaWP6H6?=
 =?us-ascii?Q?ffkcHA02LQsN6HtkJS2Gzp26xTe7t124Me01hTShQ2Jp6k5iZrAzU29NXKdB?=
 =?us-ascii?Q?DPEpTg89FtdKDAyHfCQAWYemWTho3Hf+DlPdt2Sx9HaiyqfuUJpLcny1kaC3?=
 =?us-ascii?Q?wxNqE/rWNEgCJJR3NxPxgrYeLthz+whQkxtluVef3x/0RPWlWARZpq2oZa5o?=
 =?us-ascii?Q?ea/+cX1Zq1jlV3fGhkGXHvnUbXEcqAhz5gNtXLWYVXnPOINWYraMVEzM3MAX?=
 =?us-ascii?Q?Hz5sh9c1E41aq/z0J0Vjy5rkJ3i/XFMNc8XfYmpznC1bSginJ8qbMRFUoeKn?=
 =?us-ascii?Q?oObNLUUsTEbt4ajDtv5IEqUm9AOmOgRHl/nO5VEUqDL9pikLI8iBzEhxEfKH?=
 =?us-ascii?Q?7M5mm4FbqpAhPcXVj9WNAg//S7ZtdxXGkrKVQMZXjdYuFZ5isTUgQl9L705s?=
 =?us-ascii?Q?tu4aLrFUs1YzUjbqUdUwlONk8nFY7hxpjwkJnuZ2Dk43Nh/5Xr6iwulaIYxr?=
 =?us-ascii?Q?hc37DpmBlzgtH7J0QBv9bJXlSS87wTdNvS1rwPGbtdKNOdlbDFXizJWE6CmI?=
 =?us-ascii?Q?gTOjgtBfnKztsyVy2sqyVer0+dioryrePNYOuVTyU18psomlloQXwVe/RbiV?=
 =?us-ascii?Q?d/by+Bwfail1DJYe7IRwQlxxInOM0cwoq5NI/Z8R7356q5EJacyrzXdKTygz?=
 =?us-ascii?Q?A8j7tCjjcECmT7LDnPb6rqsJtFoY8x0+9nEUD9dSA0KvMzdk4l/2RiSU4E/j?=
 =?us-ascii?Q?GTM0PpS9TsuPa1wkj4t0xR207j24YtdMqSc85foye1pryv0KvTc3/0J0Y8de?=
 =?us-ascii?Q?oVd7v5khjC41hxqGu0RPM14/GnW9jGE05Pjl3VtUtUmSW/cxpvjEjgag+n/D?=
 =?us-ascii?Q?xHwe5V/Hpi5m6Gixpab9dRTRI9NzlyN4cKfFrGdCQLXhajXZ3oGXO55gJte6?=
 =?us-ascii?Q?vu0kmVsmxCHN7Cgl3v0Bc26bYoaUjMBzxZgELd/xW4YNQB7EAwvgrS/JGoQS?=
 =?us-ascii?Q?bWu8TWwO+wsulbs7H5xzEEH1f98fBmvfv0vHk+z7VtPCBRtGYwNAFQav+7c9?=
 =?us-ascii?Q?CspV/nPs2I4LgR0sGcpNHZESMcXnkwkN6IiHBa3rw7CAftScF6pbAm4URIEV?=
 =?us-ascii?Q?a1yp4L5DWUw8au+g3eaR5zU8yBJoH3RByAsHjDzSN1EfkHAc3CqY88UyQ33G?=
 =?us-ascii?Q?2NC6TJPorE8+bwHnlSOPARcgsr5aVO1yBER65nYrx7I0SVBh+qGKUBQObfoD?=
 =?us-ascii?Q?ehPLvQelDitqzwUZUeUAf2rpoFAimBqofIgKsGRnY7gAyA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6935be-fb6a-4597-a73a-08d94094eaab
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 15:44:18.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ox1E3+528P1inf9tFUYG3iWmM3b8d9fdGDenooOpkUvYRNpqpG9cIiXJq5rLgBKY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4609
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4TfTKfV3yMJI_d2OBOVaVYLQloMIwKLL
X-Proofpoint-ORIG-GUID: 4TfTKfV3yMJI_d2OBOVaVYLQloMIwKLL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_07:2021-07-06,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=765 mlxscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060072
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 10:50:43AM +0000, David Laight wrote:
> From: Martin KaFai Lau
> > Sent: 01 July 2021 21:06
> > 
> > This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
> 
> How does that work at all?
> 
> IIRC only setsockopt() was converted so that it is callable
> with a kernel buffer.
> The corresponding change wasn't done to getsockopt().
It calls _bpf_getsockopt which does not depend on sys_getsockopt.
