Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC65EFBFB
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 19:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiI2R1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 13:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiI2R1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 13:27:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F561DADD1
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 10:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664472471; x=1696008471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FlPTVNFk8n/qkNTrEWoNpjEzYrl8bOpmHdRDFD12NKk=;
  b=FPcsEUuWF2I74vwiis2kXm7fj89KmdYHy0g4DgTWwhKXLxpZhfyy00CB
   n7OD8qUp/1GJWZj2XG9TtAUhcfYvNwVcHwfybohVVgjv+8+dJ7gm5vNDr
   /+iOyMsREj0YCtA+cMkrj/kCQ/k8QKjrs9izIxb8V0TIAgKM68wXxT86o
   gchFNV/wDM+/l16Lu5NL/Fv0u0oiHQJzgz8TQWeuJrDZgiJWVUSUXAlbE
   +C8E8D+3pbKk4Ll5JFe388fF92lq5HI0aawMPnlL1M9AaJCEcEqHPOQe6
   +HWFIVCmDL9G6vr4v7rhipdocoNtSrLXxA05bA4AkjUC4aQ5wD5cwBTKE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="363816317"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="363816317"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 10:27:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="684938968"
X-IronPort-AV: E=Sophos;i="5.93,355,1654585200"; 
   d="scan'208";a="684938968"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 29 Sep 2022 10:27:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 10:27:15 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 29 Sep 2022 10:27:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 29 Sep 2022 10:27:15 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 29 Sep 2022 10:27:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIK24a3e9swXVG8YmPGNBrySeq/eoUqJ9sw/VnbBgzQn2E1bGv50VzyZlfjTeVMW5Ue8DlhwcNIBBFpgHcOqogWs6gaILXYzGYDwfG+zuUZY6z6h0N07VtfuaCJ1aCXt1nx5Nlj7zB5uBNOWtoBykz9rQxfj+G5D1y7SOfhJGJYCtBqps9N7JMt4q5tkfE75aePaUjn1HcC/bUN3cGbo+7mMIuHBWfYqtBq4croMAvc9cNufU5MHmlcV6P6eRKhzT2gmTITup1Ury9sRpo7NOo0CIPVQK/m2jioubHcpiyVVaO+zpKEkKs3S5L5WxBWKEIFMUNBwZeuikSDendOOUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55X6SV9aNfDxubR0e/2zcOZcQG/jtYNTtBnHymwy5nM=;
 b=XAgbMLXFfsQ7QQ8be0+g4tk+BEmduWoe8wzbDSPRN23MYzufy1crR0S+/iSip7iZ0y8dJ/Id34qXLeyLjUpDTXN7MGMVYYIzyViRIgEv1TOFNi1e+phbxxvvQu1JgAlB+fNOzWSeb4KJ6x0H9RKEz2081PQZ9K1ng9Nr1PhIW2lJqsqjywx1t6y9jhH/71MDhITUXaG0hhEzkkHlYxt8Ob3mkG7z7AAnSfaiovdAHPjw8/rIe8TDvFz4qFc6LJUFVDU5BdQLCHgVfYMr6DTTWBueDrvYvDSdLqnjUtTF6z8lKJfzOGh6YXWDOUQpUdZMiEYtnPu47WykaLSaXZbNPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5216.namprd11.prod.outlook.com (2603:10b6:a03:2db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Thu, 29 Sep
 2022 17:27:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150%8]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 17:27:11 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        "Florian Westphal" <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: RE: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags for
 new commands
Thread-Topic: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags for
 new commands
Thread-Index: AQHY1A/UzWA1AvCQV0ia3wM1Br/XCK32fl8AgAADtACAAAv/AIAAAYUAgAAY01A=
Date:   Thu, 29 Sep 2022 17:27:11 +0000
Message-ID: <CO1PR11MB5089F94062C67A8D608FD939D6579@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220929142809.1167546-1-kuba@kernel.org>
        <YzWxbrXkvsjnl50R@salvia>        <20220929080650.370b5977@kernel.org>
        <YzW+ml81tM9Rlt1i@salvia> <20220929085512.17be934f@kernel.org>
