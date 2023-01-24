Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E036C67A41A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 21:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjAXUmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 15:42:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjAXUmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 15:42:50 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1771214E85
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 12:42:48 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OGNmd8016023;
        Tue, 24 Jan 2023 20:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=vFkutHcO9AdUaB+O7SqLkPQxECHhv6rn1G0Nqmw2Xpw=;
 b=Om40d/FBwRr/Fgbcuwvu5Kt5Np7pRi9sQzTeGyn5n2z02F/l8YFk/60kseL/gnkyjBg7
 Ej0rtsjUhpM26/wzQ0LH3UDFhuk7KOaCkwHMRL3daXEIgFUJtA4QxAIhZnjnwvHI9//p
 XJlfX1oZGwTm9xWhZ83cAdX/IHe2ltLAFqsA4AKvW3I4RLvqdFqzMnXY7AqpTTyqnMzR
 iKiZxplea/VXJ/yFDOrunvIaQV2CBRejkK+D2YrIMse1asmT4G0wl1AYQcqh50fGIHgd
 dA8hPBZRqnxPl8egnAt8Bn/wb3Lvg1FvOG9uCA1QCxp9e1lClyEhrqOPPqE9F//YlYRa cQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt6fam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 20:42:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OImwtv021348;
        Tue, 24 Jan 2023 20:42:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5g4hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 20:42:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeAuwzAfWMHLFEy/vUL9UWRR3byXVltRYYJLBH/aW/9LcxfqXkNGGUgtgM4jAlhBg6/XYOLlDFdVxzUyXzCZRBieRcm49P3oBzjfg+N0E6ZiDUpt6GOagbLc/gSW0SIMTyiefyeWGxXPwKeasWYUXHDkYPTi1LC4Sply5iXid16SV3JlEe1dLxRsQvcMydGSXnZV9fUzBxvNxryXgETXbW+QDxA5h/aezFAtQ+Isa84CFkGYZUHcDuejHi8L2Ri/tSlfKwcJSqDSXCDZJof6vpsflPy+yhCO6jqe9HJIEoOQJB4aRUe88F4w+CYetSn7PS1p5un8bH5/VarCIcOcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFkutHcO9AdUaB+O7SqLkPQxECHhv6rn1G0Nqmw2Xpw=;
 b=WyNKxaMrTj4MUb4I1sbxibN7MulnaRx4OtS4VOS/f2J4w/WHv+HWQXtLG+b3cFqBa8TKB0soCOJMRon4PaM1OgL9a4NSMtbIxriBSUcHtA0YvAm73XA8NEeGlabX1ZjQliHFNKw4z4lYgZN42A8JGs6Fgcf6W2FoXiuyR5ZGdoTsbTA1MeQdpTdeoqwItFr+FConKqerLRknF/q0XIV5FyyOoFIRH8laEMYbVPftBQmyRoqbzaMuAZ8fq9cG8k6v4ifcpzKySRSg/MXx2ycQxsWlNMe1VSUDx0PL4zpmBufJmp1KMOpzDPtoonsRgOYUWTEbFbu++VSSHbHP2vrhig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFkutHcO9AdUaB+O7SqLkPQxECHhv6rn1G0Nqmw2Xpw=;
 b=MT6dAJZwH7gFomFoGVanBmXiFe+UcOynWV5fAprnIcniaVRe5ff1e9liWCNiPcjW0DtQkguSd5hbhD1aXZcHa6Xcu+oRqgA8TrXixEC9MReGQ5j1joCG0HOBi6qOfw4lCdn1Bkt/g1aAUDUgvloMk+tXfwiP6pNK6wJl8sJ6kXc=
