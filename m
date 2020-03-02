Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6039E176018
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 17:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCBQgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 11:36:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbgCBQgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 11:36:54 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022GPupP005989;
        Mon, 2 Mar 2020 08:36:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=AUbXqrateywBrHOPlTM1Jp85CVB7LPGxc85/IKF0VU4=;
 b=iFA3Jc28vlI5zcyUoSvDRnpiqCP1UZ7My+dreKyMZupHncJ14H4HzfohuNXYz+Zm6tl2
 HLA903LHyjlF7SqkgkWtzUJQEEGrZr+hZ2Pm2Vy6q+TiGKF5CNU+gEFMAvRGinakBis0
 LHlDBnL2c/CacBPFFIe9u/NJDh66EYaBowk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8dcwhrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 08:36:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 08:36:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdatJERB0esgdKM72ExaSPcBUXyZnLfyRBjG1ffqqB6ANr2O+sLSOZWuc/8YMzZ5rulhrdr364I7XahBaG/f89i32cOhUWeJ9UinhF/ROjFh5k+Px4KNO6qcHrUMQSnLzGhwfeUcohzFpOo4wVkKku44bOYqeEixgFiAdIWy82i0OtPKHwOTO1RPGg4bJz4ntE1R7nRVTTWGnLXRZuAXCQlraagUZH0cxdRBGQQEUtjh9Y6v9FsgXpOMEDUiK59zk2GoIHVCjPr7EkV0Vv92e5vbhnG5SU0MJQ3Cx7YdHP0Ubv6AA+Gk9D/c+kjOtz7zzTRjSciUIVigaNNASNJOGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUbXqrateywBrHOPlTM1Jp85CVB7LPGxc85/IKF0VU4=;
 b=myZ/r4DheP/h0kOpoFm/3QkR2psOy9C+XLqNwTX9SAFvarybIYB8npDjtkv0X51Moub473ZRNP/O+AL1/lCI2ocDPBa/6XsdDACRImeoznRkRaohg1Rjo21W7j8pRrZxck4uacDreCpMqO5sZ/IuyOiUfXwe0cNKW07x5RUrjenXOBtkO4BRDhDtSQ5cj2LI3VjIWHw493MfDq8GzlmT8tya5xJSNbeiZ/GDnQWLvHnaCx1TV93hZzI64FSxLAYAieO4m7ayD155613+UwTy5MWBBiLWlJXGP6m9c22JJkzuDEx9t23vq1oHZy97+dJ+45+owVuXyHdg1cL3JUO3Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUbXqrateywBrHOPlTM1Jp85CVB7LPGxc85/IKF0VU4=;
 b=iZu8W5s5ELYU0Dvht2IT6FPj/J+khPJQ+/58Z0wySR2LLNkIdqglHLE9fLPB5cZnWmkjlDzOOCFj4gLbE42AKx67TuG2aE/2dPsMXSaqFXwPI1JGBJAndleOuOUl+5KiqGv76A+CT77+C+sWAvX+7/KFlcZrZt04EhlF/9R2Wlk=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB2905.namprd15.prod.outlook.com (2603:10b6:5:139::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Mon, 2 Mar
 2020 16:36:39 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 16:36:39 +0000
Subject: Re: [PATCH bpf-next 3/3] tools/runqslower: simplify BPF code by using
 raw_tp_xxx structs
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200301081045.3491005-1-andriin@fb.com>
 <20200301081045.3491005-4-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7c084b2a-fa9e-72f3-7d2e-f70dd9bea7d3@fb.com>
Date:   Mon, 2 Mar 2020 08:36:35 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200301081045.3491005-4-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:300:6c::21) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::6:87b3) by MWHPR04CA0059.namprd04.prod.outlook.com (2603:10b6:300:6c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Mon, 2 Mar 2020 16:36:38 +0000
X-Originating-IP: [2620:10d:c090:500::6:87b3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f076efd-f986-4bcb-1535-08d7bec7e198
X-MS-TrafficTypeDiagnostic: DM6PR15MB2905:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2905562B9E628E087809C161D3E70@DM6PR15MB2905.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(6512007)(16526019)(558084003)(8936002)(186003)(8676002)(31696002)(86362001)(478600001)(2616005)(81156014)(81166006)(4326008)(53546011)(6486002)(36756003)(5660300002)(66556008)(2906002)(6666004)(66946007)(66476007)(316002)(52116002)(31686004)(6506007)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2905;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AxaPKVhXwBH8QFl/GmN9EYdyYPGtU9FLGcmFP5a+u/t1oH2KqBeaWaaO8jPXYt/lD0OiV/IkFPwU6owv6E1eeyi9ao2QJzUIn8z4yqWt6cPbYmKO9yYU+OHUsCuqyyOd5VL/LkFTOd4XzAANRZaZIfdkm6KzM/SERjadcn1yR4O020L/BNMwcyF4L+zN4se8d8AN+yTM7sH2BDz284zoYUuroM/Ck9N73sE9OljOCDYnltFmy6Yj9qIUN5fyVXg7hB5lZdzwzxWQ0W7E6WAj1TS5ipttDZ8iGOUwnep1bisvyTRBkJxQX4I62dQ8ORQZoz8G9FqzxlMvBrPp6QfsiclIGxOaakkL//zRpT87SgwaISyf1ipsRQC+3nKNZbXxSaEqDo1VJytO6oPmc6ZeshOSUVpQiVXRcYjNUoKMF5rtn/HX57UxpJuWaF68y4SGFq6RIvn4F77VkwjOMq80uDdbc5eV2PjTKyItvQSmfP75NMN/3DB+XQ6RSeBfE+vV
X-MS-Exchange-AntiSpam-MessageData: Ezl3zz9vZTKGae672SiLhzc0Y8jE8Gx0o6GgIRBMhP5kh2JiewbMfl50sNQazO/QuvKJY+h1/JdTITVc/ZIL8QdzII2gDiHkfHjNK51Y+0f2shdP0oQFJKRKo1fTSntG9AOlv/U7ji9fkpBohanRohV1vkeZ6McC+CHPPt3zv3m6GKkesAUMChYodsImAzpA
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f076efd-f986-4bcb-1535-08d7bec7e198
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 16:36:39.0383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4q2zfbvwGf5bUkJjPhA49yDGHWxhNFCGZqWC8iCVHruuPMfZwpShSzEAqdETDw6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2905
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_06:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020114
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/20 12:10 AM, Andrii Nakryiko wrote:
> Convert runqslower to utilize raw_tp_xxx structs for accessing raw tracepoint
> arguments.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
