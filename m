Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C033536FA
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 07:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhDDFfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 01:35:53 -0400
Received: from mout.gmx.net ([212.227.15.18]:45531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhDDFfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 01:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617514530;
        bh=spnXF9bitaRpIdUoYH0Zqs8FB9jy9Hn4K39Rt8w46BY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Bq17cyiE51QPI5XOTEe2o70zo8e8Q32XJItNhcRqbfCfp0p5W+57SXhUppr1HwTX3
         0anlTczL6KDRU9BRpkZe8LOkUVpImFjImQR1pFsyHMH9oe+HgwaNgWATPGRVDceZkN
         ywTtcvB89oWd12LF7krT9igJfIBmoF9jNLFlD55g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.44] ([95.91.192.147]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Md6Mj-1m2XU92nz9-00aEC7; Sun, 04
 Apr 2021 07:35:30 +0200
Subject: Re: [PATCH net-next v1 2/9] net: dsa: tag_ar9331: detect IGMP and MLD
 packets
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-3-o.rempel@pengutronix.de> <YGiAjngOfDVWz/D7@lunn.ch>
 <f4856601-4219-09c7-2933-2161afd03abe@rempel-privat.de>
 <20210404000204.kujappopdi3aqjsn@skbuf>
From:   Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <ab493cae-e8a5-e03a-3929-649e9ff46816@rempel-privat.de>
Date:   Sun, 4 Apr 2021 07:35:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210404000204.kujappopdi3aqjsn@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9p/coZq9wZCmxGXl0mqGGX+ODJYTNv+5wpDnyDKmzh/QY3x7NYq
 Y7zm8poDMRy1j/cGtHaffrWn/f+2uRyfmlIFLrXN6IQ3Hq1nuwNfDcME1+yO3ybxSXx4OSn
 aHK7aQVyn5pfyDWr5Z+YsvjMSqRDJ+LAOqtOaXiPjgjwx9EazjC87/q0Yt7QPEYAqYQRflo
 vD5dLzJi6d8q653VrF7rA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:h0x5UH8Rwxs=:7gDkdZV1X2owpN2qm5xMaT
 5Q/CNaiW5CNCPTcXP/7yltdtUK601fXnXLQPS+XJXQJFhb7tn6zeIw4eEdVomvC3Aq4/9qIC+
 RpbPuD9XfGIJTd1j/GJ8o+8vxOrhMPViJYKfRGSJ7jV0PNZqlsUKlQxX0hYAssJD82i8hYvLD
 7/OJaXmJVUfKxSUUriMuG2gzVVdHSBuel/W1eTzRWmSZeAql8E8vtdN6mo/ZI9mVTYnGGPRDg
 mKzPcHytXTamUOWxbyjncFAMbtoGyByahh9o2Loz7KcuYFGzwCF5s7brmca5GyG2yVWms9CEz
 qofNUUAV4UydgVEGiZI4qiIJrsE5aoY/uJRgVKanvdr14o9SqXYPjoPelZFwDQnCbllogRc0A
 7a4occ333cqv/Irqcyet+KzXi1vJZbSSPHsddUTenY7dVs80TaOeKk4YLKdHIlaUj1Z/jr/gB
 mffXLZQ5vjOVqJN2x2BtuMUnH6Km4O0YundpVXfQi9hdkDd9ku3g+ghZDMGc134jed7JUBNC7
 IupzVJ4ER/IzPIAjteTS8VNTZbfkDYt4W5yqQO4F8KnQAcAP2ETafzYLSetxDwwKrFEaFe2EH
 aYETczAeDq+A8a96FLpVq1FSd1pnCxy+wnhdDgIlr6oCMpCUvuk+VHXuWBDzyHksYaOxdkZav
 Sd70TIfBfYvuifNoBHXJiPF7GLcYHJopyqS0S+z9cERMPjlqf7pflYL2qnNciZTDPqqNThiMN
 EPj1fgPkrm1c3BOYsuC5RJpObFlyVOYepQnXeqYo7UH8Fy7Bd/Tsp8jyvRpjkYEheOUALo2x4
 vV4TjT381aWjkF5/caS2pl/FJuDqhkw3JN8Kbnu5yvPsRCJ29G0Vi15fgR1gwrm3GYAFwcrzQ
 Fm8WetD83xLmSKMc8iqhvkvYpODFsS59yHWOswg5yM4naPlCxWPkFqJoI/gAEqU++xBuXyFvl
 R0Ta5sSQjmNGzCaDriM4+hBHKwA/8qnKKHEnRxZFRSsJqIVNkKYW7JGCkG2dikHtOL6RL1unO
 Fadn06CU57BkqCbyx5yAkIFleZOxezPI7eMzV/VH+dChN4ezbj7Shc7Ie2aPOS02yVyHEy7JB
 076zIPDOzHHny7RbDo54D8V6azKh67tgvmi7RCPI3jXnA/g4+ZwVOj/M7mRnTmdvArKcwcdn6
 NyEwbfKNQTOSx2c0RmmT4RUDpw9v+7c14DbPquLZGXBpJzOG0upQlPElaIVXdCDk6sjEs6bOA
 C2CsfZ3T1gATQypsM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 04.04.21 um 02:02 schrieb Vladimir Oltean:
> On Sat, Apr 03, 2021 at 07:14:56PM +0200, Oleksij Rempel wrote:
>> Am 03.04.21 um 16:49 schrieb Andrew Lunn:
>>>> @@ -31,6 +96,13 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_b=
uff *skb,
>>>>  	__le16 *phdr;
>>>>  	u16 hdr;
>>>>
>>>> +	if (dp->stp_state =3D=3D BR_STATE_BLOCKING) {
>>>> +		/* TODO: should we reflect it in the stats? */
>>>> +		netdev_warn_once(dev, "%s:%i dropping blocking packet\n",
>>>> +				 __func__, __LINE__);
>>>> +		return NULL;
>>>> +	}
>>>> +
>>>>  	phdr =3D skb_push(skb, AR9331_HDR_LEN);
>>>>
>>>>  	hdr =3D FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
>>>
>>> Hi Oleksij
>>>
>>> This change does not seem to fit with what this patch is doing.
>>
>> done
>>
>>> I also think it is wrong. You still need BPDU to pass through a
>>> blocked port, otherwise spanning tree protocol will be unstable.
>>
>> We need a better filter, otherwise, in case of software based STP, we a=
re leaking packages on
>> blocked port. For example DHCP do trigger lots of spam in the kernel lo=
g.
>
> I have no idea whatsoever what 'software based STP' is, if you have
> hardware-accelerated forwarding.

I do not mean hardware-accelerated forwarding, i mean
hardware-accelerated STP port state helpers.

>> I'll drop STP patch for now, it will be better to make a generic soft S=
TP for all switches without
>> HW offloading. For example ksz9477 is doing SW based STP in similar way=
.
>
> How about we discuss first about what your switch is not doing properly?
> Have you debugged more than just watching the bridge change port states?
> As Andrew said, a port needs to accept and send link-local frames
> regardless of the STP state. In the BLOCKING state it must send no other
> frames and have address learning disabled. Is this what's happening, is
> the switch forwarding frames towards a BLOCKING port?

The switch is not forwarding BPDU frame to the CPU port. So, the linux
bridge will stack by cycling different state of the port where loop was
detected.

=2D-
Regards,
Oleksij