Received: from BLAPR10MB5106.namprd10.prod.outlook.com (2603:10b6:208:30c::14)
 by CO1PR10MB4785.namprd10.prod.outlook.com (2603:10b6:303:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 20:42:23 +0000
Received: from BLAPR10MB5106.namprd10.prod.outlook.com
 ([fe80::682f:125b:f637:f89f]) by BLAPR10MB5106.namprd10.prod.outlook.com
 ([fe80::682f:125b:f637:f89f%4]) with mapi id 15.20.6043.017; Tue, 24 Jan 2023
 20:42:23 +0000
Message-ID: <54b10139-6652-6a4b-a143-0df9bcbd2910@oracle.com>
Date:   Tue, 24 Jan 2023 12:42:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [linux-next:master] BUILD REGRESSION
 a54df7622717a40ddec95fd98086aff8ba7839a6
To:     Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <lkp@intel.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
References: <63d00931.j+gAM+ywiXvJX7wP%lkp@intel.com>
 <20230124122800.a8c3affd99d6d916a10a1479@linux-foundation.org>
Content-Language: en-US
From:   Sidhartha Kumar <sidhartha.kumar@oracle.com>
In-Reply-To: <20230124122800.a8c3affd99d6d916a10a1479@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0183.namprd05.prod.outlook.com
 (2603:10b6:a03:330::8) To BLAPR10MB5106.namprd10.prod.outlook.com
 (2603:10b6:208:30c::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5106:EE_|CO1PR10MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e563600-8f91-46c1-4c27-08dafe4b7f39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llTquyFEgY8CV5jHOiKdHhFbvBB/gkQE1v/FPq2ln2hWmbmXrZQT2rZei/E8xXImBbuLpuOQxCAn4JohzyUEs0pp6oV2S/zsCFHfuOSTxETTGgESwEGoKJtmD2qpEPMnLvq6Al0k/JYl4zzxJo2jnk8OlaV5w1i5ITkM3RNrNbtO/6oWUXWsDdszGuXfvjrMM4TnCm71UecJdYjZOuMVFbZkE4NSGyk3myaZfBtqnWY7tTPjMP/VRT5DOgQyoM3wntNj0/wcTLMM7jRALe93WY+I7fl5txSVSQ7jyk9/eCc+xrGcZOSR/S9a7FcnKEwschbnHbMNvVg4dE5baqE09PDxFAr/OJ2pVZ7ESHrhHWQdksX0SH/MXZLYou8hRSwZfNXsCBK5MnF/R6lHxHdGxiWYTApi6+4BryRkLwv0Fauob+7efrlOENXVJZb9wdtHmDw46JLSuktvF+x9suFladgXYIdyQ2AIORFMEZtl5kQXCoeU5QmU+yZHTEf2U7NEB/XlYDm29nSN0NI0P1jMWQRHgAA1rdCja5cHspgPRrj6CHtSlOHrOlf1aPLuddb5uBbWRXYjzZYSj7KiLGEo14pTHX9/ZXCVPkJcy3HMB4M90WQXilxobGZ++Y2XbTbABOLX1qxKn4Qs1gVQE9ROSw4GeuhAWKWQRTWLZne5/HK1jsZpGyvPVyK/ZpgJPcWCIpSITLdxSMLBF9mVAC5FwCoC3ubSl2gJgItEBMsyWJfhtr2Wr31h1T8+d4KKCIakd71ffAujsE/qIxPgUGuRiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5106.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199018)(86362001)(36756003)(316002)(31686004)(31696002)(54906003)(8676002)(66946007)(66476007)(53546011)(186003)(4326008)(66556008)(6512007)(26005)(478600001)(6506007)(2616005)(966005)(6486002)(38100700002)(83380400001)(41300700001)(8936002)(110136005)(2906002)(44832011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WklHeC9PYlg1MnRVazhmVjg3MVNscnlZSG5QVld0NEFTdnYwNU04QzFYdG5X?=
 =?utf-8?B?WXdNVWV3M1VFa0xwTUNQd2NHcDR6aFJEK3cyVld2R2FGS3NZMGRtT3RYdWF0?=
 =?utf-8?B?bmhNOWtBbGIzNFVXMGg1UVZFaU15cXAxZmN2V0hNYjlyTzU2T1BoUTZDbGVB?=
 =?utf-8?B?N1UwQmxLK09vZ0VydG1uM3Qxd04zVXU3NjBvRm1ZL2dZQzVxUndUS3VnUGJ3?=
 =?utf-8?B?ZjcybytZTEN2aUV6ODZCbWtJdzZNbVNJbDVQQWlFNFhEVkEyeHVuOUhadU5O?=
 =?utf-8?B?cWVTRmc1OGtxWWp2VlNxMDJMNkVQZTFocFppZnUzMjBlc0N6aUZEREtkdUpH?=
 =?utf-8?B?bVN0TXJXRlhUWEtJM0UzSzIvZ2xFZFRXYTZFSmhqZDJYVy9BdUdodS83SnBL?=
 =?utf-8?B?MmZoV3ZZWEUrNXhZa3JxTVJPbmFmY21IS1BjRmhmOE04eWkwRCtWNGFxeThZ?=
 =?utf-8?B?S2dFaVk5Wks4bTkxdkhWR3FVNmcrRGNTSU9jS0I0RW5JOWhYeHU3WUl3RDhB?=
 =?utf-8?B?SGp2KzMvcHVtQ1pYUE13b0FRZVNnaGdhZjZ1cDdBejVZOWlndHNSelE3ZmVT?=
 =?utf-8?B?azlSRVRSbVlqdDRsdGtzNmY5VWpsMmxLVzRseW9vUVdCMDBHVXNUSVYveFc1?=
 =?utf-8?B?dm82aDRVenhQL1JXVHpobG12cnM2clZtaGh2STNjZmpFSnNvU1psbS9reGxK?=
 =?utf-8?B?WGo4L0ZOQ3NvMmh1WHpoelJxMk5IaUdOSy9XeGdrOVA4ZlppSGhDek9iSHdj?=
 =?utf-8?B?MnFNZEVoZ2g1cHB2Z09STi9DN3J5aDFrOUhoTEUxUEc3RnRmcVZCRHMrakIz?=
 =?utf-8?B?OTloWFlTVjBXVHlvdHRZVGx1ZzRxbWZDNFZpUFE1VHQzT1ZKNjNsRThicFB4?=
 =?utf-8?B?LzJtUmFkRnBnaGJDb0MvSWNVQ044M1J5OGdjNzB5T05sVTNSOFV5QjhFZ3VT?=
 =?utf-8?B?NXZqbXdOWlBxLzVzL25GVzdOYnJsNkpUditwT0p2dXIxQWxJUXA3L0hXNzdS?=
 =?utf-8?B?dGJhWEpPbjdldDFRNytjbTU4aGpYakQ1Nk1NbythUStlelRNMzlLSzlRS3lT?=
 =?utf-8?B?R3FQQTNaYnVoWDdER0FCdDRES1Q2VUIwd3FqOTlUMzQ0MnBqS0lyeklVOFJx?=
 =?utf-8?B?RFJGZndrKzhic0kvSHVRcnVEaXZha0tuUUxLZWtJRnlqcFJicGl0RVUzdzZZ?=
 =?utf-8?B?QUVudG92TmMzNUJQNDQ0WmxzNE5hZnVQaHh4UjR2bGVPZmNvWFprb1p0OThT?=
 =?utf-8?B?ZW44UXVmRHpEek1Bb0xJYWYwdmVkMlFJQllIcTR5UVp1VGgyS1RVOW1PSVFu?=
 =?utf-8?B?K0Nld29va2xhS09ZcGdiRzJYNUpUbkJ0NW1BcVFseVAwVXRNMXVpK2paRVQw?=
 =?utf-8?B?WUNMYmN1OFdid3lMMjRWcitxQUtZdkNmdThUVTJrNjlHZkdKYTgwMVVMcklD?=
 =?utf-8?B?ZjJyNnc3T0lYZEdzL2JibkpLWXZOTm05OWxVTmI5VU5aeXhXcUFHRmEvSXJa?=
 =?utf-8?B?a2FNeUhjTm84aTdXUEViTlhGbnIvZmxnK1ZFbEhOblQ0bHQvWllIdytIS2Rh?=
 =?utf-8?B?aVdyNkRoTGJCdjlITTUrRW9GTU9BRnlwSnBBQld6L2tnUGVoTDJaT3NDdkZB?=
 =?utf-8?B?ZUQ1MHhXakNtYVdxNWpBcVZoaHE2bkx3bXpwb3llaDFiQjlHRGdydGlsQVJv?=
 =?utf-8?B?MGQwTklyYlA0M0xPck5qaFdpSE9iZWlCY3NVbkljRDRKRUxhaXRQQWRwZHlj?=
 =?utf-8?B?alB5ZjNtcTA5aXk4c1FQUlNMSGlBcEJadzVkNENRNWhZb2xnT0FuOEZMYU95?=
 =?utf-8?B?N3ZZRHlncE1naXBWbTlRamxvaTEzWlRQVndWeW1xbDdwT1VsNE05V3dpVTBZ?=
 =?utf-8?B?V0VFY2dFZDNVVFFOQ0t1WGZ0OHc5UEQ0SDhxQnhBa2hCbW1wZjhHZUpWZ0p4?=
 =?utf-8?B?Y2tiNnB4dFd4ZGowamp1bmhoMTYwbXZKcVhaaFNmdXo4Z2o5RzZnTDhlV3p6?=
 =?utf-8?B?cDV5R1JiYjFQdm5TazJTZnpSU1hBV1pOVEUzczdKQ1kwdXBxSVVxQTRCaVpi?=
 =?utf-8?B?RnNjQlVoUm1qSGE3ODZDd09OaHd1aDdMREVuVk41eUFFTHh3NTl0dzRHR0py?=
 =?utf-8?B?ZGN3cUErcFFrUkEzRmVXMUhWZW5jZ0ZVRjYraUt4Z0dzYTA5S1JzdHA4Qzc2?=
 =?utf-8?B?NUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MXBLek81S0pjakl6TjhSUzNQY3lKckkwbCtUSmpCM2JrVEgwMFlKeW8rUDlL?=
 =?utf-8?B?dk4xcUlsYmhrSktJUW5aRmFmdnI2cnV5V2pIdjRSOVUycWxmaVJScFJ0OFNC?=
 =?utf-8?B?L1gxb1BpMVo3dnN2M0piaWFXYWR6eWRwdFNUSFJzbURHdjRSNEREdWhubFFr?=
 =?utf-8?B?Q0hCakZjeU5zbm1hVDIwN0w3QXllK2ZxOG9PUFNUWURERDJjeTZBVHo2TnE1?=
 =?utf-8?B?OXlsYVU2blBMWXBOZkpLekcvbnQyVTk3T2E2enRxSDg0QzBsZXNOblhUU2lS?=
 =?utf-8?B?N3lQVHVCaXdzZ2ZKRTJaNmlDdCtVdG1Vbkt4R1paT1J3RG5vNTE2Z0xuRFNP?=
 =?utf-8?B?QzYySmxneDROMzM2a1daRXFkRFlSNXhZbGZNaW9OWlFEcFI0azFiajVVcHo0?=
 =?utf-8?B?bGxGSmNEKzlMY0QvZHlxTHJ0UEllUXI4cXFOZ2dLQlVDdjVWSWhlRlJhSVF6?=
 =?utf-8?B?NjNTMGZTa21jWGVhYXdWenZHMUp0SVBjTG9tcUlPNDlTK0txdGp1NE55eTZH?=
 =?utf-8?B?S05hdGVBWGFTcExWZUpMNGVRL3Y4aElNL1RBNm56SDRBQXVWQlhNTUtzckZU?=
 =?utf-8?B?amYxaGloNWFyNHV6elEvVDE2MWZVL05aaTI5MkVIZGRnaVVIYUw4dWFJVWs2?=
 =?utf-8?B?UWZqSG5INmlTT0xlb3NCUnZZQ1d4TjBKeXZkYmVYYXJZWVpoZlFEcktyMmpt?=
 =?utf-8?B?bXdBemVlc3puTFJnZ0R6eGo3ck9UVStwMFcyWnY3ZGhqUmtXRjhsRnZPRWNm?=
 =?utf-8?B?YnhXc2dDbllHLzRoMVNpY0FLcU1qYW9Ia0FBbE9qU2pVLzI5OC9jR2thNUdp?=
 =?utf-8?B?MzdKa2dRa3ducFpkU0hjeU5uaHk5M0g5Nk9aYjVMU0xlZG0xNjNzRyt0QU1I?=
 =?utf-8?B?Qjh0VFphWEZhWE9mYWZWT0xuRUlpM0xQQjU3T2NheVIxbEtnNUd3bi9ndStr?=
 =?utf-8?B?RUduc0JNNUw1RWQ5R2FtTWVHdXY5dXVPQzc2M3dPRW40YlFoOWcvaE9PNHFJ?=
 =?utf-8?B?SzRONnArVXNldkpRSmxhdWF5dkF6a1pSNEE3OW9nZkJZNlVFRnNjczFmcmhJ?=
 =?utf-8?B?VmJ1U0o4dzlCdVBCTktCbWdiWjluV0hOM1UrL2VCL1JLTW8reGFjSGpiOFNt?=
 =?utf-8?B?K0FWWHgxUTBrNjE0Sk1iamUxbCt1NElVOW1rYnJwRVhGSGttcXloanZ6bHJX?=
 =?utf-8?B?VFhleFQ3NVBtRnhQS0xQQ0ZFNzREeVZmUGVtMnRXeEpIemR6d2Y3UDEzVUpw?=
 =?utf-8?B?SXVHaXVjdmkxWUJRSHB2dU1EUkZoelY5eEYvdHpVUjQ0d2V2NjBEcUx6Ukhn?=
 =?utf-8?B?TnJremFDUGtPbjFGMmlnMVZ2UGlnbURZTEw1TnBzUjd2clZYMXhjSjdoSTRj?=
 =?utf-8?B?T1RyN1J5S0wvdFJQWUpzN1NEZmo0MTJpMUI0ZVFRRXdrRDcxMWp3cWtVcGth?=
 =?utf-8?B?ZVFNSFMzdFNyaVBvelNoRjR3OC9jWUV6cnQ2T293PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e563600-8f91-46c1-4c27-08dafe4b7f39
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5106.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 20:42:23.8384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxAEaWOYPYJ1EZMg+KK+l8dm21YEG2HkSqaIElVyCmsOcxYelpT5YxoPSliHB2C5VVhn8aXCoCEZ7VZpDmo78CQDl9WTTQz06OZUtmpnoVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240190
X-Proofpoint-ORIG-GUID: _e82Jv-iyt-1dOD2fD2kgJBFl7gE31GJ
X-Proofpoint-GUID: _e82Jv-iyt-1dOD2fD2kgJBFl7gE31GJ
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/23 12:28 PM, Andrew Morton wrote:
> On Wed, 25 Jan 2023 00:37:05 +0800 kernel test robot <lkp@intel.com> wrote:
> 
>> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> branch HEAD: a54df7622717a40ddec95fd98086aff8ba7839a6  Add linux-next specific files for 20230124
>>
>> Error/Warning: (recently discovered and may have been fixed)
>>
>> ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
>> ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
>> drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_dp_training.c:1585:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
>>
>> Unverified Error/Warning (likely false positive, please contact us if interested):
>>
>> ...
>>
>> mm/hugetlb.c:3100 alloc_hugetlb_folio() error: uninitialized symbol 'h_cg'.
> 
> 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
> 
> The warning looks to be bogus.  I guess we could put a "= NULL" in
> there to keep the compiler quiet?
> 
This could be because if CONFIG_CGROUP_HUGETLB is not set, the function 
in alloc_hugetlb_folio() which initializes h_cg just returns 0

static inline int hugetlb_cgroup_charge_cgroup_rsvd(int idx,
				unsigned long nr_pages,
				struct hugetlb_cgroup **ptr)
{
	return 0;
}

where ptr is h_cg. I can add a "= NULL" in the v2 of my hugetlb page 
fault conversion series.
