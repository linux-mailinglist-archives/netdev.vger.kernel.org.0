Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B617815B8D6
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 06:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgBMFYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 00:24:01 -0500
Received: from smtp2.axis.com ([195.60.68.18]:14196 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgBMFYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 00:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=674; q=dns/txt; s=axis-central1;
  t=1581571440; x=1613107440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TcWjre/1zVoZ2wmoyqKy6F6xXdyU6QkXdoUrZMDgqps=;
  b=LagSzgausNxsC0NY4DTa/mv22eOpcEUjBznzt/ZMgQcbpAiy9hYUkUo4
   OXEAkUKJ6C6wjYw/a8F3ve3ketQtW34PgeqxHX8/LHrehv9Tpvc1FxXG6
   3FW3Bcq8le4Hk/mboP/PoyA8FKeVgNYY+/OWOzsHkdPSvtLtVsQ53oYCZ
   W9kMhRYnWhzfuRjaJBp5vKTahHbBuoTSCG8WUkhfaZlxQtbHONiM0psDv
   Idmu1hWuw9tCBgsQSzCibOI6M1jrMHUAH88FxG26HuhtU19og+9ObY6xT
   HvxXBXauHpjyJoT9jVgxbXsTMue9EVzocy/5KWdld+1+qg+8iBRZg/LXx
   w==;
IronPort-SDR: wgsCrMccOfmIqBtJdvv7gRrU6Wptum+PCYGF79/KzS5xDSxR/BktE5PKf1uIpVHcFTmLT5VIQL
 szkq0EQm9YRk/4+dxmZQMDbWPjxVdCHYKAGmspxei6W/Z+VWJ6G0ZEu9lMKs/BHB63pZREAM/8
 Ob0GOenvyc5hvZcTb9cl0jTHyF/8VXlx5W/sD+fAojFiBVtkmt8WADGkHtteYSiza2ohdwRFCN
 XZIzs/wtGgdln1t61gslcn8G3/VMlgXhctLL1E2Cw4aJ8yaiI3hKeNAqY9K9gpDrXVbZGJwWl8
 7CE=
X-IronPort-AV: E=Sophos;i="5.70,435,1574118000"; 
   d="scan'208";a="5224653"
From:   =?iso-8859-1?Q?Per_F=F6rlin?= <Per.Forlin@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [Question] net: dsa: tag_qca: QCA tag and headroom size?
Thread-Topic: [Question] net: dsa: tag_qca: QCA tag and headroom size?
Thread-Index: AQHV4YqjsBkgaUILIE2xIc9Wj2Kh/agX8L0AgACnUGM=
Date:   Thu, 13 Feb 2020 05:23:59 +0000
Message-ID: <1581571438638.7622@axis.com>
References: <1581501418212.84729@axis.com>,<20200212202332.GV19213@lunn.ch>
In-Reply-To: <20200212202332.GV19213@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.0.5.60]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> > -     if (skb_cow_head(skb, 0) < 0)=0A=
> > >  Is it really safe to assume there is enough headroom for the QCA tag=
?=0A=
> >=0A=
> > +     if (skb_cow_head(skb, QCA_HDR_LEN) < 0)=0A=
> > > My proposal. Specify QCA tag size to make sure there is headroom.=0A=
> >=0A=
> >               return NULL;=0A=
> >=0A=
> >       skb_push(skb, QCA_HDR_LEN);=0A=
=0A=
> > Hi Per=0A=
=0A=
> > Yes, your change looks correct. ar9331_tag_xmit() also seems to have=0A=
> > the same problem.=0A=
=0A=
>> Do you want to submit a patch?=0A=
Thanks for your response,=0A=
I can submit a patch on both drivers, however I only have hardware to perfo=
rm an actual test on the QCA switch.=0A=
