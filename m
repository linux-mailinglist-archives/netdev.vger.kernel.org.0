Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745AF6EBDC7
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 09:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDWHwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 03:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDWHwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 03:52:14 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DC3F0;
        Sun, 23 Apr 2023 00:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+0P6iAgWbr0oRgiQ4bejXX2wJ1gL4dxbw+pJCJb3WFkzQZ1j2cJnVWb3NcLxmZHZHEx3Qn2QSu4m8RN9VlHimERq0kf/gcGtE+qhfqLQYEV4WxWK8H2SThiiaFKm3aKa6I8KeCv3Bp3cUuc1nCBLTrQ/vZXGR9JThNyi9SwqVJXEFzzL3wkysrlTouhgpT1686OY26O6fZ5Yi7H9V1iOpXu186Cg+IxhNBu9KQOf1cJXkx7NYqKrV4CQErfuVsBmErVjzyx4Fq37V/EDIJfZnVMjEvvRMg1K0Qv3BpvllI609zuhZA1o3DPgnXg/pHel84dful15jK02ElyaECpPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQZhrbnw7bQwmCYnszzgXTOf3bt/bWcGOXbXD87AosA=;
 b=C466GFyY1yz0smKG62c/NMl5kQ5tLiXThP5th5mkeu0rfzp4VwVka6hlAulyd2EfgVPWvDK4KQbiXAScUWc9Sn96LfTGtube+M/WOFVcTetCeSr/L8TN784VRAjb/Yr/PqhvvA5ZiFDE3eUdxdRwCEw1R7Z/aMtFxoVR3m+ZpUbo9bPXsnZdYsXRCrTX7SW4fsGWfloOsA2poPGyr4Qi1Hj00ZLwOZNgVhz9IDCUlVL07jaJOVCsEB2+K3PkV7ij+jvPQj1wXOrAp/7vAUs0hQoYShWZmuOnimV58DduiYrePHZRR4/OzBBS31x7UpGBMRh5cRBRw/8J+6QnznHkqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQZhrbnw7bQwmCYnszzgXTOf3bt/bWcGOXbXD87AosA=;
 b=gPsQzAYzTEhnjFhN7bjDIB7wg9yEKzV2vKqt+aUkVJz6AQjk0q3An91e5ehVpp0cUnO9iiuqjaRR8QAj7bFuD/S5eciCWl7T+6SSGRuAl1yTOnN7e5bt933QIeSgAowRVI0U7LwifbjmbfErPnLkEHUpSZ1nvcCfAYDT5kXkgwc=
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by AS8PR04MB8435.eurprd04.prod.outlook.com (2603:10a6:20b:346::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Sun, 23 Apr
 2023 07:52:10 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::d2fd:ad65:a6e0:a30a%5]) with mapi id 15.20.6319.032; Sun, 23 Apr 2023
 07:52:10 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Thread-Topic: [PATCH net] virtio-net: reject small vring sizes
