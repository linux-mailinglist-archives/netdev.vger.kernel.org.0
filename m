Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4421670F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGGHLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:11:52 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:3564
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgGGHLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 03:11:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1r47d6302zxsym9VubLpTY099ZtCsTNqZNkciyhCPi5tBA5gsaqQhBIie0/89eragw5CzbFnou8ZId14nXzLBqORyEhjd8syDsLiLvV9OzkIyMeuZr5OlYfCjn128S6erM1FYbC6x7TJdaxn3+G3R1tbpUItOJhRZlUcIj+tIbmY4gdNbKJ0X6LX88JVgIaeKqQmQRwm5lmafVsqjpc9TSD6E/pZrzGCixL2Q4r9JRqGoSOJwg8qsVL4k5kn+XaabL15p0N+qmio2M8P+AXk0URfDrO0M5Ou+TQAG8ve8BVLjSylNXtgUZP7y4NBRPIQwnM55K763+/71pOc3en/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTbTMPWeYaWIHl5je9XDhV9s87ToDcU6jWzghITbE0M=;
 b=Z9dlCbqoT7VM+A1K3/U9+SAQZyYv52JBZkhUGNpYz5qcqoafPj2zWzIQIFZfXA/sMYBB5PPWHpxIolCJX1GwKJ+1mHhpSgUkXHkiv9Itiy+p/fgzglFgk2BDsPLGdQcXnUDmRHY8EyF3BMuDiECmDapRztBxjieGidzum8t74F/thNqHqIORSrHgbH+0BDQi4Ne1VJt7tA5pRkM/d7xJi6+QxdNTS2hQxk1x8bOvyfGsh9jgAIJjEFUU6cN4GcQKFx2iXWQ4+L/dfLpemNcJrmXHXaDJhaDDqTrjdfR700BC8hzftSkSblj06P4YMDgzA8qKquFmRmxNJmMXAYFHHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTbTMPWeYaWIHl5je9XDhV9s87ToDcU6jWzghITbE0M=;
 b=YHFRBDAVkM3YgGxEgBz/Oc3e2xfr2of8I2Hu3SXDL3EPG2vkt+LwsUmKH6aiTFBMRna+mXJ7Lh3vyHhZc3JXWLjTaNADtXCNkj9mqGzOMrNaNO4Ki4jRteUu4N8e3SwIHEYp5uYuQP6ATrEfUSuWsDehqOR2uKXTRdOPxqzfuQI=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5405.eurprd04.prod.outlook.com
 (2603:10a6:803:d6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 7 Jul
 2020 07:11:48 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 07:11:48 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] dpaa2-eth: fix draining of S/G cache
Thread-Topic: [PATCH] dpaa2-eth: fix draining of S/G cache
Thread-Index: AQHWU6WURjzgTmCge0esRJLuBnavuA==
Date:   Tue, 7 Jul 2020 07:11:48 +0000
Message-ID: <VI1PR0402MB3871233981DA38E881F1CCAEE0660@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200706145554.29439-1-ioana.ciornei@nxp.com>
 <20200706.130133.435191921384022769.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d24a7c6-cc72-4746-714b-08d8224503f3
x-ms-traffictypediagnostic: VI1PR04MB5405:
x-microsoft-antispam-prvs: <VI1PR04MB5405D6745D487C5CD6671C1EE0660@VI1PR04MB5405.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PgbCWRttwxpnlTfFHs2EDVJIUPDTZ5SGqcI1OowIXSYcFNDmb5EOqJM4DzUGrV0SPNAyUljLO998NyXk0qT23/fBxQncSvn92m8YaKVSgIVquVT1AreZPMyo4gaqzAgn6I+qw+cI6L47oDcufHYmKH7GjyU+dofKxslCX+Au8BMQhmayoqg5HV6hr3ByTHoudb6l8YLSxStchnVLk113OPtSpLTMox9h1FU96eEn1NZpruQz6T67HVomKJntokw+znMyzfFrGNC7gOsIW/nskN5iERcqJ+gl0DMxFuH4APl6D9MssRxLhDglmtcda/bok17rBgnqp/nMj606J4k80g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(66446008)(64756008)(478600001)(26005)(6506007)(53546011)(66946007)(66556008)(66476007)(4326008)(186003)(83380400001)(2906002)(54906003)(9686003)(316002)(55016002)(76116006)(44832011)(4744005)(86362001)(5660300002)(8936002)(8676002)(52536014)(6916009)(33656002)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: V+49qQpVz9oMhcNMX/xgSLInt1kezX5DNRNDcHyu9OzqjcpvQVo0WwtnniVLacLUFB8T9ScDYSZb92N6wv0TGUWv4kGYghorgxNiJGSKSbGs/sl1GTcxEJDZn7RE0f3Cy5P7rGU3f6eeB6zJPtX70X/jKUlQ6vUhJSQ8toRz9UuR6l8ZVFJ/B9SXiU6TMIoZGmYm/2IhqYwxV52dfeWpyzYP0aglHSv+qRkDJNoFZ45XLAGhnHrycfvFDlyBLCkFx02jsSsydwjTwfNoCyC7dLnRok52CVE8SgKskfDzGrjJMZsv4cb9fLGFQF/+qvkvQTtKUJGSI7q9vZ3rlJDey/7+ikQVVDrIqzWFlPWQ+V5DPfQhu1y4pilwnDA7AXwNFpdAXsIVHlNw7Azt5zcpP/UZ+GuZ3MHIUJEGwquImb1ZW82xN4rqSDdvxKyE+jkTAQImIWCH5W+l4E6ZHLDSSY5SYSDKfbH2BDWKSYtRsF9SAxtbPUjgTdrqdiVHBUOM
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d24a7c6-cc72-4746-714b-08d8224503f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 07:11:48.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qxiIiZr+8eDfe4ISAR43BMmZKWvKfcnj0z4eYxLIv9Faa2ZN5OggzlnvYRe5Uu1NJQuGsTNsAyjviMSIBr46JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/20 11:01 PM, David Miller wrote:=0A=
> From: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
> Date: Mon,  6 Jul 2020 17:55:54 +0300=0A=
> =0A=
>> On link down, the draining of the S/G cache should be done on all=0A=
>> _possible_ CPUs not just the ones that are online in that moment.=0A=
>> Fix this by changing the iterator.=0A=
>>=0A=
>> Fixes: d70446ee1f40 ("dpaa2-eth: send a scatter-gather FD instead of rea=
lloc-ing")=0A=
>> Reported-by: Jakub Kicinski <kuba@kernel.org>=0A=
>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
> =0A=
> Applied to net-next.=0A=
> =0A=
> Please explicitly specify the target tree in your Subject lines, "net-nex=
t"=0A=
> in this case.=0A=
> =0A=
> Otherwise I have to guess and do some trial and error to figure out where=
=0A=
> your patch applied.  That wastes my time.=0A=
> =0A=
> Thank you.=0A=
> =0A=
=0A=
Sorry, my mistake.=0A=
