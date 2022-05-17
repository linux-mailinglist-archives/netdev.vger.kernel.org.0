Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B405297C2
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 05:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiEQDPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 23:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiEQDPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 23:15:32 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05343F310;
        Mon, 16 May 2022 20:15:31 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIWxjJ015918;
        Mon, 16 May 2022 20:15:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZDGatu0AAc2Zxb6s8wIjbWVEPqxsipbIToz9KFHYLG8=;
 b=YBelr3p/OTY0AvvmkCf+nCGKhdHmWkGDpK9E/3DcxfHQZkSFj65sOzxGPgJWx4GpDNi7
 VnereHhhUn6BaSLx6ShX/TtDVxZd2l3y5P76rWn9+rX6WYbpzGfZTmtjD3LIK5gS5lu5
 x0crKsKqldfyy/1vayMRqpbxiF+8YKY3RWM= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g28fkepw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 20:15:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkIYo0V1t9/rMFedgGOrYSNhn2jqzx0YGqXeTWxkZtLXyuIzL9IP9UMirKMAf6znVN9bVeDw+upDWoiQKgSzV42y4dHGjkL2I2jWI+KtQk5imBRrPUnA3xSi3CXejLu+2SDt38YMh03vMruBjnKG1id2sP2111iDith9eH6+oYvfHilc8wUdki6Zt2mwiSiTpH06Z8NSgK77avS38YNZYSHHKjUOyW+MgbfzEKGkB3y1VvmTVrGph/EpXwSI5L270B7TZKU+pgQJyn1qD+TU1GbCuA/PgqYsJlU9ySgrWJ9VBDqMWDAxlsk1Yk2xQKGR8FN98/yMbpx+1ecykcpsaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDGatu0AAc2Zxb6s8wIjbWVEPqxsipbIToz9KFHYLG8=;
 b=CZTjewCrWT2Ww2mK0+07evEd3vyIefpLcAcoub9hYGEo4+ks6V+aBj+3qxMP2vabSp3OfY584PdQufOkqxpyWDnSsmjI2zwKx699S2r08wPjW0W0OI8a6NHjoChIKkeUs064/xo2pc9ijLBh+Fi+m/jFoFkEJtHobVRX2YgXUw0O0SN99bveKP4n/Q6E9Z6eq3jHqsYP7z5U8ucq/slsyZyHAb9eDuz4QUW6runhRfj+tZLIvxYmme/2iSl4lhdo9FNwN2VBsj3uWBrGJ7MgNsyNFFhDiKPUBVz3Czxzl3Mc2c9/5DVMh63jmIzGYHaDgPIBzCsOHmWZp3IViDCgFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 03:15:09 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 03:15:09 +0000
