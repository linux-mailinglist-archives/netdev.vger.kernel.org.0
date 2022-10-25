Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF8F60D2B1
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 19:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiJYRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 13:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiJYRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 13:44:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E5062C2;
        Tue, 25 Oct 2022 10:44:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PGDQaD012990;
        Tue, 25 Oct 2022 17:44:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=nvTwcpeb48UH9OKN2p2xynoxH6i3GxQkeeiIn7Wq0QA=;
 b=C/qx8C347iZ/PM/VllI3pX9fF034SGYsmH9SzohmGSozfgJ7iQConM6UfVJGgf/g4C0l
 YkrgU4OW+jJQ+FJk55QciRvyulQAv0gUqpR4W+JRTOZl7/yrVVP1RWZozkmrjX4KB1ZE
 yH9ZNEr7wk2mvtr1YDPkk928RYk3EipJalFRGvB+atD0CYzQxqGljOFmUPytZdgrnn22
 cK60Hjg3dK84itOuC74Q+AWIN5M6AyXqQ3a/9ypId6+vCFD8mhulwUVd4PQNuzZ1OvxO
 0B+u9ivNBO9bvbq9f+s9dfyIu27ATCVD3xXwxrguBmo1lZhmMDEygd5UOM006jlDW2jM aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc8dbm2p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 17:44:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PGPxI9012752;
        Tue, 25 Oct 2022 17:44:18 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2048.outbound.protection.outlook.com [104.47.57.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y4v5wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 17:44:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4eA0w8tgNrnRqjgETGEureB+tCwgttc2bkcNPVvpp5L7y2ZZhv2i6y5IvRPYdOpIi+u9J2igmYjdK9+QuIl4ZcC/ZjN5qnkoiaScE1XolzZ3duCZ2AV1inRS45w8dCJMsXxT8QEsjVTFZ60NvMLkYtEHOhRmn3WrlLOi6/vDMBfJeQn5ylWmzvd0CGa8nSxCEeqAQqKqSPIlFMFtqIgtM4qtN6g2OCmKk1K5H2O3ttBDVNTUhBd4sWffA5oEH1tBSm0OxyRuuCF+C9P4+m+aQS0YNZDUy1cBVDT4d0W2UGiX8wrmaCrLiL6MR+KWFaPyCUwBtiuQ94DYMbStUTw6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvTwcpeb48UH9OKN2p2xynoxH6i3GxQkeeiIn7Wq0QA=;
 b=QYaQ4IN2gqhgais9P6HFjCHGdemWMfo37TJ+vYWOSh9sxILG+WD2VZDg3mARhh5ZFDfwi/bKsGrXHRJsgwPx20GZslmQKIcWgu1iPLkifuM257SkPj/D7y2wIQ5AMj+xlGo/2XenmDLSa7duEnRz93WC0tmm9bnvzzGjU9XaRFNZ/OkgymiLW/R5Y6pxs1SvUPawz+rQ+DxaAtDpr1Gol6r13enyLhOQEvSqLoFuAYfy/SpH3+bbQrVvvaksUP8yqLtZyogGr/l18Z3sWkdCzlVQrcGrGYRjqIrBslQk1zXUT09jJoAqvpUc2teB8hgjOmNu0KktxJcN39tNClIuiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvTwcpeb48UH9OKN2p2xynoxH6i3GxQkeeiIn7Wq0QA=;
 b=YuTIHxB8m0HC8q9/2HR9916Wmm/1M0nBfwlKSi/iSO6uBpHKgjBG9nwEDtrrZrl2R3QzjLvKrz+DOwc1PDSrQBNefts3HPXO1TV1Xi6ZIK2p4KKN43UTYA6n++pBJSBr+SneyPEpzSfm3qqtXrdxdOH7HBkov/5BKYv8SEfcbCc=
Received: from BYAPR10MB2997.namprd10.prod.outlook.com (2603:10b6:a03:90::16)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 17:44:16 +0000
Received: from BYAPR10MB2997.namprd10.prod.outlook.com
 ([fe80::fee8:36cd:5e78:f1a1]) by BYAPR10MB2997.namprd10.prod.outlook.com
 ([fe80::fee8:36cd:5e78:f1a1%4]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 17:44:16 +0000
Message-ID: <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
Date:   Tue, 25 Oct 2022 10:44:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.0
Subject: Re: [External] : Re: [PATCH 1/1] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, manjunath.b.patil@oracle.com,
        rama.nichanamatlu@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
 <Y0UYml07lb1I38MQ@unreal>
From:   Rohit Nair <rohit.sajan.kumar@oracle.com>
In-Reply-To: <Y0UYml07lb1I38MQ@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0104.namprd04.prod.outlook.com
 (2603:10b6:805:f2::45) To BYAPR10MB2997.namprd10.prod.outlook.com
 (2603:10b6:a03:90::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2997:EE_|PH0PR10MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fa60b70-6913-46bf-64f7-08dab6b0896f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JyiUHOM1JopCstoXQuurBf+8hZ2emWq1ZndjzQ+0NGmSMC632jJA/sAnWtWS4zYRXr4Ee5C1pvOcDE/jrby4GhW5geePAzF/yJ4/+kTsjo+vo//HMFtBpp1C9j6VreLqVKBf8DEI3PuZ2Mtqz6GBFQSfQaab1Q3aH2231WwbLiLIwj69PnliIc0V9CYQjtSCXoo+YaZQVFe0vV3IGsNDtjmR8+wXvS2CRuqCxaihIma2tLML2XiWnU1Jcl8+A/aIsFz90VFi6UJSsVC/js1mZ8g4OQOrTrMvUxosZRBfLnFiD2O5jISYRc4rX2VbWTgHt9yIcl3Be0A/ocOAjFw5dbjQj8EeGXSqV1Rr34yZEAwiYDTN6fCPCU4SMCDHN6q/DqHAeeKW1otWgOsedUD6V06W08e909zPOkL20Nf0xjgb6KpSTWInz1ui7ezfqi8QBbynkBO/puT4M3h00lzJrsE9B+7txLmjBs2BnPkra5wzfy3oKkA/EIOJF89lVCh6qcirHdPdwyZiIfh23u67g2azxB5F5syzLuO+UoMRLcB+Zf+RRnOFRXu1dFGN9mMuJuqK5E0NgJkOiLtdGZIU4RHHc2ZMFo4wwKewUQM5zrcQlkMPI4CkLu/5QhgQ5qC7iekJZMlEwDiiHg1R42ZoXsbUMtE0kas5QfQU0XDXpTc5+81L7hehAxHS7lLIW8+i67xbJXx4e4OZMtpw82TfUNQQ2tTQ73krxNR9Th2S/cvWBcX4yvGAAPEwkMb+vQw9WA+aYI9GZf8zsNvxK0X3gzOFx/gU9ho0nC5xBzI/Zcg7K3llzMvhtg3elSI557UBUSPP491jzEDi2CXO0ZDFUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2997.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199015)(31686004)(6506007)(316002)(53546011)(6512007)(6916009)(36756003)(86362001)(7416002)(8676002)(66946007)(31696002)(66556008)(66476007)(4326008)(5660300002)(41300700001)(2906002)(8936002)(6666004)(478600001)(966005)(6486002)(83380400001)(38100700002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFNtU3hIRy9TZ3Mxd3VHMENabmtVTDVjLzFNamtIaDI0dUhBaTNiUXovRDBr?=
 =?utf-8?B?TGhhUzBxbHdHWm1uYm5JSGlpSDN1ZmtiTHdtWHNLY0dLRytmN2ltRWg0dFkr?=
 =?utf-8?B?dm1EaW9XY0k5R3VJWWhTUWZ5TzdKcjhEV2RrZVpiR3ZJUm1DYnpWeFliREE5?=
 =?utf-8?B?allFODNtcnozRU4wREw4eGpZdWpHd3o1SXcvQkhkcWg3UDA1NERwYjJaUU82?=
 =?utf-8?B?Z09EK3g1TWNhcitwMTJiY2N3a0hDa1lEL3F1cE1CemRpRkZoQnhxUFByWHhm?=
 =?utf-8?B?R011R3dzLzlCSDdSL2lLMmcvS28wM0xNR2dVU0cwdFZDSWd0MElmdU90UlNE?=
 =?utf-8?B?T2tpODYwZHpqT2YrcjZwV1hQYkFDendxdmtBUUtMTjRNQ1kzd1l3cWVSaUVW?=
 =?utf-8?B?STl3aHQwZGRCTUYwUnBodGtuKzgwVlV3VzB5cUFvaWg5cXVWQ01pczhuSVkv?=
 =?utf-8?B?MXNSandUUnVQK24zMEhLclBmazlrMUVGekVBS1JXb0xXbmxXR3Q5R0VCc0VS?=
 =?utf-8?B?Z1RsN3FJaVcvZFdtbU8rcDV1YURpbVExUFB4SlhnN25HejFJckVURGRjREtF?=
 =?utf-8?B?Q1RuM0U3RFNiSm50RGFianladlJ6WVZFc2crbzVjTUNmRWc0VmQ2cE9uSWhn?=
 =?utf-8?B?Tm8rYWNubWVYa0JmZ0RsZUY1QmdOZXdkYURqdWtReEJHTjB1ajRzL1ZiWFN1?=
 =?utf-8?B?aVRLdkh4MGQ3Q0Rmb2xvQnFJYnAzYmhIR1lSWnMyU0Zsd1d3eUUwZFU4N1pO?=
 =?utf-8?B?RGhNWUc2NWVaSmwzSEl2TmxlanIyRmJBOEVnV1Q1dGJncjVkUU5tc3IvczFt?=
 =?utf-8?B?Z0dobjlUa0xhbWt4VXlwdlk4cm9qNGV4R3F4MVoxamsrWkRkZVFtaFp3RVU3?=
 =?utf-8?B?OEZaNkJVNHFSdTQzdUpQbkJDb1BBWFZmejBpVmdDOTAvdjZwRExYRW1LMzFh?=
 =?utf-8?B?Q0FSSml5UDNZby9TdTFwMW93RHBtdjIxOGJlYy9nTDZWOStsT3hkbWVqSVpa?=
 =?utf-8?B?KzNBbVUraHRBdmhvSVBWbUhGV1o3RFpNVU5SQ0tNT3VBKytJRjZOOU1jbkVX?=
 =?utf-8?B?ODhzWnB6OERuTlpXUk91SUJNRVhoZHpLaDljUy95Uk44bUp5NVBqZERMNnJU?=
 =?utf-8?B?S05MWFJBcWV4K0Zqa3hWcHduSkRheC93L3FDL0ZjY0h3cE1IZG82YVUwR2NK?=
 =?utf-8?B?bWU2OGF2QUNDRlhTWUVKSzZKOTE0WGR5WHdVWVBhdDA2YzVVZERMZ2d3ekJI?=
 =?utf-8?B?Sm1RUXkvY0dLYm1laVc1SktrY0FEREhvaE1LZlNlbFhzYm1YdHV1VlE2clpI?=
 =?utf-8?B?NWplenhEZ1RVNjg2YmtEckFpaGRVMEh3YnpRb2o1Mm1QTDVPc0VHTUcvT0Fo?=
 =?utf-8?B?UlNGS05lVWRKRVJRVWFzNjQ3dXV0cGdTTXlRUm5GR2h2c0s1TnlVSzVjUUx2?=
 =?utf-8?B?d1hJUEc3UC91ZVhYNjlaNzkwa0RQcFFRVkZ4MDZDc2VyR1l5MzBsV2ljWW1y?=
 =?utf-8?B?dG4xNVpSbEhiblRsbnRsemNlTTBEcDNYUkR1OUx5OHNYOVdvWjEyVEFZWGZj?=
 =?utf-8?B?b3d4K0lJYnhuQ0x1OTZrMDdjcnNlaDhrVGkyQThPTnlKSkRHdGFLUW1iT295?=
 =?utf-8?B?YVAvM0xHanBEK01VbnhrYVU3bWpHUVR4bmpSbnhxZUw5SC92bTVaYi8xOTVl?=
 =?utf-8?B?bjdNcXl5SG9WRVdDMW41UklDelE5Sjdjd1BHRVdjRDJPcSt5QlJaaGRuL0Z0?=
 =?utf-8?B?WmlPWU1qV2xzRk9RY0hRMGxZcmZlWVJvQXF2cnJYTExvL1lzV0FkY01JRitG?=
 =?utf-8?B?MmNsNzh0eFA4anpBblVNVUUweUt1NWtiN2NBb25BVGE0eXNpVVkxZXAzSVI4?=
 =?utf-8?B?NVY2ZUhQcFY1Ri9LYktUemJ6ZVNkWjlvM2RhUmdENnR6N1ZBVzFOSVBzSlVE?=
 =?utf-8?B?SDRHckRXblB3eWRMSUhjS3FybWpCQy9HbzJhd3NLdVJ1WVRsR3JHQ2NlV2Jt?=
 =?utf-8?B?YTd4SldkNFIwT3R4d3IwTnFNbm5uRGhiU2pkY080aFovRW5kT2dJc1V0Tnk4?=
 =?utf-8?B?MGRFUlJXTmNOYU9GNXNtVFkzVkI4K2VPYSt4U2JCU0ROcGQ3RTNDa1I4Zys1?=
 =?utf-8?B?TjVnTVRZbXFlQXpNaGRBKy9vbEVnb1BDbGVGVmhoR1dNZE9CQm5vZHZ4SWpP?=
 =?utf-8?Q?a1hHtKDouck5jSLNw9vJEHQbWyNysUK0ik1wFKx4MJXz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa60b70-6913-46bf-64f7-08dab6b0896f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2997.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 17:44:16.5280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gg+v/bGoBo5ZTGYPkMnWiB+NyP3QykeX1Z0xqtFkBFF/N0jh9bBxa91zBsnx3VzPJlAsOlvJHkTiy2VwQ4p70do1/tvTU7h2MLZNHSFJUek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_11,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250101
X-Proofpoint-ORIG-GUID: 22kjfJAjmnYHuAZia4NgDU0Cs498YMJ3
X-Proofpoint-GUID: 22kjfJAjmnYHuAZia4NgDU0Cs498YMJ3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Leon,

Please find my replies to your comments here below:


On 10/11/22 12:17 AM, Leon Romanovsky wrote:
> There is no need to ping anyone, the patch is registered in patchworks
> https://urldefense.com/v3/__https://patchwork.kernel.org/project/linux-rdma/patch/20221005174521.63619-1-rohit.sajan.kumar@oracle.com/__;!!ACWV5N9M2RV99hQ!IdRYzr4ujJ0haaWRKGd05SNbDiiW4v85yzCS233IObdO6ziwUhmEpWBC73PMs1dwbjwL5qHv9YwJrmKNtIo$
> and we will get to it.
>
> You sent the patch during merge window, no wonder that none looked on it.
>
> On Wed, Oct 05, 2022 at 10:45:20AM -0700, Rohit Nair wrote:
>> As PRM defines, the bytewise XOR of the EQE and the EQE index should be
>> 0xff. Otherwise, we can assume we have a corrupt EQE. The same is
>> applicable to CQE as well.
> I didn't find anything like this in my version of PRM.

The PRM does contain this information and can be seen on page 121 of the 
reference manual. I have linked the refernece manual I consulted for 
your reference.
https://network.nvidia.com/files/doc-2020/ethernet-adapters-programming-manual.pdf
Here is a short extract from the refernce manual: "Byte-wise XOR of CQE 
- signature protection (see "Completion and Event Queue Elements (CQEs 
and EQEs)" on page 156). CQE is valid if byte-wise XOR of entire CQE 
(including signature field) and the CQE index is 0xff. For 128B CQE, the 
GRH/inline_64 section is taken into account if data / GRH was written to 
it (cqe_format == 2 or grh == 2)"

>
>> Adding a check to verify the EQE and CQE is valid in that aspect and if
>> not, dump the CQE and EQE to dmesg to be inspected.
> While it is nice to see prints in dmesg, you need to explain why other
> mechanisms (reporters, mlx5 events, e.t.c) are not enough.

We had recently faces an issue where the we failing to arm the CQ due to 
an sn_mismatch. This issue was not reported in the logs or error events 
and was the same for the corrupted CQE.
If we were able to dectect the corrupted CQE, or EQE earlier, we may 
have been able to respond to the issue better and in a more timely 
manner. This is our motivation behind have the error printed to dmesg.

>
>> This patch does not introduce any significant performance degradations
>> and has been tested using qperf.
> What does it mean? You made changes in kernel verbs flow, they are not
> executed through qperf.
We also conducted several extensive performance tests using our 
test-suite which utilizes rds-stress and also saw no significant 
performance degrdations in those results.

>> Suggested-by: Michael Guralnik <michaelgur@nvidia.com>
>> Signed-off-by: Rohit Nair <rohit.sajan.kumar@oracle.com>
>> ---
>>   drivers/infiniband/hw/mlx5/cq.c              | 40 ++++++++++++++++++++++++++++
>>   drivers/net/ethernet/mellanox/mlx5/core/eq.c | 39 +++++++++++++++++++++++++++
>>   2 files changed, 79 insertions(+)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index be189e0..2a6d722 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -441,6 +441,44 @@ static void mlx5_ib_poll_sw_comp(struct mlx5_ib_cq *cq, int num_entries,
>>   	}
>>   }
>>   
>> +static void verify_cqe(struct mlx5_cqe64 *cqe64, struct mlx5_ib_cq *cq)
>> +{
>> +	int i = 0;
>> +	u64 temp_xor = 0;
>> +	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
>> +
>> +	u32 cons_index = cq->mcq.cons_index;
>> +	u64 *eight_byte_raw_cqe = (u64 *)cqe64;
>> +	u8 *temp_bytewise_xor = (u8 *)(&temp_xor);
>> +	u8 cqe_bytewise_xor = (cons_index & 0xff) ^
>> +				((cons_index & 0xff00) >> 8) ^
>> +				((cons_index & 0xff0000) >> 16);
>> +
>> +	for (i = 0; i < sizeof(struct mlx5_cqe64); i += 8) {
>> +		temp_xor ^= *eight_byte_raw_cqe;
>> +		eight_byte_raw_cqe++;
>> +	}
>> +
>> +	for (i = 0; i < (sizeof(u64)); i++) {
>> +		cqe_bytewise_xor ^= *temp_bytewise_xor;
>> +		temp_bytewise_xor++;
>> +	}
>> +
>> +	if (cqe_bytewise_xor == 0xff)
>> +		return;
>> +
>> +	dev_err(&dev->mdev->pdev->dev,
>> +		"Faulty CQE - checksum failure: cqe=0x%x cqn=0x%x cqe_bytewise_xor=0x%x\n",
>> +		cq->ibcq.cqe, cq->mcq.cqn, cqe_bytewise_xor);
>> +	dev_err(&dev->mdev->pdev->dev,
>> +		"cons_index=%u arm_sn=%u irqn=%u cqe_size=0x%x\n",
>> +		cq->mcq.cons_index, cq->mcq.arm_sn, cq->mcq.irqn, cq->mcq.cqe_sz);
> mlx5_err ... and not dev_err ...
Will update dev_err to mlx5_err.
>
>> +
>> +	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET,
>> +		       16, 1, cqe64, sizeof(*cqe64), false);
>> +	BUG();
> No BUG() in new code.

I will remove the BUG() calls and only have it print the error msgs.

Thanks.


Best,

Rohit

