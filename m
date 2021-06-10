Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501F83A320B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhFJRaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:30:10 -0400
Received: from mail-mw2nam12on2097.outbound.protection.outlook.com ([40.107.244.97]:11781
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229935AbhFJRaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 13:30:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCCmdx3H3Ld28yLx/TRsTXZnt323+5cYDNna2DaebcIyEmTPdiKtP2r16cpxzq4zmhk9nAgdyFcm+Ezyg8fHQ0BB9RqV5EUUFDqckPt2KQKx5K5ulZe4JcTtabakdT+56B9UKmX3ciV7kkaWlwL29OhBPxeUV4L5zhs57Nl2LcW8yKuGElB+UHWEeVydunJVje0OVYWUyBRyPe5GAz30DFgI772MzXUBYBaGNm/2KnCKhLXGHucSqdQqt2w15Zq/HrzrPnoVMF5bD/1wcKtnQk6TTMnG5/mpYgDGLwsx8/Xi61DaTYm5kN7cr4LrlWqAc2hMM8dMZEta7EZTB4AeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWHIcT75HpVAhUbGlIMNhULTfCwV2qwKj/t6229lxBQ=;
 b=SBO2ZRgBH+wSS0SaCTfXqvI17QKC5oeyq64XEz8K9C5hOPjKGFYWx4rjmUq85exnZUubEJVGt+Vt+3TnPZw64RDYEK8C6ygcelFWdH3/ueexcYsoCXiwCDy9ztvpm698vMo0VebDcCMoX71+/hQqFDNlnQuZ1ikdKemRup2CXzR7jFEtNyoOKzqRfxRJeX7zJcq4DO/KRhtN/nOPuDNoZnNNSDiQC911jmEDbfFOVOnmjYcWqMyBrGfevQjAr01jYt7jkiYxecZDFJ+GPN8dOdK1eczKdFAmFak7y7xJpcLgtfM49M3e6aD67dutwl5qMAqeBp7qjzrxJKTeLsTTrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWHIcT75HpVAhUbGlIMNhULTfCwV2qwKj/t6229lxBQ=;
 b=AvUVpJjY/ITbXoC9MTNpOirq3A+ofg6DZb/t9ONp0OJfBUUKPAIaBvsm13tpzwt3vYBhSRpLeSNsjm9O7iY4o2JMjAVWHDoHZJxujhjHKD5n/7cY5HIjeXHEp5KdIhjyzGrxqdVg6WFiIGrgTJwfeEDWBl8TEUadEIf1a6tbmVM=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1950.namprd21.prod.outlook.com (2603:10b6:a03:2a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.8; Thu, 10 Jun
 2021 17:28:11 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::fcf8:a9d4:ac25:c7ce]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::fcf8:a9d4:ac25:c7ce%3]) with mapi id 15.20.4242.012; Thu, 10 Jun 2021
 17:28:11 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Dhiraj Shah <find.dhiraj@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] function mana_hwc_create_wq leaks memory
Thread-Topic: [PATCH] function mana_hwc_create_wq leaks memory
Thread-Index: AQHXXg1ojJMEZe7SE0uvKv3Tzsr7JasNfBjAgAAB/jA=
Date:   Thu, 10 Jun 2021 17:28:11 +0000
Message-ID: <BYAPR21MB127087B408352336E0A8BF2ABF359@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20210610152925.18145-1-find.dhiraj@gmail.com>
 <BYAPR21MB1270FC995760BE925179F353BF359@BYAPR21MB1270.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1270FC995760BE925179F353BF359@BYAPR21MB1270.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aa31c948-516e-4a40-bcc8-6b4f69306577;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-06-10T17:14:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35c2ed1d-b15c-40b0-765d-08d92c351eeb
