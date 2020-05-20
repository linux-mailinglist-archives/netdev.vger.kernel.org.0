Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450E21DB814
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgETPYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:24:08 -0400
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:6064
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726790AbgETPYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:24:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kh7K1G9gPCuGYIrqtWrxrmlgXDWW47whqHXxu8YCu06l2oH9pzUNSMVctJLB6PUpSIXgukoYJgYfAEaFWodyZA0lHkP+nkA0Tkr6o0GUpB/9j2reWP4t7fTOiHUobkQinWVuPtP7wb6XphTiYGD1rgwqtOgmB503Jukx0A5BlUrCELAF4xYSY9Erk860ajZy05xRDrAMzUekPEX7CYu32+oIZC2pytwt8iSmP83PHHUBNMW3HcG4zCvGW6Va4tHrhwMjrrN3OoYrTN8i30IFDff9eeMCKi/x/zOvXJTE88he82EyXTvJCbbip2p599In+UtIArYZx3NqtPppWYPe+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mmvSgso3TMQwjIbFBUMsDSjZYeefHsWEn3DXiQo570=;
 b=egzc43IG06ke/vpHuxZJQKYvUTjSRkpTRlz4/aRZH+2EjMoPxM4OIb6NT8mFRXO+ZBAcmqXz7n9ABWOL3kvzmhGIK/Uw++3IbIsgITO9kJMHsEhvUCpnEVuZjTX9kpAG95Fva6mUfBxoBtj2sxzstDnnE/4e8Kunrn/ALcfWMabUVrFRZsA3vwpVEpfZRrf6pBDN5HDew17KRdks5llfcosDLyfEpXwvs5gMUvXKvTvf8VAhhoc3zVea4ikKEaMhz1RYN4REg8LEioHMGdJfAeuJgdWjhIxv4Mw1dFAp7N5y4LtoXOpcI+LnmajowFVuiG6mtZh2bDOmo9p+Cpmogg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mmvSgso3TMQwjIbFBUMsDSjZYeefHsWEn3DXiQo570=;
 b=I/dBBqZ9gJNcns+YKeAIMFlWMNwFbAm9ihYIcj0Wk1nSkSmIM6g7GikXwDJRtzWCRyRdaDS5r6YN0+Sl//F/jr2lo5AKJRUkhNhA692iEPfgg4piG3HJnECQ4xcJvXvygpmfzi+YDwiqIWFx30ZlpSgS9KHeSz1qpJs/lCVwANA=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB4817.eurprd05.prod.outlook.com (2603:10a6:208:cf::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 20 May
 2020 15:24:00 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3000.022; Wed, 20 May 2020
 15:23:59 +0000
Subject: Re: [PATCH net-next 3/3] selftests: net: Add port split test
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        snelson@pensando.io, drivers@pensando.io, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
References: <20200519134032.1006765-1-idosch@idosch.org>
 <20200519134032.1006765-4-idosch@idosch.org>
 <20200519141541.GJ624248@lunn.ch> <20200519185642.GA1016583@splinter>
 <20200519193306.GB652285@lunn.ch> <20200520134340.GA1050786@splinter>
 <20200520135346.GA2478@nanopsycho>
