Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E8A53DFF0
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 05:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352273AbiFFDNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 23:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347295AbiFFDNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 23:13:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2135.outbound.protection.outlook.com [40.107.95.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD6A2AE3F
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 20:13:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoF5tkp7vp4sW1I1uqbmOk65q4JhdnUAIP5DwFpFfldITOlkFPuJ0HKxmKoVWaIbYNmEpTCPU+SgOG5BKC6WdlpHb1oxdoMd69+tW55RSYPX4iv3mNpWMlFX1U6DGr4b4Xtzi8CKcqrHX5hXL9VQmeAdjDDsfia7SKGZtX+tzjEo08fYMEAAqee4XEQn+fCMGV4Sm1HvlWjSiMxbcCX9/ON34fP7Yr3LTZi0VVrPl/uHXMpXIftbfKvbYODXGaGFmEtRTukRn7Rd3YqY/HdmDZMZ4b0lkhJuP/AzzkY8eaPc7Czh2qvRwv91LiB97oqNeBxityPi1VJTDlXEEVt3cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hm0Mbsa+FALuKv6iZEq5f3LF+71FyHnjQpj2xNnG568=;
 b=N2cMQqIOI0ptmNSPVROz4u62oC/9u6twSM5jopeV4jvaLEg7OhHykqsK2hO4weDbUU/blE4rU/dKG/fyYbfiB4gw2jCCseyugSwx5yJbLeemdTvGc98DJapTkrr0eT4BEJdUL4+H2zVtinKG4dl4BmSRGsSheKGWeq3CNf2Qs1yTgOXHM2yMHlFNPRQsGKLGFmDwotKvkNAo/A3KxrM2ZEYk7PzmGK3vM0W3P7vesgggnMrqihhTcwEvuIs3dxuz7j0ihYplBctCvITvk1bPWIbsM9j/lJmOpc24GtlwiFSx15gtexbhloaGoIZR47Xw/h1+OBjArIUd8Vj6uCpQJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hm0Mbsa+FALuKv6iZEq5f3LF+71FyHnjQpj2xNnG568=;
 b=PVY8BAk6/o+uLSIVRqFZTHwvGZE7ymEtqd5GTzUU/2JOjzseNFy+oPvB38SWY9z1loYURl9xS0ESM13TphwD7yU9vJpzt/yJNBevkI5E98Vl07mUWbNh12BlS2Nfjjq0aEEp3vaAlnww/CRVBEdOuz0JjDYLG1KUAG/moB+Ugh0=
Received: from SN6PR13MB2414.namprd13.prod.outlook.com (2603:10b6:805:5e::30)
 by BN8PR13MB2772.namprd13.prod.outlook.com (2603:10b6:408:81::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.9; Mon, 6 Jun
 2022 03:13:31 +0000
Received: from SN6PR13MB2414.namprd13.prod.outlook.com
 ([fe80::94d:c037:4d93:7abb]) by SN6PR13MB2414.namprd13.prod.outlook.com
 ([fe80::94d:c037:4d93:7abb%6]) with mapi id 15.20.5332.007; Mon, 6 Jun 2022
 03:13:31 +0000
From:   Macris Xiao <yu.xiao@corigine.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: RE: [PATCH ethtool] ethtool: fec: Change the prompt string to adapt
 to current situations
Thread-Topic: [PATCH ethtool] ethtool: fec: Change the prompt string to adapt
 to current situations
Thread-Index: AQHYdkK+vnoYqJEmZ0S0dFbZhLr0Gq08eAQAgAU/VUA=
Date:   Mon, 6 Jun 2022 03:13:31 +0000
Message-ID: <SN6PR13MB2414A83004A1D2B1C2FF4FB79AA29@SN6PR13MB2414.namprd13.prod.outlook.com>
References: <20220602053626.62512-1-simon.horman@corigine.com>
 <20220602185504.xk4uzvyk5h4wavqp@lion.mk-sys.cz>
In-Reply-To: <20220602185504.xk4uzvyk5h4wavqp@lion.mk-sys.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 539415f0-f5db-4490-78a6-08da476a88a3
x-ms-traffictypediagnostic: BN8PR13MB2772:EE_
x-microsoft-antispam-prvs: <BN8PR13MB27721ED62ABC87B00DAD08149AA29@BN8PR13MB2772.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HCtAeMCMgsSOGahk74PHDp70/4NlTMvHE+RqITthxaY/sheMg86V+2RAgTxt5Q+PaIYpFviy3e63ycJyGnjtonAZR7Ao+fJSqRKAZa30/mfzOvoOU/TtfyTCLWceYujVQq4tp4pud3BXMulcdUue1fwIJlyuuaHOrRJq8yQKNx0r5HTHMFDDaJZEAWZsgVC5RVTZg1M2v1OZLcc20AIJTZCTbc9Fk2LoYemwBmQJQpny3aHE47zyPd9HdesvYZBiKI3R0rPzwRIqCycKyzYpRtXP3B0V2heCPlg3YX2mpV1ABNgGNKNSpFkZ/YZtyug8aJylHmCa61NqkQp4SCDttd4pCL8dobPETuigKpcJl8qXwiCgcsSEgYfnt0z0n61XfDp3yAeHBmTEYOLwTbqXRx3s7XuNfoRpRQ9RBp4cBQrT7KxCijsQ7uldxpBJwavBxhvaLG6d0LVhZ8DvNPZwyyEpvf7dyTXiv6+4VmE+tE30QULOGApjANoa2OJzV6ewGTxAK1YDlZ7Dm8oGwj9ghCq8sSQjjxClnbGphwhXeRUU3/zUfwWyo0mLDpuCL69Do4Jvb6+vGmq/zO4Khu7ss4e21Os37HaGwbhF8TJVhlv+q5y+W7xlrq7FsVLcqLj8A/D05Z0gNwNpMz43xinKan2WMoRF3QFLi2iFxCWEOWtv32NcBvQtFmq4LuyMab8TZ5o3QXWBzesmzdPHj6VrrXvffQNk//gZDJnJoqRD+pdVBSMH5f4gSR1inxqHnCp+AylQ+KaBJLD8tJCf5GG00UJSc1lCh2YiPX+lRAC+644=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR13MB2414.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(376002)(396003)(136003)(39830400003)(366004)(9686003)(6506007)(83380400001)(107886003)(76116006)(66946007)(66556008)(8936002)(53546011)(38100700002)(122000001)(186003)(41300700001)(508600001)(966005)(26005)(5660300002)(38070700005)(52536014)(55016003)(8676002)(4326008)(54906003)(316002)(66476007)(2906002)(6916009)(71200400001)(86362001)(33656002)(7696005)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?QTU2b3lpWEp1Z3hrc0xucHMzT25RLzRBV3ovQVlER05oamw5RkFIN3d5?=
 =?iso-2022-jp?B?N0EwY2VRTEVqaEE2TnY3UEV0dWx3RVNMVCswcVh6MUxZQ3VHYTBUNWVC?=
 =?iso-2022-jp?B?M1dtRk01YmtUTlY2cFZucUpmV3F4Q3hDUVVrMDRFM2liQmY1cUM0TVVp?=
 =?iso-2022-jp?B?RkdaY2I5TG5LRGdqbmcwaC9NbkJQU0FkeU5Zd3VSSTVrdmhPSVV0VWZo?=
 =?iso-2022-jp?B?UVpDblE0T1J4U0h6dmt6ZkN2UXNRZnMyS2cxNERrL05JbmYvZGVzL2RX?=
 =?iso-2022-jp?B?ZE5wZnN5c0o2UkI0WUoxdnhrcmhKNGZCWVpyMVluN3ZZZ21LNS9FYTdQ?=
 =?iso-2022-jp?B?Q3NMOXh1ckpNcjAxOC9xSnM0Z1BaU1g3TDNVYmZYYzVRMmxoQi9GbEtN?=
 =?iso-2022-jp?B?bkE4ZWNUZlJrU1JDQmc5VXNBVmNnRkc1a1VEOUg4OFNJRktsTzVMcHF4?=
 =?iso-2022-jp?B?SmZab0dXOWFOU1djelUvN2FhajhpaEsrZThiZXRza1IvODh5eWN3aHpu?=
 =?iso-2022-jp?B?bFdnalRoSk9nT3BLNTVUTjVRdEZ1MkpHZC9zbXZIMWhhZTFJUm9HZDF4?=
 =?iso-2022-jp?B?UlIxZlNTc0oxODNsclliVlJqVHRwWVBmc2M5MERxSU43eU84UUtacFVh?=
 =?iso-2022-jp?B?S1dseTh1NFhJQWtqd0pnSXc3NElodkdDUkVTWWdmeEF1cFBWVkRQL2c5?=
 =?iso-2022-jp?B?TWVTYWxjTTdPVTJGMkYyTU5qcFFxZkJRR0dKN296SHNWMjZRNVJGREdE?=
 =?iso-2022-jp?B?OFNPL1VzTUtOQlUveGdVKzZndnlzQldnTy9JMzA5Um44M2J3dzFpTDZJ?=
 =?iso-2022-jp?B?b2M4bU5iUTEzdEhMT1Jpa3YxSEl4TmEwcExFSWdyeFM2ZmlXVk94bnZD?=
 =?iso-2022-jp?B?NXZVUWlvdkoxZG5wVlRBOTBqRkxSL1loSUU4Uk9Sb2QxOCtiOFJWV252?=
 =?iso-2022-jp?B?NmFjTXJPUzdEL3RrN29vR2tRcjBud2pCU1hOSUIrcG1iNm5ZVmFoMXV1?=
 =?iso-2022-jp?B?ZjBESmZzNURRMGllaENNS1J6V2hvaitwT2tHc1FmOTE2L2xOOFlpVFdi?=
 =?iso-2022-jp?B?dWU4VXo1Z05GN0dRWWlwMExHQXM3cVJRTjdRKzNYbU9VT1RTZGRHb3Ja?=
 =?iso-2022-jp?B?L3RNNUhYWk1TaFM2cGM1SXZPeW52UEE1S1E1U081SUFwbHg4dFh1dlE0?=
 =?iso-2022-jp?B?RWVEN0k1NHRUN1JWQmtoSTQyd29qR2VhR0VqaFhsOVA5VGFwSGM5Zkpp?=
 =?iso-2022-jp?B?cjNmVFRpREo5a3RoV3QyN0RYaW93aGJWNHhrdGFackd6ZUplaHdDczE1?=
 =?iso-2022-jp?B?TklXQ0U1VnFzRkVhekF0WnFXTWhZcEZwa2YxMVk0NzBDczJuTXFnY0oy?=
 =?iso-2022-jp?B?TEphd2d6ODBhRlhjQ2Nyc29GY3ZocDhtb2RDMDZ3a1JneW9VUU4yQzB2?=
 =?iso-2022-jp?B?Y2ZKYnRZZER5SEtrQ29pQjFQb0t3Q05Ra3Mrb0xLZFpvMGY5Z2ZNYzgv?=
 =?iso-2022-jp?B?VG1IUVpFQUhpVlg1VUNpVVpWUHI1Z0tteVJXMDAwRG1aMnc1OXVIbDZs?=
 =?iso-2022-jp?B?aGdkNnBuS0tvbE5QbkZhV3Y5aXRCdmU0OUJDYWc0VUxSME5MZHpXbE1B?=
 =?iso-2022-jp?B?THRvdTB4QXBqdTJuNGI2YUpBTDdsVU0rVDV6QW1JN3p6WTRmUU81a2NO?=
 =?iso-2022-jp?B?aHVlNnRnQ21qbFBnSFNMMDE5OVpwYS9QKy82dHArRVMzWHRaQ1dNMTJ0?=
 =?iso-2022-jp?B?Sk5OOXJSOUd6c1FlU3BwbWJsU2dRdjF2a1AzMG5kRW90Z3BtaFJTZXVp?=
 =?iso-2022-jp?B?cktmK3R2L3gxbCtEQnRDdkEzQ2owMGpscFZqV05KMVhFcTdXS0xTYXk0?=
 =?iso-2022-jp?B?NENXUHpDTHdKVjVzcVIxSEtValBPVnp0N2JaZlNEMHhDNG9GTlp2UW1B?=
 =?iso-2022-jp?B?eEovci9HNVorL3VldWFMWHVYak9VSVlJNmNic3UvNUM0NjFnQjEyQllz?=
 =?iso-2022-jp?B?cjJSOTlOYVlDZW55dG8vVXB0ZmhlamhneFhWSTVuSXM3Tzk3TDNWNjZi?=
 =?iso-2022-jp?B?WE9laEFUNVNxSTZ4bGpGL0Q1YjVUQm51Ti9aUmZqSUR0dzY5Y3lScFhL?=
 =?iso-2022-jp?B?ai9Cd1pTWnd5RnlnNnVyb1Z3cXlsd3AyelJBNVhrbStycEhkZHVRVUdj?=
 =?iso-2022-jp?B?NldNNS9UcDAzaWVZaXZJTFg5aDdPOFZGdHFyZnFmREJWZlliUENmaUc2?=
 =?iso-2022-jp?B?bmZGQlRPVS91MVdqdmNMOEQ2MlpXWW5PZjNidXdjM2JNb1VBZ0FQUU5K?=
 =?iso-2022-jp?B?SzRDampuamlaMUo0SGQ0MUxnUzNMM05JWWlVRnZLQXpMZWd5eHA1Q0hJ?=
 =?iso-2022-jp?B?THF2UlQ2ZEV1QUxBcmtkMGd0YzJOWVZIb0c3OWxqN3d0aTZOb3QvMS9X?=
 =?iso-2022-jp?B?aXBzdkJjQzlPWEdaOEEwZmhxbXhTSStQdzVsWUxmcGIxVjd2ejJYK0I5?=
 =?iso-2022-jp?B?MHlUTXJ5SUNmVkJBRVJaenAwVldZdkdDSlpsZz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR13MB2414.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539415f0-f5db-4490-78a6-08da476a88a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 03:13:31.0397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqjA+WhgPPbD2Y17PHLcxvmqh1fBVw6PLURRMA/gDQakFGttkaewteqs20Mjqxcp2Xi0nMBssuCqYVD5GOor1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2772
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: 2022=1B$BG/=1B(B6=1B$B7n=1B(B3=1B$BF|=1B(B 2:55
> To: Simon Horman <simon.horman@corigine.com>
> Cc: netdev@vger.kernel.org; oss-drivers <oss-drivers@corigine.com>; Macri=
s
> Xiao <yu.xiao@corigine.com>
> Subject: Re: [PATCH ethtool] ethtool: fec: Change the prompt string to ad=
apt
> to current situations
>=20
> On Thu, Jun 02, 2022 at 07:36:26AM +0200, Simon Horman wrote:
> > From: Yu Xiao <yu.xiao@corigine.com>
> >
> > Majority upstream drivers uses `Configured FEC encodings` to report
> > supported modes. At which point it is better to change the text in
> > ethtool user space that changes the meaning of the field, which is
> > better to suit for the current situations.
> >
> > So changing `Configured FEC encodings` to `Supported/Configured FEC
> > encodings` to adapt to both implementations.
> >
> > Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > ---
> >
> > This patch resulted from a discussion on netdev regarding updating the
> > behaviour of the NFP driver. It was concluded in that thread that it
> > would be better to update the ethtool documentation to reflect current
> > implementations of the feature.
> >
> > Ref: [PATCH net] nfp: correct the output of `ethtool --show-fec <intf>`
> >
> > https://lore.kernel.org/netdev/20220530084842.21258-1-
> simon.horman@cor
> > igine.com/
> > ---
> >  ethtool.c     | 2 +-
> >  netlink/fec.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/ethtool.c b/ethtool.c
> > index 277253090245..8654f70de03b 100644
> > --- a/ethtool.c
> > +++ b/ethtool.c
> > @@ -5567,7 +5567,7 @@ static int do_gfec(struct cmd_context *ctx)
> >  	}
> >
> >  	fprintf(stdout, "FEC parameters for %s:\n", ctx->devname);
> > -	fprintf(stdout, "Configured FEC encodings:");
> > +	fprintf(stdout, "Supported/Configured FEC encodings:");
>=20
> I'm OK with this part, even if I would prefer if we could unify what the =
drivers
> present.
>=20
> >  	dump_fec(feccmd.fec);
> >  	fprintf(stdout, "\n");
> >
> > diff --git a/netlink/fec.c b/netlink/fec.c index
> > f2659199c157..1762ae349ca6 100644
> > --- a/netlink/fec.c
> > +++ b/netlink/fec.c
> > @@ -153,7 +153,7 @@ int fec_reply_cb(const struct nlmsghdr *nlhdr, void
> *data)
> >  	print_string(PRINT_ANY, "ifname", "FEC parameters for %s:\n",
> >  		     nlctx->devname);
> >
> > -	open_json_array("config", "Configured FEC encodings:");
> > +	open_json_array("support/config", "Supported/Configured FEC
> > +encodings:");
>=20
> AFAICS this would result in backword incompatible change of the JSON
> output structure which is something we should avoid if we want people to
> use JSON for scripting rather than the human readable text output.
>=20
> Michal
>=20

Thank you for advice. So whether to use only the first part, and is this pa=
rt not
needed?

Macris Xiao

> >  	fa =3D tb[ETHTOOL_A_FEC_AUTO] &&
> mnl_attr_get_u8(tb[ETHTOOL_A_FEC_AUTO]);
> >  	if (fa)
> >  		print_string(PRINT_ANY, NULL, " %s", "Auto");
> > --
> > 2.30.2
> >
