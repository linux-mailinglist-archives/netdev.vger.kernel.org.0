Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8040327DD38
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgI3ADv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:03:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728192AbgI3ADu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:03:50 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08U03X7f027540;
        Tue, 29 Sep 2020 17:03:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YrLaMBxcJWSlpJ3qaG2c+LrVqvYdBUTtwtdL87Q++34=;
 b=G/3xYd6Hq75pzohM/PPAk7eytcG5SUu0jGE39vIYrq2uOPVdkrTizlU6tcBJmoI0AvCQ
 Jm8j3bb1D9eDj7B1E5zvWzihe3NgyNT2bmNk19JfQ4GP+zT1f2Nn2ND9IT4Am4JxNPOE
 zCszo3HeFKbEX5/W5S7uQj/z4Ke48TqzQFY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33tshr55e7-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 17:03:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 17:03:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2YF1n0B91kUHT/D9pXrgMiOgEr9aoZqq80Vgp+DImpDI9BCZmfHb1ZoIUWN8oIlVT9WsTBDnPOlMrGGkWKtMAfoyckoDM2Jt6hsgS0ergXgVaByqnJhEyBG/hslHlNizk//MxUA8VIFlJMbBoKoB/vSgrUvq74kP6V0TbKOVsZKShUu2nT4lRAjlrZQceqrEj0dKDxaMDw6tFsWKie2MfDqBa3NB2QDeG6m0f7XCNcpqZv0uB/LQLHih3FOdwY+d0p//M0o3wN8PKgf9UUMgn9NTR+wpyabxebW+Oybr8ixlBaqY/qqVp8mAIF0BQ9dyrxUleY6qAaPONjTDWlr6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrLaMBxcJWSlpJ3qaG2c+LrVqvYdBUTtwtdL87Q++34=;
 b=YsN3HQEL5cCerbBmQyfJywf4wDetyWjQMKlphv0m4p7Lro9B6T0RsyQrd2yFV+A+BenrBZ8Oo99UFVtK+huJPsi4+g9I2tcS6C5IcYUUv9Nza60VZr1efpuv9LYg7wkHr8UZmoouxZ7keFj/OWmJl0iDe/Pu8gWOXSKK50WMmbnr9OtNiVcP6vOtMX7habpWhwdSOWbhmgsNdZHqZZ2rj5zPHz7Q9JTs3LhLD+8V7CAewtipdO63vvmXKkGlrOE1cXXHUzRkXIwX1EhXibY3vkpnGHlr0A72Ber6LrDLf4WB1JmWmWzSlH1cMx5PoRavZXUCWCBRVTsD7dcKI1xUmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrLaMBxcJWSlpJ3qaG2c+LrVqvYdBUTtwtdL87Q++34=;
 b=E0D8Et45AFgfZqNjh6b7OkwD5M2WlwGIJP8Q+Rh8ycpcWntWT6I5aT/+Zob2O34eyTP60RGEqtOMhrXR9c2MD94HOdtwqEH3cxAv5QuyuzW5QW6SRtCzmRJB2pn9lu4uOX2iz3kwpwbC+V+y7esPGRtdlOgRH+ZkuFhI9eYTJzM=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 30 Sep
 2020 00:03:23 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 00:03:23 +0000
Date:   Tue, 29 Sep 2020 17:03:16 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/3] libbpf: compile libbpf under -O2 level by
 default and catch extra warnings
Message-ID: <20200930000316.ifjq5vn3wtsth5s3@kafai-mbp.dhcp.thefacebook.com>
References: <20200929220604.833631-1-andriin@fb.com>
 <20200929220604.833631-2-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929220604.833631-2-andriin@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR17CA0050.namprd17.prod.outlook.com
 (2603:10b6:300:93::12) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR17CA0050.namprd17.prod.outlook.com (2603:10b6:300:93::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 30 Sep 2020 00:03:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9bce8ba-45cf-4e31-a81a-08d864d43f33
X-MS-TrafficTypeDiagnostic: BYAPR15MB2774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2774CB593616DBD6C9B5CFB3D5330@BYAPR15MB2774.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/NDst7U1GMS+puzNhEGopCWYbjLIZFB1Emqv7efbIdgfOLKeEbGd6RrE46fZfFAPf3U4nLftKrjKSH6Kz1RZCKvoAzJw7Jpvk3l/T7Rq5pQ2CQwbneNWARF1yzAqes5VLccAk+zjflTfLRHmgx9jRbUc06/GWrTCfJPxpCe1WNKwPrISxIF5/26jzUguZwBqqNmDfynyH9dX2UjmXYb+Xy5QKkwK8Vbey9K3KI51CncfqpisiRNyeL+vs8EEkU9VSMSPzTUPab9zCAO/CikJBwFUWzfDQNV3bdNiwCTn+BJna+rzzS/95W2J/0pZgIcueu0c5OnKJ8yttj81aN6szmzOdFWipzO6fANiRDt8EBu9jYgbrRbSbAsUsssZXwp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(396003)(136003)(66946007)(316002)(52116002)(6506007)(186003)(7696005)(4326008)(55016002)(9686003)(6862004)(6636002)(478600001)(8936002)(86362001)(1076003)(8676002)(66476007)(66556008)(6666004)(4744005)(5660300002)(16526019)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8XhX4523wO/CyxPqCoq4W52BP+GOwln0oTdPoNCwcUCZBoelib1O5JdPU10T/0e1FnHRAXxS0nSXstkBMfjyVa1B5oIJZVEhyqr3Pc2QrD+j1HiJVdVbXAyAE4gHqNT3BR5hlMjTTNCDM8A0tA+kW9XKLBAHn7P4OVCba6SQYAW2dUF8hMdcYRt1qSx98QvXH1P5p2DCm9thhG1rUjVZaqjW9FqpE5lqykp8KD+9OKM2qVeL43KYj00Kizdxmsojop2fAkLTGeYP8vtqO7FL88TsbniglFcqxvfG3Gj9MIhD9hGrWku4nGAwUrXo3rBftRyNaDYVEewblxq//e0xA+NrGsz60uSx1jDeql/4kbUhxgT5Xlc8TjhwEd5BjZCUiuZkWuFuM47ByP35iyiUK9DnbB8BSot+SqSf8P6a7AjssT1pX9avu+sMBxzTZwA9BleF17ciDyQJaNsDdObj90hnNuRo2+F4MAsV4drka1ZGm/YpvPj7x+Bm1wdySdLaffhV23+BtGOwrmQw4DmvJDF2GpJMYBlH2sPV+6eFGmndWCAbyolOKaxNJxK2E6+D3fVF3svWpsLeWJ+0S4LRijb5IFprc6YP5C7KiW/j5+p9DUWEVsRLKoBg1/IVjmzpcbA5I+ke9cFBU+MJdlp6f3OzPnJNDBXqUHxYU8Ch3WM=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bce8ba-45cf-4e31-a81a-08d864d43f33
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 00:03:23.0098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQakbSK0QEH8wJwtcCScCTjoiGlk3gpY8NcHM8dXhrbW2cqlOtjrynp1cpytawbf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 mlxlogscore=819
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290204
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:06:03PM -0700, Andrii Nakryiko wrote:
> For some reason compiler doesn't complain about uninitialized variable, fixed
> in previous patch, if libbpf is compiled without -O2 optimization level. So do
> compile it with -O2 and never let similar issue slip by again. -Wall is added
> unconditionally, so no need to specify it again.
Acked-by: Martin KaFai Lau <kafai@fb.com>
