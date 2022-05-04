Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827C051AEB3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377869AbiEDUNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358149AbiEDUNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:13:31 -0400
X-Greylist: delayed 1915 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 May 2022 13:09:54 PDT
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F8C4EF4D;
        Wed,  4 May 2022 13:09:53 -0700 (PDT)
Received: from pps.filterd (m0209321.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244GRh71021769;
        Wed, 4 May 2022 19:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=KY3OL/i5SYoY5Pd0Wapyj36i2HGyt24qGsNiH6iETi8=;
 b=Vbk5i+ZUQSNDT9FpCnf7KEYuBNppGzxdDhw0pk6TflKvTTaGPQQSmoIpFlvGphAO0Fr8
 QXKXfsYoES1ecEMyD8csaBY/q3prgtmXDDt9Os3esBIrL/I9QLlrx+tn7wwwtUSJhzZM
 lHgb2rK7e0FpMfTZiog85bMAKBJ72uGQXleDzRh8ZZpzynzQuYJJtSyRfUeGMPFzUw4q
 Pr1DfnFMTEXCQRnGM4i5uaQtFFbuofUO7jXp3KpBYCi4NurzbPsoda1gXBI1FecQHdnQ
 QVWUr7FYW3+mDvXCMskoF6hxOfP0TIPcY/i0hldYYg/W2cXPZR6pzzwRrMQ+AiAyFWzx 0A== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3ft6hfaraa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 19:37:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TikErU62lO9K1MMc0iNprCpAzzXF5DY6IndkTxjPS/bZILuDrNlWfxFvDxv2IQWqxxNJU+lzUW2gktv7HZfeoxR24JRBv97sQgMC2k47xOoOefCSxGa9ZUgju2jWWVVjQtPXco4xiHJ5tC9fDJEQPYh4p4Du1xQg5nvNKOBsYPdcpsy5wQxWok88JaaxzGDWeIpCA3YhzALW8L9D1MJaKO/AufkLMhikSYloJJ7EIzA1YAwLi9SfPQc8l8X/5JzKPST0KuksZew9nBEBVfxQYasF2XnvCBLU9rOPI28vI80qaS4Z5pfkAnF20N6tOhnm+Z1ultu097kw4qwuyjvldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KY3OL/i5SYoY5Pd0Wapyj36i2HGyt24qGsNiH6iETi8=;
 b=C8j8WLF3PLqSW3IZlHEQfkqrA/RlL27z3V4TSNX64Qi5Ab6l7Xx/CPe8YwF6btKIql2E1KJn0r3um8jPiiDBmwaUeTkDXDeAzGogef8RsJEEY4izhxdtLqjITSWMKOzh1Z6uYeeBIZjQcw/oFLtObQH3OMITK1Pd5nVn9JwGa0d5w/ro7yyaQTpGraq9JivWuW5j9rt4uVvcwMfc2ffi3xKP80lNWKbHnhAPSf+5Dv2k3k+O3PDcFny0RvKGw9R/4OHvCroYIR0A/aPYvrob9fyNJ/HoQksY1PGw1rFB500PDLulsmcD9brqxyY0G//11tk81GM50MHa7kMPKC4MQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from DM6PR13MB3098.namprd13.prod.outlook.com (2603:10b6:5:196::11)
 by BY5PR13MB2934.namprd13.prod.outlook.com (2603:10b6:a03:187::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.10; Wed, 4 May
 2022 19:37:33 +0000
Received: from DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::fd47:d634:9131:92e6]) by DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::fd47:d634:9131:92e6%4]) with mapi id 15.20.5227.016; Wed, 4 May 2022
 19:37:33 +0000
From:   "U'ren, Aaron" <Aaron.U'ren@sony.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between 5.10
 and 5.15
