Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F727AE43
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgI1Mxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 08:53:47 -0400
Received: from mail-eopbgr110139.outbound.protection.outlook.com ([40.107.11.139]:59126
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbgI1Mxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 08:53:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z65SdpzUCHMJF52KguaQ2DOjBgBC3V37QYnldvJ0eYSvwJwIOTed+/zPAsibDwj5VSFVUyzsHQtTxqMcDfEkFDJcQ/hexWuHsN1PgOfLGOwFGFphPBp/shGH8C3kanEI9odIFjYG85CbVlrZyfnSKcpQVO+nqG2XqboXJlArgKZh4Iwgg49CZd4Vv+ApKmgA7hxM5hZaEfHCIoVUYwShfyLN/pTiJ/MN4XwO0pl9TeIQPZkZpK+U744PnsU3C42J26fcF+8o1Wr/zc7NtacLas9a30i5RHktjrKRZVSarb/J1icvEUXWzam9tszyXg5V9VKcnozIoDHz985TXHm+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLXYPowHwSHTfDhGTg+dNEGFSso3PbRaJUpcmymPXcs=;
 b=F6WXE0YNuZyaJNfwC549Q8/o/iH0rn6OaW/EwajMKqKiAMjW1mdsqW5lWxbsFn3N4vMtsElBnrMbTM7eNnM2DHOKEFj6c8rhza7ZsNH25buRbvfhoDta1NnrVeQOrFIwzcBHmHVREeG+Zy8vJW3wjIBPWZXNOg6hp9iTVcT2gqWx8mzpO9Q8R+u5jJJyKe7a2RD5SgfwvnF0plIGZ3ddSz3U7RicwZK/uweCdxz+5mQu2TnRuTyDoNTEcc2Q7jReZLK+1Rw2e2BdRI8e4rL9K0URiWiB5ILOA6FSOM/Y0GqCEqryn9ldCEZNu81v/5MJFIcV2HIp1i6ToDdMOR8b3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLXYPowHwSHTfDhGTg+dNEGFSso3PbRaJUpcmymPXcs=;
 b=hecLrSgaBEyEIjc6RyvuLdXqPB9eNDa8AKVyieMj0oA8MSiDCbm6XgZ6thzbJaixB73O/mp+PbeGrGFn7GmEBDTi6vFmX5OZTGOc1Un/gbINzy0TjWzEYhTJk0DBPce+rB3m32b3IeEE80SrKBKXcjJ350WWJyZB7CVdOFE3KtI=
Received: from CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:6f::14)
 by CWLP265MB1796.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Mon, 28 Sep
 2020 12:53:41 +0000
Received: from CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::e102:fffb:c3b6:780f]) by CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::e102:fffb:c3b6:780f%8]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 12:53:41 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Joe Perches <joe@perches.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Thread-Topic: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Thread-Index: AQHWlYEQBtpUmlBsIE2OcjRvCcmkD6l99NGAgAAMhSc=
Date:   Mon, 28 Sep 2020 12:53:41 +0000
Message-ID: <CWLP265MB197217D895F966587865FC93E0350@CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
         <20200928102008.32568-1-srini.raju@purelifi.com>,<c75638782a5a4bc141008c6c3dcec4fd1567da79.camel@perches.com>
In-Reply-To: <c75638782a5a4bc141008c6c3dcec4fd1567da79.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.104.125.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca7a2985-fd98-40cd-46f0-08d863ad86ab
x-ms-traffictypediagnostic: CWLP265MB1796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB17960609266CB89D610FAA4DE0350@CWLP265MB1796.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h7XgFyu1YCYWtse+hswywv+8vJAH93hU3bdv7a5dnQBAfOHkRBtSTBygkXxk2xiLYs16sOA5hKkWw98rR+cgqIEEsyczYTgy1w9cN/dbT7QYUvlP1XghzMpHAzIX2EnjF4PYDbXPrhlyxSJ//SLEfAzvuHCKRib+cM0AitJ9HgqFws3LNG3Dnx2hlf498RczE0GaiZlUScmaM4qBYg054hlgMQHnxVhiUctNStTU1VoJ+xs+SYFhEm5N+E/kjX2f31BF8Sb9CoCZe6Ghnc4FGxLF/4cbdyBgCY+p5Ecc4vBJpOEGykS801yExphSm4vbBQT9FX9xDHwPhSEKGdWn7zsFj+KioniaiBKwnhhchku6EtWgWuiZ/plH6bgWYbLo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(346002)(396003)(39830400003)(136003)(376002)(52536014)(9686003)(186003)(26005)(55016002)(54906003)(5660300002)(71200400001)(8676002)(8936002)(2906002)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(91956017)(478600001)(316002)(558084003)(86362001)(6916009)(4326008)(33656002)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 3xAzSevfqDIDzfqatoSuDKAlq9dAsria9FDpjgomqHCNlriHUU2bB/B3gkgn2xhmjuICIsjrwXnb4AZfmJ6eMfz0N4/hVpVRvg/JM3XPlZZ576YsdJhlFgFGzVvrjlbtr63EDB0ZrVhqq8ddk+RW9wA+6guGcK3nG2LFMtJrOLljxO38IfUI+25aGF/HqD8jhotNwBcPvKtLCVHVDFkbj5hzQPfOH2aV6NOOlUqVyAc0UADbPGwtYEVgu7xj+N9HjU0bGMRG59y/RI6mIQaogFniBuPBDg1rewHHfAJMj3eFAZxNwDqcmClJMD8nLG3fDJ6JRA+a9JJAR3IxSwu7UIq7UWGjBI0j3bOYYJOYBjuiBs907k/CF2YybAYP/blj8D2NX5KZQJARxR/IYvl3T5bEIoS9cZBjX0Se1gUU5bRv8ZOwj4AJPXznU7qYHnOeBICF8KpDGTKkHkeLsCNisfotpCey0g+ciPF2MWxwskVXSd/qzmsaHQ/pTjXOPztmbqsJuNIOI/AZ3C6H7TUvyF8XJmmi17AzxrnNiXRUmQh93NAkrbfqEi0CYZrQf5ohtmOtG2jE3CyvthcCmh7rC3rpqI5c7zd4vU5d58SrLPDikrPyFe5PkXSwJ9z8w5Gw1ezfhkfKjc14hMRdXi4PNA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7a2985-fd98-40cd-46f0-08d863ad86ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 12:53:41.2550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rSJLhloXoH4teI4Z3HWwGvC3GnDDIbcwsLVkjx93JVmZpqMaKqHq7CgXcRnHcFqC/jrQVVa8THckERvC6Cy/Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB1796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
> Didn't look at the rest=0A=
=0A=
Thanks for your comments Joe, I will refactor the code for clarity, remove =
redundancy and address your comments.=0A=
=0A=
Regards=0A=
Srini=0A=
=0A=
