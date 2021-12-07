Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7C46B856
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhLGKGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:06:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:53314 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhLGKGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 05:06:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217570273"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="217570273"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 02:03:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="563415005"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 07 Dec 2021 02:03:19 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 02:03:19 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 02:03:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 02:03:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 02:03:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/pKV6zPri+YljVcO8s+ldWmfJi43jcMtjVoEKk2iI6YvcgHWpXgKr/OwhnQ2YbQxfE7L0pd9trU5YMgKBDr1BljroH+ekSxirxzI1UkMZQrAKzGuYlAFi0ZjPklPnD7oo4a8luyypTBTiyGZznUYavdD8IRtAYB2m1MA4bTgiB96louYTZqalj/bvJUjeUGW27Ky3S1JOb/lMCt4EYSrBYlzTpZ/qClQRKrL7/175NzAZ+Tyg1ET8z0EAOSnI8K9hs5X6x6TjqLgb1vFT2prt2NdkKbou0ughrYGoVv9FPTb91j7YsccFmRT4+4wjWAfMIKGa+uQ8CAhMNhqyEpQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glt+sWbBfCwpGhuv8vcAbHT4QtCNyxgGY1sv3Je5oFQ=;
 b=ITMzHulZJ91LMI4IWvT0UT+D55yshKCucZ+PKYCPvz5Qsq00yPC/ghffPwUqUvnctUmfEoyMQk0IuRRt0BnqmZvxoTn1TTaarVKCV4ta+2NdPHJ0c1lsNPin0STfCJ/YF5iwwLydBdpd2I9b4Mov45tn12luFOJ4kaUOUR+Z5in7zDqulCeGuHl9g8pzxgYK3BXymIlMX3NkHeMLZe8mnXIBThB922S/qKvzggTlFXeQdzCMlJ/QS+t3dxmmY4/vzIgx2Gqeuon52B490qwIxrq8n222DHqL1nmpgPWbadQ6NJf/cMDhCdJ289JYwCc1yUWh5wmUGacvo5EV6OqLlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glt+sWbBfCwpGhuv8vcAbHT4QtCNyxgGY1sv3Je5oFQ=;
 b=L1O1A2TbTOAtS6XClUaWRro3RimOLD6V/QyEfcMdb9ZxcTDmPmLqFar47qUajuThwMbLHZFFjpuMdgobREi7ktxjUDKawNNVHYVBmkAMs1Ivdn9cSmrKXXdFNyQ/7hp5yHXLmbB34EG81ZfvDvOJm++0nE7cwjB7ok/yE2S2rrA=
Received: from SN6PR11MB3374.namprd11.prod.outlook.com (2603:10b6:805:c5::21)
 by SN6PR11MB3119.namprd11.prod.outlook.com (2603:10b6:805:cc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 10:03:17 +0000
Received: from SN6PR11MB3374.namprd11.prod.outlook.com
 ([fe80::80f9:777e:bb24:8db4]) by SN6PR11MB3374.namprd11.prod.outlook.com
 ([fe80::80f9:777e:bb24:8db4%6]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 10:03:17 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 5/9] ice: switch to
 napi_build_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 5/9] ice: switch to
 napi_build_skb()
