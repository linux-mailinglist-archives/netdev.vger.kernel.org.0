Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9662DDD4
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240300AbiKQOVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbiKQOVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:21:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A02976173;
        Thu, 17 Nov 2022 06:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668694882; x=1700230882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dk4PcX/hxHwhWP9fMfn16UOk/ywJvkeni5B+SNS+UD4=;
  b=2n5Z24KBmt6YgoofsDEvFwe6YxX5k6w7yl47eirpm9fUKivcSPteJpo5
   +nWYIQodTXSFiNbVv6VQ7ApcpXJWXuMPBv+nQtsrteWNPJnhf1VA5lPdu
   oRmvjVM4Y+JXAMWJNDGdyLdSVatmUZuHszgOODYyclPPvV37DybNu2WpF
   FfD3WvA9x2Z37F8YNzuQwi1I85f018nIurdsa1UDIKVMG/xZuXSyXw7h9
   3FXEFdBBJp570lpWd8po50UXgpPa6Lc35XKzUAK6YCn3iau7FtpmEbd1O
   H13LlB9AYpL9s8qsFKF9o6EXPlNrkiiHYCXVOZ4tUSGWwpQ3xLCySt9wc
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="184003718"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 07:21:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 07:21:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 07:21:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/kjorxiXCu7ztwYfiUk5noqQYw5veYoEFABNWjvqpQzSm3Dc85O/HST/UM8IHwjx133laUWQ2/pcX3VID7EFwc1ljkIXUvKIMpEJGw2XsfNuEM4trrgtvya1HcbjXWq1+xBrgs2Tgug2XaqUfIwJ9S/FqijVZbheaisck/db8XHOQ7PoO0kaY7C84eLavB0l3+UmkHDNmJGepCjIGZGICaLMRgErAxk8gCkZgpmFWHQhj6yaWFYE+HMhuG4hGFYp2hkqloHN4MExtMjMlRMPEdJxsitb/sxOs03Sj+toTrQKYtdkBSUNrY8rnTVs29+W12ut4Q8uHzeEcvd8k8zaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=894CNVnTKpyqBsrnXub4aiCXY2ThKZXCQWDapsQHQ1Q=;
 b=MYY5hANg0spjjgNuX5fNbASaIV/n2hr4AJB0iLx7Z4JRnNPJSGLQxKwIjKD0eDQwCiW5uiU7bwJ0Gb+iosQDYtVmI0nqUmXGIZ+LTfO73UYp6mhNTLUEVN5/0hlTR9yxo2VrmoiIr8PgXP2qVn5niDJY/kHNCqgfLiE+lczjdSkfSFujYito82pZj/YOO8M+MyIvoRqN2uJSoqQoZr/2o+mio8rXew/3niHKeD6Y5RCMMRIqu/16gP2g+/HyEzPYGVSnX949hQW8cLVuuj2hk5jLV31lQaFRdQtQxz91PjmRXxCvbGkuf9LDiVXhikNLUk3L7ESHJtojCUtSjHJCNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=894CNVnTKpyqBsrnXub4aiCXY2ThKZXCQWDapsQHQ1Q=;
 b=p4aZw9I//mXwRBm6HkV6/UHelTlVOiNCuCl1qOh0ixPVAQ1LPbo5gCN6mFWiL6eqepCkk7rB7FJDLeeC62rd43d+TzXln8/ajWeBFq8yQ39aMt6AzlZSI1mYojxWmk1XSUVA41ut520Yd7pDWMFLWSL8gyvM3hC/+i8KVijxqBM=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SA1PR11MB6615.namprd11.prod.outlook.com (2603:10b6:806:256::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 17 Nov
 2022 14:21:15 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::72d6:72a6:b14:e620%3]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 14:21:15 +0000
From:   <Daniel.Machon@microchip.com>
To:     <luwei32@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Lars.Povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch net-next] net: microchip: sparx5: remove useless code in
 sparx5_qos_init()
Thread-Topic: [patch net-next] net: microchip: sparx5: remove useless code in
 sparx5_qos_init()
