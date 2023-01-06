Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C645660A3F
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbjAFXZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjAFXZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:25:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B3C88DD3;
        Fri,  6 Jan 2023 15:25:42 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 306N015s017306;
        Fri, 6 Jan 2023 23:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 reply-to : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Jc2oMl6BUrWmUUNskl1NCJiHvYadp1+KmYN/nbPvcJk=;
 b=lwx97KFc8s1fyDAwQ8YUX3kjqvcLNNECZwxzCdDpWI435cCKk/Z2uATBrNkA0WtdqZzK
 u2SPJE8aSkwqKS/9mTLrm6mmwH56lHZnf0SlW9aesRXjhe4aSCie1khamk2Otw/Je1pV
 rV8BTmlnNB4maEKYhBCn7f1JcnHdwSx2X5McC9ep53m1zUojxojz9jIn/h5KUNBF5LcY
 7bWbsygfpzvMxKidt46KS6U0h9DmLq/N2jTWSbx+xAUUd986iZbEE1SKw8EPPbUy85KW
 pjsMgfIr1+sxhYXlGN8hkfX9vOpY7WwPBcMzB4dxXFYEvaZp/DG5n8er8aBfhSozGVVg 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtcptc6sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 23:25:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 306MvIWt032480;
        Fri, 6 Jan 2023 23:25:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mwft1ntb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 23:25:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9pV1q3Wkla4iH8Ym9qZFHC7YksHEwPY9oqL6nXgP4Il7q8MvWvyyLa7w8d76hiYWZhojx7HuxUFPoUg2cAM0Gm++TiMQthUrLoKVtN+sjkukNK6ETDD1oyahRTFCl27t9a55WOLg0lJ2n6rBgpBCHR9Ha1OczAHbphP+I9eEgigfK+X4yQe4PLaDZ947Ar+35FpdgoV7OFn6/i58ADFO0A+ePysFsoi5iDokOkhl3xoSp6Y/43pdy3NRi+X/2PaRM1sm1Cux78dvjGejXN8O8Hi9XrFEDYL53wrnJ0FgsdNvAyYuSseS4Re5ilOA9JeCBfeOx0+ulhousSYn6HZKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jc2oMl6BUrWmUUNskl1NCJiHvYadp1+KmYN/nbPvcJk=;
 b=e7xuQof/hF3d7WTgF5NTHF9RCjbukj5GIjk+yl7mZVlUIDQBaw6SNn5bJysyne2EsaAK0iaFgsjSNvbzRrHndvPBp9KhfJbiak5NwlDE+bdO2D4M39udvbhE1le1+CttYVgQGeM74UclgDHz0V6aiQBv4Gc6HGCpj3gimQnTWYmovXXf9X9fwsxxovBtEMsv3Udaz+bN92XRoDLmJcgG9dXOe8CVtlYwobKrnwGVraKuaz8DyNObfWRUkJKv2ib3MIrjRj3Gr2ErFuu8CtSEd54TDbWR6ufgup4r2OXdWXhmWlXq3RJit8lo0G0Q0gq4uUnM1+KxiMN+cskrV0plnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jc2oMl6BUrWmUUNskl1NCJiHvYadp1+KmYN/nbPvcJk=;
 b=IlA7/FjQSJDGCbdg4xeZqVJWOx1qX0A8qI7HLjUhBSQyt6xf9EvXxe3UXTm/ftsN2eLz9Thjy6mga8TqibweuxNnNXIxJ4r5Z1rp1h/R7gYcK5Q6daIq9Ke/VtzIeh5AdO+QvyBMGw93nnrF/p+fiWPF8i1HpClBv4g4Bo1IZt0=
