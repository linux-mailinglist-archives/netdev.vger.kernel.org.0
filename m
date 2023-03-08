Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEFC6AFEAF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 07:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCHGAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 01:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCHGAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 01:00:52 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AE9A72AD;
        Tue,  7 Mar 2023 22:00:50 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32860J66009161;
        Wed, 8 Mar 2023 06:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=u0aOftbte63aEf+675v+GbOdv/dZklR5ZVuts/AtG80=;
 b=fxeFvVAgDjYnfQNg9vc5YyCgHNmeu30Bzj82QI3zvBJ4V2EheaaCLJUwMC70TqYTvSUF
 RvONiYd+zfBYpk+eXJ7Ys2eo54O9gayuWsZDRx9hjeAJlx4l0lG758XBcio1NIiaE2N1
 RR+jMQ/vxYrkdH/6ADmcB0nGw/CQRDtSgOHf14xclwvwfg2Tt0za+qFTHQnZF1ccdwxE
 Hz+NfWtOjA167IOE4ak1TKFw+r2tjcS7r0qywMgPe54AHE0ty3rDv8du801p4ZCCYmY+
 JOEn1WrsdaWUyPQWEBNyk1FgOay06ZzB4jHpKvOScDDc6XNWWth+yJZKX65CbYfuFFyl XA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3p6fg6g6yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 06:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJPFiiSKdKilvUZS0kzhoSY+uvAMls/1s8dEUy23kUy4AI6ofESrqcvUAN70rxKj2GmBJKSz7abXjpbOVrV0JU780VN93HqJvETFmepkSKwsb7aCnHcDjsY73V25MMfOrp6gKpt3Hg3J0fmvEM6tvAFOYHlKQ4BdGZagHqxWiwYDSxBOitoVDC/IXjMQWn5Rs1Fjt4CsF+59O05yS1q/po6I9EPNyMEwG/M5BVFi5JxO+FBFxhEjz0/dmnfPk+Nv5LenAiZx1D7ESn4thiJD7VnW2PKQwsnY/QX8oz8OIb7SgtKpjUC6HZIPDFpWT7atCkKPXexyF2PajRGjabCpKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0aOftbte63aEf+675v+GbOdv/dZklR5ZVuts/AtG80=;
 b=NzQrmXdRu0IeuXqrNAgupwQ5bGW8P6NOdAW2UcexMO2zXDIDJ9SRArnuueP1ktDkcoi0B8viUJKx/P2Pz32ty66rlMy6ouzXN/U1cl/nNYRQSrs5Os2Ch2wCCtflVhl0Q+jQDCYSoUSMggoqDYsy6UOvcUkZI01RGBhzpUKEoCwiDH7gNvnWQoVsrQ4JOiM4Jwy2fY1kTj69AmOPqHx8AIR5fQUrW1xKoq8n7WBwgE8p2k160PBNWjjtfKz2ht1fEX+ScJWbH6CXl1ylt2K7cDNEzjoM7uU9yCv7mbwOR6xbOgr8Q8x1FxOfxdfAFVgMqetXFP1qPPrLGBmJJK9okQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5192.namprd11.prod.outlook.com (2603:10b6:510:3b::9)
 by LV2PR11MB5974.namprd11.prod.outlook.com (2603:10b6:408:17e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 06:00:26 +0000
Received: from PH0PR11MB5192.namprd11.prod.outlook.com
 ([fe80::aed:f30e:f18f:c74c]) by PH0PR11MB5192.namprd11.prod.outlook.com
 ([fe80::aed:f30e:f18f:c74c%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 06:00:26 +0000
From:   "Song, Xiongwei" <Xiongwei.Song@windriver.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Response error to fragmented ICMP echo request
Thread-Topic: Response error to fragmented ICMP echo request
Thread-Index: AdlQ7X/oxr/JjbMvQfuLNLgfv6/HcAAA9G6jAACAEAAAAP8IAAAiWClw
Date:   Wed, 8 Mar 2023 06:00:26 +0000
Message-ID: <PH0PR11MB51929FC41163A4A930C929B9ECB49@PH0PR11MB5192.namprd11.prod.outlook.com>
References: <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <PH0PR11MB51923E3796E4D2420C700580ECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <20230307123522.rtit24jseb5b2vep@skbuf>
 <PH0PR11MB519201AEC268247F6890157FECB79@PH0PR11MB5192.namprd11.prod.outlook.com>
 <20230307131828.ly5zudvllke2pe4j@skbuf>
In-Reply-To: <20230307131828.ly5zudvllke2pe4j@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5192:EE_|LV2PR11MB5974:EE_
x-ms-office365-filtering-correlation-id: 7a57258c-f669-4020-20ab-08db1f9a69b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJ1u4vEjslT0Rr/zMPLL37a6i+dJoMjnuwnlqNUhIalZ64Q89/3W8DZcsKcTvhXU4MJTsgZ0rJIlIU0zUwCwlDsUJkRWSCP+rjkjW32dDzh+T2gOwD9uR284uStTNCcoa/3godfAuwxSvYzd6BVc8XbIf+sjOeTspI1u8nPG/Q8QDrE7qhVsQNu9h65z+NCviAR09YhB+g2TAT/OXBRqiskLtzsd7G/6SB2GLK7bqsNtEniZvTXaYLSi7hYh6VYqJPAaXhaHdtiKfC//OcBNNRbS92VASsgLOluJqTJDZhqfvBHspmo+y8JxpQ2utLcShEqkmYS7ANfpnh38miJk/Ii9JoZiMKTGBjoJ0a8amV/XIbyqn9xfJ1RfIn68MJQZvHeeSgTbXMuwqBddur5Lmn9LwuGyo9XQdKIbsSdh7xr4BsNlNaPIujx0IXKHJyscKboWrOO9XgDKWYad4k08ats/Yh4BHr9QFOFKUYxoLVXEPju5eNAF7LMagpq2icd76eZRrjfAZ3X837fLDNuf5z0jtveL1HfsdauVVBZ3BpQyJdAkXMS30Uk5/TAtEbx29CEhfEuKocIZvB6bzUkoYy/q+KKoHSNHG7DAmQ/6wssmipHaFsjrSv+d0suDqjdDt34KU/79h0QD/H4qppqg+0gEd2ZDEN3HCtuURHfdfVOXpNHeUwuY3CwBPVtSQyCo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5192.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39850400004)(366004)(396003)(451199018)(316002)(54906003)(83380400001)(55016003)(86362001)(33656002)(64756008)(9686003)(966005)(186003)(41300700001)(76116006)(5660300002)(26005)(66556008)(2906002)(8676002)(66946007)(66476007)(4326008)(478600001)(6506007)(7416002)(66446008)(7696005)(8936002)(71200400001)(6916009)(122000001)(38100700002)(52536014)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f2mmOl7mZeCpcae9J7zrLnfs+hnwpk/KecZ555Vol6pzMmjL4JoP7/Pqkaib?=
 =?us-ascii?Q?1GgoYmDcRRV6YCzwcXaAxZHRSfFGHjz8Aj+EMCEiT1f9O8TbQT5S0cqL92Tx?=
 =?us-ascii?Q?Bs3SdYwr5J6N+X6lkUs92uv7LBzMA6hHeaKR9mOJPSEJC7ahXdCHmAl0vhQZ?=
 =?us-ascii?Q?7XZKpBVd0T3JueH+w81lDbBXeZyKOqftFC2F5h5LYSUKOcGAXrtHnRJccN1Q?=
 =?us-ascii?Q?6PXg4hSgyQsyfgk4hLFyyvoxCYQoOruL+tvUGcc0Uk6M1quBphfuyhLajQpK?=
 =?us-ascii?Q?i35zP72StoN6LGbLTp02jQXzzZvChWESZXMoj/iVUXMnb/p09NWLE4Ic6yHT?=
 =?us-ascii?Q?kIKlSb1d8G7AOxU/QPygI4yLpZDbXgJ8cWjEiJv2yZFplSwUXtuT7kgNtgJD?=
 =?us-ascii?Q?f99DrYKShtJGv2RJ/9ULk1Zt7gHAgHJ/6bdgGzSAS3SkX84s8wt3k4wun4U2?=
 =?us-ascii?Q?8fheBjFuoWcZpFz+iFgByw63ZcST0AKjiXa4796tOOttTbOOSIfBYukSejPL?=
 =?us-ascii?Q?FXzB9GuPCXx8e4yrNVIUr7kNyPo53syIwGSvkSqhOZxbkzyMxW9q24agYfFy?=
 =?us-ascii?Q?bNck/Hb38IXSDBRiGOpAGV1kJLvQ95lKyMY9k1/YsKjUWgWRrinE727ePouJ?=
 =?us-ascii?Q?Na7wK3HDNyCc2WK+K/fL8ZKvm+0jsrTk30xCkAXBxGzWgamOTkaMzT14b1TN?=
 =?us-ascii?Q?U7CpvdlkP2242zQB93OtSXcG5aNc0ToJefa5sbXDZPxEYaEUWyq/l7qzK4La?=
 =?us-ascii?Q?SC9VRbj7t0CxcI/2E2G5K2BsMgq4K0s42UiBlMwvfniXfJ7qv+Q7EYbh2sIB?=
 =?us-ascii?Q?T0vMCLRBgr1gK169/rdCxCqs4rH4jWddwWTLUcadL5g233QmiOOS+AZUAVVc?=
 =?us-ascii?Q?xPdiVqqOk0+az+Wz9yvF5INfsvpHrsHykGS8qoEVWe8uYtkk1K7eF5WY7BDM?=
 =?us-ascii?Q?C/v0htYoPt35+BMkQdtlC22H/IXZPWeEvqQTLzZdlTBysxI8ZR3sDJgMK6va?=
 =?us-ascii?Q?Vi4+u0DqsBdjqyNxnVt52VCppiMSqPHA5U1rzyrT5I7cQGd2u9Xs5LH7xmpC?=
 =?us-ascii?Q?vvyss07/LTS/0p00P88j6i3YqmNUx+gsftb86I6cGM+23wpK+2AQlSHTbcjX?=
 =?us-ascii?Q?BdtEdP9XGfcQiqN+Z0Fd4SIgKMPpzgjyt7NlJOaqTdSgVeVB1eFao0BFDHXF?=
 =?us-ascii?Q?ekZPgBZ+Sw1MdHRP+fRjeoReww/cNuyB6l85FdIi65F1eZQgMJo+R6YM3USe?=
 =?us-ascii?Q?lRjeB+7oQcaGIavK2wzLHI1Bp49N/iIQubYfxgQndUU4T/LQQSau7sSMfiwa?=
 =?us-ascii?Q?IfT6HsoucELTm6DFdbrXsKJPtMeNjsJorx2PvJoOfRPNzjcR4d0Lm3oB0BwD?=
 =?us-ascii?Q?xgA7ZHz2kO/9L+72NH20ZFvx7WsPGv0ejjB5ZuO3sgv31X52VGyyxuJiUQ3o?=
 =?us-ascii?Q?eTLEuYn1Zolplzb31prwI+S3jw+W+1BEj9zzFNN3BPL4lUxmn6RiulXz70/b?=
 =?us-ascii?Q?ms959I1F44dR49Jczr4bSVL7dromcDhJD9hBefG6Mk0UGe0/t1wprKJaZN4X?=
 =?us-ascii?Q?rYlX2KKk1Ip21IbWhyTFWhxMVnHWyfCevfR0thOdWtcuoXPl1ZmdLFuLsny4?=
 =?us-ascii?Q?+Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5192.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a57258c-f669-4020-20ab-08db1f9a69b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 06:00:26.1778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x7f3DjH4WMddPMcPlp/D4H9hii6QjRA9TAnaU9wdBw8yajjVbxvJDx2Q0w/we3nBIog2x+JdlZb6cuu55RHjdCJH2zB5weAUtzd7f3qTp28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5974
X-Proofpoint-ORIG-GUID: r_4txWQEEV_x14eFVruKzCoT_Qh_jVDR
X-Proofpoint-GUID: r_4txWQEEV_x14eFVruKzCoT_Qh_jVDR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_02,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080051
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> On Tue, Mar 07, 2023 at 12:56:17PM +0000, Song, Xiongwei wrote:
> > > Frames 3 and 4 are sent with DEI=3D1 and are dropped, frames 1 and 2 =
are
> > > sent with DEI=3D0 and are not dropped. I'm not sure if varying the DE=
I
> > > field is part of the intentions of the test? Is there any RFC which s=
ays
> > > that IP fragments over VLAN should use DEI=3D1, or some other reason?
> >
> > I didn't notice that. Let me check the test why set DEI=3D1.
>=20
> Ok. It would be good to have an answer to this, because one of the
> assumptions of that patch was that whomever sets DEI=3D1 doesn't get to
> complain that their packets are *actually* dropped :)

We found the problem in the test:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
        f2=3DEther(src=3D"26:84:d5:7f:7d:be", dst=3D"7C:72:6E:D4:44:C1")/Do=
t1Q(prio=3D0, vlan=3D984)/IP(src=3D"10.225.32.20", dst=3D"10.225.32.21")/'\=
x00\x00\x00\x00\x00\x00\x00\x00'
        f2.frag=3D1
=3D=3D=3D>f2.id=3D1
        f2.proto=3D'icmp'
        // result of f2.show()
        ###[ Ethernet ]###
           dst       =3D 7C:72:6E:D4:44:C1
           src       =3D 26:84:d5:7f:7d:be
           type      =3D 0x8100
        ###[ 802.1Q ]###
              prio      =3D 0
              id        =3D 1
              vlan      =3D 984
              type      =3D 0x800
        ###[ IP ]###
                 version   =3D 4
                 ihl       =3D None
                 tos       =3D 0x0
                 len       =3D None
                 id        =3D 1
                 flags     =3D
                 frag      =3D 1
                 ttl       =3D 64
                 proto     =3D icmp
                 chksum    =3D None
                 src       =3D 10.225.32.20
                 dst       =3D 10.225.32.21
                 \options   \
        ###[ Raw ]###
                    load      =3D '\x00\x00\x00\x00\x00\x00\x00\x00'
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
This sets both the L2 & L3 id. L2 id is actually DEI.
We updated the script to only set L3 id and now the test passes.

>=20
> FWIW, if you do need to set up a reservation for traffic received on a
> port, section 8.6.3.3.15 Buffer reservation watermarks (page 817) should
> help with this:
> https://www.nxp.com/docs/en/user-guide/LLDPUG_RevL5.15.71-2.2.0.pdf

Thank  you so much. We don't need to set up a reservation for now, but good
to know this.

Regards,
Xiongwei