Thread-Index: AQHY+owNFKsLhwrlhky7iF4RkPp5vK5DLagA
Date:   Thu, 17 Nov 2022 14:21:14 +0000
Message-ID: <Y3ZF6gLy7hjW0KAx@DEN-LT-70577>
References: <20221117145820.2898968-1-luwei32@huawei.com>
In-Reply-To: <20221117145820.2898968-1-luwei32@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SA1PR11MB6615:EE_
x-ms-office365-filtering-correlation-id: 77746431-0d78-4ee9-f970-08dac8a6fc4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jHMq+PRlTSFjGyL0dcv8jRzufJqZA7kjp30IHNXvHZbg+Uke9bGBTd7IYMoHzEEM52DF+4YNP1gZHtA8ufC7T9/7clqYr3xgB9eJRS2U9vAe1e10qApMa/ro/EakX3lvnRMdvTthjiunQBbX/FlvVVUEmnDEiQFKjZN44ATAo8SEXUcLv/MsKHGvjMZx4CACtt+mG9qFIgTpABQEHSM6a5/eYf8R3bLqJtnmE+Rs+f7x0+bCrSNretsOZTBaoZx8b8U2CQMaIU0pPV305kXKtgustxIdOx+h8xjSSha9/ZXHT6E+jQHDcBZfqkym3ebcaLsF46Zj4V3CKquy1/jLydcDIFcwNhaxxTbjK8akU8NynrSmBQLXtX3bSd8uNvpaSDqXFX+y1n+w0NIZAhL4Um97ChX52m7ZJmxzZH7lwyThwVJIv8oOw8HNRioBfykmHdpFTKMIzzw5V1QNPT5MNNj2v4DYRfL1QLm7Bs/VcgUTGb0vnNL6iBASV3f6Ow8Q/2Pd3cF0HB05bSBrjZNWAMam5mnjllguKkGgq3emYzlXyjgLuiK73CktpmMiJfdfy0J70Rtjw16kNSTaDTOJBNk9hOk80WMwAZ+RXMZ7K8ZzABhUwz5Sp+S+8h62kOBLPuhAK3imZbP/ZHkZm6aepIrw/O5byBj4yLtOkEC7Fi/koMJ5+cMmjLKsW84K5qOjSL/8mbM3Z/zsDFIAxL5UYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199015)(66476007)(5660300002)(91956017)(9686003)(66556008)(8676002)(26005)(66446008)(41300700001)(8936002)(76116006)(6512007)(316002)(66946007)(64756008)(186003)(4326008)(2906002)(86362001)(122000001)(38100700002)(83380400001)(38070700005)(6486002)(33716001)(71200400001)(478600001)(6506007)(6916009)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4hhrrW0kLi2LZ2HT6/xVp2Af6bXkrCd0urCMKqVlTJF4EUOOOvvPcF1bFmT1?=
 =?us-ascii?Q?6Sy85feU7t4imVJGxdssIt+geCAsN44a+kDGaK9eNUpOGrHwQyXkrJlDst4d?=
 =?us-ascii?Q?k1DGN5bg83lo9KYupmVwSWXZ6KaAvmqEV17KLbpknTbIN9+TVpdB+32nRYxZ?=
 =?us-ascii?Q?CHS85dxYuZne+PHvUpz4EO/oGQrjDppLWy8vUE4eQdeAdMGsTSLZEemxbnLi?=
 =?us-ascii?Q?6ZAdMns1L5W8JTC/ge9w1EBAVWEB3PQ8DAxPUSUAGr+X2AT1hE9R5clla31R?=
 =?us-ascii?Q?pBPohQrF2M+bHQlpBh1WOeznoLvEVCke8npKtH1ZhtBmyOvCaaFXk584DGPP?=
 =?us-ascii?Q?9XQ2MVBYzrptkcrflHMEcvQQwUcGxPqmz6lCzeU6JlgCKCv3Gmsd+a6lQ5Mw?=
 =?us-ascii?Q?F2IhibDUa+gQgWkJmuRrK5wGd5wtsvANF8rHuvmLWH1n4hvRgch59LR1LUWm?=
 =?us-ascii?Q?XVRadQkGFYbkqBfshRO6WMuKToJhS4hSyllLH+EjjkWXzLSiBPSEJB/uAvc2?=
 =?us-ascii?Q?gH04PRUa4GdwsGEs2n3OIIWkqvmE0rw5C5MO0ioOIXwyX/BVT7c+sv37SXsS?=
 =?us-ascii?Q?7mANDLbbzNfOtKbsPLJn0lVUcRNMbLTU55pUxZ7uiDMC1bN/8fqOWvJj6MC+?=
 =?us-ascii?Q?9X5j0RWgjwLBvwN9N2w4yzXXzIq7mI77Wuhd7Jb5iE/cFit/lPo2csqMkUMs?=
 =?us-ascii?Q?M2p2kEFmJyzlv5RCEIlazX97YS9+fPWbOAuq0w/NwWbDzV9mAxn4Vm1Z45Ak?=
 =?us-ascii?Q?SDAyRZdSeHKRk7umcvDlKCd4N3arL1RSLcppbWHRvsxZeqQxaEw9yze/srCu?=
 =?us-ascii?Q?KIQllJCWgC/eqw43zvyqF03Ai+oBC9h9K+QzQsqsd7Nwk/kXFLZ4IBdKxiwt?=
 =?us-ascii?Q?QQDWBRBc3G0C+32iPENuBpOE9qc0NDOylAxePuQoY497qPrTfLCDITeZMRPf?=
 =?us-ascii?Q?OKoT8ILVU70tLC9ih2RTom2H3YaInNNKYSwnGRm2bQr4xXeN2GfjN/X3vbnO?=
 =?us-ascii?Q?PlClnUlnWBtIiO6NkZ0dOdyc5aUh0+5SNMTdAzpMiu2yUFaPPbmRBAEzrNlC?=
 =?us-ascii?Q?Dx/TA3G0zr/B+KMdbztr0FbNFWkPbSrOsJ1jQO4WxdqRqiAsAgGZjKB3d6O1?=
 =?us-ascii?Q?XNp80Qkf1z24nF8N3clD0S2l5o6X6DPcUSN4dAg+fWaV0OntP9JIhwLFBYVz?=
 =?us-ascii?Q?9ZFEybWzbvwUnAHRtA1vmbArvfPrjDVskVo6D8YKd9nYMGtSdQmVj4aVl7g+?=
 =?us-ascii?Q?8tWB3LhV+ynBSecXblNwRHXqnCc7X5o458iCrpCFPcGDTfIqxTmRYs7pE5Hj?=
 =?us-ascii?Q?vT+QOoaPtHrMbbTWUNjipVS6th9ZuO3mPGr4p0mcozjI3jOUu5/xxttPU79U?=
 =?us-ascii?Q?k4BulSD6XJpDJoN1E2a6bf4LGTgKq0HCQkWAnz3x1XscEj9ghXrRKaZ1whZQ?=
 =?us-ascii?Q?nIzuX3wlIW84x+uKO/3PVEiXf5HoAPJxcpvUcZEzH+0clK5z4XqRUz4/4Ekz?=
 =?us-ascii?Q?0YTJJaDZkb5mzebkMSo0AlqdINwdfO9Ek+pOEw6TKXxaqZGz5cKXInqu1sjh?=
 =?us-ascii?Q?3YT5FDz2C6947nE2hVFsCkXT4720Wqo5ghl8m9yZuVRs7fHQ3bduRprBA66x?=
 =?us-ascii?Q?dAW1P/w0pkUW2B17fIAn8lw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9055AFF4EEB2EC4DAA64C12D0BCC5819@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77746431-0d78-4ee9-f970-08dac8a6fc4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2022 14:21:14.9411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l8eMSto1dIYOh2mxd0rhM8im5GAaK43AjboU+4Qavskto7uOBqXbbBRuMHC3iPiqx/JcOKxlZSA74fUUMpIc4ojQ7Vur7K6yGYZUXOahaqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6615
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Thu, Nov 17, 2022 at 10:58:20PM +0800 skrev Lu Wei:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> There is no need to define variable ret, so remove it
> and return sparx5_leak_groups_init() directly.
>=20
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_qos.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers=
/net/ethernet/microchip/sparx5/sparx5_qos.c
> index 1e79d0ef0cb8..2f39300d52cc 100644
> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
> @@ -383,13 +383,7 @@ static int sparx5_leak_groups_init(struct sparx5 *sp=
arx5)
>=20
>  int sparx5_qos_init(struct sparx5 *sparx5)
>  {
> -       int ret;
> -
> -       ret =3D sparx5_leak_groups_init(sparx5);
> -       if (ret < 0)
> -               return ret;
> -
> -       return 0;
> +       return sparx5_leak_groups_init(sparx5);
>  }
>=20
>  int sparx5_tc_mqprio_add(struct net_device *ndev, u8 num_tc)
> --
> 2.31.1
>

sparx5_qos_init() will be expanded in later patch series, as new QoS
features require new initializations - so this is actually somewhat
intentional.

/ Daniel
