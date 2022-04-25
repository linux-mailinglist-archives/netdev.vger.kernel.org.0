Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D879A50DC35
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbiDYJTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241582AbiDYJRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:17:12 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C872FF;
        Mon, 25 Apr 2022 02:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650878047; x=1682414047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zQShvpvHQJS+j2ZPHtTR7L1LT+W4WZYAvCFsk6qaHCY=;
  b=lbYmqpv0KPZUKC2Cyx63+2dZ5UuXBf3omAT8YPvYroHcGAcWxukdZc5G
   HKVV2AYOx9Eu9A0j4oAqcRyVKXSDfNE4qHSYNO6kJafmd5nfgwsBNriBv
   xzk4Y6yDXAqrKaI/fV9N2DASmsbJN146NLE7sjxQFiGShcPyvNcpKUTqs
   gmiGhg8M1yzBTmpEObdYOl4ZF+eE0eveWdbIbK70A+KZv2+hm4ePHa2NP
   NRpzbwYyV6qC/V/aw0HkpdcCKvcIFaYRGFeUreBE6+9m6RRlfBKELOrkm
   yJ6hE9h2IaIlbvkDs5EX+dVmeb51ohFgwSIn9bGq5koXi0G4LIj1wDZ/7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10327"; a="325679447"
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="325679447"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 02:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,287,1643702400"; 
   d="scan'208";a="579185009"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 25 Apr 2022 02:14:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 02:14:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 02:14:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 02:14:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPdeSi7PoWRMxqOce3lfJfiodHg22GrXygnQe9ndgg/3PRNOnwaJFQHHO4MhHrwQzo2a+VqN/NIJqPC7HooutnwPWk6LHBKWccOWvdfUydEter4RJhLruZbBdMwCBdfxBCJcPjz0+8DXDieLTKng4J8nWmRJJTdmWDAgW343LmT2ScRKn6V9nNeuPOdCnBdDGphj0I1yGc9x7X9EtoDiUGLnHfFg0pdYheqFGhIuNct3BykXWqio8nMqT+V2zt2sVBtTXqGupo+pFd7xAE7+I45MhhC2c5MV3ZXwe0zQPALiRBYkce7jf+jtj0/wFKahncdIJ36axnj1e32HnijnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LyqGDpUQgb14h0DWTggIjNBx3KTRTXXm6I3ayuWlPWc=;
 b=f4w6nZBlBJGdZKbhE+KhVhwW8B5xOI2XDFtTnWkrxWOaEtVxNt7kzCq3pHbqmnOLuXoqXuYq1d3B+YOzhHmsHuBPuTO/nCnOMy3tXrna5SPN8bhGFD6Ugif2LFE16pFBvMssZLEUx1KFFo45beBWWAs2JlZrmUi3QM/srs82f+8jlJFMswRwCNfLEUEJxahv6HEPN47iWnQs8HWj5l29eC3Xqjxb5q8nP+d5HPJgFRUKbUagjTIGBG/RwiGl6AnzzWcdukI+n6d5vn/COknGMlZ4CnaKXlPkFXTP0Hh8w2rZCCj5BrRn4skYlKOQgGQJaNmNnGk17/HFxDMMNoHa2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 MWHPR1101MB2160.namprd11.prod.outlook.com (2603:10b6:301:5b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Mon, 25 Apr
 2022 09:14:04 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::555a:eb0d:3532:d9d8]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::555a:eb0d:3532:d9d8%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 09:14:04 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Fei Liu <feliu@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Thread-Topic: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Thread-Index: AQHYU/jzEZWxs25geESOHMu6ZwIIIqz6lTaAgAXMVfA=
Date:   Mon, 25 Apr 2022 09:14:04 +0000
Message-ID: <DM8PR11MB5621D15FE88382CAA06B4C2DABF89@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20220419142221.2349382-1-ivecera@redhat.com>
 <CO1PR11MB5089EDB8FE93BA8B8905E889D6F49@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB5089EDB8FE93BA8B8905E889D6F49@CO1PR11MB5089.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16be2778-2f8d-49f8-f60a-08da269bf1c3