Thread-Topic: Intermittent performance regression related to ipset between
 5.10 and 5.15
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9azBu8uAgCjylwCAABPlAIAkPh0AgABqshA=
Date:   Wed, 4 May 2022 19:37:33 +0000
Message-ID: <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
 <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info>
 <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
 <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
 <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
In-Reply-To: <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae9c6edc-a015-4c9a-0e4f-08da2e0588cf
x-ms-traffictypediagnostic: BY5PR13MB2934:EE_
x-microsoft-antispam-prvs: <BY5PR13MB2934A0FC19860AC59DDB8462C8C39@BY5PR13MB2934.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tXIQ81wV1kO24FXT0GVjDRlOC0Z9V97md6btTsaITT8VTCwyhoDzk8b1EW/LXgb82eYE+TNyVr06TTjEGco7WC35mp38MmZTCxx8sgv05cxcumSDHoOBQk+eILOKZFLcd6ouLBicmUygL6t8tF2beym7soNQzk6VGgjHeTGCb+XPYErW35d6GntJIqDRIbp2eAjia7KtLMHPY5Gcn44gz/LBdG+YcfwSPf9Wwgcs8Jq+X+goUz2qwrK2CMXxlFoXiton6Y7f76eqx0DyNphLa5xR9XFyTZwzK/bZV9sfW/kNbRedDnLyiuNPwytKaVCFhpzAy/Ca3XpON4uTPWDeWgkq23RSqtB24rDZiOItarRhJah6M+aQpW1LhSaBclscZgT1aWMypd0SNJVDae2yUZPyNgaekGdtEqsydpx4yWTdrPCVhtxVymhVtRensij+6B4CI/W+mCH7hRAzM7bBU3Jhxzp+3Z/p4zY8VF1rbRllTH+cMl00hHwgPWvOylYOxwZN13CwrOg3z/Ed7gwXe/Tkea0XRukC27yraSxpbSeK5B4M/LwCNSqKBy1bWNCgSY+iYTHvef+NO8p/ZhSPT7q9zZHYcnCstLrZ6adg+2YdZWGgkxiWONxkhEOB7oyp0DUiWTLRS2rlSddKIiDgWsJudKcToldh/Ooi9lxPem/YjnQKhX8AhkDHzQgyKxkikbD6lknOUgZhdBljHtqkyVaqQkstMR9c+FUKCnxaeOoWbN1rglN9/Jp8hkxeKsUYiba38GaEj1l7SD8aNa9asuKh7uguVcbbO0Hqq1fRn6bijjV44ebRmZtfDY+EufQtqlk2oLbZdORqHDRjDZKFUPZTVXtmZezwwot9YPoWv0Wa6HEFARQ6JG2f+JFIYO5L
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3098.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(53546011)(26005)(9686003)(7696005)(84970400001)(91956017)(4326008)(64756008)(86362001)(71200400001)(66946007)(66476007)(66556008)(76116006)(66446008)(6506007)(82960400001)(122000001)(54906003)(110136005)(5660300002)(8936002)(55016003)(38070700005)(38100700002)(966005)(6636002)(33656002)(508600001)(52536014)(83380400001)(186003)(2906002)(66574015)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?1kB2WLU8+dIOZb53wgb0tx/rnasX3g6cIIPhncsrpzWBptYXuttay68+?=
 =?Windows-1252?Q?8+x/qmIaXCP1s0CWkHHwtk6thn9XDqVThDkt1pxTB7q+YReQyFDdfffy?=
 =?Windows-1252?Q?vljCdnRah012yUgYb1DYNLxphoCpDt1mroKhCD3Phyzo8KZs24J7KcDX?=
 =?Windows-1252?Q?056RQZ8sLfXCbnopZlHIxHgvh+9BLNx2zEWOdaG5uKDavo3kyWgb+OaO?=
 =?Windows-1252?Q?vbi3GWNPjpH4L4IZ+QQmCQOsWOjw/797e2EaHIPAtodn7BfsG708QpID?=
 =?Windows-1252?Q?Enc8ZGlf61DNQ2iaWOG430wc8RORPbdhjsVUNp3SCl/huP1X32tPQLSR?=
 =?Windows-1252?Q?8XPWa0hRWyhPxB9n79t99T1ghEsAPd135D4EzjZGOBtZXae0DyKfgyaJ?=
 =?Windows-1252?Q?BvD8PTBOL3xX3wh6hPC6si5BhNufWIGtqKUAlfa2N++oeqTbDU60jp2H?=
 =?Windows-1252?Q?HQnTHSYxt0AxsjZbuyGJdl4yFmUd687Zl0HLTChUhSQkCiR7yMYR7RHN?=
 =?Windows-1252?Q?njDKMX+QS2G4mI7FBNm4OYgu/2m4rkkwCowzKLu1L1SvWd4kfXQmazJa?=
 =?Windows-1252?Q?ZCHypUVYVZMVe5fFn6oC+YwtEUhsZmvGqHiixwc8FHlOk6noDn9ePOAe?=
 =?Windows-1252?Q?n728uwHYDJaPOmjmelRM7YTcCnZBqh3kJq/834eXP8MGsl2IsRz8JSYs?=
 =?Windows-1252?Q?B89we0BRI3Kb0q1VrVb7/2ZjGNm8AU0mALczrkfRT5duS6E9fgWdTYSv?=
 =?Windows-1252?Q?+7Hy6Klci6dRykvX+z3X5OWLMmMoREvh4pXEpvrp3BvSazl/SqoblCoD?=
 =?Windows-1252?Q?VkHMcD7iMIHI0DIKhfECs1fSlgRjAxSYkAw7CW1ugbUZe9UfF9gE4dYE?=
 =?Windows-1252?Q?T9HGmvmo8dyDIChLqt47JPS+7EnLgT5tXffDaFJnLoHwufZELbd/Imk1?=
 =?Windows-1252?Q?y8GwQRh58/Z8exHwZK9U+1LJcXcXY4KF2YCex7SL8GH1EmuWFnyoNwin?=
 =?Windows-1252?Q?npURe35r2COjVcgGSClNVdcSVZwclHkmMNW16x4mRCvzUACsOq/XZn8y?=
 =?Windows-1252?Q?n8q/eLl3fPSvav8Tc5vDywSW7cGi8KxMd3VH/oNBPfCJz2tnnaatoE6O?=
 =?Windows-1252?Q?+2ZLJ8ja8cLWX6rMC1Jjji12C7W3Itw5t/0vHCzqyMx7m6aMFf5AbCzR?=
 =?Windows-1252?Q?GLPYKkFxJ5/16hCSTxLmTFT08OENSmE+xW1Z0kXKM/S9HsEMSo3OR4vR?=
 =?Windows-1252?Q?JjDC4pQoRRLlN6OP5Z+bwkQTFjb6vi155yQbOAJi8xSjTR0i6DSDgiKn?=
 =?Windows-1252?Q?quaq4Yq12o1YEumI3NHyvP+8OIoovBIUGUK54fSrEg3Ui2x07apnW1jp?=
 =?Windows-1252?Q?OtGBsRZU8CvKzJ3Y7VUNa35veQ9OL0ZZ+jq7/+pT9nBF/+mLcxvzAvNJ?=
 =?Windows-1252?Q?IhZtEPLFXQUOee6712yqXjx/gdufHJl0NQbcwBXogEjd6yd+F1bCHNEL?=
 =?Windows-1252?Q?l9927CJ2fZThEmeZD2aPiCxdSLd3rjJBXwazUDgTdwu2uoPbDymgzRf4?=
 =?Windows-1252?Q?vqaj5BTIck7pYBbpFSbZxH9qoUtxdriZyBuBs/jWnHkfVGKUCfvRc1WX?=
 =?Windows-1252?Q?Ab/nHrVu6NjXRvppAIYOB+bb5fJ52uEwjx/kZR9Xr1roGENi6wX6D0j2?=
 =?Windows-1252?Q?PnAeh8gHuLvJ26c2mCTG4LCLYdRnpn5cTK5h4fbN/XTmLuBSaOllQpUk?=
 =?Windows-1252?Q?KAEXACIiVclaXtBabjQ0UBrInEodp5DO8mCydWDSEwU+iFI4YqCQTNZ6?=
 =?Windows-1252?Q?HpZAisefpSnDHr/1T1g7RdPd9zUI8IIY1Bg1bJeN/rVLBQj26llIU4pW?=
 =?Windows-1252?Q?wmHytZ72VO/cHVUiN2ZRdYsrFaktDDVsfyI=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3098.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9c6edc-a015-4c9a-0e4f-08da2e0588cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 19:37:33.1175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4vE/f+LeXwSNF0xzprqYFeUMGMVz0S2osuPjTyWYkWqgjiMLjHmegSyYIoZC0iGEw4EzOwrkVSSoqQW8ZTIInA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB2934
