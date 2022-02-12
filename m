Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFDF4B322E
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiBLAob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:44:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbiBLAob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:44:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513B8C33
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 16:44:28 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BKDRCT026349;
        Sat, 12 Feb 2022 00:44:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=F9ftwdJIzYwkNBliPPrvTxFY4sGfNRFRik/o7ap+6U0=;
 b=xWsT9MJUE3cogdsS0kfdDXQIKZ0vAJpFIvGINXBSEPOcxuKqlOVSYnANi9U5T7pcC2mh
 xI9FGMSqTC61hFPs9AovgbilxtHpYhUsf5oQMBTljXgZJMjCZHVuJN2VTOF8vpEm2XwR
 IvkpUEDM+2K8+49IQKjdyk7yIPGmMb5kgAWixMIZZ2RiQEeQjDXUwL15AhjBWUu9OPXN
 P3FW+87XmXOUhbYD9zKW7BLQwOhkCSfn914amTHln2xz+UqyHxRZ9TLy7awS3IHyaps+
 C6phKTh8i38rfXV08xseqBsaQ4ZtPIxf60ZEr1EtBW+z4FaBH/tDW63vek7AFDt+757E Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e54ykm51n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 00:44:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21C0eFRR019708;
        Sat, 12 Feb 2022 00:44:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3020.oracle.com with ESMTP id 3e1jpynsph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Feb 2022 00:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHcxky26oEm5UF9SCRDecSo2eDVDK4D/mPuXXqG4wXtyhoOnPlg0+vQoEzkwT2nYDaywqqs/H1F+0q1CVGDMUS+EFsOj2Db1AU0JxBP7Ei+Y1X3nmPTiRpGdVusLfGXj7WDQb7JEfn4Zyj7DU0QShplMXerF2pm0UVtmsmwUpnkAwdbqjrorwCD0xRNZidkRY5W1gnnEzPJMJWgdkWWU+gzZWkGBgRAlFbzi6OJQsjQ1xmIH47KshzfWS4gnmI0Zau3G8yADoAXVHpI99RA6V9VTqc4U1RaXNIzGixlW9BpKzjv9uXhq/9qLBrxTcfejMWCj9jdsoyYCSFDHhDMO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9ftwdJIzYwkNBliPPrvTxFY4sGfNRFRik/o7ap+6U0=;
 b=fJaosHMbyX1oSeE8PO+3v+Ujo4LS+xuoGmproFkDVP9+gbBtT3QgEPUKYhmltCwPSLFLJNupJYUcvNBLuEFzPUA0NdICxBBgeSeBf1f6bIuzN1maZCzkYskVvd9onPTggjhCqBpKPugfnSGpmPh9BZrWbf6Hd0vo9YXnxBN3dlWOFDUmwI1vhimiVQWyEZw9A8eVM1+0H4jkefHbqSDJ2q47A5AcycOrFjwEITvfgepx7MXAJxJoY2qmoN0f0Jdiay3GZSfEV/fI8AtjrQI5+4Po5RZXWwHfomN+ElVk6yp7VamPXrmMXys9BpEBmqPhJk5GCucPeKW9h2zfx4kjgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9ftwdJIzYwkNBliPPrvTxFY4sGfNRFRik/o7ap+6U0=;
 b=TTcfpAzd9WmVkewbgUoajExruhkTK5nLDA965EULxAwVHDasGEPSxHfZtBchRUc02JXeB3ZhB+OD587/W9U0gPhOKyZs2ZHEFCA07g2zX5xLXXkOkr6riQo0JjyA7uCvaGclaTkHp+iD2TSvMLmXevSUydJwFFfJrs9Ri/PrWZs=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SA2PR10MB4489.namprd10.prod.outlook.com (2603:10b6:806:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sat, 12 Feb
 2022 00:44:19 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::54c5:b7e1:92a:60dd%6]) with mapi id 15.20.4975.015; Sat, 12 Feb 2022
 00:44:19 +0000
Message-ID: <ca2775b1-f755-d50a-7a23-0db8c4e220d9@oracle.com>
Date:   Fri, 11 Feb 2022 16:44:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/4] vdpa: Remove unsupported command line option
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
Cc:     jasowang@redhat.com, lulu@redhat.com,
        Jianbo Liu <jianbol@mellanox.com>
References: <20220210133115.115967-1-elic@nvidia.com>
 <20220210133115.115967-2-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220210133115.115967-2-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0058.namprd02.prod.outlook.com
 (2603:10b6:803:20::20) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8116f824-055a-432e-45ea-08d9edc0cdf8
