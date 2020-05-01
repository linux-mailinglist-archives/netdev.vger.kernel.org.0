Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD051C2100
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgEAW5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:57:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63566 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgEAW5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:57:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041MdNuK028572;
        Fri, 1 May 2020 15:57:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=MGG2z/UTQNRC+GMT/UNK4CrADMiggv3wAMqAbao4fQE=;
 b=h0Zn+9HYHOn/lEEX3kgAGR9H08hyIomAk+UEcXzf1ypcsBg+jDKpliRPX6eCuSCFlz4I
 Nr/6r2gXyGtsxWz7ep1BxAVPfilKAEcs7dGrJnGU0XI0JChNW6lg16GhaEqv3IMpOr7B
 xH1TfUKXMBNl+h9pU/ahp1dhtpMhS/Wgwco= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30r7e2e924-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 May 2020 15:57:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 15:57:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN59SL7H0fp+xt88JkSJdWhz5zPpFFaxqSlid/jQNsO4Sr6lBtzYFOcfdS8Y/HAcbzPaiDGbastoSs5gUhd7PEDTHresGRJViMn6XBZx80ZCXI1hFHwEg+3i1h3bhhAQyOzLcDQ9kduS461UVK/x2qltOMrQ9GF9vxz/wNVn3AvqevH1bvcEy+v4+A48RPgUVtOEZuxwuHYgXEwZEu8e6xoej3DRy2GTHSJiQsICTCbThx4NV0YztqLMGlLJBtXQP5fQuEA7NfAMI3ZKgQnco0rO00UeVQyw5ZKhEdVyQrbSGZFfghAMc2yNaK/QTubsC7HdsgypFSxF/ZUoSqqPRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGG2z/UTQNRC+GMT/UNK4CrADMiggv3wAMqAbao4fQE=;
 b=AO4pCE9h9jjFw79QCttWj/LzJHumcKz8bqhu5JlNh/IZzbXL8+xxDZ8Zq9RY+GR1uYrzA5ep2sjuf7TgWL87n4LXHvXImovjT/1DIVB1rO0mjnMpDd2Y8x8gU9ni5c5UXFLnBDdyJlKBHwpDFZ4pITdhBbroExk7FjIrwUBS7JYu7CNl8KGkQ0lG4KYEjLNRqTrGgQIvewCg6sJ03GWvgr0S6nKh1moRnRP11709mf+otsJUQzhtPMs7DFwPdQsk+HIGDj6iEA/e+Ubed4K8b2NnP364aWkhQ/ad7NzNgIpgs4uwfoGAL3QT4E25Xn0MfhDnwrwF3r9nbiYwJrrfSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGG2z/UTQNRC+GMT/UNK4CrADMiggv3wAMqAbao4fQE=;
 b=HQeVaitgJ3RImCsSdRl4Gm9LiMQVs9qdcJCiHo9t25EyMfmP58mUYPrh76e0ThjIqUHfVlZBQXTNWbQ2DCfAubrBUg2w21pOStBD0TzpudXNp6GcmDR1JavFGAmNBqOjzr0dxT27OxY/VVzwV/+JQpQIMmWzkx+2/PdxpCVEWwo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4076.namprd15.prod.outlook.com (2603:10b6:303:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 22:57:02 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.027; Fri, 1 May 2020
 22:57:02 +0000
Date:   Fri, 1 May 2020 15:57:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: use reno instead of dctcp
Message-ID: <20200501225700.j4dukc7t5hxaijer@kafai-mbp>
References: <20200501224320.28441-1-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501224320.28441-1-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR11CA0048.namprd11.prod.outlook.com
 (2603:10b6:a03:80::25) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:da44) by BYAPR11CA0048.namprd11.prod.outlook.com (2603:10b6:a03:80::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Fri, 1 May 2020 22:57:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:da44]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c19b87de-a9d1-4e03-2680-08d7ee22f641
