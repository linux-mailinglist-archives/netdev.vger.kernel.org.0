Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5102541C6D8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344541AbhI2Oi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:38:56 -0400
Received: from mail-mw2nam12on2069.outbound.protection.outlook.com ([40.107.244.69]:26593
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344519AbhI2Oiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 10:38:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCOf+xSafG3E7KImR94IvBMvROQWal6VwFN2kkFOCr5QR8GP0VW3L++tlmGrsakLLaiX9QgwXnWP5unmQAPLUYq28kmK5Q+h+ZcKcN8xsCFord1iXJsQXVIJ8PCKnB286/4uX4gyhHM2ghU9uRYtMTJJyokiI2eykhofaLjHrCqCvfNbLNNpVPNxQ6NgjZedaVTkN49629Tpt6y6gHy/2MMb5AYlvip+1y/Tn20iOj5DNmi72KG8PNJSY3KJRYkPGn9Ptk6tAxkQn3gd6wjnV3p1LaIs6A30qETO/9kbEMYc6vaP5XqZCvogLjlDG4y0YaikDsmeyiFRpWXIBMRIwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oJF9bKCEOeuLu9TQ+hGiKgolFkocURdZWHH4zRcwBJI=;
 b=Z7xP0Ss75sq9EL0h3Se7f1CCkip0phWI1m5zYizS/hRhenZsafXyL7ddPcB06kjH4jcfULEFuA1UoRV7jpq6ZBsjBxE9vrknhrD3Ih4MxRqaxeTnB6uhCMUIGW1k4Md4R7ESdlWkcIAtiCfc5fZuwiGdUspMW811fQh23TEFuu8b/RaX/M/e6x+iqbn06PtAM0fUoyb5/Re8pXSZm77gkjnISBivpfEA7sAB/mB8Qdg+s1Xt5Wdgpi5ZnRxVdSgQD1GeEyPcOHnhSsU8OGVC6iRZCEE29MlTlZETm74RooAh9c1FiKVtllOIK2aKimcWXkeU15h93mJgoGrcbSoq8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJF9bKCEOeuLu9TQ+hGiKgolFkocURdZWHH4zRcwBJI=;
 b=YVBCeb0xXYY6pBMuQNjEPhOfgMVXcyKm0fYCXN1UFFsOFEGcL7QR16EpBpLaDeb5dSxkYVJwaPgGGo3goBrrIWQq+605CQ/ajFbPKdNc+35wVm+Kzd+pEQPghiKtstlYHt0sKrELCp2/oEXOlSp6UpFSJmP2dSwP+9tjLluddcZLgg6+4+YYfpgDzm/rODDjwe4PgawoIViNov+TUD+aGV/NhKQzB8EdfBINhPwYGCAfkGstARNKlGA7dDwM6meEo9Usn0H8iC3CSaGVKTDH8yPL/ViUSHdsxBjmLN0aRxUW9dIUTFJmBsN3KSK4RI+Dq6+xYJ5YD0VIV6JFGmn+lQ==
Received: from DS7PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:3b5::8) by
 BYAPR12MB3431.namprd12.prod.outlook.com (2603:10b6:a03:da::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Wed, 29 Sep 2021 14:37:07 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::8d) by DS7PR03CA0033.outlook.office365.com
 (2603:10b6:5:3b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Wed, 29 Sep 2021 14:37:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 14:37:07 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 07:37:06 -0700
Received: from [172.27.14.186] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 14:37:02 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
Date:   Wed, 29 Sep 2021 17:36:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929075019.48d07deb.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09f2e4f2-9efa-43b8-db0a-08d983569cfd
X-MS-TrafficTypeDiagnostic: BYAPR12MB3431:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3431B90B2C8905E9A7784D5FDEA99@BYAPR12MB3431.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0wFUpzJrQI/hR8xXSetmyl3kV5W2Q8UBM4RwZ/pQcw9b2omkl/Um2TaESD92DcGbrGEY9jSQnknl6FEoiw+sy40p+Vw8vyYf+KkPZjAVMEjaLrtFLDKA1XVc1wbD4TOb0m7UvRviHCpf3Lkj7f8+F02A1dinVhqrs+jpUrEK9AMYJsnR7PByMjCuQGg628zXn/FSIRnu6GHrtRtpRgZZnKljDLLYeq+DbxZBmePZFH2KilK5n0XmacVUh1yv7qeFBq1eEgu4w07bCR2zWbFKLN3wEGwwJtTnmHh54THn8XOzZSiZ3CLP5lzlYQ90FaKBXTw23JEKR2CHqN5qPWI2uOyUquyQaeJSrSMTKpaY+CN8cKn5IEpXOb0JkO+CtYbTRduqhhlEfKgiXJZ7HwtDz7DJsPixpyz2b2lA5lFTNDGBkMC+SqzaCzD3XFGAErLlDY6Ot9cc5m3CdXNit+yX9GBj+3wErXK5Oaaa9spXE7z71b8l4bZwcEgZhaLHxV2MizzSYvWTkf5VLyo1539DYxbHb//scpUqA24kRRmLdHi4HO419C6MNNzXFW+KoYmKkeCmgR05mF2jg5GeRBBc1q/wTziaW+7O5JdL1E5GJC33C2LJRul1v8b4OxnGLok+J9fMGsAM0eK+1MM8G1zzgCvbO07xqzzd4S1tv1usOLDdW0si85zI5YXSnXcpk2CgN3Qk+6r326AtGGbduGpHiS8cXvG75RDOioQZSn+j1gU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(336012)(426003)(316002)(6666004)(4326008)(53546011)(508600001)(186003)(70586007)(26005)(47076005)(70206006)(16576012)(16526019)(36756003)(36860700001)(31696002)(7416002)(5660300002)(86362001)(54906003)(6916009)(356005)(2906002)(8936002)(82310400003)(83380400001)(7636003)(2616005)(8676002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 14:37:07.2505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f2e4f2-9efa-43b8-db0a-08d983569cfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/29/2021 4:50 PM, Alex Williamson wrote:
> On Wed, 29 Sep 2021 16:26:55 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> On 9/29/2021 3:35 PM, Alex Williamson wrote:
>>> On Wed, 29 Sep 2021 13:44:10 +0300
>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>>   
>>>> On 9/28/2021 2:12 AM, Jason Gunthorpe wrote:
>>>>> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:
>>>>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>>>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
>>>>>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>>>>>> +		},
>>>>>> Our state transition diagram is pretty weak on reachable transitions
>>>>>> out of the _STOP state, why do we select only these two as valid?
>>>>> I have no particular opinion on specific states here, however adding
>>>>> more states means more stuff for drivers to implement and more risk
>>>>> driver writers will mess up this uAPI.
>>>> _STOP == 000b => Device Stopped, not saving or resuming (from UAPI).
>>>>
>>>> This is the default initial state and not RUNNING.
>>>>
>>>> The user application should move device from STOP => RUNNING or STOP =>
>>>> RESUMING.
>>>>
>>>> Maybe we need to extend the comment in the UAPI file.
>>> include/uapi/linux/vfio.h:
>>> ...
>>>    *  +------- _RESUMING
>>>    *  |+------ _SAVING
>>>    *  ||+----- _RUNNING
>>>    *  |||
>>>    *  000b => Device Stopped, not saving or resuming
>>>    *  001b => Device running, which is the default state
>>>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> ...
>>>    * State transitions:
>>>    *
>>>    *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
>>>    *                (100b)     (001b)     (011b)        (010b)       (000b)
>>>    * 0. Running or default state
>>>    *                             |
>>>                    ^^^^^^^^^^^^^
>>> ...
>>>    * 0. Default state of VFIO device is _RUNNING when the user application starts.
>>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> The uAPI is pretty clear here.  A default state of _STOP is not
>>> compatible with existing devices and userspace that does not support
>>> migration.  Thanks,
>> Why do you need this state machine for userspace that doesn't support
>> migration ?
> For userspace that doesn't support migration, there's one state,
> _RUNNING.  That's what we're trying to be compatible and consistent
> with.  Migration is an extension, not a base requirement.

Userspace without migration doesn't care about this state.

We left with kernel now. vfio-pci today doesn't support migration, right 
? state is in theory is 0 (STOP).

This state machine is controlled by the migration SW. The drivers don't 
move state implicitly.

mlx5-vfio-pci support migration and will work fine with non-migration SW 
(it will stay with state = 0 unless someone will move it. but nobody 
will) exactly like vfio-pci does today.

So where is the problem ?

>> What is the definition of RUNNING state for a paused VM that is waiting
>> for incoming migration blob ?
> A VM supporting migration of the device would move the device to
> _RESUMING to load the incoming data.  If the VM leaves the device in
> _RUNNING, then it doesn't support migration of the device and it's out
> of scope how it handles that device state.  Existing devices continue
> running regardless of whether the VM state is paused, it's only devices
> supporting migration where userspace could optionally have the device
> run state follow the VM run state.  Thanks,
>
> Alex
>
