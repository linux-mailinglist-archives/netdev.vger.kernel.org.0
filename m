Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D4F2F37E7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391723AbhALSFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:05:10 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44916 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727219AbhALSFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:05:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10CI3dVg030635;
        Tue, 12 Jan 2021 10:04:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=y2u2aHGb2MjJSbVkb0XjOwA/OR8jKDm4h+pnNA1z8+c=;
 b=R9RjvRF3iprgt7kNAEkWV2n5HFNHnFOaxWcSd6C1o2BiRPOFA4pz+XVrm8f6yNjGLMzr
 TaOHt2K8v+jawaBNNnM4uRpOak9cj0ZHYF47wFvZkEe3bO6B+RsSBIgLKS6TNk9bpos7
 MBu8w0uuXSDNDw+2KT6kC6LG6iy4wQK/AHs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpb8ef1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 Jan 2021 10:04:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 10:04:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEj0jFA52AsHsicqNGICpfrz6KLqKeT4Ep2DBFtl74w0H0VRfoBTNmPMgVll8F8tA+fClT/8ijWnqdJ2gCYdovfDzfuS0unYdAKF7Gp+h995MPb6zAtnnUjMlrPZ+E2CjTJw7Wuu/4doTgz6zPdVWzo6oXmABggtqwJiBNb4CRuyv9hk8jYfrsqAoKYF8mzg/XJxaME104+LfZYxWUU6w7+KlExgtNK7U7QtOFeEGm2QX///n4wuhQPWKW0ggSLrseCXbpq1ure1ZR15bI114SoHC0Dr/tL1CdiC71yOLfYUTUHDg+oyDRbcjJuGGCbbR9kSA65rwu4ea1TdMGMmuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2u2aHGb2MjJSbVkb0XjOwA/OR8jKDm4h+pnNA1z8+c=;
 b=PD+7obNYX2+aNfIQAtktL3g19JiXYZLvN8JqJn2xtGHw6jkQz0SwJc/8pZM2cNIuNG4fwMUb3YmKNbDjIraxF4h1Z44YRr1+3eeCFqabdyo/Jj52oewI0BOqy6wQeAnmsdY9aOLhBuocU9DCQxayFHfI72wQorl2ai8RNrGq6ABkKuGNwTjpHvm5R0IS7bYp0WJm0uraSQl1ivXxHlQfSL1dFy5LatmpuqrpUKbD/HbkKk0uj0NPFOTT+z3rZLZqJ4UjAE0lYDVvHodPXBhyCuvjkc+bm6kxyV8X4OLI1xLCN7ciWCcxtOdDNVkf3EtoYP0OHgwduI1HytjhRBAapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2u2aHGb2MjJSbVkb0XjOwA/OR8jKDm4h+pnNA1z8+c=;
 b=j1t+amzNg0pMhcWsAk68jv3MY0jRRJr4yPloLae2Cnc5k1RywBaXbaJykQa5bB8ozvb46uswBqUGallvJf2AUfNrLObsh1MlgYIPqFaTFnTycn7DCRt+qxvLNbkkqPOPxM4ZjLeVpW5NRWK1485zqUYc+7U2Icm2O0k0WOyF42U=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB4294.namprd15.prod.outlook.com (2603:10b6:610:2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 18:04:11 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 18:04:11 +0000
Date:   Tue, 12 Jan 2021 10:04:04 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v2] bpf: don't leak memory in bpf getsockopt when
 optlen == 0
