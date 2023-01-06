Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940B76609A4
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 23:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjAFWpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 17:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjAFWpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 17:45:02 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886B185CBA;
        Fri,  6 Jan 2023 14:44:59 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 306L4m9a031291;
        Fri, 6 Jan 2023 22:44:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 reply-to : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cxVSWBYcOA18oDvAHaayQqvWceJm68lQeyyVIVoUYF4=;
 b=KD7XvZxNuuR3V0pPmFphoYRVV75RFQSK6xeYqLEWybRn8sxD38l+vCwBfjN8FPzueF0j
 NvaG7AieaY1bK1Nh29+n/sL80M9cukpUAwxIyd+xYwlAT6Ned47Fy1b8hBinMizXRCch
 tgaFF581Uy2oTFx2j9Zhi9QltTftEI3p233EG2x1VEBNcL35ylJq7z4gEcpxhs6ob+1m
 oS3XLi6WSaiaKdT7z7vhWLuKdVVjRr7u7sFEeE3pS34NPPgsEpN3knK/jJaAZVfF+SlL
 51YNwJxmKlZKcjEGAMLbu3BdyVHOXyMEZP77Rq0rss4hu9MM0atFlYRAOKoxLZvynRi2 fg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtd4ccabu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 22:44:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 306L07As015335;
        Fri, 6 Jan 2023 22:44:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwepupny4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 22:44:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDFp3O87EHIwip8goeVmQAlND4yePZxoRdvKHCF0q7d2luUZJ6mMNh7ENZrvMhNhrxJGMSXEchjIabBJa1OVU7R0D4yerRnfxLmq4BcSCZVvsq1K+FLMVgMeQJK01gE8kUPUluR88VXYENA+JN+zNdzrPh6FG21oE6+Dz9kh/yzcClmiaREpQ0HAV+ucOv1us5DkntxYzz65KuauZNJQuvThMpkURU6HsC4rlM9CCho/dDc6yUMUSEWg3LAf9CA+9qUftIGu+ywZBK5xskRDYjtC2UO2YvmTaBflIJDgB25qUZiVbijUi1DjqJNMiUwMoXl785XzUNb25T9fSXHtiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxVSWBYcOA18oDvAHaayQqvWceJm68lQeyyVIVoUYF4=;
 b=hcNGFuE8rFThPF2ZNsMphJ2qIP8uOswVEOsH/faWDVdOH43Y0GLmZi+AZoB1l3YrGNQVnOgR86Sh4wSsLIkyWp+XZZwHPsrtKiMTkCkvj6LKiqWLwjJfFKt7wXIRrp588SSRSUJfdtUBpK0ox5HejHhbaKjH7SSJAXWTrjDIIA+wLbIZskxH6iyfVKZ03xIOMGthUywZ2ANLJhMW27okVUZAcj2VWsvbiaPQ1FEaj1veP6kdHF/owI+jttA0r1FbjIKmcse4HIqmUeKw2W3LUXmgTbHru58MiN60FXBUPN7o+XiFMFA4SAH6rmL4FQeyaWQfuqCj2+RRxSM4PSMV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxVSWBYcOA18oDvAHaayQqvWceJm68lQeyyVIVoUYF4=;
 b=wtOT32ZhnIUdEvjxkblLkb9hC997xrazt0EFiQn5OWqJbeoAFg9f46zZt+dj4yNmJn1eW/+h7wfkwzz4UHSsRwp6MsuZDoMv6ljH8QPN5MeH3JWj0Yro5cNJGGVwh8PvUKmkJjiasNmNc87RC1OHC5+wxhYMK83ArWeHe8I8UUg=
