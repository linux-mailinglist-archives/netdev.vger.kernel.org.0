Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19777563CFE
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 02:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiGBAcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 20:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiGBAco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 20:32:44 -0400
Received: from mx08-001d1705.pphosted.com (mx08-001d1705.pphosted.com [185.183.30.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E806258FD6;
        Fri,  1 Jul 2022 17:32:42 -0700 (PDT)
Received: from pps.filterd (m0209318.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2620WAgv010396;
        Sat, 2 Jul 2022 00:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=iVmToq1TNERoRp92crl6bJCFyCH3BH0qaTFul7bj6z0=;
 b=HK9Y3Kj8rHkotxZa5BfZ5ZPBzN/ezWs4fKNeJ9t0ZRRoHjilxeOH8oHmG4vAFVIDFysN
 QvRur0AV+L++B0tYFjYaXCR+Dsf6wJ+4BHk2zh8VKGXBd2Eqo53EMocj36ZI/8aiVFny
 ngsz19Mus/8Fvl5Vsmn/SzUgUc7vToVIaPokoilx8spvaS3QO/W1wQx4t8T8zEh3oeYZ
 Y/qTnxe8IQg1Z/ZmXrr640R6WyavZ9UvucQwMoFruEaixLf3Wjd9PfHtYkm+y8Up3yPh
 DnWAuIWBOxcDPNUSHxf8AHF2mJxoVkHNtIGgGWxb15LZ6MhIUvIgSmyE9N6SUc9ssyit Eg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by mx08-001d1705.pphosted.com (PPS) with ESMTPS id 3gwrx674sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Jul 2022 00:32:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfHdd0L1c7YcSHmBZalnczzXSrU95LVJDQ1VA3JLAlKmIFln6KcZKZ/rcAJ/Per8HUyYxvbYj1USBbSC5SZUGWz4k2ZszMDX0Wi7mrdtqPzqOyKey8BL2pKJHPrVy0oZVs9uQJX6Hxw22+mdyNuA1lKfrLEIFNYD5xD2dviHgBTFgZlyXViZvz364jKT7FUUF+IxG5t09vd2ZoXtZSXRD02+5c4R3sVXkcaa082g3uC9TeiKyfeZK2QPkaSe8tDWZS0syRJXQFZhQY2GkYYiuIqU8w3TB8Iu+NmhQJ6MBJjdn6t7DRc/T4d33FJHjkcVmOoRvwEdOQ688EFDep1PBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVmToq1TNERoRp92crl6bJCFyCH3BH0qaTFul7bj6z0=;
 b=k6gaPmsbNOtmnYZriTRw6cxaMy4g1tSlNEY2jXUm1x2Nv2uaguvlyc4wlCkrfpQMFWAwDy9DPoD+Kzf9O6cnMz0+ljrvxD6b+fFqR2BVXVeApJ5GEcRzaYDMo9b7AY6iMtpM2F37gsQPY37ZCUYpzj0JJTtZo3msdr5p95LP7R0hJePiaza1miL1VmVJWMWwq89wyuQI9iJonLLvJBI/vtYPsveqDyp0VCSG9UCWTui4umJn6sOcz7EwmPjDRH3F5sNOVZp1B17KcELMikhPFiYPfE5WLSsePjBEpE1mkIXMmN+XQxI3RsvOtJBDyfCyv8wZSx7D9CFCRWFPShGMpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from DM6PR13MB3098.namprd13.prod.outlook.com (2603:10b6:5:196::11)
 by BY5PR13MB3379.namprd13.prod.outlook.com (2603:10b6:a03:196::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.6; Sat, 2 Jul
 2022 00:32:05 +0000
Received: from DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::f879:1f68:a013:c06]) by DM6PR13MB3098.namprd13.prod.outlook.com
 ([fe80::f879:1f68:a013:c06%7]) with mapi id 15.20.5395.014; Sat, 2 Jul 2022
 00:32:05 +0000
From:   "U'ren, Aaron" <Aaron.U'ren@sony.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
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
Thread-Index: AQHYOMGW67qKpuT7dk2J1ij1Ec0M9azBu8uAgCjylwCAABPlAIAkPh0AgABqshCAKHvIgIABK1GAgB9noQCAEDSYyIAAN9SAgAH6aD4=
Date:   Sat, 2 Jul 2022 00:32:05 +0000
Message-ID: <DM6PR13MB309871595565FA5C5BDA19EFC8BC9@DM6PR13MB3098.namprd13.prod.outlook.com>
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
In-Reply-To: <20220630110443.100f8aa9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15fb0ee6-ce95-42e7-29a0-08da5bc24a50
x-ms-traffictypediagnostic: BY5PR13MB3379:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nQAiUjn6Y5VY6VKOjpWdgYgv5vfxhfQj4n1XtogYdVzKuZG5KtUBLwAYmSWLCzZZiRciJByBN4Wzv1kSRszIwtSfotUZD4EbhpoCGaOi+qWINYj4310Vh5dq2nu7y8asgpZPIJk/dR0XrtNrD1SLkht2zyNPFBHMiZVPqr6jMEPxB1PocBq2A9DigwWOquYhNxWMmgfQ8tHu694HbxsybCCBr5kt6RhMJAbOPY/da85hnv6mhyMiX8XDxU72TXbyiysIDM6aT4jtLWQZomXbwl75ePcYGZsPqmYF+61Z2TSuANJHUKHe0ODsgnL4e74ndg3Q2tkaqxKRaB1X2jFLfE5FtK3JF73EUQ1/7Amnj9EDASQzfIJ/Bi2Hd6KvvfA1QKrHXQmrCMcL74r5oeZ8vfQyE/euN3oVgVwDGSJ8s+1EbrAHpb/l/ZtsGI/6Z0TR1ATpd4zt/45TVLRS3b+j10Z6QBIIN9k5G92y3j2J4eb4/f4AEIR8KWoYG9OdaVs7p+NQIshVUNPvs8xpORErOR/IBCifCI7Xytmnulr392I8ruPxW1IQakWqsS3/AmG2Z3lEnzL090o3P6SjvyTLXdPLmki/CU4MWGnKMlcoqiS8D/uREdEZfOqkbUoX9QdNwu4pkDflY96asSheQkadsvu7hg/Mw6qYohvp1kVT5OoV1FuQfP0+Q+/Xc2DvGFxHuU88+q2Bi5PlpdMASTHNkolszw1K9rvqZQ9+lMAMlqLbMc+sokwfYYcGGcwIftL/rpaXGAu7V5SLENTd2acD9suMAM2Qe1YYnkrLgBSkWvtmmDqWHN42jP/VPvaCsQ6XJbOTnL7f1Ng6lYFwvcKcE8sto29zmYoanAv/X16jGCMmEEVLYyHmRDb0bNCqWb4J
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3098.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(53546011)(66574015)(55016003)(7696005)(6506007)(33656002)(186003)(26005)(9686003)(38100700002)(41300700001)(38070700005)(86362001)(122000001)(82960400001)(2906002)(66556008)(64756008)(66446008)(66476007)(76116006)(478600001)(66946007)(52536014)(4326008)(8936002)(966005)(316002)(5660300002)(91956017)(54906003)(8676002)(6916009)(83380400001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?raGvFw0gdpo+mnX+c9ub9p+vJJKRSkUOsJJZZvlxSmiAZ/s4v2wwsQGag4?=
 =?iso-8859-1?Q?lWvp6mhdEVNYiXgcy65cUxLTB220KCz0E0MszajR1k1YRMPfbfkCDoBvy8?=
 =?iso-8859-1?Q?rTPR9Xl0m/H5q6eESEW/XEG+gKxl2vsguQEalb1jC8Plbg4TEPGcxsKDg9?=
 =?iso-8859-1?Q?EVlgnd2YNco1vZxP0qy/bz+lODdM1H1A3IUkXenJB/SmQHkg0/0YeU1d+y?=
 =?iso-8859-1?Q?FVw3y9o5oskxWa1kvwHRuCL2diQwi1qUce3NOWaf+D6vu9wKzdiy/7+c33?=
 =?iso-8859-1?Q?iIab4NLWIH6lYMWHNpFWSF/iIsRTw0Ji+NlWqcJLEdQcv+cebr2UD+OHjI?=
 =?iso-8859-1?Q?rFFm4ewSDi13E4nX3QGJqCA/98L+FAW/qEc9F8aAIbIQHz3riv+AeIxjC6?=
 =?iso-8859-1?Q?r7md2pTIdP+nLf1UG/gZT/DoqRWRh5jKQosGPQCGnDk+gjE6JpOj198dGA?=
 =?iso-8859-1?Q?uKqP1DULQIA1IFjgHKpkPad4w+F6SdHg7xmHMaamwXkvdyu/CXjJkVeaau?=
 =?iso-8859-1?Q?BZopWTqMjeR7s3r/RKoiNuyCA68bLCU5teiTJYtFci4+f3TM7/dMLf5QSI?=
 =?iso-8859-1?Q?fG64n6gPWiLNv7sTv2xa5gDZU6AIJev3KtB7JffoDS9W6SeIud4HpL2FGp?=
 =?iso-8859-1?Q?wD3uoJwumQcFbrpKssOllEfPGjd/7exiBhj4reSCVCYV0xL96Y4RQhWd0s?=
 =?iso-8859-1?Q?2zghiHhVkHdHdS+WtO4dFnRrzK7epqmovb6DYSVme03tMNc8X+I+aE+64a?=
 =?iso-8859-1?Q?Nqg2xx6fB0iKSxTpaYlFPP3QbwKbjSXwrvecxTOSxodUz+JLkyETe3M80S?=
 =?iso-8859-1?Q?lNq6PJBKbVeT6dV+Bu9wn8ecuRjfzHY4CxX/JqT6dAOzCvLwSS2FUJAvsR?=
 =?iso-8859-1?Q?spHoapHE3g4sCZJ0uC2K35g6TL9RQlf3fpTJpMuL8fNBrSMQ6zXiHrmhfi?=
 =?iso-8859-1?Q?ZrWn8nTkUhURRb5eJkIkmdrzD88y2AFPRSGal5c4hy5/PHBdWhKqjya33+?=
 =?iso-8859-1?Q?+oumUwQNvkYGFPcAjzXz5BDelnMtYztNPQUnSx1gnYYhIxpEoc7G4g1KZd?=
 =?iso-8859-1?Q?T2g5l5DHYmvJIHONPnhVTT96RzIF6zfDtEYDbc3InxaoUp5+mDQvI7hMfu?=
 =?iso-8859-1?Q?xLiSz5B/AJJKrLUF4v5uMD8hVQEVvKNEQ1l98Iy+hYBBcqhRiCEiOqHZqe?=
 =?iso-8859-1?Q?c8lpGCFmcm/Wr7T7VnOkc8TO8xIY8E2tiBMR+1JlWe2QvOdzG1zz3ww922?=
 =?iso-8859-1?Q?njnVZHrKz5cx+13kf9VDByOpsDRxzI2mo9Pllc9+NeV6TZ3Q1dxYzNDfqk?=
 =?iso-8859-1?Q?bZO18geAy88G3WqWMLm+ifhhsdVbvFdBVqB0f1yn4M0KhUFznMa2BD1ipr?=
 =?iso-8859-1?Q?1FhfFRBpmo6TjdR7vjPuPzHifJfilTVUXp8FgEY1WziSwWhRRsPhPQLGDp?=
 =?iso-8859-1?Q?fT817KtOzJUc4SEuH2IwOuCObjqoCOC2BrIYNKP5ylJLgmdgqRSxNaRh0B?=
 =?iso-8859-1?Q?R2C+cu9bxPL1czrPhhAvRRXgyHfBWBh3ekfDawckbwwLSGrNRhj/L2IGfe?=
 =?iso-8859-1?Q?CyCIi+sGh6lCNTFfZFSwacZ+fKW8btm7Gwy/kvfcmJmqTyRMjktoZ4GgJf?=
 =?iso-8859-1?Q?nnZSuc8o/o9zB5ueeamaYrBA/qxgR7gzxh1SyaTQnni/0ifPj/cqWZeA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3098.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fb0ee6-ce95-42e7-29a0-08da5bc24a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 00:32:05.4272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9N8t8lxSLUOaENEhxRa7dp1REJpyYd4mZvh69y6Fq1l0AK7FgPk/ntNH9fNi96EgXPxnIy/eXB4FLLjoiLLdIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3379
X-Proofpoint-GUID: MgrD_FOjnOXkT7El7NXXtDh8W4TaFm6G
X-Proofpoint-ORIG-GUID: MgrD_FOjnOXkT7El7NXXtDh8W4TaFm6G
X-Sony-Outbound-GUID: MgrD_FOjnOXkT7El7NXXtDh8W4TaFm6G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_16,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=APOSTROPHE_FROM,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial results so far is that adding back IPSET_ATTR_GC seems to make the =
difference. I've only done two rounds of testing so far and we've had at le=
ast one false positive in the past with our environments so I'd like to giv=
e it a little more time to say for sure. I should be able to get back with =
you early next week more conclusively.

This was my patch:
diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/lin=
ux/netfilter/ipset/ip_set.h
index 6397d75899bc..e5abb4d24e75 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -93,6 +93,7 @@ enum {
        IPSET_ATTR_CADT_MAX =3D 16,
        /* Create-only specific attributes */
        IPSET_ATTR_INITVAL,     /* was unused IPSET_ATTR_GC */
+       IPSET_ATTR_GC,
        IPSET_ATTR_HASHSIZE,
        IPSET_ATTR_MAXELEM,
        IPSET_ATTR_NETMASK,

It would be good to know though from the maintainers perspective whether or=
 not this even makes sense or not?

The primary user of iptables / ipsets on our hosts is kube-router, the Kube=
rnetes networking framework we use. Its usage for each of these tools invol=
ves exec-ing out to the ipset (https://github.com/cloudnativelabs/kube-rout=
er/blob/master/pkg/utils/ipset.go#L176) and iptables based binaries (via th=
e iptables wrapper scripts from the coreos Go library: https://github.com/c=
oreos/go-iptables).

In regards to ipsets, it mostly calls "ipset save" (https://github.com/clou=
dnativelabs/kube-router/blob/master/pkg/utils/ipset.go#L535) and "ipset res=
tore -exist" (https://github.com/cloudnativelabs/kube-router/blob/master/pk=
g/utils/ipset.go#L551). There are a few outliers in the code that create an=
d populate ipsets individually (also using the binaries), but most of those=
 have been converted to save / restore because of the performance penalties=
 of exec-ing out constantly.

On our images we run ipset 7.15 and iptables 1.8.8.

-Aaron

From: Jakub Kicinski <kuba@kernel.org>
Date: Thursday, June 30, 2022 at 1:04 PM
To: U'ren, Aaron <Aaron.U'ren@sony.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, McLean, Patrick <Patrick=
.Mclean@sony.com>, Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel=
@vger.kernel.org <netfilter-devel@vger.kernel.org>, Brown, Russell <Russell=
.Brown@sony.com>, Rueger, Manuel <manuel.rueger@sony.com>, linux-kernel@vge=
r.kernel.org <linux-kernel@vger.kernel.org>, regressions@lists.linux.dev <r=
egressions@lists.linux.dev>, Florian Westphal <fw@strlen.de>, netdev@vger.k=
ernel.org <netdev@vger.kernel.org>, Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between 5=
.10 and 5.15
Sounds like you're pretty close to figuring this out! Can you check=20
if the user space is intentionally setting IPSET_ATTR_INITVAL?
Either that or IPSET_ATTR_GC was not as "unused" as initially thought.

Testing something like this could be a useful data point:

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/lin=
ux/netfilter/ipset/ip_set.h
index 6397d75899bc..7caf9b53d2a7 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -92,7 +92,7 @@ enum {
=A0=A0=A0=A0=A0=A0=A0=A0 /* Reserve empty slots */
=A0=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_CADT_MAX =3D 16,
=A0=A0=A0=A0=A0=A0=A0=A0 /* Create-only specific attributes */
-=A0=A0=A0=A0=A0=A0 IPSET_ATTR_INITVAL,=A0=A0=A0=A0 /* was unused IPSET_ATT=
R_GC */
+=A0=A0=A0=A0=A0=A0 IPSET_ATTR_GC,
=A0=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_HASHSIZE,
=A0=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_MAXELEM,
=A0=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_NETMASK,
@@ -104,6 +104,8 @@ enum {
=A0=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_REFERENCES,
=A0=A0=A0=A0=A0=A0=A0=A0 IPSET_ATTR_MEMSIZE,
=A0
+=A0=A0=A0=A0=A0=A0 IPSET_ATTR_INITVAL,
+
=A0=A0=A0=A0=A0=A0=A0=A0 __IPSET_ATTR_CREATE_MAX,
=A0};
=A0#define IPSET_ATTR_CREATE_MAX=A0=A0 (__IPSET_ATTR_CREATE_MAX - 1)


On Thu, 30 Jun 2022 14:59:14 +0000 U'ren, Aaron wrote:
> Thorsten / Jozsef -
>=20
> Thanks for continuing to follow up! I'm sorry that this has moved so slow=
, it has taken us a bit to find the time to fully track this issue down, ho=
wever, I think that we have figured out enough to make some more forward pr=
ogress on this issue.
>=20
> Jozsef, thanks for your insight into what is happening between those syst=
em calls. In regards to your question about wait/wound mutex debugging poss=
ibly being enabled, I can tell you that we definitely don't have that enabl=
ed on any of our regular machines. While we were debugging we did turn on q=
uite a few debug options to help us try and track this issue down and it is=
 very possible that the strace that was taken that started off this email w=
as taken on a machine that did have that debug option enabled. Either way t=
hough, the root issue occurs on hosts that definitely do not have wait/woun=
d mutex debugging enabled.
>=20
> The good news is that we finally got one of our development environments =
into a state where we could reliably reproduce the performance issue across=
 reboots. This was a win because it meant that we were able to do a full bi=
sect of the kernel and were able to tell relatively quickly whether or not =
the issue was present in the test kernels.
>=20
> After bisecting for 3 days, I have been able to narrow it down to a singl=
e commit: https://urldefense.com/v3/__https:/git.kernel.org/pub/scm/linux/k=
ernel/git/torvalds/linux.git/commit/?id=3D3976ca101990ca11ddf51f38bec7b86c1=
9d0ca6f__;!!JmoZiZGBv3RvKRSx!_lqhDxhzSRqmfCd8UGNkA-LzIuwspFCIolqiglSgQ0Y0TP=
MlX67qYlEk4Bh7IVFlB53_TUqF-16t0Q$=A0 (netfilter: ipset: Expose the initval =
hash parameter to userspace)
>=20
> I'm at a bit of a loss as to why this would cause such severe performance=
 regressions, but I've proved it out multiple times now. I've even checked =
out a fresh version of the 5.15 kernel that we've been deploying with just =
this single commit reverted and found that the performance problems are com=
pletely resolved.
>=20
> I'm hoping that maybe Jozsef will have some more insight into why this se=
emingly innocuous commit causes such larger performance issues for us? If y=
ou have any additional patches or other things that you would like us to te=
st I will try to leave our environment in its current state for the next co=
uple of days so that we can do so.
>=20
> -Aaron
>=20
> From: Thorsten Leemhuis <regressions@leemhuis.info>
> Date: Monday, June 20, 2022 at 2:16 AM
> To: U'ren, Aaron <Aaron.U'ren@sony.com>
> Cc: McLean, Patrick <Patrick.Mclean@sony.com>, Pablo Neira Ayuso <pablo@n=
etfilter.org>, netfilter-devel@vger.kernel.org <netfilter-devel@vger.kernel=
.org>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.rueg=
er@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>, =
regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian Westphal=
 <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, Jozsef Ka=
dlecsik <kadlec@netfilter.org>
> Subject: Re: Intermittent performance regression related to ipset between=
 5.10 and 5.15
> On 31.05.22 09:41, Jozsef Kadlecsik wrote:
> > On Mon, 30 May 2022, Thorsten Leemhuis wrote:=A0=20
> >> On 04.05.22 21:37, U'ren, Aaron wrote:=A0=20
>=A0 [...]=A0=20
> >=20
> > Every set lookups behind "iptables" needs two getsockopt() calls: you c=
an=20
> > see them in the strace logs. The first one check the internal protocol=
=20
> > number of ipset and the second one verifies/gets the processed set (it'=
s=20
> > an extension to iptables and therefore there's no internal state to sav=
e=20
> > the protocol version number).=A0=20
>=20
> Hi Aaron! Did any of the suggestions from Jozsef help to track down the
> root case? I have this issue on the list of tracked regressions and
> wonder what the status is. Or can I mark this as resolved?
>=20
> Side note: this is not a "something breaks" regressions and it seems to
> progress slowly, so I'm putting it on the backburner:
>=20
> #regzbot backburner: performance regression where the culprit is hard to
> track down
>=20
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>=20
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
>=20
>=A0 [...]=A0=20
> >=20
> > In your strace log
> >=20
> > 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [=
8]) =3D 0 <0.000024>
> > 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE=
-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
> > 0.109456 close(4)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
=3D 0 <0.000022>
> >=20
> > the only things which happen in the second sockopt function are to lock=
=20
> > the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare the=20
> > setname, save the result in the case of a match and unlock the mutex.=20
> > Nothing complicated, no deep, multi-level function calls. Just a few li=
ne=20
> > of codes which haven't changed.
> >=20
> > The only thing which can slow down the processing is the mutex handling=
.=20
> > Don't you have accidentally wait/wound mutex debugging enabled in the=20
> > kernel? If not, then bisecting the mutex related patches might help.
> >=20
> > You wrote that flushing tables or ipsets didn't seem to help. That=20
> > literally meant flushing i.e. the sets were emptied but not destroyed? =
Did=20
> > you try both destroying or flushing?
> >=A0=A0=20
> >> Jozsef, I still have this issue on my list of tracked regressions and =
it
> >> looks like nothing happens since above mail (or did I miss it?). Could
> >> you maybe provide some guidance to Aaron to get us all closer to the
> >> root of the problem?=A0=20
> >=20
> > I really hope it's an accidentally enabled debugging option in the kern=
el.=20
> > Otherwise bisecting could help to uncover the issue.
> >=20
> > Best regards,
> > Jozsef
> >=A0=A0=20
> >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> >> reports and sometimes miss something important when writing mails like
> >> this. If that's the case here, don't hesitate to tell me in a public
> >> reply, it's in everyone's interest to set the public record straight.
