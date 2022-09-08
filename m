Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11965B232A
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIHQLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiIHQLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:11:10 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2040.outbound.protection.outlook.com [40.107.20.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1163137F
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 09:11:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hT3N3mapdpHh6Bcw761xfjjJ0fgaZNa22fvBQtWTCNhp7xg0/BfHwRkWESqu7geZCetjyKAnVBMwI/fwSUPP3bEhuLcqIpAqreIDPbkVXWlnJqwwJX+A7jkF0Tn7LLMJvpZwWEJQSD6qc9f6Ttiqzvr8STZKEWoPU6E3v8xpQ9SZHOG9IzCNuvc0jgiSPhT8BB1p2JNYk5caF6ULWI9qDL5yY3lmYx5/eow1C8wUAllx+PiIE8Y35v23L1uhbnzuonJD2aPvw9YaXyONc74k+faH047OaSqmDfsXyC0Basg7LEHBAwTfmWELdI6wUt2snsCYvr+NENNYKwhrqAHADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/T9L/yKkc1Z1bdCR+2+Xl6XS8GYcKrlUXiNLV65J9s=;
 b=ZHY++7QsXzbkW4v2ShJNz9PF3yEpxKHNg/Pz3Cf2WQAs1uh/AbmR58wFV9HexRKSS5Pv5M1WdWBzl17vWAqHluENujAMdVf2B2VJAi2xe0Fm/FXRd4akS4d1S5x4j1zRqdmNXEIv3dmJBVdlrYOPjqAwI8k1xQAJVFJLwZkHuHUtvv4QWReBJJ1fTfkpyQZ++qefvv29LlBiyTRNsutaUvb7zjI6kSIjvXKHyc7rPO97M1W1UI84eShZmepQeOhDTkc+d+tjfl2VHBahS3UrmkSGMBkrw1jsps8nFH1QqrSc5FVyadmJVSbv0clQohPPzcmRs2aiwY8X3Qeklbix7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/T9L/yKkc1Z1bdCR+2+Xl6XS8GYcKrlUXiNLV65J9s=;
 b=qFE11tAEqm3s9MUtHP43jdV+FfUYmVje9nN6DJNbPewpWuO0ROxQ4JSnQxIukl2fzbbHdCdScJfWGgGnPnrgBtQnKTU8fAJdy9qneICcKzmPxLi7aKasq0aDeU76WBDGxv4LZlULGMHKti9VRT+e2d+s+IvCQakkOsp9uLrTCCE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6954.eurprd04.prod.outlook.com (2603:10a6:10:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Thu, 8 Sep
 2022 16:11:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:11:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     David Ahern <dsahern@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Topic: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Thread-Index: AQHYwJCiMb7bHcv8sUSdQE+5fVlfzq3Sia2AgAAUKYCAAAPqgIAAJryAgAAOdoCAAAetgIACo56AgAAVi4CAAAS7gIAAHYwA
Date:   Thu, 8 Sep 2022 16:11:05 +0000
Message-ID: <20220908161104.rcgl3k465ork5vwv@skbuf>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf> <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220908125117.5hupge4r7nscxggs@skbuf>
 <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
 <20220908072519.5ceb22f8@hermes.local>
In-Reply-To: <20220908072519.5ceb22f8@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba6e7827-7e92-4c94-12d8-08da91b4bb77
x-ms-traffictypediagnostic: DB8PR04MB6954:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: caM4x4ek6i7gc1eju4YTLm+yNMr6mh7pidrjbgyf0GXWy0A6F7rknckdbwkQjyXCKdCHVb1GJrfssijSJRv01b8BsBCtn1xSGnaYuAMB/5EQR5qS+NFJsoW3U5pgeBbkh38NhlXlNBZ9h2ae8m0WFY70HrsTlh86f5RXEHo0gZRpWF7Sp7BYJM2lCftfZsltvdpcawnLuXtWbHr3/4Z51ATpjA0rppg13vjoHkJhfK/xwusWVcqCifJodGoWC5ds9kWcHLOqLBusy2HiStEZlwaVSJiWQyxJ5NY0LLDGmy7T9UzEROeRm3zZtywlcbtXkbFIBS80OD7VTK0d1XqmeBgaaiezp4F3KHTuuCpJYJlgefiupFiwp4QNg0rxrGSc39vvvYuBlRAnT8UInIx4LIg4Oi5B+V0f2yBSnDmh29H0GdZMOMpktxasN1SscDHoLxu+nhcwQpdLHH0ZqFzqAhti8ghE50vVxVWsWZHxNdEx859Buep9iD1L5b/C97xjopPVmaixY+g6ogW13uTTl/nmE/7JDQ3CoiW+rQ+kffkuHuTsIyWzt7fCIyugtZOcm4iPCBPq+oyK9F/ouLvBx2EjBf17ivlHbxRvfyzI7tIm6dImcO8zNqR7IIQY5Hng3iJmHQy4pIGRpwZCy+SuvRwaqy5q5QUlOCda9UqjR6O54Ulnio9hLaBDz3hKELm7gXfGM1TFtLmQKVkbdiZJeXJzy/JOkKw2J9UDOkCYPe8uwHKSxRyTKTG7lzUjWU8STNhz33avflO/a2nZ6/4OVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(478600001)(38070700005)(6506007)(26005)(9686003)(41300700001)(6512007)(186003)(122000001)(38100700002)(33716001)(1076003)(8936002)(8676002)(64756008)(4326008)(91956017)(76116006)(86362001)(66556008)(66446008)(66946007)(66476007)(6486002)(2906002)(44832011)(54906003)(316002)(6916009)(5660300002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sjoeWZlJl3Mtv6ItOL+zAeJFX7eS3KoHj5U1ExJvcjfB3SB5z685HDAInBTk?=
 =?us-ascii?Q?J5lUe7yk6ZIVNhJzMeqVUX3H76UrVsMFl059eQ0lxMFStMth1GgHQeQWn4Vu?=
 =?us-ascii?Q?UA5UIVa2m63trlOGX9rHl99zra4wQfQHi6ZFjDhhZVTnYj9UUYCHAdfVSS0v?=
 =?us-ascii?Q?EgkWtVsGgRPxKM3UNpTghLUJLKx4pOIvuZ44O2WNgpxh1IqcNm98CsIFsYvG?=
 =?us-ascii?Q?e2u33wAGt829KJL/SI83WToJVigG5t/PU+aNV1ijj+slymZkJLCnbj/U5rnj?=
 =?us-ascii?Q?Yei5Qx/ysJTu75se8RlI2pzH/j22dNPwl6oXys3zw1BQXLv/T5voWkR5LUef?=
 =?us-ascii?Q?V8ccBUJstUe21pwXwzdW2/BmygCeemvYbK7pB3W/GsM5W7WjznsZYSsDjd+y?=
 =?us-ascii?Q?nTfFfw622oiNxeIxXYPByuLQXpTMCAmU8Ni6DKKMEnxqwTOA7/A2PTHIfG0L?=
 =?us-ascii?Q?UGO+iXSqVbKChF33PVt3j/eQjjTh1Df2ip6CBfJ4lGwF8WtD2YvHCdPQwvhr?=
 =?us-ascii?Q?FcRn9pP8H94fFKT4lAhPxq6l10De5HOtSYu02NGuS3g625NbEErmdj4sE1bu?=
 =?us-ascii?Q?BooRpmpDfJIKWa+UWW3QX/OUZH3K3nE8qZ6yp+CT9wEa3UG+Boc2UBRt6Plh?=
 =?us-ascii?Q?eipJRaJ+Ooax1OzwYmbd/7Hb0qWOwkqmzyKg+01As6g9fXjqfjP125fYd3Ev?=
 =?us-ascii?Q?Mgy1bdkpf6tRzbqiQNBXcBgccmwmhi85lqLkXfAWmoU5P9M/zHL01GZ5Hk5w?=
 =?us-ascii?Q?1oC2X7FAPA9OD+EMr5Uiv5ubAXmnGro2RUrKDeyyTPpNaVI+F+Kdf6G5EpvG?=
 =?us-ascii?Q?PzLMN1xCgqqoFBbPy1aRmHixXx/qjOc+A0Fpxvk94WwxzPdW4CpcUWq++VRa?=
 =?us-ascii?Q?X5fbppVWYR5uTLSqCFSqUSeJcZfFZXzW6I7pdzk2vVp2LX0I2F5zPiTvpeCx?=
 =?us-ascii?Q?Qvk330o5Rbz+B/M7LtOPS+3jJ6wnokmpODtmDRZirPGC+SGFvY7xfcipR0QJ?=
 =?us-ascii?Q?ZcAKqSPGLGHhqh/soKIPdiKdZ67BCyQLrTYNxDmRYSv1hwgqRVxjC2MZL9Wk?=
 =?us-ascii?Q?1A6TNT2BTDexSOQ5uejx135KOjB/k9vA8IgteoUEPU6JuPQH/vTnV0E/mwnp?=
 =?us-ascii?Q?cAQL9as2U8Kqmh6ytNWdowICuuwQ87IHGipxn1HKszZoclCf+gEh32LpAscu?=
 =?us-ascii?Q?nYkVVIVhmHgGTRv4RIIf4E/RTFysNyiI5KYUV11IbDSnR9Lg5hve4y70KEag?=
 =?us-ascii?Q?9950wkY1Ma0Ztv9A2tKpFmXX/BBFQW9VfzPvO09JAJT5HT70AjGF2r+onmb4?=
 =?us-ascii?Q?xYkSM0tsVbU1xItabzry0pYuM98SY5V47lt51LZ1w8AdCavy4WyifDDnA6UO?=
 =?us-ascii?Q?eRpLPcFcQRAlZPRn27po41ARMec2HEyaH7hJakvDrlWtQQ9K2JsxzQeXKFcF?=
 =?us-ascii?Q?tqjZKhIJNDQ+AWfAjVlTFi6FhqDrPfXpPwthqgYRBnWwwURZLA6P8aZZD3eW?=
 =?us-ascii?Q?/OdXBwvfYDlFbbSYpIo9cohapxmO8c6PX10F3a4W/0Ihk0WOx/bCDns6m/vh?=
 =?us-ascii?Q?ASJbCD6/6JLS2m2nqfZV6+Oohr0Z2FUqEfHFpcgxFCcchy8qt1h/sfi0BZUI?=
 =?us-ascii?Q?7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EFD11805193C5E4DAE9B28B81E737B62@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6e7827-7e92-4c94-12d8-08da91b4bb77
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2022 16:11:05.1005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U6LaIZGwWkEDpD3CKwwiNwl7sfR2GqHEZ9+Ek2ouk0EUkpbXAZaBu4kWUa+V2B9GgxNTnWeC1Aj+7HD+i/4k6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6954
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 07:25:19AM -0700, Stephen Hemminger wrote:
> On Thu, 8 Sep 2022 08:08:23 -0600 David Ahern <dsahern@kernel.org> wrote:
> > > Proposing any alternative naming raises the question how far you want=
 to
> > > go with the alternative name. No user of DSA knows the "conduit inter=
face"
> > > or "management port" or whatnot by any other name except "DSA master"=
.
> > > What do we do about the user-visible Documentation/networking/dsa/con=
figuration.rst,
> > > which clearly and consistently uses the 'master' name everywhere?
> > > Do we replace 'master' with something else and act as if it was never
> > > named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_PORT=
 as
> > > UAPI and explain in the documentation "oh yeah, that's how you change
> > > the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MASTER
> > > then?" "Well...."
> > >=20
> > > Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do we
> > > also change that to reflect the new terminology, or do we just have
> > > documentation stating one thing and the code another?
> > >=20
> > > At this stage, I'm much more likely to circumvent all of this, and av=
oid
> > > triggering anyone by making a writable IFLA_LINK be the mechanism thr=
ough
> > > which we change the DSA master. =20
> >=20
> > IMHO, 'master' should be an allowed option giving the precedence of
> > existing code and existing terminology. An alternative keyword can be
> > used for those that want to avoid use of 'master' in scripts. vrf is an
> > example of this -- you can specify 'vrf <device>' as a keyword instead
> > of 'master <vrf>'
>=20
> Agreed, just wanted to start discussion of alternative wording.

So are we or are we not in the clear with IFLA_DSA_MASTER and
"ip link set ... type dsa master ..."? What does being in the clear even
mean technically, and where can I find more details about the policy
which you just mentioned? Like is it optional or mandatory, was there
any public debate surrounding the motivation for flagging some words,
how is it enforced, are there official exceptions, etc?

In a normal code review environment I'd be receiving feedback and a
concrete suggestion for a change from an actual person who has an actual
issue (theoretical or practical, but an issue that he/she can express
and stand for) with the code in its current form. I would not be expected
to act based on something whose fundamental substantiation is hearsay.

In other words, you can't "just" start a discussion of alternative
wording, without actually going through any of the specifics. Or rather,
you can, but you're likely to be ignored, just like you would have been,
were the comment related to a technical aspect.=
