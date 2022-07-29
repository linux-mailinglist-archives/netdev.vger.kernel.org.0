Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE567585609
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 22:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiG2UWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 16:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiG2UWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 16:22:01 -0400
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DD36A4AE;
        Fri, 29 Jul 2022 13:21:59 -0700 (PDT)
Received: from pps.filterd (m0209319.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TJxrgE010907;
        Fri, 29 Jul 2022 20:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=zQMDtZNUKAXEq52bt6otAU70SKWJl4HgKOXlNlqlXlM=;
 b=DuKMc0fzLGeu3U8kQHZBkAcnlOVjtyzDKTfHJQp9evV5bSnXVb/eTMPWS0Vzg3IoB2Ce
 +eg4/YwF/6uKJ8lFA3jY/LRO52HRc8rK1VCisLJjwqvqQ5g2UvUFm9wjF/B+IiQQiFtA
 MoRycsN2Dc7q+9qoEbr9V4zcJEjbYdlP3T51Zn29LIbBXhFh4lkf2I0Y6ie+KGvWQbDB
 z6NtTcOm1RHRMfUGufpE+F6Oae1TOO2hgaV6eMAZ96gF4+TZH9g0B3KRG8FS+7Vw/Xe3
 MG16qCXfKhkZiZwGo/7uH0pEXPzYAomSnqpRr7cWnMqMVWYz2O2pz6Mgb0X8lIBseVKr Uw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3hg9crf3uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 20:21:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9nCUyO9cUcgHjGSnCc0vztteBQoJybkD6tZiFc78L3IosKxm5W+11XEhgpi8QgUF51O1uX0SZknEx9OPgMxCMyCDeFrmRumI/twVTHcwMHGSOqVLL1vtHgFtb/6CiYHIM8db39Sq7x6PuGFuuFqzg4pAics+iucBxzDiHENxDxXmiOooDXDeEcVYZkmpcY+fc5uUPaqycHi5H7jJcEym+3TnGtsCh09VuAIdZomZ15jiYOZ1Zm6HtQdGRfkMUchVoqc10xrzyVGtkrIBaZLnsWG9wG0CRiOB9mh+mupzEU9Ny9ziEg+hvTogedOMuRR58whcJ2bu2YvYpJOQr8tpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQMDtZNUKAXEq52bt6otAU70SKWJl4HgKOXlNlqlXlM=;
 b=FbZ2tqN9yl3Hl2wscJ25PbVyZWANJsc/K74aLepWkbeNwcThUiicHNizGLiQ/AKXKFi6CzxbgVjaDsR7L6CpFnx8JHjdvVWN4DSLmRPAMJkhMw7ayX8MJNvTLuU/F9M72m5oqM+oztatY9yj/xAqYF0nMQcsDR0QHJlnGoETrqPdGU8w5Dt+zo1xs6aKbNTBwt+aQ4MyWzvd5SvBsJH2cebgRTJGTwVzxMPJjCpYZtMx9QGNYHX68PMI/uem9ghXCLMx4l3WYMu92d/yirZoa+jM0D75tWz3Whb+x/lrApOKm4Gr483ZcA5A3uxZ1G0N5O1dKgTG+qnqLG1oquqUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from DM6PR13MB3098.namprd13.prod.outlook.com (2603:10b6:5:196::11)
 by DM6PR13MB2412.namprd13.prod.outlook.com (2603:10b6:5:c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.5; Fri, 29 Jul
 2022 20:21:17 +0000
Received: from DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::6598:f7aa:2cf:f68d]) by DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::6598:f7aa:2cf:f68d%3]) with mapi id 15.20.5482.001; Fri, 29 Jul 2022
 20:21:17 +0000
