Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F62331AD
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 14:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgG3MIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 08:08:49 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:58245
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbgG3MIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 08:08:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eVEKRWS+oxWxgJA8uu3EjHRtyruZd/Oz9fvZngtYlZAXjneNfb97zTF98KbxwR+ULnH/mJZ6xUVY0d5UQb7lybj0RwZu3xpYyUT7R8biYhQcEtWUkeH7NgDTIS3FAcw/muWML5DD65zJ7EIC6EXT16VmZ7elrMBUcVHs4Q1s5QSpqj136k0ehjbbRxJlGePbVFBx85V6O2iaB/GVnexkzVcK+223uxK1p6IAXQqbv75A9oY99zmK/VwOQxK3lMuXRSBVAxVObetHH0AQ8D6xRuMd1dOLSbIi9IwySLuVLZoB/AC6GqIPZPVpoaW5qEDwel0almAi6AjLb5HifEdxMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyndQYhUpuhPHPETiO1JvwLups7D4f5PlzRN/b4P7tE=;
 b=fg8DnQx9oWCrmu0NBjDf8yu6Lpw/YrSWnayEO0ktspQ/EMHvtFQ3eeSDApbK6T+X/DADud/VfSh/tp8tphPTFQkCs7EtjY/Dh12Iq1ICbw2RYVAFsnOTUCt+6dXoXd4nYXYtnPAxo0ujXtH8VpnwzDSX938+RZneI3bv7ATF0L4++uskcaGQu4ijUrpCxtv71b0LuILq1Ditx/yLFAqUMDR1eWJia8J4EN6pemAvKLNxF6eVFxQjqxY67HouvsNDAjzgKEeD/G6cCC+j64tOb+RV0gQ+mQT6b61fniEJHYjUumZYZ4zcdUXnHuq2EGOLhfxHIFXxalWRCzn0ypowBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyndQYhUpuhPHPETiO1JvwLups7D4f5PlzRN/b4P7tE=;
 b=CGVnjv4zE0Q18/sMzZGk+oaJk8DogG3kKYF9N7KvUXG1U+UbNwtlV9fdllRJm3rH14i/YGKRJlOLaPY5Gc+m2YHlESbeJ1Nc4GeWFdzQ2nFFCHOpH0NbgXQLQeKq04+RRW1y5SNM0aDCJLEJwMouEPFg5Z13y0BxJ6yh8WFrzBU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from DB7PR05MB4298.eurprd05.prod.outlook.com (2603:10a6:5:27::14) by
 DB6PR0501MB2647.eurprd05.prod.outlook.com (2603:10a6:4:81::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Thu, 30 Jul 2020 12:08:45 +0000
Received: from DB7PR05MB4298.eurprd05.prod.outlook.com
 ([fe80::f0bd:dfca:10ef:b3be]) by DB7PR05MB4298.eurprd05.prod.outlook.com
 ([fe80::f0bd:dfca:10ef:b3be%4]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 12:08:45 +0000
Subject: Re: [PATCH net-next RFC 09/13] devlink: Add enable_remote_dev_reset
 generic parameter
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-10-git-send-email-moshe@mellanox.com>
 <20200727175935.0785102a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5baf2825-a550-f68f-f76e-3a8688aa6ae6@mellanox.com>
 <20200729135707.5fc65fc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <f54924e8-eb3f-18ab-a016-276560086a5b@mellanox.com>
Date:   Thu, 30 Jul 2020 15:08:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200729135707.5fc65fc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR01CA0174.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::43) To DB7PR05MB4298.eurprd05.prod.outlook.com
 (2603:10a6:5:27::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (5.102.195.53) by AM0PR01CA0174.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Thu, 30 Jul 2020 12:08:44 +0000
X-Originating-IP: [5.102.195.53]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5caa96b1-72ad-4b82-f40b-08d834814eed
X-MS-TrafficTypeDiagnostic: DB6PR0501MB2647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0501MB2647E2104603DF220A675FF2D9710@DB6PR0501MB2647.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jb6H4X8yXPHmHsZl10vnRadgSTEjsN6qmWuwpWQi+r3qP+er3GhdPFfROGkTu5CVuQiktRKfZavGSj7evvtdxS9AVXRIVtJg0akbxfNSxScAl2f3+4hYtKe2Hn5u4JCfXniiL66o2QCp9lIhJ4L3W7aCscACR2lYjTOb0MqAEiPBXbGKymoMli1VBpKlpkPal5Cjw6x0dsfQl8dmyPtKtLtljMjA8RFqV+zxZZ8nElNniPSyo6/Gz9BVD6wLrymvEXQwWXeqZFrckwYtHnx251AGokurXE1emnucf2pZsCwRjJkqgd0S8Nc/iNxAYUwInGtwyv4ujMvK7OlGizhLY94T0KEmxlWUhSJwxdP3xKImYaMw6yJR9jvSJacf06EaRibh+FaoPLQURxnR92iAXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4298.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(346002)(39860400002)(2906002)(86362001)(66946007)(8676002)(66556008)(16576012)(83380400001)(8936002)(31696002)(316002)(66476007)(54906003)(478600001)(956004)(26005)(186003)(6916009)(52116002)(5660300002)(4326008)(2616005)(6486002)(36756003)(31686004)(53546011)(16526019)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WQKOQKk9MyPgaKDdpQ2e1i2K/lSBtExS9TF8KsdcS4y4c6lkVQbvx9goOZ3tL2my/Xo/y4x+CMBFx9C8g+Vt4OTxVXLxpvbJ112nevJGStLYRiBFYI/xk2IeIpQcTnLsD119f+Y0+6xFeO2RupSxk79Vyr08DUaAER7BR3d2BshNZ6QqqGnNX1d5pihGwukH3wvyCSi/FyDUQWh9bWo27D3zw5gXCPuUimuyztok5sRR4ATtigB80LUk2JRpGJRVOKaLowpgJT46R46k2ciaQLO65g1MeuBgDHLmlCq+V/qOD7vaanDeycuBvhZRwIWYRt7LzF7c6Oo8MFvHnJMnqjU39g39zali30mhnaEtcjlHjKyJLj25SUXURhLh4FYcjAmm9KC9CEseN2XiLj3uBzSC39YFuogXNMSvpuXA3JcTup1D3ZycEu04MIC1xGBa3OBnnIMxmyTFmacmJ2RxsVzkRmduX0WbrCE6bOD42f4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5caa96b1-72ad-4b82-f40b-08d834814eed
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4298.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 12:08:45.6675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiwHt/2nQoeBiEMI18NLgBpDN77h0ibnYlTtsNkqVfFlM8jaloJNuHSAaSEOrWMsAlmjRNvQqRBgbmF8eHHEuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2647
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/29/2020 11:57 PM, Jakub Kicinski wrote:
> On Wed, 29 Jul 2020 17:42:12 +0300 Moshe Shemesh wrote:
>> On 7/28/2020 3:59 AM, Jakub Kicinski wrote:
>>> On Mon, 27 Jul 2020 14:02:29 +0300 Moshe Shemesh wrote:
>>>> The enable_remote_dev_reset devlink param flags that the host admin
>>>> allows device resets that can be initiated by other hosts. This
>>>> parameter is useful for setups where a device is shared by different
>>>> hosts, such as multi-host setup. Once the user set this parameter to
>>>> false, the driver should NACK any attempt to reset the device while the
>>>> driver is loaded.
>>>>
>>>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>>> There needs to be a devlink event generated when reset is triggered
>>> (remotely or not).
>>>
>>> You're also missing failure reasons. Users need to know if the reset
>>> request was clearly nacked by some host, not supported, etc. vs
>>> unexpected failure.
>> I will fix and send extack message to the user accordingly.
> I'd suggest the reason codes to be somewhat standard.
>
> The groups I can think of:
>   - timeout - device did not respond to the reset request
>   - device reject - FW or else has nacked the activation req
>   - host incapable - one of the participating hosts (in MH) is not
>     capable of handling live activation
>   - host denied - one of the participating hosts has NACKed
>   - host timeout - one of the p. hosts did not ack or done the procedure
>     in time (e.g. has not toggled the link)
>   - failed reset - the activation itself had failed
>   - failed reinit - one of p. hosts was not able to cleanly come back up


Sounds good, that seems to cover all options of fw_reset process to fail.

