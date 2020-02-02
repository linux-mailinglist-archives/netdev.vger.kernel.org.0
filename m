Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA8314FF09
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 21:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgBBUAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 15:00:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38072 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbgBBUAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 15:00:10 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 012JxTN8009453;
        Sun, 2 Feb 2020 11:59:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AwVHMf0ZBIJd8j/skzLv4MvW44rKFaSF/6jyTFiRJHI=;
 b=DL9H/zp4ekYiK9xsDNcqV60MfVnXGQ04zNL5RqCZEhLfoGLqfwkI53BvKxuSTPcBfXaY
 AvhJNB/AWM3aU8NV8e1GeHjxhBRPzBwucNUtmFvE3BVvoHIoc4jELerwRNxk3w9l0eSl
 C8uXmbWFPnKTzjQJX10tbdMTSjyN1Gqk10g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xwsrv9hvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Feb 2020 11:59:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 2 Feb 2020 11:59:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJMngZ69Sko5ThnRu2Hxc1nZ5BO5ctZ1Oh/Z7yXNrO7iNguwtNH4e8mBOEpW0hucQ2HrTZxF7VhUpfg2iFCfX9s0/Xd1rs3Qt0bncaDVneuozAZ/st5+IN5S9lDsIjdWlBe8ie6mckPBO+uVWyEp5imq28EBOYuw7JDvRKXPru7KhBt+iP/fWBy2sV/sR6Djo50y76AmFqsO6UOMNQPzMbeViLFn5UOq+j8PrEqWT1JWXY5cRx2PcUyNSKHSgN2Tc7p+TBRlXGrxLHpHbYMIa4NTAc69d0aBjnYmd+NT4YdgICJ2n09RssBrP9uhm3HHYFtD1+FxcmakAOaEx5EOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwVHMf0ZBIJd8j/skzLv4MvW44rKFaSF/6jyTFiRJHI=;
 b=RGlikupYYV6J9P9iyaqX2uHXoTYj/n/WzmWmA+GNvR5uqXyyt8P5UhrqpepJuF/J7UP9ydZ4dnLenysdGzw3O4+IQizuaV4OQ0huSR+PvYpTrjE1f+cmDvCiXRKI8cfR/UcSbwEP5ZPsp7yaz8tQfrFiCRWTrFgCRdE1K4VymCIQsNc3j5H5pDOzoOSjHhC8GuUXksuoV54hQpPXU/olQp90nuyrJ4TL7dpU48QFxZUdrvk20bNwcpl5jOn9YTzXpOdXeFCbDBLLAzNHuoOmXE1TpeiRYy6XYzAaoPmu6mIvp+kK/YneAaM7mkT+wDqd4kBguUDayq6MIGi3/inB0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwVHMf0ZBIJd8j/skzLv4MvW44rKFaSF/6jyTFiRJHI=;
 b=jzS/qgGYq3yiOJhPgqtDsbH9msG7t6MW9tE4Re7+h93Y3i1B2gwV2MzBbtSE60wpao3+D4T5VBPl7XopMQR2+iOtwx8W2ICyduMZPGQTttSnhdx/FTGj99SIlIsf1HDjSAicjThZ+nL9Rk79MfnudeuHa4rs4YXcXrwFbNiljyI=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2857.namprd15.prod.outlook.com (20.178.229.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Sun, 2 Feb 2020 19:59:47 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2686.030; Sun, 2 Feb 2020
 19:59:47 +0000
Subject: Re: [PATCH bpf] bpftool: Remove redundant "HAVE" prefix from the
 large INSN limit check
To:     Michal Rostecki <mrostecki@opensuse.org>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200202110200.31024-1-mrostecki@opensuse.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <95fd964f-04ab-5267-c958-25b5a5231030@fb.com>
Date:   Sun, 2 Feb 2020 11:59:34 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
In-Reply-To: <20200202110200.31024-1-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:300:13d::22) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from MacBook-Pro-52.local (2620:10d:c090:180::76ff) by MWHPR20CA0012.namprd20.prod.outlook.com (2603:10b6:300:13d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend Transport; Sun, 2 Feb 2020 19:59:43 +0000
X-Originating-IP: [2620:10d:c090:180::76ff]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b10ffe9c-be12-4fda-ee74-08d7a81a7475
X-MS-TrafficTypeDiagnostic: DM6PR15MB2857:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2857579AF3499CAD3F0ED0AAD3010@DM6PR15MB2857.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0301360BF5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(136003)(39860400002)(199004)(189003)(6486002)(5660300002)(316002)(186003)(6666004)(2616005)(16526019)(8936002)(36756003)(4326008)(6512007)(4744005)(31686004)(54906003)(66476007)(66556008)(2906002)(31696002)(478600001)(66946007)(81166006)(81156014)(8676002)(86362001)(6506007)(52116002)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2857;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ypdpgb5MUkLjo/LL/FcHu3gMzzjTe4X9f8v0BG7JWafiHHURsiMXf+LziA67qcl6WqSR1EmVRAecYzGdu+kV+3XrPfsa8G0uMm4Gcyxpp/F7TILEq2h52cp29dcIubIloaTkU5Xtqw4uA/O9gZSOWd5JgkwxtjNhTNVvXvpNzY+KY7x9Ke6Qg6OBQbzPGigyMdCHsdD6mIAu4FiMy9ctkp2ubAWVkPSfJ6Aq0FOzqwZfXQzKgO25+hvcGyVqneaGGs8pJh4QXu4ZdTHC9PeQJv1ZF7oWLQLNZe2tX0MHztwgSfXM670WoI/tyA1IcKxW5ClBCqXkRQNiuv+gbafPOizlrmFKhFF0DO1MKeysptxJ6yrKEbmGxze8bP+LjIBA4JuRtlNweJZg4GhxZjvafIIwcQzR2xBrkDhsguOV9+m7UynLdzGR4RFy7Gj6GWMv
X-MS-Exchange-AntiSpam-MessageData: WFYRoOQPGCIRRQyODl2N4VVv102RQ0l9e4VukXMyoIlNEEkrtpZIjJRq2fpzAZ/5NlshkHdfFLDIdLyafCwOFcHfTZ0CAuw16YSire4mCLrCvW97wKQ0S6vNCVXhxPUpcDRFzpgHKTcsWux/BP6IU0rRrZpdNdfiN3lLm+nhcJo=
X-MS-Exchange-CrossTenant-Network-Message-Id: b10ffe9c-be12-4fda-ee74-08d7a81a7475
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2020 19:59:47.3955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /TZtyet++NLfOGbyjtwsdD2lRrSKTu/XOV6c0Y40VDKz7pMTM/wt+7RFYHYXONfF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2857
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-02_07:2020-01-31,2020-02-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 malwarescore=0 clxscore=1011 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002020159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/20 3:02 AM, Michal Rostecki wrote:
> "HAVE" prefix is already applied by default to feature macros and before
> this change, the large INSN limit macro had the incorrect name with
> double "HAVE".
> 
> Fixes: 2faef64aa6b3 ("bpftool: Add misc section and probe for large INSN limit")
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>

Acked-by: Yonghong Song <yhs@fb.com>
