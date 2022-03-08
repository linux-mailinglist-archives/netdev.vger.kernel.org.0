Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A374D0DE6
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 03:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344331AbiCHCN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 21:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242445AbiCHCN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 21:13:27 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688DF63FA;
        Mon,  7 Mar 2022 18:12:30 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 227KeDbC020323;
        Mon, 7 Mar 2022 18:12:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=qz4/HuiQR/PUFaxFy1OvIhaailnewisHNQ3yWcSfMes=;
 b=Fs/2AeWwTaSwPWEOskquAsZzb3Bl5hQRz2yjF7XEOZiW42H8nyuyIhwvIpiTURzM3E+a
 z7ViVyZpInZ1XvQhmTmwCMmlgvL2fDHi+E85gjpwrtBBnbpyB8zwArPMcHPLbCn3DSeK
 WwHsv4dlaHX7BijkgL2tSYtHW7aiZNUR4Jg= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3em6esf315-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 18:12:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giw8facPJ4CbCaDmoUq+v05SCE8KPKAu938/3FHjEsLK53zOKk9L6/xJ+7Z/JOpHG7FWTMj0gwxceY7pwoln97R79UwzrjEHkhe+2J2yC24A+iYanpGrXT+Cw9cHMW1yz3pxFSSiKFZ8fMnFKrs4i0YyVLlKVmuYvzV6sQcMD8Dp7iexxxuDcuvHHPJpovsbPGS1ZY0sjcmvwi2pfnKY/HJ7BN8dB4wiwERdL0Znf6RTpSrErEHEY/kGtFRhmOwGxu26HRCMH8Ru72uCvhLyVR4zXz8LOj16HAe8YaEysn1yblXBJaYPpIevWBAAkxT2SdZmCGbwCVX3/DEzRUpCmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mehqRYRTSakZBUub8Cs+N6xBvAhUDFNoDniqH/V/scI=;
 b=i/4aSn/E0xF1CqRTZb51wYLwNxGB23iF1be7pkkespBFKPSxnRVuP29spCpMftYEtSheF7zt0ah/g7RZvTDB4WwHIJRBe/lypIFxvLm7Qfh8IisAmbpQmC6OUrw9yz6vIonBKI43cwKDRM/4yLq0vGmckEemM0hbbQbvnS5ZpoI4wlSbO/LImN+M/orKAVtja8xGbfM1h6IwOy6rGa7xZ3LLmrJRhh4xqDsCr1HeW7Lh54LJDDMyZd4zQLYjslth1EaO5Unsr447ui83D5cKeRCBv6JJ7u74F083XLx2zPHyeluc8LmUV9chGZTBscSzqxc8B3Ga0jLNsLuytGN/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SJ0PR15MB5279.namprd15.prod.outlook.com (2603:10b6:a03:42e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.23; Tue, 8 Mar
 2022 02:12:12 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 02:12:12 +0000
Date:   Mon, 7 Mar 2022 18:12:08 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 3/5] libbpf: Support batch_size option to
 bpf_prog_test_run