In-Reply-To: <20220929085512.17be934f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5216:EE_
x-ms-office365-filtering-correlation-id: 45fbaba3-8024-4a6f-10af-08daa23fd7a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7shoCx0rSS44A/7EgFkrUJDRe/aKR4AdRPkBa1v68CZRU2WB4+Znx3CQMEaarp48T+N4cMoMtDtBAMk46OuE6w5UeZaXtokLI7UpVzayhseaSYFIaPI6eV0znWDOFjaB+eWL0tLP6PmVsnWKL7kUbEumD7Sja9YR7SHv655Eft1/NWi2Areu6BT0fz48K4YilyVbUADhV2Xyn9zZzaT6EPzgbu0CE1SLpqUhyuvlI/fVS6eocwFIQPqviU0o/DfTPAxBmrB+wobpIawy3dTIKXx2bWoe684wjvDB3nyFflTCFlYHfb/PRLFmnpcM0uDqbSStNXO3t/YJhRjM5ttqXGtuYGFQBqVzzFeArTjG1MvRB+/kSdk15rin4mBA/9ijI2K46wlEJsL8mhcPCsedmsOtljQVes/PizKeOChceEp41alTXdFOpzbbd4HGOOyu9m84/0ilMbOHOZZRcyhHCbI9rs6Mqk3YLHAm8fGXzc+JA0srKUCx/9r+8kckdpO+x5r4qSjpr6U8NtUT73ih+IDaPmqRSeLB2ZsyD3S0AgaF656xVz4UCR2Vij24VJbGtnLtw9+RwBA6Dx0dCzk+4tgYfVeOm5tSOSkGHMvDT0zCvLgAPHDV6QTI/r3SAbNwGzDanvyVpyYW8vwDdfqndv2jdYtAnIKFwWKiD/418ClY5qZUPyPXBuNRVNlHJ6UpJvQ8XV48tVv5qrjUoRRWq2ZmeBrSeUFG4jZlryIUO2vsQO7DtX144t+PyIpJ5O7J1In07/rc9GjuYjvT+9qWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(4326008)(41300700001)(8676002)(64756008)(33656002)(66476007)(316002)(66446008)(110136005)(2906002)(54906003)(66556008)(66946007)(76116006)(86362001)(7696005)(6506007)(53546011)(186003)(9686003)(26005)(83380400001)(55016003)(71200400001)(478600001)(38070700005)(38100700002)(82960400001)(122000001)(8936002)(5660300002)(7416002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QptvQfYjfJ8NVvY9H8UEofYuviXTrY9g9CWu+ZiZVeaFEs8/mrojOvc3S6dw?=
 =?us-ascii?Q?MNZaAnSVhuBoWhEzwrqii0a0pngLIQcDjn2HCpW1n2aSIr38t7xP9+3HAIPi?=
 =?us-ascii?Q?7sDu7nzBGrs+nGjVgGDieVDtzyUGODM4VUcn0qQy60ouISFZdmRoChyXzkc3?=
 =?us-ascii?Q?+NPbhqFLvsfJ+c47hxTo0hCzzPGA+DM2p/lpBhjHa3VcgjqZbdr5AVzNaK3D?=
 =?us-ascii?Q?SaH9+KrFTA2LP0Bp8o/zwQDFRItpXLRzW+vgqFSKrvPPmxlMcKioKjj5uyP4?=
 =?us-ascii?Q?FslA4vMrwiQb0Upv2iy4D4z+HnVadCRb7CO4Q6ZJmX0lNDxHpZOyTXNiYL5d?=
 =?us-ascii?Q?ABEV2ISiuRFe/iH+poEYgCBPt4ZzTrdnobGJ+No4ZDPDYYCPcc74nxvm6K86?=
 =?us-ascii?Q?ugO+chqLgqg+RsjuXSMUPWn5vDGQHuUoYEVtLkbhLNBoBkwKvLm6afUL1hBI?=
 =?us-ascii?Q?gZS+gukQJk+EjA1bS3tQO2f4zwTQdAavYxn9NcjGDMmT/x2lIaLMDrJstX8v?=
 =?us-ascii?Q?0/jo9zVCWUDX83mgsIxX1x4l12bb8RUrC3XZ3QrHnR5rCzyoPyrTkD6orfiF?=
 =?us-ascii?Q?yJNhT/LcHCofWGrh7Hzhr6eZRVtifTj/bJmi1dOpwF+ZyvuPw5LShe1WRqm6?=
 =?us-ascii?Q?WJQg6VwMV0SIzp98D88hm8UByHfIiycZC2aANzqbXdZtxQYVhuRjGU/dEwz2?=
 =?us-ascii?Q?zVYCsoO+QlX1bPNByfIdaNJ1aEKY+U9xzETFF8WMITUYIV1TW61plMwwb3vV?=
 =?us-ascii?Q?d0YWetQE9odjEcFg7pZMIsf6DChCc3zOqU17jelaHIwRffy1JeGkDBMXxSfo?=
 =?us-ascii?Q?rH4Rs9auiyWyIG40aa+mXEeEosA2EYk3D+Lp7Ew0evI8mWVcBe1X2JCbYn+W?=
 =?us-ascii?Q?FiJfZCdSA0h6DpxVewcMo8oMQ1qqiuzCrhTNY7HPj+dVcSsTbamdYFywUGmz?=
 =?us-ascii?Q?DZjPJqdaBUC0NqGLd+Dfn6Rv7V6/GHc0cQSpUXWOTmqFl/8o4JS2VIVJOE5b?=
 =?us-ascii?Q?Z1rW2fGeTmWEqCIZEtPmJnZPehO63lH4j0lJkQXc5DGqyJgW9RO/hqJxlsbm?=
 =?us-ascii?Q?rkDWHAZO0JxQ0H2uAHNIdZz5ZnQec4bJlfSst8NUVgDidTLsFGgxEJQgeaTH?=
 =?us-ascii?Q?AqRvJU+qhXEUNMgaQcFk/O1uRkmzTaV3NEaipmzv1X3OZODoI63OBz8bTb13?=
 =?us-ascii?Q?kJMjXCIulDuUefpt4pkiDx0CcD9jc8a7rQ/iPa0TFqoZSqIn5DjY9JuyUOrb?=
 =?us-ascii?Q?FVqdv4q9hhr85XojUCUfW0jvkP4g84v1B+cuAz+rJNy7fwPFZ4cDdkYfept+?=
 =?us-ascii?Q?pzIKhqGMXaRzpxaibp6ljivOLr/NrAsKIvZeJhCYAuTF0sFv0sUnwDEz9vAD?=
 =?us-ascii?Q?8jUbMF2Wxo/LFSYhJumChSUhDQzzE9wW7UWtyEevUcK0dQjq6/IB8n5Fj+nX?=
 =?us-ascii?Q?0rYBEu21aoTEklpXtq9HaGPpTJmW4nBSfQfhiuadkBaf1fZPbI99/SvtCWjD?=
 =?us-ascii?Q?YlOquZV9FX+I6mjaDSp6wqmMUtawT7PurT8wFmhBdJPCqddC7dJ5prgav8vH?=
 =?us-ascii?Q?nLa56G7Oanv0iYFO7+JjnFlgXQ1ERCtYvjfQ1f47?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45fbaba3-8024-4a6f-10af-08daa23fd7a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2022 17:27:11.0330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRlSpMW/D1PSyJVyzt/n6f7HMN+JRQs42MfHw8hS48Ycgu7sdt+I1HI4+PoSnw+bgkHzkFjoQ8SKy49L5LspoYx0Kx+VCbarGFZFNqbQTq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 29, 2022 8:55 AM
> To: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; edumazet@google.com;
> pabeni@redhat.com; Johannes Berg <johannes@sipsolutions.net>; Nikolay
> Aleksandrov <razor@blackwall.org>; Nicolas Dichtel
> <nicolas.dichtel@6wind.com>; Guillaume Nault <gnault@redhat.com>; Florent
> Fourcot <florent.fourcot@wifirst.fr>; Florian Westphal <fw@strlen.de>; Ja=
mal
> Hadi Salim <jhs@mojatatu.com>; Keller, Jacob E <jacob.e.keller@intel.com>=
;
> Hangbin Liu <liuhangbin@gmail.com>
> Subject: Re: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags=
 for
> new commands
>=20
> On Thu, 29 Sep 2022 17:49:46 +0200 Pablo Neira Ayuso wrote:
> > On Thu, Sep 29, 2022 at 08:06:50AM -0700, Jakub Kicinski wrote:
> > > > no bail out for incorrectly set NLM_F_DUMP flag?
> > >
> > > Incorrectly? Special handling is because we want to make sure both bi=
ts
> > > are set for DUMP, if they are not we'll not clear them here and the
> > > condition below will fire. Or do you mean some other incorrectness?
> >
> > I have seen software in the past setting only one of the bits in the
> > NLM_F_DUMP bitmask to request a dump. I agree that userspace software
> > relying in broken semantics and that software should be fixed. What I
> > am discussing if silently clearing the 2 bits is the best approach.
>=20
> I don't think it is and I don't think I silently clear both.
> Here's the code again:
>=20
> +	flags =3D nlh->nlmsg_flags;
> +	if ((flags & NLM_F_DUMP) =3D=3D NLM_F_DUMP) /* DUMP is 2 bits */
> +		flags &=3D ~NLM_F_DUMP;
> +	if (flags & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "ambiguous or reserved bits set in nlmsg_flags");
> +		return -EINVAL;
> +	}

To clarify, my reading of whats going on is that we first see if NLM_F_DUMP=
 is set (both bits!) and if they *are* then we remove them from the set bei=
ng considered  in the following check, thus they won't be reported as an er=
ror.

However, if only one of the bits is set, then they will flag the 2nd error =
and thus be caught as ambiguous.

Since we modify a local copy of flags, this doesn't modify the actual nlmsg=
_flags field.

This is somewhat tricky but I don't see another way to approach this unless=
 we duplicate the NL_SET_ERR_MSG.

Thanks,
Jake
