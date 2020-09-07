Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6B1260243
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgIGRVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:21:46 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17933 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729618AbgIGNrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 09:47:24 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5639990001>; Mon, 07 Sep 2020 06:46:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 07 Sep 2020 06:46:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 07 Sep 2020 06:46:15 -0700
Received: from [10.21.180.11] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Sep
 2020 13:46:04 +0000
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <1598801254-27764-2-git-send-email-moshe@mellanox.com>
 <20200831121501.GD3794@nanopsycho.orion>
 <9fffbe80-9a2a-33de-2e11-24be34648686@nvidia.com>
 <20200902094627.GB2568@nanopsycho>
 <20200902083025.43407d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200903055729.GB2997@nanopsycho.orion>
 <20200903124719.75325f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200904090450.GH2997@nanopsycho.orion>
 <20200904125647.799e66e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <6bd0fa45-68ce-b82d-98e6-327c6cd50e80@nvidia.com>
Date:   Mon, 7 Sep 2020 16:46:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200904125647.799e66e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599486361; bh=sezZ54ZD5NQ3LevSrG7FfxnzS5K+ZBc6/xKbw6Ghdtk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=j87jGnf4hAx99HX18Vz4sFPm10YlIagjhYt7hUTVfiDYDB/u7GB2y5Fj07DfmvKVn
         ly8I+bBqw2woI6HY/0vcYACfDa+kVjZ7lMQm6INiKy5JILysUWUOjVcUqK3FG1k3hM
         NsEaL988wxRmjtvaU25MgmX+x7f+zEfawETJM4JOXMwXNbGwhRxYlVBBGNs4w3kssM
         5f9pckjKHtw9ptP+veBgh3l6M91aT3+VqkhQ4fq3ZiK4ZvwHjBpf3TJvTOOkt1TfAO
         4SfhpLqz1gHmDNCVwB6lbYHT1qc3QUpNoWPxPGEmbEYtkNhWC64EbxzmqVBQCfc91x
         VBTZjukiXjkQA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/4/2020 10:56 PM, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Fri, 4 Sep 2020 11:04:50 +0200 Jiri Pirko wrote:
>> Thu, Sep 03, 2020 at 09:47:19PM CEST, kuba@kernel.org wrote:
>>> On Thu, 3 Sep 2020 07:57:29 +0200 Jiri Pirko wrote:
>>>> Wed, Sep 02, 2020 at 05:30:25PM CEST, kuba@kernel.org wrote:
>>>>> On Wed, 2 Sep 2020 11:46:27 +0200 Jiri Pirko wrote:
>>>>>>> ? Do we need such change there too or keep it as is, each action by=
 itself
>>>>>>> and return what was performed ?
>>>>>> Well, I don't know. User asks for X, X should be performed, not Y or=
 Z.
>>>>>> So perhaps the return value is not needed.
>>>>>> Just driver advertizes it supports X, Y, Z and the users says:
>>>>>> 1) do X, driver does X
>>>>>> 2) do Y, driver does Y
>>>>>> 3) do Z, driver does Z
>>>>>> [
>>>>>> I think this kindof circles back to the original proposal...
>>>>> Why? User does not care if you activate new devlink params when
>>>>> activating new firmware. Trust me. So why make the user figure out
>>>>> which of all possible reset option they should select? If there is
>>>>> a legitimate use case to limit what is reset - it should be handled
>>>>> by a separate negative attribute, like --live which says don't reset
>>>>> anything.
>>>> I see. Okay. Could you please sum-up the interface as you propose it?
>>> What I proposed on v1, pass requested actions as a bitfield, driver may
>>> perform more actions, we can return performed actions in the response.
>> Okay. So for example for mlxsw, user might say:
>> 1) I want driver reinit
>>      kernel reports: fw reset and driver reinit was done
>> 2) I want fw reset
>>      kernel reports: fw reset and driver reinit was done
>> 3) I want fw reset and driver reinit
>>      kernel reports: fw reset and driver reinit was done
> Yup.
>
>>> Then separate attribute to carry constraints for the request, like
>>> --live.
>> Hmm, this is a bit unclear how it is supposed to work. The constraints
>> apply for all? I mean, the actions are requested by a bitfield.
>> So the user can say:
>> I want fw reset and driver reinit --live. "--live" applies to both fw
>> reset and driver reinit? That is odd.
> The way I was thinking about it - the constraint expresses what sort of
> downtime the user can accept. So yes, it'd apply to all. If any of the
> reset actions does not meet the constraint then error should be
> returned.
>
> In that sense I don't like --live because it doesn't really say much.
> AFAIU it means 1) no link flap; 2) < 2 sec datapath downtime; 3) no
> configuration is lost in kernel or device (including netdev config,
> link config, flow rules, counters etc.). I was hoping at least the
> documentation in patch 14 would be more precise.


Actually, while writing "no-reset" or "live-patching" I meant also no=20
downtime at all and nothing resets (config, rules ... anything), that=20
fits mlx5 live-patching.

However, to make it more generic,=C2=A0 I can allow few seconds downtime an=
d=20
add similar constrains as you mentioned here to "no-reset". I will add=20
that to the documentation patch.

> I think you're saying that it's strange to express that as a constraint
> because internally it maps to one of two fw reset types. And there is
> only one driver reinit procedure. But I don't think that the
> distinction of reset types is valuable to the user. What matters is if
> application SLAs will be met or not.
>
> I assume that deeper/longer reset is always less risky and would be
> preferred unless constraint is specified.
>
>>> I'd think the supported actions in devlink_ops would be fine as a
>>> bitfield, too. Combinations are often hard to capture in static data.
