Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4D05319EC
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiEWQ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238959AbiEWQ6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:58:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6762C3DDC7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653325111; x=1684861111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r6sIDAwwAtr1dacz1EtGX/pKW6eA8WWUco+wzY6q9wY=;
  b=DVIeTBFNiAMRytbGuBThXkqk5GNlerHJcuYFuyH6pA2b5RK8HYqT3IQy
   ZIhWfx/2fH6166i6pI/bfYnD4sfRsCRkO4cSpbszieEiAmahkjqTYYlWY
   KNz/eojh6xO8ntZcku9pGqMEvI9Vt/yuYg8aKLZPRH3R4Cwrx90lBYhMh
   zJUU7gdcN67wKW+uCmfck7B/XiGBm2cz1It/6hb6nvfxiLSdnAxwZQOdm
   VPe+hY+m0IMWNTYLYea+1Sm3dCJyLLV/NV765uJZ843aBeEa/zK8X32Bk
   1D6ezOragOXp6MTXYWYnvGNBZDsDlHceP4nTdUg6IYG99V6b6aU3LX1tT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="270857776"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="270857776"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 09:58:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="548065681"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 23 May 2022 09:58:29 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 23 May 2022 09:58:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 23 May 2022 09:58:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 23 May 2022 09:58:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKCXV+LwgE4ggot0TySeCyJmVAUUoJKYdLYgkSLepVqZlBfQnYTvkk48jr4g+oPphLnILQlAkXx0G5hOXYYUMrBcr32Y2jOsnEDLahWYsYXtghohV8cKqqNVeXsbCjQWh82dpkWD5WaJmdYTxodLay0CX+gHAVlS8yJH388jH25hh7HazogB0gs1G1li6kZ38yyp5bMe8KKCO9F1NQVW7AN/DTVqdow7ioJz/MQ8Z4ER2W38UCEiiL08MiTC4GKIMQmD2OHMe9CFaepdGaOp3/1TpzmFpqJ4Rh8gCZvdAmZgEEAB9JbhzR33B6PxRq2GgYjIsMLOupWXTsWHaCVntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Gcv+8QebCKvTYyJ3FSSBe1SAqJSs0np1r7E6M95aRQ=;
 b=P2cqFq2V3MJl8/NOFUXvKol8G2m7lMwlx9I7GvCEFDVmGEG9h343aWkDG9lvn2wiZx8w2tFGfbAevh0C8QFYPImnPD2TnTPF3Mj4TAy11kDjWMRTtEuhj5Prdge6Hmfo5xXqYCXi7oOwOgphpNZMNyB80dlcfPjQMbsUrVCj5RGZEfnDhc1HpX9jZ+9cPr5nXf4iM3UE4ZRL6o2cpZ74VdlFam6kDqOvDepRVdODEgpTQBiknvU6K94k/RO06nxcqUKYIaMPL1WsTyIkMGPt/XxR37sVkC7p1S0s0hl1d6/eQbaSDsrj/nj5ggDonqBN2NwrEvu0oYgZCDXwq6z4tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21)
 by BYAPR11MB3174.namprd11.prod.outlook.com (2603:10b6:a03:76::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Mon, 23 May
 2022 16:58:27 +0000
Received: from MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::798f:5a98:e47f:3798]) by MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::798f:5a98:e47f:3798%8]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 16:58:27 +0000
From:   "Kolacinski, Karol" <karol.kolacinski@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Thread-Topic: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Thread-Index: AQHYajQ/+5Nk/nCT4Euu3FZzl2q0S60mONwAgAZ/ANQ=
Date:   Mon, 23 May 2022 16:58:27 +0000
Message-ID: <MW4PR11MB580076B10F2B898C644D8C3686D49@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
         <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
 <179df95df2f29ed6dfaa6318690dbf0ef29d7d11.camel@redhat.com>