X-Proofpoint-ORIG-GUID: cdJeb97TrlzR8rC74KOzmsj8FQXAdEQD
X-Proofpoint-GUID: cdJeb97TrlzR8rC74KOzmsj8FQXAdEQD
X-Sony-Outbound-GUID: cdJeb97TrlzR8rC74KOzmsj8FQXAdEQD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-04_05,2022-05-04_02,2022-02-23_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=APOSTROPHE_FROM,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the reply Jozsef.
=20
It=92s good to have the confirmation about why iptables list/save perform s=
o many getsockopt() calls.
=20
In terms of providing more information to locate the source of the slowdown=
, do you have any recommendations on what information would be helpful?
=20
The only thing that I was able to think of was doing a git bisect on it, bu=
t that=92s a pretty large range, and the problem isn=92t always 100% reprod=
ucible. It seems like something about the state of the system needs to trig=
ger the issue. So that approach seemed non-optimal.
=20
I=92m reasonably certain that if we took enough of our machines back to 5.1=
5.16 we could get some of them to evidence the problem again. If we reprodu=
ced the problem, what types of diagnostics or debug could we give you to he=
lp further track down this issue?
=20
Thanks for your time and help!
=20
-Aaron



From: Thorsten Leemhuis <regressions@leemhuis.info>
Date: Wednesday, May 4, 2022 at 8:15 AM
To: McLean, Patrick <Patrick.Mclean@sony.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.or=
g <netfilter-devel@vger.kernel.org>, U'ren, Aaron <Aaron.U'ren@sony.com>, B=
rown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.rueger@sony.=
com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>, regressi=
ons@lists.linux.dev <regressions@lists.linux.dev>, Florian Westphal <fw@str=
len.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef Kadlecsik =
<kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between 5=
.10 and 5.15
Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

