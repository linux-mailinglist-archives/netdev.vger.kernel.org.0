Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDE2E02D1
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 00:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgLUXHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 18:07:09 -0500
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:33348
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgLUXHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 18:07:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTxCswjooBt8B0cZvBk521X9wv3dicaZ0PLvhzjqiTj/7+Tut+LbTcDl5QVbOH48+JhOrujaAkdcYBixs/JweTwhAonh61HkCug2PJAeOCXMgQK7x75alMlLaUHfJAkQ/Hq02QGxbHZZR4OqbOg6O3Op5JlRmI1Gvd/hcA7Ovbh4S+l1fTOBo6VGRi8x3pQ+W1zf3m6jkroP1eVlgXS9vzRt6cGuEGcxbSIS0SQuRKeTE9RKpte1WIr/O0vezfsFpZtpWgYU5sUnuVfrs7QI//bUnozXqsGYF0t5PYZ+H4J2/hzF2b+9Rr7Z3YopWrEekymxjPn2XGNh7e/Dqah1Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrp+4TTB6JTdQsUvCmFupq/nmHXoWNQ13Z2xMahq4is=;
 b=JGsJLDjXA1qCH7SEVg60PSs83R2843jaNMaErFtfTM6K1IRinPCBnCvHnm9kJZD0Zi1VSWyXfQJZcEfAQtIwk/7tQ/9BfzUjIp5/41TQ8l6g/9cfbNI/tfZLxu00K6qj/QgXOs2CTCs8lSCDBtRjLgD2mY0HtUvBX3azNZK5O0VVYo56MH/Ms7V7gqG6nrkGH9gfo5XftCMO1HmiaMHYxAdYqQHcUsmmWKIZaYhYcH4z0UrM3MIov4CU1bHQlyGoSYhKJ7ATCsVgvBRfyjFEKU2URmg5RTUI7/emlhx3Cu0PzZycdQkeSquYKR5YDDfDcfGaS4mLTlD1MFIoe72QAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrp+4TTB6JTdQsUvCmFupq/nmHXoWNQ13Z2xMahq4is=;
 b=pgfp9r5ftvy6mUriQI+TTLrvySE8HeNkzqtRu2iGXSOZz5WRC4E6WdD+vEw74+Dal6oQ3uAc/2rNsjdCqcGcfOg8sk5B0tx5OXoDlScNCfYg425jBvhIM4G6VgyPF7OBtpl5SiRs62ePV4KL16UuymojUhS1mJclqSdLSx941Ew=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2685.eurprd04.prod.outlook.com (2603:10a6:800:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Mon, 21 Dec
 2020 23:06:19 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 23:06:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
Thread-Topic: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
Thread-Index: AQHW1Y6jUxjdnV3YQ0WXbdlAp0+0q6n9zjkAgACHJICAAqobAIABJ/cAgAAJOgA=
Date:   Mon, 21 Dec 2020 23:06:19 +0000
Message-ID: <20201221230618.4pnwuil4qppoj6f5@skbuf>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
 <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
 <20201219121237.tq3pxquyaq4q547t@skbuf>
 <f2f420d3-baa0-e999-d23a-3e817e706cc7@gmail.com>
 <9bc9ff1c-13c5-f01c-ede2-b5cd21c09a38@gmail.com>
In-Reply-To: <9bc9ff1c-13c5-f01c-ede2-b5cd21c09a38@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e2459ee-8f5c-4787-28b2-08d8a60506df
x-ms-traffictypediagnostic: VI1PR0401MB2685:
x-microsoft-antispam-prvs: <VI1PR0401MB26858087465108243E65C4C9E0C00@VI1PR0401MB2685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4orGwqeqcBhEtcC/w8IsVurIMT+QQJfbip0xvpVlOZ6qDml99zy8LfpCPj67I1qdn4724QFpz3niraR5gSTZ9JHyjC7w0ftUKZkLv3NR/pJgba2SvuAF0anxhjzfnBhpvjrMRUNsVzfE8+iAxPo8P16aVHmuGQHazlrWaPvOAnInYX84zHwXAP+wx+c8gXkaKad9m4N2UrITVos7Ld4b+CUhgTBqp7dWS3jfz1vdLlyt5BwLMSdcxa6rljJG1YznyxoezlqVPkoXpg8T6MTd/yg8rWZno79grscOi6+fQzYj21R658OgefBkcyDSa3bNryXQQ2CyUtNz/o7q3d9JdjTBm94ku35oC8obW+6NUSKawGM4p3GJZ6ALehsP0QrkgnxxuRH704OjyqgTn8HKo8F9OTfZaQqzl3JcajvE5K+VKD1faTf5/gVHo0hFidT2oPB4pniJni3uQy6/qojuzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(366004)(396003)(346002)(376002)(64756008)(478600001)(8936002)(76116006)(86362001)(66556008)(6512007)(6506007)(966005)(66446008)(66946007)(44832011)(1076003)(83380400001)(316002)(6916009)(33716001)(4326008)(5660300002)(54906003)(91956017)(9686003)(53546011)(2906002)(186003)(6486002)(66476007)(71200400001)(8676002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0+UyOYgUvJjIfThQVyh3C3Gw1j6UiAI5Msnylg8yPtOJXgVfArmw9KjWPL+x?=
 =?us-ascii?Q?n3zywnxwkvdRc/LTgqGkStt2HBwZMSCHY5b9NyzWC8Hd/nuTE9KlFgxh0hW9?=
 =?us-ascii?Q?J2/tMl765vlcuF5AJsh5C8NIhXipY/t6KcX/7JqclLVMwRP50kVZs0jlERER?=
 =?us-ascii?Q?2OWN0rycDnAWfz41VxNsgqsbbUYXI7UmSIEJKFLlWv49xT8dG8vu7p3jfLki?=
 =?us-ascii?Q?wm91HsiUGeb1A/rk9f/2kW7MT0/gpASxeCjaLe+S/mQfnbrW86sfNaMh05PC?=
 =?us-ascii?Q?LDD6e2hZt8+BdBdVAZ7KysYCpYQIht1aY+uTi0NhQWXXkvEQMNN7mzZtiAtI?=
 =?us-ascii?Q?gZh76YJMAVPNr8hZZ6WaUJULnCQqKwVTaM+IDYtA3OUNgFYmHp2VQICUZnJo?=
 =?us-ascii?Q?U1WguJ3kUu269+3by6r8WpB8FNnhyf1rUgjH4ryAqnlhdqFEAtwOL3afJ3+n?=
 =?us-ascii?Q?VrAvk+sSdGXpdYU/OcOKF19s+csYKT/+6qeMs8dvW6oyIrANAUroHW5ifUWr?=
 =?us-ascii?Q?S0pJTCgMuyJEAoxc5IcbnxstNSELOpxFekdGUcdW7mS2AI7sYhWPbRq5bMeC?=
 =?us-ascii?Q?onV1xytgzCcCTPyZU196a/vyAK7lFZJJ9FWkwA7tq6WXaINNR3RZfqoKeegy?=
 =?us-ascii?Q?GJs5KISmVWdxGTVMaqb1cFYpKiwCeIWOvQdQsGgh3FAz9MZA5J9PyhR8jNAT?=
 =?us-ascii?Q?T/PUALJwJrLe1FBgURQAMm+4PM6zcPODNoJlAJKcRJoEaTU7fSFKnk/954pn?=
 =?us-ascii?Q?mqo7c0JmEYKdnurfOQ8aKkAJ1POrpk40ynGWBTB3lCDyT+bgB+/pHyg7xZLD?=
 =?us-ascii?Q?Af5V2IiRKcf6MVmw7PgI5yF0HrXEUx5F0+qibtrhsPesfbwgoowNuy/qQ1uq?=
 =?us-ascii?Q?mkSCRwkHUteH6CHVIbG4Rry+U7uCwvCZWZwRzcKexZT1oBSTnAGFfEDHRMGm?=
 =?us-ascii?Q?xGUC7CXZT3P0fO3qT4KXMtWq67zkNYuwt/xgeejtqvgcfJe4/XQArDPyylRx?=
 =?us-ascii?Q?nGr7?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A8DD746343CB4419E9479959684F19C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2459ee-8f5c-4787-28b2-08d8a60506df
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 23:06:19.2081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n7Hg/9LZwbRFUuViB0zHETk/9FOasBCgEsbLoCXzNMW4rLENVHH6Li23lB2H924lUWzO1YcXW8cRbfJ9gEOvkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 02:33:16PM -0800, Florian Fainelli wrote:
> On 12/20/2020 8:53 PM, Florian Fainelli wrote:
> > The call to netif_set_real_num_tx_queues() succeeds and
> > slave_dev->real_num_tx_queues is changed to 4 accordingly. The loop tha=
t
> > assigns the internal queue mapping (priv->ring_map) is correctly limite=
d
> > to 4, however we get two calls per switch port instead of one. I did no=
t
> > have much time to debug why we get called twice but I will be looking
> > into this tomorrow.
>
> There was not any bug other than there are two instances of a SYSTEMPORT
> device in my system and they both receive the same notification.
>
> So we do need to qualify which of the notifier block matches the device
> of interest, because if we do extract the private structure from the
> device being notified, it is always going to match.
>
> Incremental fixup here:
>
> https://github.com/ffainelli/linux/commit/0eea16e706a73c56a36d701df483ff7=
3211aae7f

...duh.
And when you come to think that I had deleted that code in my patch, not
understanding what it's for... Coincidentally this is also the reason
why I got the prints twice. Sorry :(

>
> and you can add Tested-by: Florian Fainelli <f.fainelli@gmail.com> when
> you resubmit.
>
> Thanks, this is a really nice cleanup.

Thanks.

Do you think we need some getters for dp->index and dp->ds->index, to prese=
rve
some sort of data structure encapsulation from the outside world (although =
it's
not as if the members of struct dsa_switch and struct dsa_port still couldn=
't
be accessed directly)?

But then, there's the other aspect. We would have some shiny accessors for =
DSA
properties, but we're resetting the net_device's number of TX queues.
So much for data encapsulation.=
