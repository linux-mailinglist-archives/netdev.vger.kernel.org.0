Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F04634A07
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiKVW3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiKVW3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:29:36 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8351146C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:29:35 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMKRIUQ001204;
        Tue, 22 Nov 2022 22:29:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wCyw9LPbFCfcDDjxCZMvNXnKK9naU7bXFbd/jWdY+fE=;
 b=tIGBjHiLbDFHhCjyeM10gTTtzRVhd8GdNMUqqsTY7Vipb82ZOiIae4Qe8LosE/Cn7vYp
 Suezm02PGc2GHpKx3VvhnJHKgJOnQg936oMY+tj05OArjkF2Nw6GAc8u7kio9qd5xEPo
 bWYxydml4hzOxpvB7bjLnngvrb0RSNCWqrAFBy9hiU55ZTRYs0XIUJO/FE3E5tN42xaw
 OF/c0tCwe8EV7x8ojQf7ZpfSfOrsWoK84VN2RdOGU2sDfujfk474WWTg50QRiwT0sTCj
 aeS0gK+BDMj1h8H6Bei9kK5u2s/rxAj9f5s5W707QN8JXL6ElA+s1RKmInjcWQ18Wl6F KA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfb1rgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 22:29:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AMLI3l3008260;
        Tue, 22 Nov 2022 22:29:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk5h52p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 22:29:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf1URPPOM/fI4Sz1PNRK5aCsatDfnAv7DFlCvNEZRx2Yc3tbSiZFd6g6LjVPhC/7SEcRswuNfooOgD0M2GMFjhRrWAOp4mycuvohrO5QJumGJjMc5PHWFFkEyQe09W45eXSIGr2EJttYUkZCiV+rMSjhgi7818ncXawLAe4SjH45Rm9ARlY6S6CddGtZK/tqhsiLr3AQVu6qhjxPdV3v/Yz+mCjQrqu/UeVf7HpcZnlL+moF79AmDScFU4vCbY5mBvUVLJpdZ5sLbVZ60j0TT3SOX/kGRSO6PzoYw146FifsvttnIji9ILHjbchFP9vQsRdsY7DazvT5maPncsKCIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCyw9LPbFCfcDDjxCZMvNXnKK9naU7bXFbd/jWdY+fE=;
 b=B4MYSmoKbPN/vAtcXWjBMSkrqQeUJnb8eKuJUeQ4EuNLolTSvOEIDR49WohebXua2Hge+gi2G+R/H2aFKyJAEwQiOWTgDq11LsDoKpI1QTmlkGqNJgtI0BM7yEQSlgjYbR3jyvHr2yQSQCseN11Bx0MefQB3u1zN0spFPC/D81Gw3S548unWpTuLN6chDQMicDRv4EAcJMYE+VuAqT0He9Sz8PBrOu1ytNG9wGZz7PH5CLityCGTcK3GKZiJ3sL+xvCllvM+KiXEMSRyZh0ee2s7FUG0GqriuM9CK6/wrTReJuwF3brE0w19FZKTYdkY9ZIuwExmHPjrwnB2afbOpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCyw9LPbFCfcDDjxCZMvNXnKK9naU7bXFbd/jWdY+fE=;
 b=n021vuQMuomE1XvmVak1bs4Z3AA9dDPmshSN4T4q4E6rHaAf2IIZ/BiLbQqZwMAAY+cHGoAgiKHwCX303RCPu0xYyrKBS+7T917FDoaZsajFs2NCPJqTdTz1aTa5NPwZD7GU0+jqWs9flhSFzxSZh6/ro6oyiRPcQxoAB5H+rAE=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by CY8PR10MB6681.namprd10.prod.outlook.com (2603:10b6:930:90::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 22:29:20 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5%2]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 22:29:19 +0000
