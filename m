Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0824D93AB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbiCOFUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243891AbiCOFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:20:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040FC49268;
        Mon, 14 Mar 2022 22:19:06 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22EMaUia016537;
        Mon, 14 Mar 2022 22:18:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=M1awzgr4kel6jtQGt1Tq7zjSGoUPjiyjh41yOSz1lI8=;
 b=jC4pURNrM2cFKN0aKrTe53CsQVTlb8vtw62WjueUetZm3PO4VxNk7NO1WEp0Jql9SNg/
 X3VOuT6jT8FRbvSEv+vssOGltK4U9Z91jL+Fk1HRswAaRJon9G/u1wUT86J55JDFCCdp
 O8X4kwKjxiZga6N6kbv3jgqcWg0/ju42OaQ= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3et62dehxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 22:18:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nki2naJW7juweJ8stffgaixLM8IKkoG+OeSw6CNun3HFhWs1M1eBuD00PlmT7vkMwNzcgslWD9zpQAo2xAjfHf52jnRlOw/Rg4Rmj9Xh1xfbBwoXvWY+JBJ3WMoQYH2fAvloniqBJF+myXqYvru2qXkev7pUKWLp1EpYoCCRyaoLgsgeYYvtr67Qza57l7hh1ua4rwqYi+nwE849KAHl3xrgXwJbjYoeoWcHFrpBq/OKbql7BwCROa+TrLUHDeapG4J4glHMW68ubdzWOmHQuwKLU6bscKP5+cpvW7sjNW4nKBpPQmQy0UiyY9aJswX+BwxP/CR96kDdc17tWOXidw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1awzgr4kel6jtQGt1Tq7zjSGoUPjiyjh41yOSz1lI8=;
 b=KfkgXHwwTBCpFpzL3UwZiDOONQgawy0HJyc8l1ABOwjoVThNDgPrOF34WEqTvHsznP+8S/ZGvk/biVbiC5AX0XFmaByOcR5gvKhhrXwepH/J9LZew++Ywrrm6KQVh9UhyjB9BVMZ6q3dLNXsR+Uug794lY1JwpY6YssS8qi67u9u+UFt10LpMVe+9ezvbAMvV4yvmwyjcfJFn+Ne6Optfm3ftAN0uR+cqtah0EJq1w1bX6supsXWMRTZ1sfd9R435ddqVSvkTcGFwcQ6YMzB3bqCl1cx9x3I5Y30DVAEDXlFjSSWJGqSR7j3TpzNfrSQNXCEJ8tjaQu8HjHcA0Zt3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1689.namprd15.prod.outlook.com (2603:10b6:3:121::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Tue, 15 Mar
 2022 05:18:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48%4]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 05:18:40 +0000
Message-ID: <e520afcd-795a-047b-2bf1-83e791433717@fb.com>
Date:   Mon, 14 Mar 2022 22:18:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 2/2] bpf/selftests: Test skipping stacktrace
Content-Language: en-US
To:     Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
References: <20220314182042.71025-1-namhyung@kernel.org>
 <20220314182042.71025-2-namhyung@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220314182042.71025-2-namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:303:86::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b5a70dc-0d00-40c1-351f-08da06434417
