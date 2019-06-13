Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9F6444EA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392591AbfFMQkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:40:14 -0400
Received: from mailout41.telekom.de ([194.25.225.151]:58351 "EHLO
        mailout41.telekom.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730581AbfFMHBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 03:01:44 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2019 03:01:41 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=telekom.de; i=@telekom.de; q=dns/txt; s=dtag1;
  t=1560409300; x=1591945300;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nRT5A4BOCigKt/CJPzf6Dd1bvDtB6M9sLgzli8jFXXQ=;
  b=fofUkg4E8mVuj/711x+aFdnDkKZXypt0XB2LpP7VJ5fpjtqbieivrAAK
   VN6LaLw4pBeA2/EJxWsOGhl8wBI6rs8jCloa45HDk6hsh+vUEcUfs9h2X
   IHUvn7qlMeErSvBUl7gVDLuJSQCbDztVoKA5PL/PeEgCj+dV025kYQk7C
   OZEwnOgetDgSdByKyRPDRe2FQDuIqI3r8veHjVTk/u33BokZEXD13DKdA
   BaOEqXoeCJF6Uuuyh6IncxzAjrs+CAvajChQFDZm+Qhl+MXGKHfQC4doT
   lLvKGCiNa0Bke9vSSv7V4utU4HMmSxzUIcUtx5eC08qdW8hIoX9FXe/MB
   A==;
Received: from qde8e4.de.t-internal.com ([10.171.255.33])
  by MAILOUT41.dmznet.de.t-internal.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 08:51:47 +0200
X-IronPort-AV: E=Sophos;i="5.63,368,1557180000"; 
   d="scan'208";a="558044997"
X-MGA-submission: =?us-ascii?q?MDHC1rrIcAjntsWRCRfIx0s0XoBWc+1elqhHWn?=
 =?us-ascii?q?EP/ZMmzTuwUn8UPMKXKeLg1dlxyWbwfw0gRSKHEnCvGkPchNM6qInt5G?=
 =?us-ascii?q?qyakdshclRUWMT7550SXVLQWSNOZEQsEh4HFqXwN694A+nkl6d/cuvdw?=
 =?us-ascii?q?vItwNlbr54aNHYkwOH+UvKbw=3D=3D?=
Received: from he105717.emea1.cds.t-internal.com ([10.169.118.53])
  by QDE8PP.de.t-internal.com with ESMTP/TLS/AES256-SHA; 13 Jun 2019 08:51:49 +0200
Received: from HE105664.EMEA1.cds.t-internal.com (10.169.118.61) by
 HE105717.emea1.cds.t-internal.com (10.169.118.53) with Microsoft SMTP Server
 (TLS) id 15.0.1473.3; Thu, 13 Jun 2019 08:51:35 +0200
Received: from HE106564.emea1.cds.t-internal.com (10.171.40.16) by
 HE105664.EMEA1.cds.t-internal.com (10.169.118.61) with Microsoft SMTP Server
 (TLS) id 15.0.1473.3 via Frontend Transport; Thu, 13 Jun 2019 08:51:35 +0200
Received: from GER01-FRA-obe.outbound.protection.outlook.de (51.4.80.16) by
 O365mail01.telekom.de (172.30.0.234) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Thu, 13 Jun 2019 08:51:29 +0200
Received: from FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE (10.158.133.21) by
 FRAPR01MB0899.DEUPRD01.PROD.OUTLOOK.DE (10.158.135.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.16; Thu, 13 Jun 2019 06:51:34 +0000
Received: from FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE
 ([fe80::d969:b29f:d3b6:e1bb]) by FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE
 ([fe80::d969:b29f:d3b6:e1bb%5]) with mapi id 15.20.1965.018; Thu, 13 Jun 2019
 06:51:34 +0000
From:   <Markus.Amend@telekom.de>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <dccp@vger.kernel.org>
Subject: RE: [PATCH v3] net: dccp: Checksum verification enhancement
Thread-Topic: [PATCH v3] net: dccp: Checksum verification enhancement
Thread-Index: AdT/bWC4cN8MoIp5SSiDAcCedYQ21wD9aPSAB5EDExA=
Date:   Thu, 13 Jun 2019 06:51:34 +0000
Message-ID: <FRAPR01MB117066D965524B71A7E18FA0FAEF0@FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE>
References: <FRAPR01MB11707401056D4D6C95D8C615FA3A0@FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE>
 <20190505.095309.439816991626967361.davem@davemloft.net>
In-Reply-To: <20190505.095309.439816991626967361.davem@davemloft.net>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Markus.Amend@telekom.de; 
x-originating-ip: [212.201.104.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8a08c9a-0a57-44a4-23a0-08d6efcb9324
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:FRAPR01MB0899;
x-ms-traffictypediagnostic: FRAPR01MB0899:
x-microsoft-antispam-prvs: <FRAPR01MB08991FC8434BAD3983AD191FFAEF0@FRAPR01MB0899.DEUPRD01.PROD.OUTLOOK.DE>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(39860400002)(346002)(366004)(13464003)(199004)(189003)(2906002)(186003)(26005)(5660300002)(476003)(11346002)(446003)(72206003)(478600001)(14454004)(66066001)(15650500001)(66556008)(66476007)(64756008)(73956011)(68736007)(76116006)(66446008)(66946007)(53546011)(7696005)(76176011)(75402003)(52396003)(6916009)(486006)(74482002)(54906003)(102836004)(53936002)(6116002)(3846002)(6246003)(4326008)(86362001)(7736002)(305945005)(229853002)(316002)(55016002)(9686003)(81166006)(81156014)(8936002)(71190400001)(71200400001)(14444005)(256004)(8676002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:FRAPR01MB0899;H:FRAPR01MB1170.DEUPRD01.PROD.OUTLOOK.DE;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: telekom.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LCahYJiTI76PjoTUUgxBiblSw/2oSRZi50y4tHU5C+6pNiZ6TX6t4O6J+zVabMIazIQqzlhB7Jky4z3SQEGDytYyzYl4g85bxnXDE1NYjWvB1B81xO8PRyGIBBU+pw9L/8HFk3DzeZ2B7CYylH/1+HrUVhDkmjhKklcqnHzH5qwsn8usQMSs4ZQqUYbH82Mq/O2SJKXM73aeGjWZkxOxA0lhHx8v5ZGbECZDdYO9iG/2YTyMONEFtML1zu0BMEzstvMdKzpKXYdk9VSHpq9qlCRjIAw6JfZaN8Mk8FKWt2ohqVHfizDoeTYpoIe3CmMbAV/ZRitUlPFygeTR3n2SnwYyiZ1FbDux4/ctnTA0OP94zNxgexTJ1HxXfdRNZG4XJ5o7lE2xt6WWUI4Ibx9Z060RxWY2+cmLHKwu2frRE0k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a08c9a-0a57-44a4-23a0-08d6efcb9324
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 06:51:34.4992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bde4dffc-4b60-4cf6-8b04-a5eeb25f5c4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Markus.Amend@telekom.de
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRAPR01MB0899
X-OriginatorOrg: telekom.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Yes, you are right, I overlooked this. Unfortunately the current receive pr=
ocess in the DCCP layer does from my view not properly support the skb->ip_=
summed flag verification, because the checksum validation takes place at di=
fferent places. This would require some dirty hacks...

I see two options.

1. Adding the ip_summed flag verification=20


or 2. Learn from the UDP stack

Since UDP/UDP-Lite are very similar to DCCP, at least from a checksum verif=
ication point, I ask myself if it would make sense to re-work DCCP's receiv=
e process according to the one of UDP/UDP-Lite?=20
The relevant process in the udp stack (for IPv4) I identified therefore, ca=
n be found in /net/ipv4/udp.c, within the function __udp4_lib_rcv. There it=
 is done, compared to DCCP, the other way round it starts with an udp4_csum=
_init and most likely a later udp_lib_checksum_complete. Both consider skb-=
>ip_summed. If we would implement similar functions into the DCCP stack and=
 adapt the DCCP rcv checksum validation process to the one in UDP could mak=
e probably more sense?!


Personally I prefer the second option, what do you think?

BR

Markus


> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Sonntag, 5. Mai 2019 18:53
> To: Amend, Markus <Markus.Amend@telekom.de>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> dccp@vger.kernel.org
> Subject: Re: [PATCH v3] net: dccp: Checksum verification enhancement
>=20
> From: <Markus.Amend@telekom.de>
> Date: Tue, 30 Apr 2019 16:11:07 +0000
>=20
> > The current patch modifies the checksum verification of a received
> > DCCP packet, by adding the function __skb_checksum_validate into the
> > dccp_vX_rcv routine. The purpose of the modification is to allow the
> > verification of the skb->ip_summed flags during the checksum
> > validation process (for checksum offload purposes). As
> > __skb_checksum_validate covers the functionalities of skb_checksum and
> > dccp_vX_csum_finish they are needless and therefore removed.
> >
> > Signed-off-by: Nathalie Romo Moreno <natha.ro.moreno@gmail.com>
> > Signed-off-by: Markus Amend <markus.amend@telekom.de>
>=20
> I don't see how this can be correct as you're not taking the csum coverag=
e
> value into consideration at all.
