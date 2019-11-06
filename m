Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5451AF0E92
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbfKFF7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:59:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43750 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfKFF7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:59:33 -0500
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20191106055930epoutp03773807214e9e273ff65395dfce982ae3~UfVQrVW-E1615616156epoutp03w
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 05:59:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20191106055930epoutp03773807214e9e273ff65395dfce982ae3~UfVQrVW-E1615616156epoutp03w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1573019970;
        bh=5jqZLeB/t+bgdVHOVulyXWfe9MwnZ+LVz1WIl+VATmQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=doQP7LMQXxS6K6rD29/rhya+CzbayUU5dKWvbXBk057ShI/oIM7+WCyLyu76zYtB0
         4ZAjz9Cx0JlkNp7mR7QAV5z9j+RqL/sh7DhoXQ9fgm35LQoTCNYsqnX8y91fY5ADto
         +PNHj4mSpyBclZ1A2ByCRPD6VDIHp7hbVXcx5Jhc=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191106055928epcas5p194c6211b75e7a4c84e2dbd1b592b8a0b~UfVPML0tv1971919719epcas5p1h;
        Wed,  6 Nov 2019 05:59:28 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.2A.20293.04162CD5; Wed,  6 Nov 2019 14:59:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20191106055928epcas5p3371c1e4a063e5bb4012abc4d37335276~UfVOzVVCF1088910889epcas5p3t;
        Wed,  6 Nov 2019 05:59:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191106055928epsmtrp2bab2a75d17ca7709ad8260f48b6c9615~UfVOyV3My2121521215epsmtrp2Z;
        Wed,  6 Nov 2019 05:59:28 +0000 (GMT)
