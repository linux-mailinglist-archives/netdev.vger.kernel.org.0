Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D5356C34D
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbiGHUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 16:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiGHUJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 16:09:36 -0400
Received: from mx07-001d1705.pphosted.com (mx07-001d1705.pphosted.com [185.132.183.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E13A1AF1E;
        Fri,  8 Jul 2022 13:09:33 -0700 (PDT)
Received: from pps.filterd (m0209329.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268JS5Tt031585;
        Fri, 8 Jul 2022 20:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=X8oxTXUI7J9ZGPeCupXexiqRNNMEfXAIqSWESr1P1BE=;
 b=ACNxXRgq1wpYmfSgK3hW5CgSVdiXBjODRbqUxT8xTFH7JymkMuzzCqR7vvM+YDicMIZs
 u6PymZe9AedmiuzMDCcTAsP7CQ2zBwGtQHbNC2PHvJI5JLFPjtNUARl6Cly2gM5+9TNB
 P1YU4MKGtw614XGog4RuEgXcehNIQpcBpKxOQwYWBoYh28mpT/VA7KB57foSa2gNbQX1
 pFNLql6/gYJQfHg31kCMDo1FBjzF0gFox09HZuybH1qefPzzxaiYobsXzgLPUbL5ZNuH
 KpUU/y4zGKhv+5pcL2pF45eftjO2RM662EutoScpoHWudHB15U8YQibkggemw8il6F0r Lg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3h4urcknmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 20:09:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V52uPlx7yw5Vbc433tmMKGQuQOqKrvm9vaIsU/EXTpvykEzl0pS7nHh1ouxfRq7YQgAWr8j2r2LRsPdLDYdB6luXzkbsJbTheuqbM6HZBoR+0sHVWNsK7pVJVWdC9Jl/WcheXm0lesLWSMopBF75hz1Xd6xMVfl4Ynh/iQgCtY/AI9vpsiHAU98EM0R0h/rGtMvkMZV61shYZJakQqZ6qqjtfg2lkdRyY9SjCR97fqXDNA5qEJnYiqN45NZmBVGdk8L4TDwnSBPvN8YxRjkg6BKu5GyUg2xi2N1JNnQdJvil7ssD0220/wKxqlLED3n6l93x4DBnrS5p1jfntJuTMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8oxTXUI7J9ZGPeCupXexiqRNNMEfXAIqSWESr1P1BE=;
 b=k3bBn5CPDLNLAXh4de0kM0JhaEY8LdtZZTNuc/k4AygOo3ULHAIlgDT4irvQ+NhGABF/nkITAQPcl2pG+MhdZ4QitGwxay5KoA8EU+SjmOw6F2m9v23V2xlKNe/V+ELwy1zCS1KwmaGqe79nNg2mcbN5ZR+WcfyGXLMOKMn2FQ4ikbKXDQ01qWazGt8KKaGfz28aEo1YDZMr5DOYqOFNW757f3PoMKEBQ+pCzPt1rxSmJQjAqKYPeQGQ4eVIpSdbPFt67RkyxJIpTWkkaX3qWJR4sceV6ewJV3bkj5oR5UEQBMJH0XEBz9aeiRFfFZ80ICRFdQE9xsYV5lLy6ZZBpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from DM6PR13MB3098.namprd13.prod.outlook.com (2603:10b6:5:196::11)
 by MN2PR13MB4384.namprd13.prod.outlook.com (2603:10b6:208:1b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.12; Fri, 8 Jul
 2022 20:08:57 +0000
Received: from DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::f879:1f68:a013:c06]) by DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::f879:1f68:a013:c06%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 20:08:57 +0000
From:   "U'ren, Aaron" <Aaron.U'ren@sony.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
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
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9azBu8uAgCjylwCAABPlAIAkPh0AgABqshCAKHvIgIABK1GAgB9noQCAEDSYyIAAN9SAgAMd64CACZB8jQ==
Date:   Fri, 8 Jul 2022 20:08:57 +0000
Message-ID: <DM6PR13MB309813DF3769F48E5DE2EB6EC8829@DM6PR13MB3098.namprd13.prod.outlook.com>
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
In-Reply-To: <d44d3522-ac1f-a1e-ddf6-312c7b25d685@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44c82de8-d48f-481a-433f-08da611db0cc
x-ms-traffictypediagnostic: MN2PR13MB4384:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fRjMJcktpjzX761BHqnYKemTGihpdAWz1eC26lnNaRb+juc9aGfjApW1EylXWlye7poRojU7wsPO+fJCVaVCBL9m/SOssgOFi2bdKwcZA8BhEHoOzACajHjxx0c6JRK3FHkuyfliRclAWOLWDNk74mKoJpS+6HsLKJTv6ISj3eNCp0Zv1F7E1iNPA47Mueeyj2MCJ8jOEyfH8+H7reYU6xS1vuofF2ijLo6s1VvU3bZL+1outRJYPioRBGQvunthQm0WGsbDPXUDl4qMEQH7orPvYdGrESIKcMZsuhlcbatmyR5BGr2OYCFiJS9I+Vfs+nrH2jr+Km9vaBcpFT9MXNth407pj2c+EGHmSDw7PPoOwqwwbdefcj9IUYNllI3aOb5tUKJbORw32ZAEF9f1dLIlI+gx6EbJklTiDk/NTlZxoiL9uJWpqj/CqoPROENCrP8mjshdDFr39NIIhseG3no8mOix1oxtqJLeCkId9M2jV3dtYKagoMdSM1w01pmbR2W4c8YeD4PjzNaMFjqmABaD0FP1Dekh/EUb/PBLLh6Dz9dPK9YOWM3awka5K4wq+CqryG/ojS9xvYVEzBhwte8u62JM9RvqN+S0f93grNogs83XbUPuT/aqup2XHuKB1BUDb9vcdNcRNymBwo2F9I+H+u6+/R7rQUuwTXQ/uc6n0rXRJdcw4947NRjg6QMQsnAsC0s/83vxWjEt+sNYUls0RiCsa7MHg+sa2mruNrt6M5QY+a5evCkn4HUl8TH0jq8pHZKJJq3YAHMwf5WOxDSidIcqcfVhOi/I7W2trfNS7ZxnZpCbpMP4Fz1LV2dJR9EicpfTYeWRRhePK5o7RQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3098.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(83380400001)(91956017)(8676002)(66476007)(52536014)(66556008)(4326008)(316002)(76116006)(122000001)(66574015)(64756008)(66446008)(54906003)(110136005)(55016003)(38070700005)(82960400001)(71200400001)(38100700002)(66946007)(9686003)(5660300002)(26005)(966005)(8936002)(30864003)(478600001)(2906002)(6506007)(86362001)(186003)(33656002)(7696005)(41300700001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/ls2esq+N7TNM/dg5hhN2tnCzZPX9eDb4RnOZ/gi7kfqLT5yDFr8W9CRdk?=
 =?iso-8859-1?Q?X5zACwMSF4H9HMdVwlHv5KIE3+rVo8FK51UTlnjlw5khKDFpc5AfarWriX?=
 =?iso-8859-1?Q?Hcson2xafM7ddg+clgIPajJj8ysb0+XEDSQQYpX9j7s3f6ji3407yosCew?=
 =?iso-8859-1?Q?LiuKTSMX3T8FiKExdTKLO5xqBz3rMj4M//5lH4skUU2TNWyjvwjzBxvX05?=
 =?iso-8859-1?Q?hDxlaSMAD/IHxos2dApIble8pB6F08d1PpH+lTSDnOjpsNQg4lzwf0WMxN?=
 =?iso-8859-1?Q?VXmN1owlJOj7D6TOVM/eiIvbjpK0e4wR2DDb1mvteBerG3/2AW0YoXgALC?=
 =?iso-8859-1?Q?GAFqw79ldTXdFhqi0Edhk5ceZCcpAuAhwoVyqhptLyzfIODMulyl1g7Uoc?=
 =?iso-8859-1?Q?PZ9F2ypMcr6Z8bcCB1M+MG5HHo78kVMmOZy0tfTGkKrG3N6qwxFmHW2iCy?=
 =?iso-8859-1?Q?maOnvfuG06ZJbrgVQ37knn/MCXLrQX7h6x4VXOw6F9Snnawnah3Le4DYm8?=
 =?iso-8859-1?Q?9YathzxvrwTlaR6U6IKuQlx/39OTwjqIfo4iMklsUYnPLFKFDc8+xmRIUF?=
 =?iso-8859-1?Q?uq/VriIPPrzWsyhjYPybXVN4Qi2v7fcya6ZFtrD2RHUWDzwX0U3DRegwgi?=
 =?iso-8859-1?Q?h0M2ZaoY6mKItHH2HVUezfI63WgDWeS5wi9/622rAs1YBVvnjlubz9vIya?=
 =?iso-8859-1?Q?j/RlcHVQ1tDTiZ38gRCGiNC/ePfODa6cbmz3Awam7PvgMPZjTqFBKX8XHb?=
 =?iso-8859-1?Q?IoHVixvCv77I9ye2l9XAO148RAaW08MIekjgAglI5o9ELjz1dhv5FpDuYk?=
 =?iso-8859-1?Q?j7yVthyVVFdd5xvI3bUcE3Z9AdB7LvozNPJRvPTp5RKezcecdfWDgLcXOy?=
 =?iso-8859-1?Q?opCCRHKCGd8svZM6It2ovbFu/3f7iWPsiW6nvKbIuOXrce7wXabXFUtz/M?=
 =?iso-8859-1?Q?wSMXD9tiZCovCypROmCysNn9P8hc9FBTOWVwCzbdwcecXUH3kYKCPlt/9Z?=
 =?iso-8859-1?Q?Jy4w+s7fxMTC3eA28CUdDMeRkGX+AUbZEXujJ4hcd6EYklwxeQp4sxn8dt?=
 =?iso-8859-1?Q?Xv688r6kTzZOePAZYtsbYIzOBNNLAlTsWc6afKkMfDazW7YiIFMmsNxMBl?=
 =?iso-8859-1?Q?1BlIRIpmTNSQq1Arg6ub9rhNaxgZ+gQYSNczuY9dwc53ny6kATGLCTnccT?=
 =?iso-8859-1?Q?n9pi2IXGfaYz0VHTSsZiHDxaGduEoijyQhPVrF+As7un77huvUUedkz8LI?=
 =?iso-8859-1?Q?Fu1LXZHCFpMvvwz5zDxPLNvSfD/OtxH/Io9bxik3318c8LCH+twYU6BXkJ?=
 =?iso-8859-1?Q?/UFBQWhQbo0fEjQ52SIzKdcJ/hFSfDfH+kWcvJKsDK8PQSvUdqpJW35Yx/?=
 =?iso-8859-1?Q?Hh4X0raWFMPVs2gqB47Xw/HUrUUdaM8UkcM4D9bpH9CcOj69MGjC23wDuP?=
 =?iso-8859-1?Q?DBsjvhPpLA0G0i1Fde7ktMtoa45bYFDe8C1NjlPXrLGQN6s1G1M3xDlIZP?=
 =?iso-8859-1?Q?OSrXeWH6CSMtvvDD6iGXB7CRLMocqsH9X2Sl5B5119nOyoqjaEduuFdXcU?=
 =?iso-8859-1?Q?P4crG+Ks6WiAY8RireF3+Q6Zpm4E3XMOytFGljwWMuW2RFpXw9Q/a0MAQO?=
 =?iso-8859-1?Q?VQl4papUTYqtDA7jImZE3Rt+h4Q3urd7sRio+uOBowqbnArldSUJ7R7Q?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3098.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c82de8-d48f-481a-433f-08da611db0cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 20:08:57.4312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1P0Xe4EhcHdhc8kQOL9yGILxH9kGXLzQFzg3B1VK1hZVK8EUS+La6AliyeDuUpbWaeaL2InGrbDv1RJZ7VYsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4384
X-Proofpoint-GUID: vLuA2m2qPLoPkCJJVlaDLrSCl-ftWZ8k
X-Proofpoint-ORIG-GUID: vLuA2m2qPLoPkCJJVlaDLrSCl-ftWZ8k
X-Sony-Outbound-GUID: vLuA2m2qPLoPkCJJVlaDLrSCl-ftWZ8k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_17,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-3.0 required=5.0 tests=APOSTROPHE_FROM,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
