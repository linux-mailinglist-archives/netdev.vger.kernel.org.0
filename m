Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B293C59D1B7
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbiHWHJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbiHWHJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:09:41 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE29561B0D;
        Tue, 23 Aug 2022 00:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxN4WIta4n5Ao+6UlAvyfmCZx94keAWVza2mhD72yUB1+na1y5OfImI8xjNEP/9a8HD3ZbxGdOT7lZx1ss95TRHpqzBwPkMV84YTZ+o4ngjRKZBLj1gQFVDPIOV0c6MelBVGElfULY6aXzbK0VswfwdKaIVJvdInjIOCCpgz7yfdXhm9Tyk0/CUU7/1oaQ2TuJ9GOb3DGqS65ZnTo3BnlxaTA0OW454Cd9EHkLv1F5tvXkW+G1+0ccrRdwDJQQQipnBZb0CXne7FWgWFIav1smlkThLmeJgflEoeTwPGUhKgluDgMkh7Z18Ap2rrnr3QKRFxz/V0kBBZ41BFbF1mrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=az2HdoyG85YfEqGnT6FuQVIJiIp4n5HRHLNqEBg6cuo=;
 b=BePG3p+SqwUAPU6tpl75OCye2Fs5vC/9/Jv6M4AD91Y5ScqgwE2m11JNHLPsmjd9gAH5mpY5Nl27vBADVAO35yj3yEpoypQpf5B0AMjEE/UN3SFcqh1w6fPFz4MJxBuQ0ORri02fnRIEtCDkFcr2wFeq0vntoqD4zt/PnflvHKccWtMA437cvKVGslgeTIX6B0JZRVOQyMfdGZob7Z9OEubgDuKz2AJNP2IhggezoURFio1tNGHP+pZCF2fUn8UH4pqKf8EkYaAQmLRhayvXCTHtKoygw9zUjlSYOarpD5Kz+eCOaViV/Ni3W1oVKtZY1Jz1C8O6j9nWBEhHni3S3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=piap.lukasiewicz.gov.pl; dmarc=pass action=none
 header.from=piap.pl; dkim=pass header.d=piap.pl; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lukasiewiczgov.onmicrosoft.com; s=selector1-lukasiewiczgov-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az2HdoyG85YfEqGnT6FuQVIJiIp4n5HRHLNqEBg6cuo=;
 b=qtoW7AS+ylwbUP+asfW+gUbot18lKwY94X+CgHL31DXSqF1J9jP7RjRH9qyxpU9Z7e6MJChlaDPB6Wtnvsw1zTX9QwdobvJ9LZHNlEOgzhyRekhRUQ2ThAA2jTde+MZxhVH7nb0dDfTk6GWggijhCy+SPnKRYRtLYGeVEEXREyo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=piap.pl;
