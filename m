Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE453BE71
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 21:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbiFBTMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 15:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237254AbiFBTML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 15:12:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DA95B7
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 12:12:10 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252HuhwK028854;
        Thu, 2 Jun 2022 19:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dUTse56VtprWLgKkT+7yTWiBKrv5zlTfO/9I7Ui/FpI=;
 b=TLkLZdCaHFdxg+b+FpemQV/qKqdqyrv9KIpA6eNKlJf7PaSex8T+ruDRuWGS5aYG1rOU
 KEfNe2OzZHosGv3UFDg1OxqLVqKE1ItPTiqDfAlRe17jLrSoZAdA5QLlsSqxmxk92Qvv
 /vecSgsqyNAyfuqkcbjU1D5yDydg8SKa+ag7E8gug3+amgmrRK1mYbIfJu9xAdjFKWXk
 ygkqUTI09yCn1PyM+djqSyL/la9GzsQUCLRhS1xRX+WZQMgOfws/QHCw1ewS+zGZ6Iuc
 +kNkkdtB5+VgbQkr+LF0wkJerH4zBENmTu8XXWjGDyL9FUmpRgc7bJx9gth+y/DnFByx BQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7ku16r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 19:10:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 252JAHMT036198;
        Thu, 2 Jun 2022 19:10:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hyfp4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 19:10:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nn5QBbVp7eYXAZ7T4hCUkDYTgt6et18+FaLx/QxzQgHnKNBmUt+Br862F98DNbaib6LpmOZ77LaDlkrYpQMARXbDt7csUisJz8GUL8j/M/yzoACsIM155DQ88XR38zlRC38FFkVKuNBsV1mpZNrWvVgckqyQaXQwJ33znEHftPRGOC0zOryvtWTNFpXalr9ixzMYdY85ANnK01VUkF+hkLUaohPv0S8hSXiXCnzL4Ow2jettkcq8BMURaNIFsh3RVDGUkx9h7DLxeTu9A9c6qz9a9f9KQMESBvihQ5rX4dukVCpgwCxsVczLIvmWJgflZgkuk0Gd5WefdOXDPOupIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUTse56VtprWLgKkT+7yTWiBKrv5zlTfO/9I7Ui/FpI=;
 b=AbN57vh83eYaf2zJoMRvm6OBzQc10I1+v7r+eUC1kfK6ZWO/HVp0KtzmVwjq8pTqC3K2eLlmbDbVznQ1Pqq88SyN4FHev3a7sUaFvg9/e+PTzT6TVnkVnvywXdm2//GlBBCHo3oHth/ionEokkWEMAPOhM+0B4EPYg0SKS4iaYrCImCCgisNKI+JiXajrVqmGN85nsi3pk9slUgLOS2ag+Hfm1yJ570gh9pxny2bCyJe9IkN0nEEFkj3E2WOhsUZuVt0um8eMTzeJztHP/Vss577yPE7VxuTbZoSsnN+lmCwHiVZSqOVjOBgjGCKIEke3H12wO1l9CgQho4/dc1E4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUTse56VtprWLgKkT+7yTWiBKrv5zlTfO/9I7Ui/FpI=;
 b=cuC5Uaan4CJhJH7KxjwtitJdWuM/EMWm+oibFxbDoWZFU3T/gEybBlh0JN4+4ZfKxCKAbbSY3xbv5jHxHJ50UkfvGAym0B9sse9nWK/yf01JJFqSqGuFY2LNct3IFemvtiGgA8rd9Zhc5YWfHP2GL9yQGikna1X+i1FXpHEF3KM=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by BN0PR10MB5237.namprd10.prod.outlook.com (2603:10b6:408:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 19:10:52 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::8477:e4f2:ed5d:8cff]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::8477:e4f2:ed5d:8cff%6]) with mapi id 15.20.5314.012; Thu, 2 Jun 2022
 19:10:52 +0000
