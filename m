Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1E21570B
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 14:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgGFMJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 08:09:33 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:65439
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728938AbgGFMJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 08:09:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAAVriRDSnSewPc7puSJDh6XkJuEA4WM2VQPyE8oRes3lo6GLKaySiLp0Lp3Wo3QO8rcSo2anFRTN0Jm5kjW9k1w5YSmuFqlPKT+6XkmpWIpLLxpu0rURhtiWNUqIBsN0jy0I5MrXyyaZhv/T0UJdfgdiEKXoUKvFfCRC4znEs3PpdcpLVsB9gL0pnDXl9gfQ2yvUPtbdJsJA/qo9a0P9VSkwTV9bZPRB0W7RXK+uJHUMVvn7yNILivZh2AJrYbeQJu8AHWJCsz6b0CRywSHc1E4Dy+A9YhqZ0yXHQhD6sgq/LYyWlkNY+lnOBcJ77ddcUfj74akJY6anDL3lwomUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itS3RfB3KYfhrkTq87g3OfFLRfOhmumZIxSy+7PL148=;
 b=AKCka2uM0e4m0CTP3//lZ7R+XiTAwjCn24O23BdW+DJXrp61cEwWNerFvGni6bLn4Fq7OPvdWTXXHi8aatKmDAFsqFahKoJ34ICn4IXXDI8eVu15ZdXfMC3fV1zhMy58+KEhjlhFm9a5/x8LnaDfKOIqFa3dcKQUA0ePQ4EQtIWw6c6dLwPhkUw5tVZu6+TMIoC8iNsRBNc/+9abduVqOMPO2nm3XF/aSqLoY++0zDjnYaf1Wh7m8EtIxDlhzIoLxDRPplYp1pZV5sjRBlxShkltZh2dQ8uHcyo2+lYKQelZTL5QBwsuSL3m9pcBe2WlKcbXIBVqb32dQyjokUHbsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itS3RfB3KYfhrkTq87g3OfFLRfOhmumZIxSy+7PL148=;
 b=K6jBvMBzQdtV8f856S+0SZQVLMvO4NMQzOIl4HOSwCbkFCESQAFR8yPeCHr8Pd09jbmpxnVj7/45L857tOEKdbcua+vmjmitxehw+PMhgV91hC4aUwd1geY1ty37+U28f1bip8huDm/bdErG2bL6GCr2iHCQ3gxlheo8wIXHpkY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB4675.eurprd05.prod.outlook.com (2603:10a6:208:af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Mon, 6 Jul
 2020 12:09:28 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 12:09:28 +0000
Subject: Re: [PATCH net-next v2 0/7] Add devlink-health support for devlink
 ports
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1593746858-6548-1-git-send-email-moshe@mellanox.com>
 <20200703164439.5872f809@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200704141642.GA4826@nanopsycho.orion>
 <20200705094805.481e884c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <e6fb9b31-6c9a-7566-0064-84fffec942b3@mellanox.com>
Date:   Mon, 6 Jul 2020 15:09:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200705094805.481e884c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0139.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::44) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (5.102.195.81) by AM0PR01CA0139.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Mon, 6 Jul 2020 12:09:27 +0000
X-Originating-IP: [5.102.195.81]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 11e05911-0d35-4840-4d9f-08d821a56e79
X-MS-TrafficTypeDiagnostic: AM0PR05MB4675:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB46751F8A18C2B4616B259F73D9690@AM0PR05MB4675.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04569283F9
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mMP3F8OBf0VZY4kV4KLeaUI6AAWFbgna8iC/tNbm/IahEG5tLS3Qf8PItQj0NpO1I08LmIRMVimtNCpVkLUOp/ORmSMqodeJ6MGAl1p5tNn48eH8uU7M29f6+/HWTzUfEVcqR9yC3IAN/TlLxOuyVlnY7A1x7ClWMCLYZ6ULc7+j9rV2C4pr741vQjN0wjxqdWfYuuycjpXX52x+vIzJthdPVhKGbBE7Lkp0+YTUyYyzV0VuabCMmzRIlcz4kYAT2K3cx5uNvgLIn02eiPzbKDhZ7ce4/EZurYEiXA4XHK6j7o6y2tuJB1oddX6g/8NXjdDdToE9PmyyLigrcy9MziaFNmX0cxRoKyjPjICg/hkdUQ3H7QuIcIhrOwHuHrZn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(8936002)(8676002)(36756003)(956004)(2616005)(31696002)(16526019)(110136005)(316002)(53546011)(478600001)(31686004)(5660300002)(16576012)(54906003)(66946007)(86362001)(83380400001)(186003)(52116002)(26005)(2906002)(66476007)(4326008)(66556008)(6486002)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e7hySOdDInHZENSKqU88PoRnaFqvaay7jim1pMiWvT7mupyPB03/lJhtFnhaDLwCwKlsSJwHUXcUAGv6rxDUivW4GoZWvMJeJH3+RKWwT/sABo5HJB0qj9YEqBtTIkmEGtklDQTdMUTdmQBIjIPnM7SdmhY7otX0hMysvI4ap5Qu2pdXi1tX/NdMuc3T8NdisaXCBDAHU9n/g66CXT0MnWDxjrVXNdBY/4GOyE3b9szy4o4Svy0V2v6ROnDcnswTpTsJGA8N4q2PBe93801CxOBV5o7+dxWPl2QiM65TNQ9MFIS2vihf2ObHZW8vReMziaT3NhZZvgqH0jPfl1Ylgpi6qm6e9zD2/ihu///BWvGoNVKL6YUY0LLQCyfeHfE5/va2V3bU4L5Rwd8A2jgvC/QWs2KLuqsMu3pzXZ12p887qokGdgr/AHcAPawkk4djQlpfpaY/NxrDDIpaHiwZUbdK3+aO3Niuq1MucaUj7Qg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e05911-0d35-4840-4d9f-08d821a56e79
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2020 12:09:28.1687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uCGo8lQlTArk7PYzpM0Wh8HZqNNhMKlUeoB9kporQfskP+LCequ6ZQGanTFJSHZQrhp9YcsUHrxJcGVhyvlng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4675
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/5/2020 7:48 PM, Jakub Kicinski wrote:
> On Sat, 4 Jul 2020 16:16:42 +0200 Jiri Pirko wrote:
>> Sat, Jul 04, 2020 at 01:44:39AM CEST, kuba@kernel.org wrote:
>>> On Fri,  3 Jul 2020 06:27:31 +0300 Moshe Shemesh wrote:
>>>> Implement support for devlink health reporters on per-port basis. First
>>>> part in the series prepares common functions parts for health reporter
>>>> implementation. Second introduces required API to devlink-health and
>>>> mlx5e ones demonstrate its usage and effectively implement the feature
>>>> for mlx5 driver.
>>>> The per-port reporter functionality is achieved by adding a list of
>>>> devlink_health_reporters to devlink_port struct in a manner similar to
>>>> existing device infrastructure. This is the only major difference and
>>>> it makes possible to fully reuse device reporters operations.
>>>> The effect will be seen in conjunction with iproute2 additions and
>>>> will affect all devlink health commands. User can distinguish between
>>>> device and port reporters by looking at a devlink handle. Port reporters
>>>> have a port index at the end of the address and such addresses can be
>>>> provided as a parameter in every place where devlink-health accepted it.
>>>> These can be obtained from devlink port show command.
>>>> For example:
>>>> $ devlink health show
>>>> pci/0000:00:0a.0:
>>>>    reporter fw
>>>>      state healthy error 0 recover 0 auto_dump true
>>>> pci/0000:00:0a.0/1:
>>>>    reporter tx
>>>>      state healthy error 0 recover 0 grace_period 500 auto_recover true auto_dump true
>>>> $ devlink health set pci/0000:00:0a.0/1 reporter tx grace_period 1000 \
>>>> auto_recover false auto_dump false
>>>> $ devlink health show pci/0000:00:0a.0/1 reporter tx
>>>> pci/0000:00:0a.0/1:
>>>>    reporter tx
>>>>      state healthy error 0 recover 0 grace_period 1000 auto_recover flase auto_dump false
>>> What's the motivation, though?
>>>
>>> This patch series achieves nothing that couldn't be previously achieved.
>> Well, not really. If you have 2 ports, you have 2 set's of tx/rx health
>> reporters. Cannot achieve that w/o per-port health reporters.
> Which mlx5 doesn't. Each port has its own instance of devlink today.


That's right for mlx5, but in the general case Tx and Rx should be per 
port and not per device.

Better to fix the API before more drivers use it for such reporters.

>>> Is there no concern of uAPI breakage with moving the existing health
>>> reporters in patch 7?
>> No. This is bug by design that we are fixing now. No other way around :/
>> This is mlx5 only.
> Please repost including in the cover letter a proper an explanation of
> why the change is necessary, what benefits it will bring us, what are
> next steps, and why it doesn't matter much that the health reporters
> move for mlx5.
>
> The cover letter describes code not reasoning, which is IMHO
> unacceptable for patches that "change" uAPI.


Sure, will fix and resend.


