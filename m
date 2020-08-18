Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1EE24819D
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHRJOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:14:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8836 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRJOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:14:32 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3b9be90000>; Tue, 18 Aug 2020 02:14:17 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Aug 2020 02:14:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Aug 2020 02:14:31 -0700
Received: from [10.21.180.203] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Aug
 2020 09:14:19 +0000
Subject: Re: [PATCH net-next RFC v2 13/13] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-14-git-send-email-moshe@mellanox.com>
 <20200817163933.GB2627@nanopsycho>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <a786a68d-df60-cae3-5fb1-3648ca1c69d8@nvidia.com>
Date:   Tue, 18 Aug 2020 12:14:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817163933.GB2627@nanopsycho>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597742057; bh=ftMP7LAH7UKvxd8RNXoLVtSTVK7oA55WF9geKbrBmcE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=Z3pcIsgMoVKMx05ZtLIRf5MOLvyn/eAfEmtyy0uakG5t7eBYY+mhqfg8BO8zC9RVp
         c0bjMUbpJlEtpRGoMu2K0dJZZ6L7lty1KSlr/AIT2faX1EVCbfujzJP9jXlbbJEf5h
         CTWd7c1mbRZKWilSmFd9rqoLNJXnU8mBYAg0jw6wHfjT1RIwF5xH8DGFEncqe0k89N
         /y9KnzSu3OSCINS6CeFqrLrAp1Tv26btG3WtlooHXaZWwzflGzz8HA47D9xshsKiYl
         zntfFMTdZxPbZOmXNzg5s83hTApM8JFRsjRZwnFpLaE+s95YSDtaPChu379ATH2Dhi
         gzi/R61XVFG5g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/17/2020 7:39 PM, Jiri Pirko wrote:
> Mon, Aug 17, 2020 at 11:37:52AM CEST, moshe@mellanox.com wrote:
>> Add devlink reload rst documentation file.
>> Update index file to include it.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>>   actions driver_reinit,fw_activate,fw_live_patch
>> ---
>> .../networking/devlink/devlink-reload.rst     | 54 +++++++++++++++++++
>> Documentation/networking/devlink/index.rst    |  1 +
>> 2 files changed, 55 insertions(+)
>> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>>
>> diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>> new file mode 100644
>> index 000000000000..9846ea727f3b
>> --- /dev/null
>> +++ b/Documentation/networking/devlink/devlink-reload.rst
>> @@ -0,0 +1,54 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +==============
>> +Devlink Reload
>> +==============
>> +
>> +``devlink-reload`` provides mechanism to either reload driver entities,
>> +applying ``devlink-params`` and ``devlink-resources`` new values or firmware
>> +activation depends on reload action selected.
>> +
>> +Reload actions
>> +=============
>> +
>> +User may select a reload action.
>> +By default ``driver_reinit`` action is done.
>> +
>> +.. list-table:: Possible reload actions
>> +   :widths: 5 90
>> +
>> +   * - Name
>> +     - Description
>> +   * - ``driver-reinit``
>> +     - Driver entities re-initialization, including applying
>> +       new values to devlink entities which are used during driver
>> +       load such as ``devlink-params`` in configuration mode
>> +       ``driverinit`` or ``devlink-resources``
>> +   * - ``fw_activate``
>> +     - Firmware activate. Can be used for firmware reload or firmware
>> +       upgrade if new firmware is stored and driver supports such
>> +       firmware upgrade.
> Does this do the same as "driver-reinit" + fw activation? If yes, it
> should be written here. If no, it should be written here as well.
>

No, The only thing required here is the action of firmware activation. 
If a driver needs to do reload to make that happen and do reinit that's 
ok, but not required.

>> +   * - ``fw_live_patch``
>> +     - Firmware live patch, applies firmware changes without reset.
>> +
>> +Change namespace
>> +================
>> +
>> +All devlink instances are created in init_net and stay there for a
>> +lifetime. Allow user to be able to move devlink instances into
>> +namespaces during devlink reload operation. That ensures proper
>> +re-instantiation of driver objects, including netdevices.
>> +
>> +example usage
>> +-------------
>> +
>> +.. code:: shell
>> +
>> +    $ devlink dev reload help
>> +    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { fw_live_patch | driver_reinit | fw_activate } ]
>> +
>> +    # Run reload command for devlink driver entities re-initialization:
>> +    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
>> +
>> +    # Run reload command to activate firmware:
>> +    $ devlink dev reload pci/0000:82:00.0 action fw_activate
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
>> 2.17.1
>>
