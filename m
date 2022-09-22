Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49385E6B5C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiIVS7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiIVS71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:59:27 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2068.outbound.protection.outlook.com [40.107.105.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACEEF1D67
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:59:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8mYTTk7Gr87E0M1Tnli5xOclIsHg+7sCK96oVHXjtVNiDIIlq1IzLWKzwQbES3VoEPQ/TC/82xJDNBiMTSd9poGW38kUaYi/hJX1bOUssjmRGulagcey2TjHB1qBeywUuQbVP3YijMWrZBi1n71VMQdCbwu0Jy+k4e1dQk5ER+yAOY2hCo3a+xzghDO7HrUC7xZamMPNQfB7kVRFYqJ4UXK4yEYFDDQyZ39IoEmPn/ovhF+s/j1R65PYUrUil8rk1afaGVgNiKhyYwj2yg8KwfbLKg8zs9CkaiabArA8KCaJ7thDPA+duSCSkINR1I+7mF+wUuntmV7PEY5YMhWuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVP7SDSRZTIThNv5qKgEA18uKwxeQyA/k0xjOrbzOEI=;
 b=X59kbtvnkZnkYTSb3b5Ok1+6JtVNPOQ2Q+IuxwBAPmdWFphOqkdAnr05paMmKLOTq7Yb66+YXV0vtUg2maN93b0qxm9qfZAgScdxaz+uDdlIkaCuvZRUjUfz13tCNGjSr/F2iBb+8/MIXHGGt5Ic0YcQwjfVKQRJRxv6Sam7GvRFp7ZKA4g1Gdrp9gU5sGgM9LacqjitxD9N3DCQxuoD7DgKlCv/Q9kq+czKBzzWX9WphJyMouqHljaXL5spzTHaVekjDoqnNmwluN4e6Ac1uqQ+b6XNLnCa6box7AYSP7Mm4rhA2ZpPBAU61mhrE0Ke1ag2lnkUyB+VfT6cRz0QXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVP7SDSRZTIThNv5qKgEA18uKwxeQyA/k0xjOrbzOEI=;
 b=hvbyStAf+qtoiLcs2QUjMKfI1nPw5DOdTuGZOW5PUzWg2sl+X3hKFc3sahzP7w6h3Z8kpZnYmnYp4YA6Fq7tp7dbh0wF8Qtk9R+gyL+rhI3Y3O72ZIuRaaZeNXxUUA1dpxuGZxmQWs8De7n6xSwzmCHp/Wq9OaEjBGOKKKAe14Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8786.eurprd04.prod.outlook.com (2603:10a6:20b:42d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 18:59:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 18:59:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v2 02/10] net: dsa: qca8k: Move completion into DSA
 core
Thread-Topic: [PATCH rfc v2 02/10] net: dsa: qca8k: Move completion into DSA
 core
Thread-Index: AQHYzqz3WRbYv8aJ4kKPScrIR81+Ta3rzYAA
Date:   Thu, 22 Sep 2022 18:59:23 +0000
Message-ID: <20220922185922.uvioryx7ct3u7bza@skbuf>
References: <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-3-andrew@lunn.ch>
In-Reply-To: <20220922175821.4184622-3-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8786:EE_
x-ms-office365-filtering-correlation-id: 5a7e747f-0c9f-48b3-4ac8-08da9ccc9043
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +dyi6zpyClLNgt/+dxzeJirUcRx/biQRadSaDxiRlNqu3gYNHzKt2XULPOkWD/R4hIYI9E1OZIbNGDOMqVQ8/U1rlx37CvJE4CH7nRp85AglQTYu75XGGY+RdAhkd9Avv3yUk2xYvYclHYwHPE+CmN1bCMBqNXZ0/ANWhzL1C5bX+EbLCkKIMKL+DyeN21uCGnn4JXhHc67N0n0ka7zGlQRReTGBPENy1SpSyBAM7ogiYK5lgKqQEa8AESyD7+IqpliXav33A08jZ+8ShEX1GcM2+457n3rZFiEaIPVQupE8oz3mOImlWC+CnHvnLJ8hGtpwWa9Itnlpza5pnvl5gIxthGmR2PLh+dzxoZrBgkKY1G4sJkfAOGtfx9cXkpLfusxANYAs/uHegh7f+KU4iI+0Se8ctG8UPBSDH5EpxrTrUjpjcrJNp6n6x/gMRIwA03mT1/VGLkWNmeaf26GDgnByx4Mw0qkjfI+QStmaEL7TrShWHw5TDM0kFkCQeYydGglGowHZK4CuzcYbxZqW9oi43KG3hVHx9y0U+FrKPTfxfKRVQLyNx8oUOJLNRKFhXXfSPE2wOoitQv5+ndKNoHimjszCbGyymfOWtEtZYE3Pj7KnIrteqj3yo6LE4nVUAFyaeLc5v9UyvXpgNRV8J9EalJtuEdDs3R+dpRj+dEwVP79g2lUpAJeeEixMRI9zPbyvHR6jKSVtShsF+r4DH1XZfUoaNf3w6yhi9QEZ4r7cTFEDza2nmqBEGoO6ZhAW5or3S9PFChwzSxXpIgM3mZWstHY5Kb7lC1jieweyryI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(38070700005)(6506007)(9686003)(6512007)(26005)(478600001)(316002)(6916009)(54906003)(91956017)(76116006)(66946007)(71200400001)(6486002)(122000001)(86362001)(1076003)(186003)(38100700002)(83380400001)(33716001)(2906002)(41300700001)(66476007)(66446008)(64756008)(8676002)(4326008)(66556008)(44832011)(8936002)(5660300002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O/4yFp8M8t71hVIBu9gwGGPspRWK2GqbRSkr8Q2Pdae9ib2uXzqsXwwlznNY?=
 =?us-ascii?Q?e1xAG5UYGqC0enrR1nAjgPqJcETCbshv8B4gIIgqE7QDJablXA8ACKKMxHkQ?=
 =?us-ascii?Q?ee+llsudt1dzkjOAijSUQb5hYQHwQmeGdhOL7MEZO1ZU+6J2dHKjov6ewDrx?=
 =?us-ascii?Q?O4pnLdWEL2LG4fKCiGPj1pGs6N32v5TSa3wP/qIVV+6Xk4+Uxn9/WYu+MlGf?=
 =?us-ascii?Q?MwHRWmXBQBW+2fj6vCoNg+mJaHayST33t5uCiEXl90gvYKrk6BCRhKfJLJ1k?=
 =?us-ascii?Q?iM478k8nTY0ncjIkqY6omWOmwkC1ZJSm2Dl+idYVdu6xHtDx3GIAAAMmGZdD?=
 =?us-ascii?Q?HxUKCVx78IWAAiqOFByyClUsYS3hAEu5RXbnYd/GCUt1HUlakJJKhxcd4AoR?=
 =?us-ascii?Q?l1kO9IRp3GKC10OskFex6jbi+93ob5aGzijD4V0UGDZ9PVEGfP00QhSV4eOL?=
 =?us-ascii?Q?1z4dJh/7qUWmoXCEsSh+BWn3WNITOuqzpbAPuBuPStsFVQjYp0S+Xj5jXwkg?=
 =?us-ascii?Q?EWm97nBM5dRWLrdIcEfdvosiS+Hiug+opIJGIu/cwo9LPfIt1Hi9EtlPCd3T?=
 =?us-ascii?Q?YgvdS2IsZrh+phT8Te91K3ueVhEuh/+crH3qof0mwr7L9BzeM1ZTYFKsX2sW?=
 =?us-ascii?Q?0h8ESOTFOk+t/6/+HzXnKuIvjcvSJg+YEZFE6j1LFseYgVeSQfO23Nwf9KRo?=
 =?us-ascii?Q?yPBs6OuoOvaTHZY+wugLR97GVWuWcaQvPwXsXXQYMx7+B+f7OSByEc5d2YDJ?=
 =?us-ascii?Q?3boYB2BYUHKPbljBzw6rntxxRsfXaJHirFD6e13s5zFtnKc+6BZk7kMhxtX1?=
 =?us-ascii?Q?adcmNQ4rM+xxQk3hcidGw3rDjQc6aHvY9hdQxnOPFUQHaUR56F8X/qPOh4IE?=
 =?us-ascii?Q?hcxrhjWzGOZ0GI/qmpdRkqeTY1dra2Na8pZC4GNU07Y+TWyHDKh3VobB76iV?=
 =?us-ascii?Q?cr3/mSuv0bxco826quL6gDq3zLBqmOn49JX4DLch/9c4pow0IONYRhtedqkW?=
 =?us-ascii?Q?zbAXD6eBapGaYTzbxP3K4U7jawdvlG/HqA+F41jApaXt3cXHGIjaH1+OVCsC?=
 =?us-ascii?Q?GLoO4gOWKN30L35FYyodqQyvcq+DK3PSD8jVMOvbxmG3FAVgFeM46piO5ZkJ?=
 =?us-ascii?Q?UCIpXAGQl7qOEKLWJh+153B1K6eVimN94XpgLCrnxwtlkrulQGnnOnj8JLOy?=
 =?us-ascii?Q?6To2FNiDcHMAYtNZdTS2MJ8uSi9uMOPB6EqiXFybA4bfAyTZXfyeOepNbGDV?=
 =?us-ascii?Q?7U3fe0hK72U/NGbwsTeTXZlwMirfOLMfMa5rjjveMU7rw4P+h8WaiehlPIx5?=
 =?us-ascii?Q?ZctYnpBnKzDWfzAXH9rGKyl8iT9tEZF6Q9T5UWWqf9HGPRr6mX7g4S3JDn2U?=
 =?us-ascii?Q?YJB440+LTnm/zoEdi0pbtdL2Yd9tuKd6iCaOWfY6nfq4ZdLAr+vRKQpJeOgn?=
 =?us-ascii?Q?36nJRNLOmCKUzWtwueA1wUgA1A22v2sGfzbbmzq1eEPurwh2+GRoc2fMmmF6?=
 =?us-ascii?Q?Ndpo7QELn3mVVN8nbpMAz90R3QTVTHGMUARX76H6Bj6bocfI8Of7vNStsiz6?=
 =?us-ascii?Q?UF6HGP8pxrFvtCaSOtMm6VFy/3qpxyDxNimbQ+Oy4TVIDfTMfQUX2eByEc7L?=
 =?us-ascii?Q?pA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7854C3D0A9CBE84BAE4AA10FB6A26BA1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7e747f-0c9f-48b3-4ac8-08da9ccc9043
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 18:59:23.3468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGU30q0uUnbQEx4ZeWdhe76b3JfDtwospdPLZVr3+pnLM2FP5RGqAhKxNKE0oTyql01QOoCPcSmelP1hThFi1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8786
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 07:58:13PM +0200, Andrew Lunn wrote:
> @@ -1528,7 +1516,7 @@ static void qca8k_mib_autocast_handler(struct dsa_s=
witch *ds, struct sk_buff *sk
>  exit:
>  	/* Complete on receiving all the mib packet */
>  	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
> -		complete(&mib_eth_data->rw_done);
> +		dsa_inband_complete(&mib_eth_data->inband);
>  }
> =20
>  static int
> @@ -1543,8 +1531,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, =
int port, u64 *data)
> =20
>  	mutex_lock(&mib_eth_data->mutex);
> =20
> -	reinit_completion(&mib_eth_data->rw_done);
> -
>  	mib_eth_data->req_port =3D dp->index;
>  	mib_eth_data->data =3D data;
>  	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
> @@ -1562,7 +1548,8 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, =
int port, u64 *data)
>  	if (ret)
>  		goto exit;
> =20
> -	ret =3D wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHER=
NET_TIMEOUT);
> +	ret =3D dsa_inband_wait_for_completion(&mib_eth_data->inband,
> +					     QCA8K_ETHERNET_TIMEOUT);

Doesn't the reinit_completion from qca8k_get_ethtool_stats_eth() still
race with qca8k_mib_autocast_handler()? From the comments, it appears to
me that the regmap_update_bits() call is what triggers a MIB autocast,
and so, reinit_completion() needs to be before that.=
