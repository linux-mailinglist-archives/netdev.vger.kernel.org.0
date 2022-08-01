Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B20458747E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbiHAXjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiHAXjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:39:03 -0400
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514D44333C;
        Mon,  1 Aug 2022 16:39:01 -0700 (PDT)
Received: from pps.filterd (m0209319.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271LhDtn000747;
        Mon, 1 Aug 2022 23:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=DkTRz8HLQiqNDfmhw92DtJ4SNpiIcdaqchMcITmJjxM=;
 b=o8F3qzIJiNL0kxZzmd/Kd3rVTO7r/s+xQtso1XPgo7L/qAOwQbpkye8PPOww0SLKdjzO
 SQeKBfmAKy/PpKko9rlaYJaUPMUgvZCmvhvzrzJBaSuiERvdMsEhMf/M3qbXbafNXhkb
 X86g2gp0GAmiGf66gKagaohR78yQxgBYTrXx2XRnMHRV/L/PwIY2MXudi6mONNopgKxf
 UOCNWbkp4J3N7D0+ksZp1oVYnd6fgZxdJye5BCtBm4fyyTbPdTge4wlNN8tPEsFjaO4l
 HywwYmd+KWw5VRh9k6a5RsTZ8iHLRqUacFiBjJj5OvL76FL2RikL003GopdF5Ab7JAay xw== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3hmw1rtbhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:38:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0ZQV2u73+bwuKvZtRBcqXtXA+iwjzKphWWLD/iY0Op2zeSKP8W3/4ZsnPLu7H3jVDA30Ci9fZHFlApI0sJAdH5nuxtNi37/hhqUncNrrJbBE23pBxPVgx5Ao6vKv40puPhMXwm68KKBqmnyEgHwJvqFUxZYrswocnOCe9kKHY9YBaeqA5txfszJ961+Oq5kk3O6M72d+zjX/+8FM50CqvWeV1hxuT3ZbzwNRYcwPi2kILk4D6diA/HZ+xxDg1G8iA8vIpkvmnrGKz7Rd993DeOnpsv+rMfZUDqn8UoBRUK7sLQF7wvR6O/hhUoC/4Cc6FnghEJyOoKG3SFwOwcWwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkTRz8HLQiqNDfmhw92DtJ4SNpiIcdaqchMcITmJjxM=;
 b=VTRFVou45iPctgN7R54RAQbQGoQok53GY2mwzNmoxXa3vfIJFKPFy/hvHKYUoPtsXYrzq/jC4Pi2VOaOQ0lqQ1S++0H/+gsLI8OGgnu0hNvBVQV8hKqnG3d04m91AB3h0azzuB2PrIH+beAl1aTyYgQEWw5LvE3LVr45A+y6sDrG5JAPcKT98tY6sfa3wcD1Hbvv5GJ4z8v4/47l2MWgfUScnn3H1XsK/bXIx6YCwbGIczOPkdjNTIvNwPrmppUIJqkBGncdAsEMu5D6aBd4bOlkj6gTT9ULCLOnH7D6nXcQUSiZ1qdiskN0IyNygvZG8BLZL6Q+sfkobIWqNkk9xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from DM6PR13MB3098.namprd13.prod.outlook.com (2603:10b6:5:196::11)
 by DM6PR13MB4539.namprd13.prod.outlook.com (2603:10b6:5:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.12; Mon, 1 Aug
 2022 23:38:14 +0000
Received: from DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::d6c:e20c:1f5c:992]) by DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::d6c:e20c:1f5c:992%4]) with mapi id 15.20.5504.010; Mon, 1 Aug 2022
 23:38:14 +0000
From:   "U'ren, Aaron" <Aaron.U'ren@sony.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between 5.10
 and 5.15
