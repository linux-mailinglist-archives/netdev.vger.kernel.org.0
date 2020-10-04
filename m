Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C77A282959
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 09:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgJDHQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 03:16:05 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15754 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDHQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 03:16:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f79767f0000>; Sun, 04 Oct 2020 00:15:11 -0700
Received: from [10.21.180.76] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 4 Oct
 2020 07:15:55 +0000
Subject: Re: [PATCH net-next 16/16] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-17-git-send-email-moshe@mellanox.com>
 <20201003091430.GG3159@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <dcd15cad-2e08-bee3-9271-d17505554c2d@nvidia.com>
Date:   Sun, 4 Oct 2020 10:15:52 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201003091430.GG3159@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601795711; bh=gzF2jTeM+PQWrjUQgsM/XsXJdqsXSR11VWlJEV/C+gA=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=FIRxPSX/eubOu4eTm/+3VS6ZWNKlou/yQ0QSOu8n3ASCtGd6TGLEZEc+X3zbXRlkZ
         pLQqKTm/Dh54L8/j+u/ks1p3+RyUsUGcfQ49XQuRIjDXFsTCvEnEhE40vRR8QqFrbc
         dyIjUrkuYqHx7Sox8EXa3W1S9/Gv2zqCvXovKWoXqri8OX/WFm5tvyc3ml9K3prY/r
         uBDkedLM+iGlXUBmBk/KHxfZ6ua5E4K8P2dRF9AnMUqnjM39b5uu0NLuCcDD/4TGF1
         UInBVh3s+dKau9hGQlt19+AT2V+1LnC4RKqZ7UIwZ/ibQblTwvewlhd43/KypgLhkM
         jpjacdjQA4EQw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/3/2020 12:14 PM, Jiri Pirko wrote:
> Thu, Oct 01, 2020 at 03:59:19PM CEST, moshe@mellanox.com wrote:
>> Add devlink reload rst documentation file.
>> Update index file to include it.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> RFCv5 -> v1:
>> - Rename reload_action_limit_level to reload_limit
>> RFCv4 -> RFCv5:
>> - Rephrase namespace chnage section
>> - Rephrase note on actions performed
>> RFCv3 -> RFCv4:
>> - Remove reload action fw_activate_no_reset
>> - Add reload actions limit levels and document the no_reset limit level
>>   constrains
>> RFCv2 -> RFCv3:
>> - Devlink reload returns the actions done
>> - Replace fw_live_patch action by fw_activate_no_reset
>> - Explain fw_activate meaning
>> RFCv1 -> RFCv2:
>> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>>   actions driver_reinit,fw_activate,fw_live_patch
>> ---
>> .../networking/devlink/devlink-reload.rst     | 81 +++++++++++++++++++
>> Documentation/networking/devlink/index.rst    |  1 +
>> 2 files changed, 82 insertions(+)
>> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>>
>> diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>> new file mode 100644
>> index 000000000000..5abc5c2c75fd
>> --- /dev/null
>> +++ b/Documentation/networking/devlink/devlink-reload.rst
>> @@ -0,0 +1,81 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +==============
>> +Devlink Reload
> No reason for capital "R".


It looks as the convention here for rst headers, as in 
devlink-region.rst, devlink-trap.rst, devlink-resource.rst

>
>> +==============
>> +
>> +``devlink-reload`` provides mechanism to either reinit driver entities,
>> +applying ``devlink-params`` and ``devlink-resources`` new values or firmware
>> +activation depends on reload action selected.
> Could you perhaps split the sentense? It is hard to read.
Yes.
>
>> +
>> +Reload actions
>> +==============
>> +
>> +User may select a reload action.
>> +By default ``driver_reinit`` action is selected.
>> +
>> +.. list-table:: Possible reload actions
>> +   :widths: 5 90
>> +
>> +   * - Name
>> +     - Description
>> +   * - ``driver-reinit``
>> +     - Devlink driver entities re-initialization, including applying
>> +       new values to devlink entities which are used during driver
>> +       load such as ``devlink-params`` in configuration mode
>> +       ``driverinit`` or ``devlink-resources``
>> +   * - ``fw_activate``
>> +     - Firmware activate. Activates new firmware if such image is stored and
>> +       pending activation. If no limitation specified this action may involve
>> +       firmware reset. If no new image pending this action will reload current
>> +       firmware image.
>> +
>> +Note that even though user asks for a specific action, the driver
>> +implementation might require to perform another action alongside with
>> +it. For example, some driver do not support driver reinitialization
>> +being performed without fw activation. Therefore, the devlink reload
>> +command returns the list of actions which were actrually performed.
>> +
>> +Reload limits
>> +=============
>> +
>> +By default reload actions are not limited and driver implementation may
>> +include reset or downtime as needed to perform the actions.
>> +
>> +However, some drivers support action limits, which limit the action
>> +implementation to specific constrains.
>> +
>> +.. list-table:: Possible reload limits
>> +   :widths: 5 90
>> +
>> +   * - Name
>> +     - Description
>> +   * - ``no_reset``
>> +     - No reset allowed, no down time allowed, no link flap and no
>> +       configuration is lost.
>> +
>> +Change namespace
>> +================
>> +
>> +The netns option allow user to be able to move devlink instances into
> "allows"
Ack.
>
>> +namespaces during devlink reload operation.
>> +By default all devlink instances are created in init_net and stay there.
>> +
>> +example usage
>> +-------------
>> +
>> +.. code:: shell
>> +
>> +    $ devlink dev reload help
>> +    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [ limit no_reset ]
>> +
>> +    # Run reload command for devlink driver entities re-initialization:
>> +    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
>> +    reload_actions_performed:
>> +      driver_reinit
>> +
>> +    # Run reload command to activate firmware:
>> +    # Note that mlx5 driver reloads the driver while activating firmware
>> +    $ devlink dev reload pci/0000:82:00.0 action fw_activate
>> +    reload_actions_performed:
>> +      driver_reinit fw_activate
>> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
>> index 7684ae5c4a4a..d82874760ae2 100644
>> --- a/Documentation/networking/devlink/index.rst
>> +++ b/Documentation/networking/devlink/index.rst
>> @@ -20,6 +20,7 @@ general.
>>     devlink-params
>>     devlink-region
>>     devlink-resource
>> +   devlink-reload
>>     devlink-trap
>>
>> Driver-specific documentation
>> -- 
>> 2.18.2
>>
