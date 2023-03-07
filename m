Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03226AF75D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjCGVRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGVRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:17:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D9C98850;
        Tue,  7 Mar 2023 13:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678223863; x=1709759863;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pOR+a0qtrYYUZio/wrLuNbeEvIN9xaLlLRSgEW1v7oE=;
  b=W1XHguvb8MNtD2Utaz5tUU9x5l0OF9xbXjoHYXDccBVm2+BX59IBo3Rq
   cZEa3MUlD8PBz5Q7EQYMFr/AmdeLMfMOrYXGos3cxZNtTXRkXbpAR7lNs
   13GsdoBkocn0hxSuttWtJAB34AVi04xmTPGPAFDVYxcTsTnBhmmnR7PoP
   NHkkUIth9pho+E8O+pVMcLlTnqdQAkvEZY1IbE9K3f7K2W219NNfOnEXp
   vaPObN1jjUJ6a3dgs/cMan9ObFW2kUI7AXwmJbtDC+C6ENO+NQkaoFtkt
   xOS312+f7Euyr6VGNv9OZnhAGmWuruslkYl60DrktgSClQzWLrV11Y/lf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="337496400"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="337496400"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 13:17:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="850837662"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="850837662"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 07 Mar 2023 13:17:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 13:17:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 13:17:42 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 13:17:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1Ey59cIM6xmPb2fOLgqM6SRpTeRsOxFc4bm9GN3I5a7LmhY+I/Hl7qjeRYedlwnkImPeXG1rDYOyICONaOVRupyiq6EL0OIpuz7d7CJh/dHNqpEW3ZNrIaCcNy8zvz5urtaoA8xHLR/e0mQgou03m82sOW6KlSpd5a38Q087RbkW0Bul4G+/r8eWOMvGNAmCKtrcqBhSNSz8UkPFVoKbQ24TsKaqnhvCVdsnWM6pQg0maNY6wWj1Hlck9hn+NC8nTW9ON29t4ejoGhrowv7Z8+IMFUEwrKjaciKvO9MudreJJa4yCd2ZXrYGF+UCNg+f6HjSi84hHQu0tuf4tBUhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZpzKj+X87gkz3kPIOct8kwmP+GqeDrhf0c++yq+L2I=;
 b=V8YK7lmPpT8sfKXjq6kK6W3DpsC/JZuRVwuwYghkz9UMjc19rWSDSKIysGjUNTZJev5noqrEgs5n7XURe+Do9+YGvqkuP5QxogIW29/AQhyIaw3jFLPC0rwNuK66STO7FYpj1V8sNSghBbTm5C+eFQELyo9lEQpbOaWGjYAhU4DZ6vteRtVbJZGrqgBVNX9d+4fkYYd9Ck85V6pJ9W8GucncmnURbvHyLD7fabl3Z22QS+qzw/jXoaK9Ayc40s2fyJxzfpNRANfiT4w0mhG+8BKSva8g2Avvi5lNwMuP43ucKyILEalJLGFab9sfzN4GcrncGqCxAIH6c57Wsjdvng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6224.namprd11.prod.outlook.com (2603:10b6:8:97::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.27; Tue, 7 Mar 2023 21:17:40 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::a54:899:975c:5b65]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::a54:899:975c:5b65%7]) with mapi id 15.20.6156.017; Tue, 7 Mar 2023
 21:17:39 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        "Eric Biggers" <ebiggers@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex
 contention
Thread-Topic: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex
 contention
