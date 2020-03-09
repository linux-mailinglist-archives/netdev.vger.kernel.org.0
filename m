Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E07117D912
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 06:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgCIFk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 01:40:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19558 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgCIFk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 01:40:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0295cPOg018314;
        Sun, 8 Mar 2020 22:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=7odBgJEWYHhb23/W06RPMyXn+wvOeMceUwyTJ7WBQRY=;
 b=DO2rLUnYn1ODXaZLcRQmI6j/QF+O3sMdsXquL5xqySTdvtmK0FXcOa2Jp55kxQDth8GF
 oyqQH3n/d5z25BGG7I9gitDfQtrMS6HcHkVyc54Yt4Vp5nSehhZDkBrEW+Pm/yjQGejg
 4FfjiZAJIPrvwx1aEiO1ikdDxYO65xUBMyc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yme3vcu7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 08 Mar 2020 22:40:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 8 Mar 2020 22:40:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWjDD2ushLagPi5t1PTrIFJ0tFpYY4PFKKTjL+6tTG2TlfaWcYmOXGWXDYg5rLNEj+Ym3+nlW6p2i+x29IWm3/FUuPQ8PB4lTeFWlfMv+YS7qWwlX5xg+ZILX72kJd+ruQ+zrMXrSZw9EK0Eq1zd0HWgqtlCIIbzrHQlWdiVmTt2AwZ8Y8GC+6hJYEIgwqH4z595OMMSz0k6FeyjqrrT6E9gZAy6HqSordQwipFg8tXZvDq6ZUJpuuRBmsjhwS1gtWbZiry2kINBb1EJu6cKS68XE52jsq3EPyzVdRiQdIoTUMy2yjsEvcxmZKKCxhmvM2dNMDkSXue6lium222hXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7odBgJEWYHhb23/W06RPMyXn+wvOeMceUwyTJ7WBQRY=;
 b=W0AC3VIbvsu9xUatrC4mKIlwOG+cy1T+VnuO4yT1qxUekkH5ooqtqXA4/UoTMIllqUriD48W50yyOA9EtV2jPJiux0eGQ9aw9sgTyb9DYMXV4egnWNjRT7CKBhpltJJZEasZ0SVnqBV6StYNtIBJplpCr30gmkLhvmaClP+KnB8smiiIC5d0C1djqPSRwTPPNdy9dGXWxVYFhl6pIzP/JwXdQy8WhQ48d1AkgthM+Wb7Oiee2/0JSWl4atRZur5CemNV3asHu35vOs/g1Pvw2o46hJNVdWwQgJRS+zi1Eu5I81XLmIqVDAYhLHuURAO/7Li7ksJD9XqOTH82e+YI6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7odBgJEWYHhb23/W06RPMyXn+wvOeMceUwyTJ7WBQRY=;
 b=LKMmhw53CwUn6p0UUMe7UNkpsJ1PmEu0mfCa4uuFv+lA5QRTyrNA6ed2ZL2QTLypeB1GDLukI1+CQGoGzRJSkCxWKNoKVTbCmdWsAT2pVeNyuzTy/BSUsM5TWwnKqHaz8zHAjpEhQqYCihEzFsSvH73vy8qoyeisFjfa119MI70=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3799.namprd15.prod.outlook.com (2603:10b6:5:2b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Mon, 9 Mar
 2020 05:39:56 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 05:39:56 +0000
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
To:     John Fastabend <john.fastabend@gmail.com>,
        <alexei.starovoitov@gmail.com>, <daniel@iogearbox.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
 <5e62e95b61bdf_5f672ade5903a5b83c@john-XPS-13-9370.notmuch>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a756c2f3-daaf-be08-48c8-6b92c24c48c9@fb.com>
Date:   Sun, 8 Mar 2020 22:39:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <5e62e95b61bdf_5f672ade5903a5b83c@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR2201CA0055.namprd22.prod.outlook.com
 (2603:10b6:301:16::29) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:23) by MWHPR2201CA0055.namprd22.prod.outlook.com (2603:10b6:301:16::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Mon, 9 Mar 2020 05:39:54 +0000
X-Originating-IP: [2620:10d:c090:400::5:23]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30ee1f78-b49b-4e96-0d65-08d7c3ec4c3f
X-MS-TrafficTypeDiagnostic: DM6PR15MB3799:
X-Microsoft-Antispam-PRVS: <DM6PR15MB3799008A96CE405891D9219CD3FE0@DM6PR15MB3799.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(396003)(39850400004)(136003)(346002)(376002)(199004)(189003)(6512007)(6486002)(4326008)(2906002)(52116002)(53546011)(6506007)(2616005)(16526019)(316002)(66476007)(66946007)(31686004)(66556008)(5660300002)(478600001)(81156014)(36756003)(81166006)(8676002)(31696002)(86362001)(8936002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3799;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJWSIkc6hMH7aIFHo4NWykLhsfZk6jtWrcJr8artVZUdMXvTNlCm7BRFNEz6cGLJpw+6OdUFwrO2TNTYHM9ZmhnSvHwRaobB6QfOCb6Yx9cW9r+Gdfmuf1dyMpQOZcumMRLlMuaS+jNBWUyswnU32IpjO0PN6zPDPsVfX3XBqLIfgvfXD6TibrHXeRm2t7zzrWhxVlbO1OOLLhTPc0mX2wRnsVDOFNY1g0eaFMFmzh6Wrx4BnJ0TJVQEcTOsvAP88sQVAl+XOWUeUiXQGDfRN3R9Zm5T4Q6PaMywM3hlhBmg1imuaxFiyQmYJ0ENyIlSefDNbiAS7qjxe1UxryfIrb3fFfZUvEi7FllpPWKe/woiG9glp1+djOxr1xUtozScMAa0Fg11yhsykl597VvSwqGXPj5UYE1e/6BGu5qXoCrZH+aQNPP8UEKEfrHegOzn
X-MS-Exchange-AntiSpam-MessageData: ByxrvEQplcxfQYRmQJ7h63qWixmrddpVzZKhMDuX4/UCkIB3RaYI3Uj70bYmcRJX2RP73GvIsyg6J++oGeoMql7NzO33dSZcpEG3Q+5SQf24RPlirYMUVhN1xcu9kTNMoaZ38QHTGZ/2a09IH2reD1EtJ90Ozu3/t1pCbj7AWEk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ee1f78-b49b-4e96-0d65-08d7c3ec4c3f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 05:39:56.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jZ+vmYoYfM8M9trwdIHG9w2SvYeapPAc3Oo0TISU4T3gZU5/dq2pjacwag3D+3w0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3799
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_01:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 impostorscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/20 4:22 PM, John Fastabend wrote:
> John Fastabend wrote:
>> It is not possible for the current verifier to track u32 alu ops and jmps
>> correctly. This can result in the verifier aborting with errors even though
>> the program should be verifiable. Cilium code base has hit this but worked
>> around it by changing int variables to u64 variables and marking a few
>> things volatile. It would be better to avoid these tricks.
> 
> Quick bit of clarification, originally I tried to just track u32 hence
> the title and above u32 reference. After runnning some programs I realized
> this wasn't really enough to handle all cases so I added the signed 32-bit
> bounds tracker. If I missed some spots in the descriptions that was just
> because I missed it in the proof reading here. u32 above should be 32-bit
> subreg.
> 
> I also forgot to give Yonhong credit. Sorry Yonghong! The original alu ops
> tracking patch came from him.

John, thanks for working on this! Hopefully this will resolve tricky 
32bit subreg tracking issues. I will look at the RFC in the next couple 
of days!
