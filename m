Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5716D4FC25A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348597AbiDKQbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348480AbiDKQbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:31:17 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E5F1C6;
        Mon, 11 Apr 2022 09:29:03 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23B94HZX020841;
        Mon, 11 Apr 2022 09:29:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=74hNWuWL/KQNbZbSYtXLD0PXxqbcZ5NcXId+EJacO3c=;
 b=b+/3guv7kUcU/bGu9gmzggW4ckea46ieORW5QKfGSA/12oykL35z2aNKyZq1Y/GRB7Gg
 gj5qaswOSsR/MvDlAvBNnSQFfhyyHYDmSb0SEer0eSgh80i2JCAHYcW8oZM9QNVW3XLd
 MGLTI18+qFSFR03KB6+1Gx97Dyv8FddjHWo= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fb9f3a2nt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 09:29:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlj5Osh1nSdmLXuPc/xfVPUIGRuBZW73ze7d4b+OWkcq216KNPYpVX+pwh7gUJrTxnYzDKbheZNUekzsE23Fgc3/16Ks93YGVxGLOcJOXLanFGWk4+3srDeztHFk16tWIHVSlfy7WWhe4YSrbTfYZB9lD9ntr7JmngLGRQ54pLeTziQPsMs4fvo/MATWlE9gCdh5gIRUCZ+bbQXgIinEZn5cG3G3ut7Lzb2ghnZEgvBF7kfy3UOAqhbvqL+5r3Ijwa56N7hriJoYR33m4j9hRGTh0+AuS9FO2aigwkz9BhLl+WX+/+TI8yiD4rvxMASlIwXy5ZIvOZb6U4hYfIrwrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UUkA9upIWba7doIzjDCbOzo+Idu+hRMgBYpGYLzHMlg=;
 b=ee47Ni8e+oWDTteIOXmvtpgLL2SOYHGArZoGoDB8ty4+lmtx2maL5Q9/C/5Vm8yMFZbq9DEmFZUvQNzbiG9y0t5aby0spEK8FFS3MazDhZQWF74rwLjpMc3A/Mia/RG+GIcgFoTmuVMYVZ7PSTLYzNEDa+d9iUjwwu1ILclLn+H4wwv9j/xbkDqHJGJT7NqxqJUUnYlJiKiZg4ZLKcF9flJ9fKGT5ymO8wIji7X9iZdisJYL6kpY7KBy9fIlAK3aVWuH9fTAEZ+sFMXnjLeCGwWMIdNwvZOt7UMUJAZPcMapPWDHBSRf70OXpF46RpDWM9f1YonGXZk05mGr5pocNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH2PR15MB3576.namprd15.prod.outlook.com (2603:10b6:610:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 16:29:00 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 16:29:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Liu Jian <liujian56@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 1/2] net: Enlarge offset check value from 0xffff to
 INT_MAX in bpf_skb_load_bytes
Thread-Topic: [PATCH bpf 1/2] net: Enlarge offset check value from 0xffff to
 INT_MAX in bpf_skb_load_bytes
Thread-Index: AQHYTaQrW2pUepre4UeZAF4+vFT7Cqzq5zWA
Date:   Mon, 11 Apr 2022 16:29:00 +0000
Message-ID: <34CE6275-8394-4ACD-A914-DFDB51A65EF0@fb.com>
References: <20220411130255.385520-1-liujian56@huawei.com>
 <20220411130255.385520-2-liujian56@huawei.com>
