Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1735B37C4
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 14:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiIIM3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 08:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIIM3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 08:29:54 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0679B37182
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 05:29:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh6BZlRThMz7CgJN7WEeWxi9SAY2ftYz0Vh5rSzpmEwI3KfSzyd9JycXIwMyKIcqA4BbzhA4WkGX7zbvmw/rVHfHvL6tPH8OUO0GiPsxtNkP3pphOG9lKsS5R7T5IOiU8yFCr4w96W4v8EdqcSi5m1fJiEG8uEoSMtlP98Njk//B68nKDr8hoHdZeKbn20PnI2NQhj8Taz6W3vz8YJKFf5GvyQkuAOX2CeJSV/sKA1+vUqxkIHXMK+d/0KVCwQxEpa0knbNMsJHtVOfUO3s3YTuaUnbffrg2GIW9EQdemjBV0zaQSluqIDgb1WbmRuArPqPOsFJpnHQtI4fnQifxhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edFLgTVNr8di51rWIX/xgeRNMt55tKJ82yhZS8BfvCg=;
 b=T4injNFjYXBnWv8TISyB3hWiN1XKvfUiMDxdL9XyLZD7l3K+mlOGyNHhT9bJ4aPfv1RRi5J0RIfMqyyyWxm8rt/G90q2A2UpE8oUdAG3Z+d1/hSZPMBHI7bwNmjpfrByNqQrW1jEEiWQeNichwOb5xS/ZLWReGEGLW17rCa8qU21kWBVzW6vnznKgqVW49fnOkX4BqbttAVXVa4eaI2RjkK2Y/Eo9lN4iH6RTo8OlFen0k/PUcBXgYpQaWsn+3+4VS4hmdjJKIIsqsOe9U+Jl5kdXqudtROy/hu8gdRuom9bPc5UymmXANsa1o+5RE6KMT7ij3wObYAFNzwgqRqv7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edFLgTVNr8di51rWIX/xgeRNMt55tKJ82yhZS8BfvCg=;
 b=sRRvXS0vUSpkhZUeJZqTBYeurRrcb5C9TbpDFKU4VbmIQ6lOfPLH/twdpIG676C+NWm2cYBkGEILepiAA2g5xD38fTYtHwFPVBjQgtWqsGq6LYvL/VZPe9QgLe4RlP1x5Bg/2Hs5LbHX/B9nKIIxt/GJupMmZvmhmoIC30dW9RE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 12:29:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Fri, 9 Sep 2022
 12:29:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Allan.Nielsen@microchip.com" <Allan.Nielsen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Topic: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Thread-Index: AQHYw3oLFH1ClvQDs0ym2viLZxTp663XCMEA