From:   "U'ren, Aaron" <Aaron.U'ren@sony.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
CC:     "McLean, Patrick" <Patrick.Mclean@sony.com>,
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
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9azBu8uAgCjylwCAABPlAIAkPh0AgABqshCAKHvIgIABK1GAgB9noQCAEDSYyIAAN9SAgAMd64CACZB8jYAhB35y
Date:   Fri, 29 Jul 2022 20:21:17 +0000
Message-ID: <DM6PR13MB3098595DDA86DE7103ED3FA0C8999@DM6PR13MB3098.namprd13.prod.outlook.com>
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
In-Reply-To: <DM6PR13MB309813DF3769F48E5DE2EB6EC8829@DM6PR13MB3098.namprd13.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ab60506-8961-4b5e-012a-08da719fe492
x-ms-traffictypediagnostic: DM6PR13MB2412:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ShXlV4Ez3Y/CF4izmoFboNf+/norxTKwvSIEke09iijmpe3GEaxvLSwYZdZWw4u8mMenmBhvAp77kiI73VBsY0LArHQDsd5bmrvdoYiWYfvbJYGcVJ2OeuxroLO0wBEoBwLLL1nhfvTAJbTBN7VS07JjdLOCymcv4ozbeuPt5XSaIOzfmyW1SQPUbVY5VEPY+/OW9+haGCVJCYQe73QlV7pywMxNMSqqtzL2txyjat24yS6bqDT3U0BPS12snUiEBwZ6k9RzofQYjYiFRjHh4ydvxd8JNQzGVOjp5yx5xuIJ+LqfXf38le0esptxnThqeG+7R1ep9MjpfckBKU6eB/Y/cBQxtQrnOSu2FWU3+syE7hxMxNafkgJN5NKS/iDc8/Cu9TQ4zuuljx1st+SGqg0xVgKxAvSwrDBCQtf+b1KMC7C5/WpfeKL34T8ggPgANdtU4izAuyureenytY4AGiLYyyJ7CyrxanxwHc1OcGZtqRioDj7L/gKyTFxOMxKK0Kx/Fu28PHATwZB2IblI6g9lRwYNpfH45KjMo0dMW/SxfMW2S9OT7UmSCNxto1A93Y9xMPjt5SN6jd2aRVhPF3amwrxyRt29CaATmWeGf3MByyzM+rHSMSegFwnl6ZiYRpb4N9quCoMByTAbfuNLfkueaIlYNJdcBTPDRGpYMxLe5kMlqKvR07dqkJJeGj4YSyHbqFX2V1t1ayljHhUUUS9fp305rG+6IKJjJFH+/86dMCiXRiwn7xbuXPDHhwwJnHYKf5OBmIL0LS2z7AGmDSifVnaUxGfYjOcWE6uwMHhidFvAlOBSSxSMJG8nxbdy/g8H5T2gmWfQ7sToJHAG/gk23Aqoz2JMrY9Q46KAZkxTVceOjZ8+OMTQJJc5ULTL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3098.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(83380400001)(33656002)(7696005)(8936002)(38100700002)(2906002)(6506007)(26005)(9686003)(53546011)(52536014)(5660300002)(30864003)(66946007)(64756008)(122000001)(478600001)(110136005)(82960400001)(86362001)(41300700001)(38070700005)(8676002)(316002)(55016003)(4326008)(71200400001)(66574015)(186003)(66446008)(66476007)(91956017)(76116006)(66556008)(966005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UhrCvoYZ4X9eSXfCbunnl6wvsWIvk7jSpZa47OjjTW8Pd3cuHQtjFCoZ2O?=
 =?iso-8859-1?Q?FuwCqA01whwtNIw5o5tV/sa8x4Z8F1rdBuLlM9dweWx7/JSoK+mtZBuZW6?=
 =?iso-8859-1?Q?BTkNimxVTTdi4xIxtCz1Bsb+/vraf1+Ie6EE6cN3j86rTojDFaJuFr85od?=
 =?iso-8859-1?Q?5cufM8qGooeEtdEBnlNVnmbdn+PcgdXKVSw6RQM5bjaFaJCT2MljwMflyc?=
 =?iso-8859-1?Q?ZKlHBbTR6GFOo0APzzAZxF+K9v0u2HPldpyYBecdJAXa1Q9ivVV72jp2oj?=
 =?iso-8859-1?Q?zqKSumN1Sn0+rlsSWy9zDkxH4uCfOe2Zy42JnoFzqNBzAYPlJdKD9KZaz8?=
 =?iso-8859-1?Q?7qzs8H2WPadEXXHc60G7x9gfO+30P13l8Y7PlPGklSgI7fNjIG7DQKmBWc?=
 =?iso-8859-1?Q?rNUpxRrYMEYnrMnUKMRRJU+4HH0m8Ek6OYZ0siEY8vhnbtEngW/3xcQ7GV?=
 =?iso-8859-1?Q?6Ls3QkMrpVSpv+8HZHt3WqJq5YQqs+7wmMBp/Phannk/n8HKUrYAlZBDid?=
 =?iso-8859-1?Q?8LdsNv49QvfsL5x0msv3J4h23a9mGp/ZOqgLTeHccIDVleP//PYBNdXHJO?=
 =?iso-8859-1?Q?YEv0uVFA8uowZGx14TMfXLTv4iCxeWfNM41u6vroIr6/LleQqPYjKrdwIa?=
 =?iso-8859-1?Q?N35GoSBmjlDb0eO5M56TLntFb8tUb8E9vRu24XQnUNOH8TQPU1o9GHZ469?=
 =?iso-8859-1?Q?egbRO/cYYz/7+sfEhrByIcy00ZNTtiPNvU6HmT1pVP7mzFuoBgvre2BJx6?=
 =?iso-8859-1?Q?xVEmgK/ejAFIokMClnXTh6sDW5oNivIvWctEsB+c87Bk7chryLIEe5z+UM?=
 =?iso-8859-1?Q?u3xDIq5j3v/3xTUUAEdQ4ExMYztvGaqw1I7vBZN61ij1XrcOSwYQKmuTJ3?=
 =?iso-8859-1?Q?waMHQ6sLq1ygE0IabpTAGnZ7zSZdSAE0yckkkakcmc29GEvKRoQUdE1duM?=
 =?iso-8859-1?Q?VTXcNalVh0GjQwLlmwiFax3yziGYuu3YLHgHQ5B2UpMHVuodH4NJWvlI4S?=
 =?iso-8859-1?Q?zPYAOyAnVK4mRi/5AhC/+hD/RUhJZJiXWojcvod91VhUf0LAYPdcu2Zq6I?=
 =?iso-8859-1?Q?Uq2CPLPL98KVLPdKm4E6hjz0h2xHja8BQGlmgjZrz2jtV+oyyl+94sFXI+?=
 =?iso-8859-1?Q?tweM9DbDr9U+ReQuM7Jk4IgYQpFDVGNileA3aaBfv73Y0LqgOVEVH35bav?=
 =?iso-8859-1?Q?wC1X0LTJ7aBWGMJ+8fBvLHGPhXTtniBa2N0Yx9QnhpRzmJcvi9E9H3EOYE?=
 =?iso-8859-1?Q?8gb28BAxcJDOqqsKbzBoFfDICY0lm3l8QjBvAb5D5kNSYvo6/vGJ2OddBx?=
 =?iso-8859-1?Q?wV6PGAXeDlJV/hHUtehLiNZKLY16UObFjN8Myl3/ZDN6r7FBLuSkKvQmFf?=
 =?iso-8859-1?Q?ja9ICLq1LZEb7alSF0ZqxVLmhCFsnKsVlAaali6nYOjwiEZeulhWnkt4g0?=
 =?iso-8859-1?Q?qBSTWn4/SBuXcEi264yyOzZX2mPXR+GUHio3y4a6zCMQ1anCFKmeNcemqC?=
 =?iso-8859-1?Q?9bUfrBNVAgcS4DERgc5xS5AHS1bfAZbhpko025Az19fmSA/Nmxg5BQCg2W?=
 =?iso-8859-1?Q?Ac0MX68I6ZrPAOyzN8qziqaQbdwR4dlHlkJCZRvqBquH71JpLhahUT0KQE?=
 =?iso-8859-1?Q?zirIMG+bcfjJjrM1/IKTNSvUxDGgEbZIE5D6ksy8aE+fA7PibysVmFzA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3098.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab60506-8961-4b5e-012a-08da719fe492
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 20:21:17.4390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BL5aaytWyVDh8I9aEPi1logcKwSrNqhDcmym4n940vMZu+/+fZfTNbCsqAGVmWtPwllHvjQmyFa5K4a8E3mKxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2412
X-Proofpoint-ORIG-GUID: 2bHrN0U9_VynTtH6ERRH4QMQKYIYSF-M
X-Proofpoint-GUID: 2bHrN0U9_VynTtH6ERRH4QMQKYIYSF-M
X-Sony-Outbound-GUID: 2bHrN0U9_VynTtH6ERRH4QMQKYIYSF-M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=APOSTROPHE_FROM,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jozef / Jakub / Thorsten-

Thanks for all of your help with this issue. I think that we can close this=
 out now.

After continuing to dig into this problem some more, I eventually figured o=
ut that the problem was caused because of how our userspace tooling was int=
eracting with ipset save / restore and the new (ish) initval option that is=
 included in saves / restores.

Specifically, kube-router runs an ipset save then processes the saved ipset=
 data, messages it a bit based upon the state from the Kubernetes cluster, =
and then runs that data back through ipset restore. During this time, we cr=
eate unique temporary sets based upon unique sets of options and then rotat=
e in the new endpoints into the temporary set and then use swap instruction=
s in order to minimize impact to the data path.

However, because we were only messaging options that were recognized and im=
portant to us, initval was left alone and blindly copied into our option st=
rings for new and temporary sets. This caused initval to be used incorrectl=
y (i.e. the same initval ID was used for multiple sets). I'm not 100% sure =
about all of the consequences of this, but it seems to have objectively cau=
sed some performance issues.

Additionally, since initval is intentionally unique between sets, this caus=
ed us to create many more temporary sets for swapping than was actually nec=
essary. This caused obvious performance issues as restores now contained mo=
re instructions than they needed to.

Reverting the commit removed the issue we saw because it removed the portio=
n of the kernel that generated the initvals which caused ipset save to reve=
rt to its previous (5.10 and below) functionality. Additionally, applying y=
our patches also had the same impact because while I believed I was updatin=
g our userspace ipset tools in tandem, I found that the headers were actual=
ly being copied in from an alternate location and were still using the vani=
lla headers. This meant that while the kernel was generating initval values=
, the userspace actually recognized it as IPSET_ATTR_GC values which were t=
hen unused.

This was a very long process to come to such a simple recognition about the=
 ipset save / restore format having been changed. I apologize for the noise=
.

-Aaron

From: U'ren, Aaron <Aaron.U'ren@sony.com>
Date: Friday, July 8, 2022 at 3:08 PM
To: Jozsef Kadlecsik <kadlec@netfilter.org>, Jakub Kicinski <kuba@kernel.or=
g>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, McLean, Patrick <Patrick=
.Mclean@sony.com>, Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel=
@vger.kernel.org <netfilter-devel@vger.kernel.org>, Brown, Russell <Russell=
.Brown@sony.com>, Rueger, Manuel <manuel.rueger@sony.com>, linux-kernel@vge=
r.kernel.org <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev <r=
egressions@lists.linux.dev>, Florian Westphal <fw@strlen.de>, netdev@vger.k=
ernel.org <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between 5=
.10 and 5.15
Jozsef / Jakub-

Given your latest email and the fact that just adding back in IPSET_ATTR_GC=
 doesn't shed any light on the issue I wanted to spend a lot more time test=
ing. Also, I wanted to try to provide as much context for this issue as pos=
sible.

I think that the iptables slowness is just a symptom not the cause of the i=
ssue. After spending a lot more time with it, I can see that iptables only =
runs slowly when an existing "ipset restore" process is being run by kube-r=
outer simultaneously. Given the other information that you've provided, my =
hunch is that iptables slows down when ipset restore is running because the=
y are both vying for the same mutex? Anyway, I think troubleshooting it fro=
m the direction of iptables slowness is likely the wrong path to go down.

The true problem seems to be that when IPSET_ATTR_GC is not included, someh=
ow nodes are able to get into a state where "ipset restore" goes from compl=
eting in less than a 10th of a second, to taking 30 seconds to a minute to =
complete. The hard part, is that I still don't know what causes a node to e=
nter this state.

I have a Kubernetes cluster of about 7 nodes that I can reliably get into t=
his state, but I have yet to be able to reproduce it consistently anywhere =
else. Other clusters will randomly exhibit the issue if IPSET_ATTR_GC is le=
ft out of the kernel, but not consistently. Since the email where we found =
the commit about 2 weeks ago, we have also been running 6 clusters of 9+ no=
des with IPSET_ATTR_GC enabled and have not had any issues.

Since we have a custom kernel configuration, I have also tried using the va=
nilla Ubuntu kernel configuration (taken from 5.15.0-40-generic) as well ju=
st to ensure that we didn't have some errant configuration option enabled. =
However, this also reliably reproduced the issue when IPSET_ATTR_GC was rem=
oved and just as reliably removed the issue when IPSET_ATTR_GC was added ba=
ck in.

I have also verified that neither ipset, iptables, or any of its dependent =
libraries have references to IPSET_ATTR_GC, going as far as to remove it fr=
om the ipset header file (https://git.netfilter.org/iptables/tree/include/l=
inux/netfilter/ipset/ip_set.h#n86) and rebuild it (and all of the libraries=
 and other tools) from scratch just as a hail mary. No changes to user-spac=
e seem to have an effect on this issue.

One other thing that I've done to help track down the issue is to add debug=
 options to kube-router so that it outputs the file that it feeds into "ips=
et restore -exist". With this file, on nodes affected by this issue, I can =
reliably reproduce the issue by calling "ipset restore -exist <file" and se=
e that it takes 30+ seconds to execute.

In a hope that maybe it sheds some light and gives you some more context, I=
'm going to be sending you and Jakub a copy of the strace and the ipset fil=
e that was used separately from this email.

At this point, I'm not sure how to proceed other than with the files that I=
'll be sending you. I'm highly confident that somehow the removal of IPSET_=
ATTR_GC is causing the issues that we see. At this point I've added and rem=
oved the options almost 20 times and done reboots across our cluster. Anyti=
me that variable is missing, we see several nodes exhibit the performance i=
ssues immediately. Any time the variable is present, we see no nodes exhibi=
t the performance issues.

Looking forward to hearing back from you and getting to the bottom of this =
very bizarre issue.

-Aaron

From: Jozsef Kadlecsik <kadlec@netfilter.org>
Date: Saturday, July 2, 2022 at 12:41 PM
To: Jakub Kicinski <kuba@kernel.org>
Cc: U'ren, Aaron <Aaron.U'ren@sony.com>, Thorsten Leemhuis <regressions@lee=
mhuis.info>, McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <=
pablo@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger=
.kernel.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manu=
el.rueger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel=
.org>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian W=
estphal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between 5=
.10 and 5.15
Hi,

On Thu, 30 Jun 2022, Jakub Kicinski wrote:

> Sounds like you're pretty close to figuring this out! Can you check=20
> if the user space is intentionally setting IPSET_ATTR_INITVAL?
> Either that or IPSET_ATTR_GC was not as "unused" as initially thought.

IPSET_ATTR_GC was really unused. It was an old remnant from the time when=20
ipset userspace-kernel communication was through set/getsockopt. However,=20
when it was migrated to netlink, just the symbol was kept but it was not=20
used either with the userspace tool or the kernel.

Aaron, could you send me how to reproduce the issue? I have no idea how=20
that patch could be the reason. Setting/getting/using IPSET_ATTR_INITVAL=20
is totally independent from listing iptables rules. But if you have got a=20
reproducer then I can dig into it.

Best regards,
Jozsef

> Testing something like this could be a useful data point:
>=20
> diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/l=
inux/netfilter/ipset/ip_set.h
> index 6397d75899bc..7caf9b53d2a7 100644
> --- a/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/include/uapi/linux/netfilter/ipset/ip_set.h
> @@ -92,7 +92,7 @@ enum {
>=A0=A0=A0=A0=A0=A0=A0 /* Reserve empty slots */
>=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_CADT_MAX =3D 16,
>=A0=A0=A0=A0=A0=A0=A0 /* Create-only specific attributes */
> -=A0=A0=A0=A0 IPSET_ATTR_INITVAL,=A0=A0=A0=A0 /* was unused IPSET_ATTR_GC=
 */
> +=A0=A0=A0=A0 IPSET_ATTR_GC,
>=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_HASHSIZE,
>=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_MAXELEM,
>=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_NETMASK,
> @@ -104,6 +104,8 @@ enum {
>=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_REFERENCES,
>=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_MEMSIZE,
>=A0=20
> +=A0=A0=A0=A0 IPSET_ATTR_INITVAL,
> +
>=A0=A0=A0=A0=A0=A0=A0 __IPSET_ATTR_CREATE_MAX,
>=A0 };
>=A0 #define IPSET_ATTR_CREATE_MAX=A0=A0=A0=A0=A0=A0=A0 (__IPSET_ATTR_CREAT=
E_MAX - 1)
>=20
>=20
> On Thu, 30 Jun 2022 14:59:14 +0000 U'ren, Aaron wrote:
> > Thorsten / Jozsef -
> >=20
> > Thanks for continuing to follow up! I'm sorry that this has moved so sl=
ow, it has taken us a bit to find the time to fully track this issue down, =
however, I think that we have figured out enough to make some more forward =
progress on this issue.
> >=20
> > Jozsef, thanks for your insight into what is happening between those sy=
stem calls. In regards to your question about wait/wound mutex debugging po=
ssibly being enabled, I can tell you that we definitely don't have that ena=
bled on any of our regular machines. While we were debugging we did turn on=
 quite a few debug options to help us try and track this issue down and it =
is very possible that the strace that was taken that started off this email=
 was taken on a machine that did have that debug option enabled. Either way=
 though, the root issue occurs on hosts that definitely do not have wait/wo=
und mutex debugging enabled.
> >=20
> > The good news is that we finally got one of our development environment=
s into a state where we could reliably reproduce the performance issue acro=
ss reboots. This was a win because it meant that we were able to do a full =
bisect of the kernel and were able to tell relatively quickly whether or no=
t the issue was present in the test kernels.
> >=20
> > After bisecting for 3 days, I have been able to narrow it down to a sin=
gle commit: https://urldefense.com/v3/__https:/git.kernel.org/pub/scm/linux=
/kernel/git/torvalds/linux.git/commit/?id=3D3976ca101990ca11ddf51f38bec7b86=
c19d0ca6f__;!!JmoZiZGBv3RvKRSx!9YR_bFOCOkQzPaUftFL2NvuKLm8zPa4tQr_DI8CUZEen=
jK4Rak_OFmUrCpmiNOaUaiueGbgsEqk0IirIc4I$=A0 (netfilter: ipset: Expose the i=
nitval hash parameter to userspace)
> >=20
> > I'm at a bit of a loss as to why this would cause such severe performan=
ce regressions, but I've proved it out multiple times now. I've even checke=
d out a fresh version of the 5.15 kernel that we've been deploying with jus=
t this single commit reverted and found that the performance problems are c=
ompletely resolved.
> >=20
> > I'm hoping that maybe Jozsef will have some more insight into why this =
seemingly innocuous commit causes such larger performance issues for us? If=
 you have any additional patches or other things that you would like us to =
test I will try to leave our environment in its current state for the next =
couple of days so that we can do so.
> >=20
> > -Aaron
> >=20
> > From: Thorsten Leemhuis <regressions@leemhuis.info>
> > Date: Monday, June 20, 2022 at 2:16 AM
> > To: U'ren, Aaron <Aaron.U'ren@sony.com>
> > Cc: McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pablo=
@netfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.kern=
el.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.ru=
eger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>=
, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian Westph=
al <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef =
Kadlecsik <kadlec@netfilter.org>
> > Subject: Re: Intermittent performance regression related to ipset betwe=
en 5.10 and 5.15
> > On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> > > On Mon, 30 May 2022, Thorsten Leemhuis wrote:=A0=20
> > >> On 04.05.22 21:37, U'ren, Aaron wrote:=A0=20
> >=A0 [...]=A0=20
> > >=20
> > > Every set lookups behind "iptables" needs two getsockopt() calls: you=
 can=20
> > > see them in the strace logs. The first one check the internal protoco=
l=20
> > > number of ipset and the second one verifies/gets the processed set (i=
t's=20
> > > an extension to iptables and therefore there's no internal state to s=
ave=20
> > > the protocol version number).=A0=20
> >=20
> > Hi Aaron! Did any of the suggestions from Jozsef help to track down the
> > root case? I have this issue on the list of tracked regressions and
> > wonder what the status is. Or can I mark this as resolved?
> >=20
> > Side note: this is not a "something breaks" regressions and it seems to
> > progress slowly, so I'm putting it on the backburner:
> >=20
> > #regzbot backburner: performance regression where the culprit is hard t=
o
> > track down
> >=20
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat=
)
> >=20
> > P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > reports and sometimes miss something important when writing mails like
> > this. If that's the case here, don't hesitate to tell me in a public
> > reply, it's in everyone's interest to set the public record straight.
> >=20
> >=A0 [...]=A0=20
> > >=20
> > > In your strace log
> > >=20
> > > 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0",=
 [8]) =3D 0 <0.000024>