Received: from BLAPR10MB4945.namprd10.prod.outlook.com (2603:10b6:208:324::13)
 by BLAPR10MB4995.namprd10.prod.outlook.com (2603:10b6:208:333::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 22:44:43 +0000
Received: from BLAPR10MB4945.namprd10.prod.outlook.com
 ([fe80::3afe:336:671e:6d9]) by BLAPR10MB4945.namprd10.prod.outlook.com
 ([fe80::3afe:336:671e:6d9%4]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 22:44:43 +0000
Message-ID: <c43562d7-8e6b-40d9-26dc-ab85afcef70e@oracle.com>
Date:   Fri, 6 Jan 2023 15:44:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: karl.volz@oracle.com
Subject: Re: [PATCH net-next 0/7] Remove three Sun net drivers
Content-Language: en-US
To:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
References: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
From:   Karl Volz <karl.volz@oracle.com>
In-Reply-To: <20230106220020.1820147-1-anirudh.venkataramanan@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0073.namprd04.prod.outlook.com
 (2603:10b6:805:f2::14) To BLAPR10MB4945.namprd10.prod.outlook.com
 (2603:10b6:208:324::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4945:EE_|BLAPR10MB4995:EE_
X-MS-Office365-Filtering-Correlation-Id: 1196a6c8-8d91-4f19-3535-08daf0379a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DU5zdBb2cG72H/QsQGC0mHOLGIllGVED+jk4l34pgkXdvJaIGVJkKD0LxMpft4h/jPcJsyZYwQ4eAqCFOm/HlQ7q8ZmDZRYme8gd8BPYVItQ1VuhtHoaayT0B0nvgf5MvVwRf1tiHVQzdu10o8XXQO9zE8MqfA1tfG4POhcsMnDVQR6Vbw4T9HBrg5O8jKYkQBIl5JqaNO1G89ntFMJ1seXQ2EIm1/c6HuvfeE1D4hYgdLDDXQA8Yy59o5NSBsO/fHZbdwgbxDiCAM/pjL5m5UcYG1lscH9G/I7jRCFiedj+UAYID8a5NxpmgyDAv1VNwA0FlxE2wRe2NgM0ouaWyYfbg3rNWanN+VQa4/N122mzTbawx4IY6hwDFZ3mp2AyUy02/Mg+u6ZQWUIClkDX2umD83UakPam9yfvNEtXTlUiPH5nuAQ+A2TcygtoM9qieJiBpEwUQ49l8DUuUpt6lc6nfdI8gh7ebypwwksJrZxLqlxX0KeKpCY0JVxCvCfhHteSnDK8umr1hnh3PNn2YHPwPQ/QEihKsX8UKlNCib4EpPL5U4p/BHVJ5iOrtY35nS2CGkniemv1ON6qfVnPky7lb/4yFUQsdQ351f81oklvuVwNdEmT1lUZky2JCwQmIlfrJEp6hic0OfGbGdOoNW8benzomnpumK7DvYDVJ9gBY/KQtVpqIqL2Lc9g8OYQAEVQGCx8n3ifDhTb2gcskZs/wLq++pamryd3xeQBMOgukerFraW89hE6G3wQo2gl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4945.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199015)(5660300002)(2906002)(3450700001)(44832011)(8936002)(41300700001)(316002)(478600001)(4326008)(8676002)(66556008)(66476007)(66946007)(966005)(6486002)(31686004)(26005)(6512007)(6666004)(6506007)(83380400001)(186003)(53546011)(38100700002)(2616005)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW9hS0U0RWVheHpWNlBVcjJVT0N5aHFqS1BSQi9xTUV6Z0lDV2hmZkNPK1ZQ?=
 =?utf-8?B?YnFlL2pqOWlSV216UG5PQzlSNlBCdVR5bStPakNTYUtxMUJGZTJPbDZHTDJI?=
 =?utf-8?B?bno5Wk1ncWgveFEwd1lkVm82WEJxYjZ5a3B2KzM0WnR1TnFnYytSNTJBRlps?=
 =?utf-8?B?QU1ZenlKekxSYjBsUE95cDJnTk9zWVg2aUZoSHorUlZuRmgwcUpCV0xReVBL?=
 =?utf-8?B?b3R6MlFDNnoxdEllUFptOFVhZzdjRmRrc2NMSFV1TmhjYUdUWlhndzM4WFMv?=
 =?utf-8?B?SEt6SG5ibFBVcnpxb3dCQ3lJbnU2ak9ZVWJXVmd2VmdtbmZTZFptVHB4Wmxz?=
 =?utf-8?B?azJoRmxzbDN4UTdLMHlkQyttMmo2eWdPOTlFWXMwQkZVQXBTYi90aE1ib0E0?=
 =?utf-8?B?Qk8ySjdnbStpcXVycHlZNUhwUzgrK242R0FPMks5SkYzMEJlaS9hUXVSekov?=
 =?utf-8?B?bGxhSlMxRm5lRWxvVHRaYTNORVFmOStHanRUaWJmNGRia2dnV2VwOTBXa1l6?=
 =?utf-8?B?STRhZ2w1M1oxYzE5cjF4NGxHc0Z0VmRGOFMwZlRjK01ILzBSNmNJdXlxbHVP?=
 =?utf-8?B?Nkd6NTlXcXd1U0t3THpKZ0UzTStBYndmMGUzc282Wnkrc29Hem5rYUxVT3R2?=
 =?utf-8?B?eitXWHdyMEpvUlBHK2g1bFYrZUZwV1BzaDNjdmRKRGtEVEdqaHZtRktQZCsz?=
 =?utf-8?B?WjczemZOeFgyV25EdEFzbUVwam82bVFLOHlFRFprZ3lVWDh1Q1NJdTI4ZEVk?=
 =?utf-8?B?bUs2dnlURVBhckZPU1JoN3NJZFlmWUYrZ1crRUNDWjFpMVZMaTVmNkhiR1BG?=
 =?utf-8?B?cExwL2FDWnNZRnpjdEFoTjRlOHlOU1QyenFhbTB0ek9IVXJNY0dNaFhXcG1y?=
 =?utf-8?B?VVlWbEFwblFOeXRXZEdYK0pnOUxyQ2JiVjFhd1ArNXdxUDB3eEFrdHJORVdk?=
 =?utf-8?B?RjBXeWlmTjFTZVR6T2g2UDlIMmt3TFdPTU5KSzk0NjFCUWJMREdtOUFkajRL?=
 =?utf-8?B?UmI3NS9iVlBrU0ZtUnUxbTROenVacU1LRU1qY3Qvd25HYmEvQVNXMDNzWGFv?=
 =?utf-8?B?L0hEN1NJOXB0UE4wV0VWbnQzMnRuaUJNN1cvam0yOHhRU1diWm1YR1JPeHFG?=
 =?utf-8?B?SER1c2YyQlJPaXo4ZStveFRGOExHQVJUZWpDajlHSzRXWnZrQ0JUQWlFamt2?=
 =?utf-8?B?V1VtZ1VXVmxlZUlGRExRaXFFUkI2YTdqaXNKRld0eXRZQlNTRm1NaWxGVlFT?=
 =?utf-8?B?R09UN0ovZ0wwQnYxMVkvYXE4UkVEci8zd1YwZWpKTStrMkJ6QS9mWG5peVll?=
 =?utf-8?B?Z3pjMUZoa3ZJM25jakwwcXViY0dWeGEwVzY2dVFxQlNscTlMeXFZZkJNRHJV?=
 =?utf-8?B?cUFDQ3ZLRWNGdlpOQ3BOMGpPMURINjQ0ckEraEZIWTZwaUhLZEM1Y1lJNmUz?=
 =?utf-8?B?VE9CaFZjUzZtQUdBNkJYYUJRdHlFVE1PSXFsR2M0aitUNlNBRHJUcmJINVJS?=
 =?utf-8?B?TlpVUmZzblFrRndpVVJVY3lwaTVDdEtIUEYzOTNPYmZaYi8ramVleDZoMXMy?=
 =?utf-8?B?bHBTSEs3Z3hia1l4M201ZjVveFFnQUV1czVXc3oydXJETHpGcDZCRjk3dXhy?=
 =?utf-8?B?VDlpZGNnZi8rZEFidEV0bkk0bWpMKytLeEZsbW1WeklFeWtBbDhSSzVNcnJM?=
 =?utf-8?B?WWVpVnNhak15WWVlYjBSeFFXRjRJNXlFczRUcTlpdmo4MldDT2JJMXp5UGJO?=
 =?utf-8?B?bGFSUUQ2RGpObXJ4T0l1WEc2UUlQQ0dmNXZ2TGpCYk9uTkZQUVBNbGhFODVm?=
 =?utf-8?B?TUEvTmpmbUI5c0NBMit6cEFiNmZGZkNxd2FsZFZLMG5UWi9Jd0UySkNkUWI5?=
 =?utf-8?B?YXhzcklpZ1lkZlRSU0ZhaDFzbXBXbFhzZFZpTjljOXpLRCt0a1h2dGRvL2lz?=
 =?utf-8?B?RjRKUDdTbXNlYWI2bUt0NW45QllnUyt0QVRxcHlXN0tXL1dnRmhPV216bnVp?=
 =?utf-8?B?eWhFUUVRNHlZMHp3cjVtUDlQOXBtSzd4VXpqMDY2OWJPMjJQR25hY2czY0x1?=
 =?utf-8?B?SWdZU24rbjNXUmE2a0hRNThCZHBuUHg2dEtQQ3Z0bXpYdmt2dUdJR0F2YkVW?=
 =?utf-8?Q?X5F6UdUixbaHf9SW0aI44ChMu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cEV2cG1laTVpNCtVRUlqUEFBVUR2eVRuOHlGR2lBdk1OWXZkU0JTUnZXSUM5?=
 =?utf-8?B?T2c1N1hyNjVEY1ZEVnFreEpuNjZheUNmOU85amU3Q2I1djJKRjI4TnFGZEE2?=
 =?utf-8?B?M1UyZ3JsUGxYT3NHNldGUzYweVZqSy8xS3AzS1N1bXgrWTIxTmtTeUdXWWZo?=
 =?utf-8?B?Q2tjZ3JHN3hNTExBSmorWU0rYU94YkxEbW55TDhPRjloZXVkVW5vVGJ5S1BL?=
 =?utf-8?B?dEFCVURxUUNrTTl6L1ZTYjVRWkZiQU5aV0lKUUduaWtpT3FUMldjVXlmcUI1?=
 =?utf-8?B?MlNQa09jWnpMWE9wdzF1NkVIclQrYzlYZ0hQVVZYOUg2Vk80RnhiZzFpQUxh?=
 =?utf-8?B?MS9vUTZtSGtzbHJXVTM4UytIUmNlZnB0TmF2ekhKdCswMmRhck5GTVErNHJx?=
 =?utf-8?B?WmlnLzhBNSsxdVpZWWMzeGVvNll4ZitHd3ErODFqRUdIOUplUlZXMXA4djB6?=
 =?utf-8?B?RDZhT2lGK1c4T2xGdk51MnkrL0dleEtPVU9GT0cycGt4OXh0dTBhbUJvc2E3?=
 =?utf-8?B?bXRGeEI3RFdzckp1ZXNHQTUyMVE2VXFCYnpYRTlLUWNzS05IcnZSZDJrZThu?=
 =?utf-8?B?TWo0Tk8xdzNYYTNIQ3lzWEkwMVlLL2tnZUswTW9lMGdiZ2RINHp3SWdKSjcy?=
 =?utf-8?B?LzMyQlA4Y3ppc2tEamMzb1ZzdXdIaU1pYUszUFZtY0R5a1lDeEpCSkNDR2c5?=
 =?utf-8?B?blZoTGQxcFdKMjBjZlJTUGt1UmUxMGl4eVFyVnZ3aG11R1B2MzZ2OCsxT3Jk?=
 =?utf-8?B?eWp4ZHIzY3NESEs4SzAzMlBZQWFwZDR5RzJmaHBrNmJOem5mdi92WWRYbGgz?=
 =?utf-8?B?K1hXQ2d0KzloTDlLdk5zWDYwVVJDSytIT0RhT0xod1pUaFNTUFNvbUcxZFF1?=
 =?utf-8?B?cC8zS0k0YlJoMEwvQlZob20zU00yOXZGVnQ2Rm5BTGJRVWFVT2l1eGRvamlX?=
 =?utf-8?B?bktJR3l4dURQYi8vMjk0eVVMeUw3L1Fnaktkd09Rb0xLUTdjblBiL0N3UE8y?=
 =?utf-8?B?a2RjTUhla2luZ1N5cGdGVkRVUi8vajRBY3FaWWlCclNiQ1NIeXdhWGVQcnA5?=
 =?utf-8?B?aytqZjhXMVB4ZHg2TWtEK3RjVk9SaFFNdm9oRkNoYW82M1VsakN4VURsajBV?=
 =?utf-8?B?blhKTlNwREdQMXU3S2E4ZmpOeGt2ajZpWkVyRE1jME8yZWhlM0VWeEhldmpr?=
 =?utf-8?B?R3FLMWRicXJvRnVsT1RpS3hvellMaFVsVkhmL3Jsdmg0R0w4Yms2d0lTdldE?=
 =?utf-8?B?MVhVNDJHZ2ZHd1Yyb1lmcnhLbnJ2SDdYUzVweDdGR1A1TXpmUmp2MnZHYS9M?=
 =?utf-8?B?VXZNYzlybnJlOGgrRk1vbllIZVJDUlg0VVlKNlo3TDYyZm11RmFPQ1FXU0Vh?=
 =?utf-8?B?QXhXUklnWnhTdWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1196a6c8-8d91-4f19-3535-08daf0379a28
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4945.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 22:44:43.4573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xk+/p9FRBSBRBCTcH002sE9ro0ftIoCeUzMjzr2yY1psuX8np7DKL9y2Q2JLgsTqMIi6+2xHGwd1IjDnqYEbKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-06_14,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301060177
X-Proofpoint-GUID: xMoKHyYekC3hfLMPGA5e7WP8JazITrJ8
X-Proofpoint-ORIG-GUID: xMoKHyYekC3hfLMPGA5e7WP8JazITrJ8
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/23 15:00, Anirudh Venkataramanan wrote:
> This series removes the Sun Cassini, LDOM vswitch and sunvnet drivers.
>
> In a recent patch series that touched these drivers [1], it was suggested
> that these drivers should be removed completely. git logs suggest that
> there hasn't been any significant feature addition, improvement or fixes
> to user-visible bugs in a while. A web search didn't indicate any recent
> discussions or any evidence that there are users out there who care about
> these drivers.
>
> The idea behind putting out this series is to either establish that these
> drivers are used and should be maintained, or remove them.
Anirudh,

The Sun LDOM vswitch and sunvnet drivers are still in use, please do not 
remove them or the event tracing.
We use them internally and you don't see any discussions because they 
generally work fine (AFAIK).
I think you are also going to break things by removing Sun Cassini 
support, but I am not using it personally.
What user visible bugs are you referring to here?


Thanks
Karl
>
> While the bulk of the code removal is in the networking s, and so
> multiple subsystem lists are cc'd. Here's a quick breakdown:
>
>    - patches 1/7 and 5/7 remove the drivers (netdev)
>    - patch 2/7 removes Sun device IDs from pci_ids.h (linux-pci)
>    - patch 3/7 changes ppc6xx_defconfig (linuxppc)
>    - patch 4/7 changes MIPS mtx1_defconfig (linux-mips)
>    - patch 6/7 removes the event tracing header sunvnet.h (linux-trace)
>    - patch 7/7 changes sparc64_defconfig (sparclinux)
>
> This series was compile tested as follows:
>
> make O=b1 ARCH=mips CROSS_COMPILE=mips64-linux-gnu- defconfig
> make -j$(nproc) O=b1 ARCH=mips CROSS_COMPILE=mips64-linux-gnu- all
>
> make O=b2 ARCH=sparc64 CROSS_COMPILE=sparc64-linux-gnu- defconfig
> make -j$(nproc) O=b2 ARCH=sparc64 CROSS_COMPILE=sparc64-linux-gnu- all
>
> make O=b3 ARCH=powerpc CROSS_COMPILE=ppc64-linux-gnu- ppc6xx_defconfig
> make -j$(nproc) O=b3 ARCH=powerpc CROSS_COMPILE=ppc64-linux-gnu- all
>
> [1] https://lore.kernel.org/netdev/99629223-ac1b-0f82-50b8-ea307b3b0197@intel.com/T/#t
>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>
> Anirudh Venkataramanan (7):
>    ethernet: Remove the Sun Cassini driver
>    PCI: Remove PCI IDs used by the Sun Cassini driver
>    powerpc: configs: Remove reference to CONFIG_CASSINI
>    mips: configs: Remove reference to CONFIG_CASSINI
>    ethernet: Remove the Sun LDOM vswitch and sunvnet drivers
>    sunvnet: Remove event tracing file
>    sparc: configs: Remove references to CONFIG_SUNVNET and CONFIG_LDMVSW
>
>   arch/mips/configs/mtx1_defconfig          |    1 -
>   arch/powerpc/configs/ppc6xx_defconfig     |    1 -
>   arch/sparc/configs/sparc64_defconfig      |    2 -
>   drivers/net/ethernet/sun/Kconfig          |   35 -
>   drivers/net/ethernet/sun/Makefile         |    4 -
>   drivers/net/ethernet/sun/cassini.c        | 5215 ---------------------
>   drivers/net/ethernet/sun/cassini.h        | 2900 ------------
>   drivers/net/ethernet/sun/ldmvsw.c         |  476 --
>   drivers/net/ethernet/sun/sunvnet.c        |  567 ---
>   drivers/net/ethernet/sun/sunvnet_common.c | 1813 -------
>   drivers/net/ethernet/sun/sunvnet_common.h |  157 -
>   include/linux/pci_ids.h                   |    2 -
>   include/trace/events/sunvnet.h            |  140 -
>   13 files changed, 11313 deletions(-)
>   delete mode 100644 drivers/net/ethernet/sun/cassini.c
>   delete mode 100644 drivers/net/ethernet/sun/cassini.h
>   delete mode 100644 drivers/net/ethernet/sun/ldmvsw.c
>   delete mode 100644 drivers/net/ethernet/sun/sunvnet.c
>   delete mode 100644 drivers/net/ethernet/sun/sunvnet_common.c
>   delete mode 100644 drivers/net/ethernet/sun/sunvnet_common.h
>   delete mode 100644 include/trace/events/sunvnet.h
>
>
> base-commit: 6bd4755c7c499dbcef46eaaeafa1a319da583b29