Date:   Fri, 9 Sep 2022 12:29:50 +0000
Message-ID: <20220909122950.vbratqfgefm2qlhz@skbuf>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
In-Reply-To: <20220908120442.3069771-3-daniel.machon@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2b4db33-529d-422b-ac7c-08da925efda7
x-ms-traffictypediagnostic: DB8PR04MB6971:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eEPQxj1flxvW9LiIUAUqbP3r/izbZ0SnFU+TxbvOQu01Ar69m1t1lhtX84dDv7LNO28BaVmdt5VDPGrx6VaVBOuN/XWS6E4aZXm7sHLq96P3VD/W6Yhrj43MUBuvGR4AFqFK3aKylN1KYg85TQITJdDfZ+blMhSK6cdnSji/Dday3ckLFIIRscH5zOTJjFHC+CLw9vC3bjdT7UtvNQv2CmS0oGjIdrSntSI/ExqAqP6Y/xrz/HZU4SLe8PXwNbRsEKCQZbj7v4tdufkkN8QrKK+thSfEGCGlDjXyKWI/zA4kv/8OFf8h7C1UmCLZaZ5cSKZhKxiRlinTMSiNvL6hcT7QSotO3on4Zh7PyPNhqIQOutX+xfoxiyAak3IKBUIWm5JlocHSpbj0QZ+a1uHIu5LCmYYBBIT+4sPaePNuBUeEDQQD9+lW/4OocOMA7k6ATwueKVSaxJ3sPjGrUmVX6ARYHtvVLs23rCKqMqw8A+zmj7K3/qSPMdBCJ7CVJQ7cNrdhL4PZ27xoB3wQXPxIOW7ZoNfI62fEzktn6l1rCZkAxrCvLI70dYee/qiizyDzAnberlqyDLB3ijLTNpZ0avAIMQxy9vnBCeWHiceew5jjDS+MOpwPQFUtaX7woAw01qdxULKAKUzr6oq1m1UfEft6HH72X2sXwVKyvhSU4WFsOwBhQ0zDafL07R8lXuQ5OZgp7fI0dII2KdP7YdOdrNByAeGUwl2zdwWRx6TJPiBoGwKJLYI0v2we2Ut4vcZoXX7sG7qosCfHsdcPgHmG7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(346002)(396003)(376002)(39860400002)(478600001)(66446008)(66476007)(66946007)(8676002)(44832011)(76116006)(64756008)(41300700001)(4326008)(6486002)(8936002)(5660300002)(2906002)(6512007)(66556008)(6506007)(26005)(9686003)(38100700002)(316002)(186003)(86362001)(71200400001)(54906003)(122000001)(83380400001)(38070700005)(33716001)(91956017)(1076003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zl81BcCE/HCW5KmcOKJgjLotbE5tD/huRuONj2qUwkZNu8e4zrcVzNjVWxfp?=
 =?us-ascii?Q?LMT8PrwnOiZ+bqVPrBmoxknzcW4Lp6ahY0zCtbqM7X0aBZhmKpqPr3WsswNf?=
 =?us-ascii?Q?THIeYxr/QDqYoxyUC/vZJfUIDcB7+2NzyudJrPAcGjmPYU+RQKXyYV0eyla/?=
 =?us-ascii?Q?rVx6/boohIuW43f9+5HkPEddZbe/VohUIChLqvf5gslEZlVUPcaRyCFVbE3P?=
 =?us-ascii?Q?Y00G+dPwp/cXbDuOmtlVUXyTH+WtcJaXcxoBYjhumEpS5sDXkjrdpigKgejB?=
 =?us-ascii?Q?VVQRTtqvdSO1uy4b9p6KJJg7HZJ2ymfjwBAqINI3kzBcVQMZd0TFuuB6oa5U?=
 =?us-ascii?Q?q6I8Fl2xpEvDSZ1STsSFN5c7zbGg/vpGDktu5jQXZntN412T66a+k1vFgqry?=
 =?us-ascii?Q?WTwCFZ5wQcYSkrSUGiINx2zIS2PeoRvY2M8HECB1a4Ju0kSkaWY5VUY5UBjp?=
 =?us-ascii?Q?efBnXy6gL48+w7U6rT6TZ1tCgzpkXWEu1NLFyx0C3bKl6Wkl1phJWZGIFA3E?=
 =?us-ascii?Q?+LR6LAH0OuRatvNOQwD2e1E2uzD6RSrMpvnIX1fLL1E9OSUJS+EEMMWPYca4?=
 =?us-ascii?Q?Vdn7wIn9kErXzIQTV4rGDRQEdDlrv2vmrb8Kac3S1YeOmhPxJh6RkoCOM0AE?=
 =?us-ascii?Q?y+5LOsLAj95AM3jyvNT4KcjdKSsV92AAat4ZGUf9invj/mOtct0DjElmIjj5?=
 =?us-ascii?Q?Hu58t6/KsgUJUT68nIKujX4yfMrzrUxewdhqmOxmnppeJk9tR0PvQ9DFKk1l?=
 =?us-ascii?Q?1PMr14KOfGcmjNPZsIT4qUxaymofIZZdq/lO90G/K2M3ZWpmWk7yRdabnx0k?=
 =?us-ascii?Q?qpI6CwQk2+AEii20ReWu53eXXac+2Rrho6KS9A7rlfbAx0D2AQUbHMt6FKZN?=
 =?us-ascii?Q?jdaa76fWN3VTrp/VcsGj+sCgGaDbHF1IhyQCW9bH0ydeUVOOKt+x8m7AK7f1?=
 =?us-ascii?Q?f+PGZblO+ITrC1prY2VJhuK0d+eXW9gpCNh87681xOCzOvTAlzqpDLCuDzH0?=
 =?us-ascii?Q?YDPpHCIxKGj37mtXzmACKIHChG5lNJ1Bal/6IRlYOWrQpZzQYiTLWZTGhHpg?=
 =?us-ascii?Q?QV8Lm/pPOYouxqcu+LgdTNXHXyznzB32YlTal0raoUYVyLQwRN1I+kcBovvS?=
 =?us-ascii?Q?/6JgSVfGZwnbWJyzeUXJ9Nvs9CqKyFwRSaRouByEIyX+HiK7I8cZl8krdZGD?=
 =?us-ascii?Q?yB0mxihHnvs1J1+s2q9WJuQOY0DdSwKPcMXcZ+CY4go6diYyM6MwfW/C8KtU?=
 =?us-ascii?Q?YumTJx+4uKIVcK/qxTBtc7ADjuUT0gJGoqrp5yZxqtrlze3mLjbr6tdoH9zv?=
 =?us-ascii?Q?0hwOfFJPQX6YU7qw/RkzKE6GASLMESBxdqA3Jpj1yMMJU3oP40n6F5TO9hi6?=
 =?us-ascii?Q?LWV/gApD8dnz0ZaCbMwtQpYvtc0R0Go0VhZumcxsBVC78KYxwwFHW4Uwy4kW?=
 =?us-ascii?Q?UUYVLsRDdhJcrSOK041M/5mHx6m6FlwdyumVxQl3R1XQFTsc3dI0I8+hUA3c?=
 =?us-ascii?Q?GcBrf7/oFv9PeArz9baB9qSQBAUQsLAPH18PmEqE2SaCKTaS9ZKNoPPePcOW?=
 =?us-ascii?Q?GsjaFgEiae0L61P81nddx6O+SkcwqmXdT8KnxtIvU476FsEcuWmHl2skB9mr?=
 =?us-ascii?Q?uA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <057DFB9BAD4AA243926C60BBB54FC554@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b4db33-529d-422b-ac7c-08da925efda7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 12:29:50.6083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Ol8IA99uwvIZ518+/a6qK1KZjdPVwGtZuLm0kFmrDgPYV29vnvwJuE+RRQLIeTPH+lQ7huY0F8hRCUaV50sPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Thu, Sep 08, 2022 at 02:04:42PM +0200, Daniel Machon wrote:
> Add a new apptrust extension attribute to the 8021Qaz APP managed
> object.
>=20
> The new attribute is meant to allow drivers, whose hw supports the
> notion of trust, to be able to set whether a particular app selector is
> to be trusted - and also the order of precedence of selectors.
>=20
> A new structure ieee_apptrust has been created, which contains an array
> of selectors, where lower indexes has higher precedence.
>=20
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---

Let's say I have a switch which only looks at VLAN PCP/DEI if the bridge
vlan_filtering setting is enabled (otherwise, the switch is completely
VLAN unaware, including for QoS purposes).

Would it be ok to report through ieee_getapptrust() that the PCP
selector is trusted when under a vlan_filtering bridge, not trusted when
not under a vlan_filtering bridge, and deny changes to ieee_setapptrust()
for the PCP selector? I see the return value is not cached anywhere
within the kernel, just passed to the user.=
