Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748DD570AF8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiGKTxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 15:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiGKTxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 15:53:33 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00050.outbound.protection.outlook.com [40.107.0.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C49545C4;
        Mon, 11 Jul 2022 12:53:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9dscHx4mr6RKp1kA0uyZrvDPSHZixiQraGUFS+uGLy7ueAWzcfdR6HySci5cWOO5sYCvDicRFBk7TSfS6E5hAqGF7KMXb5PqdRbYEdA86kt3FVSgUQXkPYpUbKfHbkC0k85IEEjxZgAKToDdCIncYsnPmqNhM1MGat9a4yq+mwWEJQ1zKvxa4hL2YW3x9Rh0L6CE9GSLtuncRaBY66JqDX8twzz5R6qnK+STi+NTXegIT9x/8d8yZO/NRPWY7uZ10VfHgqiY/YqQ/5W6zZF/UB5xhA3HkJLSipdVeKHjVo72YUg6Nnxv+f9+yxUndQOqM4bpiRDKFiGu26w416ZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApMNWpJQBwxrV9K1dPC+TZeUJ9ZCcksuymjJSq3S4ws=;
 b=DBvrr61tUqXbeTpm5pZKzsZpqLwJ7LYJL0bSDbe7cJRF4HvOOYXYBKYnyPJsFfykuMqR5nmFuTpMZGYBaR3S7SnrGfYol8F2d9gBlQIvkFN4xC9sqj8y0L7037en7aBR1a+tih+pg1KNylcHLVwekJ52Jk2sUy9MQKaPvCIheUXW1zElDGm6iS9M6y7SZv6ViGH9fSPtDCuxuApMHIC080Pu++fA3PX5w+ZTn/wDxTlhDMcZj9ZpKJ85GFVcA3EQo5tbZ/puL2W5qNBk31awI9ZdYM4eI6F3xIqcp+QLe7j5Q+zhwSFtV+/TFLtsCNANY/XZAa/8s+kJMfdgn/By/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApMNWpJQBwxrV9K1dPC+TZeUJ9ZCcksuymjJSq3S4ws=;
 b=XdCW8FI4Pft5mr3AI/Z+cxvNeZOUZDWhgm1qLYvVuLK80Wn2ziGLNyc/Wio+KovoJMNZuXvtA6h9HIy2sBXO+SiDHvxuGnF/SH5Bv4HdqNpV5pcI5K76oy3kh+tDcfGixoQ8YhKZrAfAt+PiGWvXRjC9/d7QLXJmHponDf3Z6Av/Ntm/bqRW34WZ3PMN051YDuXDFgVXpcIZp4XqPBzvdS+a7FnnnzJXO9/UJ3FN/73zXFQ5VidAK4hCSJkLynritlFQZ9Hf/6kQrBKVklxwS7TTW8l3R1N0auKMrJc+CrDq6l2oPfJSzbC3EqnsRmFbfIiN9JbK19NKW0rle3bgIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB5350.eurprd03.prod.outlook.com (2603:10a6:10:f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 19:53:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 19:53:26 +0000
Subject: Re: [RFC PATCH net-next 3/9] net: pcs: Add helpers for registering
 and finding PCSs
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-4-sean.anderson@seco.com>
 <CAGETcx97ijCpVyOqCfnrDuGh+SahQCC-3QrJta5HOscUkJQdEw@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b2d00d2f-712f-0051-4f30-367889a2e892@seco.com>
Date:   Mon, 11 Jul 2022 15:53:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAGETcx97ijCpVyOqCfnrDuGh+SahQCC-3QrJta5HOscUkJQdEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0034.prod.exchangelabs.com
 (2603:10b6:207:18::47) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c09166c5-c984-4b5a-726a-08da637704a9
X-MS-TrafficTypeDiagnostic: DBBPR03MB5350:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7dtna9vZrSdWD0hJ8n11Kj94sV993n0p3euchZpl+H2Sso4GtncVX0nJkfRpvowPUZdQHzX3NLXua3hGT5lVd2J+mSP8WESZDEKgfGPafR4bq90RRpC3w70sQaQvhIAgGIiOJdgWh0T9C0uqVHlwXAPMbOUppN1oa3xwVghtRAruT8DPWEmIKvJpTdexAxOtjpdUrWv6W0lECyLLahscLEPU+9u9C1trJWDx3pSpTJdjVhn6Ysw3c1cb3Ylj28ZaIt0yNo6wszpYfljJFNi96TO5DjmeGan2HEYdfH/HDjyJ7og14/5W+AQAxYfLTJRUYF4EoMJSTKNIK4317QdRZ6yCTogOH0O8GpCYxNW02EYE+XAcd9dnfqfREyE4tkZCgdeKHxyVcanUMb3n8EKzwb9hFQzBYc2BbYM5o2RPvvBFj7Rrog6FIsLDPtAwKwt7bx5Aig8yZgMF9kFCmyVa89qVN6Bd1WqhJe04EPVZUKA3f3CiQ6CqOYTvTiwS9SPglDbwjSWtqTJyAmGc2B7KALmaaH4G0jYKO2hwG8KoStVU8vk8vnpwT4KEU/j/MD7yZaZ6qdCBCQJ91i5zoDdwIXabdGAOFVUKha5gbapwiN0XbsZBfbxiIq2be1ECujgdiE9OQfaHRuMSx63lsIFaSasvma0+fPproePaueT/EvOXPGRU9RNRH7+k0voSs8C9DxwDoAwwc0321BPWdCiyNgzOQrfvcMc2LPM1ELqtBGD3hGEkAcN3bAHWskaS/3pi4pOQ1H9Fi8RwcRvmmtJHYYG1zQiZx/bO74tygNtXTqnP2laNmnyCU6DsUxDAgei4jg7S70LE4lsZr/cDLvboc+mzfrOo6wzanPh7UHMDn5bH2FUFIjaRG2yF5Bhk9qR+F//lvk/SEdo8IxvWtzL+Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(346002)(39850400004)(396003)(478600001)(2906002)(83380400001)(31686004)(6486002)(966005)(30864003)(36756003)(44832011)(5660300002)(186003)(52116002)(26005)(316002)(2616005)(31696002)(4326008)(86362001)(6916009)(8936002)(54906003)(66476007)(8676002)(66556008)(38100700002)(6506007)(6512007)(6666004)(38350700002)(41300700001)(7416002)(53546011)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2ZNemduRlJFekF1eDRva2ZnRzRYYnhOdVhqNzg5OERic3Z2NDhRRmFHVHUx?=
 =?utf-8?B?aEkyR0pQbzY1RC8wOEN2ZkxQSjBxb3VpM3lzTFY0ZXM2YmM3ZGFZc3pWL0hF?=
 =?utf-8?B?WmVvdVFCZURPZTFpbkFBcXdVNHVFQUNHRXBKdTlucitwejZRYUVlTThtSXhn?=
 =?utf-8?B?M0p3VzFsV2RsNnl6TjNmZVNnbUZqYlAvYnNnSXpYMmNOL2RVUk1NUXRnMnlG?=
 =?utf-8?B?TjdrVmFNUDVob2NvV2RETnBWMTNiWUk5OXFOTXJvR28yUGNWa2F6bElKRFdk?=
 =?utf-8?B?Z0hrNFcvWithRG1URitCcFd5NnByUnh3dkhSSzZDK1Y2ek15SWJQR2N3T2R5?=
 =?utf-8?B?SzNyaHYwQkd4R3ZPaGN3cGxLRWE0TW5MeVVtZkEwSWFDK2NobGdQMXBkb3BH?=
 =?utf-8?B?N1pLRlFQQVpOeTIvSVlyMW1MTTFRaGZkektSVGx0elVieTBUTzZQWEpLOGpB?=
 =?utf-8?B?MDAxaUNmV0htYnRNQ1I4NWlLSlA2TzJJUndVR21ka1k3V0cxRiszenhkN2tZ?=
 =?utf-8?B?aFd6ZDYzY0tkakZtb0tRMjBDTS83SVlFbU1md2dIbzU1c0QzQXVqVEJGVmI2?=
 =?utf-8?B?bU9GckpKcDVPNVhXL3VkVmdEa05PRGt4ZWtyeEhrS2poNjVMeGNYc0M4U0ti?=
 =?utf-8?B?Q3JlNTNad3R1clRmeUkvbVZaa3dhNDVBSGlxd3psSzYxMkpocWxZVUVxemFM?=
 =?utf-8?B?cXYvQThqRXhxUVJpK0pYZDJxMnRkZTFwamFrWGFXUmlUeEFuNjZzYWxvYXhY?=
 =?utf-8?B?T1FCbFk3Ny9NakpYUjQ1WlBRRm5nQXUwWmVFYjNkTmpTNjRFNnhkWUhCR3VZ?=
 =?utf-8?B?MGpVaGUwYVY4UlM2ZzBwbmx2ZUovYkdXUEFJWGlUUDJ1NWVNWVNzTExkd2NL?=
 =?utf-8?B?ZTNWK3dCQ2ZreCtsa1VMOVdkek9oVTlrbG5NYUhxOW5SMXB4WThmK3gwVnB6?=
 =?utf-8?B?MWw3d0l6dm90YlpvWTljWEJFSEVlMU9VbTJ1dm9Idk5La2tVVmVrSGhuWkdR?=
 =?utf-8?B?Qk5MZHB3SXdNTFhaMVJKc1pLbmViQjJDMTNwM29QZThxZEttMXp4SVlHcDNa?=
 =?utf-8?B?MXpSSHdkd1RNVkt2NHR1RmQzeHpwL3NDNDM5S1ZNakl3SERJRkRvUzhhK0Fx?=
 =?utf-8?B?LzVIOHNTanNDRm5EM096bUdocU8vcHZ0VTZ0Q29vdUwzVFgyd2VjKzc0M1Z4?=
 =?utf-8?B?bjJLMUpnQlFwdHV4TnpMWjNyVkNjUXAzTEt6U0Iza0tjRFJQby85VzJ0YkYz?=
 =?utf-8?B?M0I4aVovcGZJZTdobmdEc0JGUS9OVU9DbStubDRpeEJjbmNPRXg1Ymo1VUgz?=
 =?utf-8?B?S3ZtaHF0ajhMWXcwVTFPV0NOUFhXQzI2cnRkcXdDSXNjd3phUG5xTTlYL2Rj?=
 =?utf-8?B?d0J5OUEwNUxBV1V0S1RKczN1YU1NOFh4aVhKMi8zL3FQTnNHQmM2NmwwcVB0?=
 =?utf-8?B?MGQyQnRuL0NXMzI5ZzFEQ1B0S09uOHFlZWZyNnB4RUs5cXprdFVnK2ZzTEdV?=
 =?utf-8?B?RTgvRXo1K3BUd3BLSGhqZ2VPVS9OcU1XRjhHbDc5NTVuZVpab2NuaTVTMTJk?=
 =?utf-8?B?T1JabmYxWlhPdW5jZDg2THZ4QStQVHZOVWY5emFXY1J6MG9nRmVud3NqajJh?=
 =?utf-8?B?UFdlR05QajhPSzVxbi9aU1ZLZHFzK3kzM3FnaDU3MXRDdy85dHA3S0dFQzVI?=
 =?utf-8?B?MHVMRCtZRlQwcnVyWG5JcE4rMmdDZTgxcWlJdHhwdDNKWU9Gd0dzamU5cW5p?=
 =?utf-8?B?dVY4M2gyK1BTazZjbUJnZXFzN3puQWVrOUM5ZnprTGVMVGR3OW5UTmFiU3Nk?=
 =?utf-8?B?NGFFWWxJaHhVYWhtMXpnZGkvK01OUFlJMlZJVHdMZXl6Z2p3bldQa2NpWG80?=
 =?utf-8?B?eTgzd3EyREJPR1pqNUlTN3FTeE5hMFJRSkYzTlc1aEZWSjR2dzhTMzNTeE9J?=
 =?utf-8?B?cW1YMmw0YjluL0JsSVpzOE9LTDRKSW5pV0RqdS9YWXBPT2RWcHM1ZGl0NGY2?=
 =?utf-8?B?aFhxbUkxb2pMVXI2NG0xMnNNSmtPa1hRNTMxREtSakdKY2tPR3VFT1pHY3Bs?=
 =?utf-8?B?WXI1ek85cXpPZVArSWM5RVh1ODVpeUVTNkJ4dUZGZWRpSGRlTHNZRHJ3S25J?=
 =?utf-8?B?OXVWMlpJSTBwR3RJc1ZoMHl0OS85R3NwWEJGclN3ZlFzRFNhVCsvdFBMZEd3?=
 =?utf-8?B?R0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09166c5-c984-4b5a-726a-08da637704a9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 19:53:25.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SW8+tbi89O9HACv0coImLvQ95Wap3ajRhNL7Al0gR2HfNdKrN30DO1rcVIsXypSdE3tcsdJZzZ/xninOu3+bKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB5350
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/22 3:42 PM, Saravana Kannan wrote:
> On Mon, Jul 11, 2022 at 9:05 AM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>> This adds support for getting PCS devices from the device tree. PCS
>> drivers must first register with phylink_register_pcs. After that, MAC
>> drivers may look up their PCS using phylink_get_pcs.
>>
>> To prevent the PCS driver from leaving suddenly, we use try_module_get. To
>> provide some ordering during probing/removal, we use device links managed
>> by of_fwnode_add_links. This will reduce the number of probe failures due
>> to deferral. It will not prevent this for non-standard properties (aka
>> pcsphy-handle), but the worst that happens is that we re-probe a few times.
>>
>> At the moment there is no support for specifying the interface used to
>> talk to the PCS. The MAC driver is expected to know how to talk to the
>> PCS. This is not a change, but it is perhaps an area for improvement.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> This is adapted from [1], primarily incorporating the changes discussed
>> there.
>>
>> [1] https://lore.kernel.org/netdev/9f73bc4f-5f99-95f5-78fa-dac96f9e0146@seco.com/
>>
>>  MAINTAINERS              |   1 +
>>  drivers/net/pcs/Kconfig  |  12 +++
>>  drivers/net/pcs/Makefile |   2 +
>>  drivers/net/pcs/core.c   | 226 +++++++++++++++++++++++++++++++++++++++
>>  drivers/of/property.c    |   2 +
>>  include/linux/pcs.h      |  33 ++++++
>>  include/linux/phylink.h  |   6 ++
>>  7 files changed, 282 insertions(+)
>>  create mode 100644 drivers/net/pcs/core.c
>>  create mode 100644 include/linux/pcs.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ca95b1833b97..3965d49753d3 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -7450,6 +7450,7 @@ F:        include/linux/*mdio*.h
>>  F:     include/linux/mdio/*.h
>>  F:     include/linux/mii.h
>>  F:     include/linux/of_net.h
>> +F:     include/linux/pcs.h
>>  F:     include/linux/phy.h
>>  F:     include/linux/phy_fixed.h
>>  F:     include/linux/platform_data/mdio-bcm-unimac.h
>> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
>> index 22ba7b0b476d..fed6264fdf33 100644
>> --- a/drivers/net/pcs/Kconfig
>> +++ b/drivers/net/pcs/Kconfig
>> @@ -5,6 +5,18 @@
>>
>>  menu "PCS device drivers"
>>
>> +config PCS
>> +       bool "PCS subsystem"
>> +       help
>> +         This provides common helper functions for registering and looking up
>> +         Physical Coding Sublayer (PCS) devices. PCS devices translate between
>> +         different interface types. In some use cases, they may either
>> +         translate between different types of Medium-Independent Interfaces
>> +         (MIIs), such as translating GMII to SGMII. This allows using a fast
>> +         serial interface to talk to the phy which translates the MII to the
>> +         Medium-Dependent Interface. Alternatively, they may translate a MII
>> +         directly to an MDI, such as translating GMII to 1000Base-X.
>> +
>>  config PCS_XPCS
>>         tristate "Synopsys DesignWare XPCS controller"
>>         depends on MDIO_DEVICE && MDIO_BUS
>> diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
>> index 0603d469bd57..1fd21a1619d4 100644
>> --- a/drivers/net/pcs/Makefile
>> +++ b/drivers/net/pcs/Makefile
>> @@ -1,6 +1,8 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  # Makefile for Linux PCS drivers
>>
>> +obj-$(CONFIG_PCS)              += core.o
>> +
>>  pcs_xpcs-$(CONFIG_PCS_XPCS)    := pcs-xpcs.o pcs-xpcs-nxp.o
>>
>>  obj-$(CONFIG_PCS_XPCS)         += pcs_xpcs.o
>> diff --git a/drivers/net/pcs/core.c b/drivers/net/pcs/core.c
>> new file mode 100644
>> index 000000000000..b39ff1ccdb34
>> --- /dev/null
>> +++ b/drivers/net/pcs/core.c
>> @@ -0,0 +1,226 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
>> + */
>> +
>> +#include <linux/fwnode.h>
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/pcs.h>
>> +#include <linux/phylink.h>
>> +#include <linux/property.h>
>> +
>> +static LIST_HEAD(pcs_devices);
>> +static DEFINE_MUTEX(pcs_mutex);
>> +
>> +/**
>> + * pcs_register() - register a new PCS
>> + * @pcs: the PCS to register
>> + *
>> + * Registers a new PCS which can be automatically attached to a phylink.
>> + *
>> + * Return: 0 on success, or -errno on error
>> + */
>> +int pcs_register(struct phylink_pcs *pcs)
>> +{
>> +       if (!pcs->dev || !pcs->ops)
>> +               return -EINVAL;
>> +       if (!pcs->ops->pcs_an_restart || !pcs->ops->pcs_config ||
>> +           !pcs->ops->pcs_get_state)
>> +               return -EINVAL;
>> +
>> +       INIT_LIST_HEAD(&pcs->list);
>> +       mutex_lock(&pcs_mutex);
>> +       list_add(&pcs->list, &pcs_devices);
>> +       mutex_unlock(&pcs_mutex);
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(pcs_register);
>> +
>> +/**
>> + * pcs_unregister() - unregister a PCS
>> + * @pcs: a PCS previously registered with pcs_register()
>> + */
>> +void pcs_unregister(struct phylink_pcs *pcs)
>> +{
>> +       mutex_lock(&pcs_mutex);
>> +       list_del(&pcs->list);
>> +       mutex_unlock(&pcs_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(pcs_unregister);
>> +
>> +static void devm_pcs_release(struct device *dev, void *res)
>> +{
>> +       pcs_unregister(*(struct phylink_pcs **)res);
>> +}
>> +
>> +/**
>> + * devm_pcs_register - resource managed pcs_register()
>> + * @dev: device that is registering this PCS
>> + * @pcs: the PCS to register
>> + *
>> + * Managed pcs_register(). For PCSs registered by this function,
>> + * pcs_unregister() is automatically called on driver detach. See
>> + * pcs_register() for more information.
>> + *
>> + * Return: 0 on success, or -errno on failure
>> + */
>> +int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs)
>> +{
>> +       struct phylink_pcs **pcsp;
>> +       int ret;
>> +
>> +       pcsp = devres_alloc(devm_pcs_release, sizeof(*pcsp),
>> +                           GFP_KERNEL);
>> +       if (!pcsp)
>> +               return -ENOMEM;
>> +
>> +       ret = pcs_register(pcs);
>> +       if (ret) {
>> +               devres_free(pcsp);
>> +               return ret;
>> +       }
>> +
>> +       *pcsp = pcs;
>> +       devres_add(dev, pcsp);
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(devm_pcs_register);
>> +
>> +/**
>> + * pcs_find() - Find the PCS associated with a fwnode or device
>> + * @fwnode: The PCS's fwnode
>> + * @dev: The PCS's device
>> + *
>> + * Search PCSs registered with pcs_register() for one with a matching
>> + * fwnode or device. Either @fwnode or @dev may be %NULL if matching against a
>> + * fwnode or device is not desired (respectively).
>> + *
>> + * Return: a matching PCS, or %NULL if not found
>> + */
>> +static struct phylink_pcs *pcs_find(const struct fwnode_handle *fwnode,
>> +                                   const struct device *dev)
>> +{
>> +       struct phylink_pcs *pcs;
>> +
>> +       mutex_lock(&pcs_mutex);
>> +       list_for_each_entry(pcs, &pcs_devices, list) {
>> +               if (dev && pcs->dev == dev)
>> +                       goto out;
>> +               if (fwnode && pcs->dev->fwnode == fwnode)
>> +                       goto out;
>> +       }
>> +       pcs = NULL;
>> +
>> +out:
>> +       mutex_unlock(&pcs_mutex);
>> +       pr_devel("%s: looking for %pfwf or %s %s...%s found\n", __func__,
>> +                fwnode, dev ? dev_driver_string(dev) : "(null)",
>> +                dev ? dev_name(dev) : "(null)", pcs ? " not" : "");
>> +       return pcs;
>> +}
>> +
>> +/**
>> + * pcs_get_tail() - Finish getting a PCS
>> + * @pcs: The PCS to get, or %NULL if one could not be found
>> + *
>> + * This performs common operations necessary when getting a PCS (chiefly
>> + * incrementing reference counts)
>> + *
>> + * Return: @pcs, or an error pointer on failure
>> + */
>> +static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
>> +{
>> +       if (!pcs)
>> +               return ERR_PTR(-EPROBE_DEFER);
>> +
>> +       if (!try_module_get(pcs->ops->owner))
>> +               return ERR_PTR(-ENODEV);
>> +       get_device(pcs->dev);
>> +
>> +       return pcs;
>> +}
>> +
>> +/**
>> + * _pcs_get_by_fwnode() - Get a PCS from a fwnode property
>> + * @fwnode: The fwnode to get an associated PCS of
>> + * @id: The name of the PCS to get. May be %NULL to get the first PCS.
>> + * @optional: Whether the PCS is optional or not
>> + *
>> + * Look up a PCS associated with @fwnode and return a reference to it. Every
>> + * call to pcs_get_by_fwnode() must be balanced with one to pcs_put().
>> + *
>> + * If @optional is true, and @id is non-%NULL, then if @id cannot be found in
>> + * pcs-names, %NULL is returned (instead of an error). If @optional is true and
>> + * @id is %NULL, then no error is returned if pcs-handle is absent.
>> + *
>> + * Return: a PCS if found, or an error pointer on failure
>> + */
>> +struct phylink_pcs *_pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
>> +                                      const char *id, bool optional)
>> +{
>> +       int index;
>> +       struct phylink_pcs *pcs;
>> +       struct fwnode_handle *pcs_fwnode;
>> +
>> +       if (id)
>> +               index = fwnode_property_match_string(fwnode, "pcs-names", id);
>> +       else
>> +               index = 0;
>> +       if (index < 0) {
>> +               if (optional && (index == -EINVAL || index == -ENODATA))
>> +                       return NULL;
>> +               return ERR_PTR(index);
>> +       }
>> +
>> +       /* First try pcs-handle, and if that doesn't work fall back to the
>> +        * (legacy) pcsphy-handle.
>> +        */
>> +       pcs_fwnode = fwnode_find_reference(fwnode, "pcs-handle", index);
>> +       if (PTR_ERR(pcs_fwnode) == -ENOENT)
>> +               pcs_fwnode = fwnode_find_reference(fwnode, "pcsphy-handle",
>> +                                                  index);
>> +       if (optional && !id && PTR_ERR(pcs_fwnode) == -ENOENT)
>> +               return NULL;
>> +       else if (IS_ERR(pcs_fwnode))
>> +               return ERR_CAST(pcs_fwnode);
>> +
>> +       pcs = pcs_find(pcs_fwnode, NULL);
>> +       fwnode_handle_put(pcs_fwnode);
>> +       return pcs_get_tail(pcs);
>> +}
>> +EXPORT_SYMBOL_GPL(pcs_get_by_fwnode);
>> +
>> +/**
>> + * pcs_get_by_provider() - Get a PCS from an existing provider
>> + * @dev: The device providing the PCS
>> + *
>> + * This finds the first PCS registersed by @dev and returns a reference to it.
>> + * Every call to pcs_get_by_provider() must be balanced with one to
>> + * pcs_put().
>> + *
>> + * Return: a PCS if found, or an error pointer on failure
>> + */
>> +struct phylink_pcs *pcs_get_by_provider(const struct device *dev)
>> +{
>> +       return pcs_get_tail(pcs_find(NULL, dev));
>> +}
>> +EXPORT_SYMBOL_GPL(pcs_get_by_provider);
>> +
>> +/**
>> + * pcs_put() - Release a previously-acquired PCS
>> + * @pcs: The PCS to put
>> + *
>> + * This frees resources associated with the PCS which were acquired when it was
>> + * gotten.
>> + */
>> +void pcs_put(struct phylink_pcs *pcs)
>> +{
>> +       if (!pcs)
>> +               return;
>> +
>> +       put_device(pcs->dev);
>> +       module_put(pcs->ops->owner);
>> +}
>> +EXPORT_SYMBOL_GPL(pcs_put);
>> diff --git a/drivers/of/property.c b/drivers/of/property.c
>> index 967f79b59016..860d35bde5e9 100644
>> --- a/drivers/of/property.c
>> +++ b/drivers/of/property.c
>> @@ -1318,6 +1318,7 @@ DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
>>  DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
>>  DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
>>  DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
>> +DEFINE_SIMPLE_PROP(pcs_handle, "pcs-handle", NULL)
>>  DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
>>  DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
>>  DEFINE_SIMPLE_PROP(leds, "leds", NULL)
>> @@ -1406,6 +1407,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
>>         { .parse_prop = parse_pinctrl7, },
>>         { .parse_prop = parse_pinctrl8, },
>>         { .parse_prop = parse_remote_endpoint, .node_not_dev = true, },
>> +       { .parse_prop = parse_pcs_handle, },
>>         { .parse_prop = parse_pwms, },
>>         { .parse_prop = parse_resets, },
>>         { .parse_prop = parse_leds, },
> 
> Can you break the changes to this file into a separate patch please?
> That'll clarify that this doesn't depend on any of the other changes
> in this patch to work and it can stand on its own.

OK

> Also, I don't know how the pcs-handle is used, but it's likely that
> this probe ordering enforcement could cause issues. So, if we need to
> revert it, having it as a separate patch would help too.
> 
> And put this at the end of the series maybe?
OK, I'll put it before patch 9/9 (which will likely need to be applied
much after the rest of this series.

--Sean

> Thanks,
> Saravana
> 
>>
>> diff --git a/include/linux/pcs.h b/include/linux/pcs.h
>> new file mode 100644
>> index 000000000000..00e76594e03c
>> --- /dev/null
>> +++ b/include/linux/pcs.h
>> @@ -0,0 +1,33 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
>> + */
>> +
>> +#ifndef _PCS_H
>> +#define _PCS_H
>> +
>> +struct phylink_pcs;
>> +struct fwnode;
>> +
>> +int pcs_register(struct phylink_pcs *pcs);
>> +void pcs_unregister(struct phylink_pcs *pcs);
>> +int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs);
>> +struct phylink_pcs *_pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
>> +                                      const char *id, bool optional);
>> +struct phylink_pcs *pcs_get_by_provider(const struct device *dev);
>> +void pcs_put(struct phylink_pcs *pcs);
>> +
>> +static inline struct phylink_pcs
>> +*pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
>> +                  const char *id)
>> +{
>> +       return _pcs_get_by_fwnode(fwnode, id, false);
>> +}
>> +
>> +static inline struct phylink_pcs
>> +*pcs_get_by_fwnode_optional(const struct fwnode_handle *fwnode, const char *id)
>> +{
>> +       return _pcs_get_by_fwnode(fwnode, id, true);
>> +}
>> +
>> +#endif /* PCS_H */
>> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
>> index 6d06896fc20d..a713e70108a1 100644
>> --- a/include/linux/phylink.h
>> +++ b/include/linux/phylink.h
>> @@ -396,19 +396,24 @@ struct phylink_pcs_ops;
>>
>>  /**
>>   * struct phylink_pcs - PHYLINK PCS instance
>> + * @dev: the device associated with this PCS
>>   * @ops: a pointer to the &struct phylink_pcs_ops structure
>> + * @list: internal list of PCS devices
>>   * @poll: poll the PCS for link changes
>>   *
>>   * This structure is designed to be embedded within the PCS private data,
>>   * and will be passed between phylink and the PCS.
>>   */
>>  struct phylink_pcs {
>> +       struct device *dev;
>>         const struct phylink_pcs_ops *ops;
>> +       struct list_head list;
>>         bool poll;
>>  };
>>
>>  /**
>>   * struct phylink_pcs_ops - MAC PCS operations structure.
>> + * @owner: the module which implements this PCS.
>>   * @pcs_validate: validate the link configuration.
>>   * @pcs_get_state: read the current MAC PCS link state from the hardware.
>>   * @pcs_config: configure the MAC PCS for the selected mode and state.
>> @@ -417,6 +422,7 @@ struct phylink_pcs {
>>   *               (where necessary).
>>   */
>>  struct phylink_pcs_ops {
>> +       struct module *owner;
>>         int (*pcs_validate)(struct phylink_pcs *pcs, unsigned long *supported,
>>                             const struct phylink_link_state *state);
>>         void (*pcs_get_state)(struct phylink_pcs *pcs,
>> --
>> 2.35.1.1320.gc452695387.dirty
>>
> 
