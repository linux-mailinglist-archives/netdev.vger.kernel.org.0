Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16038232108
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgG2OyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:54:16 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:63456
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgG2OyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 10:54:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVaW2WBuDL7O3IzlkfjQuGghZ3o1+ixJHb9VIpy1LhWEYkEuP48aiyzIoI1/8Ag5aaX+S+h16iA5OAvO8W/RbWChwRCIWHp5CWmkj00S/pVpwgwGlgYMKktkdXy9pQnjDoC/4D2ZWPMiPXfkQcbJ0AldJY8xtlO5/pGkgcP+ykIxN7HihqKZ5fwHDpqci6g3tCtrK7/k7vFs4wkwGKSMMsHOTFAbpcDuzySpC2E0agAtPBilhF5N7bEfS7woNtX9Ovne4+uQUl9ELabW9d27RBxyCFzz0j9NFwGcoL3aFLKW02v3LQJ5rVqxQC7iuv8XNupxsSMJv3flrHjNy209lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNOZAyIdIFRjKut2K9fyHsLE/QWWbOLvSG9cWK1nISo=;
 b=c1kRV0zOnbnKFkzbCU341I0Kv/R/yBjYlL+g5RxhgFoCtjCNH4pDYoTmtIvNoI7dgBqCFKEMo08u8gVOD2ynxedUShHrXmezRXYLuKLGZt9j8e0BZ3W+21z6JF/qrSrdvviT+28h0dnhup4ENHAMu9W+RuUTKy7jPvmRe/OAzpAK7OAVsDdVO3GWo6COWujc1RggylgwctHGHwm0xV2HnE/+G0XOBj7Pjctis8iG8XXfBPgLLBl4ZJXyF0fRxaVk00tmLtW16ZlrrgL0U7MwTgdYiCWJThUBdCbuuc0wrO1XDizzJGVGVxkOjFifm/5mK3/6caalgCEeAbPzHS4uZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNOZAyIdIFRjKut2K9fyHsLE/QWWbOLvSG9cWK1nISo=;
 b=tR8qshk9PmLWN6WvgnXBR2S04pUQtjBjaku8dtYfPRHMVRuQ/QJ4Ib06uGeqgVSXkKKNHdqSoc2YL6/aeXQ7P7VdjiyK5DRH24BbAb0y4kF2+wQu03dfxEq3mh+qA64ngXmBuH3kT4LJf7e+F0Iz5JN9pXQbpi/kWTmNTQ9+XWo=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR0502MB4049.eurprd05.prod.outlook.com (2603:10a6:208:12::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Wed, 29 Jul
 2020 14:54:10 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 14:54:10 +0000
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-2-git-send-email-moshe@mellanox.com>
 <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200728135808.GC2207@nanopsycho>
 <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
 <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
 <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
Date:   Wed, 29 Jul 2020 17:54:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::31) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.20.10.2] (2.53.56.39) by AM0P190CA0021.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Wed, 29 Jul 2020 14:54:09 +0000
X-Originating-IP: [2.53.56.39]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ae41bf1-96cc-4f67-d219-08d833cf408a
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4049:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40490D6BB6F1ED156B8C9610D9700@AM0PR0502MB4049.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4E2BylmrfrNLk1IJ8bsaICBJIj8RQi/k/8hS6PnBRAU1eJj5o0kOK9Jb90pF53B4ATvhLAV0PSelb5rIcyluIqIWr+fOYdvfOoTSGuq423w7MxiVP8YkNy3iYKefJmjHxCbLCHU3aGvins8BbZ4TNDWQGU7X12rtErP2ei3n44fPYgMyvrnkW/uRMxUzbTMiBz8QIj4vVwJQOINZzU+7Ul8biXpshl4kL1X4M+rQMnXrxijc8oRaKnYDU2kDzrihzDImACw6Iw7Rbl1Arg720T5eIiy21mxQyXRMuamJ/9CnT+dnw+iYValCyJWifviUBeqm5ZZhrXqvV2xkC0l2Lz5fn1uv+D/pQ4c4cxXY2UKSEYdPx7Tk0S//FUgKgQc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(83380400001)(956004)(54906003)(36756003)(478600001)(2616005)(110136005)(2906002)(31686004)(4326008)(6486002)(316002)(8936002)(186003)(86362001)(16526019)(53546011)(26005)(31696002)(66476007)(16576012)(8676002)(52116002)(5660300002)(66556008)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PSadNoLsBK3YdHtVs5Ftda+Hl7bB2vI+O3N9NpID+bco2vCxV3IExpdPdPvWt55w9Ssb1u5Nf4Hi/kkL7tvqRsS2VOVyyhPze959GZQglCq6Gq/3l9ZDb2saZ7ycSGY2d7skohCr8RPdTsWJKQ//hE4F+UJS/514KBrJSjIhXj8Vyjn2rFz/DLMw+GrYSrSlBWxKPX37PYwEDWnw9tLJYnYrkcN6RaRk3g/JZygBat7eQe2gSzhmw8lp9/Yy2CcRw/addrPkm7d7y8cd7B5yDr56SrTd3Fzts7pU5HKyaID6Ydu5knGq9D+RUsLN3x0/NXVjKveahnxFGLWSRFr6ovvfgkkAIxVQ9AYCrGaStCjZFiufrVUdhDvQyR19EAagTgtkEvxEZ/sdviOZQ1XLu1kssER2c3fRw2mfZhm1tmL2qhLI3iixl1lLG+Cmb7OWXrMX2xFPrHgPrMrrAv7vbeKUw7rfitauP1Wlk/RyMxc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae41bf1-96cc-4f67-d219-08d833cf408a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 14:54:10.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: quRwvSxpytlLtGeiRYMcD9j8koWR/0x85g5qjLOFW0nnKSqet5COIxDEeweHuCN84nfilu/GpSwkTdZ9dKOVaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/28/2020 11:06 PM, Jakub Kicinski wrote:
> On Tue, 28 Jul 2020 12:18:30 -0700 Jacob Keller wrote:
>> On 7/28/2020 11:44 AM, Jakub Kicinski wrote:
>>>  From user perspective what's important is what the reset achieves (and
>>> perhaps how destructive it is). We can define the reset levels as:
>>>
>>> $ devlink dev reload pci/0000:82:00.0 net-ns-respawn
>>> $ devlink dev reload pci/0000:82:00.0 driver-param-init
>>> $ devlink dev reload pci/0000:82:00.0 fw-activate
>>>
>>> combining should be possible when user wants multiple things to happen:
>>>
>>> $ devlink dev reload pci/0000:82:00.0 fw-activate driver-param-init
>> Where today "driver-param-init" is the default behavior. But didn't we
>> just say that mlxsw also does the equivalent of fw-activate?
> Actually the default should probably be the combination of
> driver-param-init and net-ns-respawn.