Thread-Index: AQHX4I+ZjyMyG4uYF0GCApeNGAelw6wm4gEA
Date:   Tue, 7 Dec 2021 10:03:17 +0000
Message-ID: <SN6PR11MB3374B42800E486F22C49067BFC6E9@SN6PR11MB3374.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-6-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-6-alexandr.lobakin@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0562021c-4c9e-4678-fb64-08d9b968ca93
x-ms-traffictypediagnostic: SN6PR11MB3119:EE_
x-microsoft-antispam-prvs: <SN6PR11MB31196CB956674D9B15ED56E1FC6E9@SN6PR11MB3119.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bxl6klmuTeZ+dp5bwIuxskY1gzGznGIwdNnKhBA+zZR3siHXZ4JItbf4rXwR0QESdDvv5rM+T1RTKV15t0R1ZoKp1DH4VqLMxb41nChV+NwurVPuyInVOGzFfUU6LtLTZp5O2+pn2i25cYJhjN6UUMJf/m0CPeXdGp/HfxgyoojCHQ4JiMGUQdPZHjb9ps5b2QBVZJQ6hdEpP1kB5q+EH6AcbT26an7XnJ+dvPNKlEwwkzyay/cOblRn5neZYahBRNc+VAMsuLlORizLLbJZl4DT+TV99Fq10t33ccnRpj9eaJ2/XGDYmcloKey3UPfo8aEO6PyuF5MMMS6qpv3FNLy6ihbxtode6GgDW3OJZ2vtGZnT60Gpus+JthkKSJgLqlafaJ6OEOdTSIqYPS7l4O0KeJLXjAR8Hc1Z1kdPRanCFKj3p29gaOobLkfEKN4kBt7IzJja3JXIoO4q2nD1vTezXuXo43S4+YjJK+6DnqoJczJuKGC3doPfpYdAwfWOZAH6Ji90ib7pZsCGqN0sPv/Q8aWAIa6Xxv/lcsy9QeeBfO3VMDzb5yp2HZOMXbGFc9fQQffdToKX7CeBcFRnF+AowTkBpS21T/hMBlec4CBUwpfA24nD9nWOyjAvvtAfUYAjNdIQRRiEYaHgy8ujvEqvjD0Ml5t/SQhhmMd6QiyUz4MSSwbcskQCZw/35gTUPTjHkEtPrbbYKaOG7fwzpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3374.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(7696005)(66556008)(64756008)(76116006)(86362001)(66946007)(5660300002)(8676002)(66446008)(6506007)(53546011)(83380400001)(33656002)(52536014)(82960400001)(8936002)(54906003)(71200400001)(110136005)(508600001)(316002)(186003)(9686003)(55016003)(38100700002)(38070700005)(26005)(4326008)(122000001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mZ1oJT9XEhkaVgbOXrI7d1zL4ReWE1xoyLpZswOZlCKeH9yPeFLKHD29LmRs?=
 =?us-ascii?Q?lD565RYiJ2gpvwAsxuvDq4hQiRYWmxds8ZhhCagsn52pKtBsB7SyjkuhGf3d?=
 =?us-ascii?Q?6UqpR8H1vWFG9OcWvK8d0DHPyW/BcfHQWoHAwIjsCOyw0qdj/wA8qWMO0++E?=
 =?us-ascii?Q?F7mm+/FBwkKLKTb/PF7KY25Fiw4X/pCj3alEOJlSF4pEX3FJzB/8zLMHSxdM?=
 =?us-ascii?Q?VjawaQZrrl0Za+yE5ry1VeQgGEhxpakCrsXT7peEdKeukLF2eBM2K6+isg1t?=
 =?us-ascii?Q?csh+BYvmnAKMLFYGiSJlZhUCHycc94/o1+dNecyfOSlz2/IwoP+dia/SUCaY?=
 =?us-ascii?Q?lh5+jmJMR0sxL5igOnRXmhCy1Bag7/abzWKMe2V4mtd/k9Z7b0nHp4CjaCeM?=
 =?us-ascii?Q?5rHczQkcVqPlMtKJJx1rjKegopjiF8oS4JKKn5xERe0ut+NJxJyCr7/FRz2L?=
 =?us-ascii?Q?WXlmJknTDUEOO6mc9YEQGNs3UviirOzBBpJlENw30DcdKDjR3/i2w1rKDCbM?=
 =?us-ascii?Q?fl615aJaoEKCr18hulo1Hiaf1yBxWbiI+xfmmHZdMyki0DkhJwxpmyi4PEM1?=
 =?us-ascii?Q?nbrNMuTMEvL3zCQjdoxubdd/jM3CWk8jmZ8ISImrx8qyWmtFbbG2QzbcF6+M?=
 =?us-ascii?Q?CadytGuIeJvSqGDQq9MWbaTdvtKudAXERc84IgO4guLDb86Nno6Q418tVH81?=
 =?us-ascii?Q?RQ4iiqm4QKrdsTyCy+djxJlRHcnnbfodk+66ZZKTFUv85bTlRVxMFfTa3kvJ?=
 =?us-ascii?Q?8nqkGQMqhi86vDXT9Moqfe8/wu+h9tETpRlhnyPTMT61OLtbFkwEDQBdieOo?=
 =?us-ascii?Q?/3McQ0tfzN4leQrQ6NgK/fu+Rb9cKk7Tj1Esbh3XvvavEF5EdIvSvH62odNE?=
 =?us-ascii?Q?j9fcqidxgbqvNI+BzMCdHeXowWuzxRog8r/IRinROwwcgXIHvPChTaYnGVRc?=
 =?us-ascii?Q?S08E0rY+GK5jElRa4vrmj5ZYnsClvwgBLQ2mdzKRGcb005MbwCtfJORg60m6?=
 =?us-ascii?Q?uH5XNr4LMTaDH9sfTAOw1RaEyiw+bXVCdvnqiVbmY5gMCCY4N6d2Hf5pSIWm?=
 =?us-ascii?Q?8UycZ/CED3zc0WuWnBCxtUQEwJo9KwD7dapBoYPPCF87SjdlvuJN6SoNJe4W?=
 =?us-ascii?Q?zwqskuSQG7EoDUkrQxTx5RvdwWOwuCr/BzyHvSWUH9VSyC8Sfek6WwXzWYgO?=
 =?us-ascii?Q?4iXrAL94muI5ynKlqfY+G/ICtGmQ8iTDUr21aq1lQaGsRCblTs1oV3XJba5B?=
 =?us-ascii?Q?8UqBWj7WV7uIbjhgj3TWKq92PQNDQWdyNRVrRj1nhu+D8TlqfgUKBD9/Q4KT?=
 =?us-ascii?Q?LyLL8HUk+d3oHl02OlWEdzDgbX5IS3Zi+PpTms4e9UHJj9jSAaBggrzsATcy?=
 =?us-ascii?Q?h4EOkjZYZFCBvJMilpSfzhyq45xVUB6epTXE7cnZzsi25HZcVT1YN3EYYYp1?=
 =?us-ascii?Q?MNUZ2lZB0gDG4ZkjVCsh2MjogoKvS1FXKRTleKrP6IfKVTZ/r+Y6r78W6prC?=
 =?us-ascii?Q?3FamOy/4pKy16S3xLIiXAHvjyDlpTYx9L2/U/Cydcl+Gv8jpgkmyhkXUux+X?=
 =?us-ascii?Q?lXrYxbCy2T+Bf6Zz4EMgRcKhELf69ULzD9R+PJqhWDb20trz0RT+XXcvfhEZ?=
 =?us-ascii?Q?9Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3374.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0562021c-4c9e-4678-fb64-08d9b968ca93
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 10:03:17.4959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0iKNSmw+LryA7tbd5pSgaKTUuKW9RpjijunkLaCqTS3PUocr0JLHiJYYden+Fe5X77VdkXIbfT8EkXf6Fly8hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3119
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Tuesday, November 23, 2021 10:49 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 5/9] ice: switch to napi_build=
_skb()
>=20
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order to save s=
ome
> cycles on freeing/allocating skbuff_heads on every new Rx or completed Tx=
.
> ice driver runs Tx completion polling cycle right before the Rx one and u=
ses
> napi_consume_skb() to feed the cache with skbuff_heads of completed entri=
es,
> so it's never empty and always warm at that moment. Switch to the
> napi_build_skb() to relax mm pressure on heavy Rx.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
