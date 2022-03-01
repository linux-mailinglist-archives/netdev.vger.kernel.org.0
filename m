Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F974C986E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 23:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbiCAWjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 17:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiCAWjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 17:39:16 -0500
X-Greylist: delayed 459 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 14:38:32 PST
Received: from fox.pavlix.cz (fox.pavlix.cz [185.8.165.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB0036A033;
        Tue,  1 Mar 2022 14:38:30 -0800 (PST)
Received: from [172.16.63.206] (37-48-0-234.nat.epc.tmcz.cz [37.48.0.234])
        by fox.pavlix.cz (Postfix) with ESMTPSA id 8219111111E;
        Tue,  1 Mar 2022 23:30:47 +0100 (CET)
Message-ID: <f7fc9c30-0514-0bfb-ee98-f3944d752d7f@simerda.eu>
Date:   Tue, 1 Mar 2022 23:30:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 net-next 00/10] net: bridge: Multiple Spanning Trees
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, navolnenoze@simerda.eu
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301162142.2rv23g4cyd2yacbs@skbuf> <87fso1nzdt.fsf@waldekranz.com>
From:   =?UTF-8?Q?Pavel_=c5=a0imerda?= <code@simerda.eu>
In-Reply-To: <87fso1nzdt.fsf@waldekranz.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/03/2022 22:20, Tobias Waldekranz wrote:
> On Tue, Mar 01, 2022 at 18:21, Vladimir Oltean <olteanv@gmail.com> wrote:
>> Hi Tobias,
>>
>> On Tue, Mar 01, 2022 at 11:03:11AM +0100, Tobias Waldekranz wrote:
>>> A proposal for the corresponding iproute2 interface is available here:
>>>
>>> https://github.com/wkz/iproute2/tree/mst
>>
>> Please pardon my ignorance. Is there a user-mode STP protocol application
>> that supports MSTP, and that you've tested these patches with?
>> I'd like to give it a try.
> 
> I see that Stephen has already pointed you to mstpd in a sibling
> message.
> 
> It is important to note though, that AFAIK mstpd does not actually
> support MSTP on a vanilla Linux system. The protocol implementation is
> in place, and they have a plugin architecture that makes it easy for people
> to hook it up to various userspace SDKs and whatnot, but you can't use
> it with a regular bridge.
> 
> A colleague of mine has been successfully running a modified version of
> mstpd which was tailored for v1 of this series (RFC). But I do not
> believe he has had the time to rework it for v2. That should mostly be a
> matter of removing code though, as v2 allows you to manage the MSTIs
> directly, rather than having to translate it to an associated VLAN.

Hello,

we experimented with mstpd with pretty reasonable kernel modifications. Vanilla kernel wasn't capable of transferring the correct mapping from mstpd to the hardware due to lack of vlan2msti mapping and per-msti port state (rather than just per-vlan port state).

https://github.com/mstpd/mstpd/pull/112

I didn't pursue this for a while, though.

Regards,
Pavel
