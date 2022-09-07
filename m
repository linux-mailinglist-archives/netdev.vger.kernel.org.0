Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2382B5B0202
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 12:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiIGKl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 06:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiIGKlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 06:41:24 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123095E556
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 03:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662547282; x=1694083282;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VQns0N2DwQLaiYS3TdvKQP5zOhhev5kZNcJwk3faEjE=;
  b=TJ0esL3whFGw7CNqMJ7e5fIzqFnc3Z/y0AaZlB4aXAUdf2XlYr8FbhkP
   YBqJuDUZ42FMJ2CND8mwrWTwW7YvLbuHSqPLECxEtoUKh8d7ooDOA6qCX
   BDN7TI1C39ynfAo+qI3BlKl3bpIKbXhQQswgKseJwBWoKjiTAH5awsp1Y
   AnadHzc8YouUk2oiwHBy88rrzaAbJg3pe/hzDxe5/hvXsFqiMZ5YhW2wM
   XY1NRZPfqmBvXjApdt7g40zb4FIwHhwOSc7MSSEuN1uPK68VurjN8cLcX
   GJNdb+Sw+6hCZQquiknyaO6VIqapkqpdkt+rzwjzjhBGiOek1SjhEHHN8
   g==;
X-IronPort-AV: E=Sophos;i="5.93,296,1654585200"; 
   d="scan'208";a="179503107"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2022 03:41:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Sep 2022 03:41:21 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 7 Sep 2022 03:41:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8PflpPcMlrl13RPITwyYqNqcM3TaihnlA/HT7vC1hxzVXPJN170ETgUuIjf9nLhz2uQFQeNesjx7ujcr4wxz9kdQO1hBeSXyAR4vTx5u2AicYq2rVTDKuQu/TnFPqjKXFFAFAqmdPm7oS2TfzD232SAwQzRVq96OBqDLTsL+x5ZaSv4SQkMSO6ZNapQynpZHaRz5MgmnJpVZX/Zi9rksB5Jc7+ogYZDnuC7T7Kol1b9ycVTQ8vyYQCz3rw7qBrhEMz2jktX1IUfWNRpT24ON+D/hVQotbD8XWtl6JDqxA8JjqzoQReqv1iQx/H+SWqvIXWbiim4WNe5VZJ7FXKx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQns0N2DwQLaiYS3TdvKQP5zOhhev5kZNcJwk3faEjE=;
 b=QpO0amoMr/SzLvD7yGx9po7d6g8WtIgObDDnlAHzvjESH8XOV2eqM+eNBJCxyPUl/NmuyTzxv7017cNhCrxb9zUXU6PlOr1XMkA/2aK/DbyTmqrwiKfD7HVFxopzhp7U1yYrOjCI1H2RQICcT7PQVNJjTcYqlDkEWeBpw7yhXiRu09XbccKrldaUL/iwbjLgL0a9Ne4SMM2/Hh/zVG8vEQLO1G3cKns+fP2UFlCOjYn81x17aKy0fvRhJQJGss7auz9nCVh93vEvoCrLAg6zJ8biw/ma2UVvxUoaWsuwM1MS6Q7wr8zd1hUBCf6c+YZjBOL7TJJe53frpXYro2KZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQns0N2DwQLaiYS3TdvKQP5zOhhev5kZNcJwk3faEjE=;
 b=T6atE4qnJQZzX+mzOEDC0Fur+1963m5ZpuoMIL/MgatdbUt9lJMu9xVPwAKNr3+PVFbmctf/IsF2CiSr6tfIPTjmcJYy8+LarOc8JXPUmOtm8WnPwCeWr4WW2TXFzO0iiwTbsxnnvdUHS6jUQbdQ8MrKH8675PHe41lKAwQPOgg=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MW4PR11MB7007.namprd11.prod.outlook.com (2603:10b6:303:22c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Wed, 7 Sep
 2022 10:41:11 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::b082:2b7a:7b7:3c53]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::b082:2b7a:7b7:3c53%5]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 10:41:10 +0000
From:   <Daniel.Machon@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <Allan.Nielsen@microchip.com>, <kuba@kernel.org>,
        <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Thread-Topic: Basic PCP/DEI-based queue classification
Thread-Index: AQHYs6to3s1IQsOvq0mxCyeVWfydNK22C7sAgAPQsYCAAOG8gIAC9iEAgAAg5QCAAItKAIAAGesAgABY2ICABr5YAIAGp+0AgAeuXgA=
Date:   Wed, 7 Sep 2022 10:41:10 +0000
Message-ID: <Yxh3ZOvfESYT36UN@DEN-LT-70577>
References: <874jy8mo0n.fsf@nvidia.com> <YwKeVQWtVM9WC9Za@DEN-LT-70577>
 <87v8qklbly.fsf@nvidia.com> <YwXXqB64QLDuKObh@DEN-LT-70577>
 <87pmgpki9v.fsf@nvidia.com> <YwZoGJXgx/t/Qxam@DEN-LT-70577>
 <87k06xjplj.fsf@nvidia.com> <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf>
