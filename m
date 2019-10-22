Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDC9E07EE
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387871AbfJVPwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:52:35 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:51206
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388734AbfJVPwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 11:52:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaACjfLCybrfcml2RplV9qmN/smui7K7UvBz3VuNfnNT6hdn+vZKzW4vZ4aJ3B7tR+EEthULcNNVXfemE3cFbGjyX2rkvzgPfCKMotFhprD3DkNMtk7WGNvh/lrZkp64SJeja0kbWmBhvSpDuRO0D/AlT8lw4eRzebgw2AHX4V++wpf9rhXVHTc/E6kD4vJatFNDg87JaedXb9toYp5smkbDFEJRm0DBYt/ddbrlrmGZaF8OOQ8HmBALNnJXw3zp1SNEhVhKyQKtr5DNYLqAOJnXM/pp4k2NTnjoBhlIPpTXqo3bHY3oBT8xgRh6vJm7LhIimaACPkw/47CpOs19rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS700TPr8V3h5vuSd7UVlqyafCZPOl5hit5RqTJbbrw=;
 b=oJDZzYNUARuqt+IuRHijOCCptUv3xCDiVNCDSfHza0KlgVBYa1tPILqwFfkzDLxuf8fo+yg8+8CiT8F67VtNACgyUMp7m2tSKqyh4ALjp1E4mHLzaet7oIQ3JTRcIzRVjtYpEHSS5emFrNaPLWSRSSONvCfuvyK6RH74aV8W0SIkoIAgwmjMzwcJidWrmaNGw60iPgfh+Qe4JBtOML3ou4JBw6LISTCmD+SzIQTcX1kTcrw+4XBplRgzIfUQjW6heIDrV7dLLywP0DSn6yR/ovpovHxGbk7O6Towh2fPoWBDvwKPGgGrTaMlK/QXQO1uNQ3lbN1WU+Bwi839JQZETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jS700TPr8V3h5vuSd7UVlqyafCZPOl5hit5RqTJbbrw=;
 b=YkIdHcGVhx8tfcfa4GQtJZQXdgcozTOji7q+f7e36ZknyTB7NI8cutuui0SPonKMrUoRs2Fdt2wdLujprIz0OOvXfigf4zJR5X3BM1TBtpb2XBSd9ZUd+cim8vsCEz6H8BLBGjfhWsGCEqks4cqIejhXaHuVKIVQmo3YdaEEG9c=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5792.eurprd05.prod.outlook.com (20.178.122.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 15:52:31 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2367.022; Tue, 22 Oct 2019
 15:52:31 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmxUYAgAAKWoA=
Date:   Tue, 22 Oct 2019 15:52:31 +0000
Message-ID: <vbflftcwzes.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022151524.GZ4321@localhost.localdomain>
In-Reply-To: <20191022151524.GZ4321@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::30) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 766f210d-481f-44a2-cdbe-08d75707d8c2
x-ms-traffictypediagnostic: VI1PR05MB5792:|VI1PR05MB5792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5792EF0656946461B403B2B6AD680@VI1PR05MB5792.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(199004)(189003)(52314003)(8676002)(86362001)(7736002)(4326008)(229853002)(6486002)(305945005)(81156014)(8936002)(81166006)(66556008)(66476007)(66946007)(6116002)(6916009)(6436002)(66446008)(6512007)(3846002)(64756008)(36756003)(6246003)(99286004)(2906002)(486006)(476003)(6506007)(11346002)(102836004)(66066001)(52116002)(2616005)(256004)(14444005)(446003)(26005)(186003)(76176011)(478600001)(54906003)(14454004)(71200400001)(71190400001)(25786009)(386003)(316002)(5660300002)(4226003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5792;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /xXTxZXATwbEvAmu+jqdmiBhzoF4sAEh/RJ/euyujhsvXmV1/g1idNCQHq9323rErH98peevd5wahxYz2Gdebi2geB033Lk4k03dVSElxGdJ9bLIOfq9JG6ZmOuWorrD4CDmiG4RWSHnSqAnMiILKgnrs+oGWiX2lh6yMZ57eYvlVPPqvo9GZKYizgFBnTn9FIN+TULrVg3yPAx7f6ySrjDZaxQYh3em8B7lYS9rJfN73uu0+Bv8eZpkZU+5Vm0EAamp7WwTXdwPVEaD0TzNwoTix/BXjdnDU6B9WSDDyGTTUeKZcmVjZqM4roLJ/7lmHMKLknbD1cE6k/Uzj6TqGrjKEcKuOwSHEv5O06bNp1ow+DnMIWoxoz2vnV0yPkE2qGZcl67mtU7T7AfH+/tdqZ5rE9KI7n2X6PNotoBZXxNVDQRilF39B4++5VkxqEh8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766f210d-481f-44a2-cdbe-08d75707d8c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 15:52:31.0956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBXERHziBiW5ifh7SljfVO6akSqrIgkzM0J2ICs2WilUQ0l0cdX5V41YYJ178Tvc6hmYqqM4An+/ZUQUcdPdjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redhat.com> =
wrote:
> On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>> - Extend actions that are used for hardware offloads with optional
>>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action flag and
>>   update affected actions to not allocate percpu counters when the flag
>>   is set.
>
> I just went over all the patches and they mostly make sense to me. So
> far the only point I'm uncertain of is the naming of the flag,
> "fast_init".  That is not clear on what it does and can be overloaded
> with other stuff later and we probably don't want that.

I intentionally named it like that because I do want to overload it with
other stuff in future, instead of adding new flag value for every single
small optimization we might come up with :)

Also, I didn't want to hardcode implementation details into UAPI that we
will have to maintain for long time after percpu allocator in kernel is
potentially replaced with something new and better (like idr is being
replaced with xarray now, for example)

Anyway, lets see what other people think. I'm open to changing it.

>
> Say, for example, we want percpu counters but to disable allocating
> the stats for hw, to make the counter in 28169abadb08 ("net/sched: Add
> hardware specific counters to TC actions") optional.
>
> So what about:
> TCA_ACT_FLAGS_NO_PERCPU_STATS
> TCA_ACT_FLAGS_NO_HW_STATS (this one to be done on a subsequent patchset, =
yes)
> ?
>
>   Marcelo
