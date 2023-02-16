Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF242699C56
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 19:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjBPSbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 13:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjBPSbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 13:31:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033B67EC3;
        Thu, 16 Feb 2023 10:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676572258; x=1708108258;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nk5BGN0RMdh8RfgMt3V+BGPbH1rOlv1YGz264vCkMmo=;
  b=mZkX6PanfQ8oAepYNx0RJxuWpNiBpbNNnk/EbOXfliFV1ywxNA0LknCw
   jvwhKyQ3rzcAs2yJWA01ABdFNx5liJo28+mAwRFuFSjC5Tofk33dQC08w
   4W+AONpEND028Iw6c8Ev5gxSyijvYueNb0WwDgRNF60wDMrlbumrdYb0G
   uQoyu5ymlhOsXLF6r70O4iHaGyU4XFQd8d2AfbcfqkwelR3ck3M1q7ERN
   lrADC16l+zUB/HXRcjB35ph2GLLp3Bz95S4WaD8cAR8/AiB/gpMqHnOEy
   39oGLLrpPs1ziAQKw8hw5LOcJAOAVx7FVyne7u7dtHj2AJaA4nHldlj2+
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,302,1669100400"; 
   d="scan'208";a="137631774"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2023 11:30:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 11:30:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 11:30:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDyDY5bAJ0LRRPhgNtXfZPBaR1OY9p9x4jkxFEMVe7Z6VQfLcEpHopFWISOyx4N6+8GTdVKTySTrxuLQiyE+nc0VpqAZ0JO0wjd6sRUqkhfo9I7Gl31VN5sUPUZ+77Wd+DR40GmwxXgOv25HNRji2r9AYsfPVgtZQH39VWuxgCSi7FA4xR+L5Ltl3h2w2z5qRLgUkXs7uDuAzJHjdAJwKw4u+/yFIIZ+sQ8m2be/1C6zmTkQ9WU5Cv9j/00hEcRZxRHUH56YFA17LE2YFSHJHuNFhBj5WCFMaIeDdRxjGRNsKeVm59xBTPdiKAfJUe1HMCcBDH6Pd3FCIJUUzwfh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1tfsR99z/De60eqeB6PoOPMOxpYMZua8R394TARlHw=;
 b=dyDq7n/yFqgb1olYZOkD579mJ81Bw12na6W0Qe75jw6tNyNHRuK5GqsSTN1Kulgr3Lvp32WHMfGgCzxKVgbBMcfYMqjuSAN1UO0dJnkpPTfYhxw0M0jGSDCsA9f7yKLNR3jbHFigHZKW4ISQRtOQvZHWnETF1FJSr2PMauXmNhjDEvOfqVHjyWS0dr9l+Fznjs/NNIb+iHCVabFzEWK/6ZN2ngGrfmJXQYHJv/qFy+f/xzn1d6zLpzNSvJCts6EgIDowlbAt6pS+NNspnDCFN6hjHuu64883nhbY5pK4GqNBY2musLkprUYX4agxowrmat/7rg0qyhpg3gninvWl1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1tfsR99z/De60eqeB6PoOPMOxpYMZua8R394TARlHw=;
 b=B283jMyhopCEOB07FDdl4TncximoQYhdxOKN8tXn2bJasDmGJd3SDJ8vUrurb1XZen8Zm9P3l5BPHGwaR3O/0Dax6m80MZypa6KaazYbAi26aiPimZQpUp1sF70XCX5HSgXFysEZjxTGK+sLYkCK4lS/Ac6TjsFCqro6wRge1fw=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by MN6PR11MB8193.namprd11.prod.outlook.com (2603:10b6:208:47a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 18:30:51 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::169e:9ffd:afaa:aa3a]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::169e:9ffd:afaa:aa3a%9]) with mapi id 15.20.6086.019; Thu, 16 Feb 2023
 18:30:51 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>, <edumazet@google.com>,
        <linux-usb@vger.kernel.org>, <kuba@kernel.org>
Subject: RE: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Thread-Topic: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Thread-Index: AQHZQhiv+XmFBaMwYUuMxkOVxIUy9K7Rr0MAgAAbw4CAABna8A==
Date:   Thu, 16 Feb 2023 18:30:51 +0000
Message-ID: <CH0PR11MB5561B7DF10367A4A7A95F6808EA09@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <cover.1676490952.git.yuiko.oshino@microchip.com>
 <b317787e1e55f9c59c55a3cf5f9f02d477dd5a59.1676490952.git.yuiko.oshino@microchip.com>
 <Y+5G/yc7UB+ahylb@lunn.ch>
 <CH0PR11MB556166DDD69AD4D5FDCDB2F08EA09@CH0PR11MB5561.namprd11.prod.outlook.com>
 <Y+5gOxDuyK3csyre@lunn.ch>