Message-ID: <b04f63f7-e443-c363-d856-fd558a30a107@fb.com>
Date:   Mon, 16 May 2022 20:15:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCHv3 bpf-next] selftests/bpf: add missed ima_setup.sh in
 Makefile
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20220516040020.653291-1-liuhangbin@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220516040020.653291-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e90dcd0-dd27-4858-9372-08da37b372ab
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB3192FDE906595DFD9053C083D3CE9@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: twkuZFxL/1CkjExvdu3dt6DWLWGBwNcMFCLqWCNHPlLwoICznPvj3vqLgs6LNwklu9wsAAe2cBBZ4CHXCMvsDzsRdBeWHHuSLLK7xAtEbK5QBktSNBd1jWjz2yzJRLs3rJpa1e0/YujuXcNdpms/K9+puM8TimMn0vN8bHfYrng+lU/E9/c1H+nEoXksPyNsI0LnlkbG9m6kkOgXIdpPdSMFPkgaZ+Y5G5NiKbUzZ7/jZRDxeR6eI4setJ4jugr3CD+2wMfUbdROAasrpoQdhDAmaHpJnn2IZsXNVSDACqfpnoFzD5JXMklDqwwXc2yJJGrotxksb5awORpQoGe8EQjk5v1jpL2iG+5T6NftaEOP2sb0PbTh49M8j0yJIPbBx8uCYImnrW6o+Q+eMIgw3IQnMMDcgPSu6odjPpqOO/d+wVBjKOwWEAk6+0b+DF9sspC431nI47X5i6zaZpUTqU551uFdPxZcgQyHxZD3a9pHfORha+gyZ1qQIfQbgOE+x8ENNCjh+jvcp33EYXcLIdHHK63ma3IBEkUEuhTpEz5jOi1hiRRPk3oH1fZ6UkANAfkbiU1wKN8cJzORTE0dkuWkXmHDjBVkrosLzXe5LeYau/dolVuChXA+F4eWrt9hj2WS+b42dubjfj681Utu9VitLwss1uukUupDsoSpnrlGRICwWTRsVLWBvtt6LRJ4KGCcoYhRI1uI1Tfn02xfUs23D5OwpF4Us2JOf0SH6N4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(7416002)(5660300002)(8936002)(4744005)(4326008)(8676002)(66476007)(66556008)(66946007)(86362001)(31696002)(6486002)(6506007)(53546011)(36756003)(2616005)(2906002)(54906003)(186003)(6666004)(38100700002)(52116002)(6512007)(31686004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U05Xd0JUR3Q3V2JmZEpSSXVFdzhhTVI3bUoycGVoRDdRcjlPRDJ6K1VJS2xP?=
 =?utf-8?B?dG1UZnEwd1RybytvSzhibWVRakYzUmZPVWl5OWNSRWFCT3JNNDcxdnpMUFl0?=
 =?utf-8?B?Vmh2dDBndVFiVVdBVzNnREdZbWJlSkgwcGJMMk1pMVlFRUtRMVdCV00xRThx?=
 =?utf-8?B?MDd4YWU3WjRKUys4SWFvNnJOMkVaSjBDQVJiNFNJSGZkOTBsZG1zbElQU1Vu?=
 =?utf-8?B?dVZ2YTJRRjVieHlzdXlzRlNQR1FqRERWd09Yb3N2TTUwL1o5R0JnQ1k4S1l4?=
 =?utf-8?B?OXNmNEx5bWN0KzBIUEYrTnpsTjdoQldMbndiRTIzOXBuVEJUZ1FDMTV0ajd3?=
 =?utf-8?B?SUFnTnNnMjF6TklYZ1NHZEFoWExCSnRFeVIzbHMzMGVuYWNLLzk0SFRuenVF?=
 =?utf-8?B?eTlPMTI5b3JrbWxZWkhWWndWTmpvTEFzVDRCMC9mRkh0VEVNWWJFdERZL1hz?=
 =?utf-8?B?cDJLV1pyQUxqdm0vaExpKzFzL0ZoczNhS0RGbHpCOUMxOGp4cWFDcnhJMHA4?=
 =?utf-8?B?WHlhZXoxVWZyWlluRkFGWUovWk9CVWFGSTZpMjN1OVkwbG1YdWwrSyszMkRQ?=
 =?utf-8?B?cENXSGVYem03bkVoZTNhTnZWaEZQMjdUZTF6Q21XTlZERWdrbDM3eEtoVDNo?=
 =?utf-8?B?c2M2Z2tiL08ySGtSeE9QME5zcjdURmdPVTlYS3dGcGg1WlRnZ0hBNkVJUWRF?=
 =?utf-8?B?REppWm52WU9JY1VDU2MvY01MVzFaSVVQR1JvOTB5Ukx4Y3h0SU5idnV2aExP?=
 =?utf-8?B?SStnUm1UZ1lIUXVJa0FHaXJRdDY1Z3h2NEFEbkpTY05CNERTeXVRUlMyRlRr?=
 =?utf-8?B?ZGZ4eFBQZnpPV2VLNUwvU3EzTEdSSXE3cEpqaTJ3ZXVINzRjTG05VkZuYnVx?=
 =?utf-8?B?bis4ME1GMDVmRmxhMkswVlBtQW5HUlJZZjJ4Zy83ZXI0bjB4Vm10N1o3S0Ew?=
 =?utf-8?B?VnN6bEpIR01OS2ZMdEZvZTJndk4rdC9sR2grZzJOS05JRGRuQmJGUDN6YWZU?=
 =?utf-8?B?Wkc2ZXJ2VjUwbWw0REJKTEYwQytYTlNkY3VCeEY1cFFweGRMYVJZTFE4WENX?=
 =?utf-8?B?L2VQLy8wRG84K3lnN01zVzNjQWdSVnRKS1NQM2xncStwMjM0VTFzRXBjdFhB?=
 =?utf-8?B?SVVYWjNzNkpzUCswUzhCMVFOeWtzNUd3RkFYL0d6b0laNHNXdkpJYVQ4S0dG?=
 =?utf-8?B?dGhLL01lditwL1Nha2dhVDR0bEdCZjZ5QVFvT3RvUWxkMVpKMzdSOXIvZHVV?=
 =?utf-8?B?WmNOTmJIU3dxeG5kNlJWbi9kb285VzJnTWJjVWJZRWJqNy9wdys2cml2VTBj?=
 =?utf-8?B?QkRDYW1YaHhnbE5UUnlpL1VBODcyM2wydE9MSy9iK2wrSUxzZHo2eENzeXRj?=
 =?utf-8?B?bzY2WGZNNlVESGtCN2N4cXlsQVlzenRPVTA0dkJVTGxaVmU0aUcrbEZLaURM?=
 =?utf-8?B?RjNwMklHOHhwQld0T0orRC85UFo3RUZjZU1mcEtoKzQyVkcwN3Q5cnhKSVph?=
 =?utf-8?B?K2RwMFJjZTBJODhaZFcrMHB6TnZ2K0xVWDNuWURraE1SNmVGUHg0cnlsYmdn?=
 =?utf-8?B?M0ZVakpRSzNPMFgyR2FCVW4wTzJsZWlmcmgwc2NsQXdIenBtOXJyM2FKdTBz?=
 =?utf-8?B?dnJ3c3JRYWlFSWs4SGxyV2pmZ2hVMitxdkVOeXF1U0E1Vmg3akhKTTd2YW5k?=
 =?utf-8?B?TGFDWWh1Vm8wdHFheVprWElUOVdkUEdlNFZuZzVwWnhWN2JCUEQ1UnhKSnhk?=
 =?utf-8?B?ZjdmMDlxc3B6bG9lVWlEaWJ6SnNIREFwcnZGbFVvTlNwdTV3emN0NitWV05K?=
 =?utf-8?B?RGhHY0tENnY5UExNTENpalhTaHJHU0xackVmOGFNZENhU2k0bVczckwxditu?=
 =?utf-8?B?Y3hjSlpxRmZ4NDc4QU1ETjRMNmFkeDF2MW9FRGFJeWVZeHdZWERxZFY4c2JG?=
 =?utf-8?B?ZllTYlBBSXVQcXptWkFMeFVPMnNFTnc0U1pYNmlXZ0x3N21uaWp6M1pmbkRB?=
 =?utf-8?B?ejBkT3FRdHJYV1J1Q294SW1EYnhMYm9XVHJ6c1BpSmJnNUNabEQzY1ljUmg2?=
 =?utf-8?B?N3Iyekl1V1N0YnVVbmdZS3hJQ0UweVB3L3RqUTFpdnJSQUtyb0VkRExGMnlD?=
 =?utf-8?B?bjlOd2xOOEZ1bzRLRVdnSFg5NHhTT0NJcCtOZm1CUEJXdU45enhUZW40WVNX?=
 =?utf-8?B?RXBRd3JNaDcxdnlGUW9iQ3lXVWdYUFg4eENrd29rVThYMm1UWW5XVmovUm5o?=
 =?utf-8?B?NS9rdHdPeU54dTg4dTdQVExtQzZMU2UwdXdxdTcxbytLNVVYYjZ2RTNLTTc4?=
 =?utf-8?B?WnZmMC9MNXF6TmR6b3Q2Nm1QcStrYmpTL2tlUDNTM0FLOXRJMUZqU3Jmemtl?=
 =?utf-8?Q?gZUdAs0f6MSAbh1Y=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e90dcd0-dd27-4858-9372-08da37b372ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 03:15:08.9960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmTJJlBK2gd1VmSDzyB0Kh5lrD80NrMTgeIKG5MiAPfxlPm72Y8QWAEwOtKFAvnp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-Proofpoint-ORIG-GUID: EsfcmoeRt9DFq4pw5AujX4jnSyZq-hR1
X-Proofpoint-GUID: EsfcmoeRt9DFq4pw5AujX4jnSyZq-hR1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/22 9:00 PM, Hangbin Liu wrote:
> When build bpf test and install it to another folder, e.g.
> 
>    make -j10 install -C tools/testing/selftests/ TARGETS="bpf" \
> 	SKIP_TARGETS="" INSTALL_PATH=/tmp/kselftests
> 
> The ima_setup.sh is missed in target folder, which makes test_ima failed.
> 
> Fix it by adding ima_setup.sh to TEST_PROGS_EXTENDED.
> 
> Fixes: 34b82d3ac105 ("bpf: Add a selftest for bpf_ima_inode_hash")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
