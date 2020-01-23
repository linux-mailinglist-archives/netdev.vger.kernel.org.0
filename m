Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AA7147017
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAWRx7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Jan 2020 12:53:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:30479 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAWRx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 12:53:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 09:49:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="428040520"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jan 2020 09:49:42 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>
Cc:     Po Liu <po.liu@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <87v9p93a2s.fsf@linux.intel.com> <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com> <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com>
Date:   Thu, 23 Jan 2020 09:50:54 -0800
Message-ID: <87d0bajc3l.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Murali,
>
> On Wed, 22 Jan 2020 at 20:04, Murali Karicheri <m-karicheri2@ti.com> wrote:
>>
>> I have question about the below parameters in The Gate Parameter Table
>> that are not currently supported by tc command. Looks like they need to
>> be shown to user for management.
>>
>>      - ConfigChange - Looks like this needs to be controlled by
>>        user. After sending admin command, user send this trigger to start
>>        copying admin schedule to operation schedule. Is this getting
>>        added to tc command?
>
> "The ConfigChange parameter signals the start of a
> configuration change for the gate
> when it is set to TRUE. This should only be done
> when the various administrative parameters
> are all set to appropriate values."
>
> As far as my understanding goes, all tc-taprio commands currently
> behave as though this boolean is implicitly set to TRUE after the
> structures have been set up. I'm not sure there is any value in doing
> otherwise.
>
>>      - ConfigChangeTime - The time at which the administrative variables
>>        that determine the cycle are to be copied across to the
>>        corresponding operational variables, expressed as a PTP timescale
>
> This is the base-time of the admin schedule, no?
>
> "The PTPtime at which the next config change is scheduled to occur.
> The value is a representation of a PTPtime value,
> consisting of a 48-bit integer
> number of seconds and a 32-bit integer number of nanoseconds."
>
>>      - TickGranularity - the management parameters specified in Gate
>>        Parameter Table allow a management station to discover the
>>        characteristics of an implementation’s cycle timer clock
>>        (TickGranularity) and to set the parameters for the gating cycle
>>        accordingly.
>
> Not sure who is going to use this and for what purpose, but ok.
>
>>      - ConfigPending - A Boolean variable, set TRUE to indicate that
>>        there is a new cycle configuration awaiting installation.
>
> I had tried to export something like this (driver calls back into
> sch_taprio.c when hw has applied the config, this would result in
> ConfigPending = FALSE), but ultimately didn't finish the idea, and it
> caused some problems too, due to incorrect RCU usage.
>

If this should be exported, this should be done from taprio, perhaps
adding a new field to what is exported via the dump() callback, which
should be quite easy.

>>      - ConfigChangeError - Error in configuration (AdminBaseTime <
>>        CurrentTime)
>
> This can be exported similarly.

In my view, having this as a "runtime" error is not useful, as we can
verify this at configuration time.

>
>>      - SupportedListMax - Maximum supported Admin/Open shed list.
>>
>> Is there a plan to export these from driver through tc show or such
>> command? The reason being, there would be applications developed to
>> manage configuration/schedule of TSN nodes that would requires these
>> information from the node. So would need a support either in tc or
>> some other means to retrieve them from hardware or driver. That is my
>> understanding...
>>

Hm, now I understamd what you meant here...

>
> Not sure what answer you expect to receive for "is there any plan".
> You can go ahead and propose something, as long as it is reasonably
> useful to have.

... if this is indeed useful, perhaps one way to do is to add a subcommand
to TC_SETUP_QDISC_TAPRIO, so we can retrieve the stats/information we want
from the driver. Similar to what cls_flower does.

>
>> Regards,
>>
>> Murali
>>
>> --
>> Murali Karicheri
>> Texas Instruments
>
> Thanks,
> -Vladimir

Cheers,
--
Vinicius
