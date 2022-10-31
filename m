Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1886D613F21
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 21:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiJaUmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 16:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJaUmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 16:42:40 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8E213E9F;
        Mon, 31 Oct 2022 13:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667248959; x=1698784959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7JmZd5Uj5itffLh5NvtGKdgGKInw8OcUyBiIL6nhYXk=;
  b=fDBKLWPWOyGAFZg74TzFbcqM+6AceKM+bNpLfswE0HpSpKaUCUEypDTI
   KminA7mSns9z/bph6rb9PRiGp9FMKpABMOphuCPEMqFfwUbr2nkW9hwkp
   XMRn0cpmejOnrgYfoC6HbDJdT1EwwfCOsPUJrwDbEvEGkvJv+5bL80Hyd
   VGZXmtEzdOWOwE9uOaTN0wFHSKlWC7vBWN5jTFaYjHtFK/p34LcJ21Qp6
   gYLxc+AwD/WjYzZD3EcpOBteTgzOKwN875YoxSyO2pglN7k/Z2UQ7/+Z7
   jv0lqd6S5DK/bL8WiajLN+7S5tRHmCUMFqshTUPl8wnl3D39aB6UXNFex
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="373206020"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="373206020"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 13:42:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="758963536"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="758963536"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 31 Oct 2022 13:42:38 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 13:42:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 31 Oct 2022 13:42:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 31 Oct 2022 13:42:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmBGrhQWfdGjCzfuMCvi9Gc2K/Xwu3szS1cUYjHUtBTMha7zGkq9SpF+CJftKXQk756glfCjfhOX1+GqEOn6WgDvrjs0rLNJOaqqdgPTw9/X69/Rkq1DY+1rP6p6n+fmH2KZhbADznzGi6dV4HnLX6nl7yWDxgipFmZoDpP7ufFoBbp6HvXjg1iIVNrvxMqAiNstVcDs3XiqCN4tqbp902qbHOaQHJ8Fl9WvUIucEd2lrvVLlNF+wQolQWYD1HhaRqBPtqWcauZ59+YsFIkNH6Tq3EbZF5rqE5wQZGcEmdX77JLbJ9nVHPjR/0C82sxDC2IXx59WWMpvmuj/M+JrgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsNbgQ2gyvB+TzSr5wDNoprlDgM9rDf01jcJWXsoRpg=;
 b=OiQNktqDV+Kb5IoGMHHlFeMAlWMa4T90P2A7SIpKsVsJt8e/JwUfkKst4sXNF+EUhLw2wvvLpiWVqugVPdwUI7tnS+rnpf2AlNlOukedmLMtcQMqLhLDo6K94ftP8tiGMXbG01P9tKbup3DUkUMgSB71MmCaJ7Su9Q0MvbKNrR1U+KNr9iZZ4Rw2SJLhIMSRptS6J8r6/JGATolbbcma9Z+b+TUAXJbBmnVjU1vK7wsiYPtbckBHTyLBfGC7e6+U4eLwe1uWsev5gIZu/oOSAHbjlnqE0siuJY5Oqy2vIQ7+95fMaUS12JUyI7kIg+yVd5Jp45owR7VdngCiiHW3Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1324.namprd11.prod.outlook.com (2603:10b6:3:15::14) by
 IA0PR11MB7308.namprd11.prod.outlook.com (2603:10b6:208:436::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Mon, 31 Oct
 2022 20:42:36 +0000
Received: from DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::793f:3870:4550:8aee]) by DM5PR11MB1324.namprd11.prod.outlook.com
 ([fe80::793f:3870:4550:8aee%8]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 20:42:36 +0000
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket size
Thread-Topic: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket size
Thread-Index: AQHY60UEuvCQ5/6nqkOEi2jDwjCFAa4o+uNA
Date:   Mon, 31 Oct 2022 20:42:36 +0000
Message-ID: <DM5PR11MB1324802F3F2098CB3239CF36C1379@DM5PR11MB1324.namprd11.prod.outlook.com>
References: <20221018092340.never.556-kees@kernel.org>
 <20221018092526.4035344-2-keescook@chromium.org>
 <202210282013.82F28AE92@keescook>
In-Reply-To: <202210282013.82F28AE92@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB1324:EE_|IA0PR11MB7308:EE_
x-ms-office365-filtering-correlation-id: 22ccda69-7be9-4a51-2fba-08dabb807195
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: in6LOzqzJc8skxjOH6x1MtEY1hn6VJHD7UMwlF1SCslNSL61lIFCPwcbk/Iqa8L9x0XhYw91YqYXenRlQw4EQa5KDIX0vdlGW4L9ZE1k3bqQNICaEja9zbH8nt4lMdIIpLk1Ld1pHmd6/PXptRt5oApcU6et2X9puy+tzqnBxthviH3Q8xPrySvD8/4xP8TwdGnxUDmO+r5gdMjn7TaNoWL+r1SWCIGnhcWBY0r61JeicyQGGOXizr4tl8eb6Add4UwbqFcW4LpFOU4Zripsk3bdWGzAcR/Rrc8g5FMFyqSthWl75VsMIUAoFyGFT6cxibWXLyvrZlUtupvaR+PaZae6prWRS1gFluxCzF0QPAg66xUecvsyDwvUHaecWiK3jjLTyDrrA46FE57Wp/N6nC3jO0oidJrvpZHlo7uz9qpK7bYJdXOi3pcwLEkchPl89/VXSJGkro8lVenaO64MYLW+cAJ9lFn6F7DWLZGsuA3Wa5q8wo/WpD3TUACPzPAL0yW1qSv6E8XsDmWUYaklme09OSVUjGMdC9msZkcCYKrnjARaLywPDWr1sdy60kq12qj9uAl8AwsXE385TPn2ciMR1O0x5liekeaE/u1ZTphcoswnFql/K5drEllXJiG8H4IlLaoVsg4EMr2tUE9NBnJIFdwn2tj3Z27DsdMcKdHeGv983VAaWIwGF+Piqdv9HGK3o+A7DG90ClVnesF4J6vrtwG9eMbWtPXH6aYB6QImZiSZGDVNBGeBoTR1DITcpo6Q+sD99Q/BHDJIDoIWlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1324.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199015)(66446008)(33656002)(86362001)(6506007)(54906003)(38100700002)(64756008)(82960400001)(76116006)(66476007)(66946007)(38070700005)(8676002)(316002)(6916009)(4326008)(2906002)(9686003)(5660300002)(41300700001)(83380400001)(55016003)(66556008)(186003)(8936002)(26005)(71200400001)(7696005)(478600001)(52536014)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FKTYgNaaEsiphb5sztbkXowSiWl7kv2Jq7vA7jys1ps9G4BQrez0RLtdaSXe?=
 =?us-ascii?Q?+5Fk+9U0OMIixbueS68Brr/1yxcM6MOkeUlZORPYh0Fe1nbORraPL45pkGZ7?=
 =?us-ascii?Q?3Qo9+E2I3Ck9RrQusy1rBLqDjDmVveG+EneBjTYye8uJRuIyLcV4BR81kOs0?=
 =?us-ascii?Q?58icYiAAXlQxuL92k8/hdHxNy1Nh4Fmvi4dVzIRIU9ZnHgE8ufCJlO4ghB7I?=
 =?us-ascii?Q?5K0Hool1BRbzRJ2YB74lj4ZR5Ihguw5GQOiiSlyPOzDOsx7rjhwltwsizWbn?=
 =?us-ascii?Q?ydoydOsy2NXf6IxE1jmVn+C7G+IahEEVyalqpM9OKPT76sxVKZnhFkAkq3e7?=
 =?us-ascii?Q?26VY6jAMJac/vrzk1CgPUHjb7lioZ+Z/Bk0B7fA4Vh2iqRLBkcb2G+UdfJ6W?=
 =?us-ascii?Q?UmaIihQR3tbfkjIPtUxMcPJLTrC40pljegBznzG0U9lUM2zNmnCw/sVRH0Ak?=
 =?us-ascii?Q?dPqi0Unz6xk7Xjh8W3PTtWV13cIwvHtwSWdyLDf3nK9Pd8fJJCDs6lgV5Xx/?=
 =?us-ascii?Q?8Fj8Z9SwFL0y0Ik8E8e8WjuVGClavjqqZp6U3/5oYZ2JORMdgDqTHl9UV6PN?=
 =?us-ascii?Q?8Pth90BsckzC+cMePu6jsGwO3fQnUMQ2ipCKEnsjbRt7F1ZKO3Cd3+j/jrJh?=
 =?us-ascii?Q?shwarUK7UfVNpOKMkZOCMjlCNxhbeGzLK2GsmP4I1Gq+oY4g9N7A2gErBsll?=
 =?us-ascii?Q?RTZeg8ZsjSp4xLy6SC1xl5UoFzO8an+vohyfrIx3ZhMGNScsKCxRzbunRXBC?=
 =?us-ascii?Q?d2zFbUqP94QHBjarq1c3oac4DKHyI9LEDxbJpUuyo54eRb+p3XXu6aYTufbb?=
 =?us-ascii?Q?tgw1CAKfiqq/7y97+eTNT7wTYazHH85pUEd3+Q/FOtnx5Zwb50g+8/YJoLkA?=
 =?us-ascii?Q?us7Sek/g4M4IIU7Vsy9t9Qp2cGUulFbRpTkeOs1ay9UhXLVaggywNq/f1pOO?=
 =?us-ascii?Q?CKnw0T60i09XSVqAczLY8HYj+VkWpVkDYGmXGck7q2GmLxdsJf+9otXToCjD?=
 =?us-ascii?Q?jZdj2pjnNWfUoFoF9r3iP8mdGh4QN9YsRBvNIcbODlDEtSmu3d9d4meKkq1g?=
 =?us-ascii?Q?0jPN9rF4Ot5FtpAbaeBXZM0iQRojKX2yGeuxEifLo9CemaiZs4l18H68H3t5?=
 =?us-ascii?Q?uxSCKCipor8n8wlPeu9exqI6DUtsDJ10X3Rg2k9PhdSxve0EK5XNuDi7VQq+?=
 =?us-ascii?Q?qu74vNxhlxCxcjJRgB1vtHxJKslTaT156vWRnqJmTZ9KyJK9Rr83tRkX85nO?=
 =?us-ascii?Q?WBlNxEwoF7mF8NqpP/r3BXbfTP0KJg7skoiNopH807oQgujij2CAjQsL2ftQ?=
 =?us-ascii?Q?NlaiIqRnVnj+albZhsDA2nF6yLkURd87HpaUf0SkqU51FCqwTXReoNRUOlOU?=
 =?us-ascii?Q?5dK8vpYLcHoWXvpD0JZikKCnZrmXCqJANllLM8wwn++txEqLqgteB2RKxeRV?=
 =?us-ascii?Q?AUoJs3f2m5A4XW/UnBz4urFszvMR6iece0o0qEV8OtXYSjtdC0vjnbAw/Kik?=
 =?us-ascii?Q?etK1h9ebSbOYloqfSqcLZFH6cjSDz3x1FxbPKKz+QirLWW+wFLV9tl54H237?=
 =?us-ascii?Q?Mzfla7UcNaF4dW3ZyiSCoKWJhklkV7wwP0lIjbH5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1324.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ccda69-7be9-4a51-2fba-08dabb807195
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 20:42:36.1532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 45vzYJEP+rbvdCZa8CnTnP4y7HqkkXfDZk9jVSB83b0oP+bbO79sxcEpc+WUwmMstkx9oYHcZFIrY8elZJ6uyzWk/gtnGkE91wtbEIdRoEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7308
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Kees Cook <keescook@chromium.org>
>Sent: Friday, October 28, 2022 11:18 PM
>To: Ruhl, Michael J <michael.j.ruhl@intel.com>
>Cc: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
><anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
>Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>Paolo Abeni <pabeni@redhat.com>; intel-wired-lan@lists.osuosl.org;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>hardening@vger.kernel.org
>Subject: Re: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket si=
ze
>
>On Tue, Oct 18, 2022 at 02:25:25AM -0700, Kees Cook wrote:
>> In preparation for removing the "silently change allocation size"
>> users of ksize(), explicitly round up all q_vector allocations so that
>> allocations can be correctly compared to ksize().
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
>Hi! Any feedback on this part of the patch pair?
>
>> ---
>>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
>b/drivers/net/ethernet/intel/igb/igb_main.c
>> index 6256855d0f62..7a3a41dc0276 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_main.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
>> @@ -1195,7 +1195,7 @@ static int igb_alloc_q_vector(struct igb_adapter
>*adapter,
>>  		return -ENOMEM;
>>
>>  	ring_count =3D txr_count + rxr_count;
>> -	size =3D struct_size(q_vector, ring, ring_count);
>> +	size =3D kmalloc_size_roundup(struct_size(q_vector, ring, ring_count))=
;
>>
>>  	/* allocate q_vector and rings */
>>  	q_vector =3D adapter->q_vector[v_idx];

Hi Kees,

Looking at the size usage (from elixir), I see:

--
	if (!q_vector) {
		q_vector =3D kzalloc(size, GFP_KERNEL);
	} else if (size > ksize(q_vector)) {
		kfree_rcu(q_vector, rcu);
		q_vector =3D kzalloc(size, GFP_KERNEL);
	} else {
		memset(q_vector, 0, size);
	}
--

If the size is rounded up, will the (size > ksize()) check ever be true?

I.e. have you eliminated this check (and maybe getting rid of the need for =
first patch?)?

Thanks,

Mike


>
>Thanks! :)
>
>-Kees
>
>--
>Kees Cook
