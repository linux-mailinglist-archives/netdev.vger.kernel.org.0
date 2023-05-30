Return-Path: <netdev+bounces-6484-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D01C571686D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84CB528122B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E82B2721E;
	Tue, 30 May 2023 16:01:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D8917AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:01:28 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DF7113;
	Tue, 30 May 2023 09:01:23 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UE44YP002515;
	Tue, 30 May 2023 16:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Z9dAWeXey5k2g7fk467jgHOt+40YfVaea+33ukz1+GE=;
 b=RyoTbEIug+UXEZK/RzOG8+fyvsTo9H1+Qc8kPQ3XKi8nrzZAjrNWx1l9Pb6dpT0KBq2j
 7XXDkt3VT7aAVNn6yvhR0eUJiaBf9sFtm/UoeZR/K8TSdeSJAfq2S8jZ0CZtgGimVoPI
 w5eGRG1XcZn7tdssfDoTpHeM0vJanz81Ixa/SSou0YOXxF+cqaHpcDb1FMTsBLPswOm1
 ODrrUtuk5DGZSO/+cZ1/1N5oCjG/U7woXGJTbQDFcg747/VCJigd5v8pAkjC7gV3nY85
 tUBEojm+fF7bWaqLadw9UtCpGZsr3uiAcSp7t3IQWnXMl2u9KgJxkw7JzJBScnFIkSxT dQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhd9u77c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 16:01:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UEblJC019734;
	Tue, 30 May 2023 16:01:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a4b1na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 16:01:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LvU47XtwZe3Z+60Lw0MKz1la2Q7zRish+N7rdwrPT2Rphc4hNavWBO2kE5ToK7qJoaglUKjh+oi9AhptRcM5tJloxOmlXhCB6XzRcmPGmnGEra3EdCY0yGItXYlNm75WNBE82MPjlmgSsgJS2fkbqUfXc5gDqfoBh1wH99fVqDEMqMV3iGxBI41zqEESpeby9kaSYTCmKEgFAwcBZQAhAfB2qo5lrJohJcAE97s9Wyqd4uOuuKIeF0B1T6kCGiHwC7LRY0w9JImN8/Kt/TMl4/t0J4AY0s7mRqx8Eepg/gDDxek85ghnbQbV+y0+E3S1eDC6c6fLGKLyC0C06oIq3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9dAWeXey5k2g7fk467jgHOt+40YfVaea+33ukz1+GE=;
 b=UQLJ+RguSDowI3Ikm9Bt+1UoLZIn2V+6sg8H2G4u4yH0qnOEp9sEI6S6za9/5zpzQJlDm4TyMTZGrODgZ94STarzcn0vaDK0Z8LhnhErHAe+cr7vVypJYxqpbuHrRgp+4jkhRLIPqoqNkYoigVDbbvhmj1/WhdVqTYLLK/VKKFwT2tiq8OsM26yS2eovi4a5os5OKcU67yAE6GF882DoovZhxNa8jGBg2SThd26ZqoxIKZ7N58998o3xiT3G4sAevJuO0bF4p26k/T86dEHKu7cUn6RcdTix32rGbd7Xuw5aeKaAd61lOGInWPneh8qR8qic9qqEgrC4+4DR+ENkkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9dAWeXey5k2g7fk467jgHOt+40YfVaea+33ukz1+GE=;
 b=CDTxh0gkcGHHHpzLyMEwJYMcrcZJQNp+2JwQ79saW2AAZtxNjmrZhk8unPkbmiTZ5O8uxkTLTjfSI1XXKylumuAO4tw3gzFyRr6BnWo6SRRHiFTLxjmC5PZm7G+c5PXUFVqafVkLZU91vQy9w0+pOd9Ngrp+A/cGJntDoTkIEsc=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 16:01:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 16:01:14 +0000
