Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869CD216A79
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 12:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgGGKhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 06:37:53 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:23906
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbgGGKhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 06:37:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVd9OhniSILjXTvzbgmdZgLnlCg4iAzck+WfSc0m2gFpZ2urugEqCR9iUSV9LByWq+JY90rv4tk6+sivvMCFjpg6/8ELB6SYy/vo8oz5VGAgbFloegntpGaJlFkmrATAK0a7IAkzyZsQ0fVF3YcZ5UyBm8XfZuXnjhb/gbk9uNWMdIt55fta5bP6VwNNNET6LdcniA6ab+fIMd3JSHtyHUBiyF9ZBzDiqVi3sA5kA3Q7erZXrcFpLSDMshXDWHCcADUEVvPrY7AqbKeArH34lc4IyC/IB0iobT25ZBYXbF0q7zKE+kWwp7/+fWBl5kOpLeMMXX2mCaUhRPbS5vLhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBCO1p3EEF+pDizrIk6BVODRHjxOz1Kwm7MruV4Rgb8=;
 b=e7ij4A2FaPT2XKbIBhLDNTgm/6fByP/J/k4NvLnLbYNxJe+In7/0RmoMaDNveHSxAM1DFlW4WRdRDpi/CKqrgZ0LzLI98Y50GLN3N11xOsc5ZQB164zHU/vv9DHjrz/JTPqkD3t76iVoXAJ4SG3uDQovwtds7Gy45ztbfiGyKW9x5Sq5QBHnJXDUsHJrjNBOhwYeZCjku1ttdvrg9f3Xb2xi7LSAjvLJw7Q9Paz3EWie6f6IVGEZtV6PTAVC5ICQ7N3RMduiWjDm1j+EH5Zl66EehoafJk2pTFKQktGBq1SxteecNPUGht6o9WT8VHYOaAhGiVCRk+PdlRX0AWI/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EBCO1p3EEF+pDizrIk6BVODRHjxOz1Kwm7MruV4Rgb8=;
 b=J98FC+6Nmc24jl3O3EeRv6E04GU9rlQR6yh10P6jVkdvNLQjDko5zwM8AK31/FqQLvp5kgS/Nli1Jkb21ve8NOSp0868FQdTxksTApBoDZiyfxhswSQMwAUTsPCQmhn8XXaVwF94raO0/TmNdbeq779I57O/MCoqvLhnoObO57M=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB6519.eurprd05.prod.outlook.com (2603:10a6:20b:ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Tue, 7 Jul
 2020 10:37:48 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 10:37:48 +0000
Subject: Re: [PATCH bpf-next 00/14] xsk: support shared umems between devices
 and queues
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn.topel@intel.com, ast@kernel.org, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        cristian.dumitrescu@intel.com
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com>
 <b016b064-3e46-d73c-758f-4c0e97c1f1a4@iogearbox.net>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <27fabafe-16d5-6128-7e9d-a808f4728ba7@mellanox.com>
Date:   Tue, 7 Jul 2020 13:37:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b016b064-3e46-d73c-758f-4c0e97c1f1a4@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0011.eurprd04.prod.outlook.com
 (2603:10a6:208:122::24) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.44.1.235] (37.57.128.233) by AM0PR04CA0011.eurprd04.prod.outlook.com (2603:10a6:208:122::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Tue, 7 Jul 2020 10:37:47 +0000
X-Originating-IP: [37.57.128.233]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12fc4a5e-21f3-4524-9a77-08d82261ca84
X-MS-TrafficTypeDiagnostic: AM6PR05MB6519:
X-Microsoft-Antispam-PRVS: <AM6PR05MB651958D3A0BF7579B5852036D1660@AM6PR05MB6519.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+NwwfvOLvEnX+7QjdJuyM4aRGd7cuSOzBLnbyk2Es8InjWU4Owmf00m/6hI/BYn2j6Tmvumj6sG5IpBSGZyhfJGCmESKe53FGTSW0zQWTZXOFdf3PvWgP0xFScwfw7ZWf0AS/VShbc2o/ST2e5JhD9Lj/UHZtaWVA8nLIexzbOEfjJsz53L75fpLKPxuB/zRHGnK5YyXSQjRttUtCXRFRieG3XPEXshGXfKbZcG3hjsmb2ib67O97Kr7/4kL2RoMGGeqw9osAPvpaTZp5/HlI4TUymfa2aPWrDd9FY09FGAQfeSq36iKaRQUMkiGk2YNPH40npMuAaV9PejpnJ0eQawewwc76r54+WKDcq6R3dUMrcwkZgSa1xoyge368AU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(53546011)(5660300002)(16576012)(316002)(110136005)(8676002)(66556008)(478600001)(66476007)(66946007)(8936002)(4326008)(7416002)(2906002)(186003)(16526019)(55236004)(26005)(6486002)(31696002)(86362001)(31686004)(83380400001)(36756003)(52116002)(956004)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q7BdFyJS3XHbJQpynW9iKnR+7Y2UARM98QUiytM1zoIByXCXEDa4a6cyUqfvydAxqynNKYBnuU/5iXdzqtOvEk+yS99v8enmuIjhRZYJQIdp/biQvVR8dP2+bC+L8caP9EJzUi0v2cYlPddOFnddx02Payis8poolvW1m4Hrj/pGvX+oKCkSoPIDfS/jZItUiSrFbWJuPbTLeNqpDyTv21nE2ypYW6beXeEGdnpVRo5gN3jonzMjJFfbxAZHt4yWKEUSxsvlGxJHG2Wj1Zu8B/2IU5u1jVky22HXI9/aLEASvkhJgkDavI+HmPiS6Ox5KNfuH2i5f7+iCjz9MW1ePkXPysjF15hk0JArQl946WujCE9sOPpTKdup5EzTyQOW9flyErmFbLADcQp2mWbuJ8RcU+yINuOxXyBuJA54VIZTrxHh/CT6VIACCmpm2iTAr4I6+BCLfxBy/QsM9gLYYtHoo9j+jfQKvx75wwLK4EA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12fc4a5e-21f3-4524-9a77-08d82261ca84
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 10:37:48.0873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfxE6ERxRDzwglu46L4+I8T83oCxwobOMejVneBlrEdIHukcLi5D7nnk0NrW21T39k103N1D3B5QbpSH7I/+wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6519
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-06 21:39, Daniel Borkmann wrote:
> On 7/2/20 2:18 PM, Magnus Karlsson wrote:
>> This patch set adds support to share a umem between AF_XDP sockets
>> bound to different queue ids on the same device or even between
>> devices. It has already been possible to do this by registering the
>> umem multiple times, but this wastes a lot of memory. Just imagine
>> having 10 threads each having 10 sockets open sharing a single
>> umem. This means that you would have to register the umem 100 times
>> consuming large quantities of memory.

Sounds like this series has some great stuff!

> [...]
> 
>> Note to Maxim at Mellanox. I do not have a mlx5 card, so I have not
>> been able to test the changes to your driver. It compiles, but that is
>> all I can say, so it would be great if you could test it. Also, I did
>> change the name of many functions and variables from umem to pool as a
>> buffer pool is passed down to the driver in this patch set instead of
>> the umem. I did not change the name of the files umem.c and
>> umem.h. Please go through the changes and change things to your
>> liking.
> 
> Bjorn / Maxim, this is waiting on review (& mlx5 testing) from you, ptal.

Sure, I'll take a look and do the mlx5 testing (I only noticed this 
series yesterday).

> Thanks,
> Daniel

