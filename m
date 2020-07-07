Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B42176C8
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgGGScj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:32:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728272AbgGGSci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:32:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 067IWVlw020142;
        Tue, 7 Jul 2020 11:32:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qrMYpKMKKD3x0zLPdvL6fEt+Rc0WS26BEjGVPXs7C3Y=;
 b=fmUYY5ISelhdBRCIEEcoTNsewY0VpbIR0CFx7n0MLNa30lsWuW4mjwQW3ZJyPqaLS9jB
 0heDzcOr/XnzOlvxhNyt574FnCKuErfsCQXraCaKpmv7fpk0xNcil0O6YoEECDEf+bf6
 Ivut45J+tOJTnkfuM2xJ2+9gLhy25LsKCO8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 322nekp1wj-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 07 Jul 2020 11:32:35 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 11:32:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IShN2Wpxsm2UxTTME9eDHz4PK2TwP+9dY5ETxLB/yRwqQ644b/LK2lbvwzqqY0otBvdevEadhZ9G2OJ6sa3B88CiusOsjoly1j5gu9z90dq50fxxdxZ7yrVcoo+Ma40FUw/8n6RTy0zTq1SUB3i6DjACB977nI51zBoFDvqE+Ai665lo4qkwh6nZ29RSVwYe2kGR1AnmjgQvWb6n0/jSQ7Cvy5vEllmu//EbFcrlAJKsS9DgdXd4D5hFm4X44Gh+JryUghxOSJWWh3qUjkvyI5kGp2ndqBnkfXbG7OeDWn2DcAaoEfc2/L1AOY6TphMYTLK8vqSlOuHotXdHUb6uuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrMYpKMKKD3x0zLPdvL6fEt+Rc0WS26BEjGVPXs7C3Y=;
 b=QqivrzPCHdB34wGpSZb2QGHJH1ZTyBxAW0lcKRiCofmAwBGjEZNCljdj9JCLEwK+ZFCU48zE0szQxQCBfyZfB/KcJto2nulKi2V5hoAIJW5huRtwVF5a/Ycvo6msj7/4aS8RN1+QQ51/gosPJQRdoY9Qy3YGe0v+QyqsXmHmvtxeqOTS7JVGXNBQJ8utlCyi+TAjJSD11ABBEyhfHk9Q8fvXZdSx52euwu4j0JpzR/anV0cXFwylTog9umfavbte7zCscBkSoLHkahl8+HZYA9Do0chLfEIdxsYyRjNNlxqvZCHV1RwxDbZbDWClrWuHfHELxDOd62zrdRQNxFMBAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrMYpKMKKD3x0zLPdvL6fEt+Rc0WS26BEjGVPXs7C3Y=;
 b=E08GjNovGCV8y6rf4MynfTKLeUpzO7stihl+yqYD9rlznn0R473wU7Ze+hu+c8S1mzfx5cVUi+wlYQN15FAEU+7nsCkER1adw2l37qZUk337vm97G/1zrcVkws0cixGmM1jnxwrRxyHZSSDHFAK1Axofna1YJjw8X4RcMwaH6TA=