> > > 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KU=
BE-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
> > > 0.109456 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
=3D 0 <0.000022>
> > >=20
> > > the only things which happen in the second sockopt function are to lo=
ck=20
> > > the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare the=
=20
> > > setname, save the result in the case of a match and unlock the mutex.=
=20
> > > Nothing complicated, no deep, multi-level function calls. Just a few =
line=20
> > > of codes which haven't changed.
> > >=20
> > > The only thing which can slow down the processing is the mutex handli=
ng.=20
> > > Don't you have accidentally wait/wound mutex debugging enabled in the=
=20
> > > kernel? If not, then bisecting the mutex related patches might help.
> > >=20
> > > You wrote that flushing tables or ipsets didn't seem to help. That=20
> > > literally meant flushing i.e. the sets were emptied but not destroyed=
? Did=20
> > > you try both destroying or flushing?
> > >=A0=A0=20
> > >> Jozsef, I still have this issue on my list of tracked regressions an=
d it
> > >> looks like nothing happens since above mail (or did I miss it?). Cou=
ld
> > >> you maybe provide some guidance to Aaron to get us all closer to the
> > >> root of the problem?=A0=20
> > >=20
> > > I really hope it's an accidentally enabled debugging option in the ke=
rnel.=20
> > > Otherwise bisecting could help to uncover the issue.
> > >=20
> > > Best regards,
> > > Jozsef
> > >=A0=A0=20
> > >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > >> reports and sometimes miss something important when writing mails li=
ke
> > >> this. If that's the case here, don't hesitate to tell me in a public
> > >> reply, it's in everyone's interest to set the public record straight=
.
>=20

-
E-mail=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_public_k=
ey.txt__;fg!!JmoZiZGBv3RvKRSx!9YR_bFOCOkQzPaUftFL2NvuKLm8zPa4tQr_DI8CUZEenj=
K4Rak_OFmUrCpmiNOaUaiueGbgsEqk0Udypzvg$=20
Address : Wigner Research Centre for Physics
=A0=A0=A0=A0=A0=A0=A0=A0=A0 H-1525 Budapest 114, POB. 49, Hungary