Received: from VI1P193MB0685.EURP193.PROD.OUTLOOK.COM (2603:10a6:800:155::18)
 by GV1P193MB2021.EURP193.PROD.OUTLOOK.COM (2603:10a6:150:2b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Tue, 23 Aug
 2022 07:09:35 +0000
Received: from VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
 ([fe80::a5b7:27f6:4886:a478]) by VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
 ([fe80::a5b7:27f6:4886:a478%4]) with mapi id 15.20.5546.019; Tue, 23 Aug 2022
 07:09:35 +0000
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: move from strlcpy with unused retval to strscpy
References: <20220818210050.7108-1-wsa+renesas@sang-engineering.com>
Date:   Tue, 23 Aug 2022 09:09:33 +0200
In-Reply-To: <20220818210050.7108-1-wsa+renesas@sang-engineering.com> (Wolfram
        Sang's message of "Thu, 18 Aug 2022 23:00:34 +0200")
Message-ID: <m34jy38mhe.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: FR0P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::6) To VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:155::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59930e7b-ee3a-4950-ce0b-08da84d66f15
X-MS-TrafficTypeDiagnostic: GV1P193MB2021:EE_
X-MS-Exchange-AtpMessageProperties: SA|SL
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUHtcXhZ1Zof1wtfF/MePrgpJyWHjrISef2o3EugTuC8C5ais44+avjcH1OePG6smrAgcPzzGp+l8TicQ+GBbnuGTBwvTaOg/cSEQpPFOgS9mg/fVOJx8uEVdNwmfUn0deNH0wfIK5mk2yHFMc8If392sNvt9XfWgNTA6RHGqNT03kdaOsP9XpITe50BsJ/47wgPX4opOkY6ogzJ/NeqK6W7kXrR3maoj5IIiL6bWrLes1vizboP9rcp/1RSV4S5AhHZXJW+XBJg99pP7TfZnVniMMIeAUx3oidtuKG2sNNKa5IrSQ10fcHDF/rSP9pj/lxmuN4XpB6NIZ5RtiLOFBj8R8Fs1zNQVWJydc4k/JwME9SgD5p0mqrJT5askVBoOkliyyW+oZV4Qm5bTCMbyw+lwxcSGqQM2s5gepJpmihmwi06KUbInT6LtYIuHWqzJASjupc8mPb197AT1Yx/9deeZAPdBUX3QL9Piqau+7W8Q1S2Z5kbKUptFDM1igu+8z+BbwBMSSWbTtbr6mr/nRu8x0Sovo87UJ7iFg1Gmn5/8BU1zd4IdKCK+uXZZEW0GsUKogWD9Zik8SsKowRPq2jbpbnrTiVomMYMah2JF1VKoKyKAJBZOaRcmzSaizLo8eQ3F5XyCy6SoIux4vBbTvpQgcXx0YTDhgXkWWJnpWf384Ci91OL5bgXV7IPsPcsxIQQcNpq3gdxPst3dWwQbNiwAhj46a2MjUm9ixGBPrTdfxImX66QuPOlRpdLnT+EhxhgAZjwgvER+IDKduyI8ad5jDfsGX6AqP2iNBtipPE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P193MB0685.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39850400004)(136003)(366004)(346002)(52116002)(8936002)(6506007)(26005)(6512007)(5660300002)(4326008)(66556008)(8676002)(66476007)(66946007)(316002)(786003)(2906002)(38350700002)(38100700002)(186003)(42882007)(478600001)(83170400001)(6486002)(41300700001)(156123004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEhlTVFhK2hWWmFoRzlFb05QRjRzUXVCTTgzT25WYWdQZEg2ZDZuK2hOazd0?=
 =?utf-8?B?TUVMMVJ2YkMwR3lQSk53MkNWMDhpZHZjQ1dCRFllOGxKbDJWdnJtWjA0ejlI?=
 =?utf-8?B?Wm5xZkFpMGs0T3Q2OW9NREhxcjkyYXRoZEtaamFaano2bE9RL0UzVTEyV3hE?=
 =?utf-8?B?YjVKWEo4dE5GRlJGTWFZN01pZi9sT2ZNbE1nLzNmcFBiTFNxTXJEc3M1NXlI?=
 =?utf-8?B?Q1oxRFh2T3I5QjdOQWExOThvWGZoU2VRcVkxNGlXR295d0Q2K0hOYlpqWm1q?=
 =?utf-8?B?OUlkd0Z5QytsRDExZkdiMy9yVFhGQmZ5bG1KM1FHZVJYRHloc3hNQzR2Y2dm?=
 =?utf-8?B?SWhCY1AvQ3JQZm4xV1pOWHBzY04xUENFcWNWQ0FTcnZ0RGdlQXhNZldNRCt2?=
 =?utf-8?B?ZnBTejRFZnBpd2s5VVZlL0xZWjEvOTVGY1ZJUi9DZFNMcDQ5SE5QaUhlZC9Z?=
 =?utf-8?B?b2c5OWc4TDBiYzR2R1RmMm9QOWdlVUlGUVp2Wmp6UHlKZFZkc1lFVURYdW5v?=
 =?utf-8?B?QXh1TTBPQnZlWmZtV3VsS0x1NDF1b3hqV3NnTmV4UFRSdUlJc2pubGRIRVJU?=
 =?utf-8?B?WWhoZG82RExxSU5PSENSSVV3eXBaMDMyMG96dXEvNjhEYk4rdTBBdStVandL?=
 =?utf-8?B?MEhWeWhObkZXUi9sMlNUcU5uZTRKUTNOdENhalppczQ0YXpuTlR3R3BSYUp1?=
 =?utf-8?B?MTF0MmZMWjdUK2NHMUVmcDlSb2lwQktHR3NtMFFodHc4MWV0bHlrODJKT1Fr?=
 =?utf-8?B?cFJCVC84RDVSMzM2MXJrdDZ2a2xYRkYyNlMyY2Q3RmszQkhaL2E3c253NW5i?=
 =?utf-8?B?aWN6c1d3QkJxSC9uTHhGZVNQcnVPektVSVdSeWtVMVZ1czd3OVI3c1Zza0pi?=
 =?utf-8?B?RHgrdXUvd1BiWFI2U0dFRS90YTN0bFRzQTRNZEFGZ1VSN0xtUS9JQTIrYTBp?=
 =?utf-8?B?T2tSUlNMWHJjOU9SeWh6bTlkenN3UEo5QnJYZUs5dm1SRHp5Smp6ODVCQUJI?=
 =?utf-8?B?MCttNkNtSzVoNDRZejhEbEtOMHJlS29adEhpOERIUzZZQnIwZVM2clMxVU0v?=
 =?utf-8?B?VFFabDhtT0Ztdkp0aGU2U0hHU0h5amZlcml5dXBYcEtFWXBJTm5VR2ZVbkZJ?=
 =?utf-8?B?Z0lxN2pONzE3NDBDV0JhTzBiZEZuSXg2ZkppR0lMOENYS3Q5VUlJMFdrYnFr?=
 =?utf-8?B?WDBrZ0VTZDNsOCt2M2l4d1ZKbWdwRE55ZXdQN2RVZ0RHZ2Rvb2FkZkQ4eGdx?=
 =?utf-8?B?MzZkNy9zWEY0MndBdE5pM0x5SG9mZHlYbXR2UlRaSHQ2aUJEUlE0MkVQUkJ4?=
 =?utf-8?B?S2pXVmdwVTlwcElDQnVLNkdjSGV0bkJTdFNoUFlOSjhBMkhDM1VqWEVPRGQ0?=
 =?utf-8?B?dVgra2JIZWdDT250OXd0QVVkSVN4M2RFTFBMdytFWk1hZmk3RUphQnZRY2Rx?=
 =?utf-8?B?U3E3UnB2ODRiNmF1TjlJYWIzK2NhcEtjZkN4RUR6TWlNVXN4RTdEc1F6NjFs?=
 =?utf-8?B?QkJLU2Fjenl4SGhabGk1MGNXWXB3eDNUZGRLVkQrN1YzSVd4M2dZa3BiUzVV?=
 =?utf-8?B?UUdoMmdaTVNCajRRNG03QmlLNGJveERFdmFlNjZKcm9RaCtNdW84MElEcXBW?=
 =?utf-8?B?VjZEa2luYldCK3BFRURsWXlsSmxDSzFSOFZERDdtZmdpOW11Q0ppYitIdkpo?=
 =?utf-8?B?eDdYcFQrSjJ1cFBiM2xKQ2k1ZENwdGxoN25pRkViUEZKR3BHYUR4YWlLbnBE?=
 =?utf-8?B?L3J3R0RhYkJPb3c3QnRiN3V0VmYzMXBTWnNQR1FJTXNhZlpBVC9xcFc3a0dI?=
 =?utf-8?B?RUdqUmY4UEhmUXc4d0haSjY5OVFNQU51K0p6Q0JJQ0NLRHovS1RYTDhiVUt0?=
 =?utf-8?B?QUNHTVRNWE1MQnZRL25NN0QvV25VQ2VHQmhHZTE0L0h1TkdwU2xCUSs3TCtn?=
 =?utf-8?B?Mmp2RGVqVzduYlI3bHptR3l2N0hhbWdoRWtkUkJwZ1hWamVEYTRBTDBudWZ5?=
 =?utf-8?B?ZCtiZHIveXVRSklxQnEycGFoZHRzWUozcS82L2NOYmd4SlR3eWprSXhSK0tN?=
 =?utf-8?B?eFJjRXdta3hoVUdERVVZc0o0aCs5NGdQdXpXWDJPQ3hoYzQzdlRpMzVOSFcx?=
 =?utf-8?B?bTZlVndsdHIwK045d09xY3d0RkJVMzdKdVVWVnlsVExKMGpCM3F4TG1FRXZG?=
 =?utf-8?Q?E0+OMN/ox+LmKx6lzz6asNf1DcaDr0DbGPFwVX/1gPo7?=
X-OriginatorOrg: piap.pl
X-MS-Exchange-CrossTenant-Network-Message-Id: 59930e7b-ee3a-4950-ce0b-08da84d66f15
X-MS-Exchange-CrossTenant-AuthSource: VI1P193MB0685.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 07:09:34.9007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3e05b101-c6fe-47e5-82e1-c6a410bb95c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OEiIMCAW++QoJKjgF9zC2p8lTJMGQVeFGfT7H+NtV1/YSgXFRSe6p5kfykWLtFW3fGpOYMUB7a76YwLzNCuSrWqSXs06N8TX6gBSBlMLxn1vP/QALVdT3l8cuCiD2Eop8HU5s9TTlxH36DdicaQXSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P193MB2021
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wolfram Sang <wsa+renesas@sang-engineering.com> writes:

> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.

Looks good to me (IXP4xx Ethernet).
Acked-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>

> +++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> @@ -999,11 +999,11 @@ static void ixp4xx_get_drvinfo(struct net_device *d=
ev,
>  {
>  	struct port *port =3D netdev_priv(dev);
> =20
> -	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
>  	snprintf(info->fw_version, sizeof(info->fw_version), "%u:%u:%u:%u",
>  		 port->firmware[0], port->firmware[1],
>  		 port->firmware[2], port->firmware[3]);
> -	strlcpy(info->bus_info, "internal", sizeof(info->bus_info));
> +	strscpy(info->bus_info, "internal", sizeof(info->bus_info));
>  }
> =20

--=20
Krzysztof "Chris" Ha=C5=82asa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