Message-ID: <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
Date:   Tue, 22 Nov 2022 14:29:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, mst@redhat.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
References: <20221117033303.16870-1-jasowang@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221117033303.16870-1-jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:806:27::25) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|CY8PR10MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: fc5d7a30-934d-439b-e85e-08daccd8feb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTU4lXl+AEfkMSxKZBYbyjL5MCspCinAbkttxAqUksAsD2JoWe9pwAR7zK//SG+OUc5+AX5Td9MsqZrJxuHiCpnEqgZ5X/2FGNZRQGD+SZM8BeBYE/KAh7mGquZFh8KJJNay2kbnX4W5peJVYpQz7LYe/jIzeStv7ILmL5Y1y6mYBvom82vo/TXmBfZJ3f1/5xRs1ohILWWv9g7C0uedOs0VIRAxHXR0bY+NHLrgTa96BCaAX1DaG6hwdT0DbiQrufphqx556wP6+WBxo8hT8aNjAp0ELGUchGWxSBTd9kRLP7g35T1B7pj+EFEHHkqpbDqD26IP8PJQH+63TNbu/y2BkVGEThWulUebL4bxPrpTUU1EEBGNeAUiEXuiCdS35UuiwUrHbEzcc6lLPKFcbMU/XKD6DrIN4JZLipZocM+xCQrnyHZ/+CgYX1qQr7YVSy8bRikkR8xocX+7ttGkNiGFLf3Dj006LqsZoiZuSMWYxQu3lrdCL2gtqniLtTFiGpcOvs+rXrpjDNvDhAZm7bK3+fblBWmo/SJaiYSZ5KoxnW7yBcHljGZ44Wz+izDBj7xooxwO4iJx2UMg5OsLalZvcrjKHXz5p9hYaGXauIAOiSHOwNeYomx+7UGriw2KRWjjmNnEhYSwi7lruSKEMVD1ef+pmuVNfnuIrqHGBVrIVDFhvRyfP7HxxsG9/kDTUmf/oYVTUAop1Mz5qrsCSQzBKp7dY85GpPgQZsSKfoC46QOiD9i/BwD9urX82+/K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199015)(8676002)(53546011)(36756003)(8936002)(6512007)(6506007)(26005)(66946007)(4326008)(6666004)(478600001)(66556008)(66476007)(5660300002)(316002)(31696002)(38100700002)(86362001)(83380400001)(36916002)(6486002)(41300700001)(2616005)(31686004)(186003)(2906002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEI0TjVwWVp5TDVjSGdWaFZETWFCNldkN1phUWpvU1FXQ2MrdU9JYkNJeWJM?=
 =?utf-8?B?UFhzcE9aQTRvS2hwKytvQjNlSm0wTFNOeCswM0FTZW9TbzQ4UTV4TDV3MnZo?=
 =?utf-8?B?WHluQkNUcGZYendvYWdDZzBpVHo2SG90TzBEUG9pYnNHUURFZ3VlMXhuREdR?=
 =?utf-8?B?eXMrQVdMeXBzbnFJWVZWS09NNUVWSmZzV21MZ1IvUTBmeGpJMURrRm9rcWFO?=
 =?utf-8?B?dFp1Nm1VRUZJR3laMU1hU1JyYUhQODlWc0Z6UzRneHJ3cEk4ZzBBUFFLTGpq?=
 =?utf-8?B?cG9LS3RWbGFNVERXODRVemJBN1FaYmI4UTZ3SjA3eFF6aEp0VzJuMU1tM01s?=
 =?utf-8?B?QnNQYUlldVkwMUlWMWcrbkZMajVuTTdYUU1BSExDZjJpNFdVc0lNMmNCWktl?=
 =?utf-8?B?dE1Tb1JFemV2YmhPTXdZQzJtRmlZRmlTUXZQSGVkdDBhTUIySC82TEtIUW43?=
 =?utf-8?B?WTg3S3ZPREg0YlZUbFk1cjVtOTNXVkc5UHdIelJIMFNQcjZCV0pCSFVNaDBF?=
 =?utf-8?B?dGkzMVZrd1RCL0RHY3ozSHhkL01ZMjZoYysxNUJrT204dDkrVm54eTJMUDlP?=
 =?utf-8?B?bFdvREc3bFQvVXZ0alYyVWgxdjRPM3psTlZlbm9WSCtLc3REck1OdDdwUlpK?=
 =?utf-8?B?Q1JPUDJTTFNiMUM5aXB0OFFOQVI2eDA5a1ZUZDVaYTR0ZWVUOGtOODhZNi9W?=
 =?utf-8?B?STZXajMvUWFUcjkwYURMWFd4TTc1Y01oNWN4WTZuSnI4TG5GWmRWUFp0VXdU?=
 =?utf-8?B?a1NrZXJ1VDIvVGxQUS81UFI2MW8vd3liS1Y0TlFjZnRvYXY2bFlxT3lBV09q?=
 =?utf-8?B?MHFxL0FKNS9kelhZSEJuRkNLNzFMSk5zbHpERkNmcGRwcXU4MHBUUlB2OVlM?=
 =?utf-8?B?enhmamUxdlJTTitCTDVSaHdTd1dnWHhCVFBPYUdiM0Y5eENTR2ZEVlVRbWJu?=
 =?utf-8?B?ODlOeXBacGVYK3c3T2w4UEdZN01Ra1loZlE2UkF6VXJqZ0RZazB2bnIrTE0w?=
 =?utf-8?B?UVFnb2l2Zy9oekp3TEJia1ZnaG8vOVl5SVJ5WG9WWHNuUlc1Z255WWd4b3RT?=
 =?utf-8?B?Q3J2Q1VMWHJMUEJlNllCWWhJWjcycnkrMXQzYXpzUmpJWldoS3FRa3ArejQz?=
 =?utf-8?B?eTd6MSt3Y1VOQkJhb29ZS0JydnBRNk1jcE9CQTJlVUlNV1JuUWpyU2tzdHJZ?=
 =?utf-8?B?eGFnU1pRUVlOLzVQVThRZXErMlVFcG5RY0NhNnp5cGhSRjJvYVFiRVpwSkpI?=
 =?utf-8?B?c1VWY3NLbEpvQXZMak54c0M2L1c1SkxxVFZucVc2Nnd2aGx1Mm5yVDJoOUJ6?=
 =?utf-8?B?R052YlNBbUlqVERWdlhPVTY3UythQ09mYVZORVZBbW85YWNZVVhZMjZRcnhw?=
 =?utf-8?B?Y1NFandZOVk5bzhHelBOL0lrbVhBLytxRUVpaEJWTTFBclR2dlQ4NnlZYitI?=
 =?utf-8?B?T0RDSW82R3dZbkl4UDNZRkJOcWN4NXRWS1V5ZVFKLzg5ckhPOEhLUEpad0VQ?=
 =?utf-8?B?Y3RrcXpCSkdjc281K08wTjR0TlB1bXZHb0hSZGw4K1VMSEhLUlVKYTR5WVZa?=
 =?utf-8?B?QTRlRzVKZzl0TkZPTy9hVE1sM0JhN2JsK2dWOW9YeCtBTUhPenZ3ZkhlNjhZ?=
 =?utf-8?B?TlNnUUIvL0tkVEVPUTQyczRzWi9rSVhvdGMyV1dhQitnaWlWcG12Z3lIb1BP?=
 =?utf-8?B?eU5NS2NmcnU4a21hdmhKczNZSHc5TXhjSzZpaDZmTlBac296eXFha0hwQ2Q0?=
 =?utf-8?B?YTBYL2xPR1pBdndmNmRPM2ZpeXovVTNwb2o1b3dFVEF3WU9iRnl2bG95OGpu?=
 =?utf-8?B?UjFVODNBRnRrRklYNzhBSGhqZzZldUFFVlpscGthTVd1WFFFMThQYUdRVkdO?=
 =?utf-8?B?dnNMN1RhSTQ2NldFUVN4b2pTNGtYUjVuKzVLOGF6Q2k0elFmdGQvcGF4RVJZ?=
 =?utf-8?B?MWFZdjBhOWQzVUl5bm43bEt3YmZkVUJwRFdwSXkrNVhtditRNjMzVVh6S3RK?=
 =?utf-8?B?S2dLV3pwejduSGoxNmZjdjFiREV0SFlUWkEwem5yY2owSzB2RG5HLzFtTVhk?=
 =?utf-8?B?SEhsUE9lQjNpRHNUVXdCaUY4cWVtcTJXZkxPZ0xhbjlEL1ZRYmNaZzF3QllY?=
 =?utf-8?Q?zyALe7R36mvP3fGWtQxa78rf9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d05vVG9SK2J5Z3FCQzJZeCtRQXoxUmppc2lmQ2xwMDNqQldPQkV6R0lCLzVL?=
 =?utf-8?B?TmMrampBUkpnN1ZQTFh4YUc5MXpsaUJ4aWI5UndXSDNMckM5MmxjWUprcWlp?=
 =?utf-8?B?TFpLL2hmamYwcVhUa3c1RENONVBQNFpvUWN6dHJSdHZueTRQS1ErVE5nT0tK?=
 =?utf-8?B?dTZrK0MvWkE0d2dZV0IwenFlanZTc0Y4elcrV0VwNG9VOURTV0g4U1U3OFBy?=
 =?utf-8?B?ZjV6eGdhWlU0MUpkTE92aHJSVnZyTmoyc1FlLzVjR1FtVndrUFAxckRPTytO?=
 =?utf-8?B?aDRSRlYwaTN5OEgwYlAzQ3FNUStpNHdiejRmNnlkVUlaRGRSVzZibEpiUjVH?=
 =?utf-8?B?NXJhSVBwL1FaLzRSd0hsQ0J6eDUxTGxldXBjQWtGRGNmcGk3UVRTTmk2VEgw?=
 =?utf-8?B?L3hYdlNpazNzejlyTGE1Q0tCWENqdzJoSEwzM0pRQ0ZENVp2WkRNOWhZUlpP?=
 =?utf-8?B?eTVvNnp1ZmNGV1NXRkMxZGR2SWJUNVUxQjdPb0NvblJHR3ZYOU95ZGlsaFpB?=
 =?utf-8?B?WnJRV0RsdiszT2pFQ3E5eVVvNzgxdzlxcXRpNHp6VEpuZ1JLaStHNW41WGph?=
 =?utf-8?B?Z1NIS2VrK1ZqcHE2Wi9IRHdwUlNzM0xHUGVqcWNLeUNwbEdubis3QUt4MTdH?=
 =?utf-8?B?Z0JxVThaV2VZcXZzR29DMFNDdFI3T1JWaGt3TXkrYnJnYzhRaE5wUTF2Q0R4?=
 =?utf-8?B?cU9KZ3JMQ1JlUG9tTkdQV3ZYZFRZSzZQcG9Kek5XMDhJUWUvaUl5OWJtQWdz?=
 =?utf-8?B?czNyYVZDQkdHdjRQQXlNTjVFemZzOGMyUUtVNVpKZzhNMUZPVzZndzJMSFN2?=
 =?utf-8?B?bDBNU3lLb2NzbmJVOE51TnVmWFliQmZSTCtMc09uVHFldThsQ3JMWTllUXVz?=
 =?utf-8?B?WjhSdU8vWk10QlZHbXJEVjZxVjJwT28rT2lyVnBpYUdFUjV3Wk5ubHpUdVJn?=
 =?utf-8?B?YUpaRUtDVUZNRyt3cUtTTjFkTlZzS3hRaXozNUV1aHoraG5PUXZEdWlsYmh5?=
 =?utf-8?B?UkN4bmhPZjNlcG1BemMxUDZYbW91MEVmN25iMStpUmtnTElrOW40WHE4WGh3?=
 =?utf-8?B?WldCaHpxWlkwTXl4TUVjZVl4SFhhM1M2YU5xQWo1cDJOTmFocGtWbTcyZk1T?=
 =?utf-8?B?TTJsN0V4a2YzUndiSlhkOEtid1FXclVkVXd0U0JOdXBZSWpBQjM1b3JWbUc2?=
 =?utf-8?B?b0ZQSTVQbkN4TWJXQ1N4ZjdLZ1hsdC9ORGZ6eUNxQk5JNFl2S3VXM1Y5YmJZ?=
 =?utf-8?B?SjYzRGVYUXJHYUJvVDkza2c2RVRnRlo5WWROd0J3SDdWSzk3M3JjR0xhWEFR?=
 =?utf-8?Q?yMpi7wdqhrb2UrGE1Y0/on3MNA6GpwY+Rs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc5d7a30-934d-439b-e85e-08daccd8feb9
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 22:29:19.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ii9rtDcw8AgOPh5zb97Dkhyuz7m2xQw+7M07o0lgglwhGyXxf0DLDasMRBXDErXgAGAuBW/HNTRTgvKlbnGNig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_13,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220169
X-Proofpoint-GUID: X4_9v6S3eiT4c0k29XfgNT_5GPOdS0_n
X-Proofpoint-ORIG-GUID: X4_9v6S3eiT4c0k29XfgNT_5GPOdS0_n
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/2022 7:33 PM, Jason Wang wrote:
> This patch allows device features to be provisioned via vdpa. This
> will be useful for preserving migration compatibility between source
> and destination:
>
> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
Miss the actual "vdpa dev config show" command below
> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>        negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes since v1:
> - Use uint64_t instead of __u64 for device_features
> - Fix typos and tweak the manpage
> - Add device_features to the help text
> ---
>   man/man8/vdpa-dev.8            | 15 +++++++++++++++
>   vdpa/include/uapi/linux/vdpa.h |  1 +
>   vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
>   3 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> index 9faf3838..43e5bf48 100644
> --- a/man/man8/vdpa-dev.8
> +++ b/man/man8/vdpa-dev.8
> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
>   .I NAME
>   .B mgmtdev
>   .I MGMTDEV
> +.RI "[ device_features " DEVICE_FEATURES " ]"
>   .RI "[ mac " MACADDR " ]"
>   .RI "[ mtu " MTU " ]"
>   .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
> @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
>   Name of the management device to use for device addition.
>   
>   .PP
> +.BI device_features " DEVICE_FEATURES"
> +Specifies the virtio device features bit-mask that is provisioned for the new vdpa device.
> +
> +The bits can be found under include/uapi/linux/virtio*h.
> +
> +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit values.
> +
> +This is optional.
Document the behavior when this attribute is missing? For e.g. inherit 
device features from parent device.