Message-ID: <a09fa1cf-b903-75b4-0b1f-a3a3513b2c3c@oracle.com>
Date:   Thu, 2 Jun 2022 23:10:37 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/3] Split "nfc: st21nfca: Refactor EVT_TRANSACTION"
 into 3
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@chromium.org>, netdev@vger.kernel.org,
        kuba@kernel.org, krzk@kernel.org, christophe.ricard@gmail.com,
        jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org,
        theflamefire89@gmail.com, Pavel Machek <pavel@ucw.cz>
References: <20220401180939.2025819-1-mfaltesek@google.com>
From:   Denis Efremov <denis.e.efremov@oracle.com>
In-Reply-To: <20220401180939.2025819-1-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DXXP273CA0018.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:2::30) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c7e0ca2-9f3e-44e1-8dea-08da44cb9bd7
X-MS-TrafficTypeDiagnostic: BN0PR10MB5237:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB52370DC7A2E5DF6BF2A042EFD3DE9@BN0PR10MB5237.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvZU0xUWgRgKrbyCYdUA2DeUOCrWz6BV5wQd0eFpuvc2Arlx6yJvmAAerouDUb3EiEByTg4JzRK4GlzWhIoqmcJm2GoMg0mcMXsqYHSj48bQ9zNInWtBiZagUyqGPXz5Rx+sfRDLhPU5lmiCxeiJjPyrfOBftjWTXNNT3/701iUOdVD2IkagFUz58c80LL10zoLYM9sChcGR/aT74qkpe6ZB+KGfTqgRMZtSyDkZ8wf458+jYXzNrIvr2obkwsxiG+cMM0wtcN0yEX7CoCwowKWdpJxdAQae6YWBkFwNKp+KXf1+8JLFioaV7b7kkdrKc9e3eYqsMCIesexzscy9TnLfEGtM6PfJ0+xSuDEnwG565Mpx2K7KMG++k1rNbCJce97HsiGdT6rlEVMxQN+t1bbzE+lIoXkZ6xUhdr1idpnQLjuEbHWo6GLw5qavfE9q/KQJ+62T1znlmuhE2epHcNE6HSkE5K9hj7lIApvwKkO9DQRRlYtG+YtT/lRxCNVNwVU0PN3RuYVT0OI/tsg2rkUTkpopVjUO5NATBMCsW02+hFcZzIq8S0HjbyIr3kVYWOINJ2gflf/+j4xzfAtQZ/as6OECROToprkCmhlgFiSUEEpon5vXpHDsEcjjYcIK2H5ZHmzonfCZAknxE9PbMHK4i2yL06oxZQN3lm8340k3302sE+5VKA6Gqf9veYU0AVYMjbs8Hbo/dmW7GYcxorxdsKMmuWFwV8JIlRJoiuc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2906002)(5660300002)(66946007)(31686004)(4326008)(8676002)(66476007)(66556008)(7416002)(38100700002)(8936002)(2616005)(83380400001)(6666004)(6512007)(26005)(6506007)(36756003)(31696002)(86362001)(6486002)(508600001)(53546011)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0lXaS82V2ZhdStQK1l4N1pBRVNaVWJRVVpTdVNLZzRESDlidk4rL3RWTVJ5?=
 =?utf-8?B?RHdoaFpTNlkzZVcyWTJpOWVlOXQvSmtsaXVwcVQ4R0NKQVFQaUUzVGVES2Vy?=
 =?utf-8?B?azIzY0hudFdrb0ZEM01WWkJ1ZUVramNaWlhKdEkzQW5NeDl5MUVXbGJRbElZ?=
 =?utf-8?B?TmZhbmNiU29aZW5SenBjdk9FaEZueXl6MEU5dEUzYXVHYmozL281TmVMcWVV?=
 =?utf-8?B?QzR3OURBeW4zN2Q2OHk0K2lVZ08zNmQ5TE1BN0RWcjZRSFJLMWxXU2x3VGgy?=
 =?utf-8?B?YkJaL20xUjB6ZG1KejVTQ05DWFNmNVE3c0p2YlJxczlPbzh3VGl1Sks5MzRK?=
 =?utf-8?B?MlA4WEM1QlFnSDdIcDdadmd0Y2dPT2k2Yk84Wi83YS9WYU9hVG1STnlwdUJl?=
 =?utf-8?B?REE4NHhKZ1k1NjZ6WS91TjJIZWcxZk5PQ2FpRVEzOVJCczJheDEyalltd0lO?=
 =?utf-8?B?RlhPdDRhaDlpbnNyUUJmVFVrK3REaHZzaHFsWjZmU2NiRkdDM1F5a3pPV01k?=
 =?utf-8?B?UXVWYURad2tXNFJzQThLU0VKeS9ESG1JKytObmtaOThXZ216UElQbGdUcCtZ?=
 =?utf-8?B?Sm9TMFJkaEVZMGp2RXNIbDB4Z09RSjlRS0NMRUJVNS90RmJJSklSR1NFSWxI?=
 =?utf-8?B?TjJFUk1EeHNjdzZONDZEc1IzMldmeHA3aU5zTzZXcEg1Q1pDWEdTM1RVeVFw?=
 =?utf-8?B?L3I1U1U2SEs5dmErZVRtUEIwVDBXdUwrbnNhSTVSMVZZNWd6YkxCZGxqOHhk?=
 =?utf-8?B?NXZ2QStycDVWbDBlU3RXOWlNbnpTZ3p6KzhLbmlCTktQVmtBNWhFMnM5aVRG?=
 =?utf-8?B?Y1U5OTNGR2dvZkdOaE1zZjd6MUpZZUJDQ3lLYytSaG9QWGszUkJHcmp1NnZK?=
 =?utf-8?B?VmM1WmhYakp5a3NzZWtSRks4Z2hicEQzQ2RjOVhYRytmTW1oVlJVeHpvMmN6?=
 =?utf-8?B?Rkt5LzEvMk1pMWFFWk1Ucmc0cU9qTDhJb2J3Q1VTSE1XVXhJenhEbVNxcyt0?=
 =?utf-8?B?Z01OOHpuN1lJdnpsbHM0cEVZZGdXNGR6dWNpVzhtVzUra3l3VW5GQU83Titi?=
 =?utf-8?B?K0tuT3hFa3BIYVUxeE5EUG9YcTBZSC9hSENBa0JmMzVnUW1zM1pkcVZ1NDJ1?=
 =?utf-8?B?OEdiVDhDSVVhZzJ0NlpKMG5DZHhmcnp6UE4zT2lta2l6RzMzTjJRNDJoVGta?=
 =?utf-8?B?YUN6cW55ci9BS3MxMGdFekc1RGh5WFRqRmhuMnA4enZMNXh3c0RJZ0oxOWl6?=
 =?utf-8?B?RjJ2YUVrTVBDR1Y4VUREWlJHZUY0RVRGTm1PQlVQR2RiQ3EzTzhQYVdKT2Fi?=
 =?utf-8?B?N0g5QUE0WXpzdWhNbU1FUFJSTk9XckF0ZVRsN2dITWI1dUpSUjc3aG5DcUpU?=
 =?utf-8?B?YU03YjcwbVRheE9NaHpsNDFRNFFHZUdIODM3cmUvWDZCVDhZYlU2TjlaQzA3?=
 =?utf-8?B?ZEtodWJxdHA5SHR4M0NpVDFKQjNYWkx3bWNWbDRycDZCQmtPUko2MnFYYW1T?=
 =?utf-8?B?RDRvMU96ZG5tVkNHQk1pZ1p4Y0FyMktCRDA0M0VIYVZ0NGwzemd6U1dCTkt4?=
 =?utf-8?B?SmNlVDZ4Y2ZaclVRYlJmTDR6djdzSU04bExIRG1kY0JwdGtTRUh0cFA2djRn?=
 =?utf-8?B?YmFyYkJYaVRUZ0ozWFpSWm9ib2lXSnBnVWNqWmNlUnVOYUVETllzZi9tVHQ2?=
 =?utf-8?B?WklTQVZ6UDRkdGx3b0FZUTNaTUJOSklNbzJPQUd6RWZKbU5Bcmd6YjJCWk94?=
 =?utf-8?B?K1BtUkxLTnplR0U0Vkc4ZERGTzZ1d05tdzR3akNWTEhuSU1JTzNPQlZLOS9a?=
 =?utf-8?B?cGtjbWV2NEFHTkdYRE0zVTF3c1FFTzhQR2hETFBxS2hNK0hHdHdrSzBDQXFK?=
 =?utf-8?B?d2s5cjlKVnBNQ2xMTWlheUZwVFpNMUwzS3pSVU1KUzRYTlZmMFl1QndtUGpP?=
 =?utf-8?B?cUt3amY4eDE3RFF4WjVVR1ZndUpER3dqaVNwTzQ2MHR5S0xTblppcGhTNUha?=
 =?utf-8?B?MnBNbjdYTHdlc3NyZHVWWUtFS0pXcDljenFoSzJqRFhWVWRqaEZDVjhYMEZw?=
 =?utf-8?B?TEdYTktZbUttNVNib3BNOERCK0NpN0hiWmVLSDJsL2dvbHh2MXRkclErcnM2?=
 =?utf-8?B?ZUZ6OWpnRmhXTUk5RnREY1FyQSs3QmJxbjFSMDNqQ0QzUDhsQ1BPUTFvYWdT?=
 =?utf-8?B?bVJxMWx4eWtEZ3Y0RDZTY2xjMTZpVEZ6TFh2QUhqZzZKem54N0ZGa2tsTUdQ?=
 =?utf-8?B?T2h5U1A1elBYSlBidHFVbUc2SEhJQXFyUnFKUXJZdnYvSWMwVVFJZlpGSkIz?=
 =?utf-8?B?VVc1S3ZFRVp4MDg0UUxoamgvNkt5VktqcFdQbEwyaTZnVlh4dEFuQ3FteFEv?=
 =?utf-8?Q?TIOMCYeqIzgixxcY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c7e0ca2-9f3e-44e1-8dea-08da44cb9bd7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:10:51.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jBCzJm3oNUldg7w4wUd6uk2bpkfO0YhcJ4r/GI7EWmUQo+qxid1lw91g6pdd2qGgf8VbiEXb0q3+738lMdJGAqNKuMWq3oT2uKPimuQzR90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5237
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-02_05:2022-06-02,2022-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206020082
X-Proofpoint-GUID: 66RaTsPUaM2SjpnYalDARWeFgLnAMhCZ
X-Proofpoint-ORIG-GUID: 66RaTsPUaM2SjpnYalDARWeFgLnAMhCZ
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/1/22 22:09, Martin Faltesek wrote:
> Changes in v2:
>         -- Split the original patch into 3 patches, so that each one solves
>            a single issue. The original patch indicated 4 bugs, but two are
>            so closely related that I feel it makes sense to keep them
>            together.
> 
>         -- 1/3
>            nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
> 
>            This is mentioned in v1 as #1.  It just changes logical AND to
>            logical OR. The AND was rendering the check useless.
> 
>         -- 2/3
>            nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
> 
>            This is from v1 #3.
> 
>         -- 3/3
>            nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
> 
>            This is from v1 #2 and #4
>            Both are derived from the same bug, which is the incorrect calculation
>            that buffer allocation size is skb->len - 2, so both should be combined.
> 
>         After these 3 patches are applied, the end result is the same as v1
>         except:
> 
>         -- minor comment rewording.
>         -- removed some comments which felt superfluous explanations of
>            obvious code.
> 
> Martin Faltesek (3):
>   nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
>   nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
>   nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
> 
>  drivers/nfc/st21nfca/se.c | 51 +++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 21 deletions(-)
> 

Ping?

Denis

