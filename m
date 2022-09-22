Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB445E6BCA
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiIVTgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiIVTgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:36:52 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20079.outbound.protection.outlook.com [40.107.2.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EE610B203
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:36:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myDmZRbz9iy4CLkW4IvyYo4bp5xY/zzONCeVM152s4ZzniYqqODp2lv48QITWoDOx2kKJfBf8EdGQZ1i3u4adebHNCPLOSAh7RSXqvYB49RYoMUMvK+nO07en8J29k8WDT6HbxpZOLqwKMXLquHGiRJ9Tw2+mf/M3CR/DpGtkUGOEZLXf+RBxMAQEqkFIkaUAK2JAZ4oBCjyC5tamIn5x7WkQlQk4VdkwNBCyU1vwCYUsrmPJ141UzZv45Iuld3ouopYSG1IX03Cl+BlDk/buVl+XJQ++ViVRP5DSn8HxRg2/XeneGpmSAkXumgnLrTxTge2Rfw1MH/p66I95UN6IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25z+9NjdttXtSx+W1rnPbj0SAOM2L+QjuIv32T8iVD0=;
 b=hAvKIjavMNMqsujKvgmQbI7SOvorCRsBZDfG6B2gdXOrYoThuRPUg98n2IR/lO8zke1hSc769uQGgu1J0VW5xZgMozMrsH8/zFI9F1h1o4phbcr1f99shxRSbzEDXvbDX99pQsfgCv7rFZsW2IkvGewo5v9t7wJJMUpDh2qyyxZHcsKkC6oMOUFh32Y1Gbv/hJwDIsnjU8ty8U/sX+1B8pM6wE1VR0Ov2z0bmdul57H9Vgt43B12/a4EKZ4amY8mB/DolBl2BmWHF56mvWscdKDlmTba8ff1zVBe/5mm6UgmfHdJJVTXKAKBdfooxE2jOA3OHD2lDSRSrwumQ6OBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25z+9NjdttXtSx+W1rnPbj0SAOM2L+QjuIv32T8iVD0=;
 b=Yd+05CGQcDGAQc2Wq+fAz/CIy4mfhY5uTk3pQ4boZWWaug3sq0w45iTgU/J348BRk45ArMRr3VdzBVLoPqLHYIm4yHB5mm1CPITH6vL0sLowpZJNlhDCCnDmRK3yR59DB4+JcqtXAtvQ2CQVoZTh9gALze4ZdX+QCeAGrsbFPjk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9345.eurprd04.prod.outlook.com (2603:10a6:10:355::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 19:36:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 19:36:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEHDgIABDlWAgAARNICAADKKAIAABd2AgAAI7wA=
Date:   Thu, 22 Sep 2022 19:36:49 +0000
Message-ID: <20220922193648.5pt4w7vt4ucw3ubb@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921153349.0519c35d@hermes.local>
 <20220922144123.5z3wib5apai462q7@skbuf> <YyyCgQMTaXf9PXf9@lunn.ch>
 <20220922184350.4whk4hpbtm4vikb4@skbuf>
 <20220922120449.4c9bb268@hermes.local>
In-Reply-To: <20220922120449.4c9bb268@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU0PR04MB9345:EE_
x-ms-office365-filtering-correlation-id: fad991a5-f0d8-4e67-64d9-08da9cd1cad0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1crCeU4TrmPKZdDbAv4kLoY9M6aFtjE/gjVxPFnNVrjfdWI4yVytV1F2N3TOQkDB7XzAWQM1Id+ogmvoqS5IGThFAqwAc1we9yp0PokgGaiAHIbiORJP8dp6bAJ4SwK//nE/b82asV91PvgUYwvB/596tWZn3k/s42pqJpa5cyr9FaJdDh3HY7W/R2WoFQJ5HMEFbIW4FsNYgW1f1NA8LkuFDPZdesxjgxj3pmLZaJSWpUne50743iJ5D+yh7WxZNVUWAkBIF7lIBgEEblVMt8qA2SAXpCPrjXXbjLVsNZCe6g+/yUhZiW6CrDeULUoY/DKqMjVtu1OaQYMCAOZs1lpPluRtmSw/MA5oCSmCi48fI6HlKx6v0Vh16S2CJkeSTtgLOOm6wcJtO8XZIccE37wWqLIR2CFTjImsLEMRpDh+xJVrPpodM/Cb4dDrZB0sN5+x3CROUbfqAVaGy6DPoFvUOT4QIpeF93jvuz6d/Q8lmiibbhhF0vdSJCj/mKACUPYH8IqwDHUf3O0ZZEwhjgxpYhfsIxEmAa1/C0QZ7mT/u+2L6ml8JqSLqkoEiSS/Ukve522gHyFNZsNaC30GeF1aUCWfBV0NjbmImoKdU+ZJYXyBov9yICG8gutPcSo4uRtyXIX/2nyjVWv6trB/zLHRPL7sxOK0rGuGa0VPO5472q8R/HnMIjiGZr8rJoRp24gEnTs8T5Ew/QqgDzpNnl62k0AAs+qRkAY/nlxwj0YxYuKWO9H3FtVXx56kFXVIWKzDIAWweTz/2WozC6uMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(71200400001)(6486002)(4744005)(8936002)(38100700002)(86362001)(38070700005)(186003)(1076003)(122000001)(41300700001)(9686003)(6506007)(54906003)(6916009)(316002)(478600001)(26005)(6512007)(64756008)(5660300002)(2906002)(66946007)(8676002)(76116006)(44832011)(66556008)(66476007)(91956017)(66446008)(4326008)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OH6fra6+BRJlb9hjiIFH7FYc28TFAJqgGF2063XOLGgYvhgSQ0+BXSlSZXT3?=
 =?us-ascii?Q?rysf953iyk2Le5so+5vZaFMKVmSHCy0MidPQCbJSTSf3MUWkoHtHIB6WXIEV?=
 =?us-ascii?Q?UrIgSntX2NyIe4eq27DTKUucBPcnODwUPxOgYknB98/9qxyppAnfL6sX+7BS?=
 =?us-ascii?Q?Nk+FFLl+YIk5+VI/2SRB7H37pZDGds4eX62oH7Btq8kPjA6atPgQuD3X+1Ck?=
 =?us-ascii?Q?XvWZNI0tUfIeOqizdC671L7tXjO9n7crvHZQNTEYRAyBb7LHI9MTo6L/rKyd?=
 =?us-ascii?Q?duM4HZBSSDn5A+srLI7V1L/EANZ+iSr3r8E+1sT4QLS56HXmZ1/4Xe5VoZNl?=
 =?us-ascii?Q?C9EvWMex9HZgpfQskp+TZ7Cr0h4zIyAbXHJjIJ8a2curs2QZkV33frHT7b4i?=
 =?us-ascii?Q?yNfx2tlkSjaPGcNNsBk0uKUfnT/eP8pm4gWUdUT8yB62Z9PFQoRiaFCzHM5p?=
 =?us-ascii?Q?7FbohG4UzcGYLPfv9O/Mmjm5u/PwZvfWgGgdGjpxU4/42hFQ5p7d0dVTXnTR?=
 =?us-ascii?Q?5ExS5cvMtuLHBTZpHiv0bB7IbyhRPZdUvGCZOvSLxcRnDB5BmlnWgx3BXNOf?=
 =?us-ascii?Q?j14eKhaacerHHSetfaITngempTP0fu9q51Ta7UZKzqhYcxnZCK3Ew2RVxqoQ?=
 =?us-ascii?Q?/sYO7TP7pVOXET0SWii9NCpvcXLJP54XedbLP89ucdJPKoVMhe7IC7fVa/fG?=
 =?us-ascii?Q?Wm+jZNc524LNwyLoIs6RFVGx77vSY7CpAm5CbHpIcbMC0bUnVjllBgNalRLC?=
 =?us-ascii?Q?1il9fghgWUoJeCWK+SV2syhegIXHprxj2dvCHwM+o+cYpesHr3jVqLPj0a6S?=
 =?us-ascii?Q?gC8gC21TDTZtLQnoLuUSHijZvxo3EKZR4PWvxtXJB5U0RtOKjQ3SH9akrQyk?=
 =?us-ascii?Q?U44J2RtBxurPxCPCcjP+zcVAocDp56yL5T5eUDlnuv7EpZAwIatwOkzi3tJf?=
 =?us-ascii?Q?oHD7pfuQ9JEfI1IePdXJC2Z4UH4G6O5w9MLOS+vfpES/33RYfj4Bn9m/PwFa?=
 =?us-ascii?Q?tXAcl+BsBlbdct6xUrVdlXUpIgyN11xxKK7Fu5QN4jEeU6g4OE1cB/LXedX+?=
 =?us-ascii?Q?txdq85UAmOeIRVVL6ayFQblEWlebPbra0vSR0ed7OUmm/G7ImXNPHjSsLQde?=
 =?us-ascii?Q?VvVV3XAtqTP+AOSnAbqG09HQofMORZrxmLBMlXsfLSa+CUXEUDfJmF7rtIsV?=
 =?us-ascii?Q?jrEFlBg/kdG2ymRZQtDWZodkXoF3WABsoTy4AUNHA+6KGz6Y9gMOdQ6ryRwn?=
 =?us-ascii?Q?yoRAV0imRauAjmzfFmPIF9K/TGUgtAngAHPOhusq0LYaNkI5uCIHf97IkpQK?=
 =?us-ascii?Q?YpA1r3rgONNVr8TVMlUnFc+YxVn7Af+AGTbJDrDW6Vt+6CMS9fke6ZoSyDhh?=
 =?us-ascii?Q?KotAXifzTwv4g6AI9E10PQMxnLLBlJvQe9B9cvKE8zexGc8OVejCAyqRu4o8?=
 =?us-ascii?Q?tQmw3woRB7XHNs8XsNoF5d7rrJal9BVTYqMigpiLfBXKSl6BbfLEnd/oUTlJ?=
 =?us-ascii?Q?03GZpCFtfHNW4LkhBB3ien0OfxkW9UanM3NRZBytLULYtDv2loW5pSiCLKAY?=
 =?us-ascii?Q?k4FCCJcmNnnidlEsbio0Muq5dzVO5J45htlKAMf8kwffKxXnvYuos9Yi6CrC?=
 =?us-ascii?Q?+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7E6F57F7251573499EF347C582083404@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad991a5-f0d8-4e67-64d9-08da9cd1cad0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 19:36:49.0474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LLUz6vAHF6s1KTaMNqQn12hrBNQwWvJJcOkfkKAhvV1sTq8jguVjP2SSqSNX7Ydm/pSk1/IfTMiK9EtJzkkhNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9345
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 12:04:49PM -0700, Stephen Hemminger wrote:
> My preference would be that a non-offensive term was used and put
> as the preferred choice in the man page. The other terms like master
> will be accepted as synonyms.

Ok, if there aren't any objections, I will propose a v3 in 30 minutes or
so, with 'conduit' being the primary iproute2 keyword and 'master'
defined in the man page as a synonym for it, and the ip-link program
printing just 'conduit' in the help text but parsing both, and printing
just 'conduit' in the json output. At least this term has some history
of being used in Documentation/networking/dsa/dsa.rst, although not
unambiguously so. There is one paragraph in there which also mentions
DSA (cascade) ports as conduits. Though I really don't have any better
idea.=