And what is the expected behavior when feature bit mask is off but the 
corresponding config attr (for e.g. mac, mtu, and max_vqp) is set? I 
think the previous behavior without device_features is that any config 
attr implies the presence of the specific corresponding feature (_F_MAC, 
_F_MTU, and _F_MQ). Should device_features override the other config 
attribute, or such combination is considered invalid thus should fail?

Thanks,
-Siwei

> +
>   .BI mac " MACADDR"
>   - specifies the mac address for the new vdpa device.
>   This is applicable only for the network type of vdpa device. This is optional.
> @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
>   Add the vdpa device named foo on the management device vdpa_sim_net.
>   .RE
>   .PP
> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
> +.RS 4
> +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
> +.RE
> +.PP
>   vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
>   .RS 4
>   Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index 94e4dad1..7c961991 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -51,6 +51,7 @@ enum vdpa_attr {
>   	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>   	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
>   	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> +	VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>   
>   	/* new attributes must be added above here */
>   	VDPA_ATTR_MAX,
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index b73e40b4..d0ce5e22 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -27,6 +27,7 @@
>   #define VDPA_OPT_VDEV_MTU		BIT(5)
>   #define VDPA_OPT_MAX_VQP		BIT(6)
>   #define VDPA_OPT_QUEUE_INDEX		BIT(7)
> +#define VDPA_OPT_VDEV_FEATURES		BIT(8)
>   
>   struct vdpa_opts {
>   	uint64_t present; /* flags of present items */
> @@ -38,6 +39,7 @@ struct vdpa_opts {
>   	uint16_t mtu;
>   	uint16_t max_vqp;
>   	uint32_t queue_idx;
> +	uint64_t device_features;
>   };
>   
>   struct vdpa {
> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
>   	return get_u32(result, *argv, 10);
>   }
>   
> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
> +			     uint64_t *result)
> +{
> +	if (argc <= 0 || !*argv) {
> +		fprintf(stderr, "number expected\n");
> +		return -EINVAL;
> +	}
> +
> +	return get_u64(result, *argv, 16);
> +}
> +
>   struct vdpa_args_metadata {
>   	uint64_t o_flag;
>   	const char *err_msg;
> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>   		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>   	if (opts->present & VDPA_OPT_QUEUE_INDEX)
>   		mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
> +	if (opts->present & VDPA_OPT_VDEV_FEATURES) {
> +		mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
> +				opts->device_features);
> +	}
>   }
>   
>   static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>   
>   			NEXT_ARG_FWD();
>   			o_found |= VDPA_OPT_QUEUE_INDEX;
> +		} else if (!strcmp(*argv, "device_features") &&
> +			   (o_optional & VDPA_OPT_VDEV_FEATURES)) {
> +			NEXT_ARG_FWD();
> +			err = vdpa_argv_u64_hex(vdpa, argc, argv,
> +						&opts->device_features);
> +			if (err)
> +				return err;
> +			o_found |= VDPA_OPT_VDEV_FEATURES;
>   		} else {
>   			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>   			return -EINVAL;
> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>   static void cmd_dev_help(void)
>   {
>   	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> -	fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
> +	fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
> +	fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
> +	fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
>   	fprintf(stderr, "       vdpa dev del DEV\n");
>   	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>   	fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
> @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>   	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>   				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
>   				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> -				  VDPA_OPT_MAX_VQP);
> +				  VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
>   	if (err)
>   		return err;
>   