Thread-Topic: Intermittent performance regression related to ipset between
 5.10 and 5.15
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9azBu8uAgCjylwCAABPlAIAkPh0AgABqshCAKHvIgIABK1GAgB9noQCAEDSYyIAAN9SAgAMd64CACZB8jYAhB35ygAD01YCAA/bT6w==
Date:   Mon, 1 Aug 2022 23:38:14 +0000
Message-ID: <DM6PR13MB3098E17D316DC69F0148189CC89A9@DM6PR13MB3098.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
 <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
 <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
 <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
 <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
 <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com>
 <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
 <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
 <871bc2cb-ae4b-bc2a-1bd8-1315288957c3@leemhuis.info>
 <DM6PR13MB309846DD4673636DF440000EC8BA9@DM6PR13MB3098.namprd13.prod.outlook.com>
 <20220630110443.100f8aa9@kernel.org>
 <d44d3522-ac1f-a1e-ddf6-312c7b25d685@netfilter.org>
 <DM6PR13MB309813DF3769F48E5DE2EB6EC8829@DM6PR13MB3098.namprd13.prod.outlook.com>
  <DM6PR13MB3098595DDA86DE7103ED3FA0C8999@DM6PR13MB3098.namprd13.prod.outlook.com>
 <23523a38-f6f2-2531-aa1b-674c11229440@netfilter.org>
