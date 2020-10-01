Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA47F280B73
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbgJAXxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:53:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22084 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727017AbgJAXxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 19:53:13 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091NpsFr016464;
        Thu, 1 Oct 2020 16:52:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=CR1fqMrCSX4AzNOpfdak4n2AggaTPypdGDrA4BjqDRM=;
 b=LY15fnVVNerXh0Pa06zrMQ5O8FVYxLpoxMYuounI5hoBikZl0B1FcmMzDqd4RWfLX5xb
 OGJGgLInLNEVrBDIMG1HrkHJQG6l+8OmigROviE3+43Vh0YsHVZHXsWUgD+rQJ2dmDO4
 0HFk+9hscUrganm9cTFYu1asAFBxSuivrJ4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33vwu3gbew-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Oct 2020 16:52:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 16:22:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLC0GJcuAYc4uOk6fEtOWaAtPOXsHzT3fpQ1D7UUZj8lDB4/LUaupW3pP7CoPXxWVPKMQO+bEEiM0lE8/tSlLAGuQ4Bv2lBApVYbAsDkrSvaSwhep4aCSi3nM8DeIFEzPtXyteG51hPe2cSloTI6LJqJeqZroOrnUD9vWdpMuDbft4AvCxMwArLpvfUQ29HN1l77i5LG5w6ySfKPSjx7pmCJuhjsLU5v10eO4jpFrNDmuGzS4hMQERnoNTrtMZePhy7HBek4fQKR2qHS/pvfjidDEigW8AjUl0Q1l3aTLIk0TCIaVUSkfsiUncf1vVi1/aXM0iWbH2EdWNevmPlKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CR1fqMrCSX4AzNOpfdak4n2AggaTPypdGDrA4BjqDRM=;
 b=Ju77W5Kp5nneznI40R3d0pJyYXZrCcR8q5ERuETd7TLZq2ooybaVxKNci3I18N6SUGsZOmIt1mpmgF7aW1Ku3a9gF0gv/77LVQCAQPsKJqSgmgop9OyChl2xRSeJ3b2H4uolg6Fp4bolI8RYA9ujNGPSuWiYuCINDaWjs46gCMSQHvvyr54BLEcE2nuJyAzjqvlDUG/HicFzx+UoSSCV0O3eOK0Xr9jop3REqnhO5BytBV265B+x/CXdspBBCb+mZLMNJc2Y067lmCq6vhkiBB4B3MzxCEK9YB4YvUe9xCbG7weQvmMeEBF3O+2zZ0BZkCLWyeLYbT0ULOKE2lWY+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CR1fqMrCSX4AzNOpfdak4n2AggaTPypdGDrA4BjqDRM=;
 b=eKM21GN6BjNR68H7s1UWD7p6PswHwN6Q5vqXORW8hgg1H6n17Im4jRjvbimFmSKIgAsZN8hS5KyKck9QV2H4KG6IfQPAQWAcCNFtJO290LM5QXXdE70YiBBH8nFMl9sT7rFMnbaBzEKAPyMhfKAyeKaUhPFP9nT1rPXBaskaCDs=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.28; Thu, 1 Oct
 2020 23:22:43 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 23:22:43 +0000
Date:   Thu, 1 Oct 2020 16:22:36 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] selftests/bpf: initialize duration in
 xdp_noinline.c