X-MS-TrafficTypeDiagnostic: DM5PR15MB1689:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1689091ACE6C00B6D89C1C3CD3109@DM5PR15MB1689.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GcNBkiNimVGVC8yKT4YvGliIJjHAy1BRYj6F7TzEpGLuJ/47gbak/01adFU0fXUS6HJv4ejqIK90c99YKtsFUdn0orPNG3soRgVSPOANQxivLT6zQTfO6pueVUJlno7jQw1kF8KaDjkBrEYEqZw2za15U7+c6CJ2hgC/8BT4NmUzuCVYPQZibhG6Cl8dumBQarCAZHasR7srL8+o5HyWQl1lIA9aATREmlXEVVaqmpPbNe8Btl8cxlUyPsjNWieRtVh7M1hy+lb7eFzzYsRY9xObrNZhFiF/PNsBO67HZDDwXB9eiYgjGvnu0vlh0awTzbBp4uxAVK+vyZmGvyGJO+zliX6e9jP4qA6Arjk3ToiomYncnonsFHuRKKF795Y2fFeUvep+tMwpOcqVmp+LzF6ys+2ILT4xw/mm418iNcxGT6xHOYGhbEBB2+mRXX5N/Nd3m5sdzPaKf4WL9bAW9zLYBtTareR9GNUcp6hGKDgcsCGvALDqJw6ZHxb+2zSPSDuiA4N+9SDSDosNJHEE0xRq4hPQlXmQ1oZ032t1LBKO2rtfcDqdgQ9Iedp9Pn685++UAVjUKWDidlbnaN8Xumk+e28an33yXOdFMNyeaCo16g2lwdTJ9OArOR3rHRpb9lbX9SSp6V7Q5cS5ZI/baBYhqgaIWB9qzOtZOeSEPqtofdc4lIAYC9nTd+ujsPoeHlpsIz7Y3MZXZ/Aj+MQwRWB1vul4w5HsUMk5g+K1z4Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(54906003)(6486002)(36756003)(4326008)(52116002)(6666004)(6512007)(53546011)(5660300002)(8676002)(86362001)(6506007)(316002)(31696002)(2906002)(8936002)(66556008)(186003)(7416002)(66946007)(66476007)(4744005)(2616005)(38100700002)(110136005)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHVTWEl1MFVLSFRrTmFaRmprZitjZjZnbGVpWnFEdmxOZWhYVnZIdmRlUGtM?=
 =?utf-8?B?alZNc0V1bU5EU1dNcmphbFk5WmQrYkdobXFsOVd4ZW5yUWtybWhvVjE4SmNw?=
 =?utf-8?B?a0VIY2xRNlVRSXZXOVFKWGdhUS91UllNOGhXbE1JdHB4UmU2UTNieHYwOS9j?=
 =?utf-8?B?VTNQWnVoR1BySkZvUTIra1lCMGdMVThYbko2MmNNT1lyVGE2NFM2dTFtR2xV?=
 =?utf-8?B?ZXp2dDRYaHZxL1NqRlpUekxGSk96OHRqWEhzc2hqZ0pEbjFDSTI4UnZ0NUNn?=
 =?utf-8?B?OUJMaFJ3b01JdkVWRXdMTGNGd1R2Z3VxYUZwMGZZZ1daeFZaTVdZYWVYck5z?=
 =?utf-8?B?TDdLeWZEc1dVSlRTaDMrZ1hnTXRUczJzZ3BENlVQMStOOGdCZlZxS3JBb0Fw?=
 =?utf-8?B?TGdNbEg1UWRjai9yVWRyc2Z2S2hIZlNPRm9sVzZ5cmhaNktBR25lR2MyZEN4?=
 =?utf-8?B?NTNYdTBxV2RrekpWdkxtSVVjMjdXOXMzYmF2cmJDMXRaS1ZqY1NUMTdyc1Yz?=
 =?utf-8?B?UFhYQTdnNmNXUEpZaE1hbXl0eVJ6T1JoTU1HSnBRbW9wNFlvSFhvL0EvYnoy?=
 =?utf-8?B?cXZqRkJQK0tjNytiNnB6dGNSenkwbGNpWnZpUVFLdXNPZGFTSll0cld5aDRa?=
 =?utf-8?B?S2d4ZklsaG5vS2NVOG5sRmJNY056cWhWdGV0b0hoK2k4S0JkVzBDc3VrSUFC?=
 =?utf-8?B?T3R5eGxhZmwxOW81cDZtdGMzbUkrTExnZklLWlBBSGlYbitUL21FQkFSeTd1?=
 =?utf-8?B?a3dJalljcXVqVmIyTU5velhFT0M4R1pBUU90WXRWWUFUSDYvME1odUZIbVRk?=
 =?utf-8?B?WmlRcjM5UlRxdlh2aEV0SEQ2YitSeXN6TExYYUUrODFzUndBWnhPdTFoTGFj?=
 =?utf-8?B?M09sbXMxWWxDNEFxN0lBWXk0NFhUaFZFZHFXQXlsL0ZKa2hjQ3NYMWUyQ0Nt?=
 =?utf-8?B?SjRBa3pZcmxjb1orN25BU1pTTTJBREJNaUoyaEN5SEcvdzRZQlpjb3VCQWxz?=
 =?utf-8?B?V3dEVkF0TUM2ZTZOMjRyR0cwMkJGTEM3MHoxMEJZK3BhQUMvdXdId1lZT0Rj?=
 =?utf-8?B?R2ovbU5LQjRJVC96VC9VT2pSWU5EaTJ0ckF3ZHI0Vmx5R052OG1qRU9FOUpM?=
 =?utf-8?B?VDF1M1Z2ZnB4S25JTVdRUnV1dUtlRGUyYUxoa3RtaGVvTDlES0RNM243Qkxl?=
 =?utf-8?B?U0lSSEIxT0ZsdGU3RDBkK0ttM1Jtd2d5NGhUNXJ5RXRyQy9NT1ZhKzlnNUxS?=
 =?utf-8?B?YUZpcmNzaHFJVUVnbVJFNk1hUzRDamlQMDd1NlZMaTVnenpTWXkzTTdRejgy?=
 =?utf-8?B?SG02R2xmUEZwbjA5Z1BtakRKakRDRmhkSEwzZFU3U3dGa1M3MXo5ZmhxWGQ2?=
 =?utf-8?B?dmFjRDFUWXExOWVuS0VJNllXVTlaV2NPNjdnT2cxTXRrcDhMNnNoQWtaNmQy?=
 =?utf-8?B?YTJsWWRWTEFVNTlLSkFNb1ZYM2R0bE4zZFVHaFhiUklqTG0vTG1ub3JFdDZK?=
 =?utf-8?B?cVRCa2FrdkhtNFYwTU1SU1BON1VmYWcvK3BDMUo0V0ZkLzMvd1dHd3NmbVBj?=
 =?utf-8?B?eWlKYS9YYTM3SzU0bnF2QjlXZlFOWmpmdVEyV0R4a2Q2SVhoT2R1VGxDYU5R?=
 =?utf-8?B?K3I4MXl4a3BqTUI3NDZYV2pvZWQ3d2VWTjgwSEozWDI0eEdlUFBtekhjWktn?=
 =?utf-8?B?QWpaWGN4Rnp6alZOYWd6MCtFSGRnSXliMjBWNjNrQ3JlbUVWR0hLbkFOMVV5?=
 =?utf-8?B?Y3ZGaThVZmVmSUx6SUl3L0xtNTdyNDlIL3JhczBBYTY3VW5sL29CMCt2c2lz?=
 =?utf-8?B?eTl5d3V4N1UwdUgxaHQzTi82YjQrUDVlSmY0OGFSdDMrRWRQcXU5Zk9xbTEz?=
 =?utf-8?B?RnhTdGs4YVNNSXV2UFJReXBwVHJxSVErTVRNK3M1SUVmcWNFUnMxc0N1cDhZ?=
 =?utf-8?B?Y3IxV0xpWElUbGkzQ200MkUwZXhzc2dzS21YT3pLSkcrTk9iSmVya1lKK0R2?=
 =?utf-8?B?Z1BDU1gvQ3lnPT0=?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5a70dc-0d00-40c1-351f-08da06434417
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 05:18:40.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otI+/QzMH7b8VMOhHeC+5eq5atjh4uwBy0WbR1dMd1lwT2c7aEl80Qx3T2aFhSna
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1689
X-Proofpoint-ORIG-GUID: J6jv_3AVf2Y0E8W1a0Sx7wOD7GOn7wwM
X-Proofpoint-GUID: J6jv_3AVf2Y0E8W1a0Sx7wOD7GOn7wwM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/14/22 11:20 AM, Namhyung Kim wrote:
> Add a test case for stacktrace with skip > 0 using a small sized
> buffer.  It didn't support skipping entries greater than or equal to
> the size of buffer and filled the skipped part with 0.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
