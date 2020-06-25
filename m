Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3089620A554
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406409AbgFYS55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:57:57 -0400
Received: from mail-mw2nam10on2113.outbound.protection.outlook.com ([40.107.94.113]:42929
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406110AbgFYS5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 14:57:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJove7v5tmmGMn4RFJGJ4EPXw/GhEBSgABlZ6Z7G1UKrjnZboSaQ8UiBOOjmwgzt26qgMuIdxlDh4fBZeopMZR3OK6PfYfLTai7FHY51ghu1izLpLlKNJHBtvqDK+zBxc9yj2eiwZ1LoHMQe84lT5E1oWH3jv3+VuPLqTlXnbruGDvHZD6eJxENYJWkC05ZfY9L1jabdpbJJGiJwtcVk336Fe0wT6yYk8CYJEOp5WJeDVtPeg9+zGUR0h7AoS81WPXsv5S4sy4vqanvZHVePUfmqD6IhqIIrwE2yY+q+c+7k6iqtCNzGXqEUL17vTLOq3hOHPF02rLQh1fa8yS+g6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PX8gpwdqa6XLfdsDog8IV9acID7i4CFhz3jOK+jl94=;
 b=iLfAPfBNKV0EURIuvkYvGXEF/PyyvDE8I76l1n8IU/C/3bRBjbl5vAdBmiP7WKdZhD9LB8yYOXy2Q7jCacAR/yiBZ3SsfrQoRrdgAoUQS3v2dlYh62A3AUlZTf1XU1rv/DNnVEpLxH9YkPiGG1I6JQ5NgcslZ41Sw5JVBE5jo360AmXnkS1Da7VlkfpKTetM7RTZzvu1l9I6XYSkgwf+E0iKf/S+cTcZcOQapiANWGJnRukeMcTYVxc/fx0jNeVZWeckd3w+fOECTf6lYmyq0ltd3YRoqUNF9XzB7meiHcsuIS+0o4A186UNrQm/3pIlAbAqfYiwgEf0iJOSCZ1KMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PX8gpwdqa6XLfdsDog8IV9acID7i4CFhz3jOK+jl94=;
 b=Q0h4au9prFVmCzhC2tRR+dOAKMdCIHTCjUKOsnLU3NaoL+rhhh3zayLwNK6ngJXNPL5muNEXMOZ4I6BY0mQPvUC+XNNiTPZVDdea5oyWv6dV4hBqJb8D+kck9+6PrTNSL/BIdEMyuWJVg8ts0331hHCOF27R/QEwp94vXzBUgJw=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB0980.namprd21.prod.outlook.com
 (2603:10b6:207:36::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.2; Thu, 25 Jun
 2020 18:57:51 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::421:be5d:ef2e:26d2]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::421:be5d:ef2e:26d2%4]) with mapi id 15.20.3153.005; Thu, 25 Jun 2020
 18:57:51 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andres Beltran <lkmlabelt@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 3/3] hv_netvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
Thread-Topic: [PATCH 3/3] hv_netvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
Thread-Index: AQHWSwaaylt6KwhZwEW4/H3wlYNgFqjprKTQ
Date:   Thu, 25 Jun 2020 18:57:51 +0000
Message-ID: <BL0PR2101MB09309FC4BB95D48026DEE99BCA920@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200625153723.8428-1-lkmlabelt@gmail.com>
 <20200625153723.8428-4-lkmlabelt@gmail.com>
