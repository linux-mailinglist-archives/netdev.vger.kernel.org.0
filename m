Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1661726347D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbgIIRVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:21:22 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16841 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbgIIRU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:20:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f58d8380000>; Wed, 09 Sep 2020 06:27:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 06:27:33 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 09 Sep 2020 06:27:33 -0700
Received: from [10.26.75.108] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 13:27:22 +0000
Subject: Re: [PATCH net-next RFC v3 01/14] devlink: Add reload action option
 to devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
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
 <6bd0fa45-68ce-b82d-98e6-327c6cd50e80@nvidia.com>
 <20200907105850.34726158@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <b0550422-83a4-4e97-46e3-cb5f431a6dd7@nvidia.com>
Date:   Wed, 9 Sep 2020 16:27:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907105850.34726158@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599658040; bh=OugWLf77e29jNSxlOkOYuMZsn3NrrTySpTzRlJPN99o=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=In0ND108KpeaY4kZvrXL9+qbX7Xa4WCVVY7wgfX8/otBJAqS8tl4ve4QGRObf8RFZ
         ukKMmV/lPK/IXOCIXhjSeteSqQbxCcGe1VqL85VYSk/S2QH8ZhItgSlJqGVe15njsP
         1L3Fw3WAEzwp90m8e7PT/BPZvh83XJ89Y3qYrz7gsv4fwRrq7KY1seanNXl2ERj5Zb
         phQHThh7qdi3X4pv2bQYgAKJUFq9kfsU66Bkl8TCHsbqqygfzmsXPiXqjvRWX1+B+8
         tv2WcyT3m4yNmXDRzFOQDvDFNfIEALmbFCO81EOBTcgi1fqgWmBD5sgXPiiF8C7mZi
         93F2QjlTxYxWg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/7/2020 8:58 PM, Jakub Kicinski wrote:
> On Mon, 7 Sep 2020 16:46:01 +0300 Moshe Shemesh wrote:
>>> In that sense I don't like --live because it doesn't really say much.
>>> AFAIU it means 1) no link flap; 2) < 2 sec datapath downtime; 3) no
>>> configuration is lost in kernel or device (including netdev config,
>>> link config, flow rules, counters etc.). I was hoping at least the
>>> documentation in patch 14 would be more precise.
>> Actually, while writing "no-reset" or "live-patching" I meant also no
>> downtime at all and nothing resets (config, rules ... anything), that
>> fits mlx5 live-patching.
>>
>> However, to make it more generic,  I can allow few seconds downtime and
>> add similar constrains as you mentioned here to "no-reset". I will add
>> that to the documentation patch.
> Oh! If your device supports no downtime and packet loss at all that's
> great. You don't have to weaken the definition now, whoever needs a
> weaker definition can add a different constraint level later, no?


Yes, but if we are thinking there will be more levels, maybe the flag=20
"--live" or "--no_reset" is less extendable, we may need new attr. I=20
mean should I have uAPI command line like:

$ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action {=20
driver_reinit | fw_activate } [ limit_level=C2=A0 no_reset ] ]