x-ms-traffictypediagnostic: SJ0PR21MB1950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR21MB1950A22F1CDC98AC30680E4BBF359@SJ0PR21MB1950.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TS2Yrmv91+wAzlWrihRFHW+T2tYSPxB4NsGrPXRsCTFf8yb9UjNdTfRmB8R0yKSqqqXsuTLiBasrLKjsUaEwZhd0tKbZmv5fDnW+vadd7nkOvSNqV04bi5Fm5lVMthYl2hqE7yiB7q+H+Ug+CoPMOr5/e9NYdKxC+Oi/GH3/F4ZWmzSZVXTKuQTdP3KRQizCgkzxKMSXw1QKrIB1Z/k1ykmlP+ZeXYSEBpjbLQ5Rl2IDNSc/D/nEp0AZGUyjCwoxu6xFHBaKhSKRSA/wCfPAgCABJ8nQhqRXM1c2h5cqqg21uo+FK4CGcXqnp4Y5BOc0skyezR9yto941PCOGg5d5tPUfE3JChkbDwCl4jBfwNSUJyZo/XVy5zbY4v+Ihlgw9EQLkl+6PK4AessFhH06tS7ISG7NjgBYWxcs2l/zqFuI7Vj4euy04JmtOagY9bHgHWpnJRTYtE+0Oo61PI9xU3WURDvYEg0HGAsdLGTEAqYQbisHlnCWuddYNdcTXatyEbGE4xvoi23tlqzf/VbndZpBWoGDJmBVV2wsXxDz8voYJU8sQuHCtqiFTM9FSL0mg4bm6qaf9HweTOC0npFEIR0lIBiDYu5EzcfXYz4Scju6YAIHxMMKa3XpHSx+dUrFPoX/BcTXcwx2qlzJLRZ23w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(122000001)(4326008)(5660300002)(8676002)(76116006)(2940100002)(10290500003)(71200400001)(8990500004)(186003)(66446008)(6916009)(66946007)(64756008)(7696005)(316002)(82960400001)(82950400001)(8936002)(6506007)(54906003)(66476007)(66556008)(33656002)(9686003)(478600001)(52536014)(2906002)(86362001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vBo1Es0ojnqfKfYq0wNhsCB4ihOuW9CwODgk/ZPyzXz43AVUqJsKG3pTTbmo?=
 =?us-ascii?Q?dzNUQO3Ri79Kfr0pspbQq3ur0nFWSFqEwVOEpHrgBdivvhPLHbs8G+w9mkrj?=
 =?us-ascii?Q?h4AZjE0OLVkBh3fWilt45WGXt4UV+6ZN1btGoPsKxm44nk+Pjxoq9T96bFRS?=
 =?us-ascii?Q?dyEayA+Kynnb8eJapH++50geyWMwhF5wA43O1f5X5mfpigJ0DCdo0KFUumVN?=
 =?us-ascii?Q?8XfcVWEnmqIzSyxntDDtXRH0xMQUWqCqMSSGPjbLAhnof3+0rX/9lCHHc1hS?=
 =?us-ascii?Q?u5tXYIeoelj70PQx4S3w1u/eFLT6WUD5ceKlNrrdqAaxCyN+G6OeWEeTjP0g?=
 =?us-ascii?Q?DAYD03fzqQ2lsNWFbG+Eut0cTi8vDat62nlN9SyCcxABsFKLQ3QccYANpP3/?=
 =?us-ascii?Q?W0gAlgwSXnfVKGwtVqN+u6L0Cwv6b4Ll6O5PwMgKv4dSnvdKyblgTjc3cTcX?=
 =?us-ascii?Q?2Q6sKwP3mo8mBM2Ad5cclDR1//JEJQzJzluS56+9vsvE4hodkAPRu8x1sh9A?=
 =?us-ascii?Q?ae++7U0g1jAf9Z6tNzeTMB68LLi9ZonfIfsRcSZT/jOkZ6lww1PLgNAx+WzF?=
 =?us-ascii?Q?iEGKWfipZS33QackV9iiisCUqv384glqjZX+W1ctQ66TW1shpCRaen4R2Krx?=
 =?us-ascii?Q?SytDTOygqnV6M5/cOQDcpbIKGuWLsUClVOsYFxuW0cVFLx7jdSYiwEUI82kP?=
 =?us-ascii?Q?UtE2sjeOJWdvpJlJReWWb9lhbK2xkOnm5S4feMI7Bh5WzidYhXtQ79OUFV4R?=
 =?us-ascii?Q?xO5ghU0r4GSaDYP02szr26cgTqeTD6oDC2T90gJQidYOfC355bNeGlTm2SZ4?=
 =?us-ascii?Q?fxIYrkNK9gdbuXa0buHXSdFnT2Bhuo94nGK//Y9EcbcUGLEAacKfHJ4GMnqF?=
 =?us-ascii?Q?1E6v+2UU3WyTKKlyyLONVbEK+7Ss3VtR5GebcWSQQFNwnt837S3O1uZIgmZi?=
 =?us-ascii?Q?hYIYt/6kk5iOQZeKUCs8sm5mFR5HNDUKlPdxUqsFbqqU89mJCO0t3j4pVWjE?=
 =?us-ascii?Q?OmoU3Ifhv9AlQTq8yiNCDJdP65RJgigG12C1dVusFz7ef5K8SclzTggGfA22?=
 =?us-ascii?Q?AZo+xw/U0PmbhR59L4K574hzX05w4CxbB9LNPYD2wr1osgg99AP9aP0OEi/w?=
 =?us-ascii?Q?FKrNu7qQ35AYDv2yYxps8CnHcNthreJW3pt8T6bLm7j1JQvkCkJvVDexI/Vd?=
 =?us-ascii?Q?1uRTEDBlImcpcuncBnq7pg0q2FgQV22EfFW7+xhfrckYNOa5FlN+d7kOzbk8?=
 =?us-ascii?Q?EoOR7XjAlKikii9VX+CUznMHMA7KestrhECE383GHI1K4DVfPjOtINCpQOUc?=
 =?us-ascii?Q?Ii4vt8aVmhquu7A05V+HDNC+YPCDRhg4hFy8naR3Ac7d2DUWIjKZPrnne168?=
 =?us-ascii?Q?4b1zSHZdW3dI0yeJTgPZCwuitPcK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c2ed1d-b15c-40b0-765d-08d92c351eeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2021 17:28:11.1453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lnfhGxE3vEszAmZVC9Z3SPTH7wlc6UeLEmMkbu/UEw2R1X/9cEQo+ZcD3iIjMA0vupBlQWYea2wxeSOqsL3UUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1950
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui <decui@microsoft.com>
> Sent: Thursday, June 10, 2021 10:18 AM
> ...
> > diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > index 1a923fd99990..4aa4bda518fb 100644
> > --- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > +++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
> > @@ -501,8 +501,10 @@ static int mana_hwc_create_wq(struct
> > hw_channel_context *hwc,
> >  	*hwc_wq_ptr =3D hwc_wq;
> >  	return 0;
> >  out:
> > -	if (err)
> > +	if (err) {
>=20
> Here the 'err' must be non-zero. Can you please remove this 'if'?
>=20
> > +		kfree(queue);
> >  		mana_hwc_destroy_wq(hwc, hwc_wq);
> > +	}
> >  	return err;
> >  }
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>

Hi Dhiraj,
I checked the code again and it looks like your patch is actually
unnecessary as IMO there is no memory leak here: the 'queue'
pointer is passed to mana_hwc_destroy_wq() as hwc_wq->gdma_wq,
and is later freed in mana_gd_destroy_queue() ->
mana_gd_destroy_queue().

The 'if' test can be removed as the 'err's is always non-zero there.

Thanks,
Dexuan
