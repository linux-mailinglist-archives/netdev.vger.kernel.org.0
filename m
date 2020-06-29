Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86D420E11D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389866AbgF2UwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731382AbgF2TN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:27 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A06C0086DF;
        Mon, 29 Jun 2020 02:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UITaDtik3TgkNSQ9PzQddqgiFID8HTmXsFa7SuF5y8wwetNWL7HLjrzfL86Yln7BxiBlK9JoyrbbBrMtqZwAU66OKisp3xEPs+CTy7ZsMumn/sBaw5Bebd/apkce8dZjnQJy0bGTBG0ZVgL5Yp/5LNKvF7+PtbJqFv/IYe7m/Gpi5eTPI4xyxbhK0Lz+LVEohhtJ/ayJckb/OanlyZJ38tDtrupMST6cGn7joL6jDotYZsF9CPfZ4yDFYdPzi0+U0GlXy1T3Vn9m0shXlrZd4pMZOStIjkWvxxsUEV0BkjO73KUqbx38tbheSp11zpEu5RplrI+buckdnsqHB0McYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH/NWJ7E5p/H1YBJoHen+4xqy2PxcClr8Q3yad6/QUE=;
 b=E1M6x9WkPt+ySc0ZMX5StkYT2Ftwyz6Tb8PcjG30omfP0MtZVSaQEoPLN916QHmL+UExheC3A550f+akLDuqJhmPHKsSVYSy/vFNA18lZO9merWNw9tS7RJiKIhOvUVJOHv81NizNej7B478y+0/1gaai7JOoG+Df7udYFl+J//GOfTZbu0pEFx5774jppfXW7HgNTum24D5um0vzPwkBmTWkR89vuLyDYmGmBn3y1gxK2siZmDm6Txy7m+sBtS9q/9NGaIvMRQLGy08uX1LU1nZrlhNAwYjaytXrbOFby8aOv8UH3KF06jhtAKRzpGVQbJyII5udAA5GiVpYYBUAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CH/NWJ7E5p/H1YBJoHen+4xqy2PxcClr8Q3yad6/QUE=;
 b=tcqw7Pe1GylBmb49HmLUyfpVMeVt1J0t9hjQSKiwOUMJYQr4xK4I7qYqHZvwfwDYBRSYIWh3Im8fE6kyJlD4kYXh4aTtoGxi/AB+M1uerqgLG9J0FDzvtU16+2SURePoy6YT6wDGq39spVfoTifM/l44HqwAkGYUae/jxBRyjmY=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none
 header.from=mellanox.com;
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (2603:10a6:10:d1::21)
 by DB8PR05MB6012.eurprd05.prod.outlook.com (2603:10a6:10:a7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 09:32:48 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::a406:4c1a:8fd0:d148%4]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 09:32:48 +0000
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, linux-pci@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
References: <20200626201254.GA2932090@bjorn-Precision-5520>
From:   Aya Levin <ayal@mellanox.com>
Message-ID: <ca121a18-8c11-5830-9840-51f353c3ddd2@mellanox.com>
Date:   Mon, 29 Jun 2020 12:32:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200626201254.GA2932090@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0101CA0067.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::35) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.11] (37.142.4.236) by AM4PR0101CA0067.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Mon, 29 Jun 2020 09:32:46 +0000
X-Originating-IP: [37.142.4.236]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1561de66-62a2-4208-ae24-08d81c0f62bd
X-MS-TrafficTypeDiagnostic: DB8PR05MB6012:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR05MB60126932478352CD5E5029FAB06E0@DB8PR05MB6012.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lf8zog0kvBIgeiDqIcP+4s4JA5/GbYuG6vTy1RcO1A70nA+Ul6Yk3GRo+dQaHOkZe/4e6ocTcU4J2G/GPucQYLmgYuAaDwKJESuHtj3mOv+3AwfIexIryxH0eR5g9zviSaaTwrEhyeSx1yKzmerjmtkesHB95CfGlA3KX+S9jESHeAE09GmqUX4ZjGqQudiA2xGed8oEfHfW1/wNnz92pgeLCb7HFk5COdIcX5OygH7eOhB90O/3/gnoKMrZAJq8YYG6hiPFEXV1fXfO9xd4sdJcfFBSfBCaFT9epJ2k/yKU9lXp0hV8/XdWo8DR6LbR3tsLcwQksN1kRIxk9P5B1yEDE6CRheRbYXX0nfPGBwZoTzWC5U8dtSFO1wcKYuS6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB6299.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(478600001)(110136005)(5660300002)(54906003)(66476007)(66946007)(16576012)(66556008)(316002)(956004)(36756003)(52116002)(2616005)(8676002)(53546011)(83380400001)(86362001)(6486002)(8936002)(4326008)(26005)(31696002)(2906002)(31686004)(186003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a+zqsYpsOAebAltFNQdfUEVgsY8H/2NJasDgb6cTTsRzp+x5B0ZHar0qDEJMagh6CJ5M/rh9leY/3NbQ+sDtgtVUaNiiiQz0PazAxgeKV1xFb+chwtqD4/P4xLyS4uAjD0d5J12cmWpdSRU2pBgTSlDtY7VJTMAQcBTYjZITy4dFhpuGH5vOL/MLEA4KEjci5fQshEMAPlUItnnmZAFcrMM91Q248p5ehgSo6NSsDnw3GiR+VllHXM49Q1vIs2nqslV+OdtEC4KCKMofxBfHYuo9SKkOEQWq2vJ4Ju/jcHHaT92qLE9SEHZrCtUw9GAW1xXIwqddfE6rwftYLbew9kqSLdtbEzp/Ep0c4EdXWFbDsTZ8CBvnwz7zQ/I9KHGz+QP5D9rhfgtuE1QY+fFtX8hWtlUDMUJYO1hfyh82jL79JIa/tehLCAhhX0uUby1xXwH5YSwobC67arhrS9vi7N2Tu6oaH0r0jnR558AP5W0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1561de66-62a2-4208-ae24-08d81c0f62bd
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB6299.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 09:32:48.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sq8iiErDYGcK49wZ2hqwsxKYWaCf+THS8SDhAm1VMljdkKAsKBbOIXiwRO6uDSHxfLhp9d+t9IVKspFeXyDbBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6012
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/2020 11:12 PM, Bjorn Helgaas wrote:
> On Wed, Jun 24, 2020 at 10:22:58AM -0700, Jakub Kicinski wrote:
>> On Wed, 24 Jun 2020 10:34:40 +0300 Aya Levin wrote:
>>>>> I think Michal will rightly complain that this does not belong in
>>>>> private flags any more. As (/if?) ARM deployments take a foothold
>>>>> in DC this will become a common setting for most NICs.
>>>>
>>>> Initially we used pcie_relaxed_ordering_enabled() to
>>>>    programmatically enable this on/off on boot but this seems to
>>>> introduce some degradation on some Intel CPUs since the Intel Faulty
>>>> CPUs list is not up to date. Aya is discussing this with Bjorn.
>>> Adding Bjorn Helgaas
>>
>> I see. Simply using pcie_relaxed_ordering_enabled() and blacklisting
>> bad CPUs seems far nicer from operational perspective. Perhaps Bjorn
>> will chime in. Pushing the validation out to the user is not a great
>> solution IMHO.
> 
> I'm totally lost, but maybe it doesn't matter because it looks like
> David has pulled this series already.
> 
> There probably *should* be a PCI core interface to enable RO, but
> there isn't one today.
> 
> pcie_relaxed_ordering_enabled() doesn't *enable* anything.  All it
> does is tell you whether RO is already enabled.
> 
> This patch ([net-next 10/10] net/mlx5e: Add support for PCI relaxed
> ordering) apparently adds a knob to control RO, but I can't connect
> the dots.  It doesn't touch PCI_EXP_DEVCTL_RELAX_EN, and that symbol
> doesn't occur anywhere in drivers/net except tg3, myri10ge, and niu.
> 
> And this whole series doesn't contain PCI_EXP_DEVCTL_RELAX_EN or
> pcie_relaxed_ordering_enabled().

I wanted to turn on RO on the ETH driver based on 
pcie_relaxed_ordering_enabled().
 From my experiments I see that pcie_relaxed_ordering_enabled() return 
true on Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. This CPU is from 
Haswell series which is known to have bug in RO implementation. In this 
case, I expected pcie_relaxed_ordering_enabled() to return false, 
shouldn't it?

In addition, we are worried about future bugs in new CPUs which may 
result in performance degradation while using RO, as long as the 
function pcie_relaxed_ordering_enabled() will return true for these 
CPUs. That's why we thought of adding the feature on our card with 
default off and enable the user to set it.

> 
> I do have a couple emails from Aya, but they didn't include a patch
> and I haven't quite figured out what the question was.
> 
>>>> So until we figure this out, will keep this off by default.
>>>>
>>>> for the private flags we want to keep them for performance analysis as
>>>> we do with all other mlx5 special performance features and flags.
