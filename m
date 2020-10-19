Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB729230F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgJSHkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:40:21 -0400
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:61907 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgJSHkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 03:40:20 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 03:40:20 EDT
IronPort-SDR: 0vfhQ4TKOy46x3X9FsKpxxu4nIrYHHT4Z7vcZpw5Vz87tJTIi8HGFEzcdUNPjIxl6PuLab9eNs
 5yi4kZ2A6Eu1ET9Qm9WfCjtJQI9zf/LSqkn2y0Q9d5qPWxdxSgSbI7dyz4nRNxHtkqFikdMaQo
 VbjOV+wsmqPHq7Kq7CmAgYTRn9JVoRM2r+Zr3s140s/L0/weo5LGcFKYAdf5+ZavA/VX2zKwc6
 IVee9cs8gf6ukkRq8aEV4mPrw5zoVhXxYjH5osZOvK50kwKZQ9RGpElQpdiNWEtZlfUwUR2Cc/
 qAg=
X-IronPort-AV: E=Sophos;i="5.77,394,1596528000"; 
   d="scan'208";a="56358194"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa1.mentor.iphmx.com with ESMTP; 18 Oct 2020 23:33:13 -0800
IronPort-SDR: 94hb2TNwQ8JmgpSo2vHl8oKWvzJ8X0FVboOZLH3MKnNwe7RVC9xgbCP5W5P4nM4tIpxzeqhX98
 4JNWMru1i7HV1/5cEohaKd+4fZV/tBcW7SjKhiGtTO11USDx65mQ42O8WZo6O8L8gNd3S0kG+Z
 Hy4ouYgEiaXiMI9Nf795/czEtfvk5xnSKbPe6Am5A5kjfLSVqzz04gzjcQxS+xtxIXotEo2B9H
 3Tbm5SJkDJPhG4Mo/uiII5+LOV1B8nhcS8sAGXTmZrKEENj1FdCLRd6mq4K/CKng2ySrWbmmlY
 j5k=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     'Sergei Shtylyov' <sergei.shtylyov@gmail.com>
CC:     <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <geert+renesas@glider.be>,
        Julia Lawall <julia.lawall@inria.fr>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20200930192124.25060-1-andrew_gabbasov@mentor.com> <000001d697c2$71651d70$542f5850$@mentor.com> <2819a14d-500c-561b-337e-417201eb040f@gmail.com>
In-Reply-To: <2819a14d-500c-561b-337e-417201eb040f@gmail.com>
Subject: RE: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Mon, 19 Oct 2020 10:32:59 +0300
Organization: Mentor Graphics Corporation
Message-ID: <000001d6a5ea$16fe8e80$44fbab80$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHWl179dggpQ/YNgUW3t7t7L6TDlKmcTonagAJPmgA=
Content-Language: en-us
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-03.mgc.mentorg.com (139.181.222.3) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sergei,

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@gmail.com]
> Sent: Saturday, October 17, 2020 10:49 PM
> To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> Cc: linux-renesas-soc@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; geert+renesas@glider.be; Julia Lawall <julia.lawall@inria.fr>; Behme, Dirk - Bosch
> <dirk.behme@de.bosch.com>; Eugeniu Rosca <erosca@de.adit-jv.com>
> Subject: Re: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
> 
> Hello!
> 
> On 10/1/20 10:13 AM, Andrew Gabbasov wrote:
> 
>    The patch was set to the "Changes Requested" state -- most probably because of this
> mail. Though unintentionally, it served to throttle actions on this patch. I did only
> remember about this patch yesterday... :-)
> 
> [...]
> >> In the function ravb_hwtstamp_get() in ravb_main.c with the existing
> > values
> >> for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL
> >> (0x6)
> >>
> >> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
> >> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> >> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
> >> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
> >>
> >> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true, it will never be
> >> reached.
> >>
> >> This issue can be verified with 'hwtstamp_config' testing program
> >> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type to
> > ALL
> >> and subsequent retrieving it gives incorrect value:
> >>
> >> $ hwtstamp_config eth0 OFF ALL
> >> flags = 0
> >> tx_type = OFF
> >> rx_filter = ALL
> >> $ hwtstamp_config eth0
> >> flags = 0
> >> tx_type = OFF
> >> rx_filter = PTP_V2_L2_EVENT
> >>
> >> Correct this by converting if-else's to switch.
> >
> > Earlier you proposed to fix this issue by changing the value
> > of RAVB_RXTSTAMP_TYPE_ALL constant to 0x4.
> > Unfortunately, simple changing of the constant value will not
> > be enough, since the code in ravb_rx() (actually determining
> > if timestamp is needed)
> >
> > u32 get_ts = priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE;
> > [...]
> > get_ts &= (q == RAVB_NC) ?
> >                 RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
> >                 ~RAVB_RXTSTAMP_TYPE_V2_L2_EVENT;
> >
> > will work incorrectly and will need to be fixed too, making this
> > piece of code more complicated.
> >
> > So, it's probably easier and safer to keep the constant value and
> > the code in ravb_rx() intact, and just fix the get ioctl code,
> > where the issue is actually located.
> 
>    We have one more issue with the current driver: bit 2 of priv->tstamp_rx_ctrl
> can only be set as a part of the ALL mask, not individually. I'm now thinking we
> should set RAVB_RXTSTAMP_TYPE[_ALL] to 2 (and probably just drop the ALL mask)...

[skipped]

>    Yeah, that's better. But do we really need am anonymous bit 2 that can't be
> toggled other than via passing the ALL mask?

The driver supports setting timestamps either for all packets or for some
particular kind of packets (events). Bit 1 in internal mask corresponds
to this selected kind. Bit 2 corresponds to all other packets, and ALL mask 
combines both variants. Although bit 2 can't be controlled individually
(since there is no much sense to Request stamping of only packets, other than
events, moreover, there is no user-visible filter constant to represent it),
and that's why is anonymous, it provides a convenient way to handle stamping
logic in ravb_rx(), so I don't see an immediate need to get rid of it.

Thanks.

Best regards,
Andrew

