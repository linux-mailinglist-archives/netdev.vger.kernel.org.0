Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817B53B8F1A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 10:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhGAIxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 04:53:18 -0400
Received: from mail-mw2nam08on2042.outbound.protection.outlook.com ([40.107.101.42]:27361
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235088AbhGAIxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 04:53:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdjaIa2Z7vLajReSY7GVZaC9/ikxY3Ssb9u37hMa0kf2/GnMKFOVEpVuh19UzoASUmSC4QKYxqKaTKGqSo2HFIqzq7iFDH1PLmom4xq0bouNcybuzubbvhisIktGW3p5Ftq3IskIKNCRgWmBRwHxrYizIeqjz26d8lp89t+nsRt5Rcx+hLOvKc7gsNb3Yx0dFh8+88zTdWDCe757gOtGOsmYlGREpqtBXvip1cFP7Cx+z9+8J5cE7ziJjE+ViM0rSYyovwatQXJVkbOrMRGOUDl+JSW3MZZDNATK++2r7FPFU4HxMYnBk1lnUNfoHBlRlrslb3j3ivlm9JXQA80GaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKG718QjVQCBgvJeAsDenJfnuNfpu7Bsnn3RfcBuFS0=;
 b=E1yal8jaEa7X3DuY4uV8dBbcx4d71ydP4G+B9JeCrhyHtXOFeASKmlHblMfpq2RjHa3JV9GhJyFfxhBrq7rPMrRjmCl2ldvtFAdRxc/QfcGpcWVXulQWu4+oakzwOvC3P0R3hXoLRURfHDvLKneCTomrB3DayDzjZXs6EirjBEGl4tVkHcf9sZcaspbOqACPRYZNRZNTWhnvMZ373oFK70/mIqx8ZXlnCVE/Hd4U39egZlnkqeuzOE2WU1Zh4ZO1/4ND8Ij3n066PnFa9moIJWJcxqIZPTF6sbKiL4C23OxA4jUHLp7fyf5KPzG5ZIIPi61lsywK9ilRDXJctJcRvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKG718QjVQCBgvJeAsDenJfnuNfpu7Bsnn3RfcBuFS0=;
 b=aOyHEZxsU/m9mcGyQS4VyBF+uf6839xW8bpM4LtheaPJ8n3QtcqGCDGSYzJX5d0WBGhtsO/hCTGxriqisDphwF2r6IsnCQDhw2Y8Hzy3mKMxD3XuQorH5LxWcqBeDvK8yJi03pR+yZUQtRx62Ry7OQGx6Qt6nZm4GK5VXvX1nBi4M7ZK5ru3kbm5eTZ6dC2m71wdmRFDa0CkzgOh+smx7B2sFobzZQAJCgFX3x9N2K3Vgwdr+nF2G8XrQBCzYh6+HwgUcP4MDfq//4nfxbXPNiW0jqywwKx+nsYJBHZqjKlnbQNrsy4FZI0uEemm5AUJB2ZPYOdXADccG+8Iope6RQ==
Received: from MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16)
 by MN2PR12MB4656.namprd12.prod.outlook.com (2603:10b6:208:182::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 08:50:43 +0000
Received: from MN2PR12MB4517.namprd12.prod.outlook.com
 ([fe80::84c4:a135:4dbc:8607]) by MN2PR12MB4517.namprd12.prod.outlook.com
 ([fe80::84c4:a135:4dbc:8607%3]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 08:50:43 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        Amit Cohen <amcohen@nvidia.com>
Subject: RE: [PATCH net-next] selftests: net: Change the indication for iface
 is up
Thread-Topic: [PATCH net-next] selftests: net: Change the indication for iface
 is up
Thread-Index: AQHXaQvXeC1EK8MyIUC/3gHQLgwveasjs/QAgAolb2A=
Date:   Thu, 1 Jul 2021 08:50:42 +0000
Message-ID: <MN2PR12MB45172880B30787CA283A3A22D8009@MN2PR12MB4517.namprd12.prod.outlook.com>
References: <20210624151515.794224-1-danieller@nvidia.com>
 <20210624215102.auewn2cod7z5kjki@skbuf>
In-Reply-To: <20210624215102.auewn2cod7z5kjki@skbuf>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c08e5b4-da60-4184-ccbf-08d93c6d4f75
x-ms-traffictypediagnostic: MN2PR12MB4656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB46560B703E738D679FB023E2D8009@MN2PR12MB4656.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cRGwyKMmq+lchriXXaC4e1+KunTqkYSqR7OpUCk+bcBBG6dKfW1wUvzRUU3xryl4BZTswj/BXnUAj+gOwObV91sYUmKzgtoVw6FoVJhJa0iYgX1Y3U+x57MOzTCEhLoepR5kAeBgEV9BcQhtyMaItzYD9f3kQdi4+O2EKurc2xmDwTZaVW2NqdyP0RnaQJWS63ZHPtvJcnU/nRi/gidp0WzIR+Q4G7Os3Fx4npvUoFv9e8y9OZTaESCM5Fs4gi+Jkrho2mLVmWQ6KnXvDBRq6w6aiecm633IpNHRVVKK8zrKeF4cM/B6zEXxBgaACs3rVivHhA9AE3baLn9ReWeOykaalrqrO7CKmMaMfNMSjgtoYgLC9VCw0VBrIhgE5chyan+K2goNZmhEMIpqIIQ2CJ6WfGWyQ0Yg48DtOoseBcO7kFJalDbAdrzT2upXtOGxwzAUIIAzC9xQmp2XzTDPhAZzem4VEw59B9zQeWtcuOKKrIfVSl9Rz8VUBK/jGv6rJkNIoZI62wZG/3FPNAzRZKtYSSiKbAW+5wJKTRKMIPmBZRKM/JpwRIqWYZyCaV3UN9jwzsNM2zD1wH/NCXFHklnmnzWrJ7cesLNp3dLZGJezHopvbaHu3zcbwusmG8oEgfg/mQNzxWMpDHdJogs5lw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4517.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(122000001)(54906003)(8676002)(38100700002)(5660300002)(107886003)(316002)(55016002)(2906002)(9686003)(86362001)(8936002)(53546011)(478600001)(66476007)(26005)(71200400001)(76116006)(7696005)(83380400001)(33656002)(6916009)(186003)(52536014)(4326008)(64756008)(66946007)(66556008)(66446008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?JZNhS+w6BCfwNHyra80c96tbJP8i64IxkNVFZ5HLXpfNouNnYjWwHnM3pa?=
 =?iso-8859-1?Q?im7RGuXsdxIuRIgFiKIIk9OLkhLfAM3FShZR04JGJen/o8G0Dr1BotFDTS?=
 =?iso-8859-1?Q?y45Ij4Ae2PmQqdHqysBZHxEh+TEkWs4cQIV14ryYupYBC26JYSYam/hSpV?=
 =?iso-8859-1?Q?mCl9QWEAFDeC1/lyT6A6TwLi3LKD3pyEDY/hG99Kgw5h3XeOUpES7fCCGf?=
 =?iso-8859-1?Q?I7vOPzzwC+F0wvx7gGzsSct4AD351UH8YxCtLTFKGmh367LGoIA3RrDq8x?=
 =?iso-8859-1?Q?yH3V2kNvoP8eod19mbWbtYmvy0nokbcHlZofAsvHiV0XH/WOWaNTp6F6f7?=
 =?iso-8859-1?Q?pFMH7tKk0cuJ9tj83ax/GsjTwn0/ZJzB2U8Y9viwZBTnLdyWMKUd9KLh0/?=
 =?iso-8859-1?Q?LyTYw1dnrUt9+30pW2IL2EIY5U3dtI2GSBuVYs6+eN+7/midb7QOik9+CB?=
 =?iso-8859-1?Q?rm6zt2D6lBd5iSbgrlYOSUZudhdCGrz3PJfm4ndy9ymSxwYyAqbSupJ6kd?=
 =?iso-8859-1?Q?QP6hVqFf0Pe+cOpUATOadjCp1b4QL7yq365A9AiqoJMPRZtLWsyH4zYEpJ?=
 =?iso-8859-1?Q?zESOH9Swiris1Dc7pJxk5uMwlnOVlHRNlP6qcMzOWsVTPKEDa0o8b6PQlB?=
 =?iso-8859-1?Q?jfoSeiapVbIqdOHqB1JWmjTRru9n37ZotV0diBC6XrEzTRL85UXhXdLBXG?=
 =?iso-8859-1?Q?7OsTXup70EfHqq8HNVtlrM+2Miz/HioF7RWDQ3tdCx9nHtdgkSPIHJcuja?=
 =?iso-8859-1?Q?ceJZjvAjYxdbc2GXUMR40YJL/rvDDdfrojaXOdRZR9F90nEmwPa57m/dge?=
 =?iso-8859-1?Q?GBdGEAdgnHXQzpfVgEGq+Xqoptta+VCoD5B6yPHQhjpvE/CEPDJCkbRhBG?=
 =?iso-8859-1?Q?Vh63JXUzwlG5A+B596y4T8nDArieeViuXLlOLQkpR04ytZxwJQ0Si5fnLu?=
 =?iso-8859-1?Q?NhsZFTA3AW09KbMc36qh34NB7f0iWRhEQQqAqXyu5GgtQBC08sw99u6FgK?=
 =?iso-8859-1?Q?rG6IiFQJdAgaTMEkPlLkWxWGxidUvkvLVQrPYDYS2oqmS0Q5oWN3DEDxGF?=
 =?iso-8859-1?Q?ifKD/yYnXhiAjVF5uZpwzfOXbCE4x7KKjmqfzLHITTS+VbsV9+lvQ3yGLR?=
 =?iso-8859-1?Q?68JSVB/ZYlTOmNkH3KFJJ6p+1nx1D0h+inr7/FExXxtm897jYwSfYoMYsQ?=
 =?iso-8859-1?Q?bXXRbfiegx91vLxqXyrzxHYcGIfms0cbPhHvskQ0EupvcoVnPfnfAL1Iw9?=
 =?iso-8859-1?Q?l9M2PGWUeXun+EcqE6qmiNtt5BCjINzGQVPe4HzSyDkSTEBbPpC0vkJkDW?=
 =?iso-8859-1?Q?aAw9WsTXkv1soQUrCU1o/+cU2aNqDxN/zy93+/IxU1TUXCIFy1fWTy5kpr?=
 =?iso-8859-1?Q?TO6iPwLA5s?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4517.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c08e5b4-da60-4184-ccbf-08d93c6d4f75
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2021 08:50:43.0603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vanqFWsMqMw+kmqhc1fFz3fGhcNP8vhGZavIkHL6HeORWjUwGHwaWg+Pn86+28llmtzebVbT67cDiS+cXjiFEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4656
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Friday, June 25, 2021 12:51 AM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; shuah@k=
ernel.org; Ido Schimmel <idosch@nvidia.com>;
> Nikolay Aleksandrov <nikolay@nvidia.com>; gnault@redhat.com; baowen.zheng=
@corigine.com; Amit Cohen
> <amcohen@nvidia.com>
> Subject: Re: [PATCH net-next] selftests: net: Change the indication for i=
face is up
>=20
> Hi Danielle,
>=20
> On Thu, Jun 24, 2021 at 06:15:15PM +0300, Danielle Ratson wrote:
> > Currently, the indication that an iface is up, is the mark 'state UP'
> > in the iface info. That situation can be achieved also when the
> > carrier is not ready, and therefore after the state was found as 'up',
> > it can be still changed to 'down'.
> >
> > For example, the below presents a part of a test output with one of
> > the ifaces involved detailed info and timestamps:
> >
> > In setup_wait()
> > 45: swp13: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel master
> >     vswp13 state UP mode DEFAULT group default qlen 1000
> >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > minmtu 0 maxmtu 65535
> >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > 7cfe90fc7dc0
> > 17:58:27:242634417
> >
> > In dst_mac_match_test()
>=20
> What is dst_mac_match_test()?
>=20
> > 45: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel
> >     master vswp13 state DOWN mode DEFAULT group default qlen 1000
> >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > minmtu 0 maxmtu 65535
> >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > 7cfe90fc7dc0
> > 17:58:32:254535834
> > TEST: dst_mac match (skip_hw)					    [FAIL]
> >         Did not match on correct filter
> >
> > In src_mac_match_test()
>=20
> What is src_mac_match_test()?
>=20
> > 45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
> >     master vswp13 state UP mode DEFAULT group default qlen 1000
> >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > minmtu 0 maxmtu 65535
> >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > 7cfe90fc7dc0
> > 17:58:34:446367468
>=20
> Can you please really show the output of 'ip link show dev swp13 up'?
> The format you are showing is not that and it is really confusing.
>=20
> > TEST: src_mac match (skip_hw)                                       [ O=
K ]
> >
> > In dst_ip_match_test()
> > 45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
> >     master vswp13 state UP mode DEFAULT group default qlen 1000
> >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > minmtu 0 maxmtu 65535
> >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > 7cfe90fc7dc0
> > 17:58:35:633518622
> >
> > In the example, after the setup_prepare() phase, the iface state was
> > indeed 'UP' so the setup_wait() phase pass successfully. But since
> > 'LOWER_UP' flag was not set yet, the next print, which was right
> > before the first test case has started, the status turned into 'DOWN'.
>=20
> Why?
>=20
> > While, UP is an indicator that the interface has been enabled and
> > running, LOWER_UP=A0is a physical layer link flag.=A0It=A0indicates tha=
t an
> > Ethernet cable was plugged in and that the device is connected to the n=
etwork.
> >
> > Therefore, the existence of the 'LOWER_UP' flag is necessary for
> > indicating that the port is up before testing communication.
>=20
> Documentation/networking/operstates.rst says:
>=20
> IF_OPER_UP (6):
>  Interface is operational up and can be used.
>=20
> Additionally, RFC2863 says:
>=20
> ifOperStatus OBJECT-TYPE
>     SYNTAX  INTEGER {
>                 up(1),        -- ready to pass packets
>=20
> You have not proven why the UP operstate is not sufficient and additional=
 checks must be made for link flags. Also you have not
> explained how this fixes your problem.
>=20
> > Change the indication for iface is up to include the existence of
> > 'LOWER_UP'.
> >

Hi Vladimir,=20

After a consultation with Ido Schimmel, we came up with the commit message =
below:
According to Documentation/networking/operstates.rst, the administrative an=
d operational state of an interface can be determined via both the 'ifi_fla=
gs' field in the ancillary header of a RTM_NEWLINK message and the 'IFLA_OP=
ERSTATE' attribute in the message.

When a driver signals loss of carrier via netif_carrier_off(), the change i=
s reflected immediately in the 'ifi_flags' field, but not in the 'IFLA_OPER=
STATE' attribute. This is because changes in 'IFLA_OPERSTATE'
are performed in a link watch delayed work. From the document:

"Whenever the driver CHANGES one of these flags, a workqueue event is sched=
uled to translate the flag combination to IFLA_OPERSTATE as follows"

This means that it is possible for user space that is constantly querying t=
he kernel for interface state to see the output below when the following co=
mmands are run. Their purpose is to simulate tearing down of a selftest and=
 start of a new one.

Commands:

 # ip link set dev veth1 down
 # ip link set dev veth0 down
 # ip link set dev veth0 up
 # ip link set dev veth1 up

Output:

11: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue s=
tate UP mode DEFAULT group default qlen 1000
    link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
11: veth0@veth1: <BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue sta=
te UP mode DEFAULT group default qlen 1000
    link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
11: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noqueue state =
DOWN mode DEFAULT group default qlen 1000
    link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
11: veth0@veth1: <BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue sta=
te UP mode DEFAULT group default qlen 1000
    link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
11: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue s=
tate UP mode DEFAULT group default qlen 1000
    link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff

In the third line, the operational state is set by rtnl_fill_ifinfo() to 'I=
F_OPER_DOWN' because the interface is administratively down, but 'dev->oper=
state' is still 'IF_OPER_UP' as the delayed work has yet to run. That is wh=
y the interface's operational state is reported as 'IF_OPER_UP' in the next=
 line after it was put administratively up again.

The output in the fourth line would make user space believe that the interf=
ace is fully operational if only the 'IFLA_OPERSTATE' attribute is consider=
ed. This is false as the interface does not have a carrier ('LOWER_UP' is n=
ot set) at this stage.

Solve this by determining if an interface is operational solely based on th=
e presence of the 'IFF_UP' and 'IFF_LOWER_UP' bits in the 'ifi_flags'
field.

Hope it answers all your questions and we will send the new commit for net-=
next.

Thanks.

> > Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> >  tools/testing/selftests/net/forwarding/lib.sh | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/net/forwarding/lib.sh
> > b/tools/testing/selftests/net/forwarding/lib.sh
> > index 42e28c983d41..a46076b8ebdd 100644
> > --- a/tools/testing/selftests/net/forwarding/lib.sh
> > +++ b/tools/testing/selftests/net/forwarding/lib.sh
> > @@ -399,7 +399,7 @@ setup_wait_dev_with_timeout()
> >
> >  	for ((i =3D 1; i <=3D $max_iterations; ++i)); do
> >  		ip link show dev $dev up \
> > -			| grep 'state UP' &> /dev/null
> > +			| grep 'state UP' | grep 'LOWER_UP' &> /dev/null
> >  		if [[ $? -ne 0 ]]; then
> >  			sleep 1
> >  		else
> > --
> > 2.31.1
> >