In-Reply-To: <23523a38-f6f2-2531-aa1b-674c11229440@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cc2e0c3-b078-4eca-637c-08da7416e740
x-ms-traffictypediagnostic: DM6PR13MB4539:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TVbOdQkPj0rNEOpS3bfLKty0p0b2Gte0b2+Rh1T08QXvolaAueqTTWjNNOLpLorDclZsp2idIWQbedWvVL1KGBfavyLg672WBrS4a9IDt32kkUPU3LyWPZPBVvx1TpYdYC5vS8vLEyorsL/eGp+rZRAD/RET43A/1/30SQKM2M/HU6+jbbdXr+yGLlcRgSDfHuvaNXEdkvmzby5l/DnOOvHMfdFS0W4rGPvHcU9++TjNyv0DYcdRrpWtLZ9jZFnRVl3x4tR2QPiau7GRFUPr0JtRUBFF42te98EUOdj3OpWZAxBqtjcAj0ZVttHiGjD4X7BDNKTQDYsl3y+u1Ip+I6u18C+breUGLwPf/IDbBY5712/zEQdq3sW/ttn2/UbCt8T0OEKf+vf9A9PfkVXvzP/ebXONed29iuhELKHa/NQ7KQBsP+xIBH8HqA8Pawt74aA4+HgpWLoW348ceDmmsN5P60hskKU9j8YhJ6PByldsjT/7rBhkEYMrASNLEjfFUjqLZ2paN8Z4Ca4hGKDUtGgVjOwwkSyRZxr5WCkIQNH+p2Tkt9gmdTZscGT8iUZ+vICkm82K7FDvTlzhGvxZGbEWHLYI9FQ1ktzMJd9F0qYKTpS+f5dgt/u2fqTLgO7UvPJfjoJTiJwYJbu9Ax7iMhXmzdkQRyz3gTM7XbAr0avTrMc9uOSBE6jmcuhca04XM5/fvM6GBO0eqzE6hFAcYlsh7laDmISSLLEf7zIDU8y/9rM2GHb+ylLagf9juVK9xkW+N4B0HVOagGvXEmO3JirPN6Z7UvNf6relU52RFHpkBIBsgnmnoRTcNJyI71/Q5ItRBKLqImNZ42+eTpaJOnnwW2z/EEfgBPOJulbI4ysyljx5MW81FMB7kvEpjU/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3098.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(478600001)(6916009)(966005)(6506007)(83380400001)(41300700001)(186003)(9686003)(26005)(54906003)(316002)(7696005)(8936002)(53546011)(66574015)(38100700002)(8676002)(38070700005)(55016003)(30864003)(52536014)(82960400001)(71200400001)(4326008)(33656002)(2906002)(66946007)(122000001)(66446008)(86362001)(66476007)(5660300002)(76116006)(91956017)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?9mqens/E0PmBFb2ahCCdQh394jahwyDZDsXH92uvTZswF3WwXcWmC3I4qy?=
 =?iso-8859-1?Q?KUMcaXYI5vvUC4F2DZoXZdcb/yHJ2hjf3+0BUgqC15laOHdYdRNAtY85C7?=
 =?iso-8859-1?Q?B+69kvRspg0tHT202QcEmkAy+CPSNkZDmFlfoDdGyqE8OAw/ub1JTY3N4g?=
 =?iso-8859-1?Q?N0Xxm/J5kNHNyp+OpRsYsrO5EFiCjY1ZDgYALRBR+ymZ4G1m/27+bJJDt0?=
 =?iso-8859-1?Q?alfHoNpaan/dB5nb2uRqI/1xjOO4tvX6YopSsG8QVIi4ez7nqaE3dQmnJT?=
 =?iso-8859-1?Q?DuN2U7cnzmkPVe7XXgfLsBqdxskkhopDMnTh/Pq9Yk4VdfmOY9VecAIhP4?=
 =?iso-8859-1?Q?IxkRTYSJncwjoy5z7L45IdddwFc6TiZFDS5yz2ioh1rmWMCON0ilfmuLwq?=
 =?iso-8859-1?Q?CeBwjwcIWpB/TcxqoDp95jmPgtt6ix56dcGIcLMkyIcFVPvtg0agMulMvX?=
 =?iso-8859-1?Q?VUufKsJW5HTP3tIrGkg0sdoMZDlMdmHZZq9MUNu7EXPZfZlgAL2ZYZjiOp?=
 =?iso-8859-1?Q?m7Nbu6X8bf4ZbdAadHyfnmwdYzxgKpiL9K5B72k7cSP/DZwkfsDGcRU+nl?=
 =?iso-8859-1?Q?JVHxkS2qH52leNoxn+7BwTg0ava02K4l8qRPhHpsTCjnZQkQXCTjAXMZvx?=
 =?iso-8859-1?Q?YcjJOjEJzgNLNT8/06Wp+rzvLIbUQZQib2ZJH9gsHEwyw6Oc/FCO7P6JHK?=
 =?iso-8859-1?Q?nrWAtTXiQOlnl+UJ382PlWLsUMEh+1X6e5CqU6cYLGpULUXdLZtlYHs6QS?=
 =?iso-8859-1?Q?Bs+uCF4qRlXvlEWfOAJgU2zIBFMSnIKPgT+eNyNcGXpvRcdoDlwBdThKOR?=
 =?iso-8859-1?Q?WP0BHJtVS1jyP4h3YuzHk7WhdC3yK3VWFgQtP2DJgitySL9a9AIMA2Wmr0?=
 =?iso-8859-1?Q?euRHvytk0zW9uPDRTgnZxEPntnZl6RWaCj/rN1JC4N1T16Y+pS/tGHYPJS?=
 =?iso-8859-1?Q?iiC0rH1pKrzGY2UXJTFXN0/v5z1WhutSZPbcmXYvMF0DNTYpAeDk08CCOu?=
 =?iso-8859-1?Q?A0zVSzppItrAEs93Texgp/kaLev1stB5rt/t9DH5ncJYtaJk5rdyEXwwK3?=
 =?iso-8859-1?Q?ctMEvDb/dHy97y11W5qCkGFyROK06NJhBJBB569osZo+FRA1O328VFzIOv?=
 =?iso-8859-1?Q?qRWzYl408j81dumOh2hxFOKjaJ7Xq2AEIm+bntxL76Ccqa6Dgd0yUDlLo5?=
 =?iso-8859-1?Q?IsyKg7NoVf7PK67Xe8x2RcU//7uQO2csK8hfZIyrlBw/RWdyNCzRWOOuJ/?=
 =?iso-8859-1?Q?DUGOCqwtEvxOs4LGrFjn5iMic7WJ0TCIVXhugknD02iINEYH2xwOd8CozI?=
 =?iso-8859-1?Q?vvRIlNZ99+zka3I5CbU9DXQwL7QgveG05LTuxPZGMXQ511RxdW8CXAGNfc?=
 =?iso-8859-1?Q?ncZZeyS/PfazfOjFkBd+sP1GCGkVbQI93zT8P05coNuKDmHnf/ITk/+njo?=
 =?iso-8859-1?Q?xmVQwMLGibrDTPvk3saMBacPuXazgHkn4ycf/sAvI/6D81WO0310xyC5WC?=
 =?iso-8859-1?Q?1YkacCQxHeaMTIxyV1nMSWp/WGy26USobxIspJCD9EqrXD0gkkSmyxIT7f?=
 =?iso-8859-1?Q?hmIRvyilJ87NdGxRVV41ddbsv+sdW0VPpNrjiPnGpXZC3fRJO+Nyz9zE+S?=
 =?iso-8859-1?Q?fetRznu10By7KD3OsJffl+S2KLqO6g7GqSPp5U/W23EDZs9elXVMC+vQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3098.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc2e0c3-b078-4eca-637c-08da7416e740
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 23:38:14.3893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pSmyT07Oll1Adv2eBD1HKHBYPhor2wmAP52m069sDbIllQShYXo8H2EJYHxO3o7RmW0cCpK922sIXF4Jwk/N6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4539
X-Proofpoint-GUID: bYHY_EBgHW5HkJuMZxwQmLH1Kd9LAwPn
X-Proofpoint-ORIG-GUID: bYHY_EBgHW5HkJuMZxwQmLH1Kd9LAwPn
X-Sony-Outbound-GUID: bYHY_EBgHW5HkJuMZxwQmLH1Kd9LAwPn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=APOSTROPHE_FROM,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jozsef-

