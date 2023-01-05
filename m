Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802BE65E5CE
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjAEHG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjAEHG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:06:26 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2064.outbound.protection.outlook.com [40.107.247.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2789B51334
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 23:06:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmmemwHUOn5MUJI2oR+NwuOsRUqaaEzA3fVySCyxc0KiuxqTTWcVwYWy/ADiWHcjuGw0M2lu+SVxpg+858GIHnbGJZgVk0+7N81xcP5v+njPaZ0b+NVEkwBPW1p6rKiQmdVk9StoPs7OWF8p3H2SWOij1+UfxJUJxk63uo5T/vQrB2uSUlB4amAv3Jvh5v1jqswfJvob4HQnvwBwu4Eu2dsYsJXmYEELu+jeGlXMKRrAAQpaNW8OSLQhUAhtmVaWKMd5ZFnq4X0V1EysPgy5haKb+jO9wAeeVFVG0bcCP+D2XvWoZM3JT87sVIUb1gtrdeWLK0P2hoZYCygyiUzTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sry8pRWDZn9mXOQi604sAVaYFXDqBSVAog3Bd0wfarI=;
 b=bmnJ1d+mjzNt0r8M3c39Z+N9Mu6nNXqF4ducovt4k4ZsfBKuNbcLorCnpaR4ci/bGUOQIvS/0A75Uckwr60Zh7V5P+EyW5de58nwMltuHQZcBNTO5hF1fxTDb3tyWsf6BLWnM3mHRHkGnhB0H3hSVK69cwdk9nU4SVrwzBOf9xN5tISIVPFLU+JsM9p9DugVvSqgfK3cX259cN7QXkiBFoU8mTkAfKKXpTuwGVqe0TqiSxncQyGLaPbIGZiE8ntHxpUk7h24khQ/4ZW0VOhTlCzjt3GMV0mk+KT+KufC3+WuttCTEhhspg4uKTbyMq1Gf6t0r0s1IKti3jWFaMlqiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=piap.lukasiewicz.gov.pl; dmarc=pass action=none
 header.from=piap.pl; dkim=pass header.d=piap.pl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lukasiewiczgov.onmicrosoft.com; s=selector1-lukasiewiczgov-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sry8pRWDZn9mXOQi604sAVaYFXDqBSVAog3Bd0wfarI=;
 b=adroLzrSv8kIojhL6Xki9sImbIHOhXKZo37jyNhKd4BdMgj5nVh6sztuXC31jEUBjOVQ/g/4B3WXKyeaXKuBJplpnnwb3ZyGQEHXcz1dR7eqRQyB9Mq58ht90KDL4JSN0yqhEbp28jymcxAhvYTBi2ud5eiGE2mvzKeTOjKwvfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=piap.pl;
Received: from VI1P193MB0685.EURP193.PROD.OUTLOOK.COM (2603:10a6:800:155::18)
 by PR3P193MB1023.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 07:06:21 +0000
Received: from VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
 ([fe80::4ef7:11b6:83c3:a6d6]) by VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
 ([fe80::4ef7:11b6:83c3:a6d6%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 07:06:21 +0000
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Harald Welte <laforge@osmocom.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: hdlc: Increase maximum HDLC MTU
References: <20230104125724.3587015-1-laforge@osmocom.org>
Date:   Thu, 05 Jan 2023 08:06:19 +0100
In-Reply-To: <20230104125724.3587015-1-laforge@osmocom.org> (Harald Welte's
        message of "Wed, 4 Jan 2023 13:57:24 +0100")
Message-ID: <m3wn614g0k.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: FR2P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::18) To VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:155::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P193MB0685:EE_|PR3P193MB1023:EE_
X-MS-Office365-Filtering-Correlation-Id: 898cd10c-b013-4cc4-3d9b-08daeeeb598f
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlIjk43U9surDmELZmMfckotREA5kln5M1XZWe64Sl4rm3gHLa5BX1TKwQxtO9D3cNZ+OG8LfIbTU+QM9hN9FINSOGqZrNtQ0XWRAHWO7TkD7eNmv71R9QcngjfRQIr4iPSHxlA5ODwSDMrYSQqlq3dCsp4jnMxXRRSqnZRX9gPOZH8J/SyL7xB/dRjbIcWPVRfYEzu8r1F3b6qIEiSJZe+LPMH77At5DVRRAfjO4VktTdx3WtWWMa1Tnw35wonJiw3/5bYgDWURigMJpI8Blgfj8xLlsvy5BRw8Gj2o7bpP8ZQ+9WE1cnFe3/C9D47/+riMFzNo9GNF+qVUCLVXXurnk5p0VSzMv7R4Pcd16loNorjYvy36lmbBBCqfVaSBKgceCTj9RfOQrir1pj1gXi2z/CFCg0YkrQSbr8xPYsGoQydINYrrMrAsjIQPP2oh+TCjgFX1ddpPNyUHkF0tNp9Flbqa0go2JDQjFkwNBT1ajzi4CTCCEMgda3AxKJrGFBs3O/+qwsgu8gaPGuFzWDrrspV7taV/SGSDtAonDgpiEsZ3ExUkmYCrvj1BHtIjFn3Z6ylLCT/yo9XInYbDGWidsq3NT8gahi0ZkDUVkL9tVEoItPTSNwuYu9BBOHPnDscdrdF0qSuo+Oe7k5cKX4j2cYXEIPyEJKagxNxJbhSM7DuovG1sjDQVwu5gy4sj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P193MB0685.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199015)(83380400001)(38100700002)(38350700002)(4326008)(2906002)(83170400001)(5660300002)(66946007)(66556008)(8676002)(8936002)(66476007)(41300700001)(6512007)(6506007)(186003)(66574015)(26005)(316002)(52116002)(6916009)(786003)(6486002)(42882007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEJ5aFo5ampuWkFDNnF0V3BLWTNuaExiU0RhMU1tNm84RzVIQTlXbThRVzY2?=
 =?utf-8?B?ZGpacDZvdlNsQXpVRUt2RE1VZDM5QzZwRk1hZ1pLZG5kcHJacFVHWjRNeHQ4?=
 =?utf-8?B?TVRCNUY1MXVoNjI0Zlo5ajhHMVNBMHJ1bngvZXh3T21hQlIrTER3NlJ0M0Zy?=
 =?utf-8?B?UElncis0a2RSVzVtRDZ5aFl6TlpqNGE0K3lrNi82M3NaUmQvV2ptVW5uMnFq?=
 =?utf-8?B?eHFyUHlDMTZQRXRHSUdmcmZ1R2t5c1F0Y3c1ejd6cDdxanZncmdTWVBwaG9y?=
 =?utf-8?B?VXp5WWRaZmw4WTViQTZWRmFxTkRUQmkzZG84VGZ0cUV3ZFFLTjN1NFpjbDVz?=
 =?utf-8?B?djRYMjFpTDFLaXhnaDIvY01jdU1XR3A0dThDUUtZaENSZ0dXZGNzQUI0Sml6?=
 =?utf-8?B?TkRYd3V3K2RjZm4vWEFIdzZrQWVmZThmR3U4UmNZdjBqNnc2ZXp1L2syT2lX?=
 =?utf-8?B?MGY1MGd0Z1p4NXZESUdSa1dPa2w3eHVYZVF1aXRrWTc3UGloSGlCZzJrQm1m?=
 =?utf-8?B?Qk1sRHFSSnRLcUYxWU90ekhpUkZWNnNaNTBxTDdpZmg5NjhIbThKb2U1S3d0?=
 =?utf-8?B?NmpQZmpMSlFDZEZIVTVZU3RVeFI0QS9GUnRudlhBQXFwUVBLclUzdDBqdnJR?=
 =?utf-8?B?K0haeml3MkxzRkpNQmk3S29DbHc2MTR5dW1ROWQ3ckptbEE0V2s0am1oS200?=
 =?utf-8?B?Z2xJcXNwWDhYZXd2N3h1ZFFOdlY0WERYdnMra0x2UEovbkZ5eEY0TnpWY2dk?=
 =?utf-8?B?Zjh0OGdVb29ldE11ZmFqZnhSQmd4YXh4dHUydnZaNjRSZW1GdU5nMGJSRENO?=
 =?utf-8?B?aW5pSlJSMmx3S0tDdjVWVGxsb3ZEOWozbC9PU0NUVitkbmllSzhNcWROVjJG?=
 =?utf-8?B?VCs2T0l6U2tYZStwWGxHQk9GeEM1VE1JZXdGTXczL0ZGTDg4ZkxGWTB2WjVK?=
 =?utf-8?B?bERWc3dPc1Z2ZytTNUZJUjIxaWFxZGV3SGVBM2xFUkRUNE9ZOGFMUnZINzRn?=
 =?utf-8?B?NUQxUkNibnA0RU1vTEFBSTQ0V2RjSE1pWjlISThLMWlZd0E4eEUvejk4aHgx?=
 =?utf-8?B?K0dYV3gvUXd5aytqYUtQckZFQm1VQnpFaER2SENRb1NVOGtaL01jSlJxY1Zh?=
 =?utf-8?B?T1RTSGIvK0lyZzFDbjM4d0JWY2U1dW1QYWtsejBuRm9xRUp4dkVTWWk0NjR2?=
 =?utf-8?B?MENYTnU3cEFHV0ZPUGxnMnIrZXZGOFN1NzN1N1dsSW84eFg0MUcyMmM2NlNo?=
 =?utf-8?B?aFRrcFJ3cEptMW95dWZHYlJrems5endtd2Q3SDhyTnZCVkRMR1RIT0pKVkxw?=
 =?utf-8?B?RS8xNU1GcVdrWjE3ajJRUlA0RnVRS28wQllhTUFmckpaTzN1NUQwaGhhVG9w?=
 =?utf-8?B?eGdOUm8zb0J2eTBGZDA5NXFRWkZ0bGxiNG5TaW9IcTJickc4MkxKcS91VkIz?=
 =?utf-8?B?RTh4OUhtSWRCSjE4NXZqbzJLTUZMZFZhSVIxTVo3KzB1OElmVFVCZWVla0xw?=
 =?utf-8?B?K3dIc1F6R1pTdDYra0Q2dHRYdnJPTFYzaEJqUkNpUUtnSXIxN3l6OTU1YUpX?=
 =?utf-8?B?ak9pc25CS3VrS3ZBQ3J0cEpmV1hyaTZaQjlncTFMOTdxU1pCZjI5bEpuOXRz?=
 =?utf-8?B?aVZCc2x5MzNLVHZvVGJCUnU1L2hjWjVBRUU0L3dwb3FMQlpJTlJNOStYdG1q?=
 =?utf-8?B?R09Fd2R2R1dxeFZjN3NTa3FKdmZXdmZscDNVZjJSc0QvWlFERE5qdU56dmxR?=
 =?utf-8?B?YlJ2cVJnc2VEa1FTaG42ME9NNnI5WFc3U2xrWDhmSEUvZGtYOHU0Y1hCSll2?=
 =?utf-8?B?Z1RDKzU4ejUrd2FPQ1JVYmRKS29RdWpGQ2hIelVZMGU3UHpJTTB0UWlld2xO?=
 =?utf-8?B?ZzFKZGFRNHZza3hOQ09jVnF5S290Y3A3bG5abzUrb0FVc3ArNi9Fb0FHcm5Y?=
 =?utf-8?B?TEs1OVhLZ3NRTjBGZzVKZVZTaVlCbkpkRWJOdmVzSFJCMThuQndaTTdYdHgy?=
 =?utf-8?B?VkZkazkzRjBkb1BOTnZ1Rk5GRnBOYnd1eWcrTERBaGUyTWVRSWRZbWhKZFcz?=
 =?utf-8?B?TnVWUDlXWDFhb3E1aFdNSFE2VTZPQWpRWFd3ejJDU2FEZi9zb0RJa2Q0M05s?=
 =?utf-8?B?R1JmWWhET054T3pTK3dXQS9OTVZoYyt0L3J5dWdkQTQ1ZnB4WWo4UmFYQy9q?=
 =?utf-8?Q?QA7/f6aYiJkMlm/lgRDWnFNxYfTG7J3nLnS2HtwCd/tU?=
X-OriginatorOrg: piap.pl
X-MS-Exchange-CrossTenant-Network-Message-Id: 898cd10c-b013-4cc4-3d9b-08daeeeb598f
X-MS-Exchange-CrossTenant-AuthSource: VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 07:06:21.8173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3e05b101-c6fe-47e5-82e1-c6a410bb95c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNy+L4RvF69lVojq54tWCRASy0AFmmXPhzZ03Ce6DZrH6k+wMyofwnxqk+e2BBwmNM9t6tXupaIIgdhT22jTTAr6KG3DZHGA8M/rB0LaCSGAjcDd9HgDs8YecL9aKRJROpNewt8jM8dAfrGrD5vGSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB1023
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Harald,

Andrew is right. The default setting makes sure the packets fit into
regular Ethernet on the other side of the link (which is, or was, the
most common situation). I guess the mtu could be set trivially to 1500
with the max being 1600 or 16k or whatever.

Now there is a second thing, the HDLC_MAX_MRU (which is set to 1600).
This is the (fixed) size of RX (and TX) memory buffers on certain old
cards (some of whom are ISA and maybe even use 8-bit XT-BUS transfer
mode). I guess it doesn't concern you directly, but the MTU on those
cards must be kept at most at HDLC_MAX_MRU - max size of the headers
(=3D 10 + 14 + 4 or so, maybe more) or the packets generated by the IP
stack won't go out correctly.

Harald Welte <laforge@osmocom.org> writes:

> +/* FRF 1.2 states the information field should be 1600 bytes. So in case=
 of
> + * a 4-byte header of Q.922, this results in a MTU of 1604 bytes */
> +#define HDLC_MAX_MTU 1604	/* as required for FR network (e.g.
> carrying GPRS-NS) */

I think the "FR information field" is the data portion, without 2-byte
Q.922 address, and without the 2-byte frame check sequence, but
including e.g. UI and NLPID. This means, in the simplest case of IPv4/v6,
max MTU of 1598 bytes (by default), and less than that with 802.1q
(8-byte "snap" DLCI header format + 14-byte bridged Ethernet header +
4 byte .1q header). This was never very straightforward.

I think maybe we change HDLC_MAX_MRU from 1600 to 1602 (2 bytes for the
Q.922 address and 1600 for the "FR information field"), this shouldn't
break anything and would IMHO make the code compliant with the FRF 1.2.

Then we drop the HDLC_MAX_MTU completely and use ETH_MAX_MTU (which is
0xFFFF) for dev->max_mtu instead. Devices using fixed buffer sizes
should override this to, I guess, the limit - 10 - 14 - 4.
For dev->mtu we could, by default, use ETH_DATA_LEN which is 1500 bytes.
Also the assignments in fr_add_pvc() should be changed to account for
the hdlcX master device parameters.

What do you think?
--=20
Krzysztof "Chris" Ha=C5=82asa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