In-Reply-To: <20200625153723.8428-4-lkmlabelt@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-06-25T18:57:49Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c0a1711f-605f-48fd-b5c0-1721e5d1d095;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [96.61.83.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72eb1272-18c6-4b25-64d3-08d81939a8fc
x-ms-traffictypediagnostic: BL0PR2101MB0980:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB098060C47C6BFD776D2833A5CA920@BL0PR2101MB0980.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3nWHGcgSiPzSXGFxLpV8opm2WBTX1ZY9e7qbw9bTuLYhJRj1nVqCyu0MzwORr+l7HQnja6xSo6ovCs0q2ni/+LI/yWx2XD/PZ1+BxwHD6Y+vILMFRFaygm23P7LzGl42/N86H51OVpF791WLpCDj8HKLfqLKwMj4kCSLQrscD9IC8Uad6NOkK3i8rpjF+4fkuFzLKVsbZM0zkE+8JfOH3gPYmPBk/QcvAA4fs4gvptqpTfFAkk8X8TAWBfdxQqqV6mm7p3KDZJQLjOBpMC+6knbg+TMw6rUBdpn4TH/iQr+qQe5XMCSOaAsehDOpQrwTwg7NlPpOfl32zJZOKyo4QA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(10290500003)(82950400001)(82960400001)(71200400001)(33656002)(66476007)(316002)(66946007)(76116006)(8936002)(83380400001)(6506007)(8990500004)(186003)(53546011)(26005)(52536014)(110136005)(8676002)(2906002)(54906003)(86362001)(64756008)(66446008)(66556008)(478600001)(5660300002)(9686003)(4326008)(55016002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GgV6NCQO3UkSisoATN4cxzmlsNijHE0KpymkWgX6K3j0WDYlIBRXKvTsDGBUfL3g2Cpgx0tiVsy+DqoFmw0EPkAJISqwVkLv/cxaoHZJ/jJ86UeKVrpcBgheljQhcid/xOwauEpbtkZozNElN2KFvQz82snPNEpI7a/SUrFaWgOheMBK37YFIAQehu8drwzGs0hq9f37e1ON39eUEc9tS8bYnhOfNVn+GjT+rlYW4rv03+jAzeWPOijEvnyDcUYi19sKoahOGVwgU8P3P7gI/1KZCOdnO68eIT3ThZdhHpf9loTL/pCEiOS6F4VGQdW95EgTPWVJcSidPCqab1tJJyIIf4JvDt8a3laqH/lxwc54GdaLPemY0I21FLKKgbGzv85Ws9ZKZsv87iN+rE1fNPWCQ0knGOa2Bvt00VHBC7i1eYFccBPct8H/jiZkM8N5GtkNd6UO5O9Wck2+oZzDzCKPGEfV0I8cEqeydf6aTx8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72eb1272-18c6-4b25-64d3-08d81939a8fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 18:57:51.0769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NU6++Bet83dBqMy+Ppwd+m0rA2P7bgmkpxoWf7YwqMAxUSplenxo0P4DitVZBbVyiXUXasy5Sb9TT+czumeGFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0980
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andres Beltran <lkmlabelt@gmail.com>
> Sent: Thursday, June 25, 2020 11:37 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> wei.liu@kernel.org
> Cc: linux-hyperv@vger.kernel.org; linux-kernel@vger.kernel.org; Michael
> Kelley <mikelley@microsoft.com>; parri.andrea@gmail.com; Andres Beltran
> <lkmlabelt@gmail.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: [PATCH 3/3] hv_netvsc: Use vmbus_requestor to generate transacti=
on
> IDs for VMBus hardening
>=20
> Currently, pointers to guest memory are passed to Hyper-V as
> transaction IDs in netvsc. In the face of errors or malicious
> behavior in Hyper-V, netvsc should not expose or trust the transaction
> IDs returned by Hyper-V to be valid guest memory addresses. Instead,
> use small integers generated by vmbus_requestor as requests
> (transaction) IDs.
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   | 10 +++++
>  drivers/net/hyperv/netvsc.c       | 75 +++++++++++++++++++++++++------
>  drivers/net/hyperv/rndis_filter.c |  1 +
>  include/linux/hyperv.h            |  1 +
>  4 files changed, 73 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_=
net.h
> index abda736e7c7d..14735c98e798 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -847,6 +847,16 @@ struct nvsp_message {
>=20
>  #define NETVSC_XDP_HDRM 256
>=20
> +#define NETVSC_MIN_OUT_MSG_SIZE (sizeof(struct vmpacket_descriptor) + \
> +				 sizeof(struct nvsp_message))
> +#define NETVSC_MIN_IN_MSG_SIZE sizeof(struct vmpacket_descriptor)
> +
> +/* Estimated requestor size:
> + * out_ring_size/min_out_msg_size + in_ring_size/min_in_msg_size
> + */
> +#define NETVSC_RQSTOR_SIZE (netvsc_ring_bytes /
> NETVSC_MIN_OUT_MSG_SIZE + \
> +			    netvsc_ring_bytes / NETVSC_MIN_IN_MSG_SIZE)

Please make the variable as the macro parameter for readability:
#define NETVSC_RQSTOR_SIZE(ringbytes) (ringbytes / NETVSC_MIN_OUT_MSG_SIZE =
...

Then put the actual variable name when you use the macro.

Thanks,
- Haiyang