Our end solution was to change kube-router to ignore initval when it parsed=
 the "ipset save" output (https://github.com/cloudnativelabs/kube-router/pu=
ll/1337/files?diff=3Dunified&w=3D0). This means that initval is never passe=
d into ipset restore either. This was essentially the same functionality th=
at we had before initval was introduced to the userspace.

You would obviously know better than I would, but if I understand your comm=
ent below correctly, I believe that because of how we work with ipset resto=
re, we don't actually need to use the initval parameter. When we work with =
ipsets in kube-router, we copy the entries into a temporary set that is uni=
que based upon that set's options, then swap it into its final name, and th=
en flush the temporary set afterward.

Because of this approach to ipset logic, I believe that it should mitigate =
any potential clashing that might happen based upon name with changed optio=
ns (like hash size), or clashing elements.

However, if you believe that this is not the case, we could look into findi=
ng some correct way to save the initval and pass it back into the restore.

- Aaron


From: Jozsef Kadlecsik <kadlec@netfilter.org>
Date: Saturday, July 30, 2022 at 5:44 AM
To: U'ren, Aaron <Aaron.U'ren@sony.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Thorsten Leemhuis <regressions@leemhu=
is.info>, McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pab=
lo@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.ke=
rnel.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.=
rueger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.or=
g>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian West=
phal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between 5=
.10 and 5.15
Hi Aaron,

On Fri, 29 Jul 2022, U'ren, Aaron wrote:

> Thanks for all of your help with this issue. I think that we can close=20
> this out now.
>=20
> After continuing to dig into this problem some more, I eventually=20
> figured out that the problem was caused because of how our userspace=20
> tooling was interacting with ipset save / restore and the new (ish)=20
> initval option that is included in saves / restores.
>=20
> Specifically, kube-router runs an ipset save then processes the saved=20
> ipset data, messages it a bit based upon the state from the Kubernetes=20
> cluster, and then runs that data back through ipset restore. During this=
=20
> time, we create unique temporary sets based upon unique sets of options=20
> and then rotate in the new endpoints into the temporary set and then use=
=20
> swap instructions in order to minimize impact to the data path.
>=20
> However, because we were only messaging options that were recognized and=
=20
> important to us, initval was left alone and blindly copied into our=20
> option strings for new and temporary sets. This caused initval to be=20
> used incorrectly (i.e. the same initval ID was used for multiple sets).=20
> I'm not 100% sure about all of the consequences of this, but it seems to=
=20
> have objectively caused some performance issues.

It's hard to say. initval is actually the arbitrary initial value for the=20
jhash() macro in the kernel. The same initval is used for every element in=
=20
a hash, so it's tied to the hash.