Message-ID: <20201001232236.5plmque7q23uv3as@kafai-mbp.dhcp.thefacebook.com>
References: <20201001225440.1373233-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001225440.1373233-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR18CA0042.namprd18.prod.outlook.com
 (2603:10b6:320:31::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR18CA0042.namprd18.prod.outlook.com (2603:10b6:320:31::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Thu, 1 Oct 2020 23:22:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4947c728-fa8c-4631-34e0-08d86660e58b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3094:
X-Microsoft-Antispam-PRVS: <BYAPR15MB30943410944AAEBB22B78DA7D5300@BYAPR15MB3094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mRQhYRiHxzKxmHAYnIx4n9LHEp1g84v7ThJ/xfyrKeYhgZ5S2I+VKm6FTOBkRUbzaTjSvHglmJHsco0Ee2iHDUpeOlLcQVlfta2kpWEl0G9bJCqgcSd3sRj7A/UhHRQi5f80TDy+XrewOcflPlqK+CNGWfeMnfx0KPFfMPaaUzVVEyGcEsU2fBTa4YBiBS0OpOK4vjgYKV/6f75XoJOnaG205WaKoRbzEN4E4+VpEaGJKvPGgi6eoqKxWhx1Hl0u1Zp0932NL4ARB/F5QzLp+2Mi8SDt2roNuDEAhwcZLfZ5bSwXjYA1c5jhSlb7aZsy/osYAYnCsyoL7FQvQ6SRVaYtQv+Nuljmdp3Nbm/0hnoGJVl73ajbt2PYhmWGHoKj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39860400002)(366004)(16526019)(52116002)(2906002)(83380400001)(6506007)(8936002)(66556008)(1076003)(186003)(86362001)(4326008)(66946007)(316002)(55016002)(6916009)(8676002)(5660300002)(478600001)(66476007)(9686003)(7696005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dhm4IEv03rHQdLF1fUBXJHpCqOlYZ0PvyiLmH/5x7IjUSBtL0ehszvy1gL20VlZ7PNl5M4Qbv6RN4jW72uQVNoKSz8R9QryY2fT6oHhURrOnoE2jRYCAtXinHO4oMHv4NM/bc5vaFScSbxbI5nvBBbjtQa4QEJEj/pxn+JEmfkoTFKQRuZNAIrrIsPGxtfj50t6Zldote2wCQOTVDKGpeme4dYC7o3Rin57Tg0cKorn4m8SJ70weaxKW/maNmXnlJnVCzcnk6NBZ/oNQ1zTNksyeWUkZsqYERUw5kBmT/Rb/riboRHYjoQGeeZJ/grr90NOxYHZ4bfh5T5jYgr5P4Pb5+iBASV5z8bt6WjgoQkuE2x8IwM8L3lMjEsFNyutZlqncOLGFdj4MwUbjfKkxw2+rpPi6F7gcBNXrely9c/Cio4j1j0UZOH3lUhm1LLMwV5to3edZUInq8jWV85Cj9Lyu7ZE+dvO04CGxmSoHjF/2MtF/FR5R36Entb9lYX1+BFO4ClHwA7ai3irrbcTt1w6HyqQuVnr2MmgFVhkmk+ql+sT4pR1XSSPidYy5kk2OsGzwyRmXGFBAqN54Rs88LtfEHtcWWmhcRwdVWIjDcevqMXBpCM6zy/ej421xpQc8E39QsflhOiFfrksWxBjSQpM5mxz3DDl+wnE7a5H6lMTtF98arAdYiZ/HINaRwNob
X-MS-Exchange-CrossTenant-Network-Message-Id: 4947c728-fa8c-4631-34e0-08d86660e58b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 23:22:42.9682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT1CGkW0iXGyshTXi5aDk/gT4B+C0Io8PkVopDK024l/iABGsKc38hj7zqICRWsT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 mlxlogscore=626 spamscore=0 suspectscore=1 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010193
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 03:54:40PM -0700, Stanislav Fomichev wrote:
> Fixes clang error:
> tools/testing/selftests/bpf/prog_tests/xdp_noinline.c:35:6: error: variable 'duration' is uninitialized when used here [-Werror,-Wuninitialized]
>         if (CHECK(!skel, "skel_open_and_load", "failed\n"))
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/xdp_noinline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
> index a1f06424cf83..0281095de266 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
> @@ -25,7 +25,7 @@ void test_xdp_noinline(void)
>  		__u8 flags;
>  	} real_def = {.dst = MAGIC_VAL};
>  	__u32 ch_key = 11, real_num = 3;
> -	__u32 duration, retval, size;
> +	__u32 duration = 0, retval, size;
Acked-by: Martin KaFai Lau <kafai@fb.com>
