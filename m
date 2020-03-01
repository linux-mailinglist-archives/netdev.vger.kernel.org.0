Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E03174D81
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 14:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCANYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 08:24:30 -0500
Received: from mout.gmx.net ([212.227.15.15]:53027 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCANYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583069060;
        bh=RV3ocdyvPvYSdKxfqNbOkM3ZQiV1J+VbRSniuNsrFYI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=NZiSJv1at/jFgsQ0emBmmTl+ofDZmREwOZjl9aR6scplivbARj8btoax0Dw5xTTmJ
         WqR9p2iEP4SQt9DC6oyLkYZ/kanMtgSz6FfRuTx/V+hSrJTcf8tGlj2AKu4okTHafJ
         3QC/qJXfUsRRELBHNt7OiAEIMiXM2l883lXsO3do=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.44] ([95.90.191.58]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MEV3I-1jA05e2WWA-00G5Gl; Sun, 01
 Mar 2020 14:24:20 +0100
Subject: Re: [PATCH 3/3] ag71xx: Run ag71xx_link_adjust() only when needed
To:     Hauke Mehrtens <hauke@hauke-m.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com
References: <20200217233518.3159-1-hauke@hauke-m.de>
 <20200217233518.3159-3-hauke@hauke-m.de>
 <b980f225-66ca-1ae1-23cf-eff06810b050@gmail.com>
 <9c509cec-a1cd-c012-b2ab-4f1334b47a8e@rempel-privat.de>
 <b120575e-b129-63c5-962e-cb3a90d4c62b@hauke-m.de>
From:   Oleksij Rempel <linux@rempel-privat.de>
Autocrypt: addr=linux@rempel-privat.de; prefer-encrypt=mutual; keydata=
 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
 Rmpernzn0GXR0xYSTiUvuvpLsoo=
Message-ID: <c05002cf-3aeb-96b1-7da0-bf2c35b9c6c8@rempel-privat.de>
Date:   Sun, 1 Mar 2020 14:24:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b120575e-b129-63c5-962e-cb3a90d4c62b@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:R7Jtac4ha+obtax4JJfsw6EfFL1d9wC+k7smOJ6YWSl5O/noZ9c
 xVgC+ZTamAhnw/MNgRjjLBq9O060DZP5cXZYYT0ucNIudybdbPh4uZaIwp9o4I2ldQTANSc
 d+KNudoCYBPIqIFhMaHR0K7wc+huBSujR2/bAgx8d7gm3Eu2zc9lvqlsq+ZFsQL0gAvfvhz
 YrWpnJYyrqoV1kk2p7YIA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MLD8bCwwngU=:/vgwnsIFdyuhB1OJbQ4PDY
 emyA1f5jVEhB8rFsVchMK+F/fjGRaDA03cc2pth5qGzOD/kRp6K0yFhu9yjd7/Eb3toDs3qFK
 RcYnmP9ZE0LcwtxD+Z5CnIf4lM2x9ZHV+wIR3/VbhHqIaWlf48qg7N/ASwwxy5dlPgNty/Twn
 HNAT1RHUt0OpN+z83oqkZU9EfHeyawaiYCRLl+zfz3Y+6K8JIz+meTxXyI8fLGHQ1TnWzW5k+
 VIzD8gsdiSGbkDBeWRdU6yQnlW/noB78ITJwvrk/P1woZu+Ix9nk74LSQdwSj9I0nMnMvxdap
 n5fmg/dT1bVVoLmTDucBewL+3RQVkiAAZs3oQmgbW5ZqtZXERlJjDFK514EMLixHYTzwRssyq
 eG6pcnB5AnlSgqzxpVWpIE8Jg7rDC7vnWXKvY2lrGnRYSiI3vy5bm1bVQ6JiwRwuTebVTlph1
 7ld5aN0LP5TfAoJ0HtvSPQpzkkflVeQPYwcUUe4Qky/HH+Vu881l0JVRdiBxMHDerwNk8Rbcs
 XWdu/vlF6bs/LGUj0b5vHba0VUEyZDV2xFGZo0AGCGA3iuU/j8pPpw+xy5PoSRVIpw3mvWxBi
 +T16DRvF7gcLa+BBBSeTfW5u6xI3krjqCTH19ohmMvhZ34lLap8Q34S45flem/6t1/VT8z6Ku
 ufgXSvfpapu2JQuZ7P+IY3NrRdsDhlMVKmb4MRQuGqv5LDOX/9DX084xj1KnLCCltRdFoLmKZ
 6tYaKzQonZrmAL5XyLoGvaj4IW85LPSCE6AOV0MNY7Ja3zuSt8kBH0XNem0GPDgndXXw3O1ii
 GH71rio+6zlpLuUh3DY7m09aQXlYH5RCGT4uTM5ObkqGjByeG1yGCXxeXpU/vzby3EddG3QB+
 zRynWqAfNFh8xTDHVdBxQ28G7yZFEAzYiyXnY9hqnzMfjqtF8S/PFHUzClooOLhAaEU9ow2s7
 KvA2wAMwC/cREpeDfhSI0JYr8zS396b4guf1Tv1N5PXiWcbnOjMNiJJ1F5QmqTfRNk7bBo/b/
 HVtwoAl67dLZ+aXt5tb7SKNICsAF3AyWedMl/MgIkiqP03eW1VYjuXkKhNPLQS608Lf+dJpoo
 HTCND+qpNJ5j6SRXWMThuB50X8TSJuU0Z9+USI2szvu1iT8dg4dMg+MauyPzmZDX5dUZiXDqF
 ehLhP7ACKFGnE0xZq+hSsDRiVTdGTXyt5j8O3FG1dCmvyCzgD+c6uHzdQCuQKogIebO34pr71
 4tLTRjy8LgKhvOFaj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 01.03.20 um 13:19 schrieb Hauke Mehrtens:
> On 2/18/20 11:30 AM, Oleksij Rempel wrote:
>> Hi,
>>
>> current kernel still missing following patch:
>> https://github.com/olerem/linux-2.6/commit/9a9a531bbad6d00c6221f393fd85=
628475e1f121
>>
>> @Hauke, can you please test, rebase your changes (if needed) on top of =
this patch?
>
> I rebased my changes on top of this:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/comm=
it/?id=3D892e09153fa3564fcbf9f422760b61eba48c123e
> and my patch is not needed any more, I will send a V2 only containing
> the first patch of this series, which should fix a potential bug.

Thank you!

> You missed adding RGMII support in your patch, but the MAC supports
> RGMII, I will also send a patch for that.
>
> @Oleksij: Are you planning to add support for the GMAC configuration
> like RGMII delays and so on?

Not now. Currently I work on AR9331 which has no external RGMII
interface. If you have HW capable to do RGMII, patches are welcome :)