X-MS-TrafficTypeDiagnostic: MW3PR15MB4076:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB4076838710AAF351F0D88C51D5AB0@MW3PR15MB4076.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Duovzpk8RRq7SSL6jrGHfYr05jPQ3MBQAYA232GAlcL9eVrstvxbuEci3Hf4h508shCQT7Bc6YUK+MaWjSDmL2k5mYuLb9xMQ1rkTHI6HZAeBBaHmhDR2kl7iVK2hW5q/wwkag+WozTx6VwEgqGTjDuA6XvUuNe6xi5ZCKhxBp+OIcjzJR6pBAWguuTsUts0aDIxKQSkaJhEDNwcPXHF2ccQ6XS97Y8nC1oPRwDNERWSLvp7OO4vmTr1NRyx7MQ1qZlfmSAES0QYNZHvySQvszqwj/+NCdVHQgAFJrHbUIja/87H44qnq7HSPV/o0KW9lqoD1Y1hs0KLIKzVjV8egPGzt/g+TDgGiEvsStIqZC/7NAeQ4GSJX+s/sFTl6l7/C6Ot+UK2JIq6IAYDcrv9d9gmghRB3Jn4K5Cp62MOfJ6EcdGtCHtgKaqZEu51x55N2zUbTtuoWBACnRXxrQOd4W/GZY/cfRjvkmWT1XvBHWI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(39860400002)(346002)(136003)(376002)(4326008)(316002)(66946007)(55016002)(5660300002)(9686003)(2906002)(558084003)(16526019)(66476007)(186003)(66556008)(478600001)(6916009)(6496006)(33716001)(8676002)(86362001)(1076003)(52116002)(8936002)(17423001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X8woHq/vutupyXzeDFxTeOnIyZQnAaVJ+zVUfb7kxDP2mXjKangEroKo3+AIWj2/lpm/YlG5MqYr4zVsixRXlTN02OBaZ/gxpZkWSoNT+Sj2NEQBBKRi+AceQb8xcvQ3L97JuFMVwGBr3+pyKsijBaH6cCxUA0vE6fgTmtEdFbw+CAiBpzRoO4h8s718wkv/4TQ6SLkoPB0EyyYWaR53GlEvDNMeqdZCtkpyxSsORk3UvJoRcVNA8iqyGrlTIDg0+OcGZGIaWbMDHeEv5GTvk8vo22Egx+VNzH9iIO/33k37i1QGeP4XReT4mUKpcWli8tFvohhsyHxXSZO74VksvsOyipegCWm7HPiph6ITr6HGGVIM7KhRKRV0kFyMgVDUDM+DBUsbEHUL4gjCXSlF8FQefE2zDLPvomUynV0dwoPowGxaoJvhJ5+hOo/HJoYYRLg1S66iQ4UKBANkGxM9W61+ZOujAWc7uefxJGyTjUfb6K4+Q6opU9rXr4ucjCntSvucByLaoNC7Kbpl0LvX3SsAyTRBmfQSFuGUXTybLEDn7Arg2hKKedwnJZESk22WhSdQEsrg+R+nfjxC+NzCZC2YfpdKFVpmSb14Tvgdd63ota6WrBAJlrncBG576ueuSQBuq/SHIbYQVDyGprlsFqaRNu5fEbNgMWJkRyoJdD1lYTWLv5mlsnm4OyBAgADw6+SwrFALe9sESo+hiylTgqcPoeZ4lRJQscf6taT1Lml5Y9FVCqibojSqR2dehHL81S0pZ2MISg+b9KfKTo5otSivvsMISTBjR4iik48VFNEB2uXyKDcg17Xu/ND7b71+rsjqpIpTKDNV8ijtvsgsDg==
X-MS-Exchange-CrossTenant-Network-Message-Id: c19b87de-a9d1-4e03-2680-08d7ee22f641
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 22:57:02.5670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJ7E/zYVsCPmZ2R3a4EG8+QvTXeQXSK4wiZv8UfQL5tOSdY8lvy3f1aLg2wn9EKv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4076
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_17:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=708
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 03:43:20PM -0700, Stanislav Fomichev wrote:
> Andrey pointed out that we can use reno instead of dctcp for CC
> tests and drop CONFIG_TCP_CONG_DCTCP=y requirement.
Acked-by: Martin KaFai Lau <kafai@fb.com>