Earlier, initval was a totally hidden internal parameter in ipset. That=20
meant that save/restore could possibly not create a restored set which was=
=20
identical with the saved one: hash size could be different; list of=20
clashing elements could be different. Therefore I added the ability to=20
save and restore initval as well.

> Additionally, since initval is intentionally unique between sets, this=20
> caused us to create many more temporary sets for swapping than was=20
> actually necessary. This caused obvious performance issues as restores=20
> now contained more instructions than they needed to.
>=20
> Reverting the commit removed the issue we saw because it removed the=20
> portion of the kernel that generated the initvals which caused ipset=20
> save to revert to its previous (5.10 and below) functionality.=20
> Additionally, applying your patches also had the same impact because=20
> while I believed I was updating our userspace ipset tools in tandem, I=20
> found that the headers were actually being copied in from an alternate=20
> location and were still using the vanilla headers. This meant that while=
=20
> the kernel was generating initval values, the userspace actually=20
> recognized it as IPSET_ATTR_GC values which were then unused.
>=20
> This was a very long process to come to such a simple recognition about=20
> the ipset save / restore format having been changed. I apologize for the=
=20
> noise.

I simply could not imagine a scenario where exposing the initval value=20
could result in any kind of regression...

Just to make sure I understood completely: what is your solution for the=20
problem, then? Working with a patched kernel, which removes passing=20
initval to userspace? Patched ipset tool, which does not send it? Modified=
=20
tooling, which ignores the initval parameter?

I really appreciate your hard work!

Best regards,
Jozsef
=A0
> From: U'ren, Aaron <Aaron.U'ren@sony.com>
> Date: Friday, July 8, 2022 at 3:08 PM
> To: Jozsef Kadlecsik <kadlec@netfilter.org>, Jakub Kicinski <kuba@kernel.=
org>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>, McLean, Patrick <Patri=
ck.Mclean@sony.com>, Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-dev=
el@vger.kernel.org <netfilter-devel@vger.kernel.org>, Brown, Russell <Russe=
ll.Brown@sony.com>, Rueger, Manuel <manuel.rueger@sony.com>, linux-kernel@v=
ger.kernel.org <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev =
<regressions@lists.linux.dev>, Florian Westphal <fw@strlen.de>, netdev@vger=
.kernel.org <netdev@vger.kernel.org>
> Subject: Re: Intermittent performance regression related to ipset between=
 5.10 and 5.15
> Jozsef / Jakub-
>=20
> Given your latest email and the fact that just adding back in IPSET_ATTR_=
GC doesn't shed any light on the issue I wanted to spend a lot more time te=
sting. Also, I wanted to try to provide as much context for this issue as p=
ossible.
>=20
> I think that the iptables slowness is just a symptom not the cause of the=
 issue. After spending a lot more time with it, I can see that iptables onl=
y runs slowly when an existing "ipset restore" process is being run by kube=
-router simultaneously. Given the other information that you've provided, m=
y hunch is that iptables slows down when ipset restore is running because t=
hey are both vying for the same mutex? Anyway, I think troubleshooting it f=
rom the direction of iptables slowness is likely the wrong path to go down.
>=20
> The true problem seems to be that when IPSET_ATTR_GC is not included, som=
ehow nodes are able to get into a state where "ipset restore" goes from com=
pleting in less than a 10th of a second, to taking 30 seconds to a minute t=
o complete. The hard part, is that I still don't know what causes a node to=
 enter this state.
>=20
> I have a Kubernetes cluster of about 7 nodes that I can reliably get into=
 this state, but I have yet to be able to reproduce it consistently anywher=
