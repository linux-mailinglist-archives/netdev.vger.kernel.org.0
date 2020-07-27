Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F0D22FB8B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgG0Vje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:39:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43136 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbgG0Vjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 17:39:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RLcrJ3016134;
        Mon, 27 Jul 2020 14:39:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=pNA1Q0t8H+NTlWRNPqgWurYyGMT9+/750zTzrpP2210=;
 b=ZONTcrHucIdCz/dTvfYa/XgHRP3beP3AzSyp16ItvJrBdEDD+yI/bAnC2J8kpuWGWnZB
 o/5dPH1DLv5o33egoQ07ZReluS2/kk3s2pGfKsiZs3DRSTCpCvpsKTvk3eisCc/MXK2A
 +objrDIyKNj9M59tIfNkb6t7BPPO8RZuoXo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gjjes1ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 14:39:18 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 14:39:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRAHvcZAxVP1vkMEC35Yk4EySDutvlbYs3tUAXG4qqajyUF1j5NS4jIygsjcsdve46fzsCddl6ys4PtDTlFoEkD9KCEjXqVoLTyiaCXG7KQnhAVNsVYCwTwG8Bd/Y4aoEgPrvUHgk5CjAdqRoYGSIdyFZo5zhOvMtJAhTfWAE3Wx8jMPPlo5px0ak+z6LCcpcpVs+HZxrBFk4BjFGISum4zNhvH4e0H5p5adSLTmCScDtspDH8xfFplsADib6imiAoMLwxOPEJF2+VPukfopkPgmApnbTdJMRs9RtJWr5LmztKtjIrxGeCfvYBMWjpB0ExmQUa3E9fChrUk0Lfj8LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNA1Q0t8H+NTlWRNPqgWurYyGMT9+/750zTzrpP2210=;
 b=h5yCrnAkEu0raXQbKEYrx9vtJ9CwjcKuZhxhMIQn1iFP3EIwSwKm2rqIhedAa3pNhrApb86okyv7Ayw66JnK7WB9xB+Ymb0y9LpfIFBbFi34V+WWOGIviPvw+0d98Co1vK1Nfhxt0K+VcGAmQ0RPb++t0gPQ7vHuwrUl+QQEyp0Pks8eef322s8lRzxfh/EftSVtxVMm2BepIUAGEm3hXXERWjUUwoeqh9dl5QU+2G4y1Kxiq5LYu5/7E+U7qRv1m5XsSWkSbqT2leNw3xZTdlMQ1BV9zf9mKdKTPblhsXCEApjT73EQTYuxE8MkwzvRpWKndijLyS4FUtzSDv2MPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNA1Q0t8H+NTlWRNPqgWurYyGMT9+/750zTzrpP2210=;
 b=eLMGf1xK8ckMw4I1br7VV0oPfLI7o64BoFB31eLo5L9dxYoVJuzTX8HG75Us6w3FuYlkH2SmOLmV/HfuWdufZs/1e/UG6tUTKHW2gmieanqMH627D4TUJ8uUAUTwxmdVcFskCU13fFzqfgNlxI6KjzyZvxkFWEma9zbQC7rbJik=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Mon, 27 Jul
 2020 21:39:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 21:39:16 +0000
Subject: Re: [PATCH][next] bpf: fix swapped arguments in calls to
 check_buffer_access
To:     Colin King <colin.king@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200727175411.155179-1-colin.king@canonical.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c9ea156a-20fa-5415-0d35-0521e8740ddc@fb.com>
Date:   Mon, 27 Jul 2020 14:39:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <20200727175411.155179-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::11ef] (2620:10d:c090:400::5:402c) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 21:39:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:402c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 224e1d55-abc5-4166-fba6-08d832758325
X-MS-TrafficTypeDiagnostic: BYAPR15MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB33660481BFB00FD8F3E6B1CED3720@BYAPR15MB3366.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vQsRXyyWxdDSpfjvqm+bwiXPWMA6rPvEFCcXQHN056X37io9CV6N1uC5U3ED+CiFbcqOaHuzOMwV/bP0SpDGjiAimMfgvrtvaaXephI4kaxoDX1wJi9lyppkie/SJHX9/e1krCDHCoiv5TKCmxZQ8AbtuDgQIT5kh90uQ1VgGoCu7t/+nIGgnq/fdDPeMHUDEf0AXc72eLGN32bTNjptfNs04IurBgepuLWiWTK7IIIP1RcpPuIfh0ZmPwAgJVxyI/Kn+PuH35eXlsrafKOEz6ylRyORB+fD8Y4apYDY5lwqeBi9++pJTP1ttu2a/Ekydp4Sb8nHodFWQuQVApYesoRa//dHcNxIt7GBj+rftPNmMfR19NopCqdx1zwxMhtrM1G7rP3rRqnlWcdkP+rWkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(39860400002)(136003)(366004)(396003)(66946007)(4326008)(66556008)(52116002)(8936002)(66476007)(2616005)(31686004)(2906002)(5660300002)(31696002)(53546011)(86362001)(478600001)(6486002)(8676002)(83380400001)(186003)(4744005)(110136005)(316002)(16526019)(36756003)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QVrpsA/UWYhsOPbr50hsiy/6yScDsxEB4JdUAX19TFzRj5DPS7LdTVuiqfwfxQz0G2Pg3eAB6g1bEHrlkyFHkEM2eR2zV3xDJ3dcsAaX1iaf6WU7GYQXKWYrCVGQpTK0VYTW/aol3uYxM/DyFCoiXZGax0KqIGgGQSxrQzbEnOBLx72umqo871u5t5i1P+aFxAMzppj+4uijHqbmgB0qITA1dhsx42ULOOS7TF+1eLU1PRFcU1gI2U2umSG5OrkGyt7dB9D2/7UslITqOt42FnaH90zQzwskr9cduqhJZ3jqGSoY5QWM/Vgq3RHxHiAycUf+BQ8/BwTbn7w1200U5fnAI5xLZIT4oJPDXLOWUEzXhb6EjpEVXWpZ6q+gHipeIPhXVGtMqHHkcV7yunMSlEnI1JtRRWEeLiEBFfdISD4B+lOxn/9aIg39VhaT/Rjv2gCylNeZhk+G0zwU1H6ZRZwQHgPmGD34jWMprd4iUl3V3Bt1dlSconVQNzx9XYJsjrrbunFdyySxL88+sjrMpA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 224e1d55-abc5-4166-fba6-08d832758325
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 21:39:16.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mObefGI/SaRKtQkXn2KG0ObUncbBtoYit8gZ7N5H4xDlAnyyNxfvme+ZAf3s4fqG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/20 10:54 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are a couple of arguments of the boolean flag zero_size_allowed
> and the char pointer buf_info when calling to function check_buffer_access
> that are swapped by mistake. Fix these by swapping them to correct
> the argument ordering.
> 
> Addresses-Coverity: ("Array compared to 0")
> Fixes: afbf21dce668 ("bpf: Support readonly/readwrite buffers in verifier")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks for the fix!
Acked-by: Yonghong Song <yhs@fb.com>