Message-ID: <20210112180404.qkvbvo7tixf5wcv6@kafai-mbp>
References: <20210112162829.775079-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112162829.775079-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:bc5d]
X-ClientProxiedBy: MWHPR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:300:95::27) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bc5d) by MWHPR13CA0041.namprd13.prod.outlook.com (2603:10b6:300:95::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.3 via Frontend Transport; Tue, 12 Jan 2021 18:04:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04d8e09d-a153-459d-3c4c-08d8b72476fd
X-MS-TrafficTypeDiagnostic: CH2PR15MB4294:
X-Microsoft-Antispam-PRVS: <CH2PR15MB429483AEA60A29E296995502D5AA0@CH2PR15MB4294.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1QmNzX9P4CFgBp34gaX0scPJ7BD5AHydjsOFHCQvoHL1KCC31RrxZDQUmvuNSYMEdQMoi4rMwT/Lgu4eWDbVBotoX3NnC/NZcSpAzEMqJIQ+mBEStcDVm3h4zOX14EKEtR1PnNgjbyu6j+PFiUfxPlzW5CG9nbpo9qTT3PXcoENKQLGIlohJx7fXtKOLcFTKFFshXmsK/yvzJVcRczMA6XESisYwOnLMfaz4TSJbe8vPSusmLg9w7XSsOueFkWvcUvCsNViTmEJY2dYJLcLrvaNuaNjdYcF/cc2yDj2QrLtuNHL9cH1Ry189L3ypVq6R8joRcWcE0kbOiwmc5n7ZEhfrxUeR3CN8PQV0relAutdh8dm7Z5HNfJmo+Z7lEB/OoMPaXjjQbYeYwCLh2Ai5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39850400004)(136003)(4326008)(6916009)(6666004)(33716001)(52116002)(8676002)(6496006)(316002)(558084003)(186003)(16526019)(478600001)(55016002)(9686003)(2906002)(66556008)(1076003)(66946007)(66476007)(86362001)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Knawh40T3uQDXw0K4aTE9bEtXo8ki+Zk1TihJkgP1YuavWwCF6AiwEuMGa1q?=
 =?us-ascii?Q?VhokYRBvXu7sikIYYn/XugRSK69PgwiLioySdBjX23m2p5andaHnTiHRI9nu?=
 =?us-ascii?Q?QzzTx3Y9m0+jC7AGvInPQRBJQnWOVFlX0Ljlfgk1fG1zH+4zkYQLUk4/Tiyn?=
 =?us-ascii?Q?Km7oqHj0rsOy7k3+mcaMwmwUrb125o2cy/eln4eG2/iz+mvBCl3zJcYFiy5D?=
 =?us-ascii?Q?moUf8IobpsLo/TDMNYWHxk0BclSF3ai7/uvneIFd+jd7sF+nEMWiNaiwTYcE?=
 =?us-ascii?Q?WAbBFJZERM2NTpK46sNr/GehN6guuQrMgaQqEmuIwZIR7neeT5Pd79iRp30F?=
 =?us-ascii?Q?deRS2k30XZKFR9AgXrDaxNSSrkYI0NbMynB5LlqeEBh7KieLS6Cv6SvKcchJ?=
 =?us-ascii?Q?qQJz76yPp6ThLIcncs/d24PAYLdDxwayxonxekfOre6HyoCbrtCacdbx6+Gs?=
 =?us-ascii?Q?K6rg2MCQe/V+XIzAvtuN9qEF9rpyN0Va7IM/kqlalexqqX43sHake7uGyvCG?=
 =?us-ascii?Q?MfShG8at1j/h8QZbAdtnpbqq6o5i91kvfH8X/BeFehPcY35qymfAPI5yr0LW?=
 =?us-ascii?Q?/DZwDFmCNdwGlXkjZHXXy9zMtSy+bU05LSU1G1AUWn6ysWaUfJXnOB3Jgrue?=
 =?us-ascii?Q?hSQYHndKkvghzNEq9JkRoodPouvFZsuSfAVv2qN5yOjiLvFAC+L2K8FfMYsM?=
 =?us-ascii?Q?4ayMQdCeVR1yTjyjJDppzx7+k29679JqcCDGMSrIawDiPq0eOt4Ugzb3TW7c?=
 =?us-ascii?Q?/p+SE2oSKTNcRTdDkZIIrXXBfmvW/jvHrllXJNzgyNf5wPPXrKDQbu7ERJfV?=
 =?us-ascii?Q?LqZASVhQbxXShAvPY2P2zfM+9Jp0fM+d50Ujw+PhXGOu8hHbAyt91zJI8zfW?=
 =?us-ascii?Q?3xLlZZAAaUPhtj2SAzF+xc188vfO2zAUiu5Dwc+CATqpaEF+vVwOgIcJAuxL?=
 =?us-ascii?Q?JgIWOfxLV7yv3WM/XtnhTh0dxssEiQKDrirtDK3oCBA2XTEcREtVzm4Qlhs4?=
 =?us-ascii?Q?19M3QQSal+2VMq5Gwmj5d4YCig=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 18:04:11.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d8e09d-a153-459d-3c4c-08d8b72476fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MURbsyVSO2hRIZGikYA29U3HIENRIGnCa5gzbB+2b+T6bhotcTkpNd0YuJY9EICv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB4294
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=851 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120106
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 08:28:29AM -0800, Stanislav Fomichev wrote:
> optlen == 0 indicates that the kernel should ignore BPF buffer
> and use the original one from the user. We, however, forget
> to free the temporary buffer that we've allocated for BPF.
Acked-by: Martin KaFai Lau <kafai@fb.com>