Authentication-Results: katalix.com; dkim=none (message not signed)
 header.d=none;katalix.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2824.namprd15.prod.outlook.com (2603:10b6:a03:158::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Tue, 7 Jul
 2020 18:32:32 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 18:32:32 +0000
Date:   Tue, 7 Jul 2020 11:32:31 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     James Chapman <jchapman@katalix.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: bpf's usage of sk_user_data
Message-ID: <20200707183231.hfxtzfpfcf7g3jwp@kafai-mbp>
References: <20200707093730.GC21324@katalix.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707093730.GC21324@katalix.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR20CA0006.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:6c3d) by BY5PR20CA0006.namprd20.prod.outlook.com (2603:10b6:a03:1f4::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Tue, 7 Jul 2020 18:32:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:6c3d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a30dd510-b7cf-4178-1d09-08d822a41c8d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2824:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2824DE927131792F127C83C2D5660@BYAPR15MB2824.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:549;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N07N13blLC43dkH7LAy5CmvXlxR9kSIn7TZv/7KD7eIsueTrwqv8onJJZlsn9paBnG8B1mwW752uFck7MHo3IrUECpPRXAcTK6tgNy2+x5w9UmtruhI1ZiNmc8kN7JUIeujjZ+W3E7Ttn7sTdmXcMFwE3cZIrKaTPl47w5NAtHI701gxQXbkgFj8fEXWYvOj9hBGU8foKlneWMn+lwWzFb3sjGgDszeE6qmtBBTQ2F/FsTIBBH5HFi4AjFWo/0jXcLRkmvPI8geL06/6AIqJD61xGEG2wQQU2m7VkYQhOkYoz6Jnl554OX8L/+hQA3hWIH8D9RrAwKsuHv7Vzucmq4vn39pz34PMsB10qY6UJyCqE2VQArot7PqVCy+1hW1INIH3BqHFcO8pH5OmRciZtDl378YdFlUNVrehlVb6q/G6IDPL8aWGWHxsd3lPL1he8A3anqWmcxFBNlMAKLXc6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(39860400002)(376002)(396003)(346002)(6496006)(8936002)(83080400001)(86362001)(66946007)(33716001)(66476007)(66556008)(478600001)(55016002)(316002)(9686003)(966005)(1076003)(8676002)(4326008)(52116002)(16526019)(186003)(5660300002)(2906002)(6916009)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: abu1NPOA2lq/j3oKnU+JQ+E56fhWiDdKY4iQ0gKNJU+iZ6UzYPMaUR+Bl65xkKbREcBir8dRUjP4mEODZOIhaZlp61YjriHon8D7Y4RX1sf5/LvSpLQnym/ong99foGBBZ0wVUhK4jzHeLvf2jSPbHiElhh9C1Jg+xJs7BvylGRzQZ8tw8vnBYdYB3mgmJbgAaLoVI45mpcDAPaDX/DCLoObzTzAoPuvv9kGa9I2waPWm84Ek6UcoMF+mb0fiaTDTgqvehA3oOD7jf1mHlZouSJFrExKvYBRUlWZdvNriy0o9pxfT6WTEJsAEZ5bdb61E+edFcwNG8b+xWx0lqEPnhYcBdepy1HTzcTx7mSNXxG0TB188IzyH2sezwLgvkhXuexWJrELXMsYVVG+lndp24q/vvNUCsmgm8X+FqF6ce8oLaewdBh+kzA4W0Z2XZHbZcxl9SJIOptpvZ6FC3ZDvxZhSkeGrfGOA6jxM9tqJ/3aEMBJHLzcovj8bPYVMtSkr0c/6zRpiMtHMJ8qfqTccA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a30dd510-b7cf-4178-1d09-08d822a41c8d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 18:32:32.3415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H8iij9jCoW+hDY/KV7JANR5YLmfF5VdvW/wL/AGE4LTjHpx0pg0LF6ZDG5mwp+PU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2824
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_10:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 cotscore=-2147483648
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007070124
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 10:37:30AM +0100, James Chapman wrote:
> I'm investigating a crash found by syzbot which turns out to be caused
> by bpf_sk_reuseport_detach assuming ownership of sk_user_data in the
> UDP socket destroy path and corrupts metadata of a UDP socket user (l2tp).
> 
> Here's the syzbot report:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D9f092552ba9a5efca5df&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=p6aRc9baiGL-RnWqirYKbVXROY5Qc1x4T5-HWjxEp0g&s=mPnfVsw-U-eTV_dezjfYUahIbSiW8wEg4jC44e-mris&e= 
> 
> I submitted a patch to l2tp to workaround this by having l2tp refuse
> to use a UDP socket with SO_REUSEPORT set. But this isn't the right
> fix. Can BPF be changed to store its metadata elsewhere such that
> other socket users which use sk_user_data can co-exist with BPF?
> 
> The email thread discussing this is at:
> https://lore.kernel.org/netdev/20200706.124536.774178117550894539.davem@davemloft.net/
I have replied on the original thread.  Thanks.
