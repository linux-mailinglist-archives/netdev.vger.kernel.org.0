Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7284B39FCE4
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhFHQ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:56:00 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:52705
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231278AbhFHQ4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 12:56:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1pOylfOqLf3PA68crUtSglyA2hnK5O/rTfAMnUutb3dX2458YT5c8eK9QGP7W2Z06agsSFH9ryS8f0Ik751Wp81Aoz1JoOdvAIBFgsvIWUTYveeZVR+oBNbs7QuNbyBajTGmPzYbdHl+7/BrgH1BJLdlZQ0jKBRFxfzwJbTodjl2TKXPwopeYMoFmp707WEg+XA7r9N4dq3gyn0isjXY/0SlY1bUdFwD/BcXIasyONn8gXl6ZYFyZHTliXtHe4upcabRaRbBs/PApJ8GYVj7gL72xLNyPT0BHf+Pxrib/rtZCzZfJ8PIdx40W+pVt8VgDmgoI9tVoBEuD/VoW6y+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxLHj/qlJJi9iZ6dSsYwIt+D4B9oKYvHQxitr4pPS44=;
 b=hIn5Iwy0lpawGuQlEsl97XHHcuAfim5pE4MJgQFu++/+PCdx1baXiENbR86lmIdagC3j2sCsQBecirdBsc2YS6nfeGwBT8mzEW4Eo81Cwo19a54rOSBDD13GzARI/YwKTpsZeRfT5WJKX2eZEF19oSaZ81l1iZW5g7HTj0j8x3RiyUEBMwWtkmPsAkFtVkpTf5rcgSw2I18hI5BQZZlS9C12/o5wzdDcnn87lNrQoSLCqjMUld+2J9H0HlwY0MAOQk8/QOWVKalWbg2KahWD741CvrdS2tu2jdcHk7yD4QD0PmQ8LMlJhoP4J4cZBAzfyDLrJYVd6sgA9nhqhjx0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxLHj/qlJJi9iZ6dSsYwIt+D4B9oKYvHQxitr4pPS44=;
 b=O1kGvN2FAO8zPOf6NB/DRzf405ky5gj/OJSXiM1xZKW+QcDEFtvAJY9xGlXvhN34wL1ad1H0tUKjV8WBN95v92IkYdTBlJxPIfHvVM00tz1CBGcu6hx2juuICWx3BATpvPE+cvuAaGgDKC1qHCG+ocywkNSk2g54vjTwJcxcnYTQYiCQhrWqry2qIOySs98qgMOSCFxkLu+jeeK2FJpZT916BByMjbVrKYK5y+QS0kjSL1rjzQli9bNrh7MtCnrHKC3LH+Anl8m0btnnDMvq0tFcblEsKY6syJxiSCCr/luhmbevPFbAFQAPRNc16kPDRXYf+5Zu8ljQQbzDbbbE9A==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5450.namprd12.prod.outlook.com (2603:10b6:510:e8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 16:54:06 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 16:54:06 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: RE: [PATCH net-next 3/4] rtnetlink: fill IFLA_PARENT_DEV_NAME on link
 dump
Thread-Topic: [PATCH net-next 3/4] rtnetlink: fill IFLA_PARENT_DEV_NAME on
 link dump
Thread-Index: AQHXXG5hvlR+yAncTUalCsHKBeaUlasKU3Dw
Date:   Tue, 8 Jun 2021 16:54:06 +0000
Message-ID: <PH0PR12MB5481A464F99D1BAD60006AFEDC379@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
 <1623161227-29930-3-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1623161227-29930-3-git-send-email-loic.poulain@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a4f31e7-99a1-4561-29d6-08d92a9e0720
x-ms-traffictypediagnostic: PH0PR12MB5450:
x-microsoft-antispam-prvs: <PH0PR12MB5450AE650A8FEFA9954547A5DC379@PH0PR12MB5450.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:121;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zHbvDYRZDVa2k/VewfVALvzG8pVfqhx7aFcc5C9NcTFhQOLhsgnyMlTUHa0YWzgh4fg01aknSIaVkWogYt6K76CFkFQnkLxhIdPWg04BjY2ngJWNMvEDqM6YPF7pi86kfCBdjKDnyviE9EKYCwtNsf5s5+D9rTi58/RMDGaAJSXAvQQPpYMT57CP5VmVbUxGh1l/e6rBgsOBYeJMVzxTOjcJcpgkJi2msJCRgJJGqzhYYvLzIaQCFqVhRYT/taRf2VN7qSXgWHbo4U9LSptWQ+mw6UqNzmqXpAVuv8qa9tV1r7IdEeKjA5KlB9iZyC5ueU2AYvKwaZbure0G2Bpd3HLy0PD6ba1WV1PGNbB0p8MDGdTzQzZs6aOagFy+CxhwGOw5tU3q7nVGvtzJZ4qUJIdQ2WJKlc738eh+UpX0r1g2L/6llac9LMmOM1gW9skM9wq+DUEJIG4+ZUE5vpJvFHB3SAHrA+ObseLhz1m/aI/PG30G3qvItIan27N6gNPZZGLd1MCdVtV9x9PyMRsUFimx6IIlRzi5dfy98bbbeRWUhdGAQqnUSfj7P8PfjfV5n1sFkx7nl05w+81m2NPwX92e7Uc8Uq8daCaenOQ6kcA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(5660300002)(4326008)(55016002)(110136005)(52536014)(54906003)(7696005)(86362001)(316002)(6506007)(2906002)(83380400001)(71200400001)(9686003)(186003)(26005)(122000001)(33656002)(8676002)(38100700002)(66946007)(478600001)(8936002)(76116006)(66476007)(64756008)(66446008)(66556008)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: HVUtPz9+9gIhY/Gxa73GmboGBDtoiaTFv7LlbtaZQWpNqk9sxYBnmUClYjhJ2lpGaV9TLQR6Ohc9sgrpM2dfWWYZzB+A96bQ853QW6EDKr3m5XQ95YfGoq7S4gtKNH/BiPFy9IcJmLHz30JwnMqvQonqw1cAFPo6AtTlDWYuRFoGaJt3cfXsmhHEMZ3rCY1fxx7Bp7YmNp88vNmYFNyDqJX8sTLrKoy0Mk5pC+vjUkS0wxR1ugLrPg6W7UZyzcwopgXQxsYfkzJSu40ResHMrxlivA6z+GtdFwum4e35Tkq2RRNZQAbhsRb/xhMEeGM6zubiJd05K+oCQXZdXJgs9nALwceoMCN8uMnQvacCwl9pYu+bzgm5q1LfR5w3eeridhs0yiYWA15cZLAcqZvDxaaKqqDSVl7OFFGBxmFwzqeiV4FO5VTNlqnr6IUm6r1R+UE/nyQrW95FTLkPbw3eK6myYImLd68oIDXiNFnLAHnmLxO0rzNfsBjm/jBqN5NxD7EVVDPG42ExX/y7nhId74ZbpYlljeRe7GgZCkgjLTDOTxsGIT0pk9aFanHEo0COEH9gCL+oSCExnUciWQtwPli3JjAmGs4gbWduZZq7b3Oog7u1ovsNegubc8rChiNOZnK5DUaVw/TPyuLQR/Y4TmJVnQCEvybv42xdfVrg9WmxK9joiGZgxwHSxwbAnZipUWAZur8erwBXMXjArnN5RyISGeup+PSMAA3aRmuAjYGDMLEto1IZSldEM2uq7x/F
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4f31e7-99a1-4561-29d6-08d92a9e0720
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 16:54:06.1527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7iyThmyeUjYA4V/xc5oma00XSBC2x1aqR81YK8XJW1O62Iv4Gnp9V68wjkHxYXtDvJnaoj294o9ioOTitmK7qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5450
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Loic Poulain <loic.poulain@linaro.org>
> Sent: Tuesday, June 8, 2021 7:37 PM
>=20
> From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>=20
> Return a parent device using the FLA_PARENT_DEV_NAME attribute during
> links dump. This should help a user figure out which links belong to a
> particular HW device. E.g. what data channels exists on a specific WWAN
> modem.
>=20
Please add the output sample in the commit message, for this additional fie=
ld possibly for a more common netdevice of a pci device or some other one.

> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
>  net/core/rtnetlink.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c index 56ac16a..1=
20887c
> 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1819,6 +1819,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>  	if (rtnl_fill_prop_list(skb, dev))
>  		goto nla_put_failure;
>=20
> +	if (dev->dev.parent &&
> +	    nla_put_string(skb, IFLA_PARENT_DEV_NAME,
> +			   dev_name(dev->dev.parent)))
> +		goto nla_put_failure;
> +
A device name along with device bus establishes a unique identity in the sy=
stem.
Hence you should add IFLA_PARENT_DEV_BUS_NAME and return it optionally if t=
he device is on a bus.
If (dev->dev.parent->bus)
 return parent->bus->name string.

>  	nlmsg_end(skb, nlh);
>  	return 0;
>=20
> --
> 2.7.4

