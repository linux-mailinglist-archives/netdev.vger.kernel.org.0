Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2CE51F4F4
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiEIHPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiEIHDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:03:05 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2060.outbound.protection.outlook.com [40.107.100.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3F11A4D12
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 23:59:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQDZVvTT4jGmRiSS1QasL2zJcOFtilM9og/T1raoj2MwFoAiz/cQk8nw1tfEyfXlgtKxeigf579I0Ix4v9OyW8pP8gYYNsHDgAVAqpPKHhYJTRFJMI7DtAxWBsvbDSDn6mUma1gzDkmYp/+dstPu8UL8wJiyI8dtfevSYb2H4dKOqs/hhdnIsI3jeXSKxH/OhGEcLt/5wu/odTVKbGVligb17ebUuNBsIVAa+T2/HpVhcwfV6LjgM7C3fGdntOZifKvaoYhNcPzouRKEzujRr374z5y90wGVGP684rwlgQa5W641kPk5JOYvLHfF0Y0W068tSzdayFrnrdnoPPuz1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t05f7GMron6z+cvvhN3d8nBwrUETTNG/AMFtYYl7eKc=;
 b=nSUpkjLLHNjrWzedf2dN2tUo+qDRRD6ZwhkhMHegnbXQes/xrpqpKyQBfBk9arf9DZHYLhz9VsGP3Ut25eX6eVqeOWt57KhEEZhAueKPd4A5SPj0lHsUGsl4ZxKkHEJZujN8n5P9wOPfY5GmbftkwdiSA18ObXLEhodrmcL6yj2nrZKLgK8x/vnic6Xq2uhANy8+vFJ/uI/DPsCa4xp9TURoCPZm4mJA2FvVK/MOQdMlQpDKVZ8YQvHmSPeC9vr2DdOoaR5S2vT9KAzNqmUwcNtD4umdVrtVGk9cPJK1ZkQIIcw4XK+PnHRF3UY1OdMvHPt7v4gmJFqBNK1Kx6lOzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t05f7GMron6z+cvvhN3d8nBwrUETTNG/AMFtYYl7eKc=;
 b=O0sOsb/J67WQgmMOK1GA3XscyEkvkmN0yCdLCGXQGKYFEjewwa1vzEB2Iy0lbxTM7EDZ6dj0brqsqLjUFxDcdg9jtKIQYhAQiwY2ITMKq+Us1aPOVcVQV6POF9OISETydWt3Zf4xlT0d7kaRmeOHjhqJbNG3oJ73LRiZAfwXH4U=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 DM5PR2001MB1051.namprd20.prod.outlook.com (2603:10b6:3:ea::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Mon, 9 May 2022 06:59:05 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::5047:44a3:6942:3ff4]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::5047:44a3:6942:3ff4%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 06:59:05 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>
Subject: Re: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYX4JgQ9a90BuNG0u1i9lIsMx3tq0PTj0AgABUASSAAATiAIAABLMNgAAA62OAAM6lgIAFpSXGgAAEuRg=
Date:   Mon, 9 May 2022 06:59:05 +0000
Message-ID: <DM5PR20MB205570BAE36B6ECE25906567AEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504223100.GA2968@u2004-local>
        <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <20220504204908.025d798c@hermes.local>
        <DM5PR20MB20556090A88575E4F55F1EDAAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
        <DM5PR20MB2055F01D55F6F7307B50182EAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220505092851.79d3375a@hermes.local>
 <DM5PR20MB2055542FB35F8CA770178F9AAEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
In-Reply-To: <DM5PR20MB2055542FB35F8CA770178F9AAEC69@DM5PR20MB2055.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31b2f720-af6f-4276-1352-08da3189681b
x-ms-traffictypediagnostic: DM5PR2001MB1051:EE_
x-microsoft-antispam-prvs: <DM5PR2001MB1051F9205081FA772F0C0D8CAEC69@DM5PR2001MB1051.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4FlulxZF6y5l5NTc8tZlo76rc4o+hDYyQDeAg8r3ktN8DLAeQM02lKHZh+2rbYXbYgbkZReqqbk/Pgr+i1lraFajU+BXlPip77GiS1xK1IUHjyeTpdDFTxnyyhzt9/DsMsYENMjYI5sjm9JzVsbi5B2t1iAGvPcqbP27LPC6smZEtGB5q78Wl2WcoHT7NmQ2qOYkG3XjkcGhYCHy5JO3tP8+gyqgdHIFRy/zeEQNX4tIx4my+9S93wxPqkJiryutSQNlVp5ICI9Gp13krIpI+azspP2NCW7sEEu49+N/Z7wQ1XTg+k8XPxFR7d+yEKF1OmXamXiSu8WNYV52nLmz0EL+feJWAy4ah18LNJ3/eWUdPPNuzUTj8gpI/faWVMgm2NbOzOkcLivMQ8RZWXVZ86AMqLZ66W0WPXy1B9gokcPBhOyRPvj9+OtpU5Ucfz5eu0AwkWDm4vcsv/m0uoFJ5iGq4XVk+Bgil3cr41QTBTCXSTioLeiHlR8+KEveaWdZ/afNr573L0VdYTcecLXG86+w917TIqZyIxFZqoab53+0LQb+5RW3y1br+bEyvFTst3Howr+C3F7f4OHQ+mnppDg6UyREEq/rZapsQQgYyGPRsmGJmh2a+iZsAvEmwCcn7Ib0upGAuF+CVW0s+CiCtTb6I4G+vxeeCOtY+tqJdq07cQEtcyrZFWunqf1qSEsxaagBzs6tfjc3mS3flD1XnrxCm03siQB8Qdy45PQW/k63hwMMWEu+zReMg8gbG9o9OkM/yei6SQDxnF2RHcqNNJDDKi+95KLBZMJ9FFiEIpc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39830400003)(136003)(376002)(366004)(396003)(55016003)(52536014)(316002)(5660300002)(508600001)(8936002)(38070700005)(33656002)(38100700002)(64756008)(76116006)(66476007)(91956017)(66556008)(66446008)(110136005)(186003)(66946007)(2940100002)(26005)(9686003)(86362001)(15650500001)(4326008)(71200400001)(8676002)(2906002)(122000001)(966005)(83380400001)(6506007)(53546011)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?24ZFzTw+VnWBTNHM8OI9V9Krdb9+Psck4r5VzkakxA9PQ4DJ5GT0uxuFEq?=
 =?iso-8859-1?Q?3h/kWmQcFDasbzqYkh+TblkYK7bLDGwxydZeOh7OSqpMzfpCkC4yQJcG3O?=
 =?iso-8859-1?Q?DNHLBOvR+Z4fTPKfGhPd5su5pRRhhp/vsa09/Eoxm/FoEf1FqqzK5SwTrP?=
 =?iso-8859-1?Q?2EZAb3xINnFskYVa4E1VTKSw/hFR7XkcjZB3Hl7AGpkVxoVCqPHJsb9fqU?=
 =?iso-8859-1?Q?tFQPUKUgIahbNa8haWPkiz5MpiOcGBr4+RBtw0N+nK42mVxOgectelnevV?=
 =?iso-8859-1?Q?Z37tRDmdXj3BM9DrsS5orS88vFIXvl/f+cwzUAxubBIjWC7zZmOTvaNAp6?=
 =?iso-8859-1?Q?53TnOKkYUg3VyT0wnqDc2NVioNhIATFF9nx3KxGgDwxSTotI6G/zu7UO1y?=
 =?iso-8859-1?Q?f9HbyU2qiYZleKST8hHvRJekvx+Rb/Z26ZovsUAIndUQPAR+YbDpEb6ApI?=
 =?iso-8859-1?Q?Yy606GsPwPCgSU1LUAWJBymZtgghUSrmYBjgF42QkS65MVqxRVbrr6Gb0j?=
 =?iso-8859-1?Q?a9j17PJtcG6LWHsTH6eISun0vXabsFqluniHHongvsWSn9uF0WhYQbnJ6u?=
 =?iso-8859-1?Q?I+2kjCYSSXRzcqJi+i8XFNK4CZ8Iwppy2jK54rCWchZwOy+NOu5UO+aZPr?=
 =?iso-8859-1?Q?6ZP87hyzGIyZFw1nCe4OOKqqa6FXBTYeCI4go6spr1DPSA/85SUqlsEH1J?=
 =?iso-8859-1?Q?m51C3qMMGCW9inpC3OrZsLCs/jm21fss5UMTyBjBqwuFwY7/VfubZ+3LXn?=
 =?iso-8859-1?Q?7Fq/sd1hIO+FEf9e4IjKidjeKgwQnxL9MWqOHg6i3UTFbh4o4ngGgf/x7l?=
 =?iso-8859-1?Q?BXpBveTVJF2mXSFodTKWrlAVsn9CkHJfV6X4N16Y9VDOM52wHXDBPbjdRl?=
 =?iso-8859-1?Q?SIcHeh6RrK6jJB3pxNw21aX9LUSEcI9PpdXLMhdtm31PvdQ0KVIRgElrz2?=
 =?iso-8859-1?Q?tLn2d1BANwIuePuTApYRHTIQAyCOgR7tMDop2iJwyFOmZvpNYL8adAd5og?=
 =?iso-8859-1?Q?bPGtavJH/VeacgM48y64iPQ/rhVY6PL+yj38HSsfcJtYbzZRbOHGQ1+2e9?=
 =?iso-8859-1?Q?BlJGH9Wpt58q/6G3SSRPT7lAJfgzyC3ttkkC5M+9U6uWRG/jOqncIvqSWN?=
 =?iso-8859-1?Q?Qnypzhtk9/AFAjRvEUfx4NIEoMVROiP0uqH/h1BcNEbSW7VIedyWthEJRN?=
 =?iso-8859-1?Q?3/2vhIGvd+EkGU2Plplyrg90oXVgKfiS+2QS4z6Ea9XqTVx5hRsnb8Jx5E?=
 =?iso-8859-1?Q?vAQMU9tYoiZhEMM80eeOMh0kAIGjnohbnsuvkFupa1A6f7nZ9c1dWHa8Kj?=
 =?iso-8859-1?Q?H2AZdSemICQYY6vFTCI/GT1uADyjpXy5JlyblVUCjzMhx/BYE4Oi2YLxXC?=
 =?iso-8859-1?Q?y9gBxPJoJ9+B9GJwcqra73x9yOPdJsumgVX9SakqncvSIxFhCrfC/O0xDN?=
 =?iso-8859-1?Q?quzUqC/23O6JuHDT7d4O/I0BOsmoC8gamtzibPxpAKGYehu/A6vKIwUsqo?=
 =?iso-8859-1?Q?3Njp+6D+HC/f0gMo6jVaicuYedfE0UX8JJ0JlL2usS6AKpwHeXUxYvMo+F?=
 =?iso-8859-1?Q?z59zEM/tNuf1BhE8uHGSnLRlmZOgQseDTFspu0cxNEVFD9L5DmwuGkSWzo?=
 =?iso-8859-1?Q?xz0Sr8n+dfNu+GqkEABbvvM5KkFF406elu9GdHm7zIGLZMalRhZ7J4iN/Q?=
 =?iso-8859-1?Q?qIo8kE93CEPJMmeScRahYvgmxgURkTGkW14YOqjvpFULNaA5OrptrWtNUm?=
 =?iso-8859-1?Q?5fI21DoZEtOca7Sp/vlmEGi7pYuBmYunEhtYiNjuNTP9eARnKSjDoJphro?=
 =?iso-8859-1?Q?eV6dZ/JwUQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b2f720-af6f-4276-1352-08da3189681b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 06:59:05.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQFvhAKwmvVTtc3OWk5klZ7OL/1pZnQ59YMHTFKtc8/5zT6PpowcMpcHq/yzSOjEhK7e4Kp5QfE+Kyh774M7T7+LCCbeRehECewEFHGDUos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2001MB1051
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
=0A=
=0A=
=A0=0A=
Hi Steve/Dave,=0A=
=A0=0A=
Thank you very much for great support and sharing the knowledge.=0A=
=A0=0A=
Dave referred me the file iproute.c but this contains the flow from user sp=
ace to kernel.=0A=
=A0=0A=
In my problematic scenario, the use case is from Linux kernel to VPP kernel=
 and this is where my parser at vpp kernel is not doing its work properly. =