What about the support of these combinations, one device needs to reset 
fw to apply the param init,

while another device can apply param-init without fw reset, but has to 
reload the driver for fw-reset.

So the support per driver will be a matrix of combinations ?

> My expectations would be that the driver must perform the lowest reset
> level possible that satisfies the requested functional change.
> IOW driver may do more, in fact it should be acceptable for the driver
> to always for a full HW reset (unless --live or other constraint is
> specified).


OK, but some combinations may still not be valid for specific driver 
even if it tries lowest level possible.

>>> We can also add the "reset level" specifier - for the cases where
>>> device is misbehaving:
>>>
>>> $ devlink dev reload pci/0000:82:00.0 level [driver|fw|hardware]
>> I guess I don't quite see how level fits in? This is orthogonal to the
>> other settings?
> Yup, it is, it's already orthogonal to what reload does today, hence the
> need for the "driver default" hack.
>
>>> But I don't think that we can go from the current reload command
>>> cleanly to just a level reset. The driver-specific default is a bad
>>> smell which indicates we're changing semantics from what user wants
>>> to what the reset depth is. Our semantics with the patch as it stands
>>> are in fact:
>>>   - if you want to load new params or change netns, don't pass the level
>>>     - the "driver default" workaround dictates the right reset level for
>>>     param init;
>>>   - if you want to activate new firmware - select the reset level you'd
>>>     like from the reset level options.
>>>    
>> I think I agree, having the "what gets reloaded" as a separate vector
>> makes sense and avoids confusion. For example for ice hardware,
>> "fw-activate" really does mean "Do an EMP reset" rather than just a
>> "device reset" which could be interpreted differently. ice can do
>> function level reset, or core device reset also. Neither of those two
>> resets activates firmware.
>>
>> Additionally the current function load process in ice doesn't support
>> driver-init at all. That's something I'd like to see happen but is quite
>> a significant refactor for how the driver loads. We need to refactor
>> everything out so that devlink is created early on and factor out
>> load/unload into handlers that can be called by the devlink reload. As I
>> have primarily been focused on flash update I sort of left that for the
>> future because it was a huge task to solve.
> Cool! That was what I was concerned about, but I didn't know any
> existing driver already has the problem. "FW reset" is not nearly
> a clear enough operation. We'd end up with drivers differing and
> users having to refer to vendor documentation to find out which
> "reset level" maps to what.
>
> I think the components in ethtool-reset try to address the same
> problem, and they have the notion of per-port, and per-device.
> In the modern world we lack the per-host notion, but that's still
> strictly clearer than the limited API proposed here.