Message-ID: <c87f0768-027b-c192-1baf-05273aac382b@oracle.com>
Date: Tue, 30 May 2023 11:01:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
To: Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <85836a9b-b30a-bdb6-d058-1f7c17d8e48e@oracle.com>
In-Reply-To: <85836a9b-b30a-bdb6-d058-1f7c17d8e48e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0050.namprd06.prod.outlook.com
 (2603:10b6:5:54::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: d6f777db-ff24-4106-9f28-08db6127186c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Jt/4I1+TxDXwNADfZVFxOMmbBk3z0pezqpIeHDybXOw2tVyx3Yes4vbCDhhs9BSgy/Fh265e31Lo4LBR96Td6Es0b4Q4zFbuYN8F5cBr6ByUpfnNAzXLzW14u8fsqx0jhkBGPfK6XhCHhEiVnx33jqVjVSb9Sr7v5IHPEGF0vvkZMkMvu/wy3EKMhJXo/nCpr2NK2asPCkSEfDAYZEcU4T6HGbwc3NFNdFnBuPQfwn3UwGsa4Hr+M9UazK67dUXgwC8/of8WtHbcX5EtCyypuFUrRZ4OoPetYiHrmuzm6kHkKbXxjgJwz34v6txdwiJz4YzMab5EdPuUQwMB+flMfkXIbSVPk9KDSMr9DoMi1gnURAywJgZ46xbVykeTgzCe1ESJN/yALAK2pN+73s+Fh5IBY0MyEkz/AyqvU6+RwnPB9rTHPvCpZrCWR1AiF4et2bf7OrvjmrZD5/RHfES8NOVf+B5EmAWzUUixi1BNDRBOw2z6QH3efKp/FbsGohigHlD6f42WTR1umJwFTny7LeO7O5ff+1bj3Qpk1zEK3Lg6lXX0rr8sByVPtk3fJtvFdwao8Bj2QVZKXAMqe5RpK8Rbf8Q9D5pkiondPevz79cwYirrZaVXSUVp4AHCgOem+YsJdYDe5A2fv1qISqOkPA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199021)(26005)(186003)(53546011)(6486002)(6512007)(6506007)(316002)(6666004)(2906002)(5660300002)(41300700001)(36756003)(7416002)(8936002)(8676002)(478600001)(38100700002)(31686004)(110136005)(4326008)(86362001)(31696002)(2616005)(66946007)(66556008)(83380400001)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RUlvVVF6VGFhM0IxZlZuc0FDSmh5U2FtTnVDbGdxNnZqSmw3aFdWdVNmdjZl?=
 =?utf-8?B?eDI2L1VDM0cybmNTakR4ckNGcG9VYmVjN2k0cm5jK2ZwQ2ZQUlZjV2hiYzUv?=
 =?utf-8?B?Qi9LeDVGVkZkRmtFNjBadWZ6aE1qUHBldzJKRnhSS3p4UFIrS0RSWXlkNFRL?=
 =?utf-8?B?cHV4dnRHUFRVOHUvM3RNQUtLNTFPaGNMSVVqdzZrVnZ3V28wNEtlenRGdlZY?=
 =?utf-8?B?MG9pMU9DTW5Cejhhdm1tSTFqZXpocjN2dDBvUHBDU25oS0ZzTHY3dHg3TTF2?=
 =?utf-8?B?ODdrVnp6RkNrUVBvdzcwNGdlcG1uYUxWRVF4WXRSelY5dEhJcE1wU2VDYVFR?=
 =?utf-8?B?eWxVV1hxOStJc08vQTBQWXJpSE5LYkVSZ1RraEhSbW9RSXh5TWdobWw2WTZL?=
 =?utf-8?B?UUJMMUdWTzBCb0dCUHlDSGlyWDYxSW00SUtoRWJLWWROQnE5Yk56WVViekpq?=
 =?utf-8?B?MW4veWdIOEdraDZGNjZWY2I4NSthakVFS2dSazgwYmV6YjZ3c0NoQVZMdW5L?=
 =?utf-8?B?RjFZV0FHOWpSenVpakJ5dEw2MWkvUVZEQU92QzluRkRRSjg1OVZWVDVJc1hX?=
 =?utf-8?B?dG55THB2cjB5VHliWGFOZk94eVdCWWp1MDlLemlwdW1aVGRob0M0ME95NURT?=
 =?utf-8?B?TEVFYTFiUXEyczJ6LzBTYmZibXpUT0ljVmFuM1ZKU0taOUxrNjNKV1h3Zjd2?=
 =?utf-8?B?cFdjUzZxbXBYZys5eHhvUi9EY3VHYmQwWGxnbElMRGlhbVJLckhyNTBGdi9Y?=
 =?utf-8?B?TTd6dzdhbExSSGh2T01DaHlxUWVyZk5mN2JkYzUyT04wdmVTYlpqbXVmMkVU?=
 =?utf-8?B?ZXRrYktKRk5lU0VrdXE3bS9hRGlrTWRaNlBzUzFrQ0J6UEV4THpxY000dnFn?=
 =?utf-8?B?b3R2TWlQaWdoeEp0WmdKV0M3Nzd2N3BOYkpWV3lrUmllN3JWR3B6SWlPLy9Y?=
 =?utf-8?B?SWM3OW5yK0hCU0J6U0t5MjIzdWk3aXh5N0doa29qNW96ZXY1elRLUGZ6Y0wy?=
 =?utf-8?B?QTVOYVNzbkNpNlhHdnRGaERoU3VuM0FxZDZhQkFJV3pUQ3huS0JyVUY3WFc5?=
 =?utf-8?B?bkxqckNyRCtwbkcybndiNUc0Wi9ZMysxbkt2MmdqRVdUbHducVpHMm5ZN1l1?=
 =?utf-8?B?TFh2MW5IVndOVWFJZTFkQnlXOENhRmsxN1h0aFNmUTR5UUdtNEhLbXA4ejVh?=
 =?utf-8?B?QXN4Zm9teFQ5bjFtVmNwaHR2UmZHNldNUTNzSXVVaDljcGFESVhTcGRGcVhJ?=
 =?utf-8?B?eGxWbDB1d2N3ckpDMWZFaVgrYUI4WGxoSDVYaU15ZWJaL3c1amVOUHNNSjV6?=
 =?utf-8?B?WFd5bnQxVWhYZHZmK3k0bmtMVGxpdHFlMXJwcFZMMFpqdGxvTFBLRmhodEhs?=
 =?utf-8?B?aVVSbU9RQ0hERFdYRzZraVQ0M2dTS2hxZVF3TWU4Uk1ZbWltdmN4clYwYmp0?=
 =?utf-8?B?YUJtTGo0SE9hOVh1M1U1NnVOZE9NUmdWZks4NnFaKzBGWVRrQ3FlRThPekZ1?=
 =?utf-8?B?cGZvNngxQXZoYllOcFZnUTFaeTFuVmM0bXMzUHRIS1k3K3hoNHNpcTlJSXcw?=
 =?utf-8?B?WDRJYng2QWNsYll1L1NsUHdMdHhzYlNkTFRQYW92a2JhRTNUTzhmbVJDbDNF?=
 =?utf-8?B?NGtVTzhiblh1RkxDZXNUc0pYUkwxMjBMOVcwWUdLMTF2a3V0K0VHejM3YXoz?=
 =?utf-8?B?eHFJTGNqSHZpMkRtZ2dFTnU3c29ySXlkQ1laRE5NSkUwZUpCazdaZGRDV01T?=
 =?utf-8?B?RGhJYVpQL2VGVzEzSDlSTDNtamluZ1B5a1l0QnQvVmczMmRUU1dSK0kyZDhu?=
 =?utf-8?B?NXh2RzE5MGd1K2FKT2dhMUR0Q1hGZWVpYmNNTmN5UWdrYzNiWG5hRDc2d3k0?=
 =?utf-8?B?NCs3ZjczR2p5UUNzaHZ4NHZabWxzZTVTb3hjRUlabmZqOHdYbU9yaTVSaCtt?=
 =?utf-8?B?Qng5SnVTQncxUWhNRTloV0VjYnZQYXFBeEN5bXJBTmZpK1BuVloxZHl0dXow?=
 =?utf-8?B?UWdxYWwyQk5NclVRVXBxd3pjN2d3Tm55a1FURE5vamRSWGxtMG1PT1VVYlI3?=
 =?utf-8?B?bEdkSHpXZ1dhWExIOUV5WGVmcHR0bG9CVFhJeE1UaDJnWkQzbXFPVnF2b3dD?=
 =?utf-8?B?Y1hWVk5XOEdUQTRrdEZUSWY0N1ZmMWdKY3c5UUQwQWhiYlRNZERad2pOcGlu?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?eVlFWGhZOXB1VUpxRStTL3lXYk9Ca0VYTkRjY2YzVEhOQVdyeGVPMjNIdU9K?=
 =?utf-8?B?MDUvc0F4UXFLSzZHVkU2YitxdmZOdWhrQXRuM0ZQRGgyNjFJd1VpMlR3bzZK?=
 =?utf-8?B?QlJNejlkNDdLb3Bod0NHNk1RSi9IY2hNQlFVWVVPNXU5bWNyMCtDS3Z4UEJn?=
 =?utf-8?B?aGEzbU1ianVsWktOdWIveTJseXhPci9FYmNlaEMrTDZRQ3EzK0FHUzFPcFYy?=
 =?utf-8?B?NzFYWThLU1VWZVlUUFROZ2hDS2FZaFU0aDUzVkd2MVMyWU4zSVMvZFlvNEtl?=
 =?utf-8?B?MXlxMjE1cHQ4blpzc1RhTFNGU1pNaWk4RzBXVGhkdEZqQm1XcSt4U3NkR3JN?=
 =?utf-8?B?QURMcUMxbWk2ZU52VlU1V0NjQ2w5dUVUWThzNnBRbVltdXNpZFlHVDFueXRI?=
 =?utf-8?B?M3FDdStvRXphNStUK1Zoam1CaHVkL2dnUi9IZjdpY3ZMbk5iQ0E3YVJaMkFY?=
 =?utf-8?B?b2hKSUhoU2JiaHlXUGtvdm5rMitSY1hsM2N1dzU0RVNsK0ZVdW05N0hUckpj?=
 =?utf-8?B?NzNlOFZKTnB4bnFDUk15MEdZSTZyYUQvZ01aclM0S3FlOFEza3dQTU0yeVJJ?=
 =?utf-8?B?eGVidTA5QzZNMkxvQWZIaDJQQndIaHdydm8wQmNKSGh1dHEwQ2h5cDVDTGI3?=
 =?utf-8?B?S3A5MW1mT3pHRUV0OGVxVHpGWHoxL0ZvV1p6bmNkN3NRNFBERFMreGRacHFz?=
 =?utf-8?B?ZzJhSTdEVHpiRDFTRXVrRmtHQVhBRXpiWkJ0TDVTQmdnOHVTYSthSHQwUFZ5?=
 =?utf-8?B?ZUh5bDhYTlhmRFNUL1Q0Zm9jRlRRejZiTTZncXhoK2hQWGlOaE5rNWQ2SE5j?=
 =?utf-8?B?UW1iUGNiZjFsd2JzVzd0ZUh5M0RCWDUrdFV5S3BkS0hxZDRqZFkxb0ErL0Jw?=
 =?utf-8?B?K2pEMVBsV1RKb050R01leFZ0ZWVVTnlmbmc3TWY0NFo4c3JDakpRMGExVW1m?=
 =?utf-8?B?czltNmN6YlpQMysvclVZUWNPWG5xVnU4OU5HeU9DbTUrb0szYkhhcEdVS1Z4?=
 =?utf-8?B?Y3RzYW9qUENVOW5GMUx4bDZ0UVNvTXhVS2ptQ1lHSU1mTHFDb2JEYlE1QXFu?=
 =?utf-8?B?QUM1QkhWQTNGalhSOEhUbHVuMmEzS3diZUFGSnZFekErSG0xQTJRVm44Y0cx?=
 =?utf-8?B?QU1xWW0vWFUvOWhDdWpuRUFGb21xbkp2cDJMa3FPOWtmWnpnVlNiOVNhRHZp?=
 =?utf-8?B?MEY2R0I2NWxBRFBZbTVIM09zZkc2cFpsSXM3c2c3Z3NtZDNERTV6dS9Wc1Jn?=
 =?utf-8?B?TzRTSVh2RENoS2ZodlpoOUt2bUJlRk1qSUlsTG9wWTZpaGZCTU5nZWNWaDFi?=
 =?utf-8?Q?z7ZkFq1XONcF0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6f777db-ff24-4106-9f28-08db6127186c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 16:01:14.5755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVp1QUKjOot83xyUtH5Fw1Ux2ekgNWx3yA+0AvWL7xTRlZon2HVu+5hokeu33ubeLHWLHwncIYPfJHY41fI6mgslTKf/WWTAwHheEZ4Hpgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_12,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300127
