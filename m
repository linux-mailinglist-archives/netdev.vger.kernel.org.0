Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D192493C2
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSEQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:16:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSEQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:16:24 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J49QlV022211;
        Tue, 18 Aug 2020 21:15:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y2pOw7r5+0LZeek01xdOMmbEFToUq2WUMhMMxSeVkj4=;
 b=gliU6axfQiKrmNJwgFnDuVdRMawTAhPFZxuAgVP1BfBFmnhgQwpoCj+mThpk7XkfDJK5
 KSJtcivQD6HmTTzEy911SvnmxtaTHK6ETpr8Sp6qfeo9I3JOU7SpXztdXowfoaFovqhz
 qedVFY+svGZqUQofm22Ry/PfTtZFJzWYOOY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m2xm4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 21:15:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 21:15:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8B6pXj792wggtllvu1KA0Hwhs99kfMawoPbvTVdytEzD1pttX3UJBRgpaiprXe77Bwkl1jHYm1oFF7TvaGS1UsKl/6C3FmAlhXjVxFO/g/RzXAs43PoKOCrrYFWz6hX8xDjxCSYz0zUwYwshjbG706JZSBcD4u6TW5Z5htrRZVb2lpgYjNvGKXR7hlrI01mwrNyd/eqLN56o3tuSybsuVt/+mz81WBBCTaKlinQMAZ+7aeeA9azdECLNDthX/YXQ1QXdAYRhKsSjqQWoycmeeEB6aliI33TGT/Bk5iFZQV0O1Njm7OREbBakEf7kdBBJWH7JiOCzUeYRAmT+kadSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2pOw7r5+0LZeek01xdOMmbEFToUq2WUMhMMxSeVkj4=;
 b=NMfRmBIQTS7JPYltX6QhAZYwb4HVyGNrjZeQkwx9guuw0oJoWG5gvxHx4OF2lyYo4phUwjjY+B+qOPbh2uaFseT3rqkj25E92oGer0ZdScaYIzOK3uf8nf2wnkHHwSlDe+aBWFNDOqeykjgHvarvmUYZZiUYd+PXT1KEOV9ZjDuxdiEHUHNdW3LDnWKv/1b5ksCojfXW9dQm6DBiSUE/DOdnk3DC3KnYa9+4bIPsRNBpKa07TqHKGSGm7mx9j46/Fo/eTDoFrMYCtU/tX7zksK4gRGHoVjehtQXAOYCVpdGnvQQoig1dmkfyk/v6/Z5k3AUf6j4wRc6f+gtx1pV1MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2pOw7r5+0LZeek01xdOMmbEFToUq2WUMhMMxSeVkj4=;
 b=TJDoAMnsniNjQFxo6DKXEZUosIiMMBLd/Gnx4Nsy7J5D8D/7huHSGAYMn7aoIFNo3ZJNC4wHYJaTSvvb2kPzh7uSBTrzuejVl+X0hpNuO+GNrm18jpI3JPVmAoQvkVdy8uTO+YtFGceYrBCzxG/BgWt5pFEVmpHc2HO7cELQBjw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Wed, 19 Aug
 2020 04:15:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 04:15:26 +0000
Subject: Re: [PATCH bpf-next] libbpf: simplify the return expression of
 build_map_pin_path()
To:     Xu Wang <vulab@iscas.ac.cn>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <20200819025324.14680-1-vulab@iscas.ac.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5a5f8fb5-3e9d-18df-a313-5809af347c26@fb.com>
Date:   Tue, 18 Aug 2020 21:15:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819025324.14680-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:2d::36) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:374f) by BL0PR03CA0023.namprd03.prod.outlook.com (2603:10b6:208:2d::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Wed, 19 Aug 2020 04:15:23 +0000
X-Originating-IP: [2620:10d:c091:480::1:374f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b935535-5e9f-4eba-15bf-08d843f67fcd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2840:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB284043084F93476F173DB936D35D0@BYAPR15MB2840.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhLEm36J/o7nDaMzHZkC/u3lFARO6R/EUL251g5psN+xV6rhekdjK6jxBATc6MwMv9vea9arAk0obPOEEBl96qOXs45Em794gCazeo3+UcffDo/7kMSgsBE3aD3ysL+V4uiuCA55d+TIXiiJDW/8O5+XlkrShd86HN18Y4ovilgQWHaTqUyDhi3kwerxk2f//jkW88xZL9CoVmq9+hv58hljBUaLAOgweEagkw9rhA7TT27nGiPncrRu9vPKznTJqkTXCi+zNYa7L4UK8b2Ve+67smHma93AhJL8FuFBkLHTLk1ZA1/AB+ibht+fAJf3UdGzAsQcAMb0kfEObnVvXrxMVaz8PEj2GAY19DkTgg0BnnPCkGLrZ4D6rkTx5pS0gDfYuvOcw2MX0NyXtfMZjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(396003)(346002)(2616005)(53546011)(8936002)(31696002)(66946007)(5660300002)(478600001)(86362001)(2906002)(6486002)(66476007)(316002)(66556008)(52116002)(31686004)(4326008)(36756003)(16526019)(8676002)(558084003)(186003)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jI6SO4vc1Y5ERo3VsvQm9SmuE0RzYTzKQPGfy0ylTtJIzh4YtBCI5zKAIIupk+Xgzdc0hh73jKaZKxQdo9lx9z9iqV+xEFDFa1pEOqpQGMcUlmlY6+MxadSCyYg9IIW7LgMAErKJuuN7HsAV9MYpcSXs8k29pNFzieAoujBM00KLRVnsinLf9w+jC3qR227JxNgw1PEbBX61J0dhP9RVsQjVwERpGJEXpO1UdGSsFX/N+5Krz9A4qUuvIeyMJN4EOPr9ImlZHWF47np324x4+iWyO62BFqsRGxa70fNPW2oL9Q06Yr0gL6/SyKrkgZnAL/hfQxssmM8RtWk10ttLLTkiIFm3i2oUfp7f2ighS37Vgj02Osuiu5xgD1W0gDSjkhth6dmb751d27cdpk8uo+GJz3DOboOeK01T2Xsyz8a8+Pb1W6BITFy/EAwltzLFjlCzo6DXJsfc2gFLOKVGGWg9itXC9ZqXU2IX6xCFMGVP5xCDXXzS67iizEwBxAilfUZ7TQ1z4FpuMg4qL3tVjlL90jUZr99eYYOtYtKMbybNzd3O8LuakvaMTW+6gNh+eyinsjgMiu9SvoRpnzR6fI0uuRrHMtUxkQ1ebT6BNHGXshw3rz9vgcg/rh3zh4Q0jI9NICcy8tfFVwkJi+JnfIg88ud7ygir0NPiCq6fGSg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b935535-5e9f-4eba-15bf-08d843f67fcd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 04:15:26.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7oVURZe+ZnZtfFfHWaeN/u5h+5dccZrtLBxhG2CodZ21vvRdxx2xjmxBLsqEmKQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=954
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=18 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190036
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/20 7:53 PM, Xu Wang wrote:
> Simplify the return expression.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Acked-by: Yonghong Song <yhs@fb.com>
