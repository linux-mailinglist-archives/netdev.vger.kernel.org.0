Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6439F170
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhFHIzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:55:44 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:34401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhFHIzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 04:55:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Itt5QGNqKfegTW+9ZtL/Eu511/ZgovwLQg8vMJqaXnaYVyzAIr2lT84u9CkuGMknnWhVG3zxclAhh40Qzg90YSPzb5n448ijKLEqo0/n4rOAWh3M4UVonnc5IZV9IMfsiA8jBcw5/iJUN2shzTwnaeGEsZOb/3+A4+Y2gNXFukHICpZGUV1ccBDRen/ET+d6zAvArz5zs6O8Hs4FEuanDvzApiaWx+bduH7o/9obBvuOXD2q/nCpT6KDg22oVtqmAZNOpG6syEd+xl6qNmM5UHzWLbg0SXBiR1s2avI5jDRmQekeV96kCEp7crBHv1UzIXKmj3rOmpS4B+IoubzliQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt4gkILoypk2WG79sJwqeAWJ8suDLrOX329sokfeIgE=;
 b=Tf67oFo0rkEB0GZPwAOYExE5L6HU924SjbaFJJ5zXiedjaS67zQCW1XEA5Om7W72BFmtZj5PoXHpqo8OK3fi1IXOiw92l9I/rU7KErGGDq1WZQ3rcXPOqdb64bdhPpHG7I6JisyJRpN10cmYA0uABDg7rh+sA3uxJLm4duXn0I67w8NFq9sJezrlGacB+1oMvPqsVMylq2rjv6TnaE45BQbyyyxQEjywr3qd30HJWF9R+zgggmSvp8fqSSx+C443f9PbmYnwv7/0o2mb3Q9cWX+Kztg21a/9d+Dun/bBOFatSPcSFZ7x3E7o7ukjP6PGqkeMnLf2AVvPwv7+yd2zDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qt4gkILoypk2WG79sJwqeAWJ8suDLrOX329sokfeIgE=;
 b=Quem6LOKLCImj6wNVdZUGdkUNs0+yBtoWs2zxpD+c/JzCPeQqIP4Qa1FxOL3udP8Ub7ikB5RPE0NsSe3QL35n+9AWvDE0mV2VQk40Dowz1AY+C+uolYDMfk86zyNWXMdddfnjpxe7tq2AMdGHtWvrwy7iFUYkFv3qjyHCqBNBL1nSHWOUkrJLEBzgrpteDAwJvDbQgQJI3b4PwxDVTH653hrPEg8SCEYOyJbNrpPFYwiwlYc8arWnxAEpp6LMb7UZMtyY7iOxxSel+/Xqiz6Ul0aWqdeFJp9nV4iY8vCKCPRJNmidNQIT4DFoeEt3MRiH/aSo2o8dexk6Ad3GPITZw==
Received: from BN0PR04CA0102.namprd04.prod.outlook.com (2603:10b6:408:ec::17)
 by CH0PR12MB5059.namprd12.prod.outlook.com (2603:10b6:610:e2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 08:53:50 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::43) by BN0PR04CA0102.outlook.office365.com
 (2603:10b6:408:ec::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Tue, 8 Jun 2021 08:53:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 08:53:49 +0000
Received: from yaviefel (172.20.187.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun 2021 08:53:47
 +0000
References: <20210608085325.61c6056f@canb.auug.org.au>
 <YL8Mz573gNRktQTh@shredder>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
In-Reply-To: <YL8Mz573gNRktQTh@shredder>
Message-ID: <87sg1s20vb.fsf@nvidia.com>
Date:   Tue, 8 Jun 2021 10:53:44 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13d33455-89f6-4ba8-26f4-08d92a5aef1c
X-MS-TrafficTypeDiagnostic: CH0PR12MB5059:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5059B78EC30D1DDCB49AF61FD6379@CH0PR12MB5059.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOMA0qPRaLjUIPpKtSM2AVaFGlE75Pk65KoZuQvRHETKvwjFjnJfNGw9i/ZjHcXCeVC7kAve/adms/m/XCAFrVXziQeyTA6JNW4qHVGNT9mATT2qt1l8bRW2vidn9UqxxxPrHQyA+UTRBiHSTeWpF/7cQnfQVlIMR7qrF3PSTtM2UJ2l2vtlWyEl9eVbGlki3ctRNIn1oV8rdQzow0tD+1+bhwdWjZcwce0vvdOm4AKKZ3HKZw+wNO7mf/DUP165EnKz9f7zr862elP5SwWuccsszLNygy316BF7PPzrm1wCgZs2KxowEaOfZ9gX68eEtpC6nnAXKFOeW/ovUkc4+vEs48qDhsREx4tK/jrESa8RO9jN8iTNExF9waxJR+dlv9Syd/FmDeu3PAhn7FEAYGsjaYNGrO1HA6urH3bG7wITKpq9S8keYi6jZSro0ZaNN+EooFIwhER06Xi9YW4hZWG+Q8RY+SPbL3OKhUIZITqEpyVbYViM5VvRRen+3lh9MWLvTerG5EqzJt+WnvXKMThhxnPd/J+dGXA/EsLFgZQ+63Qt0r6RPetM17A57PD+sQCx6V0wAZAVWC7aic6DAlGa5L1prlN5OzlUHgpnWYppFXNlo7m9ptJaExPWSoWvbrAmi/HztDt+Vdh60Y5LgQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(6862004)(6666004)(37006003)(82310400003)(5660300002)(54906003)(426003)(356005)(4326008)(16526019)(186003)(70206006)(82740400003)(47076005)(4744005)(336012)(8676002)(2616005)(70586007)(2906002)(36756003)(36860700001)(7636003)(316002)(26005)(6636002)(86362001)(478600001)(36906005)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 08:53:49.4909
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d33455-89f6-4ba8-26f4-08d92a5aef1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@nvidia.com> writes:

> On Tue, Jun 08, 2021 at 08:53:25AM +1000, Stephen Rothwell wrote:
>> Hi all,
>> 
>> In commit
>> 
>>   d566ed04e42b ("mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()")
>> 
>> Fixes tag
>> 
>>   Fixes: 28052e618b04 ("mlxsw: spectrum_qdisc: Track children per qdisc")
>> 
>> has these problem(s):
>> 
>>   - Target SHA1 does not exist
>> 
>> Maybe you meant
>> 
>> Fixes: 51d52ed95550 ("mlxsw: spectrum_qdisc: Track children per qdisc")
>
> Yes, correct. Sorry about that. The first was an internal tag. Will
> double-check next time.

My mistake. I must have been looking into the wrong checkout when I was
hunting for the reference.
