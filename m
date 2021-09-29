Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D049741C591
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344177AbhI2N2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:28:48 -0400
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:6496
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229846AbhI2N2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:28:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SopQUUjKKmWehp9/Po4GBq9wjcXYagtrXTnXLPg8qkFSDhNzqVmUC3TrCCLYBelECHk7ggBjOPHTiYYDRcen3ENw9NlENfTXbHd44pHSV3N+d8JZpBWnBvUCH7ruguuWCTtii7RTr64JFurQib2iVGltCiqIHHhsTH2/pum/UjVNjfdQCdiqcbciI2AGDaT+I4N5ts44JIZjXSVrEIKtYBQFMkQm11Evbq19J7TOdzOWk9t4h/qJsyLlA7GuKK6uZfb5qCrn2ofPpwspfFqDwVCRuBGI7R2siqRNrfJLNg7jGoBr0qqQ/4YZB7f1iH2GmnpdGGFzSVFIy7kEXPFesw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZqSAvNtWdfLXwX07aABQ8OVg/GsMy6vHqsPVY4vNNMU=;
 b=P7c8HcCxGExMsH0nC4ufkmQ5FI9LfszbMOuaeElNmi4tTzWSHOqHvUdA3V5KkcxJ9TUmTUwTUOT+ShXukiBTJZQqgHqrnSVpuVp0eKN8a+5wR0N7LSaCUD13d7hMqIdXQJn+9yYRUr8iIWaK4GAvEzXPvqFNrVmB1Zr31LHxUfDKRH8JiPJaqrBgtDwoVg8hQtpTCnRsvQOU1tUNa0EP81B8zuX4IeIeCVuAlqfg9bVXfoYJkJaqpblVTR4SfmwuInUmSnnWgscHWar9hsGdz4o9v5onhDQZ+Dkb/vB2h/uj99pSj2SZEazd476hVEJyIHmnUM2rf9DeNOMUGPipGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqSAvNtWdfLXwX07aABQ8OVg/GsMy6vHqsPVY4vNNMU=;
 b=hh6Ld2P9G1IhAN4NVMRhDXFExkSbYneg/L8YeotXyiFpyK+quBheOQv+zTkHSwod5LkVaj5+m8dUxBKPrsycp6aho+wN/GK4nxply7TjoZ2YbOhWMYipfu2Zya8C2xbJkgHTwNcBSqWbS8acL788dKrI5OByAalGZLi0kvScKc98h9Pk2tAv0NpeFNG7YApfEpDNRtzLDQE0dLfC8XWAUR3M3iym3xLRMsPR2Uxt4be+9pCkCmrlscI8Mjd0ok8oLAmgj8fhh4BTxsiX5gjnl0w1Xpi/mXxbQbmbMxon7/6qYVLBp4blpTV/+eELta+D+gMU/WRigq2nO/sS55y4gA==
Received: from CO2PR06CA0075.namprd06.prod.outlook.com (2603:10b6:104:3::33)
 by DM6PR12MB4986.namprd12.prod.outlook.com (2603:10b6:5:16f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Wed, 29 Sep
 2021 13:27:03 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:3:cafe::bc) by CO2PR06CA0075.outlook.office365.com
 (2603:10b6:104:3::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Wed, 29 Sep 2021 13:27:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 13:27:03 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 06:27:02 -0700
Received: from [172.27.14.186] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 13:26:58 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
 <20210929063551.47590fbb.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
Date:   Wed, 29 Sep 2021 16:26:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929063551.47590fbb.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b7e28e5-c5e5-4d78-1dc1-08d9834cd31c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4986:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4986D3F991AFC79EF025DF52DEA99@DM6PR12MB4986.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBVgrJNAi4KQ0iM3aqB49o1Q+aofJqCVxTxnb/t6cRCGp4HS3pGT00NK8DjUZrYmooOdVqTi2WpZSImoUfFOaQrAklH9UvVFW5zPkQrQjABhr8eA2o8ZNhSlmEVzasYoF8tRpVodxmR//RNrAPKXeWg+feIWJBEa8EwK4BSlTw8IIaa6R5Jz5tMnWsa7sinES6wJD4aQaqTY4xGQVzepVxJArfqXEIx27gdWse6ZvmZYp2FBKVkuj/CSOM4JB65zHEqgHPvjdT3Gp2Zy8JD4+CsQkaPt5FHuZyCKLn5p2qiBsXL52Ze4uyaWyC7DVmMitB9tfroDmXPD/ik30Kqwk4N+Ck9xPuR8/Z0+TOwV0tOe6kmbeWyIjvbsbyEBtIa81kY0VUPjbgg0rbag23vdSH1Udc8jlceseaFxfPoYF3nARFG4susRlSYDxtxF8fjXWRN9bTnmQF+vCkxRA7rd650nO5D/CFJCiYHaIGtfS82moWY5zmLkHy2I+j2HUbLG1n9EbFb1gg/+Vgla0gPGXrWRhaWvwyRgBYbaj+nBkZO1sjUh7w5osu0sb5pxukmqTsBhTpbIBRCQ4vIGKID69PDKOIMfehzo6J8OmCJfE42Bad9IEsPvwoJfjMR4AIFxx+uQ5S7pod8HgUujX6VwoWVj+0Y25gxVNmqTi8sVlXebqD6jaK6mzQAl+5mWhBwPZNvXvnsWmBjV0m3xUBrVkJItM3V622ItTweZHjPqDw4=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(2906002)(70586007)(36756003)(336012)(316002)(356005)(7416002)(5660300002)(7636003)(16576012)(8676002)(31686004)(70206006)(426003)(6666004)(26005)(53546011)(186003)(6916009)(16526019)(4326008)(47076005)(82310400003)(86362001)(54906003)(8936002)(31696002)(508600001)(2616005)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 13:27:03.1034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7e28e5-c5e5-4d78-1dc1-08d9834cd31c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/29/2021 3:35 PM, Alex Williamson wrote:
> On Wed, 29 Sep 2021 13:44:10 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> On 9/28/2021 2:12 AM, Jason Gunthorpe wrote:
>>> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:
>>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
>>>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>>>> +		},
>>>> Our state transition diagram is pretty weak on reachable transitions
>>>> out of the _STOP state, why do we select only these two as valid?
>>> I have no particular opinion on specific states here, however adding
>>> more states means more stuff for drivers to implement and more risk
>>> driver writers will mess up this uAPI.
>> _STOP == 000b => Device Stopped, not saving or resuming (from UAPI).
>>
>> This is the default initial state and not RUNNING.
>>
>> The user application should move device from STOP => RUNNING or STOP =>
>> RESUMING.
>>
>> Maybe we need to extend the comment in the UAPI file.
>
> include/uapi/linux/vfio.h:
> ...
>   *  +------- _RESUMING
>   *  |+------ _SAVING
>   *  ||+----- _RUNNING
>   *  |||
>   *  000b => Device Stopped, not saving or resuming
>   *  001b => Device running, which is the default state
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^
> ...
>   * State transitions:
>   *
>   *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
>   *                (100b)     (001b)     (011b)        (010b)       (000b)
>   * 0. Running or default state
>   *                             |
>                   ^^^^^^^^^^^^^
> ...
>   * 0. Default state of VFIO device is _RUNNING when the user application starts.
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> The uAPI is pretty clear here.  A default state of _STOP is not
> compatible with existing devices and userspace that does not support
> migration.  Thanks,

Why do you need this state machine for userspace that doesn't support 
migration ?

What is the definition of RUNNING state for a paused VM that is waiting 
for incoming migration blob ?

>
> Alex
>