In-Reply-To: <179df95df2f29ed6dfaa6318690dbf0ef29d7d11.camel@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: pl-PL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: e98a5490-5747-59b2-0ca4-a257649b46dd
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be6e56e5-26e3-47da-de2b-08da3cdd74c5
x-ms-traffictypediagnostic: BYAPR11MB3174:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3174892A69917C11CAA0C87886D49@BYAPR11MB3174.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGzdeg0Sjk4ep0hSRT9/CtZQptN11eIgCcYrsEN9mCEFS2JiEq/NttGkfE9xKPCoY2vf2K3/Q6EmU/q1RaOwWDy+3URg9QXJn1yoK0voOZEcmFQxmyHzVukHh7KaStAXNU7WxtlLfHgAdU+jQ3mzjT7VyA2fhlw4mdFjxvSHeOrFYqgYx/xJDviPhsh7H5vLuWCp70MWpr7msNOEDrkuQqzt/LDgSZf2JqBS4UDw20pUeWbJ94C6tPvPpVDKAzK/b9uGRvxs/RfaD1rhtAlSAWlMmO0UMW2hfMrtG/EexBCyfW5hTaN38sbrErPM2DK77TRrEKwrSco47YVwzvLZNtIVlkk2AeJBgTZm20tK6um2sCNoePyCyR2fMSbGmtb3mrwyGiB4rOALo7HTJAFCIazXFp2L8L7+H/eDJqo+4ybzCwg/m+PyIMKAR65ahYkI4KtAu4ufDg1socnOzrhqKbfBvCOzqTib2Q2Z6+6miPyWWzgp1C59+qd6VqvmQ1gYrMK6gNIbPpDyf3/kmmvymOdxyic9Ej573HdjKH74838nElfqNKeA2gtoAqt+B31d/5YB9cE2cu7VHEQwBoKWOaHG88hXhRd3H4TSnNyn5f6DN1npwo52lUy5xgmvIBppp73JApSMvPfMzmnGTEbPbYz+feYhzeCA73rkeFIxNxAbn4SgLl2t2a4ErtSpKLMtr//znxuE3pFmtLzp4ssUxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5800.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(66946007)(316002)(6506007)(508600001)(110136005)(122000001)(82960400001)(54906003)(33656002)(38100700002)(38070700005)(7696005)(66556008)(64756008)(66476007)(66446008)(76116006)(91956017)(26005)(4744005)(107886003)(4326008)(186003)(55016003)(86362001)(8676002)(71200400001)(8936002)(5660300002)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?A7i+G1znKTOqPiyhi/fDvKVUiLv28febi6BrOJwB10TSKNB3X6DCeCj7qz?=
 =?iso-8859-2?Q?09j3iiNvWwqHZ2zxWU3LfvX9PngRbtk9uBx/2KOxXCRo4l4nNMrg+NSGZ6?=
 =?iso-8859-2?Q?NlPrV7uAycyWdEdS438eDgRO/49KIsBHnAfuceXUJ3yCQrFlXT+vD0HMb1?=
 =?iso-8859-2?Q?WFJYKFtztDfnHA/J4Kbcbvih225H55nWzf81gfYwjPoJZO9QaLAilQdlSo?=
 =?iso-8859-2?Q?NfAo0BbIpKfqWtop66sm4L/MwwGeNT+t5wCayDetn0TCQofUDKPiRbW+C4?=
 =?iso-8859-2?Q?xi+skeYHcXtqppo/0i1qLKYsak6jNZLI2n+9fw5cMiJqmUo+tWzpRr1jCD?=
 =?iso-8859-2?Q?IGaoX4NNe+MupCxIE1/idpIB/kwemAu5RphKhKYGqoW8gcFo4gE9ZG/Xrm?=
 =?iso-8859-2?Q?vzl44zp1qMH0NcJEdBe9OFqNe9t7eSzMZxM2FRkwEP5MTd6J0hxVKf1gzu?=
 =?iso-8859-2?Q?eHJ06E8D+P64+7B2Eh0VM5fPGKvBKyFKA4677BQ8p1BSmMuazsm/HVRVC8?=
 =?iso-8859-2?Q?NQtjmHy+E8UJJAIyNtkRL8I1qwmo9Lmts3wCBmaW0JjBPibDlcx3c1VgPN?=
 =?iso-8859-2?Q?hJFcja4gXttYSSdoxBsl+Cv2zYaiG2uzcns+MbUY4eHv3lmTq8oIVtLZKE?=
 =?iso-8859-2?Q?Hyga70x8YM3CQNuJvP3CJ+f6eRJol9b0nJsWYv6Xg9zuUzc8Z8M6RYhlrD?=
 =?iso-8859-2?Q?4xB5kuDLIk6c3loRRtG50CAwG9eqTw9e52hA+O5+DeAwqflRkcyAT3fl97?=
 =?iso-8859-2?Q?sRp6R1MgbhpEmOHUPDtKLB0VH52Y2/J3cm0HM9dekLnxjvomtOhh2xZ7lG?=
 =?iso-8859-2?Q?n4+OjORs6AwY61b8+SBAiSvHBCSKeyHqD6wK61XCujRr2OBgOlOiS9th7n?=
 =?iso-8859-2?Q?Ybzs9pW4F97xcfxC4wa63YCe/iO98s0WyHOC80VgGuIUAR4tPjWL0ZjVA1?=
 =?iso-8859-2?Q?Jn9m3jeLi+LPV1h76ayPbvUbXlTGShClj0tJ69DdF4I4RhFweT2T7V6cak?=
 =?iso-8859-2?Q?vZzviuGyFB3bgnNDEV/7jBLs72T0pS1p/xGsLSzHKmeCw/WqE2fVKdfnQc?=
 =?iso-8859-2?Q?g6rFiRef2GawXGKL+1YD8C1CnuTSuTMDpDZXGYXRb4X7GtfE+bRc17voZm?=
 =?iso-8859-2?Q?9mxVgnkkXkqXY+wUcZzildERO6PJEvMY5iXGLYN96zgjNVOIUfURpcc0Ot?=
 =?iso-8859-2?Q?x5iKWp+bd0zxdtx/QuViXmQcyRlHT/1Ejarb5uijAUDk4tqS+0Lv+0ynLe?=
 =?iso-8859-2?Q?bxTkLYrEYOljyDz1YZ6E3uHyzzGMXys8zuqzGx3SW0B6ccdgn8of62Yjw0?=
 =?iso-8859-2?Q?tFSAOes8O5SKzSnUlwKYEQhi4N5Npw2bOmvlFDaH96aRZQ/G+U7UpyKw5p?=
 =?iso-8859-2?Q?AzSBMtxW+fQ72kigVU/FIs86Bi2WN/87dLDGOPsWLRPmJY/uKzodEDqO15?=
 =?iso-8859-2?Q?4e6VWQgGnPCwcuFFLWKS9OwfJeUKsf9iu60HNd5dpg9bzqwHCrAgcz4NT1?=
 =?iso-8859-2?Q?vl7ZV0pQeM53Oqz7NYE3ofrCfdIRvpB7HdqJP3U1pG+9EDjlZEi7H8OAkg?=
 =?iso-8859-2?Q?vnjEFJTUSIsYrXbLzHz7olIU/hUdBp9HwisjdtVg6/OGTFxH2+99Gn7CLb?=
 =?iso-8859-2?Q?2RcZVrDpHttcn7Rr/VJezfU1r/+QuLVfNx/2qaCMdrLe4anvSyO1Jfe0Rf?=
 =?iso-8859-2?Q?hnq/DFfNt5Mf2Yj7PzjS9R5OLDN8arb8QlVVYq6pSk+Z12Hh1y7HQGZCtM?=
 =?iso-8859-2?Q?UsSDdBXYoaXZrWTcS2WmjSHCCwTv102+4/ZbA5yTddzDv21E3OfQ3OJNaH?=
 =?iso-8859-2?Q?jXhRqkd0Lo117Hu4Evl1Rb62sp0hZ0M=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5800.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be6e56e5-26e3-47da-de2b-08da3cdd74c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 16:58:27.0441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AM8oW3uZm5x3pD2np2BVsthoz15tL3G5leneb+IoWn+biA8WaxQ6C/FXcFWfdZFFdqIvr26FjsgoiJYOxsSZKJqJLmiRYPxn+oxkpZABeUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3174
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 15:45 +0200 Paolo Abeni wrote=0A=
> > +=0A=
> > +exit:=0A=
> > +     if (err)=0A=
> > +             dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=
=3D%u, size=3D%u, err=3D%d\n",=0A=
> > +                     offset, size, err);=0A=
> > +=0A=
> > +     return offset;=0A=
> =0A=
> =0A=
> IMHO more readable with:=0A=
>         if (err)=0A=
>                 goto err_out;=0A=
> =0A=
>         return size;=0A=
> =0A=
> err_out:=0A=
>         dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=3D%u, si=
ze=3D%u, err=3D%d\n",=0A=
>                         offset, size, err);=0A=
>         return offset;=0A=
> =0A=
> (plus adjusting the goto above)=0A=
> =0A=
> Thanks!=0A=
> =0A=
> Paolo=0A=
=0A=
Done, looks better, thanks!=0A=
=0A=
Karol=