X-MS-TrafficTypeDiagnostic: SA2PR10MB4489:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB44891CB3B6368384FB808191B1319@SA2PR10MB4489.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:235;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HltXUIo8lEjXwBFhytEXzLqZJHmqvphE3PdwPvFJXsZpptcV5znRR6zqqccrRu1MzEGUqapyUrPEntRszHJ3/3NnsgzHysxRe1WOeopuJlv/EPH9V6A8Q42iEVirXBuBPR256+K85WMaCNzGrwzn72EPi1GTLiLOkZ/E/tl7Wx33uTKGIwvKl9J/Mnquc8//5kr7+4wUqt/+7NZOvsjAMFmmTMrOLjKgt49HcaquHlPCBRaLoCM9BsIoIGARld/7cIAsQo42K3zfD4fseXTcZbD4Rmk+O26f3QWR0lorJMgzgzltd8eJMLHJLIzo3pNX6xIIEAnqwRiK0ys7T3gBENIsxJc4U7M8gStVhUcCE0x3YkKC5HVNN/BDop5Ag1PLMgIh+9IfArKmshpqJrPKkcjZquM+co6uTsfisMP781/1lcyJn95NKbPHwlDLiWS+0zrCg7kMebWLIoc4x0Br7LFrrltI2R0OpgAQCqjbp1+xwIMicZgopJ2EVFQq9PgOx/vEfpvjMpOMSaEEoSaj6bTGj8YnTOvgcayvTfudqJO4aSsehSB7d6oU5lNlW/SxrOLXMZuf+yHAKiAF1P3PSh7OIGC6Htz8VZ3YdSqhq6QLybAAI/9CcOWczVOOYv2crGOTWvPOc2oKzpRz/IjclJ3oWZwZPmDcXscjWCZJBQkehnhSlKZAtsALiF14+3bXUCRmySBG5twlql5irEBFhTM5ivIF6SgrL8VrtuQ8qjueqt1luV4mhJIOJKXI+Ay4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(4326008)(186003)(31696002)(66946007)(6512007)(508600001)(8676002)(66476007)(8936002)(6666004)(2616005)(86362001)(83380400001)(2906002)(36916002)(26005)(5660300002)(53546011)(6506007)(4744005)(38100700002)(6486002)(316002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEtncDlnV29ORlNmL00zUEpXVGRNZnBVVGEyWnpFM2pGelJQQm93dzVyNVdo?=
 =?utf-8?B?NEpHS3VvSVRDcTk1KzE3S3NIMVplQXhWR2k1ZC9TTEtMREd3bU55Rkcxd2lU?=
 =?utf-8?B?Q1ZYSndqNkMxeWVvSUtrL21kK2JKUGxHQlk1T21ROWxqMS9aRUpXK2g1UWln?=
 =?utf-8?B?aTc2aG9nUzVNa0x5VEdzVUtTZ2FxbUZuZkFqYi9PVUlOMmx6aTRhWUdEb3Q2?=
 =?utf-8?B?Ky9vREVkUndrb0ZVTWRLK0VpcVlvbnlIaWRXUHEralJidlpQQjlmM2xGNjFm?=
 =?utf-8?B?bHVzMnNuM3JxOUNLUjlVWlViZ3JQSlB1dmRlZnVrUzBxMFdzUkU5WFZJWVRr?=
 =?utf-8?B?V1Q0WlBBbEl1c3phYU9LZDFIQVR3cUc1eTFkSmhZM2d3ck1WYmdoL2FnSENQ?=
 =?utf-8?B?cGN3bXVyY1Ftend6OTBYOEc5dzU0Sy9DbFFDT3VBeTh1c1NsK2VMT0xjRHVr?=
 =?utf-8?B?QWRKQ0lReEh0a1JtMEt6cEpiVGJHTUU1MGJoVXB6ZzlpL21MT1VYN1gvckpC?=
 =?utf-8?B?VTJlLzAyMm9vZGJFODBRYSs4bUxIcFZFMnYvSlQzMGlFYUpBV1Q1alNYaGYw?=
 =?utf-8?B?c0xJUTR4TG16NjN0VE5mUnYydmdFcWVoRTl2OHczeFpDd25oRDlLSVlBaS9O?=
 =?utf-8?B?YWdtWlFCZWZQczJHRi9XVUpxNmNIbmJnTE9MOWlvSWxyQ21JRkJqQnRITFlq?=
 =?utf-8?B?UnBPNHU1UXQvcmIzSmFkWExxNkJnR1YvcCswYWw2WUhsM1ppZDZ6aEJ3SWJv?=
 =?utf-8?B?U1JZWXMzcFNMQThwdjNoOG14QWk5ekxvdFZRMnIyaEZaelhNc0hUWVBWeWd5?=
 =?utf-8?B?STk5enl5c2x1ZlFMVSszTUk1aGxENTh4UFNqM2NGcGZyZy9DelFKcHdHNFRl?=
 =?utf-8?B?cG9MeFZvZVZJS2ROVGxyUzBTTjRYQi91c3UyZkMvQzhORFJ6NEYvSHYzbkhK?=
 =?utf-8?B?SG4yVmNEN1FseGVYNHh3bzRpRVBuRU5qNWdpZUFCUkNlMXVoSWdtdTExVEdZ?=
 =?utf-8?B?SmVCYzY5S01RdEYwNVNmTkthTXNvdGR4TXNsMVk0U2szT0QzYTl0SC9jOWlZ?=
 =?utf-8?B?OGk5c2JSQnE5NE9PSmNkUjNENnRTQTJxWjVxTTQrQmtoVCtUSTB6YWRIdnFr?=
 =?utf-8?B?UWFPaTNiVCt3V0RvKzR1Yll1SW93aFAxQWIzWXcvM3NzdkRQdmZsRE9oeTc5?=
 =?utf-8?B?MERIY2g2ZGpmQzFNNlA3T0wreTNFSmoybUhLS2R2R3Vsa1kyTWg2TFFkOXBQ?=
 =?utf-8?B?MzdQdUpCbHBSdSs0b0tucTFDNW1mZEQzVTV3c0QvMDd0aW9zbWhiN3l3YkRR?=
 =?utf-8?B?TmdyOG5WY2t6UTNRWTBtVGdHd2ZIYWlndlE4QXhTZzU3dW9FOW8ramZzKzdr?=
 =?utf-8?B?dzZHSGptbitzc29QYjhoVGlCZUw5YnViTm9WQ3RRSm4rVjlqMFYyRnVCeFQ3?=
 =?utf-8?B?ZHpxTUtHbXY5WUJRYUtDMXFyVFpMQUNpazVxVDR4ZGtadkl6YVp3VHk3T0NB?=
 =?utf-8?B?RHBNZTZoS2JpV1d4WkdMR1psclNhU2tycTdJZkNGM3p5dTU0anplWjRFVjJE?=
 =?utf-8?B?UVZOZXhIUUEzYVhOWUdKVU9LS1MvcGZwQjNDLzJzbC8yK3czSVdla1lSZStT?=
 =?utf-8?B?Nk1nZjN0SXRBeU5kMG1Jd3IxbGZMaWhONVV3d3FuZ1pURGJuelp5VmZ1cEhl?=
 =?utf-8?B?YWZWUGovbkJacVB2Q2JQeXgyUU9TUlBaRFR0U1ZHQXVTTVRoNC9Xa0ZKbm8r?=
 =?utf-8?B?L1owWVQxME9qUkN3RFU1clhTWUE3TnJOSjJvbXNFNWtQaFFHLy9pUEJ6emVl?=
 =?utf-8?B?Y3F4bXA4SWJwT2VPcGdVZUNxSVVtcTN5SDJUcmFBb1RibXd2Z2cwVlRuN0l1?=
 =?utf-8?B?WXQ0RlJLaHZhQ0pOTi9MdVJzNkVGQjRHRHMrVkVUR3VMWGZDZ21BUzRYNVpF?=
 =?utf-8?B?bEhEd3NMRTgzSmYzTUExb3M2QUwyRmZmQTMySktkemQxZDZNYmVXK3BUMnMx?=
 =?utf-8?B?ODlUUnY5S2paaDZ2ZlpZS0NNVlR4UmUzVVkrTE9UUU40QWJFUHZySS84ejRF?=
 =?utf-8?B?dEV4M1REenRTTFM3dU5UZGd3U1prT3cwZXlVcWljR3Vya3dQTmNuYTdMeERI?=
 =?utf-8?B?LzIwTm05RkhtNnJ6S3RqUXFKR1YzRWdTZEFVNVl4Q0hLemNOTEtXaHptTlp6?=
 =?utf-8?Q?EnZZ6GrR8FAALmSI6H1HjZI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8116f824-055a-432e-45ea-08d9edc0cdf8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 00:44:19.6458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOF0lUTa+DdT5Oa+6OBBSHwjHMyKSzk1UI2UDKgIwlSD+xmM5WX7vL+E2YMRAxpkJQyLAY0hEbjV2YguRGosHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4489
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202120001
X-Proofpoint-GUID: j0lPORy6nnoDLXqpSKfUepPbyMkA2u8p
X-Proofpoint-ORIG-GUID: j0lPORy6nnoDLXqpSKfUepPbyMkA2u8p
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2022 5:31 AM, Eli Cohen wrote:
> "-v[erbose]" option is not supported.
> Remove it.
>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>   vdpa/vdpa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f048e470c929..4ccb564872a0 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -711,7 +711,7 @@ static void help(void)
>   	fprintf(stderr,
>   		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
>   		"where  OBJECT := { mgmtdev | dev }\n"
> -		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
> +		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
Maybe remove -n option that is also unsupported yet?

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
>   }
>   
>   static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)

