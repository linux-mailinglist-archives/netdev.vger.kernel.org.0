Return-Path: <netdev+bounces-1735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641926FF05A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:03:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DC201C20F32
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1BE182C5;
	Thu, 11 May 2023 11:03:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A1018013
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:03:15 +0000 (UTC)
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBD75FD9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:03:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-51f64817809so1184788a12.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683802993; x=1686394993;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XkCvIeyUwHV8WBXqbrK+arj51Lj8HCCDXYTWJYvOzH4=;
        b=QG9fqSNnzHTBG5rVgcW/W5d5ri9vPpbrlRLWbLHaXqJRx0dNWopAOyN67kc8n/zByF
         H8lUYj75Brzi/+grNt4mWNqiOpvu+3xo9uN3eP1ABNpiZwxjyJ4LKKhYZCFmQe1TPziB
         zZ1OdhIrGPPTKMZtZbJO97khMR9KDM/pJfQnNcVw8cRMY0/bY1hMHvytAYgxmceBYUuT
         W0OHrk0zwiN9xSL6JQoOHlolmL+8hDAFyqV3jAwejPMdu7ssePPw07eVCVuwKmkmpRXA
         cVlH5wsqZVZAb/LcGPKzsAQ0ZwSXX1aBPdgmY3dl6vWyeoJrYKlnlmCNPgEt8O9CnJQ/
         /Mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683802993; x=1686394993;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XkCvIeyUwHV8WBXqbrK+arj51Lj8HCCDXYTWJYvOzH4=;
        b=IhtXnF+VopZsDSN/+amEeRCs0S/b3+vDnE6nxAKmadbi2BIfXgtgWaSFihp7uGWZtm
         z4x3oiz68TX1FsS8/5ktiTUWoqA0Uu7tOZ7QIFRvLtqeaAOSbev0sfoc1CpswzmAcYv2
         9Ifx7FGwYR20QL2bJkn5NSP6G6ddKcPYucippgTC5ZvONoRZWC0IpCZz17Vpl9hDyqis
         /NWy6TjqBGIDPSfdcQFEfFjejQJFEly5cePsXBXZBUn6xsAFsnb3S/qf78DJxC3Gelmi
         xGWSJVnIkwaNKvngRQzmTnyK+bpg4054pK43nvQjirjDcz4S2o3c0RWJGysIeSrZTsM3
         gyNA==
X-Gm-Message-State: AC+VfDyJ5BsRzBjHyXt2wcv7FRvV0+EzBz+tbO5L5fckZQyrPI8Yon/i
	lFZo+DSSoxjEVDZOBdbnUqWStPGWG8QlG4FNI4k=
X-Google-Smtp-Source: ACHHUZ7SfAMFBHJ5OVwjyBp8Vzn4f8s4vD7+Jqbon0ecKp1khYlqrsS9WYACPZSfQJHH0bZplB1g20SS7jwVe+epLgs=
X-Received: by 2002:a17:90b:17c9:b0:250:d8e2:3627 with SMTP id
 me9-20020a17090b17c900b00250d8e23627mr5703786pjb.0.1683802993123; Thu, 11 May
 2023 04:03:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch> <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
 <CAOMZO5Dk44QSTg2rh_HPHXg=H7BJ+x1h95M+t8nr2CLW+8pABw@mail.gmail.com>
 <5e21a8da-b31f-4ec8-8b46-099af5a8b8af@lunn.ch> <CAOMZO5DSSQY5fa5vTmDbCxu1x2ZRdyB2kTqrkw5bRg94_-34zg@mail.gmail.com>
 <20230510182826.pxwiauia334vwvlh@skbuf>
In-Reply-To: <20230510182826.pxwiauia334vwvlh@skbuf>
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 11 May 2023 08:03:01 -0300
Message-ID: <CAOMZO5Ad4_J4Jfyk8jaht07HMs7XU6puXtAw+wuQ70Szy3qa2A@mail.gmail.com>
Subject: Re: mv88e6320: Failed to forward PTP multicast
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, tobias@waldekranz.com, 
	Florian Fainelli <f.fainelli@gmail.com>, =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>, 
	netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000046fce905fb68efe4"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--00000000000046fce905fb68efe4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

On Wed, May 10, 2023 at 3:28=E2=80=AFPM Vladimir Oltean <olteanv@gmail.com>=
 wrote:

> I checked out the v6.1.26 tag from linux-stable and I was able to
> synchronize 2 stations attached to my Turris MOX (Marvell 6190) with
> this commands: sudo ptp4l -i eth0 -4 -m
> (also I was able to synchronize a third station behind a mvneta bridge
> port foreign to the MV88E6190, using software forwarding)

Thanks for testing it, appreciate it.

> My bridge configuration is VLAN-aware. FWIW, I'm using vlan_default_pvid
> 1000, but it should not make a difference.
>
> In a bridging configuration where there are only 2 ports in the bridge
> PVID (1 source and 1 destination), could you please run the following
> command from a station attached to one of the Marvell switch ports:
>
> board # ethtool -S lanX | grep -v ': 0'
> station # mausezahn eth0 -B 224.0.1.129 -c 1000 -t udp "dp=3D319"
> board # ethtool -S lanX | grep -v ': 0'
>
> and tell me which counters increment?

In our tests:
eth0 is the port connected to the i.MX8MN.
eth1 and eth2 are the Marvell switch ports

