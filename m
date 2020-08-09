Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA71623FE64
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 15:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgHINVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 09:21:39 -0400
Received: from mail-eopbgr50069.outbound.protection.outlook.com ([40.107.5.69]:55745
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbgHINVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 09:21:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar1teoYckXje65/7unTW37DNY7P9ACnBgMl39OwMOMxTz+teLs8rb+gaB0JWlxWYYHVl/z5oYXzayh6gsEV5mqD0lkx5QZNKzf+2L3BPeIU5aj32ex2mkObzAqDMstm15oAeyHGJY8fqnQcOgTA0d5AzAeYl3MospQhHDKxsH8dr2QajeRkh4fGdPkyiZ27zShyUkk66ChqF7K5xHxLnSYIh9bRHegj6aoEPVLQDw2Jp3aFJ0AUQSFAmuznggBsSycOrMf0+KuNlYEuGrA6cGyx5FR8xbF6kpEdzqJ23X6JOnPLvKfxrF6n4VPZB/AS4etObwZj8SKtAd1K+u9vDNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2twGEFVLLRbRs6cwYMIJTDIKiLaiiQKvsTSD0yJTFs0=;
 b=CpoP488b1OZ7st2fzvaitjaFv/WAsT6TnNY1maIGJQkUAL3Mf2cDmhcfzal/cENzukr9SDRTYIYApIhaDM0xWq1dsQYSrDr1/q24bNaYra0Q2l6NycI1OAuiW39KU/jV2++ZTih67U7sqVPIv1atkP6DyXC4TkyOPInfM5NjmgfWdbAdzJYPW7HHXEB8IEHu5B5EUkrYAaOsUyfKpD6tsE3Rp7GD2CXSMaFJ8EqigCogHL5+gHFujbfdSByP66GkgA3xsACxR/P86hv1qddhNs+98ZjPCH95/n2kHctLQqRjrNKmSpOtJjcs25eFYjQEyt7GT1+O9dp+3I8iQ8cKpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2twGEFVLLRbRs6cwYMIJTDIKiLaiiQKvsTSD0yJTFs0=;
 b=ePSnpeT68KUzDWuDxSbqF0RvZdV6Ey7wpS5ZmiGqQ7q2kXAZ6IFVOB7IfYWd+w5ybVaN8COFbZ/fC2yhLbPnmRx8Tgq8gjF2yWGBHoOrZ5ch49Sj3Wu9Xj+YJxLF4uK/SzOmM0Dilc6fh2qbj+d4YKkOPxVCIr2Grk7hGyGERJQ=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB5683.eurprd05.prod.outlook.com (2603:10a6:208:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Sun, 9 Aug
 2020 13:21:34 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3261.022; Sun, 9 Aug 2020
 13:21:34 +0000
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
 <20200803141442.GB2290@nanopsycho>
 <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200804100418.GA2210@nanopsycho>
 <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200805110258.GA2169@nanopsycho>
 <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <8b06ade2-dfbe-8894-0d6a-afe9c2f41b4e@mellanox.com>
Date:   Sun, 9 Aug 2020 16:21:29 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::20) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.0.0.9] (141.226.210.185) by FR2P281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.7 via Frontend Transport; Sun, 9 Aug 2020 13:21:33 +0000
X-Originating-IP: [141.226.210.185]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4403c194-00a6-44ef-68ce-08d83c672328
X-MS-TrafficTypeDiagnostic: AM0PR05MB5683:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB5683477F9F98EE28E2E58A91D9470@AM0PR05MB5683.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RZz7QpIO61OnW+G613a9DTRnbMQVSS0BiJ7DNIMDwy4bZGzCi6mSOEph14PKFb//JjC7EhUULHh8qll30fB39txiZB3HERRBjgeQ5DqEMiRFZQCQ+ER6saXt9OhQCVi5xi7eazNss15v1UwDmN2Idd+unSwjTylUMPyHaeqkCDBawNWtpQJFOW4OeVuTR8EYi4JJr5BKMVjCvvq9CxrrXFxaxAx8e1TVTbS162mnHTSt2cK70U1FKIqbFEdSOWfdJqKyweSJP+saWPG2Rzbe5+8ojjMGbLxgGUBWVVV+BYBeszjoVGjCDRHj4SRwdh1iUNI2y5Pb7GvdxP3mYfKmoXxhPwO9A+M9EX2HKwBtXzb548PYsT0SrmYJ7qHI/Ncr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(8936002)(2906002)(8676002)(66476007)(66556008)(66946007)(16576012)(26005)(83380400001)(36756003)(54906003)(316002)(6666004)(53546011)(52116002)(956004)(110136005)(2616005)(31686004)(4326008)(6486002)(31696002)(5660300002)(186003)(86362001)(508600001)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cT55lLR5ni9DgSH7p0asHspYg9XynQ/uJ3BrClWZv0NiRIfS1hFU2mQlDuNXQrYNEfAghBmZNT29Az5YAWnYeDbyp7TfNFsZYilujcUNn1rbPla0UiYEuXPzhIG4Bz7zE7NfHrjtXmYY7QnHH+YZW2rtwglPte61xYAfIGgC7W1rv8IoLub3qjtbfCmZjRi9gBUhGS3zVf0BV0RrNPfnOovgWNsUuhm0+ThPijx+W6nk+gEyTB/hKLzUidvFR6X5pnUbL7hvz6fr0aqnfLWpk1kby978BLrunkLxjMnPWxguAlOgRTY1uWFnqfh8dJNrXbRNA9N60UVnF4oHJ6eJWcf83FheQEl6vsNRhWoCdyC+i7vVPWN3o/8NDXYgwdL/IRhVdl0SoGgs+v+GDfxPaKRXu2zJCj+zAhmepEuWLMpRa2ldZoFU3l1JO4cCjXwtuu7q2jDJ8G7IcxPD/GlO15LJ9LEs2ilEbO/3knS5FlqRsruADUT8lDz19vv1Dt7vEx48krJFoysgmpkeOE+3KbFYtdw6oO3ZRVj41b9DY79NtK1CTfucjj8V99ipIsE1NoX2wFBnFGgSFwctt5WIxk1EUGWuqLdZ7Razkldd5BTusS0j9EDRlqT7rMRQiPt5Tu0iBmn+Acf6OVXE92FhSA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4403c194-00a6-44ef-68ce-08d83c672328
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2020 13:21:34.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+MaOMHDWO/GIjRyrIYNJtJzCHFkMIcw80k0iHGclWimq0P4mMuuRsx0IMOrHoMPpAhlkajfa+Uz7OFCmD/4Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5683
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/6/2020 9:25 PM, Jakub Kicinski wrote:
> On Wed, 5 Aug 2020 13:02:58 +0200 Jiri Pirko wrote:
>> Tue, Aug 04, 2020 at 10:39:46PM CEST, kuba@kernel.org wrote:
>>> AFAIU the per-driver default is needed because we went too low
>>> level with what the action constitutes. We need maintain the higher
>>> level actions.
>>>
>>> The user clearly did not care if FW was reset during devlink reload
>>> before this set, so what has changed? The objective user has is to
>> Well for mlxsw, the user is used to this flow:
>> devlink dev flash - flash new fw
>> devlink dev reload - new fw is activated and reset and driver instances
>> are re-created.
> Ugh, if the current behavior already implies fw-activation for some
> drivers then the default has to probably be "do all the things" :S