Thread-Index: AQHZcDeGnH5xR2OGlkuo4s6jvhNMC68uIjT9gABGFgCAAG90AIAAMSwAgAABjzCAAARBAIAABATIgAAENICAAAM4M4AAIQOAgAALfyGAABuqgIAAAQKHgAADxACACRVQMYAACvaAgAAGduU=
Date:   Sun, 23 Apr 2023 07:52:10 +0000
Message-ID: <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
References: <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230423031308-mutt-send-email-mst@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB4723:EE_|AS8PR04MB8435:EE_
x-ms-office365-filtering-correlation-id: dd6799c0-a723-4d2c-fdee-08db43cfa4a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EGZ64EhSbtX/rfkESCi3eLsFrZ8Cch35ZzqfPHplw1EJtIpqgTZbpFgCOw+IB7hWRc9oZn9qlNhBk5WiglojACMVkMMA7ocjX46Gz7LFkn1UhG6SmUUU9Ep243DIt64UnvxLWnt30lYAoG5z8f/YpHg4ffr2BFypQC1tZDVEvZ3BAygWrEwUd0vRDgSTgBn3MCO5WWAAUGF0YXNII4DhRSeRDNT5fOI2oiPMI4F4060rCrTxlXI+04PmCKkhboNBFYiNDca4VvwmP5+uUIwCvzffPhEbmW4ckIzIH54QQBfp+Qrts6WqZKNLfu7qLTRozub5bbqKH2LP78D1cXZFifRhkrRJwcGZTnm9qT6tKkQ02xC607Lj348GIyh+oyYizt0125M4HaRl3ULd8fh01oK6Ow4p6FUahM+SuA6u5IznX23AxaAgDXtijuTWbLMj6rzBMYXMY2PO+z/etlF8cFHiLpGBm8gmz6Q7AiUabRqVH9dvXO283img3kLKihjCF6zRcfqSTR7OLC/RjiLtOyGiEjNtotrp19EzvxLK71RPfxAuZYQuDCo7t4c2cLpjqn4CLjN/zUN493cnNSZkdH57xPdRPtIDWqMyTvC5A8N+rWGqfEwsFoKz7TiYHhJo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39830400003)(396003)(346002)(136003)(451199021)(41300700001)(122000001)(83380400001)(55016003)(66476007)(66556008)(66946007)(66446008)(4326008)(64756008)(91956017)(76116006)(86362001)(316002)(38100700002)(6916009)(33656002)(52536014)(54906003)(2906002)(71200400001)(478600001)(6506007)(44832011)(8676002)(186003)(8936002)(26005)(38070700005)(5660300002)(9686003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?uGNt4ivoIdBuSmkENNh7KiELX7CCmvidOX4PGXdW9Wj5rpOv1Qe05i5K?=
 =?Windows-1252?Q?s8rGu+vRGI2VLIOe0BmiXLYISwe851GaECNtKM4LUkWn5N7L3CdE5fNX?=
 =?Windows-1252?Q?sk3YxBWs5ypQM4inUAe+8/2wn82buC18xP85Kx1LI/qab1jzfVZf10m1?=
 =?Windows-1252?Q?VR66WENLFU7yyrnTYgdmouv3IPXMsMxXVXYUD+CpvJBmoj2UEB83pJ6S?=
 =?Windows-1252?Q?91AHxM3s3oYDbKeWutRpewNfq78TJytAMZSQa5WCrGyLQf4K0q1EfJLW?=
 =?Windows-1252?Q?r7vs22mZipfCv8kfPjMWDNiqGfaJuufkuV8Ja37K65Q/UxLmdbwSVRSV?=
 =?Windows-1252?Q?7a3/oP4DL7FZFngkg0mfxwbd8MK/fmY0jyXJ1ltWhoVhZtrtz63NWZV8?=
 =?Windows-1252?Q?gG39puYYRfLsOl24BHXJbYO4nmIeLqiANiYzAzCtV5XJh9y1NydXDoGZ?=
 =?Windows-1252?Q?bcNRjHM3PDRnxDNPVCTRVP5Pmj39B321itAhpuYRs5NAOqyayY9ekpLN?=
 =?Windows-1252?Q?vN46+p38aZDmJojcU378edwQHXakEgubY5ky7GB/448UlmVUM8YmjoEQ?=
 =?Windows-1252?Q?LLGfBUm8EVBN1q/x62QUxvEZQVq6w+VJyh36iF6RKCjS+KK3SSkMaPWx?=
 =?Windows-1252?Q?KqG3nhmYaaoNDbja7KpoXD7/gO+gvVVQk9JAZTULHSGRTSAV5FSs9QfT?=
 =?Windows-1252?Q?+iE4v0Prn4mzj0JYURnB4UD3BTTyJc95PxIHtp6BVLb8MFBWGH7mgcIQ?=
 =?Windows-1252?Q?BB0RK+eje3KlkrnUdpOsxaSqzfyAKbZNwBzRN4EaGeeuP0wnzkH4n/9A?=
 =?Windows-1252?Q?rTQjNOeY7D1oH/spOfArX9lioAo3lTDxRFkg4xeM1rM00uNw2NzfOzag?=
 =?Windows-1252?Q?P7R2z49ZgFNg2LvEC1IDxAeSvIoBPjdE4PyFIDf/nynpJf9ln5sQW1Tl?=
 =?Windows-1252?Q?UdwNFtm0ssrxAixyaUXamKFSMlS9KgDizfcq38y6x8EiUj4bieOznaU9?=
 =?Windows-1252?Q?3JnSJ/RW/K7J1jinF/yjAeaTrhMxzRmZbtdz6/kEzlT4Irf5PDnM59qD?=
 =?Windows-1252?Q?ealv3tDfTZNBokltrXDvGO15zyp4dtJVOA2tSKqeOnQs/ti+ZDVPBj5/?=
 =?Windows-1252?Q?xT08+X9zVdb6CekABkU4HKIEJdxTOue/7P9yyCMYnFskXoLtMCwHgUSE?=
 =?Windows-1252?Q?Pa0fFDwJsflY6JxuBpTX/evLDQ690trfsJHbbci0DKs1izvh+1nJyWUs?=
 =?Windows-1252?Q?N5tA3J53sWl2i+CaAfLwQOPcgGX67GSRBvy15kooJ7LQj53u3g90Nngx?=
 =?Windows-1252?Q?iQvRVWjd5L9uyDMIFKsZ0MciNNNeuT47OIXWogkSEvP1Vx6BjmUuIA/r?=
 =?Windows-1252?Q?K1yQgvP7ctnlmgsi9j36Z8NmUTb9HzjnRWwPfyafUbnuCkENKDXC0qo8?=
 =?Windows-1252?Q?EIc+FN3wTxFYDk7GN/iIpzGop5q8cB6KFrmyrlXoOskd1zwndL7GlDVj?=
 =?Windows-1252?Q?cJ51cMScYpvbwxBnb+3A2rJYSxZtRohzgCb5gXYsAUWY+2AesnatR65n?=
 =?Windows-1252?Q?Zl5sWJdordLRAw205RSpaw40y9vQKyzJEf7QeA/kLSKXloXPo3oTvJJV?=
 =?Windows-1252?Q?DKYYrfJY8FHLhAviPSYzoOH7QFUNbe2zfdpIkrtz1aPZwSEc5Ci+3tvk?=
 =?Windows-1252?Q?A1cDYoT/PxRRBRnXcNszfWITJoxfIt5V?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6799c0-a723-4d2c-fdee-08db43cfa4a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2023 07:52:10.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YFfRiMHHR9/OOv+Eximi+/LoxYMGmDu+4xNTSHwPGYIci9aD5muvmG46w7l9sPouXLePzh1Sr7jX3Mf57g4Mbm+f5yl2yHOLv8BWUpvHoUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8435
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hmm. I was wrong. There is no way to disable CVQ feature bit.=0A=
> =0A=
> 1. Reset the device.=0A=
> 2. Set the ACKNOWLEDGE status bit: the guest OS has notice the device.=0A=
> 3. Set the DRIVER status bit: the guest OS knows how to drive the device.=
=0A=
> 4. Read device feature bits, and write the subset of feature bits underst=
ood by the OS and driver to the=0A=
> device. During this step the driver MAY read (but MUST NOT write) the dev=
ice-specific configuration=0A=
> fields to check that it can support the device before accepting it.=0A=
> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature=
 bits after this step.=0A=
> 6. Re-read device status to ensure the FEATURES_OK bit is still set: othe=
rwise, the device does not=0A=
> support our subset of features and the device is unusable.=0A=
> 7. Perform device-specific setup, including discovery of virtqueues for t=
he device, optional per-> bus setup,=0A=
> reading and possibly writing the device=92s virtio configuration space, a=
nd population of virtqueues.=0A=
> 8. Set the DRIVER_OK status bit. At this point the device is =93live=94.=
=0A=
> =0A=
> =0A=
> So features are confirmed before find vqs.=0A=
> =0A=
> The rest of stuff can probably just be moved to after find_vqs without=0A=
> much pain.=0A=
> =0A=
Actually, I think that with a little bit of pain :)=0A=
If we use small vrings and a GRO feature bit is set, Linux will need to all=
ocate 64KB of continuous memory for every receive descriptor..=0A=
=0A=
Instead of failing probe if GRO/CVQ are set, can we just reset the device i=
f we discover small vrings and start over?=0A=
Can we remember that this device uses small vrings, and then just avoid neg=
otiating the features that we cannot support?=
