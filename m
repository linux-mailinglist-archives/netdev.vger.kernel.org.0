Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3C1C2B0D
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgECJyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:54:52 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:48481 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgECJyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499692; x=1620035692;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=UzFVXUk7rGwLcvRbopmsQsMgpI4WSn2QXcw5+PKa9Ao=;
  b=pgUL6BR4RzV9bUEO0EbJ3YrPi16iJRs0JPQUwjTXsoiiPneNXbOSIKcu
   x42f0EsNMUEy3xBybLlHXLti9Twc8B6cYidhXsnwkPdyn2wnrq39AdpT7
   ygf+j3G2JRJ0oVgN9WIw+2cPMspDSPIASTHNmS8242r2us5W9md9AWAf/
   M=;
IronPort-SDR: caTl6x8I/DdwEn8GdjXElwcpQAkiphQ+79n/Y+eBtpQwFLOIg37f4bjkNmT8t3ZpjTdMR1FIO9
 kjEuOvg0O3mQ==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="40862815"
Subject: RE: [PATCH V2 net-next 09/13] net: ena: implement
 ena_com_get_admin_polling_mode()
Thread-Topic: [PATCH V2 net-next 09/13] net: ena: implement
 ena_com_get_admin_polling_mode()
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 03 May 2020 09:54:52 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id E2D4FA245E;
        Sun,  3 May 2020 09:54:49 +0000 (UTC)
Received: from EX13D06EUC003.ant.amazon.com (10.43.164.140) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:54:49 +0000
Received: from EX13D11EUC003.ant.amazon.com (10.43.164.153) by
 EX13D06EUC003.ant.amazon.com (10.43.164.140) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:54:48 +0000
Received: from EX13D11EUC003.ant.amazon.com ([10.43.164.153]) by
 EX13D11EUC003.ant.amazon.com ([10.43.164.153]) with mapi id 15.00.1497.006;
 Sun, 3 May 2020 09:54:48 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Chauskin, Igor" <igorch@amazon.com>
Thread-Index: AQHWHS57Jg1LD+a6YUOzm6xpFwMMlaiO5WOAgAdBd8A=
Date:   Sun, 3 May 2020 09:54:43 +0000
Deferred-Delivery: Sun, 3 May 2020 09:54:12 +0000
Message-ID: <601cbd5a68de43b2bcae39eefd0a61db@EX13D11EUC003.ant.amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
        <20200428072726.22247-10-sameehj@amazon.com>
 <20200428120443.09c4931f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428120443.09c4931f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, April 28, 2020 10:05 PM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Kiyanovski, Arthur
> <akiyano@amazon.com>; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson,
> Matt <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>;
> Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Dagan, Noam <ndagan@amazon.com>; Chauskin, Igor
> <igorch@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V2 net-next 09/13] net: ena: implement
> ena_com_get_admin_polling_mode()
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Tue, 28 Apr 2020 07:27:22 +0000 sameehj@amazon.com wrote:
> > From: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > Before this commit there was a function prototype named
> > ena_com_get_ena_admin_polling_mode() that was never implemented.
> >
> > This commit:
> > 1. Changes the name of the function by removing the redundant double
> "ena_" in it.
> > 2. Adds an implementation to the function.
> > 3. Fixes a typo in the description of the function.
> >
> > Signed-off-by: Igor Chauskin <igorch@amazon.com>
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>=20
> Doesn't look like this function is called upstream, though.
>=20
> You should just remove it.

Removed, thanks!
