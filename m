Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9321A2847
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 20:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbgDHSNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 14:13:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52870 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729693AbgDHSNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 14:13:05 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 038I3DJR003141;
        Wed, 8 Apr 2020 11:12:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TuykCKxWbXWasOvy49ixLmXNGEjYCF1xyotadrlK9Pg=;
 b=mU98SkoQVjH8loSJQCGza8N9YBCllZXMCieTGEeLX8b5ChkpoUYnrBMagrZ4RJCUeoUx
 Cghwb6xsXaw9Tl8MDRDAvsYXIi54cOBycA0IXzotBnbPtHpr6sziidM/TmTxXQhMO+cu
 QFUqwyyGJnwbfdOCEw0c7Thv9Kkuj6tU1cE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3091mvwkad-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Apr 2020 11:12:51 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 11:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOwaEdoBZ4pIIKYGwLNb79MRxyRp3139lRmHKxmLnataL302d0aFzNBZwX2UXQwIpiizBpOA7zXnYUo8JBT/GG/qdpmYVUANiOcl0l/6YvcRGNpYliDSWbKOb8Eh3QXkLjr0r+9U8EL/yseTFLYnCNwmQDQ/VWqjCFrmy9VlDbX2gUnNVc+ukZxzEH4PjbkD6PT39llFJ1BqfemX8k4xPSu52VrS0W/7wH4T7ltaPdtygFY7otOA5pJhIpDTcgkVOe3fwq1doLEOXA7v8rqr3bBnO0lvJFRkLd/qCH8fSkQmD3FV6MlGbwz5Q1XknfvCU+7YoowhF1v3K9K1Cu5ZDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuykCKxWbXWasOvy49ixLmXNGEjYCF1xyotadrlK9Pg=;
 b=eAl+9zw63Ht7vAD74DzD9yUFc+hniGILD11FZwL1/KQAVAXKZo4l2SAOOBRbzYSK+5HCIlz2DxiSiasSa3dQUc+4h9psNn4lCosaznCZ57EPs8nTVpafLL0WEhkqgimm6QKHuXicBVbkCbEhvONuwg6eyAn8OGr0Ijc4lmBt907iDzoEF1jUfjeXGYMnybL4h+A8/YpKzEsZGA7Kb8BZ33p0XH0H9D/EBr4Sk6q9Gdg8dAp2V7mfHZHVNZ7gQFeim8pmbChrghX2/LuygoM0bdYAT01vIyN3c9MJxE5YnQQW2rN4o2VSSr987IxnQvxbzc6/J9nTdq/MZW/OWAeEsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuykCKxWbXWasOvy49ixLmXNGEjYCF1xyotadrlK9Pg=;
 b=TQfrXeaJXuI5mGNnaQcr/ICEvxElhvidCll6tjsBA9KrBhS+hq9mcZNNOjbfSZZG09Xd68ZCMGZMFIjJ5+1uymAIz9VQPO7Els05SpLDQwOgkskAE7nB4I+zy9xSiHCx3h0uPb2KBKMm/XX1//ZuJSom5tMsM1tImIELIdJ2eTg=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4026.namprd15.prod.outlook.com (2603:10b6:303:50::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 18:12:49 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::9527:1ae5:c960:f4d1]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::9527:1ae5:c960:f4d1%7]) with mapi id 15.20.2878.018; Wed, 8 Apr 2020
 18:12:49 +0000
Date:   Wed, 8 Apr 2020 11:12:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>
Subject: Re: [PATCH bpf] bpf: Fix use of sk->sk_reuseport from sk_assign
Message-ID: <20200408181243.abadjuapq7z7tzpr@kafai-mbp>
References: <20200408033540.10339-1-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408033540.10339-1-joe@wand.net.nz>
0;95;0cTo: Joe Stringer <joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR18CA0045.namprd18.prod.outlook.com
 (2603:10b6:104:2::13) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:9fc8) by CO2PR18CA0045.namprd18.prod.outlook.com (2603:10b6:104:2::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Wed, 8 Apr 2020 18:12:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:9fc8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b65de89-69ab-44f5-94a2-08d7dbe87220
X-MS-TrafficTypeDiagnostic: MW3PR15MB4026:
X-Microsoft-Antispam-PRVS: <MW3PR15MB4026EBD9FD57F6F8D119CD38D5C00@MW3PR15MB4026.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(346002)(366004)(136003)(39850400004)(396003)(186003)(6496006)(52116002)(86362001)(16526019)(478600001)(316002)(9686003)(109986005)(4326008)(33716001)(55016002)(2906002)(8676002)(81156014)(6666004)(5660300002)(1076003)(81166007)(8936002)(4744005)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMvi5dbp08+7lJC/8LVU8BWrgxfAiHfHuTY1YLG7Q9sfIfTnIibIYrSTn6lnsfN+cg0zQB0OS2mWC394DN7ROOjInBU8RqTibfjfNNOX9nRwf33LWMnTjFwj7r6O67w1AQKATaRCp0ETF/yw7k6s3NBAzViG4kIq/bws2WI2HNWgBPq1vyPICesznMMSbZ+aP8eaSvimGGRinKkMr/jf1Xg295tn8kOPjLzPBRsQk/ZBf1LIMz9C/K8UYwavtFu42GY94Iz2WAhG6SzaX/IIul2RbDotzz6cLkct2CGhPqdSjLUsIbBLgefsVXT1nYQvSDJ5ehq1f8mZ9Xchvf5UBgc5p0C6MrTBQ6YkRs4KbZw9r57TG0E7O/QbPmbzSJqupz00VAuLE5tbbGQqGbcvXwB36bCrkU+OZurozjsTYmMtDb4rfc2KKBqeyMpZVHZm
X-MS-Exchange-AntiSpam-MessageData: 4YLamB/W2CJBuH5ArxmgisnXDgWAXt77blcXrmAGI4YnxDhiF8R6CesKOcZKQJfwYNrRwfj2UFEhKM78JyU97lAMJ9mqCLc2e/pzeiFKogKJT6tMMqWirbmzFRlxuVT83qocjsMRFKhZAnBwWso5UqaI3Bi+ZQTPRWgur09sd50kBAHasc6HMMNW9dwYQs8j
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b65de89-69ab-44f5-94a2-08d7dbe87220
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 18:12:49.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOO2TI+cg8umUzK6RR8Dik2mveoQGtgT1d+YstcXmFZhaptYO6nnhVtEjZgTgQ6w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4026
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_10:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=431 lowpriorityscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004080133
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 08:35:40PM -0700, Joe Stringer wrote:
> In testing, we found that for request sockets the sk->sk_reuseport field
> may yet be uninitialized, which caused bpf_sk_assign() to randomly
> succeed or return -ESOCKTNOSUPPORT when handling the forward ACK in a
> three-way handshake.
> 
> Fix it by only applying the reuseport check for full sockets.
Acked-by: Martin KaFai Lau <kafai@fb.com>