From:   Danielle Ratson <danieller@mellanox.com>
Message-ID: <0429f5e6-6c7d-4d61-49a6-ce2e9c4e337b@mellanox.com>
Date:   Wed, 20 May 2020 18:23:50 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200520135346.GA2478@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0131.eurprd07.prod.outlook.com
 (2603:10a6:207:8::17) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (77.138.4.56) by AM3PR07CA0131.eurprd07.prod.outlook.com (2603:10a6:207:8::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.13 via Frontend Transport; Wed, 20 May 2020 15:23:57 +0000
X-Originating-IP: [77.138.4.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b71d32f6-2103-475d-0a96-08d7fcd1d1eb
X-MS-TrafficTypeDiagnostic: AM0PR05MB4817:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB481786BCE2030D0C4EF4A6B7D5B60@AM0PR05MB4817.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QJWT95CufH1LjTBanrtZ/7HuqEgEPCsnLOCuDJm47HhfGlENqWVYbrZPWvjUMxDNzdyOu5pHwC4soAZ8/kp+/800g4dgotmxdxFD0+KhAXNeNemlhCNdDptqxJsoil5n4WCjMAfwhMx/8lpHDnFFPGHEWO8ZjYQfZRtKDpg+MjHtjWeK0dfXOgiJaXNt/6IMLRQbh6gDMOEwOjXuyIKxGj8SFi0Ez3bU/D9AulclyZfYDB0RsUjPH+IQgMgrn9roDjEOT8LpTQNR6c3MqZoXbMNaPOYU/fTSBfP2dFioZ02EB5MIfwVLZaziqxdwnXxpQ+TLMdfi64qv9fuU6g2xSAGHXdICs4oxbwW+2t2Ro8p7H0El/XJeZJPseYKTSii75l1wH+SuPfh5FMaFWHwVCqpVFOAqRXCCJ5kEytYe6+56jvv4DyDAD7AHZ6oaK8OM/bmgkvCJruoBy/Wj+2qum8gifMBUcuGvPk8uOxlacKdWqcEfzdNFgF7kcrPPTx7M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(16576012)(86362001)(956004)(6916009)(186003)(53546011)(36756003)(66476007)(6486002)(66556008)(66946007)(52116002)(316002)(7416002)(107886003)(4326008)(6666004)(2616005)(31686004)(31696002)(16526019)(2906002)(8676002)(4744005)(5660300002)(8936002)(478600001)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aod8777g9MJ26BocJIuj6yLXxmZCHLJyqfIe9oIoO1vr2q+l3K1RIwwo8miJ9JODBBSn2qRsSXDgaBjVdzqDGQlVhkartEipk5nOv4W5iRzQ498a/TNSgVhJ+NI/DU5Tgyuoe6NDg4hIqxg/+2PhhLopfjuMrbHeUvIo0WxWp3U6EpIjrRR97mLf9VRdVPEvQs98IMSFsc4gFlmb8ae6hekiQSwnESoLaxFosttwoQ8o6+wN4oJPfJYkqTDZ9Kb9bOoa5QgCVT73nizueAlHuru7JV+WyQy+peg0dSCLPE5MjLak/A0Lp3dlf/7H2IXstJaUw8UM+EUapKUbDYIVhMk8dXl+r+qElBq6cCdBA22IkNtvZ4ZEuYIejanMh9M9ZjRAogsK7icW7r0d2NAmF/KoTZwuK3cjGrrrcVH37NH/5/xAv+AZYyDFpgdhBPa7Ty7BsMoO+8lHFI1eSyzVlwoOz00s2kJtcbjrcdPfdp0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71d32f6-2103-475d-0a96-08d7fcd1d1eb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 15:23:59.8269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+6BiNYhV+ZF8JtAbMgqcj7dG7rPeS250HexAmLni+n30x+7cNZKYOV+JRrtnv4aZoAm3KWPf16jL/h8MnoYkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/2020 4:53 PM, Jiri Pirko wrote:
> Wed, May 20, 2020 at 03:43:40PM CEST, idosch@idosch.org wrote:
>> On Tue, May 19, 2020 at 09:33:06PM +0200, Andrew Lunn wrote:
>>>> It's basically the number of lanes
>>> Then why not call it lanes? It makes it clearer how this maps to the
>>> hardware?
>> I'm not against it. We discussed it and decided to go with width. Jiri /
>> Danielle, are you OK with changing to lanes?
> Sure, no problem.


Hi Andrew,


Maximum number of lanes, is the maximum lanes capacity of the port. 

Besides that, there is the number of utilized lanes, which is the number of lanes that are actually used.


In that patch we expose the maximum number of lanes, and in my opinion "width" describes that better, and "lanes" on the other hand, can refer to both.

Thanks