Received: from BLAPR10MB4945.namprd10.prod.outlook.com (2603:10b6:208:324::13)
 by MW4PR10MB6679.namprd10.prod.outlook.com (2603:10b6:303:227::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:25:10 +0000
Received: from BLAPR10MB4945.namprd10.prod.outlook.com
 ([fe80::3afe:336:671e:6d9]) by BLAPR10MB4945.namprd10.prod.outlook.com
 ([fe80::3afe:336:671e:6d9%4]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:25:10 +0000
Message-ID: <d9afabea-2c8b-6047-7126-5e55704bb291@oracle.com>
Date:   Fri, 6 Jan 2023 16:25:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: karl.volz@oracle.com
Subject: Re: [PATCH net-next 0/7] Remove three Sun net drivers
Content-Language: en-US
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
 <c43562d7-8e6b-40d9-26dc-ab85afcef70e@oracle.com>
 <048ca2e1-4490-21da-b95f-8be018d64e5a@intel.com>
From:   Karl Volz <karl.volz@oracle.com>
In-Reply-To: <048ca2e1-4490-21da-b95f-8be018d64e5a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:806:d3::29) To BLAPR10MB4945.namprd10.prod.outlook.com
 (2603:10b6:208:324::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4945:EE_|MW4PR10MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f895c81-fa87-46cf-d22c-08daf03d414c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e4scqdgoQGTl1KgWIEVW4ekBHl4xiHjdeklvdygy2tdF0BAtuFWYCFhRPDEJ5GHcNRbhBCLsVEzavJC2TUNvYcdoUBizfT54tCJ8joLSdr0PBHRQCvJlL/OTKQbIb81SjKIm+VMrPo88Lo+nfpBrhHonATwVtFCIJlxYRGm9iPn6+Okdx+70ncYLf1tEWUZ6iQoUnTd3bFTQNpFywMxDLf/vFUiO7rFbz5AlZz+fEdAXh5uLliVAZG6fdVox5BdNGIBVmJYfpyoceJrB4yEpDoZ/M4LoSu4F8dEaljNLeRDn/cM8Se1anMyUzgWEPpGCU1K75G3VnKb/89Cr+Qc25HzEU6M7ut978O37ZNi1IL4eeSggv67WWFjkOwJREFJ13OVyC3IBiOSh7+/GWad7jTfN8xqebgNpKkFjjizP97slQTTkg3Fzk+74HDgl/9E2YQ3aKqwtk0B6jQq3W1g+PBTx2k1S8pqnvCiMJOl6/YUjZ1BbOQWbTZNSYE9KcgY06GpU03ozNWkMZKLU81aPwL2P6kCJy092ND6g4Y0dmOmXl+RcmHe6qTyoUwupldQOsR5faDZkECmlhaDnBIm1k9Opd8D1FSnOMueY1qVCMrjvGiyryv9xZs2xhFPWOiO5ZHMVI/thYz/GPQhybvkkE887lg/z/HPf9X0h8AfTN92clij0KjhqQXmYWgsGoZxG5iRuuK2mnNu52XAWgX988S8Im5KwA0zyXakBbvylx1o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4945.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(26005)(186003)(6512007)(31696002)(86362001)(2616005)(36756003)(38100700002)(44832011)(31686004)(54906003)(478600001)(2906002)(316002)(41300700001)(8676002)(5660300002)(6666004)(66946007)(4326008)(8936002)(3450700001)(66556008)(53546011)(66476007)(6506007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck9ZZHFJQkVVYm9iN1cxeWJRM1EyTjZsSm5LSDZhTkM2SURSZURYWlFqNzVR?=
 =?utf-8?B?M0plWGhIeVd3dVlTZGdkNSt6ZVcxaHBaZC9haDJRVGkrNVZ1MmI1dEhLT3Rx?=
 =?utf-8?B?ZFJwNWVsUHg3djZWSlhjYUEzN1E0Uy9HVlU3bDFRUzRSbXg1M2hBdW9BNUNR?=
 =?utf-8?B?eTluOUlIVXl1VUhUNG8wQVlkWEV6NXJ2bWdRNmNjYnQ4Q2NOd2JZZkcyRDR2?=
 =?utf-8?B?OCs2dTdaWlNDT1QzSU1qNENsT3lQNVZ2eU91dGVqdDUyTEp1czk2ejVXU29P?=
 =?utf-8?B?eUFoK0phWlZDTHNybCtzcmhXeUtkS1FpUHlqRFVGVERKOVNjWDRrcDhRSHZC?=
 =?utf-8?B?cE9kL0ZOMGl3SW11RWdPU2N3RDM3cWxGL1JkWlE2c3hmTTk2eGMvRWNWazV2?=
 =?utf-8?B?RWlsRHlMaUpxTy9xdGk5dTNHWHBSY1Q3TmtTZTlTN21ObE4ycHllNlNJa0p1?=
 =?utf-8?B?L2QzVzB6eHEwVlowRFl4aWFCcHBCMDE3S2JOazduUU0zRUNMaHpGUENITUFO?=
 =?utf-8?B?MVl3bXRVQTc4dGNvbHRDQVlJVDY4a09PcDhwTmh3SUprZ1Y3NDh3bWwxY09o?=
 =?utf-8?B?MDF5U1k3YVpEUVhhWk10V1ZIaXJJa0VBb3RUMVRoYlpQZ3pWcStvR1ZXUHJ4?=
 =?utf-8?B?Wlo1a2hUZVc4ZXBrbnhJYlgrV0wxSHVRVEhtU3Fub3Rna0IwVGlmUE5wcnpD?=
 =?utf-8?B?TUUzSmdGcERTdDk3dkU4Wjl2c3pyeGxqUmtDbE1zd0tLRGw5c3FTU0pDZ2xF?=
 =?utf-8?B?RDg4NCszUDRjaU1jUXk1SEU2UTRhQUlJa0RQd0hXNEhHVDdyanVWYzdqQ3ZO?=
 =?utf-8?B?TUVFOHUxMEp1YXJsUmNTTWQ2ZnF4WmxHSTVHT09MOUtIL1NYZi83ZlozS1ph?=
 =?utf-8?B?Q0xMdzV3WUd5Yko2V3UvTXdQa3VEYnowQzV3cGcvb0huSm0zRTV1KzFxeWNj?=
 =?utf-8?B?QkZLNHg0L3hGWlFYRHpLMUVHcFNNUnpzWHFaTCtzTVpOUHkwQ0lHMCtKRW9W?=
 =?utf-8?B?UTJ4a05IMk1CR2RheGFuTFB6RFhtbURKeVMvcE1RVkN5aGduUklGbW1MVjYv?=
 =?utf-8?B?ZjBMdlgyZ0VDMWNpQVdJMEZ3dGtSa2JIREQ0UVppaVNJdFdEd1BZZmJqMVds?=
 =?utf-8?B?OWhSWEs1UGxrbmYzM1J3N3ZhM0VlRnZDMEtaWVZIcFVkYzE2a1dPT0cvNCt3?=
 =?utf-8?B?YTFJbExHc3IrazZlcmoxNTcwdks2ZmdqakZyNXAvZE5wR0Zab04yVEt5ZGNB?=
 =?utf-8?B?MU5KcHh2ZDBUNURETDNsam5ZMi8wZ2RhTmR4TW9obTFmbHV1amcrUHBJLzA1?=
 =?utf-8?B?dE4xczA4dWdaY283NEVXNnpkaDF3TVYvTXBvWCtQa1VZWWpKRWxBbVRpaXJI?=
 =?utf-8?B?MFRHVnJPWDdmZTQ0RWZpVVZ2Vkd2d1V4VHBJS3hhWCs0aFdSTkViOFJ1YTBL?=
 =?utf-8?B?YWJhUElLckU3eHoxdjdJU3hHV0VrZWF1SmdFb1NtN1FybWNmbU5YNTRwOFMy?=
 =?utf-8?B?U21DRlRoVzF5MHBtQnp0aW56YThnZGJxeFVlWVZXNnN1U3hrUlhVL3VOTUlZ?=
 =?utf-8?B?K3lwWlVPNTFseXZ5OC9nRHJDSHQ3NGtFMHpQb1VWSFl6K3ZtNXJtU2tKanlm?=
 =?utf-8?B?MjY0Uys3RWo3emxPQjFYc0pXRDMrTDNQREx0NFZ1VVg0VkFtYmp6RWg1MGIz?=
 =?utf-8?B?UHVNYW1qT1g0eW1mNmdFZHh4c2c5TVprdkI2ZnVKcENlUkZMcGR5ckxTd2Vl?=
 =?utf-8?B?V3BoOUt1R2czL3ZzYXdRTzdtVDVtWkNEYkxRT3VLNER2TDZOdTlzZnRDcVgy?=
 =?utf-8?B?aUFJa2kxS0lZWkJ6QUxHVkJBeEsrRUs4QXgvV1grTXR6aTRzdjdaUjFuREdI?=
 =?utf-8?B?d0I1cWMrSHkyUU5qVXdpTm13bDBWQ1BJSkdkano3MTNzemZtTm9ycWt6Vm1W?=
 =?utf-8?B?dVNSa05aY0dCNmZpVGE3ZnUxTHBuVm1MMURMcVZwelhsbnh1NGpIR1FKOFBB?=
 =?utf-8?B?Z0ZZanQ0VENSOEZtMlNlNnR5ano3UXQ1OGFZRllxNGhibWVPN2krYTduWmw5?=
 =?utf-8?B?eEFLV1VTelMxRHQ4UFJSWFlncEFVVDRSZkJsWHBnNDFJZXA5UE9ldkhybFRt?=
 =?utf-8?Q?2R9+fHQKcDuVN0JuotxGGXyXt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VTh6QmFpb0pnVzRPMWdST1hiSkJqNE5GUXBVSnJWWGpYbmhxWUIwVmd0ekhX?=
 =?utf-8?B?clZ5d28vN1I0ZmJybWRnL2JmZ2g4ZHRaT09rWHFZMFRwbnlkWHM5aktxcDhw?=
 =?utf-8?B?WnNIV3VpVlFEamJ3QnNQUUhoZEM4RXhLV2tLZWZlN0FUMTczd2pxbVZoQVNy?=
 =?utf-8?B?ZDNMVFFPanBJR0ZPTE94ck9tVytYWkFLR29oYnd1Q2ZBejhOR0RRZWpmeElm?=
 =?utf-8?B?eWlKdWNrZlZMTG9YbkxDZVlhbXVQSGdYTi91cG1OUFA2RDJWWkEvMUVLSjI4?=
 =?utf-8?B?amhSQjBJdk9PcWRTYUxMS29Bc05xaUpHZE9HMTZIWVJOVW9aZzM4NnZueDUx?=
 =?utf-8?B?bGsyTmJZS1ZycmN5eWJDVjBDY3VFeGUvTFh6cEs3NzdGaGVYNlZCYVpQVG1V?=
 =?utf-8?B?VDU0QVBOYTBXUCtEd1RCMHBTRS9EcXVUcFRtYzNlTy9EQlcwUmRTR1B6cW11?=
 =?utf-8?B?UTk5UjUxRmk5TXJjTXRJUmtNNDhiQkdydURxODJ1S0NyMkpZZllCMEk2cFNV?=
 =?utf-8?B?MUhSejhwYnVRWUwrR0pYQ1ZjWWtUUTYwVld6M2w5eHR4Rys2enhoOTlQTmdH?=
 =?utf-8?B?blQ4cUFnTXZBUGtsc0EwSEkrd0N2OXVhZ2lYQndINlVlTHlqS2M5VDdIbEQ2?=
 =?utf-8?B?UFNkVm42THByYXRUVVhFYjBkMEw5aWQ4TUFBbmd5T1BVSW5DWjh1VjlQWlN4?=
 =?utf-8?B?RmhsU1ZyckZvcEpoeU80ajNwMk4ySnVpMGF2cmJDQ2oxdVJOM3J1bmo1aVI2?=
 =?utf-8?B?RERMYmJwTmJXVG9VdGFVV0toRFBiZXl6RlRGc2lOWEdSOGZwMkhkSVJacTNr?=
 =?utf-8?B?aURaNU5KRXc5R0dESUlid2VVQjBCNFdpWC9sMXRsRS8yb1lPS1hTeVorQklw?=
 =?utf-8?B?alcwTVRJaC9LSFJBbEFiMDdUL2lkVWxucTg2VEhKZkNTbVE0QW5ZeW9Zb09W?=
 =?utf-8?B?cktJZ2tvNnZoRk95UG03b21lYzU5V2UzZE9obklzTGI0WDdTdnIzWGNFbGRq?=
 =?utf-8?B?YmVsRzlXdDZMRTJ0UkZicHhYUkYyLzdSMzdNVDFSWm5hNUIrbyt1ZjEwbElu?=
 =?utf-8?B?V0hiL2tXKzF2bExnT0lRZ3I5cmkrTXMxZS9tVWYwQkp1NUxic2hCY0xKUFRt?=
 =?utf-8?B?TUlOSVNlY1c3S3RmU0kyYUlmM0pKNk96UkdpR0trbERpYjlGQXpjT2R1SEpm?=
 =?utf-8?B?SzFoK2pRZ3VqUFFWZ2pTem9wMWpOdVh5WmEwdXpRd1ZsZXYrbVUvcE9TeEVQ?=
 =?utf-8?B?ZDhQSFQ5bVpQMTdiaENXL25QTGJXV1V1WlM1MG1SdVVUelBsbHluL3htOElk?=
 =?utf-8?B?STc4dnk4aGFTa25KOElOa1FIUTl3a2xVaTFSZ29xaHQydTV2WGNVb1g5TjA5?=
 =?utf-8?B?RlAyQVNLNnEvY252UXZ4M3RQa1VXTmRLVU45bHBOZzhqbitRVHBwRkRyd2lN?=
 =?utf-8?B?S3NDNlVpWC9MTE9TYTQxd3QwSkpmRnZaZm0vdGNBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f895c81-fa87-46cf-d22c-08daf03d414c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4945.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 23:25:10.7134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AG11Dc2mgPAcjkubrJfSdbHCNVseCkFaBWryaeL4aABeW/HLv2KrsCsFpxJdrwg1i35/vzUL5hapO7tDAnd1qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-06_14,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301060183
X-Proofpoint-ORIG-GUID: xmgIWEMMvFO_-1fdL-eOGHjz6qb9jzRD
X-Proofpoint-GUID: xmgIWEMMvFO_-1fdL-eOGHjz6qb9jzRD
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/23 16:10, Anirudh Venkataramanan wrote:
> On 1/6/2023 2:44 PM, Karl Volz wrote:
>>
>>
>> On 1/6/23 15:00, Anirudh Venkataramanan wrote:
>>> This series removes the Sun Cassini, LDOM vswitch and sunvnet drivers.
>>>
>>> In a recent patch series that touched these drivers [1], it was 
>>> suggested
>>> that these drivers should be removed completely. git logs suggest that
>>> there hasn't been any significant feature addition, improvement or 
>>> fixes
>>> to user-visible bugs in a while. A web search didn't indicate any 
>>> recent
>>> discussions or any evidence that there are users out there who care 
>>> about
>>> these drivers.
>>>
>>> The idea behind putting out this series is to either establish that 
>>> these
>>> drivers are used and should be maintained, or remove them.
>> Anirudh,
>>
>> The Sun LDOM vswitch and sunvnet drivers are still in use, please do 
>> not remove them or the event tracing.
>> We use them internally and you don't see any discussions because they 
>> generally work fine (AFAIK).
>
> Hello Karl,
>
> Thanks for chiming in.
>
> Are there recent platforms where these drivers are used? If yes, do 
> you know which ones? Or are these drivers useful in old/legacy 
> platforms that are still around but perhaps no longer in production?

These drivers work on older T4, T5, etc  to the latest T7, T8 Sun 
servers (e.g. T8-2, T8-4, note, T7/T8 are still in production).
They may also work on T2/T3  (but I don't use those anymore, though 
Adrian (John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>) might).
You might have missed a lot of the linux SPARC developers since they are 
on the debian-sparc@lists.debian.org list, hence I'd ask there also.
>
>> I think you are also going to break things by removing Sun Cassini 
>> support, but I am not using it personally.
>
> You suspect there are users for this driver as well?

Yes, they may not have seen this yet or recognized the servers this card 
goes in (post on debian-sparc@lists.debian.org list).

>
>> What user visible bugs are you referring to here?
>
> I was saying I don't see any evidence of recent bug fixes, which would 
> make sense if these drivers "just work".

ok, no worries.

Cheers
Karl

>
> Ani

