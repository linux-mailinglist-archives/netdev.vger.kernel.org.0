Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27AC59C488
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbiHVRCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiHVRCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:02:32 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5213ECD1;
        Mon, 22 Aug 2022 10:02:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGZAENLy+/cOnHt1vcm2cpuPjvzxkS/fRpSGdV3n7QtuVT0Y/HOpaZ0W4B9N+O0+puxO00NuPfuISwudXkn/H+pw9SNAG8LEZ+ohi8n4d73lIW543diiBbqZ21ZZqlBVy5sdDLB+EWaBduk32vwgrcxZGDXblwnfj6uIzPx/fGumKrytQu4O0eKEaBEW99o5PGaS0gvq3r1JwlfD1H1jwfrP8XEwO3dt/Cn85ps89Gnm1fK9QTLuqbLe7fPQKOSqFrgw24KcGE9riCmP79Y51sjn/Ky6YU4ehm7AMIUBJx/dCPblnHX6pQWF217lssvIjLeTRVX7Ct+Pi25mlOrzJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJr9YCp6weid4Gv4GmYWBH9TPqV8uoxWZw+fV3SHx7U=;
 b=SwJ20AVzR+oF7Pfeqx2fp4nI9/BIF+iD6Gxx9+stMKFSOfe9ELnMK4ncsSVIo7F+yRMGsuR55zUNTwXXpGoA/YdBPHPNeO6U2IKxhGRsim2k7c4cDTVmDMAOKj0fU1eAmPo6lKteEHuzH75/RwoKNc3iWQCajwIwV3m9Q/uIqszY/dH/Xg07FwbgFzJi13/xOCQf0CIBg+oqGpa8kNhQ0pnYjU+LbcqycppzYpJVaShAi3lRWCCXjkjeKX9M8xIMAEWlUBjoN276pBvGZvmfRHL2vn26PUpV+FVoOwq/HhFA1Q4EzP74CnElPijS/Midq2O7ClyrPXF1ekRJwNHLyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJr9YCp6weid4Gv4GmYWBH9TPqV8uoxWZw+fV3SHx7U=;
 b=dodEx35Q/LtoHZivuP+g6F+d4Vnqi815fyWUgClPrVpwoCbQOM39CnhKvH0MsaxQ7jZ5+7Snzo8uXamYVrZ8Q9j2qCn37BYv8E9JNtliglKM77ZC7kb9uirGa2cZXUq324KuksUD5wDZKflMg1kjsdBJiYz34UDEK+PHMAEKshA7csQL4g2pK6H/H6TatFmSPDk823kFNSITCwbSsz5PGT4gd6oIdgYc6oj0SvNiMeNW5r+3klyocadoeyJAMjIHZD+CmUrn/Q8Sg9V6x9oa3oeTvfy6QE74oOrNIF8h9gm9O+j18Hnfg2rDsRLAgzdRGAcdaxMbn6mECQBM80F+4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM5PR0301MB2532.eurprd03.prod.outlook.com (2603:10a6:203:9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 17:02:26 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Mon, 22 Aug 2022
 17:02:26 +0000
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
 <20220819164519.2c71823e@kernel.org> <YwAo42QkTgD0kOqz@shell.armlinux.org.uk>
 <b476d7b1-1221-2275-e445-6a70b3a31fe6@seco.com>
 <YwOvqLacWLQNcIk6@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <49692ec6-878f-0b03-d277-6f2d8f3195bd@seco.com>
Date:   Mon, 22 Aug 2022 13:02:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YwOvqLacWLQNcIk6@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0097.namprd04.prod.outlook.com
 (2603:10b6:610:75::12) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 496c051d-cb5e-49e5-e325-08da84601709
X-MS-TrafficTypeDiagnostic: AM5PR0301MB2532:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yJRhg2n3MhVlhgK3BGR5Yy1ezEYspkWeyCInJTzMZ25r17d5IcdO5OI12/XqSOMba/0tGPJ6F7MaocivN3e1L/lpejkcW8m/z+4BJRfGknI0jNW8r2BVQ5dnL9tKrSGyUK+4p7hJ/uxunr9AoihGIhCxGbDQjwXKdipkUS4a0GCTfs/JsDWVG/SCWhBH5DzCC6lb1vq0UgtUA8GkFfDZjviI87KqAvrR8wD7R1WKAgG7gcVyL1Nw9zKvQhtXfl5iNkapJLyTF0PmAspQzhZuaAHvzcY+d4B3kImt/HyYardnjjvvfKvNuN9wLUEmgiCv06HTJMSidMpFz2XJCGiR9YNaOOO7pFm3zOLXx0HkEudZNmWDlOcwl0vIZxVlsllLzDUWDXgXo5BizpK691y14A9fneJUyMyK8GISBR5S6MSjimaLlCQ9HfJQO/seNyzRbgzRyxMIdUEARIOY9yCw4s4MeigRZhY00EdGfx9uv9WS5gPpKsnS8LoM5/48UhhXqIhXnnykHnbjZ99yjgM/MQrUI0CMDLGCV3apV/mji5lcTuuZp/X7TCyn2M6iin0y3L1aNfUz9YRrceiA5aob+EBqs1UWWR7zV3LRyjlp7M5DTLk6NwgtokNTNeScgnB9b1zCP0gRLLJqIvh+DjhJddnEjvIGY7bhU9PsjgD9K+NToteuz9ECnbWx/HncrHmcfYqDHXZgeJ8F9yM/q0QmTtZ+nvOYvyEZh2canCNrLW0oCkkMXKkpAt0PwQF6clpBbxTtRtJkhmJaI2uZk8ZtL+bNic3mNYH0Tw0eu2eb0UtTERQtOkYQuVP7rYx5WgQQzNhb0z/T4vxmkiP7AHCcjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(346002)(396003)(376002)(6486002)(478600001)(186003)(83380400001)(44832011)(2906002)(36756003)(7416002)(38100700002)(41300700001)(31686004)(8936002)(66476007)(86362001)(31696002)(66556008)(8676002)(4326008)(54906003)(38350700002)(5660300002)(6916009)(66946007)(2616005)(6666004)(52116002)(53546011)(6506007)(6512007)(316002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnRKY3JGUHZnU0oxUUZQdEloMjFkNW9EQXZYZlpwb21TNW0zN2twWExqYWVv?=
 =?utf-8?B?R0tEVWhrWVNHQXVxa2RaaFcrdHNHVCtWT1c4NWpOOGNnaFhUSzFxMWZwd2gz?=
 =?utf-8?B?elcrMjRtcEZ1VGtVWHIvZHNLQzBpNEdhUFFqQi9hSDVmeGwvWTlQZDRMVnVR?=
 =?utf-8?B?ZlFQMDJCVEwxb0FBQmtOMHRKMC9aSG5uR1RIRnV2VUZwVy8xQmRWek40RVhs?=
 =?utf-8?B?VXEwbDhTMjJZQktveVN1QlhWUUp0RUZybnpET3NZbkFhRzdOeHVwRGNRdFJK?=
 =?utf-8?B?SmRtaUo4YVQwOUlBRFNNT1JUWnVvWWY4UDcxWTRONVgxUnZqd3pkdEU3MlZr?=
 =?utf-8?B?Q3F6ZDRxT1FpU3Rua0poKzZ5dFBnQnRudEFnaDNzbnpsRmtHZU1LdGF2eElH?=
 =?utf-8?B?L2lSWk96b1c3TE5sMjFKbEpPcG03TDREREc4blhySEpBaC9zaThqR2Q3YWV6?=
 =?utf-8?B?THJDV3FJRnVaWmpRWWFEcVl4anQxWmJtTmk3N3FqWDdoSlpUT2ZmY2R2TWUr?=
 =?utf-8?B?VmVQRll3U0lLcytUR0JuMFd6dW9GYWwyNjZLQnUxc3orcHlseXEvT1ZGaTZH?=
 =?utf-8?B?eUdOeGlaTGNUazZqQWp6UFBIdDRaMUI3UUZxOEw1cmNRelA5bmcyUnd3TnE1?=
 =?utf-8?B?Znp4UTZDTmFTSURjWTkyMXVWWFZKcURRSEJqT0Q3WHp1b1pvS0Y1dXNTS2Iw?=
 =?utf-8?B?Y2UzOUh3WkF0YVVjRnlxUGJDR1oxcFNIRnJ4THBvTDA3M0xwMnZIemZGbXAr?=
 =?utf-8?B?Wnp4Zkd3Z3RWOStRd3F5em9pTWd6NmZub01nTWRhN01hUFUrNG40Ym5MS0lS?=
 =?utf-8?B?VHptSDN2WXZJRVEzV01NRnMra25yVEYwUnE4ZXdORnBQZVBRN1NkeUFrYlZh?=
 =?utf-8?B?aXczc1gvS0x4aThzcDhLeXV2SWF3YWVlQXI5NlpnVDB0ZXFBc2tyTTlwd2Iy?=
 =?utf-8?B?Znh4MncvZkxqWG92ODBVbnFvb3RRdVAwTGNvU0t1VzArK29uN0Fvemo2YU9q?=
 =?utf-8?B?N2RTN2FmUUhub1NqdGFxYzRPbGYwaUpsdit0L2xOdGxXNnFBRlJmZTVEMFc3?=
 =?utf-8?B?L1lnLzdxTFJuZzQxd1lhdzZkdkY5QXp0ZGsvMDFuN2k2TExYOGVBOGllTHh6?=
 =?utf-8?B?VlFvdFdmYmJsY1pNTTFKbVkvcDF6OVhqUHJyK3BTVk1kMjJDM1JvVkJhMmVM?=
 =?utf-8?B?eEZPcnRIU2J3Z0NUUkt4cjZ0QmtsbGNYVmRHUlFFRXZUZmJsbWtRVkhDLzJ0?=
 =?utf-8?B?dFZJYWNiNnRQemQ5bDNCQXBHMEYraG1aelQ4amRETHR2TUd5cUZaTjk2aDJa?=
 =?utf-8?B?dk9XTG1MM05BdHk2ZDl6Y3hsN1VTWmVUL00vWlJoSHhRU0VyTFhvMllDZW9n?=
 =?utf-8?B?Mm1kRVJWdFJLMTZLNmVpVFJsQlpkencwYmNncVVCcVlZMGg2cHRxNVd4LzM4?=
 =?utf-8?B?WmdDaWVSeTM4YlBmWXB3RjlJY1lsZVl5V1RhZjdmVzJROTJucEl2TVB4eCti?=
 =?utf-8?B?R3FRY3kydWVxM1UzUDlSdFYwNkpIVnN6L2FhS0Y4UXNtZnZ0S3luVkhMTjFH?=
 =?utf-8?B?OHgwY013Nm10VkFDdWp5WVRCTndseEdvY3Z1VGt4a0pGeUYyNThSZTd2YnZs?=
 =?utf-8?B?MFIxbW01bCt2a2VTTEpVa2NRdWtxT0ErZmMzL3c3YmliWHhqa2gxQ1E0N09U?=
 =?utf-8?B?bUh5bGpUZGFMNmVndUF3TjhvVTFDR2ZLTEtrYjNud1lwOVIwYVhyV25YdVcz?=
 =?utf-8?B?bERPUU44UTJ5ZldNUUw3RERqNTZHYTk2TFpJWFpxQk14eWQrR05XaEtvMElh?=
 =?utf-8?B?N2Yvd3dBQlltRVBTZ2cvc2Eybnp1R1orVEk2UHZUU2ZlcFNCVXlUWFRvcDJn?=
 =?utf-8?B?QXc2dVFVb29ZaUtwL3htTEg3SE5vdEMyNENPMGZDVHdSR3c4eUlrd1VSeG5a?=
 =?utf-8?B?Rmg1QW5hVkNqdUVaRDBhK0p0MFJ0OW5ZZ1ZkVGdUbTlQaWxSSmFvK0tJa2JB?=
 =?utf-8?B?ZUhuQXhSQzdMSnd1dUd6eURyVTFtMzRhS3RJYWMrYXMyMGpRb0hDYU5uQU9L?=
 =?utf-8?B?bEF4OEpzSU9lMGh0S21WNlZrZk1LMDd2VWVzaXJ6clJqQTBCS2hHenFQSThY?=
 =?utf-8?B?OStrblNmTEVOeE5uWmt5VXY3aSs5VzNtTVVwcVdGQmRzNm5yZDN4RVF0WGlV?=
 =?utf-8?B?S2c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 496c051d-cb5e-49e5-e325-08da84601709
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 17:02:26.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WAj6WTR8EIPPY3W3iZfqnh20ASV5Q/RdTctUXbe6C5rsAqLl1slZCnawsQg2yF4bDjKtQTQ42VKdwR3MbkQyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0301MB2532
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/22/22 12:32 PM, Russell King (Oracle) wrote:
> On Mon, Aug 22, 2022 at 12:00:28PM -0400, Sean Anderson wrote:
>> In the last thread I posted this snippet:
>> 
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index a74b320f5b27..05894e1c3e59 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/phy.h>
>>  #include <linux/phy_led_triggers.h>
>>  #include <linux/property.h>
>> +#include <linux/rtnetlink.h>
>>  #include <linux/sfp.h>
>>  #include <linux/skbuff.h>
>>  #include <linux/slab.h>
>> @@ -3111,6 +3112,13 @@ static int phy_remove(struct device *dev)
>>  {
>>         struct phy_device *phydev = to_phy_device(dev);
>>  
>> +	// I'm pretty sure this races with multiple unbinds...
>> +       rtnl_lock();
>> +       device_unlock(dev);
>> +       dev_close(phydev->attached_dev);
>> +       device_lock(dev);
>> +       rtnl_unlock();
>> +       WARN_ON(phydev->attached_dev);
>> +
>>         cancel_delayed_work_sync(&phydev->state_queue);
>>  
>>         mutex_lock(&phydev->lock);
>> ---
>> 
>> Would this be acceptable? Can the locking be fixed?
> 
> I can't comment on that.

:l

I feel like doing device_unlock is very wrong, but someone in the dev_close
call calls device_lock and it deadlocks.

>> > Addressing the PCS part of the patch posting and unrelated to what we
>> > do for phylib...
>> > 
>> > However, I don't see "we'll do this for phylib, so we can do it for
>> > PCS as well" as much of a sane argument - we don't have bazillions
>> > of network drivers to fix to make this work for PCS. We currently
>> > have no removable PCS (they don't appear with a driver so aren't
>> > even bound to anything.) So we should add the appropriate handling
>> > when we start to do this.
>> > 
>> > Phylink has the capability to take the link down when something goes
>> > away, and if the PCS goes away, that's exactly what should happen,
>> > rather than oopsing the kernel.
>> 
>> Yeah, but we can't just call phylink_stop; we have to call the function
>> which will call phylink_stop, which is different for MAC drivers and
>> for DSA drivers.
> 
> I think that's way too much and breaks the phylink design. phylink_stop
> is designed to be called only from ndo_close() - and to be paired with
> phylink_start().

Well, the driver almost certainly wants to bring the link down (so that
it can stop using the PCS) Maybe we just need to call
phylink_run_resolve_and_disable(pl, PHYLINK_DISABLE_STOPPED)?

> When I talk about "taking the link down" what I mean by that is telling
> the network device that the *link* *is* *down* and no more. In other
> words, having phylink_resolve() know that there should be a PCS but it's
> gone, and therefore the link should not come up in its current
> configuration.

Fundamentally the driver is the one which owns the PCS, not phylink. The
driver is perfectly capable of touching the PCS by accident or on purpose,
including calling PCS operations directly. We already have two in-tree
drivers which do this (mt7530 and mvpp2). I also used this method when
conversion dpaa to phylink. In the patch before the conversion, I
switched to the lynx PCS instead of using the existing (ad-hoc) helpers.

So we can't just handle everything in phylink; the driver has to be
involved too. And of course, what happens when the link is brought back
up again? The driver will once again offer the (now bogus) PCS. Will we
have to track dead PCSs forever? What happens if another (valid) PCS gets
allocated at the same address as the old PCS?

>> I think we'd need something like
>> 
>> struct phylink_pcs *pcs_get(struct device *dev, const char *id,
>> 			    void (*detach)(struct phylink_pcs *, void *),
>> 			    void *priv)
>> 
>> which would also require that pcs_get is called before phylink_start,
>> instead of in probe (which is what every existing user does).
> 
> That would at least allow the MAC driver to take action when the PCS
> gets removed.
> 
>> This whole thing has me asking the question: why do we allow unbinding
>> in-use devices in the first place?
> 
> The driver model was designed that way from the start, because in most
> cases when something is unplugged from the system, the "remove" driver
> callback is just a notification that the device has already gone.
> Failing it makes no sense, because software can't magic the device
> back.
> 
> Take an example of a USB device. The user unplugs it, it's gone from
> the system, but the system briefly still believes the device to be
> present for a while. It eventually notices that the device has gone,
> and the USB layer unregisters the struct device - which has the effect
> of unbinding the device from the driver and eventually cleaning up the
> struct device.
> 
> This can and does happen with Ethernet PHYs ever since we started
> supporting SFPs with Ethernet PHYs. The same thing is true there -
> you can pull the module at any moment, it will be gone, and the
> system will catch up with its physical disconnection some point later.
> It's no good trying to make ->remove say "no, the device is still in
> use, I won't let you remove it" because there's nothing software can
> do to prevent the going of the device - the device has already
> physically gone.

OK, that clears things up.

> I don't think that's the case with PCS - do we really have any PCS
> that can be disconnected from the system while it's running? Maybe
> ones in a FPGA and the FPGA can be reprogrammed at runtime (yes,
> people have really done this in the past.)

This is actually a pretty good case for PCS drivers, since the MAC
has no idea what kind of PCS it's hooked up to when there's a PCS on
the FPGA.

> If we don't want to support "hotpluggable" PCS, then there's a
> simple solution to this - the driver model has the facility to suppress
> the bind/unbind driver files in sysfs, which means userspace can't
> unbind the device. If there's also no way to make the struct device go
> away in the kernel, then effectively the driver can then only be
> unbound if the driver is built as a module.
> 
> At that point, we always have the option of insisting that PCS drivers
> are never modules - and then we have the situation where a PCS will
> never disappear from the system once the driver has picked up on it.

Well can't we increment the module refcount?

> Of course, those PCS that are tightly bound to their MACs can still
> come and go along with their MACs, but it's up to the MAC driver to
> make that happen safely (unregistering the netdev first, which will
> have the effect of calling ndo_close(), taking the network device
> down and preventing further access to the netdev - standard netdev
> MAC driver stuff.)

And I'm not too worried about that; there's no need to create a separate
device for the PCS if it's always present.

--Sean