Patrick, did you see the comment from Jozsef? Are you having trouble
providing additional data or what's the status here from your side? Or
is that something we can forget?

Ciao, Thorsten

#regzbot poke

On 11.04.22 13:47, Jozsef Kadlecsik wrote:
> Hi,
>=20
> On Mon, 11 Apr 2022, Thorsten Leemhuis wrote:
>=20
>> On 16.03.22 10:17, Thorsten Leemhuis wrote:
>>> [TLDR: I'm adding the regression report below to regzbot, the Linux
>>> kernel regression tracking bot; all text you find below is compiled fro=
m
>>> a few templates paragraphs you might have encountered already already
>>> from similar mails.]
>>>
>>> On 16.03.22 00:15, McLean, Patrick wrote:
>>
>>>> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.16)=
=20
>>>> series, we encountered an intermittent performance regression that=20
>>>> appears to be related to iptables / ipset. This regression was=20
>>>> noticed on Kubernetes hosts that run kube-router and experience a=20
>>>> high amount of churn to both iptables and ipsets. Specifically, when=20
>>>> we run the nftables (iptables-1.8.7 / nftables-1.0.0) iptables=20
>>>> wrapper xtables-nft-multi on the 5.15 series kernel, we end up=20
>>>> getting extremely laggy response times when iptables attempts to=20
>>>> lookup information on the ipsets that are used in the iptables=20
>>>> definition. This issue isn=92t reproducible on all hosts. However, our=
=20
>>>> experience has been that across a fleet of ~50 hosts we experienced=20
>>>> this issue on ~40% of the hosts. When the problem evidences, the time=
=20
>>>> that it takes to run unrestricted iptables list commands like=20
>>>> iptables -L or iptables-save gradually increases over the course of=20
>>>> about 1 - 2 hours. Growing from less than a second to run, to takin
>>=A0 g sometimes over 2 minutes to run. After that 2 hour mark it seems to=
=20
>>=A0 plateau and not grow any longer. Flushing tables or ipsets doesn=92t =
seem=20
>>=A0 to have any affect on the issue. However, rebooting the host does res=
et=20
>>=A0 the issue. Occasionally, a machine that was evidencing the problem ma=
y=20
>>=A0 no longer evidence it after being rebooted.
>>>>
>>>> We did try to debug this to find a root cause, but ultimately ran=20
>>>> short on time. We were not able to perform a set of bisects to=20
>>>> hopefully narrow down the issue as the problem isn=92t consistently=20
>>>> reproducible. We were able to get some straces where it appears that=20
>>>> most of the time is spent on getsockopt() operations. It appears that=
=20
>>>> during iptables operations, it attempts to do some work to resolve=20
>>>> the ipsets that are linked to the iptables definitions (perhaps=20
>>>> getting the names of the ipsets themselves?). Slowly that getsockopt=20
>>>> request takes more and more time on affected hosts. Here is an=20
>>>> example strace of the operation in question:
>=20
> Yes, iptables list/save have to get the names of the referenced sets and=
=20
> that is performed via getsockopt() calls.
>=20
> I went through all of the ipset related patches between 5.10.6 (copy&past=
e=20
> error but just the range is larger) and 5.15.16 and as far as I see none=
=20
> of them can be responsible for the regression. More data is required to=20
> locate the source of the slowdown.
>=20
> Best regards,
> Jozsef
>=20
>>>>
>>>> 0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=3DS_IFREG=
|0644, st_size=3D539, ...}, 0) =3D 0 <0.000017>
>>>> 0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOEXEC) =
=3D -1 ENOENT (No such file or directory) <0.000017>
>>>> 0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) =3D 4 =
<0.000013>
>>>> 0.000034 newfstatat(4, "", {st_mode=3DS_IFREG|0644, st_size=3D6108, ..=
.}, AT_EMPTY_PATH) =3D 0 <0.000009>
>>>> 0.000032 lseek(4, 0, SEEK_SET)=A0=A0=A0=A0 =3D 0 <0.000008>
>>>> 0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) =3D 40=
96 <0.000010>
>>>> 0.000036 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
=3D 0 <0.000008>
>>>> 0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) =3D 40=
96 <0.000028>
>>>> 0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 4 <0.000015>
>>>> 0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) =3D 0 <0.000008>
>>>> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", =
[8]) =3D 0 <0.000024>
>>>> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUB=
E-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.109384>
>>>> 0.109456 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
=3D 0 <0.000022>
>>>>
>>>> On a host that is not evidencing the performance regression we=20
>>>> normally see that operation take ~ 0.00001 as opposed to=20
>>>> 0.109384.Additionally, hosts that were evidencing the problem we also=
=20
>>>> saw high lock times with `klockstat` (unfortunately at the time we=20
>>>> did not know about or run echo "0" > /proc/sys/kernel/kptr_restrict=20
>>>> to get the callers of the below commands).
>>>>
>>>> klockstat -i 5 -n 10 (on a host experiencing the problem)
>>>> Caller=A0=A0 Avg Hold=A0 Count=A0=A0 Max hold Total hold
>>>> b'[unknown]'=A0 118490772=A0=A0=A0=A0 83=A0 179899470 9834734132
>>>> b'[unknown]'=A0 118416941=A0=A0=A0=A0 83=A0 179850047 9828606138
>>>> # or somewhere later while iptables -vnL was running:
>>>> Caller=A0=A0 Avg Hold=A0 Count=A0=A0 Max hold Total hold
>>>> b'[unknown]'=A0 496466236=A0=A0=A0=A0 46 17919955720 22837446860
>>>> b'[unknown]'=A0 496391064=A0=A0=A0=A0 46 17919893843 22833988950
>>>>
>>>> klockstat -i 5 -n 10 (on a host not experiencing the problem)
>>>> Caller=A0=A0 Avg Hold=A0 Count=A0=A0 Max hold Total hold
>>>> b'[unknown]'=A0=A0=A0=A0 120316=A0=A0 1510=A0=A0 85537797=A0 181677885
>>>> b'[unknown]'=A0=A0=A0 7119070=A0=A0=A0=A0 24=A0=A0 85527251=A0 1708576=
90
>>>
>>> Hi, this is your Linux kernel regression tracker.
>>>
>>> Thanks for the report.
>>>
>>> CCing the regression mailing list, as it should be in the loop for all
>>> regressions, as explained here:
>>> https://urldefense.com/v3/__https:/www.kernel.org/doc/html/latest/admin=
-guide/reporting-issues.html__;!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlSeY6=
NoNdYH6BxvEi_JHC4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpZdwVIY5$=20
>>>
>>> To be sure below issue doesn't fall through the cracks unnoticed, I'm
>>> adding it to regzbot, my Linux kernel regression tracking bot:
>>>
>>> #regzbot ^introduced v5.10..v5.15
>>> #regzbot title net: netfilter: Intermittent performance regression
>>> related to ipset
>>> #regzbot ignore-activity
>>>
>>> If it turns out this isn't a regression, free free to remove it from th=
e
>>> tracking by sending a reply to this thread containing a paragraph like
>>> "#regzbot invalid: reason why this is invalid" (without the quotes).
>>>
>>> Reminder for developers: when fixing the issue, please add a 'Link:'
>>> tags pointing to the report (the mail quoted above) using
>>> lore.kernel.org/r/, as explained in
>>> 'Documentation/process/submitting-patches.rst' and
>>> 'Documentation/process/5.Posting.rst'. Regzbot needs them to
>>> automatically connect reports with fixes, but they are useful in
>>> general, too.
>>>
>>> I'm sending this to everyone that got the initial report, to make
>>> everyone aware of the tracking. I also hope that messages like this
>>> motivate people to directly get at least the regression mailing list an=
d
>>> ideally even regzbot involved when dealing with regressions, as message=
s
>>> like this wouldn't be needed then. And don't worry, if I need to send
>>> other mails regarding this regression only relevant for regzbot I'll
>>> send them to the regressions lists only (with a tag in the subject so
>>> people can filter them away). With a bit of luck no such messages will
>>> be needed anyway.
>>>
>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat=
)
>>>
>>> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
>>> reports on my table. I can only look briefly into most of them and lack
>>> knowledge about most of the areas they concern. I thus unfortunately
>>> will sometimes get things wrong or miss something important. I hope
>>> that's not the case here; if you think it is, don't hesitate to tell me
>>> in a public reply, it's in everyone's interest to set the public record
>>> straight.
>>>
>>
>=20
> -
> E-mail=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_public=
_key.txt__;fg!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlSeY6NoNdYH6BxvEi_JHC4s=
ZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpRHTvk29$=20
> Address : Wigner Research Centre for Physics
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 H-1525 Budapest 114, POB. 49, Hungary