Thread-Index: AQHZUSVCtRdQbQ7OR0qukN0bzLm1BK7v0elw
Date:   Tue, 7 Mar 2023 21:17:39 +0000
Message-ID: <CO1PR11MB5089C96D23A1D6F0F121716DD6B79@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
In-Reply-To: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|DS7PR11MB6224:EE_
x-ms-office365-filtering-correlation-id: e4789b94-2902-4219-51a8-08db1f5161cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u3wgtFs8y+GBIDmXMuPtV3Q34B8Cqj/dcbUEb64XmJyACxfNbmmGL5lVKCfp65m+Z0Kix0CBIvm9JTjeWub1U6oX9qcizA01SOU3TQIdbhueYUxpcCXeEHyxzMEU661FROBupKoPHXocTNO2tPh4SsuL/xkzbO887viHP/JeerQMIZ7HmqljVT0rQlOdmYafDLWf5QPPZh5y4WExgJMiy71EVdGmXBonRIftmXSJAVgG6On0uGUTEGfVBNExWH6wW+lRngT/8OSqNZ3HH7ehDuLI+ugqYk/xBvoLoVovmcaYfGWjX4ydO+g+Pbv/8I2j0l2jmaDdehGdSl3D1LQhdgxVKAgb8s2mia7yhvYplS34O0AjotXFxX89P+4NsID7MoAPlYCsqAtlyjetOyZGmADA48Su6ReQggWngML27nwtY/ljkWr/HZR125Rt/Mob/r2v91b5KH0DJP1nqLhlI/ynbr2cnmtirIoXAJpr/Hi1KuK/mWdsjxkuzF3EiQ8TEFzylmQncW/twkKhZYQ28CTb5V2cGFsPjggA8lbq7UkQqWiesh2YCOZP40ZXaccPwdbP2Z1HgIJC7DtouRXJ45EqfXpLL4in0ba7VghkbFIlhd4pY26NR0cHMHtg7aFkUsb/A5s2wcOr4mm25/PiS5Czhj5W2oIw9R9UDKiTLCXxi/7OZp1imD4MF91w6Z7uDOrywByCI7TDMmmwLLOg6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199018)(53546011)(6506007)(83380400001)(55016003)(33656002)(82960400001)(122000001)(38070700005)(38100700002)(9686003)(86362001)(186003)(26005)(41300700001)(66476007)(66946007)(64756008)(8676002)(2906002)(66446008)(66556008)(8936002)(52536014)(76116006)(5660300002)(7416002)(4326008)(7696005)(478600001)(71200400001)(110136005)(54906003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j7qwKjeBN/VGPAi1VhcXixhbfn+p7u3rmexAmCw2YeZbMXBNGRszwv/GvTIR?=
 =?us-ascii?Q?R01uYs/2O9OXPsiGlyDanrYY25gw19/ec8p0UV9M+pWBimcgX6Iie3v1QsxL?=
 =?us-ascii?Q?kxvgw3tP1dljMCC1ZUEMJeWkF/7NE+QTyP0tvg5FfxiOOwcMZB2OJNIx88bN?=
 =?us-ascii?Q?xoMWXrXBHWQUTLdA5xYufCuog7Gnw0pZtBacakzh7IP3UpdooTuErOvePBq/?=
 =?us-ascii?Q?W/VIJS2I+hNp/0a1WKRSCOoXrMx7a/wIuRaYiElfzKfhyYADpgUcEQwXjY7l?=
 =?us-ascii?Q?dzHxHUmxlnNycJq3T/joq6COz1YCp1u//cHwk89mhAnZm2E8TQ4CyV+ZDR1h?=
 =?us-ascii?Q?qp6dJ53MymibWSfZRvWgMXJnzuTSUvV4Z3pb2+qaaOKSmmLXpxfaA36KeD6R?=
 =?us-ascii?Q?41w/x2NqbmImmluT72TF9P2nsdhrBIveWiQs3t9NOioEKuDuXBU9zIzBaT2v?=
 =?us-ascii?Q?d7jMbX7Yy/a/bdi1sX7cp6EhjzVQCeECJSAZQDVN+JczrkyMPamFcyFVVfhm?=
 =?us-ascii?Q?3uxB5gnnO9y4lg3UoNf7j5G/5gerRU3hixqGyIDoC4tfKZncxTU+eBZI+TN2?=
 =?us-ascii?Q?VSv8UeXIxo4fO06u1N+2eq1MUYbFBScNIm9K8nBEjzQS1DX7p8EX5q2//cA2?=
 =?us-ascii?Q?EU4f0iE1Urv45gWtGQ5a/xukYzri7Z3oCxyoh0zegxN5ZyaLOFBRu1lFjYSJ?=
 =?us-ascii?Q?VJDKFe4y4CoEbrPJRtI3eMwP4tMRG6lGpUcsdKMjgqEI2rgaQgNFrBf5s1J4?=
 =?us-ascii?Q?L5OZLSQCKzgng4ri7GGHOHnQvjCJgZl3GCe8khBW+D8e+zLaoeBGHqprvyqK?=
 =?us-ascii?Q?DVRA0CQDmS6TnClCXQJ6V4bBEX4Pt3quMW+TCFM1tC4oh+DiHf+mTaAD1Zvg?=
 =?us-ascii?Q?pwaULRjom+k3UPc3rT8zSXmgy8vsybPSteZTJk+FN9DdtsWqIgXT3ACpzgcf?=
 =?us-ascii?Q?RjXTu6a43gu0SyUgSFBweh/ufGe9uaqa5WntqF0quCE/NoZpcfveSxl7leh6?=
 =?us-ascii?Q?JUsT/rjbW2rMdIjCgFISZsCF6d1YwPFzO74uwdnRfiigWK0qGhyLAYy20aub?=
 =?us-ascii?Q?R+EMd5jR8U2reloCEIV3MWgg3+6sslyyHXE8bmZQKl/Mi4VGbJSc8iyZcPcM?=
 =?us-ascii?Q?kDErw9a1gg96CcrOiGqx3tD9GCm/SyLJVQzAGnYeWc8YJKtuNHwZTfD/MtQb?=
 =?us-ascii?Q?Q7ol++pkMB+hBYCpMqZuOBRe20vBdAvyGHM4Dx4E3wU96vXG7aeNIpSJWCjf?=
 =?us-ascii?Q?4qMm+zqQti+4VA8/rHYhUvlvxXVEHmSdV9wwAg3dn7rI8LlDzfiQNNbeFseL?=
 =?us-ascii?Q?9iL42DD0tLVDhZyisBs/nftCpLLkJLletFsgeb6BqvD4VuliVRzsHamYGDw8?=
 =?us-ascii?Q?IT4XqDJx8SlsRvdTHKRa4k7pDdoyNDZqXaDb5sW6Lk6iuluCEoEKhql4yM4g?=
 =?us-ascii?Q?0IHLrt5GiFyXefd4OY0zhXWHfYjyV3dImHRIKeY3ihO8UilHLjFo2ES/5SzT?=
 =?us-ascii?Q?glMVIZPnINbeyjVexiSWZFsDU0wPHkjCJy8aqY2ZHWzNCSuozt6Y4gclboad?=
 =?us-ascii?Q?gzayvN/6GScxiwdy9tdK6Va+WrBMl1xj04L8aOrC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4789b94-2902-4219-51a8-08db1f5161cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 21:17:39.6558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YnfYxOWKMS2ncV0FFrBxTtYoyRbck8kGn8WM9zaxFBx43PhzDQPQ7TiNbaQYos7ZNzDxWCHveBYYbfuUwwQfWbI2TQLzw/qUmMj3ds+EPP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6224
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Paolo Abeni <pabeni@redhat.com>
> Sent: Tuesday, March 7, 2023 10:47 AM
> To: netdev@vger.kernel.org
> Cc: Soheil Hassas Yeganeh <soheil@google.com>; Al Viro
> <viro@zeniv.linux.org.uk>; Carlos Maiolino <cmaiolino@redhat.com>; Eric
> Biggers <ebiggers@kernel.org>; Keller, Jacob E <jacob.e.keller@intel.com>=
;
> Andrew Morton <akpm@linux-foundation.org>; Jens Axboe <axboe@kernel.dk>;
> Christian Brauner <brauner@kernel.org>; linux-fsdevel@vger.kernel.org
> Subject: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex content=
ion
>=20
> We are observing huge contention on the epmutex during an http
> connection/rate test:
>=20
>  83.17% 0.25%  nginx            [kernel.kallsyms]         [k]
> entry_SYSCALL_64_after_hwframe
> [...]
>            |--66.96%--__fput
>                       |--60.04%--eventpoll_release_file
>                                  |--58.41%--__mutex_lock.isra.6
>                                            |--56.56%--osq_lock
>=20
> The application is multi-threaded, creates a new epoll entry for
> each incoming connection, and does not delete it before the
> connection shutdown - that is, before the connection's fd close().
>=20
> Many different threads compete frequently for the epmutex lock,
> affecting the overall performance.
>=20
> To reduce the contention this patch introduces explicit reference countin=
g
> for the eventpoll struct. Each registered event acquires a reference,
> and references are released at ep_remove() time.
>=20
> Additionally, this introduces a new 'dying' flag to prevent races between
> the EP file close() and the monitored file close().
> ep_eventpoll_release() marks, under f_lock spinlock, each epitem as befor=
e
> removing it, while EP file close() does not touch dying epitems.
>=20
> The eventpoll struct is released by whoever - among EP file close() and
> and the monitored file close() drops its last reference.
>=20
> With all the above in place, we can drop the epmutex usage at disposal ti=
me.
>=20
> Overall this produces a significant performance improvement in the
> mentioned connection/rate scenario: the mutex operations disappear from
> the topmost offenders in the perf report, and the measured connections/ra=
te
> grows by ~60%.
>=20
> To make the change more readable this additionally renames ep_free() to
> ep_clear_and_put(), and moves the actual memory cleanup in a separate
> ep_free() helper.
>=20
> Tested-by: Xiumei Mu <xmu@redhiat.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> This is a repost of v4, with no changes. Kindly asking if FS maintainers
> could have a look.

This (still) looks good to me.

Thanks,
Jake