X-Proofpoint-GUID: JOOxrxCCbBrhenleZfqYkPYDJ_Ra45TA
X-Proofpoint-ORIG-GUID: JOOxrxCCbBrhenleZfqYkPYDJ_Ra45TA
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 10:58 AM, Mike Christie wrote:
> On 5/30/23 8:44 AM, Stefano Garzarella wrote:
>>
>> From a first glance, it looks like an issue when we call vhost_work_queue().
>> @Mike, does that ring any bells since you recently looked at that code?
> 
> I see the bug. needed to have set the dev->worker after setting worker->vtsk
> like below:
> 
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index a92af08e7864..7bd95984a501 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -564,7 +564,6 @@ static int vhost_worker_create(struct vhost_dev *dev)
>  	if (!worker)
>  		return -ENOMEM;
>  
> -	dev->worker = worker;
>  	worker->kcov_handle = kcov_common_handle();
>  	init_llist_head(&worker->work_list);
>  	snprintf(name, sizeof(name), "vhost-%d", current->pid);
> @@ -576,6 +575,7 @@ static int vhost_worker_create(struct vhost_dev *dev)
>  	}
>  
>  	worker->vtsk = vtsk;

Shoot, oh wait, I think I needed a smp_wmb to always make sure worker->vtask
is set before dev->worker or vhost_work_queue could still end up seeing
dev->worker set before worker->vtsk right?

> +	dev->worker = worker;>  	vhost_task_start(vtsk);
>  	return 0;
>  