In-Reply-To: <20220902133218.bgfd2uaelvn6dsfa@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|MW4PR11MB7007:EE_
x-ms-office365-filtering-correlation-id: 08b1fd25-74c0-4cbb-c629-08da90bd7ab0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CO8LTB4s7TQpiLy8QZfJnNtsUCguvTTIudGGssSxkYWzMS7Kv1PI/jTjj8C/LuRvkFW/TxE+ySCxGcLFKG0BCYdlJ106+a/VBfYofej9U1DQAzGB3yeCQsL0IvRSBu1AqzrFQgLk4tSje/ZzW77RxIdP2o1EzADT6myLljvtRQq4XA7UHeQaUEAk4z1R8Mp+py/+oUmyYQVjcmp2lP6Ch87pzFbU4N7HUUL93DuYCZyxLZJHIYkbSQbNfuEMlOIOQVDiO5I4hjbgncghssnGj6QgcpvDheMd3stgRI1/uTXY9nlY/7yNxqC2ADevrKuvILosIGJblkSrhhaJAFAttpN9+nlPxC5M+FXFZb+HruCHslrtsBOwJjJxO9D3CSSN4dZDJ4xJW/CSrLlEXHKlCEr5wY26eWut9NHhADicPERkPB5p/0l6siuVqehNLkOzr55/Bf7TebJwkkOLkInAMcB68v2OpJS3s8OFNIIgvwYpgOZv25i3JUj4Xs1Kn1jdZTuS5Gi1e6QsgzM3O/R/CDmZ1qQ6QFstn1Ti3pKHpHG6PhHOUxhwjNa38WkBOkRW7XJOcjmrmipa28zBiXwy+4MI7taddVdqV+podlCpJRJV9NpQ0gLIeCQ46o7z5PVNkkHDe5z0ZM/lFZhM+hvgkj+sjeLD7Hgi+/sleq/+sk0YvlFN566VW91EdmaNicJkMoqh2mOU99k+mF5t3yv8M/0qr+Jw6BmP+jfoEYj6lh0QOqBRQ7zRsQ6F+RWNisI0ZC5yIiyPdQZSwg/DGSRrPTJrYgWcRhY4gRwZ5Ra90XI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(396003)(376002)(366004)(136003)(91956017)(316002)(122000001)(38070700005)(86362001)(8936002)(76116006)(38100700002)(4326008)(54906003)(2906002)(6916009)(66476007)(64756008)(66556008)(66446008)(5660300002)(186003)(71200400001)(66946007)(9686003)(8676002)(33716001)(6506007)(478600001)(26005)(966005)(6512007)(6486002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7p1tlJ+lcmAzV7rXwTk/RA6KeFR6uFgcjWiwz7Kqdy0cIr/EPu0xx1enx6+R?=
 =?us-ascii?Q?SMFrbpuXETjzLt9AMP4EEKFus1zAKMRTzi2xvIGySjFtV/eJK4cnwmHiymbK?=
 =?us-ascii?Q?NnkJQRdXniRaaIAOeJh9BMMnhZLgOF6fkhkVKPkjwN55AXrzw01IQLJJj39I?=
 =?us-ascii?Q?zqdyZKZ5yHmXjWJFxirRRzo0qFZH46U88BUklsOawsUYMiVe+LLRy3n3Ty4K?=
 =?us-ascii?Q?mEG7U9nBckZ/slhWOyvbHT6zCPPCbtttEmPlDZakwmtqFuwm/KOcIv9uAdfi?=
 =?us-ascii?Q?bjqowdciAw6LxKnkVr5p2+sarS7AifUGMJHtvMhEm1BKvBlle0OocPVl6Dyf?=
 =?us-ascii?Q?w3FfqVZjmk9qs6EfhDdYPUCRso4NBqX3Yp3fqFuDHwyUTVPegmaErY55FTdd?=
 =?us-ascii?Q?tUFSXxa9Vqwz3hGrSEl1qXna+WDGT8UA5JqhHFcaXyWFHGsS/9olga5ihXLN?=
 =?us-ascii?Q?kIJGBt7PwcSAT7iaHpPS9o7f1lCTqwS75mB0/Bs/6A5NbUQafjfD+RLuxEAa?=
 =?us-ascii?Q?MBe6WjjGOE76TltLadRUEp8r3EnT3sBgWvELY7wIzMGgPM55HjMUpjmBxZA2?=
 =?us-ascii?Q?B6KW/5TCaRH4brNaMSLzSsXz06mMlxLFG2mU3HP0kapRJyD0Hlx4LgZZkfKi?=
 =?us-ascii?Q?pRW8AyPMfqEZLj2fvRKuk8IzC7UtMX8mBE3A427D9P+guDsk3gFIAOUEnKSK?=
 =?us-ascii?Q?xrioyI9wSWDv0Sihy/IllRYdUpwhHQnUXYadNfgoZvLwhzrlaK2qVXhjNdQC?=
 =?us-ascii?Q?XWavvugl0ymWSO+mrHVXuDxPtpgl+rRAJ3C2OgtFTZ1RKnez4/ivhVdSv7SK?=
 =?us-ascii?Q?NumUi6zrcUsFzaPoQ+6pXQDLOehLmIQkR0HVrBBjpDMmnYgJXLGKwv27wt5S?=
 =?us-ascii?Q?XgGNIEKgjafB9662Fazk+YgH8yL6Jkj5+4ZmMM6Drqo7tzcu1pV8ohVffLhq?=
 =?us-ascii?Q?p3X9zDxmfj4e6ssGM07epEKVA4vo55Kzr+PqZS6avTWJbzSDas4pn9o3zWpb?=
 =?us-ascii?Q?dWqNpAESzZmuUpgjjVQEHk9BpOPnyPs1iPE2kRZGa1NrzOuCXaP7wPb0Cl0Q?=
 =?us-ascii?Q?J/2jYF5PmNHH+NN8AC8CJddzmpdCZseUiR8BzoK81rCPtTjtaRksJzO4vz3b?=
 =?us-ascii?Q?Hw2fi7B9+IOZYzTq0DYGK1g8VGn01ImNfrSi7DGNcVeqsDMVzYXN6AehLzCL?=
 =?us-ascii?Q?QK8PkqabCzb8+/3aCNm5mq8jlm1wVLIdXHTA8cfJAGobhUJYsHBHibZMp+hf?=
 =?us-ascii?Q?YDDiirydBQWVD67xqZOZ3+WiE8cIikvPKMMkIqezHDWUzv0GyrcceyrmkHhn?=
 =?us-ascii?Q?RslEHhsWCqVH8GylAsmmgYc6i5XmGdHnKlgyoq4GNosTFToedG0+XCOeJD7v?=
 =?us-ascii?Q?6r+uEho6MNJdikH8k2YFL8cJSEI6XjuValS5j0lO+yB5EFeqsLfJHQvgIpGm?=
 =?us-ascii?Q?YHfMhdU9HXlAsU+3xjosfSAnBpUZRySYxYpGc0zwX+mpQCuIwFrG1KGu0yIH?=
 =?us-ascii?Q?vyoALRQ03N9ju2CNmtQax4vg00yBR96Gv+CzKpsPxIBxFDD6CQPFWW1pRLdP?=
 =?us-ascii?Q?dyrtDFqYM/J2vl9xg0a4v90j6jbFxoQYi6jUb0ZpkX6LEG1x1b2Rj5zQ6Ywl?=
 =?us-ascii?Q?bqF9QF2SSug1xuD0IpWMdJs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D1D1493420BF643906066EE19997424@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b1fd25-74c0-4cbb-c629-08da90bd7ab0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 10:41:10.7658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9HFLRqivBFEUXIFtmPpmoFZ8gK9VsiYevYmUSrh+144/XrJWwe24lRFBQ44VhJpOYI53JI6A06LgsZKrG9xemBlVYj+V4nRzmQ1gyjTOKsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7007
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I think this feature belong in DCB simply because DCB already have the
> > related configurations (like the default prio, priority-flow-control
> > etc), and it will be more logical for the user to find the PCP mapping
> > in the same place.
> >
> > I think that framepreemption should be in ethtool as it is partly
> > defined in IEEE802.3 (the physical layer) and it is ethernet only
> > technology.
> >
> > /Allan
>=20
> My explanation given to Jakub at the time was that I don't quite
> understand what should belong to dcbnl and what shouldn't.
> https://lore.kernel.org/netdev/20220523224943.75oyvbxmyp2kjiwi@skbuf/
>=20
> From my perspective it's an inconvenience that dcbnl exists as a
> separate kernel subsystem and isn't converged with the ethtool
> genetlink.
>=20
> Regarding the topic at hand, and the apparent lack of PCP-based
> prioritization in the software data path. VLAN devices have an
> ingress-qos-map and an egress-qos-map. How would prioritization done via
> dcbnl interact with those (who would take precedence)?

Hi Vladimir,

They shouldn't interact (at least this is my understanding).=20

The ingress and egress maps are for vlan interfaces, and dcb operates
on physical interfaces (dcbx too). You cannot use dcbnl to do
prioritization for vlan interfaces.

Anyway, I think much of the stuff in DCB is for hw offload only, incl. the
topic at hand. Is the APP table even consulted by the sw stack at all - I
dont think so (apart from drivers).

/ Daniel=
