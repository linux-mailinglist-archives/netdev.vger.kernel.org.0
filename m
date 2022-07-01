Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27360563C35
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 00:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGAWMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 18:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGAWMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 18:12:54 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA40C675A4
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 15:12:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6tXhKGoZbr4XeP4EQ1ybYIy72GZE40DjbqkoMO/Lynwefseu7cQCLrHifXBq53v7yHJKpkydyo5NfiTObnkucW5L28zY5dvMGT5fewQALk7rb/URYASgjhz8XYt/C8WieoEz2wSEdRQZdWBif0KbhFXgRXJFDsokM+z3jhErpOukbo7c6SaS+c5TeOpCtkpnzEAP/qWe6rl8HUuQtgHGZ7I+fJpV++zmW7WL8uC9zmyslAYwqGi3W/6A+GDeYYJ339l/g9T3Hf4+NAg+1QG+/L+MV/k0u/gacem6eqLosGNnUm6KH7RVGqO8ldaDUJt6C6wRrVhfrNslhcCN+4eIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zef8L3Cw5hnJpkeAERTSLFRdgyuuiATe+oJy22ymd6w=;
 b=NgoLuUCnIxgNx0PRQD468QIRMxDfdqjTORkLmTeTPfkTIvD55cIPTfCoUuq2SQionGxYSrBJ5ELg0bdw7QMs1Oe90tTyiSnCw9uBMTGScNqNG6bGdra9LhJ108vuR0BnCbhrlWC3oj+/Ws1/Uy7fuJ0zTWa3hezBlTLnpEnvmGBmdtuMEiVnT8dTLNgp444HiOohl22jpF07ZdH6YtbQ6G33g3q2Maiz2mKDDyxcueRr9FiaO5UCRiMx5kQ/f+gyEAAKJ6M02OqBZA852WOIW8Qgnd28uSQn0e/hDrAnX3nLouXwyXHSFTqh1lwMVskjzW3kxjguJ3EdCSgmZjL3oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zef8L3Cw5hnJpkeAERTSLFRdgyuuiATe+oJy22ymd6w=;
 b=cVEDxhXmbX22l61UvbZZpy9aAUEODQgYKgNJ6o7IL+FZNTd1A1J03ej+QZZmmWBLja6eb0W/NAeTpc+BxNI2owIpu1oF2qCne9UE/nBJSFkjaVkctN+I5+gN0Y5FaA2PsTsKOMI5e2PK8AKq0iuMV+xsMc/Vee5oqIiI6LlmTmKHSeJmeNR5dU1k5hIC/+mGmKGI0vaeyjWtSRhFuMEs33HY3FLopLTsIBLg09gSloMx1/bGnrWQebHEfQmRExgt4qsTMX9o7fFG9DoO1T6eJkDfW19eISzKXkCbvoAf0OF+ioOI8GX6mIsDMf/QE9iGG6PTKr6w9WAomCUFhD/rIA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB4959.namprd12.prod.outlook.com (2603:10b6:5:208::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 22:12:49 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5395.017; Fri, 1 Jul 2022
 22:12:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Thread-Topic: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Thread-Index: AQHYjU+N2FCBvYoo1k6WRMs2o5YCL61qFA6A
Date:   Fri, 1 Jul 2022 22:12:49 +0000
Message-ID: <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
In-Reply-To: <20220701132826.8132-5-lingshan.zhu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30526226-4ac8-462b-10bc-08da5baed5d7
x-ms-traffictypediagnostic: DM6PR12MB4959:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +RYbQlcTg0J4Hb0eoNy8lonR+hoqtzwsQDhBqOlVhgupCnJVSK3bIz7fzrhrc5n0WBkie11UBguL7PefHeDSkjGdGFCZeCMDXyR8JAMYf27rkOyGPyg/QEaNccgGcCWckESA0YYVD7zVAvcRr4Az+v5H0d3DK1ybsvIlNfwM8zAc9sZuiv4ROpNa1j2gfagKbRuQE/i8GZy1RIQukvf41InwWwEmqSFlkp274UVhri3g+bRJ0BGxZlAzFrSClzbYChmPRdl6DZ7wklLuUbaVNswQdZL3CagdEYnuZ4h3/aNa1PJU64IMELICuOYdGyZeBWOAKozgMDCxe6IrgwdrNcfJLP40a7vUmm8Rr/xKUEjUmm8OOyiAar0egY3GhNnRGAiznWYIv7xu5g0jn+CkfnYjya3nYoPaEsC/0TWqs1dPhIYcrvJ3nfaMVxMuJNdpnckczZuINJCmEOVequVaBuypek7Dmcp7/zxT7L1bXenFuzMMGp+Yk4AFt/8W/3u3InPyQZ+eVSX1tFScKHYCQLUZmzfOrjxnkJIRsKsQsxKThol5paJb6c802d59/E27q58RiatYPbfpBt42lTBR67x/oZ73pDvy5QWzXDM2AvvR8kY6y7wDtCoQnS27DIxGsaylcGrPjnVVlW2ZvtIbzIVRMkKf8hoIneDq1wzec8+gxLuoRiaJpS4fbl5lHZmfbwHMHCZQwi2e5pPySovyEkOGpX8gSw1PkXxMgygP2rvRayDc4eXr23fdTWd4x/xd5BB1OsgJGoCL28VhUixBaF2kghcgIPG519kAyGpfvOKryrN804R7PEtx9uRbdpXy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(26005)(9686003)(83380400001)(478600001)(55016003)(71200400001)(2906002)(52536014)(8936002)(5660300002)(33656002)(7696005)(6506007)(41300700001)(8676002)(54906003)(86362001)(316002)(66446008)(64756008)(122000001)(4326008)(66476007)(38070700005)(110136005)(76116006)(38100700002)(66946007)(66556008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n6UCmHGHX1Foi+z/vgXPMnLWlHyVEjykihBa6Iw3UoD7+0vQYjFzW+4UHyLZ?=
 =?us-ascii?Q?GS+wjicSBHZIAFHqwpUIu1Ngm5UKaOs75irAKDURdd7+OXGJeGCq2k35/F+y?=
 =?us-ascii?Q?x9YtmVTqsSqkBN9iSL9ElPmKNxAITiap/q7wy/FL6VWxsN4W+xtkZ3UNba39?=
 =?us-ascii?Q?a7VreTo5VK3hsaNdmtnx3Zwv5N3Cm/YU7UKQnRtTF6rl1Cq5XI1OyBUMSZX0?=
 =?us-ascii?Q?/fa8C0Q7fdHmFi/ukMZXdZAMEy2FQ13bVmDijrDrfrCk2ddc7uXQYQ6Iic4Z?=
 =?us-ascii?Q?oGM8uffNULQAdH6a4yIEvPakA+vgkVrAaTOd9ZTINVh2bH4nl7xSbH2fkNqJ?=
 =?us-ascii?Q?iiCXIhAwHyLCxdNkKsdQgViWjia3/WTyL5Toc4QdyLW9vcaRNCfNpA+3sRNX?=
 =?us-ascii?Q?xc3MjWymXcYRc66R8v02GsDz05h0I/Il56f+evATVLuetqc3DgFKp9CY2Srn?=
 =?us-ascii?Q?Pt4QcVz5a181dIyB+K8EDYkUvi611lff6luBZkoEl2VVXKzhFGuYF2NwMCOz?=
 =?us-ascii?Q?awUdAVLf3rt0LyfuGYp68EVJZjI0RAB4M27SID+QrmX4x5iyliS1e2huXh+x?=
 =?us-ascii?Q?u7NHII27hj0wfDl1nQ7ZdqV/3DqI8WxxC2rjN1oin+EcuAa8fkekjEdEePWU?=
 =?us-ascii?Q?ddx0EmqkM/J34Ok/wLx9JMGZjFSwpskm0cd2l32EBqyU0sxFqLJfBxi5LmVP?=
 =?us-ascii?Q?ZZv4dyGCqD5CnNrdmaTBbr/EGuXlrVHKgEp5Ms6J6N22ukqWhUIwP6XF9iRV?=
 =?us-ascii?Q?UdfxkzewWQ7oeEeyFtJwQleB4xc4LbPw8+ECrsb0Fjn74jUnUwQZSLdXfCv2?=
 =?us-ascii?Q?WLziX3plifc2hwpzV5DRVMG7umnVj05CzYPaBrRXiaGjQOnuF8XIKUNHx/5E?=
 =?us-ascii?Q?KKuey4inYMxs57IQlXtMHgleIrgoEWBmSiVOcewT4ZrIE/4aMhKnX6A1zNIi?=
 =?us-ascii?Q?CN6l1p0zP4/rB38J3pianFSFidEXRXuYbGLHpFG9bSj/93V38RSfxs9lOCgN?=
 =?us-ascii?Q?OLWm3bBq/+y5zuQGrbTdru/KOfPKu/AYrt2NxRQJ7YkNULa85MKkHmw4MeVi?=
 =?us-ascii?Q?rdhhZ3gQvL6QZYTU/ksd9htm3FJ8bXLEs2ug4B9bI5iE3Rw7toLZw7yFz26N?=
 =?us-ascii?Q?JY89SnwogIvEcuLkd7Yvd87+Kt7hKgb8Tz4M9eq6c3cJP4c49qdpVE1SLW0s?=
 =?us-ascii?Q?pkwtNLIIN50DOZ25ZMiDSbMs/kXV8j0N7e6ksrWPjaJxAjpDSXP1XqKr09fR?=
 =?us-ascii?Q?iGW4y9P3zIlJdzEKbOklqvIN5EIQF6nCZfx+14XNVdp60olblOj9PMoBsNgA?=
 =?us-ascii?Q?l6ASWELMglPFlJ0TmIIEaCWk3TEG9tTE2umVp5exn7+1j0CMxc5c/kz7+hrY?=
 =?us-ascii?Q?aRdHiM88ha0X1UqeEFoo6CVsASY9S6GfyfBX7i977AtVBFrgg9j0khMGQSAe?=
 =?us-ascii?Q?Ys6H0RbK94dJ6kAtyrlCthJA+zjp3j/X4MllVQe+soHvXge4yECQIAys6zHv?=
 =?us-ascii?Q?KSDN3gmmyNIhJeYkHO2X6apcJe2F4liS3UIHEbOnuSCHSObLeLwjGTT7CVVy?=
 =?us-ascii?Q?3bg7SqN2wOzbPP5gR4A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30526226-4ac8-462b-10bc-08da5baed5d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 22:12:49.6112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18m6Rdru9XudnA5hlYUs3AXO/6k291Xt9jD4HTY5MhyGD8y6+jFNN+4eHSlfeh45aW3FXb2GkBGlLuzB9i8uRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4959
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Zhu Lingshan <lingshan.zhu@intel.com>
> Sent: Friday, July 1, 2022 9:28 AM
>=20
> Users may want to query the config space of a vDPA device, to choose a
> appropriate one for a certain guest. This means the users need to read th=
e
> config space before FEATURES_OK, and the existence of config space
> contents does not depend on FEATURES_OK.
>=20
> The spec says:
> The device MUST allow reading of any device-specific configuration field
> before FEATURES_OK is set by the driver. This includes fields which are
> conditional on feature bits, as long as those feature bits are offered by=
 the
> device.
>=20
> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK=
)
Fix is fine, but fixes tag needs correction described below.

Above commit id is 13 letters should be 12.
And=20
It should be in format
Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if FEATURES_OK")

Please use checkpatch.pl script before posting the patches to catch these e=
rrors.
There is a bot that looks at the fixes tag and identifies the right kernel =
version to apply this fix.

> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 8 --------
>  1 file changed, 8 deletions(-)
>=20
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> 9b0e39b2f022..d76b22b2f7ae 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
> struct sk_buff *msg, u32 portid,  {
>  	u32 device_id;
>  	void *hdr;
> -	u8 status;
>  	int err;
>=20
>  	down_read(&vdev->cf_lock);
> -	status =3D vdev->config->get_status(vdev);
> -	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> -		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
> completed");
> -		err =3D -EAGAIN;
> -		goto out;
> -	}
> -
>  	hdr =3D genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>  			  VDPA_CMD_DEV_CONFIG_GET);
>  	if (!hdr) {
> --
> 2.31.1

