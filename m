Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFBD6D9359
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbjDFJy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236821AbjDFJyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:54:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81C1B476
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680774719; x=1712310719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/9+UTSM3aUrdwQD9eDBYFjeb36Zy+EXnttLaV3cU5dc=;
  b=ht2Q/Q9vzsrV76vh+GZtGLi4KgrjHh0Af6F+pQXlCjWZpMMItkdC1QBE
   34epxGKua/qcyaX+GXz9mVkc1AIEoIUz/86Cvot/UDcM1lMGvU3OKJviy
   1CHmxbEU3PovjGLTHBcUEx2eRUKYl0QUeDUtB76Pq5DeWRr8kg9uTqce0
   I78NE3p+Oen8JPSoNpvEZqAjgHaB8PjrzhET676MnoZkSmdWgQS1e7a4y
   tvkY2Kxsf//kAtbo8+Q/n7nKROMbRe+dnDoKYgRVxQz7D5TRSA3Hn9tlo
   OY/GIU85X3h/8eDz6Ujoe0+5a17/Tb4ILJqjl+4bWBfhLX70vkjR5wtAf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="342703577"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="342703577"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 02:50:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="933126998"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="933126998"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 06 Apr 2023 02:50:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 02:50:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 02:50:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 02:50:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 02:50:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUXdvYUtHWiA2aa6HSe1pMStJENx8Vm7TggVbIIEkHU+y0cQCFDzzzMUscXsB1190JSvhab2rZsYMRzwcdERct4FWUrmwOgsHJG1m6suDBCg1Vm/iT+yL47piNxtql400IZ3XNnooBMQumuINWqrr1WnwOuXpmKQ5Yqy2Wd3DLhQ+4oHUTtkDT5/T/m9rcGQjItBWj0NqEpOKFuBtsIee0jXsMovhqr7Tb/WrElBpMQ3zcdc6RAZ90N1LVOINuEG/cn+id3W0j2W9bTstW66kkFZ3OiVGAKwBdAGxysiq2qKSjHOEsLqOO05CQjVXDzoTHBLSMOuNMj2xLZnzMTT1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9+UTSM3aUrdwQD9eDBYFjeb36Zy+EXnttLaV3cU5dc=;
 b=l+nlLVE98b6JB11eZQp6kqdRdNPkSx4b8/m3y3zmXTlf+ACAg6GGeBnty48fNjyNKnw2+uLpEq2bzcDfvIGURJiW1EQrH9w4GIQ+hSupCrRziYixvKvw/7wOA2YaMN9pCwAbxdpbGp43VTDivYI2Hl0AnxmcZ6qcb5k1v3qzaMhEUiteSatOzUvzaLNPuSrNnQegmQvXIoebG/WijvodMCMF6lKr/EL+mFTS6pGeRIekQpZ99j0yohHJ3oG1Dj4kodTmvGf1rBXfNJmKkr8OsD+Y1j3dtZIVVCxX8AD24mH2N2K/7wImfkqnk5veK6aJ4LcdyXt5fErBAxDkTPF0Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3521.namprd11.prod.outlook.com (2603:10b6:208:7b::32)
 by SA2PR11MB4892.namprd11.prod.outlook.com (2603:10b6:806:f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 09:50:41 +0000
Received: from BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::3788:9800:d35e:32c3]) by BL0PR11MB3521.namprd11.prod.outlook.com
 ([fe80::3788:9800:d35e:32c3%6]) with mapi id 15.20.6277.028; Thu, 6 Apr 2023
 09:50:41 +0000
From:   "Romanowski, Rafal" <rafal.romanowski@intel.com>
To:     Simon Horman <simon.horman@corigine.com>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>
CC:     "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH net-next v3 5/8] ice: remove redundant
 SRIOV code
Thread-Topic: [Intel-wired-lan] [PATCH net-next v3 5/8] ice: remove redundant
 SRIOV code
Thread-Index: AQHZXYKN+upcw3swB02xhdAOJFK/Sa8NFOAAgBEKbyA=
Date:   Thu, 6 Apr 2023 09:50:41 +0000
Message-ID: <BL0PR11MB3521887E3EBBE88EC91133898F919@BL0PR11MB3521.namprd11.prod.outlook.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-6-piotr.raczynski@intel.com>
 <ZCBKVN8x8aQ2SY9x@corigine.com>
