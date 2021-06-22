Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A9E3AFCB7
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 07:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFVFqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 01:46:15 -0400
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:21034
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229677AbhFVFqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 01:46:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKFCD0OU3j896XfE2RicMnTvpVdDJBqPu8b63SHnbql+9A8qCUYrXi/oWrN9ysnaDvMj/W/giaWFJG0Sf5UvRLiENjGj8lDABVaNimtzJvZF4d1SMZPdkS1VmkNKFXUa/wresHDnTodG2TI5+P8bxlLxUP3a0ilxS3Q2qG2T1Wvfot1/sycOf9XGisWmGcjUDlawxPsbbzZH60iFgGMh52hrGdZYi1ljZK0Iaz7KGBD/bu5LQaIxYzpgdcMb2zgnc1mgvOozScJgE02n8bTJxcFfyW/ubOmLY103e5dVuePz4qK4WN7ozTIJnyatAc17r/Ybd6o9WaqX8QMJ9xOikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jApwSK/XtLYbvSES1mDjjAgmIKWW9ZEbjikG0tVzok=;
 b=KGuxK3hSKeynjhP/PyUGl+RIFFgV1mJIBBFqvJaaoNlTLg76ggUA6bGjcjrAiTbJoS3Kumt+wijSAkZFxU0+UMDmtUFJAdqtO8UrLKaHHTb14W0Ub+wNm8b1raUIoxyUhlx7YlR/msoY6l+uz1IM/7O5mnbJM0zj/818NeZCkHnP9XEswzo+zT3tKe7AE+x61M3MlAJx7+bxzjrze4DoJKUqMnMLfT8acccrzR9EdiubpcvB6k2ZKPVYNBjtcBiR1vpU/mGUv+mpRi66JZywjuQeyAIValuuSzvYCYd2u7c0NInKqApwszrrglGugrcGISHFcrqLrRZYRAn5nJdPRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jApwSK/XtLYbvSES1mDjjAgmIKWW9ZEbjikG0tVzok=;
 b=qoVthc+ugLfKwwl26vjA9SFqkdHfLoizTpHM0SJSAfx9krSTk6uFGzNM5XLWUJssR1USQszT1hAPSvptqR1WL1JNHb4/y0WdqeuG9zfi4oHXol3+DF9+K+J0gIgc4OImkWZBqfb92LpEg05Cf1jMaPjbaM5doEtgxqXLfEgab/M7ZlPRXt0eSLgn6mKtV4pKwd6DmceZbTZoHaYYFDDOczMiFHaqO465sbUAJlQb+lysqquj7j1cK/qPGTBYkNdUv9xLDC7ouEHIvtNVIHIozF2XxIQXviFFcwyEQSN/zsKPK6nD3vPZ+YyxYR63UJaDy96ymf/WvxRPlf7Pr1Z/gQ==
Received: from BN6PR13CA0046.namprd13.prod.outlook.com (2603:10b6:404:13e::32)
 by DM4PR12MB5390.namprd12.prod.outlook.com (2603:10b6:5:39a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Tue, 22 Jun
 2021 05:43:58 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::a5) by BN6PR13CA0046.outlook.office365.com
 (2603:10b6:404:13e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend
 Transport; Tue, 22 Jun 2021 05:43:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Tue, 22 Jun 2021 05:43:57 +0000
Received: from [172.27.11.84] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Jun
 2021 05:43:55 +0000
Subject: Re: [PATCH iproute2-next] devlink: Fix link errors on some systems
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>
References: <20210622054250.2710106-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <495243ae-a3c5-72b8-b76e-bc71baf57c84@nvidia.com>
Date:   Tue, 22 Jun 2021 08:43:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622054250.2710106-1-roid@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fe836a7-8b88-47e5-407d-08d93540bac1
X-MS-TrafficTypeDiagnostic: DM4PR12MB5390:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53900D1471C964BFE97712C3B8099@DM4PR12MB5390.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:235;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UiGvqvPsdateT+sfG3UEHelMudUVKjZNe6Xen/aHBIJ53OBi7ulU1Fh6beZkv3HOubIOBdJ+JDNXhB4EwYbdZnCvr0cABh0XYsQVjBcK5l1ex1XBu2rBvxodVC89xAPLTCO2lhvBl523bQZq842yAfo7znZ/Tu4W76Zwifw7TdWvNE+REBJ55/VxuMG/7sVQNdLhncwJap7gmTTCZ1trQuck42K1wrC71XcT/7cUyE17m5qu73YZV+SM+nXTl2sKFNyMFYzCYDPOCtgNtTfr59qGYM7Jbz1djLlZBFhxKN1erDvxXMUSG/O6mVSNXuaHWWWqLTyxH7ZWYvioKJrwAodE7C1VHEZpYZvk7PuPW1SKqwHurULON5K5k7dvBUzrR6Ynp5MdKKtmGID3+2WVY6ojk1rFs5cDnhO6oebBjNd/6QFLX+jMjKD+xc4VqyyHWXbGWPPeC5HJ10mehH1klsJJSpDPcW0HFt8zwwQq052f84tjAA1x/6SZNXsxbHv0Y9dyVoqOSq7Xxu9ALbv2gEIXSdYJHrVm6KNSqUMlsK60WfJXrz7YppL0/sshjNoYQp/300TYH+Z4dcvlIs5C/hDmKzQ2E4T3L6zdzjTCn7+zMImGomHBlRkRP5wLT1KkjHQCltrmV5QPlArirMbYhMey7XpuVv1nulMQxBjkfl8PWs1/FsWL8CUboQHCcF0b
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(53546011)(16526019)(186003)(26005)(5660300002)(54906003)(478600001)(316002)(36906005)(16576012)(426003)(2906002)(107886003)(4326008)(36756003)(336012)(2616005)(31696002)(4744005)(36860700001)(356005)(86362001)(82310400003)(82740400003)(6916009)(70586007)(8676002)(7636003)(8936002)(70206006)(31686004)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 05:43:57.4613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe836a7-8b88-47e5-407d-08d93540bac1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5390
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+jiri

On 2021-06-22 8:42 AM, Roi Dayan wrote:
> On some systems we fail to link because of missing math lib.
> add -lm to devlink.
> 
>      LINK     devlink
> ../lib/libutil.a(utils_math.o): In function `get_rate':
> utils_math.c:(.text+0xcc): undefined reference to `floor'
> ../lib/libutil.a(utils_math.o): In function `get_size':
> utils_math.c:(.text+0x384): undefined reference to `floor'
> collect2: error: ld returned 1 exit status
> make[1]: *** [Makefile:16: devlink] Error 1
> make: *** [Makefile:64: all] Error 2
> 
> Fixes: 6c70aca76ef2 ("devlink: Add port func rate support")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>   devlink/Makefile | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/devlink/Makefile b/devlink/Makefile
> index d540feb3c012..d37a4b4d0241 100644
> --- a/devlink/Makefile
> +++ b/devlink/Makefile
> @@ -7,6 +7,7 @@ ifeq ($(HAVE_MNL),y)
>   
>   DEVLINKOBJ = devlink.o mnlg.o
>   TARGETS += devlink
> +LDLIBS += -lm
>   
>   endif
>   
> 