In-Reply-To: <Y+5gOxDuyK3csyre@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5561:EE_|MN6PR11MB8193:EE_
x-ms-office365-filtering-correlation-id: e8b1608b-03cd-4fa7-a604-08db104beeac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1i4Jm4lvy0yK0SSs0NKIBApmpdDO5QGtcuTfnFWIc+gpy5fWUlz1AJM9qnaT8T+6GeLPCJPMaYo4KAqOysA9P7D75jNUIJPCxvZYbzkHG2i4B8Ic/j+O7bhT7UszbqPb2doqJUCU0+x28ISRnYQC7ely1fNW4hrOzr7SomUoSXjPrcMalq8tcHG+2LAXtMFCQPjBzSveTIAHo1nJXKtbDjNxlYpuRWSkkzT6+pHWMfofiKT5c9+dSJGnjEHgfH7HjFrBMqD8epbLIwKMTdwa4h5dZc3+1djX3/TmmvyQD+d9J9e21aEd0Uyv8Vxq4BI0XE5pDBGi5rWF6+KVrGraLUEsjxy+ZQTL7o0rLM74FN2jTOBGcUw09q31csric/jUWqUh5Dsc9tdCBU8ZUihtA4tGHCwVYrx4M/7NOyWHHT3xH/mqAMMLG2inpCCQUV4eJrp/NDx6gjSFJDdopYoK+5ZXqUo8lcZSAZ1K/G2k7xv47bntdZ2d6ri/NanVlDlD4RHt3fpXEU37gu2TedfWdfqMDgD/HY+Lyo8AzyYAE/iXireOYhMqIsUGRxAiswafcByTC0plxg2JVoFUjm8vCZNf4P0UiPcKWiwYOHv9L4aKc/eHgEYeZ+EK1KZN616yYD6HG+bvlfUpJRcGIDraxLpUOogTDfAPN4bx/QovUCbrj8T0sc0Nj2kns1k5U91jYajlbjS0TMj9dZhtkm+ymw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(7416002)(52536014)(8936002)(2906002)(4326008)(41300700001)(5660300002)(6916009)(8676002)(64756008)(76116006)(66556008)(66946007)(66446008)(66476007)(478600001)(71200400001)(7696005)(54906003)(55016003)(33656002)(26005)(9686003)(186003)(6506007)(86362001)(83380400001)(38070700005)(316002)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OCKdCiFtoAfuAF5rv+zUAhfOsoIlcMwlOz0Ai4bdJ613vF47dg7rLgN+J1Ge?=
 =?us-ascii?Q?qzl53L6PQNUx1zejB644vmpxDGMIiDzDs+s8TlTUqndh3G8LhK31gmQb/JPb?=
 =?us-ascii?Q?uEqW0315iBBmSZ/OUq9RCeLCMBvYTq8G8KLeGbD2IEYBOR3jw2iuVTTsxQxv?=
 =?us-ascii?Q?a2g8jh2f7y0qqERUMJb+sVH9d4YEyF9B0y3xfN4sK9gVWOaWRv1TdL2lK5NM?=
 =?us-ascii?Q?ONA2U2leJiTVOfc7V3DYX6sULl+OxPIhTGpqXEeKKXFmoZq17HClgbv5z+qr?=
 =?us-ascii?Q?fer7rVFhpuTkl+r7p9TrxT9sxf+oqVnv7g+xtdMckXM5d6sVnUVWIViGaekd?=
 =?us-ascii?Q?frFTLAznogAoaR1b1Kasmo8Zu4mICF8xwsQfyJhfdglvZFQtEOqcwwR71EvH?=
 =?us-ascii?Q?5MNWQjgDuboA9CVTFdYPyzOhxBiSNA5heRMyR+dJXOt5VMHLduK2/HqfRjYw?=
 =?us-ascii?Q?YqV6tvxWLyNjXxCIZrlcDO3Ez+CtqB46UC52/3WnGEyg5MlLc47STdhIuh9u?=
 =?us-ascii?Q?8tHcjQ9KAL6aDXQlzjw5PFxhdR6Xv2YZa0i1Zmn0U70CeXsBNvLKA5rcApLR?=
 =?us-ascii?Q?r1WSim70TfKTrbcIkNAHTKTWPxPxZzZ1uGyEccBsgYvNfugFm0/ziNwrLOd6?=
 =?us-ascii?Q?J40osYgEtjqUgzX4kouUAgeof02vECAkNMZ8MPi3vHaJnF9qp6qbhILA0Djn?=
 =?us-ascii?Q?Ufe8ULeRMwfxmJX3rw8WbQu1jsTD+jerZ97hp5G6Wu3hqlalPI/kapNd2A7l?=
 =?us-ascii?Q?jryYvq+1l1gNoguSq8t4NKuHb/hxCn93wDxAdxe43uvAzr0OpqhbQPL0bKYI?=
 =?us-ascii?Q?0Idk1kANMZqdWypWospeisz2vI5rpH1dPPcH4yDJ7nZc2R1rooB0LtFKoDPI?=
 =?us-ascii?Q?lHuxArRmvKN04oTXqMxpsODJBSLovf+pv6/HQGoLz1znm6uKWVHkLtWp+jJ6?=
 =?us-ascii?Q?1EsRLuUCcarCclMv5MB09QNHhMMG32Ky4uIz8LDL2sNPq61kRwptu5CRJGI9?=
 =?us-ascii?Q?IJOUbwNXi/vQnm9T4hzr8lZBy2/Z3PB80MDXqsEAnMtrz6b7YsBSwV1MauWP?=
 =?us-ascii?Q?qK8EMbkJAKWM4oR1gO44EzW9XAdIcB3NUut1x4ACMMrsYG+p6xvM/DlMbJ8Q?=
 =?us-ascii?Q?AIzBJjl0qT8AVgUdY4NaTlv2Esjjw2mbABZ0zIAmQC9oFBq+x53a5MsTRMP0?=
 =?us-ascii?Q?fmlJrmpzU283XesQ8JPEwsPIsaiRm6hH/J/7ks90YC+Ul2XfkgXJWbqaOVll?=
 =?us-ascii?Q?R6qJ5zmj8r03hzOaFXgidRSBD43kWVm5xIXJQelEWyuRx9tIs58moRWkbK4O?=
 =?us-ascii?Q?2ol51yRukDT3IHTg0aovrqMUrLu5LeYq2tUW40fl0UYL2+wgFkCmc5DemEAh?=
 =?us-ascii?Q?8HpF22r45txQzj4vyHio0ZtiFsM/JjNOzdpbQ5pdwWIZ07G+M46uot5a0mwf?=
 =?us-ascii?Q?Iml3pXoykGOGY7nQl1mtW+TQGNEsroa44JV3E9JHCxBxjcDua2bBv95i0Gcc?=
 =?us-ascii?Q?JpgmOURIShvHDs0kRZP2ILm1+iVhYqOtPB96twcpuF/03Tva7n9wvtuQzL8m?=
 =?us-ascii?Q?SQNR2R7HH2gBlDSuW+9KazXdJSMw+8cN4pt96THY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b1608b-03cd-4fa7-a604-08db104beeac
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 18:30:51.5784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kOlXUCL7PbcSOfOKshQbmo8q0jHJdsy1/FmAfK/grpQOShqjGNnfJ3pXhXq24gCVUSvYKQG7bQbDPD7ygvKXGlUsvkhXmdI4vCchnOUSdwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8193
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Thursday, February 16, 2023 11:56 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: enguerrand.de-ribaucourt@savoirfairelinux.com; Woojung Huh - C21699
><Woojung.Huh@microchip.com>; hkallweit1@gmail.com; netdev@vger.kernel.org;
>pabeni@redhat.com; davem@davemloft.net; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>; linux@armlinux.org.uk;
>edumazet@google.com; linux-usb@vger.kernel.org; kuba@kernel.org
>Subject: Re: [PATCH net 1/2] net:usb:lan78xx: fix accessing the LAN7800's
>internal phy specific registers from the MAC driver
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>> Hi Andrew,
>>
>> Enguerrand reported the below on 20 Dec 2022, therefore, submitting to n=
et.
>>
>> " Some operations during the cable switch workaround modify the
>> register LAN88XX_INT_MASK of the PHY. However, this register is
>> specific to the
>> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the
>> LAN7801, that register (0x19), corresponds to the LED and MAC address
>> configuration, resulting in unapropriate behavior."
>
>O.K.
>
>So please include in the commit message this information. Then it becomes =
clear it
>really is a fix.
>
>Also, you did not add a fixes: tag to the second patch. There is a danger =
the first
>patch gets back ported, but not the second. Since you are just moving code=
 around,
>i suggest you have just have one patch.
>
>    Andrew

No problem.
One patch would be easier!
I will add the comment from Enguerrand.
I will do v2 tomorrow.

Thank you.
Yuiko