Please find attached two configurations and the results.

Some notes:

- We have bridged (eth1+eth2) =3D br0, no matter if it is VLAN aware or not=
.
- PTP traffic flows correctly over eth1+eth2 (the 2 hardware switch interfa=
ces)
- PTP traffic appears shortly, (like during 30 seconds) on the
non-VLAN-aware case
br0 interface.
- PTP traffic does not appear on the VLAN-aware br0 interface

> I am also curious whether there is any difference to your setup between:
> ip link add br0 type bridge
> ip link set br0 type bridge vlan_filtering 1 # dynamic toggling of VLAN a=
wareness
> and:
> ip link add br0 type bridge vlan_filtering 1 # static creation of VLAN-aw=
are bridge

It does not show any difference here.

> I've tested both forms on my setup, and both work. Who knows, maybe
> something happens differently on your particular kernel, or with your
> particular switch model.
>
> Is it vanilla v6.1.26 or something else?

It is vanilla v6.1.26 plus the devicetree for this board, plus an
audio codec patch.

Thanks,

Fabio Estevam

--00000000000046fce905fb68efe4
Content-Type: application/x-xz; name="mausezahn.tar.xz"
Content-Disposition: attachment; filename="mausezahn.tar.xz"
Content-Transfer-Encoding: base64
Content-ID: <f_lhj0l3v20>
X-Attachment-Id: f_lhj0l3v20

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj4CH/BJ9dADcZSu7Azc3Fg2yYyERSoJ6Lyx4UOYGP4p75
IJ4KK3Chh5+W0+++Kcl/hjqjS5vQWx9Hp/YGkYNyyw7ukslWY9nFDHIQ4cUzB83qZXviFfTbBZ1R
mDNcQXgymtFRPpzcvmXEeGdZMZ4g+lV9A/hMJUHnwsUK/bPvNVh9PXybfLfWa0P9p33gL4C+unBe
iGm9jnTC7kin09eWwEyT1sUnKohoOM3deHIC2+AgQ6X7kWp3sK6oWOwJ7BnQLQRjc1qlxtPTU6th
hDkGmfD9KL48PhjdKUd+0kel/NvgcoU7ARbDuWkEYvR2txpewyJL3+ubBPWcfxOYotyci7TpqN3a
lURa5WBLnaiYo1lkLJimroHFhvactlTfUq8WJmuYerChh6YTZZo6Jzti935ApTOIuCTAJ43SV94O
xm77DdbmbOLPNfcS9y/scoho5RwVLtFAe4gBrjcRsyJcuaNeTHZy7Imx/saKJ43gXzUQyzz86hQw
PTFp2lkozCql86n8/XE7cQIrl3AwHMS/j+aYTOkUewDgchwWpEG+YB7gXnMAbcJ/EW/t88u3A8bX
UzC9Dtb9SOvm7k1no0vDRa8XsD6n6zct7SY5C+dXOfHsF/N9VERm3tpDplAfm3O3Qp//2aCIrYbV
FmxDUlnyLnXSxVPBqFlRYCv028HLSCBmNeygSmh/ykQkyxZLKzWqWz9zgshpaQ71U9zbNNV84NEe
I/xokJtcCT8CvCA95Ollz7voQZMHSg7rKoYAON1V6rnYDpncrEQ3azXWcIO1BrRuHk8n1zjoOEuK
tlOWPFnIa9SOOdTXuhxTJzSCB9NumbGKTJSBDQmwDe2d+mBh7K8R2/QNI9D+Hzvs3lY7fngvfI5+
H4p2KRpiNhGta1pnS0nu8elsFZq4Y/B2x1af7Q5dPUuNAhhKZzPk+JwqUPuA+QOZOffSK3Rrx4f9
O7UX6LDeOGKK/Bc1sqLenK3zA3a5IH71xna7X3cosfGKdkfWHdoadjLstj8C/MnYNG/OpbkWGiXL
D5JIBdMx5uFYyFUw1AKsVFaa9lq8Z2Ly5iQ+7e47sMM7W6iIlQ4WDMMleK+NzkiqG/uETELzhFbL
BIFO65eLh8guGXbSwAUmhSeSZa7gGA3GORBboo4HifBEFZJV02Ct9ipzPFX3y9fTz0YYnRSRVolW
prMAYn8ivFeanN0hOy32zFvPUZSxweMd+8qE2wXOy+wRQyeoNTqRTRGcbWgKyomaoPwuMrJaO5uX
0Yv6IQ0w+esWuZzouSoBOIzBMBUylwjDTxv1N7a8s6HjXVnu3npm6GqhONiAeaAmGvOH2d33wszv
A70uYEX8KIZefuHPYYN89kiCWxXbZ0HYIm2AHLDH9yZ87gB/Zi+BtzsXW3kZ1i72J628iwePjTuT
MRuXIu6Q0WQgqZX+a/nWk1ZanWM+sFNfHHTA2PDqCFImTpiJnc+CdBSe3YxhiXz/X7+BDEwjwWGC
2QsAgzy7U827sMXf5FhtlbTg9RMOgkdxY3nFdAP4C1BulMhWdNC/PwWgJyOkA3fSc1oZJTCv7nBk
pi8zVvPJyp4BfIDcop5gvAAAAPW+YnSjmfcNAAG7CYBEAAA9xoIkscRn+wIAAAAABFla
--00000000000046fce905fb68efe4--