X-AuditID: b6c32a49-fe3ff70000014f45-9e-5dc2614015ab
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.CE.24756.04162CD5; Wed,  6 Nov 2019 14:59:28 +0900 (KST)
Received: from pankjsharma02 (unknown [107.111.84.17]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191106055926epsmtip28d612b8d8e1b46086452996ec625632d~UfVM8VnYB1946719467epsmtip26;
        Wed,  6 Nov 2019 05:59:26 +0000 (GMT)
From:   "pankj.sharma" <pankj.sharma@samsung.com>
To:     <mkl@pengutronix.de>, <wg@grandegger.com>
Cc:     <davem@davemloft.net>, <pankaj.dubey@samsung.com>,
        <rcsekar@samsung.com>, <jhofstee@victronenergy.com>,
        <simon.horman@netronome.com>,
        "'Sriram Dash'" <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1572435539-3315-1-git-send-email-pankj.sharma@samsung.com>
Subject: RE: [PATCH v3] can: m_can: add support for handling arbitration
 error
Date:   Wed, 6 Nov 2019 11:29:24 +0530
Message-ID: <01db01d59467$597156c0$0c540440$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGK3XpoOA41uKowC2FhnQpbH/1i7AGj5xUMqAXz66A=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7bCmpq5D4qFYg6/HtCzmnG9hsVjxfh+r
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm4x68IOVosbOzktbqxnt1h6byerA7fHlpU3mTw+
        XrrN6DG9+yGzR/9fA4++LasYPT5vkvOYdPADewB7FJdNSmpOZllqkb5dAlfGg5UbWAr2SVVc
        n3mUsYHxhGgXIyeHhICJxIK12xi7GLk4hAR2M0pMubmIGcL5xCix+NwpdgjnG6PEk/2NQGUc
        YC3frtpBxPcySsx/1grV8ZpRYv3Ll0wgc9kE9CWmNP1lAbFFBHQl3qx9ADaJWWASk0T3rWvM
        IAlOAQ+JX68egTUICwRIrJp8kA3EZhFQkVg+eQqYzStgKdG0bw47hC0ocXLmE7ChzALaEssW
        vmaGeEJB4ufTZawQy6wk5q+5zAxRIy7x8ugRsMUSAv3sEgv3b4BqcJG48P4kO4QtLPHq+BYo
        W0ri87u9bBB2tsTC3f0sEC9XSLTNEIYI20scuDIHLMwsoCmxfpc+xCo+id7fT5ggqnklOtqE
        IKrVJKY+fccIYctI3Hm0mQ2ixAPoANkJjIqzkPw1C8lfs5DcPwth1wJGllWMkqkFxbnpqcWm
        BYZ5qeV6xYm5xaV56XrJ+bmbGMGJS8tzB+Oscz6HGAU4GJV4eFeUHIwVYk0sK67MPcQowcGs
        JMIb0wcU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzjuJ9WqMkEB6YklqdmpqQWoRTJaJg1OqgdHS
        5qsk66zmcOOG3rn1HLM5hI8dtlO22ngwOIyNXev9V7b9a48vZrC+JNBRFpijESmWcKY/RK3q
        tszaw+F5hxKeW0w7YbOrepISQ1PZXSbbtzyn+3Z5G+Td0fy1u7eH1+D4L21G87J5dleWaKuy
        R/++VhJvb3nnyker56qLGWIifV02RCyeqMRSnJFoqMVcVJwIAMO7FNlYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCSvK5D4qFYg7v7uCzmnG9hsVjxfh+r
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm4x68IOVosbOzktbqxnt1h6byerA7fHlpU3mTw+
        XrrN6DG9+yGzR/9fA4++LasYPT5vkvOYdPADewB7FJdNSmpOZllqkb5dAlfGuRe7GQueSVZs
        ezubsYHxjUgXIweHhICJxLerdl2MnBxCArsZJZ7OYYYIy0gs/lwNEpYQEJZY+e85excjF1DJ
        S0aJ1snv2EASbAL6ElOa/rKA2CJA9qJL/8GKmAVmMUl0POtlgxg6k1Hi1xsdEJtTwEPi16tH
        TCC2sICfxIHJ68FqWARUJJZPngJm8wpYSjTtm8MOYQtKnJz5BGwBs4C2RO/DVkYYe9nC18wQ
        1ylI/Hy6jBXiCCuJ+WsuM0PUiEu8PHqEfQKj8Cwko2YhGTULyahZSFoWMLKsYpRMLSjOTc8t
        NiwwzEst1ytOzC0uzUvXS87P3cQIjj8tzR2Ml5fEH2IU4GBU4uFdUXIwVog1say4MvcQowQH
        s5IIb0wfUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv07xjkUIC6YklqdmpqQWpRTBZJg5OqQbG
        ucekzL+GvP9+a/9f/x0yE2eXZj4S3fFN+/U0mWy7+cVFy/4FJH3cyqxokyqygVt0SSXD3z/v
        73i8y1VfJxxVXDu93UoryTvje+Ry80W+ugf5zbtfB3UKR4s25siuTuh5mR59q1zQQM9ddOOi
        v/0ff/p1r5RbrH9l//049crzDesXP1+bxzpfiaU4I9FQi7moOBEAj31dUrsCAAA=
X-CMS-MailID: 20191106055928epcas5p3371c1e4a063e5bb4012abc4d37335276
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191030114039epcas5p434c9a7ffb715f2af2f4d3745239b5bbd
References: <CGME20191030114039epcas5p434c9a7ffb715f2af2f4d3745239b5bbd@epcas5p4.samsung.com>
        <1572435539-3315-1-git-send-email-pankj.sharma@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle Ping=21

> From: Pankaj Sharma <pankj.sharma=40samsung.com>
> Subject: =5BPATCH v3=5D can: m_can: add support for handling arbitration =
error
>=20
> The Bosch MCAN hardware (3.1.0 and above) supports interrupt flag to dete=
ct
> Protocol error in arbitration phase.
>=20
> Transmit error statistics is currently not updated from the MCAN driver.
> Protocol error in arbitration phase is a TX error and the network statist=
ics should
> be updated accordingly.
>=20
> The member =22tx_error=22 of =22struct net_device_stats=22 should be incr=
emented as
> arbitration is a transmit protocol error. Also =22arbitration_lost=22 of =
=22struct
> can_device_stats=22 should be incremented to report arbitration lost.
>=20
> Signed-off-by: Pankaj Sharma <pankj.sharma=40samsung.com>
> Signed-off-by: Sriram Dash <sriram.dash=40samsung.com>
> ---
>=20
> changes in v3:
> - handle arbitration lost stats even if the allocation of the skb fails
>=20
> changes in v2:
> - common m_can_ prefix for is_protocol_err function
> - handling stats even if the allocation of the skb fails
> - resolving build errors on net-next branch
>=20
>  drivers/net/can/m_can/m_can.c =7C 42
> +++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.=
c
> index 75e7490c4299..02c5795b7393 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> =40=40 -778,6 +778,43 =40=40 static inline bool is_lec_err(u32 psr)
>  	return psr && (psr =21=3D LEC_UNUSED);
>  =7D
>=20
> +static inline bool m_can_is_protocol_err(u32 irqstatus) =7B
> +	return irqstatus & IR_ERR_LEC_31X;
> +=7D
> +
> +static int m_can_handle_protocol_error(struct net_device *dev, u32
> +irqstatus) =7B
> +	struct net_device_stats *stats =3D &dev->stats;
> +	struct m_can_classdev *cdev =3D netdev_priv(dev);
> +	struct can_frame *cf;
> +	struct sk_buff *skb;
> +
> +	/* propagate the error condition to the CAN stack */
> +	skb =3D alloc_can_err_skb(dev, &cf);
> +
> +	/* update tx error stats since there is protocol error */
> +	stats->tx_errors++;
> +
> +	/* update arbitration lost status */
> +	if (cdev->version >=3D 31 && (irqstatus & IR_PEA)) =7B
> +		netdev_dbg(dev, =22Protocol error in Arbitration fail=5Cn=22);
> +		cdev->can.can_stats.arbitration_lost++;
> +		if (skb) =7B
> +			cf->can_id =7C=3D CAN_ERR_LOSTARB;
> +			cf->data=5B0=5D =7C=3D CAN_ERR_LOSTARB_UNSPEC;
> +		=7D
> +	=7D
> +
> +	if (unlikely(=21skb)) =7B
> +		netdev_dbg(dev, =22allocation of skb failed=5Cn=22);
> +		return 0;
> +	=7D
> +	netif_receive_skb(skb);
> +
> +	return 1;
> +=7D
> +
>  static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus=
,
>  				   u32 psr)
>  =7B
> =40=40 -792,6 +829,11 =40=40 static int m_can_handle_bus_errors(struct ne=
t_device
> *dev, u32 irqstatus,
>  	    is_lec_err(psr))
>  		work_done +=3D m_can_handle_lec_err(dev, psr & LEC_UNUSED);
>=20
> +	/* handle protocol errors in arbitration phase */
> +	if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
> +	    m_can_is_protocol_err(irqstatus))
> +		work_done +=3D m_can_handle_protocol_error(dev, irqstatus);
> +
>  	/* other unproccessed error interrupts */
>  	m_can_handle_other_err(dev, irqstatus);
>=20
> --
> 2.17.1