Message-ID: <20220308021208.nuqlw5ebhhynyhyc@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-4-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220306223404.60170-4-toke@redhat.com>
X-ClientProxiedBy: MW4PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:303:b5::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8aa4281-25d6-4f9c-a099-08da00a90ecb
X-MS-TrafficTypeDiagnostic: SJ0PR15MB5279:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB52795C8CFECD49318797B8D9D5099@SJ0PR15MB5279.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l/I/hNj6BEswfqgkLlwA1e8AdtBQAKiF3U7UKc9Alz4beToV6I5RpDGioaDFU688l3CWDSUTk8gt8mh5JVac2YuvMLzOfN6abu7VKx72mYQDaqZH4y0OtCNLvxERghU34GAv/Cwgyd/vSZ1w6Spw1lVMlOtVLiQotsRWcyxa3W52pc7g70XvHuhi2mMUkSFCgeZsf+M3MARVtwn/6dxmw+8exLg7gfj7eG649971ZNihnOKhC9qoOATgj1WD5YL0wqRpA/8YVHNBmMVa8HY1BvAq3TMXPj+78tk73/xdldyJ7X3VIq1D5moUqramHazXNbVPr3KeJ/ybk0fHSd99MOizL5HL3PblD0Q2z+3adnfO8uAsujncUzsMQt+wUVawkyFYd6w9iSVpsSYC3xhgsQ4TXjQn4ROzZxkbouwoHVCp0cCAG7lrcjCvfofX+7Ivs+FxhrxZahlDpR3VGRQ9MxRxuIXwyxUEud+feFl/5JnNfEKXuscnxsVjk1udJCDHLuwSYrPOQmYRLGRTvpqwp3Zzx4KrLOv98krO7KX5etRMvpKxBu5D8E0aPVOoaDeI6qYqrwNB8DeI/zXSkGEGetT57WidheiFbGD8hA+VqfXZLb2MWLgdi+Gg0KF5t0heclXnexvcSuZCZscAGQEhHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(54906003)(66476007)(66556008)(86362001)(38100700002)(186003)(316002)(8676002)(4326008)(6916009)(5660300002)(508600001)(6506007)(6512007)(52116002)(6666004)(9686003)(1076003)(6486002)(2906002)(8936002)(558084003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?55FBe3chUgZ1g+kwIO07meFCYkJoTGxIBoj/YwjN8u5Pl/+N8xz2C0aIGs?=
 =?iso-8859-1?Q?3+/26v5ES3BCHA73c0+Cy3LqOztnykwLGyHSLF8ptfkWsJdUp9LyxjaYLr?=
 =?iso-8859-1?Q?6gt1QoIr39VuQyV3t85yVydQsob8p3kR9IDII3MzP54rU4EHdCGUdAAJyC?=
 =?iso-8859-1?Q?kSfJq7zzdmdeV4gW37pxS0fGGkMHAl8ZUg0LM3l7jz8apC19LUR7oVKcCh?=
 =?iso-8859-1?Q?fXc+A6MazVD5UDQXg74RzVQJ+xj4LkYO4gfRf0QBbS8YNo87FWAZ2mox9m?=
 =?iso-8859-1?Q?w5ClNGtNAFobUvOfz3PjXl9dj1JFRMYmCHUDEhAAp5yLA5rkQYE1aVuVsf?=
 =?iso-8859-1?Q?Ag6viDDeH2axY4S+DuOCnABR8quyZknLDFKIJyMBVUEvQW8W3Dwi5QvY04?=
 =?iso-8859-1?Q?3syIEgyfclUToDOkvvmEVkoXfM0iuiR5jqEWj7+wGBvKfwYDKKAL5RRHrl?=
 =?iso-8859-1?Q?u9Xm1J06A3AvxzqRwVwK196oqmKEKD1J1LetsApcujUSL9fjt3qxK+fCAX?=
 =?iso-8859-1?Q?mlMry3fRSQ8Un2YgyNQI3pVzcqZCz5KrFDmMD6MQr2u0PR32ez1SmL2KpZ?=
 =?iso-8859-1?Q?2a9pm/Mw+gc4MUCgH7eiW/ydKUl+iZexJPRzJVXAmOixazvoerSC0hum9Z?=
 =?iso-8859-1?Q?FDANeOTQkBp9qPivf60ejozreuF/N9BZB2sf8YClxqwHMWAPdByheTE0TL?=
 =?iso-8859-1?Q?jNrmjC6uO/MJseFLxCgCPY7tFKnClDBvhd0Metd5UsTrlAk4eeMUnyWzf1?=
 =?iso-8859-1?Q?Nah8Y5bXN018cYACv/TBbNOUhsJ64ioI5sQcxx32RE9TbnU4SdyNanw+8G?=
 =?iso-8859-1?Q?+ON0cQCzvj638qEP7dMd6D2UqWYm85t92yea1iYY8Bay0s0Dr0pp/A0g1H?=
 =?iso-8859-1?Q?IjF1SkywR7aRwmKRELUTyq8FMg7YVYrKI/Dve0YLzTtbtiRU2r5Iwq/VgC?=
 =?iso-8859-1?Q?uBjkRY+Je9NET/LUaJb0xxO0TT1n2VSNxsNVA5Yaa6AInsIFOAzraMIfkS?=
 =?iso-8859-1?Q?sGFYd5llGGSfOFdeMhd/LH6+APY7emBSagqRZNEJ8CbVAGiYm0Y9jkJSo5?=
 =?iso-8859-1?Q?UeKo6ufhTVBIXOh54iRYSzKPDb+v52VGQa7RgjnTzR2gcC+qzBbhGG6Lbm?=
 =?iso-8859-1?Q?+Ehn3itTAA43Oz3SZvTJdtEydal7cBDrnaSd8MQln8NdAyKKo/Un0vRG91?=
 =?iso-8859-1?Q?2NwI3wV/SQl4yHRR0yVAcm9GdxBaHI4EeKNU8PWCCbkyVpNtRdO1X1LnDr?=
 =?iso-8859-1?Q?rYwQU0HnoQ0GebVhFI2BF/HesYfwubap5SK0jNfP4Y9oyY9vCcUZadW113?=
 =?iso-8859-1?Q?O4wtvgqcSKA7jiwKuyPlOV5DATNkUX6GqUEpZdswVB9U+IhphVQSPwqXJm?=
 =?iso-8859-1?Q?zdrbPsAuTZm4RbwxBc2y8kjIIV16HWFV63aAHEliznC9dU0orkIyF8ftGY?=
 =?iso-8859-1?Q?FY3lHPR0uRJMLnSOknT9aEcu3Il6FdkjvJhKXka9ZxxIkQZAVHg4mHjfbc?=
 =?iso-8859-1?Q?ZIGhUtdMp0zcgoOYbBu0AfiFU+2PZJjtRG8ZhNXxehkcQtkXAC8Y4EKxxn?=
 =?iso-8859-1?Q?9pP7X4p5zomVJjCXDbjQicCoWRyziL95LzjQfITFuZ2rtIdJHBbyvgie5a?=
 =?iso-8859-1?Q?MAGyLBBys7/pfcmacjdeWtHAd9XVvRFFQdrETL0iN9ms9HN0j8jrloZg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8aa4281-25d6-4f9c-a099-08da00a90ecb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 02:12:12.5306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6gWWpubagkJVsfTV1wodSQ7NyhFHQ7hFQ4FVme8cSm+70Z2x8xA0+ChLIE7RE+e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5279
X-Proofpoint-ORIG-GUID: pPgO_c8lXKV6-BYDwnEBdO4Lei2823C5
X-Proofpoint-GUID: pPgO_c8lXKV6-BYDwnEBdO4Lei2823C5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_12,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 11:34:02PM +0100, Toke Høiland-Jørgensen wrote:
> Add support for setting the new batch_size parameter to BPF_PROG_TEST_RUN
> to libbpf; just add it as an option and pass it through to the kernel.
Acked-by: Martin KaFai Lau <kafai@fb.com>