e else. Other clusters will randomly exhibit the issue if IPSET_ATTR_GC is =
left out of the kernel, but not consistently. Since the email where we foun=
d the commit about 2 weeks ago, we have also been running 6 clusters of 9+ =
nodes with IPSET_ATTR_GC enabled and have not had any issues.
>=20
> Since we have a custom kernel configuration, I have also tried using the =
vanilla Ubuntu kernel configuration (taken from 5.15.0-40-generic) as well =
just to ensure that we didn't have some errant configuration option enabled=
. However, this also reliably reproduced the issue when IPSET_ATTR_GC was r=
emoved and just as reliably removed the issue when IPSET_ATTR_GC was added =
back in.
>=20
> I have also verified that neither ipset, iptables, or any of its dependen=
t libraries have references to IPSET_ATTR_GC, going as far as to remove it =
from the ipset header file (https://urldefense.com/v3/__https://git.netfilt=
er.org/iptables/tree/include/linux/netfilter/ipset/ip_set.h*n86__;Iw!!JmoZi=
ZGBv3RvKRSx!69L-2bZ2sI_yJHZDhKe799D2LnTMz-jfAVznMjfJK6jB68je36HDpX0ag_GDJRI=
QxS2lfs9imab8LPpnCPI$ ) and rebuild it (and all of the libraries and other =
tools) from scratch just as a hail mary. No changes to user-space seem to h=
ave an effect on this issue.
>=20
> One other thing that I've done to help track down the issue is to add deb=
ug options to kube-router so that it outputs the file that it feeds into "i=
pset restore -exist". With this file, on nodes affected by this issue, I ca=
n reliably reproduce the issue by calling "ipset restore -exist <file" and =
see that it takes 30+ seconds to execute.
>=20
> In a hope that maybe it sheds some light and gives you some more context,=
 I'm going to be sending you and Jakub a copy of the strace and the ipset f=
ile that was used separately from this email.
>=20
> At this point, I'm not sure how to proceed other than with the files that=
 I'll be sending you. I'm highly confident that somehow the removal of IPSE=
T_ATTR_GC is causing the issues that we see. At this point I've added and r=
emoved the options almost 20 times and done reboots across our cluster. Any=
time that variable is missing, we see several nodes exhibit the performance=
 issues immediately. Any time the variable is present, we see no nodes exhi=
bit the performance issues.
>=20
> Looking forward to hearing back from you and getting to the bottom of thi=
s very bizarre issue.
>=20
> -Aaron
>=20
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
> Date: Saturday, July 2, 2022 at 12:41 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: U'ren, Aaron <Aaron.U'ren@sony.com>, Thorsten Leemhuis <regressions@l=
eemhuis.info>, McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso=
 <pablo@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vg=
er.kernel.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <ma=
nuel.rueger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kern=
el.org>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian=
 Westphal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>
> Subject: Re: Intermittent performance regression related to ipset between=
 5.10 and 5.15
