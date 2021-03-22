Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0095C344DF6
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCVR7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:59:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42798 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbhCVR7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:59:38 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MHxRbs026355;
        Mon, 22 Mar 2021 10:59:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=DRzSr5CgmuCew7f1uaRwc29Ez358PewDqqmqh5bt9qI=;
 b=Ep1JvT5kTBDnKJtteNzM2gcHl2mVpHSdyNN+7M8tjI3//1HEsD8xeNAw+pCBqMcWFlPy
 IqlxFtm0Pqdz00l284HFJs7VcmMqF+4+vl7WxFhoc+MeiPauenVJXC0AxW+zjXsO/Sg8
 P88bZxHJ54ZCzjKdOpMNMUrvLEC/v5ccAtw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37e0sxpybh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Mar 2021 10:59:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 22 Mar 2021 10:59:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9hABFTETuufzjYccs7rO8y846hIulu46/dNkNsIrzP5HosWCbIFeQifHIJcc6c635VRePTJBEoHpmbhX2Upr4wOgRdWZdMS1N8ebhkALeZCVuHi1A13Yi4+GI2iVsfEZT6nfzxTrBD+tOb12bgEoBJuHFC6ahjqR+UyYsxxUS4zW8U05VErDTfB+Vvd6OQAOryOIuwz+/j4zvsbQa/HNE61yLruyJszjDxW5LSo5AdTWCEV6429vbImDkg3RxmqWm50oqCcXMFP53aIH0W/+e3ld1TJbevpiFDB+X23+ReZFtQ6yWBX/rPahUAG+gLj6HScWOdpwOcR2vVrPxwOiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPRWgbP4wyBoi3EhujCtEsDoKUwTTo6NrY8+DLYejMo=;
 b=UcL4DM0+xLkoD3XfF6JxSl7Sm0Do2IePD8MF7hvTympUStg1vzgKyclYnmWE6uol5H6lld7uuG2qIrOQOs06Bw6WSKEY3QFcbFSg2zKYQzPn9SuJ0tGw+OSM+z9X0kuFPHRbOPMf5X+NuPaIAmSMeKx788jQ91s2uqg/F3pECuXC8j5SzXdVnAdxqzh/RcdrEq5KmC27WCTcfxu5tipm+B+hQ9PSD9sL0PoOqGEWBwh5uUyMceVgmkNE4HvPif8tGri4Hex8K3Y0T86+ia727EkvFXUsBDw7D1E//COT8tt2+WBtzg9VEgOmsHM/XUMJo3qskT0BNkRFoo9GiIOqpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: mildred.fr; dkim=none (message not signed)
 header.d=none;mildred.fr; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:59:26 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 17:59:26 +0000
Date:   Mon, 22 Mar 2021 10:59:22 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Shanti Lombard =?utf-8?Q?n=C3=A9e_Bouchez-Mongard=C3=A9?= 
        <mildred@mildred.fr>
CC:     bpf <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alexei.starovoitov@gmail.com>
Subject: Re: Design for sk_lookup helper function in context of sk_lookup hook
Message-ID: <20210322175922.wu5igribakuc7pl6@kafai-mbp.dhcp.thefacebook.com>
References: <0eba7cd7-aa87-26a0-9431-686365d515f2@mildred.fr>
 <20210319165546.6dbiki7es7uhdayw@kafai-mbp.dhcp.thefacebook.com>
 <a707be4e-9101-78dd-4ed0-5556c5fa143e@mildred.fr>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a707be4e-9101-78dd-4ed0-5556c5fa143e@mildred.fr>