Okay, so devlink reload default for mlx5 will include also fw-activate 
to align with mlxsw default.

Meaning drivers that supports fw-activate will add it to the default.

The flow of devlink reload default on mlx5 will be:

If there is FW image pending and live patch is suitable to apply, do 
live patch and driver re-initialization.

If there is FW image pending but live patch doesn't fit do fw-reset and 
driver-initialization.

If no FW image pending just do driver-initialization.


I still think I should on top of that add the level option to be 
selected by the user if he prefers a specific action, so the uAPI would be:

devlink dev reload [ netns { PID | NAME | ID } ] [ level { fw-live-patch 
| driver-reinit |fw-activate } ]

But I am still missing something: fw-activate implies that it will 
activate a new FW image stored on flash, pending activation. What if the 
user wants to reset and reload the FW if no new FW pending ? Should we 
add --force option to fw-activate level ?


>>> activate their config / FW / move to different net ns.
>>>
>>> Reloading the driver or resetting FW is a low level detail which
>>> achieves different things for different implementations. So it's
>>> not a suitable abstraction -> IOW we need the driver default.
>> I'm confused. So you think we need the driver default?
> No, I'm talking about the state of this patch set. _In this patchset_
> we need a driver default because of the unsuitable abstraction.
>
> Better design would not require it.
>
>>> The work flow for the user is:
>>>
>>> 0. download fw to /lib/firmware
>>> 1. devlink flash $dev $fw
>>> 2. if live activation is enabled
>>>    yes - devlink reload $dev $live-activate
>>>    no - report machine has to be drained for reboot
>>>
>>> fw-reset can't be $live-activate, because as Jake said fw-reset does
>>> not activate the new image for Intel. So will we end up per-driver
>>> defaults in the kernel space, and user space maintaining a mapping from
>> Well, that is what what is Moshe's proposal. Per-driver kernel default..
>> I'm not sure what we are arguing about then :/
> The fact that if I do a pure "driver reload" it will active new
> firmware for mlxsw but not for mlx5. In this patchset for mlx5 I need
> driver reload fw-reset. And for Intel there is no suitable option.
>
>>> a driver to what a "level" of reset implies.
>>>
>>> I hope this makes things crystal clear. Please explain what problems
>>> you're seeing and extensions you're expecting. A list of user scenarios
>>> you foresee would be v. useful.