> Hi,
>=20
> On Thu, 30 Jun 2022, Jakub Kicinski wrote:
>=20
> > Sounds like you're pretty close to figuring this out! Can you check=20
> > if the user space is intentionally setting IPSET_ATTR_INITVAL?
> > Either that or IPSET_ATTR_GC was not as "unused" as initially thought.
>=20
> IPSET_ATTR_GC was really unused. It was an old remnant from the time when=
=20
> ipset userspace-kernel communication was through set/getsockopt. However,=
=20
> when it was migrated to netlink, just the symbol was kept but it was not=
=20
> used either with the userspace tool or the kernel.
>=20
> Aaron, could you send me how to reproduce the issue? I have no idea how=20
> that patch could be the reason. Setting/getting/using IPSET_ATTR_INITVAL=
=20
> is totally independent from listing iptables rules. But if you have got a=
=20
> reproducer then I can dig into it.
>=20
> Best regards,
> Jozsef
>=20
> > Testing something like this could be a useful data point:
> >=20
> > diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi=
/linux/netfilter/ipset/ip_set.h
> > index 6397d75899bc..7caf9b53d2a7 100644
> > --- a/include/uapi/linux/netfilter/ipset/ip_set.h
> > +++ b/include/uapi/linux/netfilter/ipset/ip_set.h
> > @@ -92,7 +92,7 @@ enum {
> >=A0=A0=A0=A0=A0=A0=A0 /* Reserve empty slots */
> >=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_CADT_MAX =3D 16,
> >=A0=A0=A0=A0=A0=A0=A0 /* Create-only specific attributes */
> > -=A0=A0=A0=A0 IPSET_ATTR_INITVAL,=A0=A0=A0=A0 /* was unused IPSET_ATTR_=
GC */
> > +=A0=A0=A0=A0 IPSET_ATTR_GC,
> >=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_HASHSIZE,
> >=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_MAXELEM,
> >=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_NETMASK,
> > @@ -104,6 +104,8 @@ enum {
> >=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_REFERENCES,
> >=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_MEMSIZE,
> >=A0=20
> > +=A0=A0=A0=A0 IPSET_ATTR_INITVAL,
> > +
> >=A0=A0=A0=A0=A0=A0=A0 __IPSET_ATTR_CREATE_MAX,
> >=A0 };
> >=A0 #define IPSET_ATTR_CREATE_MAX=A0=A0=A0=A0=A0=A0=A0 (__IPSET_ATTR_CRE=
ATE_MAX - 1)
> >=20
> >=20
> > On Thu, 30 Jun 2022 14:59:14 +0000 U'ren, Aaron wrote:
> > > Thorsten / Jozsef -
> > >=20
> > > Thanks for continuing to follow up! I'm sorry that this has moved so =
slow, it has taken us a bit to find the time to fully track this issue down=
, however, I think that we have figured out enough to make some more forwar=
d progress on this issue.
> > >=20
> > > Jozsef, thanks for your insight into what is happening between those =
system calls. In regards to your question about wait/wound mutex debugging =
possibly being enabled, I can tell you that we definitely don't have that e=
nabled on any of our regular machines. While we were debugging we did turn =
on quite a few debug options to help us try and track this issue down and i=
t is very possible that the strace that was taken that started off this ema=
il was taken on a machine that did have that debug option enabled. Either w=
ay though, the root issue occurs on hosts that definitely do not have wait/=
wound mutex debugging enabled.
> > >=20
> > > The good news is that we finally got one of our development environme=
nts into a state where we could reliably reproduce the performance issue ac=
ross reboots. This was a win because it meant that we were able to do a ful=
l bisect of the kernel and were able to tell relatively quickly whether or =
not the issue was present in the test kernels.
> > >=20
> > > After bisecting for 3 days, I have been able to narrow it down to a s=
ingle commit: https://urldefense.com/v3/__https:/git.kernel.org/pub/scm/lin=
ux/kernel/git/torvalds/linux.git/commit/?id=3D3976ca101990ca11ddf51f38bec7b=
86c19d0ca6f__;!!JmoZiZGBv3RvKRSx!9YR_bFOCOkQzPaUftFL2NvuKLm8zPa4tQr_DI8CUZE=
enjK4Rak_OFmUrCpmiNOaUaiueGbgsEqk0IirIc4I$=A0 (netfilter: ipset: Expose the=
 initval hash parameter to userspace)
> > >=20
> > > I'm at a bit of a loss as to why this would cause such severe perform=
ance regressions, but I've proved it out multiple times now. I've even chec=
ked out a fresh version of the 5.15 kernel that we've been deploying with j=
ust this single commit reverted and found that the performance problems are=
 completely resolved.
> > >=20
> > > I'm hoping that maybe Jozsef will have some more insight into why thi=
s seemingly innocuous commit causes such larger performance issues for us? =
If you have any additional patches or other things that you would like us t=
o test I will try to leave our environment in its current state for the nex=
t couple of days so that we can do so.
> > >=20
> > > -Aaron
> > >=20
> > > From: Thorsten Leemhuis <regressions@leemhuis.info>
> > > Date: Monday, June 20, 2022 at 2:16 AM
> > > To: U'ren, Aaron <Aaron.U'ren@sony.com>
> > > Cc: McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pab=
lo@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.ke=
rnel.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.=
rueger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.or=
g>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian West=
phal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozse=
f Kadlecsik <kadlec@netfilter.org>
> > > Subject: Re: Intermittent performance regression related to ipset bet=
ween 5.10 and 5.15
> > > On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> > > > On Mon, 30 May 2022, Thorsten Leemhuis wrote:=A0=20
> > > >> On 04.05.22 21:37, U'ren, Aaron wrote:=A0=20
> > >=A0 [...]=A0=20
> > > >=20
> > > > Every set lookups behind "iptables" needs two getsockopt() calls: y=
ou can=20
> > > > see them in the strace logs. The first one check the internal proto=
col=20
> > > > number of ipset and the second one verifies/gets the processed set =
(it's=20
> > > > an extension to iptables and therefore there's no internal state to=
 save=20
> > > > the protocol version number).=A0=20
> > >=20
> > > Hi Aaron! Did any of the suggestions from Jozsef help to track down t=
he
> > > root case? I have this issue on the list of tracked regressions and
> > > wonder what the status is. Or can I mark this as resolved?
> > >=20
> > > Side note: this is not a "something breaks" regressions and it seems =
to
> > > progress slowly, so I'm putting it on the backburner:
> > >=20
> > > #regzbot backburner: performance regression where the culprit is hard=
 to