In-Reply-To: <ZCBKVN8x8aQ2SY9x@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3521:EE_|SA2PR11MB4892:EE_
x-ms-office365-filtering-correlation-id: c5e3f504-6318-4c44-e9e5-08db3684624a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGqqJLr/HdPM7RCWhf1J75jK96ACFzk0yALBs8XmVH6+A6PHbEikm9L8nFWLLvtNIp+1e8bghYNIq5op0oR2HTTPEkkFvLTtLiJiywrn3ll8Fx4YZzTC/45Gdtn//BPdMKXv+pbL8phGFExm0mZTzX6GBboiJmKxIw/tYFcTHNx0la/NoHbJHcXX0taMY94MX16RI0jo3SusSW7bOxOwJEhlhWwv+qkj5aRM3f0IoB6kXluO3Id2TnyqyxpNrLnQyNkJ9tHIbp74Obj9yfrK6eWWEn4YtkO1vP4XMTsfgMPwvaPy3qbJY808WbEuBkIZU3ZeYZFff3fBjdo0ny4gyjmC1qrTmsm0M3CzpwLQbZq56wEAqtm5bpWT1gUbd0VBzfb55nsIRk8ewZk8nlP72231vuR6gtngm5w4RKVrz5lnXHaRAJBunJnq5PiHV1x/SXJ97R8NCW0WqnSHID4uiukoaeDmPXAAIfCrTnUeVVvpeMGSqdvKw6nacgUXYv0/l2myMtPdDLlxtNzRGwAfJgRSrUQJy41XcECF3B51eBZ6C+SFPMFUIASRLBamZqAHHwMI9jUfaiPRjT7oe5tauoFPIT59yT/nqlrjoxEN4YLI/tmRCw3g+2l+wImmcGkS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199021)(26005)(6636002)(110136005)(54906003)(478600001)(86362001)(53546011)(107886003)(9686003)(6506007)(186003)(316002)(7696005)(33656002)(82960400001)(71200400001)(66476007)(66556008)(66946007)(66446008)(4326008)(76116006)(8676002)(64756008)(5660300002)(55016003)(38100700002)(83380400001)(122000001)(41300700001)(2906002)(8936002)(38070700005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ba5cDUmok9vS6Mqazq3iH7VBXJx3I5fY8c/Q+sPrlOFtmvJ7znA8NhAz7HQ+?=
 =?us-ascii?Q?ZgMvxuNcrYJue+rdYa0t7JugCW20Td4rQCuREOmHQGZarjw0/ATyl0a1NleQ?=
 =?us-ascii?Q?7ONWCvSFInb2eJy80WTZOdUXU68jgBm7eyzVc227By+mSWgqa9YcbJ5kpDqH?=
 =?us-ascii?Q?/hsloOEJiQQFSOcAHbvTyLhZ/aDv++pQ0IuSzGG5kxRkdlEZ2AMQGobaTEYs?=
 =?us-ascii?Q?Jn7bDHJR544FIxquXAlNhpVhkdiM3j/D6a2Fkl4KBXxWq3+0+Bt3/3mOgSVm?=
 =?us-ascii?Q?3xhOnT3oGDu6QwHs4dzVMLucAjUWU+GmPEfn41mgYMJYAofe/HyOYKuObf4g?=
 =?us-ascii?Q?LpiBbNt7EuIXLyCGvDfAdqD1azunpq0cfG1rSCT+XkK4YnzYne26yCjsd1HT?=
 =?us-ascii?Q?YA82mGb8OtQrSrLwOs3+Uf5J/kZhzAGCAtuRjO1TxXRhfuhy9eNP09WODdc9?=
 =?us-ascii?Q?up5QOl6aH/O3YQXD4kSOwIpXp1qWWki2oD4nAjKYPF/Jzu6N+1/52gc8MZKC?=
 =?us-ascii?Q?WRdTeLfxf8S+gosOss07Zkz9DunpCAlDTfXPLnmUPxobJEtJhsqSNxfOt5m9?=
 =?us-ascii?Q?gHhjt9o4SI2WQbZW+9a9sfhjbKDRHeMh5bkfbgQcldb8vOByCKqfNe+hAyw4?=
 =?us-ascii?Q?JJsZGGKCzIeSeoSP9wbz5yRtMRrPrnNWz8soTt8qaRlNGzbSl33Or1FrtYIe?=
 =?us-ascii?Q?3d6z1n9rxqf/0qGh4lz1HIBgLei48McGp/5uDLE4VkXKcVmnKkpdXynd0s33?=
 =?us-ascii?Q?ryOEpyfKQkn6m+HD/W5C2KhTWyyP6xNIT06dH8/do5FibFoL+zAl+Mb1Dr+9?=
 =?us-ascii?Q?mrVPAlID7928tnBv0wWZUjrlVzTLLxHwWOpjvw3uz8fAqTe4XfS5JjuYA/yx?=
 =?us-ascii?Q?+r8K3nGP19Ww5uMuhz7FHJaFTKdTXwk2dSy5mcSDAytkAxREoCld2Nnv2+rs?=
 =?us-ascii?Q?bZigSQlm6wUJxGHp3c/TyTk3uGXdkMaDuFZ1G/O9J7x+6dDwWY18K+SRkPFd?=
 =?us-ascii?Q?Rs4xgZfQY1tUzf4OQj6UfN16gQ56G+5GcNa7nd8Nhym0s4g0okTz+duG/gwc?=
 =?us-ascii?Q?IL7ENJ5wdDNyxntP3mw/0DJkvyyvYC+Y8xp4KKdubKscz1Py63gihXivpN9u?=
 =?us-ascii?Q?psw3rQYklV1+VQWx/d6nFy1PE/EPR4jvwdQk1wEwZClf7lkULroLC0pixED1?=
 =?us-ascii?Q?YDXIOb4Ro70m7J4HYCjyucnGBkqdN69ydlIEQ4Rfvf7IPwJq0K+/JBJ2Bnk1?=
 =?us-ascii?Q?p9jFuMc5xlIQUHZMAx7OcaAC69UQwkqOOgsa1BvSl7/cgwnrAhc4YJxT2XCs?=
 =?us-ascii?Q?rtvEkZB2nGQs36P2M+zOU3WmUaFgouj5ZpJxSjsCfxtYf+dzZ7Y5ll1dkZm1?=
 =?us-ascii?Q?SWSLBe3AYaY4E5PrT+Zqc0Q/0UtXIJ5TCInK8Bo9V7D1yB751iLnacYCpNA8?=
 =?us-ascii?Q?1xqVDmowsLBVl1SUTojZ7DR+MuEHjdF99h2m5RmFH7Hzh36E/z+Esl5EPE/f?=
 =?us-ascii?Q?6S6vOZgCPOZywL9MSfyL8IXEmVVgveTF9wxR35wx98zKjV/cGBgtXBfVapGO?=
 =?us-ascii?Q?gP2ogpidjeF8Tb0Y7LNl/Psd4eSrLy/FnaavWvDFY8nbL82ZmC1XYhnWhSmd?=
 =?us-ascii?Q?Tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e3f504-6318-4c44-e9e5-08db3684624a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 09:50:41.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Dnppnnu1CbvQg+Jn9pVXr95XXMftRvHY6oQ+QPKADvjNnHGX+hna4R39pfgSFptymkIeMTbMzlG+WPJdmbrEvpifl//HRWeP4EYHrYsFzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4892
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Simon Horman
> Sent: niedziela, 26 marca 2023 15:36
> To: Raczynski, Piotr <piotr.raczynski@intel.com>
> Cc: Swiatkowski, Michal <michal.swiatkowski@intel.com>;
> netdev@vger.kernel.org; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org; Saleem,
> Shiraz <shiraz.saleem@intel.com>
> Subject: Re: [Intel-wired-lan] [PATCH net-next v3 5/8] ice: remove
> redundant SRIOV code
>=20
> On Thu, Mar 23, 2023 at 01:24:37PM +0100, Piotr Raczynski wrote:
> > Remove redundant code from ice_get_max_valid_res_idx that has no
> effect.
> > ice_pf::irq_tracker is initialized during driver probe, there is no
> > reason to check it again. Also it is not possible for
> > pf::sriov_base_vector to be lower than the tracker length, remove
> WARN_ON that will never happen.
> >
> > Get rid of ice_get_max_valid_res_idx helper function completely since
> > it can never return negative value.
> >
> > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>


Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>



