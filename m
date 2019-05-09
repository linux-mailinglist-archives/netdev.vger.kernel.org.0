Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EF2186A9
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 10:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfEIIRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 04:17:07 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:49386 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725822AbfEIIRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 04:17:07 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 26E2BC00FF;
        Thu,  9 May 2019 08:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557389830; bh=/rAPkCX+h3mO5IIHf8mYqsYYjiVjat0JV+HA8HZ9cZQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DP3elEC22Raw6u58ZxKE6cHYO4d/vP2PxC4Zrcov3iVLEq/foyaeZFCp+dNRRmzqK
         5okKSktu2buW2yf6QoVRhUtEW1cLTFmwTSHGYIOu8CINxDWvOOwCSbT3NLeCbixZ2f
         xeI42f4Od30xnZfYrAcUMRzT321E72HrLjXMkO/jVYpyE3MHzuA1wRxpvduZ2tcxKA
         VUCUHz3PE/+CtviIyNuFT8SPknWM8Rg9szSwmo1lWCK+i22U/9zb7vQkRmzexGwTmh
         a1F7CJ+McQN1N1rzsdX0W3iijq4J1gvPijzT25lrDwqB8IPKU4x2m3ROx7cJ/Um3Ds
         +bhzcEfMPX4xQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CCE96A00AF;
        Thu,  9 May 2019 08:17:05 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 May 2019 01:17:05 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 9 May 2019 10:17:03 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: RE: [PATCH net-next 00/11] net: stmmac: Selftests
Thread-Topic: [PATCH net-next 00/11] net: stmmac: Selftests
Thread-Index: AQHVBXLZwJ2RZgEDF0CNP6MWY759gKZhghGAgADw7NA=
Date:   Thu, 9 May 2019 08:17:02 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B47AAEE@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
 <20190508195011.GK25013@lunn.ch>
In-Reply-To: <20190508195011.GK25013@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, May 08, 2019 at 20:50:11

> The normal operation is interrupted by the tests you carry out
> here. But i don't see any code looking for ETH_TEST_FL_OFFLINE

Ok will fix to only run in offline mode then.

>=20
> > (Error code -95 means EOPNOTSUPP in current HW).
>=20
> How deep do you have to go before you know about EOPNOTSUPP?  It would
> be better to not return the string and result at all. Or patch ethtool
> to call strerror(3).

When I looked at other drivers I saw that they return positive value (1)=20
or zero so calling strerror in ethtool may not be ideal.

I think its useful to let the user know if a given test is not supported=20
in HW so maybe I can return 1 instead of EOPNOTSUPP ?

Thanks,
Jose Miguel Abreu