> > > track down
> > >=20
> > > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' h=
at)
> > >=20
> > > P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > > reports and sometimes miss something important when writing mails lik=
e
> > > this. If that's the case here, don't hesitate to tell me in a public
> > > reply, it's in everyone's interest to set the public record straight.
> > >=20
> > >=A0 [...]=A0=20
> > > >=20
> > > > In your strace log
> > > >=20
> > > > 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0=
", [8]) =3D 0 <0.000024>
> > > > 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0=
KUBE-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
> > > > 0.109456 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 =3D 0 <0.000022>
> > > >=20
> > > > the only things which happen in the second sockopt function are to =
lock=20
> > > > the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare th=
e=20
> > > > setname, save the result in the case of a match and unlock the mute=
x.=20
> > > > Nothing complicated, no deep, multi-level function calls. Just a fe=
w line=20
> > > > of codes which haven't changed.
> > > >=20
> > > > The only thing which can slow down the processing is the mutex hand=
ling.=20
> > > > Don't you have accidentally wait/wound mutex debugging enabled in t=
he=20
> > > > kernel? If not, then bisecting the mutex related patches might help=
.
> > > >=20
> > > > You wrote that flushing tables or ipsets didn't seem to help. That=
=20
> > > > literally meant flushing i.e. the sets were emptied but not destroy=
ed? Did=20
> > > > you try both destroying or flushing?
> > > >=A0=A0=20
> > > >> Jozsef, I still have this issue on my list of tracked regressions =
and it
> > > >> looks like nothing happens since above mail (or did I miss it?). C=
ould
> > > >> you maybe provide some guidance to Aaron to get us all closer to t=
he
> > > >> root of the problem?=A0=20
> > > >=20
> > > > I really hope it's an accidentally enabled debugging option in the =
kernel.=20
> > > > Otherwise bisecting could help to uncover the issue.
> > > >=20
> > > > Best regards,
> > > > Jozsef
> > > >=A0=A0=20
> > > >> P.S.: As the Linux kernel's regression tracker I deal with a lot o=
f
> > > >> reports and sometimes miss something important when writing mails =
like
> > > >> this. If that's the case here, don't hesitate to tell me in a publ=
ic
> > > >> reply, it's in everyone's interest to set the public record straig=
ht.
> >=20
>=20
> -
> E-mail=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_public=
_key.txt__;fg!!JmoZiZGBv3RvKRSx!9YR_bFOCOkQzPaUftFL2NvuKLm8zPa4tQr_DI8CUZEe=
njK4Rak_OFmUrCpmiNOaUaiueGbgsEqk0Udypzvg$=20
> Address : Wigner Research Centre for Physics
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 H-1525 Budapest 114, POB. 49, Hungary
>=20

-
E-mail=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_public_k=
ey.txt__;fg!!JmoZiZGBv3RvKRSx!69L-2bZ2sI_yJHZDhKe799D2LnTMz-jfAVznMjfJK6jB6=
8je36HDpX0ag_GDJRIQxS2lfs9imab8SZmlVBs$=20
Address : Wigner Research Centre for Physics
=A0=A0=A0=A0=A0=A0=A0=A0=A0 H-1525 Budapest 114, POB. 49, Hungary