In-Reply-To: <20220411130255.385520-2-liujian56@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e86b6a1-d3a7-48c2-9a97-08da1bd8624e
x-ms-traffictypediagnostic: CH2PR15MB3576:EE_
x-microsoft-antispam-prvs: <CH2PR15MB35761F56C835E7D5FAA14879B3EA9@CH2PR15MB3576.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sac5e2m76jD3PHu4PEelg5Cmf6M1vJXOpp3FTZt+0GxJ7QTFX21f9ErkPoYIjAxc/UJurNe1OJjj1B+AD/1X6DGee6TdzseKVJ16LzI8xCnHwm9615WcXnPsTJrewv9BETaL5+TY6ZvYYHiSXa0amX5Zbs6k+nH5sAJq8ef0tLIvBD0HrmI4ZPFW8paresgGsq3pG3Pmz+2YSX4SuTrcPJHLqEtr/la9fiS7mhzbCk0NpDVDGh++2gueX1xAIko5jngKMmXqVRHFGOjNiKrmQSG0XlcThpFD3bSteowPgGs/fdMn7w5DLkUKrz0VHR0/EjsAEK05VDXderCSH9KqvVKpBr+UK45/+GJ7SFk8L1hlhE0dKZ/lbccO6uepdTDcTxrMpDk7UQArTXuCGLTr1+Yk6UNt1shvLzCOEcMRvxNcAkLF7Olug5KnKNjf534PILMTwA0WmHzqFYFBsDOEBLJJzGUSV7k0dYgSaxqBM+mH0oE/QWnLwNA2areY8rymiqaxFOXgNq3jtiIFkaObK1AF/4yUvPnbIFISxxx4ok+RfM8GpShZTn+6igJpMdFOeV0UScbQtHY2zcfjbAOHHBZRrpw5BBD4oWnzW7yxFUlFRjFjrvynXuK+QOCtw+VeBloGaSyEAc+SIa2UwuZRm+d6sHRnaG59yZJGhIn8rqS29oqTeyNwlUA9ovrKdjd6z0a9ZLSF2o7rImBzI7+OSU52q33uerjjhXTbQvDUT8lSF3QfvTKA9KofbW6o/eCTmRZmQlmKyVopIanVWQpcLVhgEIr1IOLUdxpdGASuZqM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(2906002)(36756003)(33656002)(2616005)(6512007)(53546011)(4744005)(8936002)(86362001)(38100700002)(6486002)(508600001)(71200400001)(122000001)(66556008)(64756008)(8676002)(66446008)(66476007)(186003)(316002)(66946007)(7416002)(76116006)(38070700005)(5660300002)(91956017)(4326008)(54906003)(6916009)(161623001)(147533002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b6daZXJ+bbbPv9LBzhw+CjbdvtzNB2otboh0ZXKIvNZRFcFQoMp+Cv8xVTG8?=
 =?us-ascii?Q?n4yxz6pJs4S2SsYOulYXAe5QvZUKYX5oLsFpGY71VmMg8+O4U2If7FtVaQRD?=
 =?us-ascii?Q?Ja3XsDBQ8oPerkDW6Yt00qxidAchcarmc00GBE1zxRiiQ9iPdCLtrJ4H0X4N?=
 =?us-ascii?Q?q7fbxwTkN8Vk40DKzeEq+oDAHncZ2JU/5F+eBejmn70ZPtCiNVp59WJKjLoV?=
 =?us-ascii?Q?B01J+OfvdJywKsMMqJwaa0QrJF/ech0Y0emJDkCcvrjGzbBPEAa20V3ja/6+?=
 =?us-ascii?Q?U2x79xFH61Tr+TdLXfU13EFk/eurg1NSkBfzFVZo/ZJlh6Sf1YnHbS3Hi9/g?=
 =?us-ascii?Q?xFkK7ykDab48xCx/5Qn4Gi7hGd+eTFs5jMCQATkg7IGFgiANP7llOY1VeeE3?=
 =?us-ascii?Q?LusfLLPc8O5JD6eTHHRwSnW9tMtF+YIMwYcuN79zOZNqVTm4G56wnEmf9Hvl?=
 =?us-ascii?Q?w8NKu0OKj2RvUfQQk3jaWFiZ8mCwuK8PqQh48Xc/14OG1dM1Ed1dyw7syAvU?=
 =?us-ascii?Q?fImEele3CmtkypI9tms7Unjzita4BhHE8+bQBWK1n1tWqmDz/YqKOtjASF44?=
 =?us-ascii?Q?meYqNmVPnkjHdIyRoFx1Ab4Np4V8dyaP5G8F50psWoywAkgg3wIgsAJlYaaz?=
 =?us-ascii?Q?wF2PDVhoDLl4w0d2z6dQiWn16gQP6CMm3L6ECG/dlVGiAaxY18tmX81DCaeN?=
 =?us-ascii?Q?lYfMZ1l3pSSIR5jXAYP8IDoz5En2+A/f/9NTLIOTMF203qoP9Yr4YDMLcsY3?=
 =?us-ascii?Q?b5OxTHZbJKEJcDyqNx7t4F205JsmNhmxvUNapmW37a146t0RVz71pYHDOoJ9?=
 =?us-ascii?Q?c+9iGR5JymLsA+E3rBDPVFgmsjVB5EOIj9UY2btGJQ/+GUvWNDKeXdbJJpDe?=
 =?us-ascii?Q?U8Cl+v9J945Vb0xlFJ/6OHIcTU/nDdsaSsxvYDxxkWcaNAlL/VeBGycampVt?=
 =?us-ascii?Q?rFeTLii6UhUYqLFG1Suh8gy+xf7o++gOLeqQVCsMjShS/LgWrFpjL6qdqAm9?=
 =?us-ascii?Q?IcGhuaGodWp8A/Ezad9yvXvf1cY2rDgXBTMSUXNkZxmG3MC9W/BWxJM02JIv?=
 =?us-ascii?Q?IQ1lAu7wZwRYWH7QUQPk3XC5QdBHa2JMHXFmA/4tJxPO6jjw2hqfZdyE7teK?=
 =?us-ascii?Q?SCqcX3RDEG2AKhvc+LXlUXXOOee5xTYIFPSz+FswSdZd6+QIymkdc7FkdjBB?=
 =?us-ascii?Q?Oenmn7yUfJlGDfwGcNN8LNsadjkxgnZ/v1w8bjIhJwZCAGjO1pxpjGnt8ekP?=
 =?us-ascii?Q?18lHNP2SBRVIM9L6EBj9Ow7Zs0Mk4ShpmEQcmMF4s3MAJ2xh7qLLzETR4hJD?=
 =?us-ascii?Q?Ac+zOzAtZHqgCrhkkK7y+U7OLt4DYuZ6jx7BxV66TRT/gvMQ4fkg4P+Ssba+?=
 =?us-ascii?Q?1CAY0pblAWQ2GURygBsvzXCjYXMRJH54tcJkbafLwjMLFXMU2FDaO6LXzQS8?=
 =?us-ascii?Q?BsojDodgwGre5df77d9Cjuq8Lgp61fjs6ySyLmRSvrz5ZxLvp+sasKCgxxHD?=
 =?us-ascii?Q?hjilhIbKuP82sOC4Bw4G3cFZNwhA9+YfSoEsdyj3I/rxvLZOuG9AO/xiNwEV?=
 =?us-ascii?Q?yt9YcSXWA7rzcsdBurgk8AgLFIVAbYWWMyg4pFP9fuNtBf6eYstiIAANkUhC?=
 =?us-ascii?Q?8eLiKGEhNFEsGdk6p/hRBWqDWfBaUVAdPFgrbYSnAEUHUQdCk91yZ/TijI8d?=
 =?us-ascii?Q?Z+SSR5ya7RJKgSpX8ovdWlIyD51LrYL1gX7jz8U894kgoiAtcwhi8OlIfpq9?=
 =?us-ascii?Q?Z4s6lNPg5Jej+X4dkElus8iOtfY3jlLy5rEszMT+GFbpjG4YKxFd?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <35E59E6AB46A1E42A9FC1EAFD97CC967@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e86b6a1-d3a7-48c2-9a97-08da1bd8624e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 16:29:00.1769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Obj4qn4KJ2P9CV1Qjy9KcFnNBEDKNqDbmZuscmCJKk2fjuJL6oKoT1ePRqHdk7QtTJ1PM/KYOFh09fAld2mVlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3576
X-Proofpoint-GUID: WatwGfJXeQ72-VkD3Vut9qGPiYd_XckP
X-Proofpoint-ORIG-GUID: WatwGfJXeQ72-VkD3Vut9qGPiYd_XckP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_06,2022-04-11_01,2022-02-23_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 11, 2022, at 6:02 AM, Liu Jian <liujian56@huawei.com> wrote:
> 
> The data length of skb frags + frag_list may be greater than 0xffff,
> and skb_header_pointer can not handle negative offset and negative len.
> So here INT_MAX is used to check the validity of offset and len.
> Add the same change to the related function skb_store_bytes.
> 
> Fixes: 05c74e5e53f6 ("bpf: add bpf_skb_load_bytes helper")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Acked-by: Song Liu <songliubraving@fb.com>