> Hauke
>
>
>>
>> Am 18.02.20 um 08:02 schrieb Heiner Kallweit:
>>> On 18.02.2020 00:35, Hauke Mehrtens wrote:
>>>> My system printed this line every second:
>>>>   ag71xx 19000000.eth eth0: Link is Up - 1Gbps/Full - flow control of=
f
>>>> The function ag71xx_phy_link_adjust() was called by the PHY layer eve=
ry
>>>> second even when nothing changed.
>>>>
>>> With current phylib code this shouldn't happen, see phy_check_link_sta=
tus().
>>> On which kernel version do you observe this behavior?
>>>
>>>> With this patch the old status is stored and the real the
>>>> ag71xx_link_adjust() function is only called when something really
>>>> changed. This way the update and also this print is only done once an=
y
>>>> more.
>>>>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
>>>> ---
>>>>  drivers/net/ethernet/atheros/ag71xx.c | 24 +++++++++++++++++++++++-
>>>>  1 file changed, 23 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethe=
rnet/atheros/ag71xx.c
>>>> index 7d3fec009030..12eaf6d2518d 100644
>>>> --- a/drivers/net/ethernet/atheros/ag71xx.c
>>>> +++ b/drivers/net/ethernet/atheros/ag71xx.c
>>>> @@ -307,6 +307,10 @@ struct ag71xx {
>>>>  	u32 msg_enable;
>>>>  	const struct ag71xx_dcfg *dcfg;
>>>>
>>>> +	unsigned int		link;
>>>> +	unsigned int		speed;
>>>> +	int			duplex;
>>>> +
>>>>  	/* From this point onwards we're not looking at per-packet fields. =
*/
>>>>  	void __iomem *mac_base;
>>>>
>>>> @@ -854,6 +858,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag,=
 bool update)
>>>>
>>>>  	if (!phydev->link && update) {
>>>>  		ag71xx_hw_stop(ag);
>>>> +		phy_print_status(phydev);
>>>>  		return;
>>>>  	}
>>>>
>>>> @@ -907,8 +912,25 @@ static void ag71xx_link_adjust(struct ag71xx *ag=
, bool update)
>>>>  static void ag71xx_phy_link_adjust(struct net_device *ndev)
>>>>  {
>>>>  	struct ag71xx *ag =3D netdev_priv(ndev);
>>>> +	struct phy_device *phydev =3D ndev->phydev;
>>>> +	int status_change =3D 0;
>>>> +
>>>> +	if (phydev->link) {
>>>> +		if (ag->duplex !=3D phydev->duplex ||
>>>> +		    ag->speed !=3D phydev->speed) {
>>>> +			status_change =3D 1;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	if (phydev->link !=3D ag->link)
>>>> +		status_change =3D 1;
>>>> +
>>>> +	ag->link =3D phydev->link;
>>>> +	ag->duplex =3D phydev->duplex;
>>>> +	ag->speed =3D phydev->speed;
>>>>
>>>> -	ag71xx_link_adjust(ag, true);
>>>> +	if (status_change)
>>>> +		ag71xx_link_adjust(ag, true);
>>>>  }
>>>>
>>>>  static int ag71xx_phy_connect(struct ag71xx *ag)
>>>>
>>>
>>
>>
>> --
>> Regards,
>> Oleksij
>>
>
>


=2D-
Regards,
Oleksij