X-Originating-IP: [2620:10d:c090:400::5:1cda]
X-ClientProxiedBy: MWHPR19CA0050.namprd19.prod.outlook.com
 (2603:10b6:300:94::12) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1cda) by MWHPR19CA0050.namprd19.prod.outlook.com (2603:10b6:300:94::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:59:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6907af70-8710-40ea-e40c-08d8ed5c3b31
X-MS-TrafficTypeDiagnostic: BYAPR15MB3191:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3191D88AEC0779B477AB02A4D5659@BYAPR15MB3191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XeCZDEXO1i1CMWeo1vncSfWiJ+uMPAWIUBisg9gj/jkxj+egC86MmIRn3VMTR4WDoV89kw7jRMlG6r4WvnWtmJMNWFznDQoMqYrdnfUaG59wkixViQkl0kAWPuAd9325rhlRFrLthMILDeJk3YX5Ytd0ofoegYy2dedcXmjCm9AgcumzBCSZ8xXykevj7xS6tTqFe/4wENB733WGkJUxLISj0VtlOU0YsR9eZNMmWNT6tPZaZgZO2T9JDDXf0QSNq8v5SuUv606Lt/HZ5YHsXpqyx/q9Et0cxZmsKq9ON5pOB8hqsr5obKQbbbcGVzZl9uhCDrPu1I5aHmTBdL27TkVG4g8vFkcY30rgTB3+ahc3Z5vsVbJO+BR8OHEmLDzYypKIyE8yhPyM6859kqkADm7RzV0xy6A3JGckan9GxNGENrunSpTFMje+/+ac3T1dGO4JFKlwyyRc2pi9rsfI9iqeChkzxHETdyXBcaxUrjc9Dw96Ud4SbsWxkNyk17KIiv43bExMopb1nUORkIqut8BQXXT1gfAjZwVHDv+cjee1/ywAYxjkUOdsVc92zF/jQ5PyjkqNFWPaLmrbWJMM7gqg+00alkmisO5q1kK5LkDKe58uQEmHGRY0ylidF4vQVWFqp+91HBO2YjIntfgnZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(136003)(366004)(376002)(2906002)(8676002)(66946007)(6916009)(66476007)(66556008)(1076003)(9686003)(55016002)(4326008)(66574015)(6666004)(8936002)(5660300002)(83380400001)(478600001)(86362001)(6506007)(186003)(38100700001)(7696005)(16526019)(316002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?128MDRwSLc+1zt83e//USGS9zp7vDiUfg4AaGfZ5sFEIGCIUIwd+IMZSX+?=
 =?iso-8859-1?Q?9xmxvXUEdIC0OrFzL9OmXF0g2dxl6Sr96ry0c5C6jLCGno4xtunxkj0F7T?=
 =?iso-8859-1?Q?x6R/uffvcWwQj7Y6/TNFzKIHX6Six32h+aQPkdoZBuTJdJJ3qZveY+1yQn?=
 =?iso-8859-1?Q?+mmzuJ2JDqNSaInJ9ZJNvPy/p/+A+SW6DWMPXbRcErewUt2Eo6by7GmRfM?=
 =?iso-8859-1?Q?GHJuCgfg19TAraO+rRv2/cd/I7VTb9kvsLvybLN6lkzp/gm0bGkzhyP2oY?=
 =?iso-8859-1?Q?ggRt8P35pHO9Xs66TaCotabmCYNSM69Tr2oMpE+/A42pnhAfScv7MfMOcl?=
 =?iso-8859-1?Q?cVftMHspdGFy8pRxkhmSp61Mr77GLkn26tugIntcahZa9JUy9Jwz9rhZDB?=
 =?iso-8859-1?Q?B9xC83xVed6ySqYutiST0E0wCB5u5A84DrB5VU5FQXEfgWMhspGMNgTwrS?=
 =?iso-8859-1?Q?zbAm/AhX/A+d0QDz5mcE7/GOnDxJTqAM7CcglTEU7TTJkoirdwtXj6rTAB?=
 =?iso-8859-1?Q?4MxTg933z0XX2Gc/can1P4LF6PhEYx/10fVa1fnql+WEZM75e/1Nv2eGZF?=
 =?iso-8859-1?Q?2nSOJDFwRilS2CmEo0kWzhvqNMkzERqg8ezfqkpzN9QvJ3Hfq9MHbnLwlY?=
 =?iso-8859-1?Q?vn1tpGqNHwRDO/AnNNHEbLCxe69Eqc/NdIVKJEMVZxWsRelJaTiQ+7PVvg?=
 =?iso-8859-1?Q?8aGjZ7IVgNktKcG3SmlTcfZrOWrSeqJDJnXN4a+GHuGMbAKPGsBM/b8H1x?=
 =?iso-8859-1?Q?5e1Ygqyt4tqCqeaNbcwXd2XfFeJ7HspcqkQj0kfvo3anFGz/I9Wo5ynarT?=
 =?iso-8859-1?Q?OmIBGQtuIBLQw6mN3duR58bvfUBVUgv+prjPDuOfmz+z2IfMzhPQBroHrD?=
 =?iso-8859-1?Q?ZbEtUz2tcDlv8IV48lEskASfta3tGb80qwpTZjomhKxBkHirOZ2VABbH0A?=
 =?iso-8859-1?Q?cIfGnXEbzMQjTY2pVshlIqYsVoZpa4IuxTnwsC9NwRoOfCb7eqZWWDgiPn?=
 =?iso-8859-1?Q?d7PqMI4HS17BwPHevWKHFeW1zuSaqHIskDOO9Bzvx6OQC5lqiPluATG8Xe?=
 =?iso-8859-1?Q?zpASk6kLTsaNJ1AgNw3A5/IR6XbM3UtwGYVM8axGxaIjGXV+g9FvNpaBlt?=
 =?iso-8859-1?Q?LKnTfnR8Pr78QofcvxtDNfXUP1XnoJgo08j5bvU6Lijh1KsK1pNbT3QHj1?=
 =?iso-8859-1?Q?1ZAl6UNet1j5+eokcrE7lod2DkDH5zq5W+Rtf73sfUunr0oG4QtWDvjdQv?=
 =?iso-8859-1?Q?dS0uKMeoMaxkXIGS/H0gmyOLRQfBP2jl5TlKh58inTF1X9IdRRrxClSFMe?=
 =?iso-8859-1?Q?xA3AdAjrS/z++XVRQeWWORQdaIdHfH/DwA5BOSnCzhs+q/Jr4qw2Lt5ts8?=
 =?iso-8859-1?Q?Kqp+xLGEADD7y/Cxz8VjJuWUD/TWa2Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6907af70-8710-40ea-e40c-08d8ed5c3b31
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:59:26.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7K2VUus1EwbI0ZkF8mmSKGxqUple4ezzFix+JBTJg92QgBVNB35F+7QwtIYMFU2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_10:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 06:05:20PM +0100, Shanti Lombard née Bouchez-Mongardé wrote:
> Le 19/03/2021 à 17:55, Martin KaFai Lau a écrit :
> > On Wed, Mar 17, 2021 at 10:04:18AM +0100, Shanti Lombard née Bouchez-Mongardé wrote:
> > > Q1: How do we prevent socket lookup from triggering BPF sk_lookup causing a
> > > loop?
> > The bpf_sk_lookup_(tcp|udp) will be called from the BPF_PROG_TYPE_SK_LOOKUP program?
> 
> Yes, the idea is to allow the BPF program to redirect incoming connections
> for 0.0.0.0:1234 to a specific IP address such as 127.0.12.34:1234 or any
> other combinaison with a binding not done based on a predefined socket file
> descriptor but based on a listening IP address for a socket.
> 
> See linked discussion in the original message
> 
> > > - Solution A: We add a flag to the existing inet_lookup exported function
> > > (and similarly for inet6, udp4 and udp6). The INET_LOOKUP_SKIP_BPF_SK_LOOKUP
> > > flag, when set, would prevent BPF sk_lookup from happening. It also requires
> > > modifying every location making use of those functions.
> > > 
> > > - Solution B: We export a new symbol in inet_hashtables, a wrapper around
> > > static function inet_lhash2_lookup for inet4 and similar functions for inet6
> > > and udp4/6. Looking up specific IP/port and if not found looking up for
> > > INADDR_ANY could be done in the helper function in net/core/filters.c or in
> > > the BPF program.
For TCP, it is only for lhash lookup, right?

> > > 
> > > Q2: Should we reuse the bpf_sk_lokup_tcp and bpf_sk_lookup_udp helper
> > > functions or create new ones?
> > If the args passing to the bpf_sk_lookup_(tcp|udp) is the same,
> > it makes sense to reuse the same BPF_FUNC_sk_lookup_*.
> > The actual helper implementation could be different though.
> > Look at bpf_xdp_sk_lookup_tcp_proto and bpf_sk_lookup_tcp_proto.
> 
> I was thinking that perhaps a different helper method which would take
> IPPROTO_TCP or IPPROTO_UDP parameter would be better suited. it would avoid
> BPF code such as :
> 
>     switch(ctx->protocol){
>         case IPPROTO_TCP:
>             sk = bpf_sk_lookup_tcp(ctx, &tuple, tuple_size, -1, 0);
>             break;
>         case IPPROTO_UDP:
>             sk = bpf_sk_lookup_udp(ctx, &tuple, tuple_size, -1, 0);
>             break;
>         default:
>             return SK_PASS;
>     }
> 
> But then there is the limit of 5 arguments, isn't it, so perhaps the
> _tcp/_udp functions are not such a bad idea after all.
> 
> I saw already that the same helper functions could be given different
> implementations. And if there is no way to have more than 5 arguments then
> this is probably better to reuse the same helper function name and
> signature.
