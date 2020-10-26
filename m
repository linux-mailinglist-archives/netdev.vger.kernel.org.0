Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470C4298A65
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769831AbgJZK3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:29:41 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:63606 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769657AbgJZK3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:29:41 -0400
IronPort-SDR: otwfDwVkQZr3NQwBywMU8ffQKo7cZtyxE47KOtsHGQi5MT1KQ5gUJAoLsxqst7UEMC9DOXr9e3
 QzxaqF8yO2O+3q4FmafIijEyoB0ZCKANM6kMegymPPKSPF3IHUIR78RhWbyNWZyUlg8xbaNl8w
 H0+SRGe7edkEmo2vGmNDRc+zYMO2HFU1BL261oqauRW6EnWzE36O3jyVH2FQmZ5o/l8OaU7UfT
 tIBnBrjfS9qkIiMVQwQU/jlAwXsMMrLYQlxPxNh7DDhwpLDpad9rFbjtEyHntTsU8LW2zAllcw
 i9E=
X-IronPort-AV: E=Sophos;i="5.77,419,1596528000"; 
   d="scan'208";a="54324541"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa3.mentor.iphmx.com with ESMTP; 26 Oct 2020 02:29:39 -0800
IronPort-SDR: O0g58AkoeYCj7u7+jb91zeViXBebA06j6obqBo10HcdbDlEj9EPxk/TZ0GB8xNe0zPKE2q5mHM
 vCjrkkdepk4awBx/KXFvt4W45f4wZ7/L8B0vAgaOw8zp4+swW7zwqp9ifVmCUeBC9XKFqhbOiT
 m0es60O02ASbx9mDk7ptCcYtPS+gmxOPgcIpc7neTts6WMuNUNrzKxYpQqQBqhSApyoatSNLXR
 rIfY3ZW+9XbkjxUvL7goWDqcc2T07xFJvUl+qzuxhB/jDZutqls5ohQT9xin1ot95A4UsteoHC
 CIA=
From:   Andrew Gabbasov <andrew_gabbasov@mentor.com>
To:     'Sergei Shtylyov' <sergei.shtylyov@gmail.com>
CC:     <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <geert+renesas@glider.be>,
        Julia Lawall <julia.lawall@inria.fr>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20200930192124.25060-1-andrew_gabbasov@mentor.com> <000001d697c2$71651d70$542f5850$@mentor.com> <2819a14d-500c-561b-337e-417201eb040f@gmail.com> <000001d6a5ea$16fe8e80$44fbab80$@mentor.com> <ead79908-7abd-93da-f943-2387f4137875@gmail.com>
In-Reply-To: <ead79908-7abd-93da-f943-2387f4137875@gmail.com>
Subject: RE: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
Date:   Mon, 26 Oct 2020 13:29:26 +0300
Organization: Mentor Graphics Corporation
Message-ID: <000001d6ab82$e4fcf6d0$aef6e470$@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHWl179dggpQ/YNgUW3t7t7L6TDlKmcTonagAs3kmCAAk8jUA==
Content-Language: en-us
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: SVR-IES-MBX-04.mgc.mentorg.com (139.181.222.4) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