x-ms-traffictypediagnostic: MWHPR1101MB2160:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR1101MB2160B8796BC6B71BB160DAD1ABF89@MWHPR1101MB2160.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Jq511+H9m5y8MZ4O3LK59pJ9WK7Rnq6BMYA5kaxoFVh2PEkf+aW4AWSKXOTpjtcojMdDHiQSv88SPb+HajcJC6xVmtQhZeB7jQndgQzruT/2u2vPusUfVgDBeJRO6YsZUlNYNhSReFskE60FfEMyaVlq+EN2QrtVJI7uTvlM28+eoHDQAoFcrbGniZTBzHvn1css5QNyUaaKvc9Bkn3IEX9r2YidOges/IodYzso8TmrI32k6MDD5McKdJJemSCSbCx3GNP8+gPcYq68ojULCbsVnuTzha6eeqr4uy2Jkt7sIsfkG3f7fYCazedpAC+O9yKzyFlAKnPwloZefE0b9gZCzJAu4guK2hwiSV47HtXSglbCGSBpQ+geUyiVbmSNO9/2PHoPeXNWwEMLRU8bS5vE2JtfY5Aolb5h/tpd8q7I5YTTyn2c7gHtWMsAer2XoVaMMsR7TvzZJTntlcjZ0xrM2/WHPp+CWdR9gDjNiGAm0ehauw2G5VF13DeNlLxgurq1Q1/sFV7uVQRmk6gYxiZXVmN+kqN+ce1k+XMLRQCU6LoGRyvu3c06f4ftGXOT1aYZNyGn/LZee+3vNXMjt+IIUeYEro+o71hYApeuSY+5fReqx3T41viFlfAiYvHN+ujLx8V3Sf3IvAiJ9dSdVslQDOBw7sIh6PXQ1XxlzKf8RGCHuJNYXsAAJFLazDHHlm9a7HOU5ndhTXxaW7xjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(66556008)(66946007)(66476007)(82960400001)(76116006)(38070700005)(38100700002)(9686003)(64756008)(54906003)(2906002)(33656002)(53546011)(7696005)(4326008)(8676002)(6506007)(86362001)(66446008)(26005)(110136005)(71200400001)(508600001)(186003)(8936002)(55016003)(5660300002)(83380400001)(316002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jqRwiwP8icCSf0tnsvV9aGm9Sw4ql88gL0xOyEY1NuI2iAIFZprLPAWO5/EX?=
 =?us-ascii?Q?EwWy0KAOZF+2qhnCDZ7Nr3lEFHDUfWongjZXybunkd9eefO9nw8jUakIZ2z2?=
 =?us-ascii?Q?FM9z9pA7ax0lHPE05ezrLZnRes0s9UagvotmdCSw9Uk+2QiasDz9TOg4d77M?=
 =?us-ascii?Q?4eO68FWe9/NbmhGdGe+KzlU+X2AgGaCu6rslMfFFJwn/1gGh8uQH7vi4LBqD?=
 =?us-ascii?Q?RTUcCjgdOpr4yQEc12ZoCogbl5ijm09S4LNmPXRk4VhGJfBn0RsTcZSao60W?=
 =?us-ascii?Q?DlEcojwox887nvPlsMZ9I6ftzfKPFaW3X3Zge11u1yflA0WGmdbYb83EAq/k?=
 =?us-ascii?Q?scMq/7PxYBNM82r/M7kj1iAr+5EvTHJsn/NiI0+cjuWYbJKS41TdlubkKOx3?=
 =?us-ascii?Q?MWVPSOnh3sKNmyyJEBbPmFyjoY84Vxmv2FRwOwB7wjOieWJMYuup2zus1Blj?=
 =?us-ascii?Q?vF9su0cbOnvRvQp/TEqJGnj5z7HNf58t1PGK8mT+HMliXnFEeHqcI5gPk5M/?=
 =?us-ascii?Q?46PCCgK6RTP6FvVHW6ZNzKLvb7h3etw4ij2aVd6Eluju0ybaVEWYbqmozITz?=
 =?us-ascii?Q?tOTM1I8OPKUeCjaYrcQGWZ4ncsOaraCeSExlqIkTFITdt+NJf9jwEc60DQPX?=
 =?us-ascii?Q?TKP/R5bhCj8suk4hZWhvFeiFBns/NiALkjl+6wM4RooQKmRkIGOcFvFAnwlU?=
 =?us-ascii?Q?G2ZPrtKO673qNGqIbCi11cKoDoJBbIsypoLm6VYPQhN8sL08zbOTzae5U369?=
 =?us-ascii?Q?9mF2BajZzPj4kR1PPAF6mn1/jyh6h4hdNm++TMTszEq9lMYvMuyS/zjtSIHU?=
 =?us-ascii?Q?+zhwU8bTmoIyQm7h23QD8JRsD0b9/HkmDNCLzaypc4F5/nJV4nn+8oOYHZe7?=
 =?us-ascii?Q?OF8W2lCeVagye3QIeWEztKI9s4igWARk3UHYY1YhXriG+QqVfCtDC81X1yGo?=
 =?us-ascii?Q?aaD0qanyAemTSvW7VxPhdNqg4CuPkzAhPig3kC2hGSNPfvYxjI2k+5XrPIYc?=
 =?us-ascii?Q?F7N1AX97rwjwHMDMnUwYpATfcxoQRQZl5jsxZkjTitj6X3BCEWq2iFW1DzEm?=
 =?us-ascii?Q?cWVg1AKUDa3XCqrD+ZUaqHPItpWT9A/DERFTFdHkCDUGNUv36M5dIWdU+hiL?=
 =?us-ascii?Q?i6sp8xYBGyIJdNqvS6gNMeswsEjqkMwJqDdR09s51SuNq7w4DJGtaNj/ZXEu?=
 =?us-ascii?Q?bCjQcRSYA1HadPfBSGcbwi2VBzp2kPzC3F2UovvN9Hs83c2xfn4vnCJ5KJDQ?=
 =?us-ascii?Q?PrglIFb6KG56q2KDy5iEphAk5QuDZykjsfhhvma9m/e/d9vQpK55FEkJbtgt?=
 =?us-ascii?Q?MmFVGc0tU12lFpbSA6zRDdxWNi4rIg6CyWXNfkdU6yZElu5Z6/I7VU8toCKx?=
 =?us-ascii?Q?rmTgZCpJCD9UWGDtOdEe4itl3js1OL0PyIRUC4Acww+Tx8dUmJwOkJ0ArhwV?=
 =?us-ascii?Q?txUFleQlskaKaf0Ak0yb3wA8nKaT7gmxfSjsMDSszWxcKsF9IqAPUMtz43G1?=
 =?us-ascii?Q?q7JenUPD5Cqk8o9OJtmUPF14ZwAzE/Uk81IokMZ2sbyql3LHYUkXA/xkpDCk?=
 =?us-ascii?Q?efpg1hyJb617OZY0yhbleP+tAk+5qLOSK0yUqJvJsa8xyaGClId9vtr46nJ2?=
 =?us-ascii?Q?g0QaJywOrV/k8zUL7nk8qrAsgssKbP6GNTTYkGvfRHVgbnLfk2lOA6UUqtUD?=
 =?us-ascii?Q?4nYzJ1ocT0jkg5ZMZCcSfTpXmRiHI4fJF107zm8r4Xe9kqmAW8M2JPVajwQD?=
 =?us-ascii?Q?LnrIzzXHNCCNF4/9Wrk8BQyvkIvdbrs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16be2778-2f8d-49f8-f60a-08da269bf1c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 09:14:04.3815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ubBGAGGE0jfj8GRe18d/K/Nqgw/G4bJO2uKZojunwCzbHoqf1kqxbFonf1c735QiSG0UlG8DDIYtsYtLRzdht7ok+UaVrftYSJBofrTa5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2160
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Keller, Jacob E
> Sent: Thursday, April 21, 2022 6:41 PM
> To: ivecera <ivecera@redhat.com>; netdev@vger.kernel.org
> Cc: Fei Liu <feliu@redhat.com>; mschmidt <mschmidt@redhat.com>; Brett
> Creeley <brett.creeley@intel.com>; open list <linux-
> kernel@vger.kernel.org>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; Jakub Kicinski <kuba@kernel.org>; Paolo Aben=
i
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: Re: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check=
 by
> cfg_lock in ice_vc_process_vf_msg()
>=20
>=20
>=20
> > -----Original Message-----
> > From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf
> > Of Ivan Vecera
> > Sent: Tuesday, April 19, 2022 7:22 AM
> > To: netdev@vger.kernel.org
> > Cc: Fei Liu <feliu@redhat.com>; moderated list:INTEL ETHERNET DRIVERS
> > <intel- wired-lan@lists.osuosl.org>; mschmidt <mschmidt@redhat.com>;
> > Brett Creeley <brett.creeley@intel.com>; open list
> > <linux-kernel@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> > Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>
> > Subject: [Intel-wired-lan] [PATCH net v2] ice: Protect vf_state check
> > by cfg_lock in
> > ice_vc_process_vf_msg()
> >
> > Previous patch labelled "ice: Fix incorrect locking in
> > ice_vc_process_vf_msg()"  fixed an issue with ignored messages sent by
> > VF driver but a small race window still left.
> >
> > Recently caught trace during 'ip link set ... vf 0 vlan ...' operation:
> >
> > [ 7332.995625] ice 0000:3b:00.0: Clearing port VLAN on VF 0 [
> > 7333.001023] iavf 0000:3b:01.0: Reset indication received from the PF
> > [ 7333.007391] iavf 0000:3b:01.0: Scheduling reset task [ 7333.059575]
> > iavf 0000:3b:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our
> > request 3 [ 7333.059626] ice 0000:3b:00.0: Invalid message from VF 0,
> > opcode 3, len 4, error -1
> >
> > Setting of VLAN for VF causes a reset of the affected VF using
> > ice_reset_vf() function that runs with cfg_lock taken:
> >
> > 1. ice_notify_vf_reset() informs IAVF driver that reset is needed and
> >    IAVF schedules its own reset procedure 2. Bit ICE_VF_STATE_DIS is
> > set in vf->vf_state 3. Misc initialization steps 4.
> > ice_sriov_post_vsi_rebuild() -> ice_vf_set_initialized() and that
> >    clears ICE_VF_STATE_DIS in vf->vf_state
> >
> > Step 3 is mentioned race window because IAVF reset procedure runs in
> > parallel and one of its step is sending of
> > VIRTCHNL_OP_GET_VF_RESOURCES message (opcode=3D=3D3). This message
> is
> > handled in ice_vc_process_vf_msg() and if it is received during the
> > mentioned race window then it's marked as invalid and error is returned=
 to
> VF driver.
> >
> > Protect vf_state check in ice_vc_process_vf_msg() by cfg_lock to avoid
> > this race condition.
> >
> > Fixes: e6ba5273d4ed ("ice: Fix race conditions between virtchnl
> > handling and VF ndo ops")
> > Tested-by: Fei Liu <feliu@redhat.com>
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
>=20
> Thanks, this looks good to me.
>=20
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>=20
> > ---
> >  drivers/net/ethernet/intel/ice/ice_virtchnl.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > index 5612c032f15a..b72606c9e6d0 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> > @@ -3625,6 +3625,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf,
> > struct ice_rq_event_info *event)

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>