The VPP stack tries to synchronize the routing table information from Linux=
 kernel through netlink messages.=0A=
=A0=0A=
My file netns.c looks like the following:=0A=
vpp-netlink/netns.c at master =B7 Oryon/vpp-netlink =B7 GitHub=0A=
=A0=0A=
I tried to implement the parser logic as shown in the following link but th=
at did not help.=0A=
Parsing the RTA_MULTIPATH attribute from Rtnetlink | Eder L. Fernandes (ede=
rlf.website)=0A=
=A0=0A=
I see only one gateway in parsing the RTA_MULTIPATH attribute inspite when =
I had configured dual gateways.=0A=
=A0=0A=
The existing code in netns.c works fine for single gateway ip route configu=
ration and it fails in dual gateway ECMP case. =0A=
=A0=0A=
Your help is greatly appreciated.=0A=
=A0=0A=
Best regards=0A=
Magesh=0A=
=A0=0A=
=A0=0A=
Sent from Mail for Windows=0A=
=A0=0A=
From: Stephen Hemminger=0A=
Sent: 05 May 2022 21:58=0A=
To: Magesh M P=0A=
Cc: David Ahern=0A=
Subject: Re: gateway field missing in netlink message=0A=
=A0=0A=
Have you considered using libmnl it is good way to handle the=0A=
low level parts of netlink parsing.=0A=
=0A=
https://www.netfilter.org/projects/libmnl/=0A=
=A0=
