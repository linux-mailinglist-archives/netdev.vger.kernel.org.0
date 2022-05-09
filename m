Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF3B52011D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbiEIP3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiEIP3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:29:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3971964FA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652109939; x=1683645939;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qQGKbbBBVHNWfiIJtOozDjdiJ1HZRGty1nFL8gt/lBQ=;
  b=jASQpv+Vj40drZqPhYnkriz9nvRdRwDBI2fGYg3vuBk06BIf4U3COb/m
   xiOhKx7IXnFi0SjQS/8foc9VKQW1yirAn4hqIW4aJJWrug8WeaUsXaRBS
   /AkNeP5K/uvNYiAGo7eWF7IvSdmKYdiRnU05cF50n0EtDux0iAZBXhx5O
   NVxdihqwegBZQiYhZleYcpoKbeuKZREu3a2+1jGdF7itgOx7olyXM8lK6
   WuPLPusM+IrGp//P6yPM5GqaQ/BdX/aVEwyp9+50mkP5Uk4nkH/JNSnKs
   P7/APJlcXMur9PQyvzDPbFNMj0hc9g77M9KM24JmDzz+CKCZ0jyS8bpZJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="329676560"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="329676560"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 08:25:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="551067578"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 09 May 2022 08:25:22 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 08:25:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 9 May 2022 08:25:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 9 May 2022 08:25:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jc//MzyvEq/6QV2qP9BXQi0u/0dUeX90D6eBcqG/lSxUxL+4b5VrPsRHyRpLXD+3KwggQnfhYjg7sFTwKP5tM3ILNMjCvWGGV86W6po6UsRyqduDS3u2Aam5n1c8DKgA3Qai/8AEnMna8qHIW2H3REP58hOwkEbBfDAZ9mKs/3HVFKcrtg18a+cLvtotv480/RQzmy+vFzIPRlvX2aWAR/ki6aKcPrO4lWc4+FlNZT1hPjE18TUwj4G9JfMiswUbScn7UY3hi3Jy/Azzfa5EjuzsiJ7XlsmEzzscK0WfVumYDSxgJ9mo58xZRWqOqHBF9wqOXnc9p0G11yNg6t3OlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQGKbbBBVHNWfiIJtOozDjdiJ1HZRGty1nFL8gt/lBQ=;
 b=nXWzDgOlyv/X8/pFOVkIfl1tEcI1L95aZOSRYlHzR9S9EuJKzbr/DJnjXmLxRl718IWluX/louBiqYIUU2xqETOX96oRDFe3V6Lie5raTOoruAzkMwi5lX6xg9Rp05G4w6uxpet5VohnbnH7R9aHdo6KUS6S5h+36KFuY83TwAAoYl4cKaPJ/beXJJpa5YVdH3NqWE5k/zVUS4SFCbjIQjI3gUkQouMGwuuaob0Y91aZVpqC7+CCi6RE0TDPh3OFYPy/trpQ1m5CYKoYppFtSiyeYTCTtbfZ/O5hYxYt2y225wd9+mgYWRvxLrivLA2c7x7dMjY9pU/n280Ilztudg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5430.namprd11.prod.outlook.com (2603:10b6:208:31e::24)
 by SN6PR11MB3309.namprd11.prod.outlook.com (2603:10b6:805:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Mon, 9 May
 2022 15:25:19 +0000
Received: from BL1PR11MB5430.namprd11.prod.outlook.com
 ([fe80::49c5:bec3:a36:c4e5]) by BL1PR11MB5430.namprd11.prod.outlook.com
 ([fe80::49c5:bec3:a36:c4e5%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 15:25:19 +0000
From:   "Maloszewski, Michal" <michal.maloszewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: RE: [PATCH net 1/2] iavf: Fix error when changing ring parameters on
 ice PF
Thread-Topic: [PATCH net 1/2] iavf: Fix error when changing ring parameters on
 ice PF
Thread-Index: AQHYVNwqx8tU1ZUFuEyko1AvZMprh6z8jEYAgAkgk5CAAATnAIABNlZwgABTUICAD4zEYA==
Date:   Mon, 9 May 2022 15:25:19 +0000
Message-ID: <BL1PR11MB5430AF541A6F1861B22CC8D286C69@BL1PR11MB5430.namprd11.prod.outlook.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
        <20220420172624.931237-2-anthony.l.nguyen@intel.com>
        <20220422154752.1fab6496@kernel.org>
        <BL1PR11MB5430A4AD0469C1C4BDCBB5C486FD9@BL1PR11MB5430.namprd11.prod.outlook.com>
        <20220428112820.4f36b5e6@kernel.org>
        <BL1PR11MB54308512D3CB817F76DFBCF686FC9@BL1PR11MB5430.namprd11.prod.outlook.com>
 <20220429105715.6179fc9b@kernel.org>
In-Reply-To: <20220429105715.6179fc9b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.401.20
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 632fdbf0-b4b2-4411-4f91-08da31d02045
x-ms-traffictypediagnostic: SN6PR11MB3309:EE_
x-microsoft-antispam-prvs: <SN6PR11MB33091A3A5E4838F3AE0F6F0186C69@SN6PR11MB3309.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qxJE034jV8oSb9B3N55YYvsnKFVicVfCw+5j9yAE418sQaxtzCNAjxOwJH5NfRdP1A62Oze67BDO6PGrvBzjIVreQu/JUf7BvvpDZ5bVgh8dPSgVi5jQip8MZjdpvPUjd0HaarcbQuOjGaAKOUs4P2A28ifvLW0LXLo5S4xJJGuouca0cDefOoFqdHBTo2AUZswKyhZ78c6YxJtprTJXwMksJRTB0BvbWWUp5uJsoOQSc80J3Ft9eM09WZNXsYRtfGeH1JH8FKfy6sokaVA8Blc/SCfbA6ZKskkluENJaFLwIcD6CKnswThpwspSgikspZDM4uDu6IoFo9b7LCEP/h9LvBSdqOGwD1JyJm7dIwWjYBIsvrCSDDrU8snwUKISAWFWwR1MrnoIQEgp2mOQewQt1JQfdDeG4Ax6jEMfxj+edtQWPsdluD6wxkkJPw6CD6KOGRA8GZDlLWwtxTc7ypxDt10z+4tLJoYh+yYJ7FnbNTFO/jFFL3xfIyeMhwYtEReLX/3hFVDYRUl1oteB1KF3GI5fDOvksdoWLKwqwtYCEnIGbMnbRxiGizDs3Vj5oFDvzAwdBdIj2Kefh+11Sdjxr1L/yUHaOkxgkbi0DT+VhukhyRFmCxbsun5jjK2dddLyAqvAG6Ur5lCBvP8E8KUeNe9fEQb78WZQLxbOUekkBNfVl21pUGiFjgkUhZWWHB2M0JLPLkorcZltEmDyLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5430.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(26005)(9686003)(107886003)(82960400001)(2906002)(38100700002)(71200400001)(86362001)(122000001)(83380400001)(52536014)(5660300002)(8936002)(6506007)(76116006)(66476007)(66556008)(66946007)(54906003)(66446008)(55016003)(186003)(6916009)(316002)(64756008)(7696005)(508600001)(33656002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0yn0MPsueosTkkE+GrHENEucaqCmpJnKUpXWmgH/7EI1lqhTRHs5mHS4psWY?=
 =?us-ascii?Q?3J5ZEA00DYomrjAfM7AE4qBupy4tXOMk+I5NajT3ywWb8cR7gVB6tnS+Cvv3?=
 =?us-ascii?Q?XXKfsYc0vj/vIxqxMkmBRBZuZMW4KHzSbisN7USpvnTifXh+GeO0u94aiGb0?=
 =?us-ascii?Q?gkJ/YJqFQITnT/Bx1m4CIbXbvxqlOGlLG8McwRvAWbNtLxnooKV7yx3vLpb/?=
 =?us-ascii?Q?i1oG5hGhAQ7RVmQdATyf4RLYpVPesNoRQ6m0qkpLuw+NPoxeLxMaLWZbWX99?=
 =?us-ascii?Q?x+CWxs5gEeoBRGCyQwshk1Kl2F61Jl5/DJekzl5CapieoM/PyNPPv+JCNVD8?=
 =?us-ascii?Q?G/mAUOAZRb6h8dmnBdN/zicemidtMpFUVAaI0IO9ZJ8NFedyAY0mA07r0OiC?=
 =?us-ascii?Q?MC0ru9jwOhxuwVgQnuVuBOHAmjjce+TKkwmTPT72l87meZFtuciWkKKnpbEC?=
 =?us-ascii?Q?ZXPI46GeSkBhXsRpd3K/aLcVOgNZKj5/gGz8LpZ+3fzvE5quKI54ZnMNnz7D?=
 =?us-ascii?Q?YVNUKBk6Olg3jYfzWGjS3kaMfKiApuff6sB+Lyzpu1uNfFJlg8I+AmESZRDz?=
 =?us-ascii?Q?VJY8+7YC5sxdUL4abfC9M0GeOJLhVcHX86JT3CZs2ZIApEP5ZQkmzIKp6iQL?=
 =?us-ascii?Q?M1QrCsvyjK7bsKIC4QLKSKbFxKMGBk4x6fdyfC/GXfSia11c4gXDevglrSR9?=
 =?us-ascii?Q?1Uxb+toyK/Uln6UvpJVXUv4eNLI2RFruNYqPwE43lrQeeCn7iIh2bOZm5/Gn?=
 =?us-ascii?Q?iyk7K8nQguvIXUIWS1UMiT5lbilhQfipczQsVFfZmH+7siMr39m0NnbocE/p?=
 =?us-ascii?Q?JnyBOeFmavLxKrBw+1QivCIxJN0HD11tS2bcNPhHWk6hRgaQn4DhyFh+oB1q?=
 =?us-ascii?Q?j9VbYJ6wezew1RrhlstKS1PZnZfEMZiiHswvHvtCinYOWuwLv8TQt5AhsPTX?=
 =?us-ascii?Q?Alfu7A3GuVKP2cjO/zftTjki/tHBIaHoG9aIUbPkN3/heV4QILmHnpcd6Nm0?=
 =?us-ascii?Q?O9rF6qNQ48R52Qq3kTRldz/Kq/ttC6BGqSK9hrrmSNXkezPQ7s7ANP0sQvzD?=
 =?us-ascii?Q?bxU5nHBTsQ+dpIZnWbVcSgQyB2c0nvOVeyM87JQp7s6Mez2X5yD7xA1cYvpr?=
 =?us-ascii?Q?cNAC3rxaF+CTWsN264a6+uH+hDRjQCxg6dSStghOQ4+D7L4ydHIupe8w5sZE?=
 =?us-ascii?Q?H8FZdPnucTrGfZWwz4tXVyMjAlw1/xrT0O2EPsd38mvaQFaUeZk4jeFTu54S?=
 =?us-ascii?Q?poxpjidtzvsjrS87PPevJ9CoOJlBTBcPefrPWKAlycRiHuE9RFg+1ZOIMSEW?=
 =?us-ascii?Q?XKZWZ7vCI8SB4Ci3ffxZ8xzZYu2/++N6BMEqnSWSLdGnjJ5nPBGRmPMRi04v?=
 =?us-ascii?Q?D2JfkWjZ+VePrnkNZYanGpMBexqKBXack3Og4ExZTEIK7lwUQ7Qdc5kswh2V?=
 =?us-ascii?Q?GzDmm3MofSiLj9u5XEOy93fwFC/MS8hwAYXfHE/uY5NsGjSXbxzEaokG1xS9?=
 =?us-ascii?Q?Rf8SAPQrC0/bEU0r2b78zsOOMZcaC53WxaktQIqwEhsiBsbQjvwhzxgX0SJH?=
 =?us-ascii?Q?kOmFKqz2JfEGFk3+N7NFK4uuuCgyJT4dFJivC5QJSYkFnoKFk9GxDSrSuWW6?=
 =?us-ascii?Q?AnjAbz+MEIdEhuokh8edqt/G8/OxZ1ZRKl8KGqjHeUTjTuPcx2iMTnsM/FmX?=
 =?us-ascii?Q?nNGL7LtlJGNw/I38s/62a2vs5NsE3/517/8TGP+f+EShn57GooxtebEhi5PY?=
 =?us-ascii?Q?Qq6Y8MsY6J9ZBA6YHU2sCUTj9EsPqHM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5430.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632fdbf0-b4b2-4411-4f91-08da31d02045
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 15:25:19.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NICf7rN0g42BYRzTBEhlNULzNysB1+K6zOJZtKHfWfj0330JfRsQZZ1L+aw6YM3WLdxQd8LifZaIscjNUXiVuv0q0uXxtWdIBmKYX4PvAPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3309
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Fri, 29 Apr 2022 13:14:12 +0000 Maloszewski, Michal wrote:
>> >> When we have state which is running, it does not mean that we have=20
>> >> queues configured on PF. So in order to configure queues on PF, the=20
>> >> IAVF_FLAG_QUEUES has to be disabled. I use here EAGAIN, because as=20
>> >> long as we are not configured with queues, it does not make any=20
>> >> sense to trigger command and we are not sure when the configuration=20
>> >> of queues will end - so that is why EAGAIN is used.
>> >
>> >Let me rephrase the question. Does getting out of the state where=20
>> >error is reported require user to change something, or is it=20
>> >something that happens automatically behind the scenes (i.e. the state =
is transient).
>>=20
>> It is something that happens automatically behind the scenes.=20
>> It takes some time and there is no guarantee that it will be finished.
>
>Then either wait for it to finish (wait queue or such) or if possible reco=
rd the desired config and return success. Apply the new config when the res=
et is finished.
>
>It really seems like you're making users pay the price for poor design of =
the driver's internals.

It is good idea. We had doubts if we could do that. I will try to fix it as=
ap.
