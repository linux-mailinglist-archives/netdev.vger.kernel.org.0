Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA04B14691C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgAWNaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:30:30 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45912 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgAWNa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:30:29 -0500
Received: by mail-ed1-f68.google.com with SMTP id v28so3261460edw.12;
        Thu, 23 Jan 2020 05:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IiWAALaEhjJXo291MxNcDCCNHviU2XOa9axp5A6Jt8E=;
        b=Qvhbh/vXUu3aCTWDtyaawFnJLD5iv0v1BrMjOl21CN5+J+O0j4Y+c+unjGEnwbjeNi
         wUkW/8qDOBuKd8mjDxQ0QGqVYm3QjNtgPfCF8GGk212ABuTl1AvFOw8BIiV6sO4sTGGj
         AsvpKzcdbh2ZSuEtGiHsXW8sn7H+scR/joHD2HJ4Dq7sR67LmIVKT8mLu4zTyTqUoltx
         dw4gsCGlrGDhSix7kU81fcx5cqTNLKojkWpydVMlUcjJGUa8nHAWJcdFLp4Q2kXppTAd
         tE3cgvW/vwNAiQ4Sm/Zs5pRqqk6j+Z9DQI5gFGn5yXDaBo0iH1nBSkJlDEYUjGx21f4b
         Ae6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IiWAALaEhjJXo291MxNcDCCNHviU2XOa9axp5A6Jt8E=;
        b=L7orHZknbeJ+YSCrJANaaVMCc2oOCS0woPT/5eQLBgBPV3NpaQu1/o7DLHeDN+kGYH
         ObAUztFEgOze5+CIx8XIHTXL1/sjlAuClEYyihJh3qvrfnNWgKkRAtvUpi3HxNUrDLo6
         o+Enqm0AT2Gj9KVDRH+CREJly2/sNHvrpaDnjBwqL1qESS/PZ9iZg14WzN4pPYOn/W3p
         zlO17dMXZ2LnCzzDiGVIs6xORivuVHz1j2Ax9aD1sDo2ToF35Gepb3A8ne/Rw6sJVUCc
         A2HjWMSEzZMfbYxxcGAQdgA21rQpPp6YJl3G8mRzc/x/cmxKF0Hp2wPZhuUVG1eN3oTf
         5tpg==
X-Gm-Message-State: APjAAAVyklxKFcDqO1x5yxdI4//+LIyOxa1hhHudL3tC2DH5jnx9h95o
        4kaA9qXnDD13FuYlvsJfzGO+JmP/8TE0gM9yn2o=
X-Google-Smtp-Source: APXvYqxt31COidURfCWB7E9cxNx/HSg5G6+Cfz5YpTwRiMseW1+rbdXl0j1Wc8LNge3xcBfuWV4bUNiiOSR7L9urebY=
X-Received: by 2002:a05:6402:19b2:: with SMTP id o18mr928732edz.368.1579786227446;
 Thu, 23 Jan 2020 05:30:27 -0800 (PST)
MIME-Version: 1.0
References: <20191127094517.6255-1-Po.Liu@nxp.com> <87v9p93a2s.fsf@linux.intel.com>
 <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com>
In-Reply-To: <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 23 Jan 2020 15:30:16 +0200
Message-ID: <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Murali,

On Wed, 22 Jan 2020 at 20:04, Murali Karicheri <m-karicheri2@ti.com> wrote:
>
> I have question about the below parameters in The Gate Parameter Table
> that are not currently supported by tc command. Looks like they need to
> be shown to user for management.
>
>      - ConfigChange - Looks like this needs to be controlled by
>        user. After sending admin command, user send this trigger to start
>        copying admin schedule to operation schedule. Is this getting
>        added to tc command?

"The ConfigChange parameter signals the start of a
configuration change for the gate
when it is set to TRUE. This should only be done
when the various administrative parameters
are all set to appropriate values."

As far as my understanding goes, all tc-taprio commands currently
behave as though this boolean is implicitly set to TRUE after the
structures have been set up. I'm not sure there is any value in doing
otherwise.

>      - ConfigChangeTime - The time at which the administrative variables
>        that determine the cycle are to be copied across to the
>        corresponding operational variables, expressed as a PTP timescale

This is the base-time of the admin schedule, no?

"The PTPtime at which the next config change is scheduled to occur.
The value is a representation of a PTPtime value,
consisting of a 48-bit integer
number of seconds and a 32-bit integer number of nanoseconds."

>      - TickGranularity - the management parameters specified in Gate
>        Parameter Table allow a management station to discover the
>        characteristics of an implementation=E2=80=99s cycle timer clock
>        (TickGranularity) and to set the parameters for the gating cycle
>        accordingly.

Not sure who is going to use this and for what purpose, but ok.

>      - ConfigPending - A Boolean variable, set TRUE to indicate that
>        there is a new cycle configuration awaiting installation.

I had tried to export something like this (driver calls back into
sch_taprio.c when hw has applied the config, this would result in
ConfigPending =3D FALSE), but ultimately didn't finish the idea, and it
caused some problems too, due to incorrect RCU usage.

>      - ConfigChangeError - Error in configuration (AdminBaseTime <
>        CurrentTime)

This can be exported similarly.

>      - SupportedListMax - Maximum supported Admin/Open shed list.
>
> Is there a plan to export these from driver through tc show or such
> command? The reason being, there would be applications developed to
> manage configuration/schedule of TSN nodes that would requires these
> information from the node. So would need a support either in tc or
> some other means to retrieve them from hardware or driver. That is my
> understanding...
>

Not sure what answer you expect to receive for "is there any plan".
You can go ahead and propose something, as long as it is reasonably
useful to have.

> Regards,
>
> Murali
>
> --
> Murali Karicheri
> Texas Instruments

Thanks,
-Vladimir
