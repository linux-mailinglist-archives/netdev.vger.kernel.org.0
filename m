Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE5A3BF681
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhGHH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:57:38 -0400
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:16865
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230494AbhGHH5i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 03:57:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hixg9fBihafY60gNUcC0rXQRX9JL2miIPoxf7EnwHoxkyauDjQWchA8xjaGxqEv/HTvE3rO/gwuK5rUG5+UMAgete2R4HnBNvM+fiOsEVcoj+SrZxFij2uGcrdn2SxPM8cPh4C70kKyYz8UdQB6lK5UeS0dQEeNr8jbnTGxaWpR9yZwUj7Lclg7b/lC9VGTUFBoSZlLdrKXIfQAyQFuQAWQ0W7/NveK+TmI+3S1H6cDFhOFrUHGF1iyJCuTfHrEuPMHWH5gVuled1Re1JW4TcFPz3kmr611JNrmEegI+yghtt2mHwSvt1meIEtsi43kTXGH/9cDjrsbb0fvrgiBGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7/exfssAZ9Fl+DS0gkEA8Ywcu4t+jTLDQw3T9DoGQo=;
 b=CtL8Lkd3A/ENNmZQnAxyVriWcbm56PQc90Qa9KbjVrqYyNptPxlMVpFlQr8tmnGn57u/n58+KVsdkrceZC4FN4M+llzR5hQGm1yD+SazZ0mqOeEJaYc7e3mxvVBVrt8ImwBMsTbgdMPf+0/BORIS6nSFU6V26d/QXcUFOTjAlRkDjmrJ97+JiqwCwr2KaEyM1nxPVJQo7KwyMVTkNs42GtiNSrLg/3IcHgWe0ceaNpQXGsAAUuGB3n+2anQp19sqInM8c62m/vlJ1Hrm3dt26V2DXU8/qTTkyyseP8FUek0lBaNvokVNDHLUAMSWqATLBsPILjEjxUuNIjVqN17c0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7/exfssAZ9Fl+DS0gkEA8Ywcu4t+jTLDQw3T9DoGQo=;
 b=j1nVFXgq79U7eYxV0p6t0u9KJVCArrcMbLPot44xTQ6o4C0gAfL3B+YHDqG82I2jN3HePkAWfxO4IAqbH5uPvO0zMyRw3kpFAZPeqCRJzFMWonLYJfqvYn9Z1zzVeendWwbxFxaP/7vZ891N5hkMrktPZzQX5RIrH2Ymhxy97voqqBzpEBqalUvjkOaop5GkxO5RubUW8mdT4fdIk33biVm26l27JiYTIq1f5aB2ajAR9KKlCHE/GKQha7Y0Ygx2OZdo8XB6PfZj1OTjDM8m2Wdet8H6JPxoXNOetiMi7gmNnRZRODM+NlgSDirhWPAaSi0ee6zC7DBoeD9xCCewbw==
Received: from BN9PR03CA0002.namprd03.prod.outlook.com (2603:10b6:408:fa::7)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Thu, 8 Jul
 2021 07:54:55 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::32) by BN9PR03CA0002.outlook.office365.com
 (2603:10b6:408:fa::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Thu, 8 Jul 2021 07:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 07:54:55 +0000
Received: from [172.27.1.80] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 07:54:52 +0000
Subject: Re: [PATCH iproute2] police: Small corrections for the output
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "Paul Blakey" <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210708074728.3686717-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <e11e07d7-456a-222c-c7e7-508119ee0ea6@nvidia.com>
Date:   Thu, 8 Jul 2021 10:54:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708074728.3686717-1-roid@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c34dcded-6bb2-4510-4bc5-08d941e5ace5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4230:
X-Microsoft-Antispam-PRVS: <CH2PR12MB42308F5956E6628F1B1E5378B8199@CH2PR12MB4230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ghr8HdTToFJEB5GxFBpSw+fSs/l773BbDC/HouEAvUsKpJ71xYXrYc48NNi9agk5A5XBGWQKv1oJ68+Y9qiPVerECp9r7s8l/x9LqmndzT5x+dgLqrrWDTxI7Bbvp2DizgDMsxRca/L+K0+khy2nywSjXcN+FqsIWKfzi9bsgnu78mTyEYE7cd/VoiTTqCQnQYjKySzdqh1tebPxG46aWh+4g0T3LtjQsIE+Iq7PmjpJTOtzF8D+odJLXp9u6G2Ls8vkQFYGtfikcP0ifxt5RXzH2zi5dArE2gQpvuUcu56CKRleknZGQTMaRAc2qJJNozyVr9HmCwTsThvBMo7+QpOArdtlPm9YGgTOJAZxbN2KrD7HinXSAlQSVh7tQ68DM9ZyHp5skxvGMgz4xCvr6YP22i0prffeHcWDdP4hbhGBemZWv3p7SqSpUCe2xu8ZuN7StAf8UDiX279+vOjsNskUOMUOCMCjoKIElAJht6zwpwhiNgP8K8lkPoTUEjphxJo4bqhWW12QK+N6H09z1vLEa5zhZvWVqENJOInWRLTqO7l/XCyEaInG+pkmjk8THTtgsfeapOE6gz0ejtTvYQadan1gVRydr+pnRy+RcfS0ViV7YR0C4lBC/aj9a0xKc2qbEc3r7wCMWNYXAFoYVEa0K7olc0Y97X7rQQaeXtWWu4lgxr8iMUAvW9QRAQov/nYntZ6ibSJ6y5JwWBvCNXzgFmDT/UPdydb5bMszQXs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(36840700001)(46966006)(82310400003)(6916009)(36860700001)(4326008)(356005)(478600001)(186003)(83380400001)(31686004)(31696002)(47076005)(82740400003)(2906002)(336012)(316002)(54906003)(7636003)(8936002)(16526019)(36756003)(86362001)(5660300002)(26005)(70206006)(36906005)(426003)(8676002)(2616005)(16576012)(70586007)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 07:54:55.1881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c34dcded-6bb2-4510-4bc5-08d941e5ace5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 10:47 AM, Roi Dayan wrote:
> Start a newline right before printing the index.
> Print overhead with print_size().
> 
> Fixes: 0d5cf51e0d6c ("police: Add support for json output")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>   tc/m_police.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/m_police.c b/tc/m_police.c
> index 2594c08979e0..a17ab64b1ce5 100644
> --- a/tc/m_police.c
> +++ b/tc/m_police.c
> @@ -301,7 +301,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>   	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>   		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>   
> -	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
> +	print_nl();
> +	print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
>   	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
>   	buffer = tc_calc_xmitsize(rate64, p->burst);
>   	print_size(PRINT_FP, NULL, "burst %s ", buffer);
> @@ -342,7 +343,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>   		print_string(PRINT_FP, NULL, " ", NULL);
>   	}
>   
> -	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
> +	print_size(PRINT_ANY, "overhead", "overhead %s ", p->rate.overhead);
>   	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
>   	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
>   		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
> 

sorry forgot also the newline before ref. as Stephen Hemminger
pointed out. will send v2.