Thank you for the review.

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@gmail.com]
> Sent: Saturday, October 24, 2020 9:02 PM
> To: Gabbasov, Andrew <Andrew_Gabbasov@mentor.com>
> Cc: linux-renesas-soc@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; geert+renesas@glider.be; Julia Lawall <julia.lawall@inria.fr>; Behme, Dirk - Bosch
> <dirk.behme@de.bosch.com>; Eugeniu Rosca <erosca@de.adit-jv.com>
> Subject: Re: [PATCH net] ravb: Fix bit fields checking in ravb_hwtstamp_get()
> 
> Hello!
> 
> On 10/19/20 10:32 AM, Andrew Gabbasov wrote:
> 
>    Sorry for the delay again, I keep forgetting about the mails I' couldn't reply
> quickly. :-|
> 
> [...]
> >>    The patch was set to the "Changes Requested" state -- most probably because of this
> >> mail. Though unintentionally, it served to throttle actions on this patch. I did only
> >> remember about this patch yesterday... :-)
> >>
> >> [...]
> >>>> In the function ravb_hwtstamp_get() in ravb_main.c with the existing values
> >>>> for RAVB_RXTSTAMP_TYPE_V2_L2_EVENT (0x2) and RAVB_RXTSTAMP_TYPE_ALL (0x6)
> >>>>
> >>>> if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_V2_L2_EVENT)
> >>>> 	config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> >>>> else if (priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE_ALL)
> >>>> 	config.rx_filter = HWTSTAMP_FILTER_ALL;
> >>>>
> >>>> if the test on RAVB_RXTSTAMP_TYPE_ALL should be true, it will never be
> >>>> reached.
> >>>>
> >>>> This issue can be verified with 'hwtstamp_config' testing program
> >>>> (tools/testing/selftests/net/hwtstamp_config.c). Setting filter type to ALL
> >>>> and subsequent retrieving it gives incorrect value:
> >>>>
> >>>> $ hwtstamp_config eth0 OFF ALL
> >>>> flags = 0
> >>>> tx_type = OFF
> >>>> rx_filter = ALL
> >>>> $ hwtstamp_config eth0
> >>>> flags = 0
> >>>> tx_type = OFF
> >>>> rx_filter = PTP_V2_L2_EVENT
> >>>>
> >>>> Correct this by converting if-else's to switch.
> >>>
> >>> Earlier you proposed to fix this issue by changing the value
> >>> of RAVB_RXTSTAMP_TYPE_ALL constant to 0x4.
> >>> Unfortunately, simple changing of the constant value will not
> >>> be enough, since the code in ravb_rx() (actually determining
> >>> if timestamp is needed)
> >>>
> >>> u32 get_ts = priv->tstamp_rx_ctrl & RAVB_RXTSTAMP_TYPE;
> >>> [...]
> >>> get_ts &= (q == RAVB_NC) ?
> >>>                 RAVB_RXTSTAMP_TYPE_V2_L2_EVENT :
> >>>                 ~RAVB_RXTSTAMP_TYPE_V2_L2_EVENT;
> >>>
> >>> will work incorrectly and will need to be fixed too, making this
> >>> piece of code more complicated.
> 
>    Judging on the above code, we can only stamp RAVB_RXTSTAMP_TYPE_V2_L2_EVENT
> on the NC queue, and the rest only on the BE queue, right?

Yes, this is how it is implemented now. Frankly speaking, I didn't dig
too deeply into the deriver code to understand whether it is correct
and if there could be any other variants.

> >>> So, it's probably easier and safer to keep the constant value and
> >>> the code in ravb_rx() intact, and just fix the get ioctl code,
> >>> where the issue is actually located.
> >>
> >>    We have one more issue with the current driver: bit 2 of priv->tstamp_rx_ctrl
> >> can only be set as a part of the ALL mask, not individually. I'm now thinking we
> >> should set RAVB_RXTSTAMP_TYPE[_ALL] to 2 (and probably just drop the ALL mask)...
> >
> > [skipped]
> >
> >>    Yeah, that's better. But do we really need am anonymous bit 2 that can't be
> >> toggled other than via passing the ALL mask?
> >
> > The driver supports setting timestamps either for all packets or for some
> > particular kind of packets (events). Bit 1 in internal mask corresponds
> > to this selected kind. Bit 2 corresponds to all other packets, and ALL mask
> > combines both variants. Although bit 2 can't be controlled individually
> > (since there is no much sense to Request stamping of only packets, other than
> > events, moreover, there is no user-visible filter constant to represent it),
> > and that's why is anonymous, it provides a convenient way to handle stamping
> > logic in ravb_rx(), so I don't see an immediate need to get rid of it.
> 
>     OK, you convinced me. :-)
>     I suggest that you repost the patch since it's now applying with a large offset.

I've resubmitted the patch as v2. It is re-based on top of the latest linux master.
Since you sent your "Reviewed-by:" for this patch and there were no changes other
than file offsets, I took the liberty to add "Reviewed-by:" with your name too.


Thanks!

Best regards,
Andrew

