Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6518C2320BA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgG2Oh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:37:57 -0400
Received: from mail-eopbgr140088.outbound.protection.outlook.com ([40.107.14.88]:46222
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgG2Oh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 10:37:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQn8aYBKppbXpcHShvOOQnsVFqp6AdGxn21kSky78cdom7jaZU5dlJ1AsCrz1bsLNjloimvwMBy8wGCU9F5S5fGMwtnzndZpAkzdSo4erq8yaXZ2yWKN5bcyFLQVi3h+XZKtLaBu/9Ln9H20rEgP2MPXLwPJrScRDyEorsKSQrEzPSd7aNPsGx+WwQZYrFQNR0n2oq4rR80Tt7VS5AcdJeXZBtaE8Atf7iwR4cTNk695Uan4yxyY3drojnjk/+pYeShPdC15FAuA/SyOBa7ylL25nTKrXucmedLislYy2mYUiO7g7316oXdC7YvmIIRz7J+3i7oB8EJdvDICOPO3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/VBqG3xIlBvcMnjcwZCSkv75AzRBIbsYr3hXlwWpAw=;
 b=Dh1b9TRst8g2Afjse3c7MJZI5i123sBxMak7SBIEKLcS3vTeiE0UlIUcVcEIHNyZL3KFhPafvUTc4W3jcCICq9tYPRGdZYVSR9ZJ+h8opYr+Dop+YeEEJBZsvMtyuUTiTrkJPWRQSPd38h5qKehDCFJV/MYkRgg8DDPaq9jeQAJHAv4WviQOmoWoLwnpbSgOmPJ7wZsS4JM8iurB/0KO8Ss2cBqOkMeGGLI/k323bJdqICBi3YnioU65dp8GV+w6IPO/OeLXWzBbufO73stn+TwB2knXmDZrEM1HIbdcJcg6TB9MB+Tbn0aTFiWKvFI6Dn+4EdAW6ga9DncUqFLY8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/VBqG3xIlBvcMnjcwZCSkv75AzRBIbsYr3hXlwWpAw=;
 b=sIOhArGpH0BOyHJ4UbgaAe60GmxvmNoX/LdtJlyBS1dhzB7vXqdPTHsMtrsQOLgGL8WiYZ/LrhDqOzcADlI1mjmuF9wHKSseYgMuykdavRCkPDjfnL2FmuAIB/fjiD1a5zYDq1y5emXdrWTQTGQh24SqW+qXGacgZtdW4pCvy4A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR0502MB3697.eurprd05.prod.outlook.com (2603:10a6:208:1c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Wed, 29 Jul
 2020 14:37:46 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 14:37:46 +0000
Subject: Re: [PATCH net-next RFC 02/13] devlink: Add reload levels data to dev
 get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-3-git-send-email-moshe@mellanox.com>
 <20200727175842.42d35ee3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <448bab04-80d7-b3b1-5619-1b93ad7517d8@mellanox.com>
Date:   Wed, 29 Jul 2020 17:37:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200727175842.42d35ee3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: LNXP265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::28) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.20.10.2] (2.53.25.164) by LNXP265CA0088.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:76::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.34 via Frontend Transport; Wed, 29 Jul 2020 14:37:45 +0000
X-Originating-IP: [2.53.25.164]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c57c0b6e-c6e9-4015-dc90-08d833ccf5c7
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB36975C09A3285206C15115FED9700@AM0PR0502MB3697.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haToLY6jQnq2Z+d1+/L+na2seL55TOYjIy3uwspxqIZTFk3D9M7VQ7mKw5R5uCtFuFkQtlq3OXxFdHt/h4HxhaTAmhDOfeuw83+tPkgS63mbXkdgYvG68Q9re2L+ly4ajuwVtoSblJjIGEmbNea+rYRU2YA6ot9pctTfk82bjQNDVuDQj7M2IxwtTvXv5cco1KfJILG4zz+CcPs1u6FrUlt+L/VUDXsv9FSkCJqDL4TK2+7fVLAtD8uj/CTUtZqCnHCh689lQ11cQ4pSUJN0sbnt0JkNeRVdmOMUJ2H5OcuEydjllTdNCzUhEQqxgtAhX+upn9DvMb7rZ4/OJDo7nJB4xN6snwRIp98Yv8x8Mrj2r9/TNoE53zQyBRuVp9pA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(83380400001)(52116002)(53546011)(31686004)(186003)(26005)(8676002)(16526019)(2616005)(956004)(36756003)(8936002)(86362001)(6486002)(5660300002)(4326008)(6916009)(66476007)(478600001)(66556008)(66946007)(316002)(16576012)(54906003)(6666004)(2906002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +r3PHnD0ijzflSx6Jq+lRfLHDuplJWgalgVWgHsXW5zbCQ8HwvPb8mjEkuP8TPckbyNOLw4vxSLku0ipEarZvJ7DRTPJupbJeyOlJfUDD7EHK8M7Kih/4ALmdpv4B+VCO7E6MLrL0pI9lcOs4Yl4EX6XY6IFP8OksaYkijR/5gp4lKHzcxZrsoa8TVriCM8NO6yBkAZIbcalISsDKnf6SZyjly/LQ0iQtgsssFiFpWAXmMnjYao2rhf1FjrTS/wLaaUMpoIaSDNUPsil9pUCwgrnvg3GQQ1lTYDNe6KqzF9yu6aXfa/aKIe6XA/KYlHHQ6XPRacUcVSgShqQeRhTnE2kFgp9CwKchzR+Smj/omO5if1bvNM3rH2qn1b9logN+rXWmyWC+4lhpi1AeoeC/dyXeO+h+9RQ1n3SSxQOmVRP8Kwz/9MlHOfABhEOrSbtybpg/v/tbVNeUCS7KrDFj1u82OhTZXQesh0f0QAr1dM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57c0b6e-c6e9-4015-dc90-08d833ccf5c7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 14:37:46.3945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5V94kyaUEWvB3SZE2Du2AHEcUMsrQu3G3oFCZ7L1Laz5BwNp7SrSbPqeft8Pyg0RYQqjHuBXM1w0tBw0NoekGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3697
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/28/2020 3:58 AM, Jakub Kicinski wrote:
> On Mon, 27 Jul 2020 14:02:22 +0300 Moshe Shemesh wrote:
>> Expose devlink reload supported levels and driver's default level to the
>> user through devlink dev get command.
>>
>> Examples:
>> $ devlink dev show
>> pci/0000:82:00.0:
>>    reload_levels_info:
>>      default_level driver
>>      supported_levels:
>>        driver fw_reset fw_live_patch
>> pci/0000:82:00.1:
>>    reload_levels_info:
>>      default_level driver
>>      supported_levels:
>>        driver fw_reset fw_live_patch
>>
>> $ devlink dev show -jp
>> {
>>      "dev": {
>>          "pci/0000:82:00.0": {
>>              "reload_levels_info": {
>>                  "default_level": "driver",
>>                  "supported_levels": [ "driver","fw_reset","fw_live_patch" ]
>>              }
>>          },
>>          "pci/0000:82:00.1": {
>>              "reload_levels_info": {
>>                  "default_level": "driver",
>>                  "supported_levels": [ "driver","fw_reset","fw_live_patch" ]
>>              }
>>          }
>>      }
>> }
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> The fact that the driver supports fw_live_patch, does not necessarily
> mean that the currently running FW can be live upgraded to the
> currently flashed one, right?


That's correct, though the feature is supported, the firmware gap may 
not be suitable for live_patch.

The user will be noted accordingly by extack message.

>
> This interface does not appear to be optimal for the purpose.
>
> Again, documentation of what can be lost (in terms of configuration and
> features) upon upgrade is missing.


I will clarify in documentation. On live_patch nothing should be lost or 
re-initialized, that's the "live" thing.

