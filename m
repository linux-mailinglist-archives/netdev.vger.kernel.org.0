Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1644CAD60
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241908AbiCBSVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241526AbiCBSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:21:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C202DD6B;
        Wed,  2 Mar 2022 10:20:39 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222HISsT024411;
        Wed, 2 Mar 2022 18:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RhS/oXcKdeHgayIZUzE0xDLXVo8flkWLQyOr8nxMjSU=;
 b=iy4vG9fVYpSgMWWh95MNo8+A2KFFNId/0aqeX56WA0tbTXmSg5zXKUWDKPhB19pNU9LW
 JJjQnrwwrqE22Vz69mugWaP993HVOZtxgCJXYS8UKuLux8hR1YW25Noacg6CHotk+cJ8
 SJshbxeCdw3kfrSbt5v2pEyMTqPaDWcLGhm0k7YWsKxdDC6asJpc562tnzkhL9xn1fNe
 ouhpfeG65YgisXksFRKXF7RBcGiVAjd1MkP+TixXM90OxQM5DPPqKBRkdesPKIzlGwwl
 RBpOo6zK1pdM957tvwWY6eXVmvNI+jx+WwCqutbsyBsYM6fUZibvznAV7enQvg3xgS0j iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k46n8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 18:19:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 222I5OUZ045046;
        Wed, 2 Mar 2022 18:19:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3efdnqsk7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 18:19:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNY55/KPsSqlpT4QzxIbkmCISn7B99kRtCU4jeNzDTRjTZUIwwPEbj/hC812I7PViYITLM5lp+85Gw2/J9+hzdy/oya64L77GdBCKl2QBZdEKs8KVkQxD2forigt24qKhCyAd99Yq48UkSlUh29w+Zq3S5oSZ3VEh6WPqNI0e6wrdrKSPKQvWQf++CQEl9wD1+7WxHBGfU+yQZpNmNVK2aPGat23wkvwUfVoS57oWv4hUPhPsubIXM/slKMpDuqpBVBp7Av4C6arEuyh+qUEKWePDZfcqg+oFI8HRNJzy1lr3Dr1ux5aKF5fZsNhncMiga/ZvL/E1cfN+FiCth9+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhS/oXcKdeHgayIZUzE0xDLXVo8flkWLQyOr8nxMjSU=;
 b=UsfySUIv7cpVea5tg5GAdKwI8IdEeguOaQFZ3Mw1ZxEkANeFv/SuiVG85FYX1vks7obM6v3ORfNo/ZJ0Sy3qGcIQHcqiGwDNq2W/+u94NMYMWvTcHxXVrhE1wl40fpdW9IK3VvKuxH0c++pWfw5Bm6/7mIadVl+xT8plJ38xJtyvxMQ1BO3cCPzEJghYtS0RV52bTPf0pgka8DFrxFHXmS9ioRus5mEFhbEgWa1x1fgOg5REHMCDmBOnyUocde0cow4OQL5IXxiCZ8A+bOkJkhto4M6Y4kYcn63YWkY0tFuAGGsrTSMVp5iFYKrqflUlqFEz6PKVzueJX9B7ZQw4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhS/oXcKdeHgayIZUzE0xDLXVo8flkWLQyOr8nxMjSU=;
 b=xHfy2bPCT+yVVBoBNQet0KKUrWe8AIxxHBqdsa+4vhFkbFci7uPSrI1KCN/CyqkBIAyQMG7jzzNHNapWikvq0r/MuLjce41PF5z5N1BIRIp8RE+mko8vx6A/VNDAhPqcVEdLB6DvxoUNYC/tkua93g3GP4kcK0IjxeJTqWSMIKI=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MN2PR10MB4144.namprd10.prod.outlook.com (2603:10b6:208:1d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 18:19:32 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 18:19:32 +0000
Subject: Re: [PATCH net-next v4 4/4] net: tun: track dropped skb via
 kfree_skb_reason()
To:     Jakub Kicinski <kuba@kernel.org>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
 <20220226084929.6417-5-dongli.zhang@oracle.com>
 <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <ca81687c-4943-6d58-34f9-fb0a858f6887@oracle.com>
Date:   Wed, 2 Mar 2022 10:19:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20220301185021.7cba195d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:a03:114::19) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1458ed6b-bba2-4423-084d-08d9fc7932b9
X-MS-TrafficTypeDiagnostic: MN2PR10MB4144:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB4144FBC90CB5B6A426D48919F0039@MN2PR10MB4144.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Og1kSKBrqPLYCNd/IHjgJpq1TWlEOygOnBB6DE2/WGWJX117iO/2W+24jlhzdzjI6bpJJeov462ramJ+VB6bLkfyAgQ6Qt4GO+FWFmXILMTMXFtDkmCBoEQ+IKzrrKwf5GKgvXv6fOvxebKqt4nFgnW2fzh/J1XiDfcy3Vu4r5Kw9yxOV3szbCwb0OsLh0r2HSph2JsLGM5b7EZXPXo3b7g8WeRQkYOj0cTxJ5ve9bhoA/sCLcMjrx96IsHDJueHOKyrZjJWhaXo/2ra2WXZrYzRf/n49u6S4kV1+CivZ9mIV5HnYpNzlfFpY6pAGiJX6M+66TUjylPKkMKwVfhzzVRGrVGFy7d6oTUc4xFkSoYG67bb8DWDH5xtN5UyKt2osnwOfIt4aJmp9VQ4LeUDR7EkdfBvxNduZqg7wKbook7BwlX7ABNTXbdMB3topVEdGiXncECAb1Jok6iNPvCTEthV2eaAUeAHWkjPrPUYSPRK98PZO2Zg9qXNnlvcd66NMSPpgbgYQd2XkhaK9BlPxTVHr0JpgNYFwLCC65+eMuDq+FBMfVoV0wqjdBA5z8UM6qlbgq5uRbU0NKANElm+Fx95qxL9kQAepz1wD5CkIAsI2uWaJCOW+0bM7IpLoXWECziZuE+P/+71JRcacogsXSZARL/UEaYBAAY6mb1fdXI2Y8zpA/Hr7Dx2r9cfpwuhPwnPUIiDmDMkQigwz/3a5XXL4gNoqF77/gZw6a2F9AlJjFmcLwNFzg1285MA3ditXssYlD7B3TlBmZUMLvu7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(8936002)(2906002)(38100700002)(7416002)(5660300002)(44832011)(186003)(36756003)(53546011)(83380400001)(4326008)(8676002)(6506007)(6512007)(66946007)(66476007)(66556008)(6486002)(86362001)(31696002)(31686004)(508600001)(316002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZmQ1h2cWtPbTEwWW9sbkpISlFkSXcyYkVIbnhHTGMraTFTOGcvZVR2QTJy?=
 =?utf-8?B?bzl2N1kwZVNtOFVCOUVVN05lQ2h6ZGpMSWE0dGJJN3JhV3BvS0h1NSt0NjlB?=
 =?utf-8?B?UVNjKytMandJL1ZIWlo4NEJOeGlVRnhrK0JuZXovbXdVM2ZRbEE2Vk5mVFd6?=
 =?utf-8?B?MTQ4d3pBWUNrRWltUzAyM3NoSHRDNUFnMWJ6K0crdVU0RXBPUDRPbWthdEVC?=
 =?utf-8?B?NkRXYmRVTUdSQ3dEUzdKVDRhekR3MVViYWtKczRaZWE3Uzh3ampkRjc5SzhX?=
 =?utf-8?B?SHFTSmdlZHRxbDJ5dnE0NG9JbkVGTUp3UC9yZ01KOE1KUi93d1hiNDhpNUtw?=
 =?utf-8?B?M2I2M0VYZWNBZXNMY25KbmpYWm5TeDNFT1BWZHJJZnhHOUE1L2J3MlpZaFR6?=
 =?utf-8?B?QTY4VzlsZWNCa2xUMVVCVmRXR1pwaE13TU9JT3BYb3RVZDhZY1FlU0liMGRq?=
 =?utf-8?B?UUROL24yRldFWVZXZ2ZleW14WlBWbTJ2YjlSTFBrZFV1aExGMW85T2k2MTdK?=
 =?utf-8?B?L2NNY2Q1bmdES2Y3MHczNlF4WEFqMklzV3JUWE1OL0paaGtaVTNpenhnZTI0?=
 =?utf-8?B?VlpaK05VSGE5UXc2V3J1L2V1Umd5SEdYYzljZU5oem55VURHMklXWXF3OHVT?=
 =?utf-8?B?eDFTTFZUUmpPSkRvMFM5VExDc0J6c2xpb1NTVXBHbFF1T0dJOWZoNitpVmpx?=
 =?utf-8?B?Z0FnVXl3NlpPSlN2S0wxQ0E1RGhrcHF6dEtqc0VQbmNVWC9PVnI5SStKMHFu?=
 =?utf-8?B?WWprUE9JR3lRRkR6WFFIcVdTWSsyd2ZBbys2QTkvdnNzS2M4azlUNzdObUtO?=
 =?utf-8?B?QXNYMld4L0NaRTliV1RoMVZwTmlYVXhDSmc1YlBWNTBvUVMvRVphdW04V1A5?=
 =?utf-8?B?YnJQOFlKd3ZKYzBlTVNIRmw4STNjNEZsTzhONGprSlR4S0xjNGpOZXlOaENT?=
 =?utf-8?B?N01SZnFiUFEyR0FSeFNzQXFaZ3Q5cnR5eHRvUDZjTnU1ZWxVV0NTNEQxQmFn?=
 =?utf-8?B?ZzB2eE0wN3pYZWxBSGVQcThXc2I4MGRycCtsSjNlSmE2T1o2ZGxEL291ejdi?=
 =?utf-8?B?RzVRZU8rN0FoMmJ5UWtrcStQMXgvWHpiMTlEYndSV0NuQkJzWmhsK08yTlNB?=
 =?utf-8?B?dXBScjVNM1lvQnpiaXA3d2pxenl0bE14NkcvNDVzc3IrMnVPL0ZEN2dVTDlX?=
 =?utf-8?B?cjRmNkJHV1NvSGhYUit3dkZzMFhVZXV3NnI1MGl5cUIzakVreHNCRzA3RDVx?=
 =?utf-8?B?aWRPVHZad2wwdlRnQzd3ZHpPYkE1VE0vYTVrMjVBb0N4NVBMbHpBdGFrcUFK?=
 =?utf-8?B?N0p1OWh5V2I2SlViRjZZeUN3aU9EOWo4RS9RUzA0a0o3L1BvY1U1UWVVKzha?=
 =?utf-8?B?dFZLdHYzbS8rNFFVRWgxTW9DOFRORGJvdm9GZXp2dExaODdka2ovaWExZzFW?=
 =?utf-8?B?bHRVRDh1a05wVmJZS0JNRnJLS3BKS1ZGTHpnUzFCVHFBT1Q5M1F4MlpHS2dS?=
 =?utf-8?B?dVg3eE1jTXFsTTdicUd4ZE1lYlBJWHhuUFN1dCtTc2dUSWR2bndhckZHUGZS?=
 =?utf-8?B?SzYxSXB1UW9RRjVTdEtiZjV3NWhVWnJDRGRZUWhTdmczaEVPcm5kOWlVZkpQ?=
 =?utf-8?B?KzhPYmkzb0xlb0wycGJlbThhSFZ1NUtWMWdZeWtWSHhVNG1PVmsvVmt3Qk9V?=
 =?utf-8?B?MnQ1Vlc2U25lMm90b2s2R1g3TFNSdWd4eGZnNm9tMjFJU2FoUEVQZTdsclNm?=
 =?utf-8?B?WHdZaWhkZ0JJdlVwanJ4Y01sUGdTYkM2Nkswb0pUVERCRC9MR1N5T2tZbFkv?=
 =?utf-8?B?aGlyU0h5V2tyeWx2Zm9uQm9rQjRrMldWLzJYYmZ3dHFjWFdOWVQvYy9adzZZ?=
 =?utf-8?B?Z0FlcGxpSjEyM2g0VXdsMVZ5am1BaU5GSWRacGYya0dlQlQ0UGxhRFNpbWY2?=
 =?utf-8?B?KzBIUUxkY3Q3RStNdlp6L3AzTy9PQ2gzTVhtNm1DMFVCUHZwaHpUdFp4K21O?=
 =?utf-8?B?L3VIaktZNjJnRXJJU0NDTC9GQ2drcjg0eDU0WWhVZ2h5M1RNZVkvTkJ1U3U2?=
 =?utf-8?B?WUJ5NkUwR1A1bGNNS2FkVitUak83YWRSdEtXVzFaV0hqY1I3SVVCVDRyMmFL?=
 =?utf-8?B?UmdZRVY5UWJQYm5teUxNNUxaeGE3UHY0ZFBpWFNHbjd4czg5eStqTkQ1Vis3?=
 =?utf-8?B?VDN4QWVDSzh2SzBDOGtUeDg1Z1pKSVByeVVLZXF3REpVK29yNFhXUDNoVGx2?=
 =?utf-8?B?bDFWRFdFT3UxM3RiM2RKVTlTVXpnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1458ed6b-bba2-4423-084d-08d9fc7932b9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 18:19:32.3583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wpAyHopn69hUggRjvqhAsZnD4nrK0SwZaqC+ftZiHVV/YCRgiWPuxGnuDeyFo5ObB2eXoIYpxONpAr6K3vZGVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4144
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10274 signatures=686787
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020078
X-Proofpoint-ORIG-GUID: KUOXD71HoVGvHWGUm0fb3SqytIkiO9f6
X-Proofpoint-GUID: KUOXD71HoVGvHWGUm0fb3SqytIkiO9f6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub and David,

On 3/1/22 6:50 PM, Jakub Kicinski wrote:
> On Sat, 26 Feb 2022 00:49:29 -0800 Dongli Zhang wrote:
>> +	SKB_DROP_REASON_SKB_PULL,	/* failed to pull sk_buff data */
>> +	SKB_DROP_REASON_SKB_TRIM,	/* failed to trim sk_buff data */
> 
> IDK if these are not too low level and therefore lacking meaning.
> 
> What are your thoughts David?
> 
> Would it be better to up level the names a little bit and call SKB_PULL
> something like "HDR_TRUNC" or "HDR_INV" or "HDR_ERR" etc or maybe
> "L2_HDR_ERR" since in this case we seem to be pulling off ETH_HLEN?

This is for device driver and I think for most of cases the people understanding
source code will be involved. I think SKB_PULL is more meaningful to people
understanding source code.

The functions to pull data to skb is commonly used with the same pattern, and
not only for ETH_HLEN. E.g., I randomly found below in kernel source code.

1071 static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
1072 {
... ...
1102         pulled_sci = pskb_may_pull(skb, macsec_extra_len(true));
1103         if (!pulled_sci) {
1104                 if (!pskb_may_pull(skb, macsec_extra_len(false)))
1105                         goto drop_direct;
1106         }
... ...
1254 drop_direct:
1255         kfree_skb(skb);
1256         *pskb = NULL;
1257         return RX_HANDLER_CONSUMED;


About 'L2_HDR_ERR', I am curious what the user/administrator may do as next
step, while the 'SKB_PULL' will be very clear to the developers which kernel
operation (e.g., to pull some protocol/hdr data to sk_buff data) is with the issue.

I may use 'L2_HDR_ERR' if you prefer.

> 
> For SKB_TRIM the error comes from allocation failures, there may be
> a whole bunch of skb helpers which will fail only under mem pressure,
> would it be better to identify them and return some ENOMEM related
> reason, since, most likely, those will be noise to whoever is tracking
> real errors?

The reasons I want to use SKB_TRIM:

1. To have SKB_PULL and SKB_TRIM (perhaps more SKB_XXX in the future in the same
set).

2. Although so that SKB_TRIM is always caused by ENOMEM, suppose if there is new
return values by pskb_trim(), the reason is not going to be valid any longer.


I may use SKB_DROP_REASON_NOMEM if you prefer.

Another concern is that many functions may return -ENOMEM. It is more likely
that if there are two "goto drop" to return -ENOMEM, we will not be able to tell
from which function the sk_buff is dropped, e.g.,

if (function_A()) {
    reason = -ENOMEM;
    goto drop;
}

if (function_B()) {
    reason = -ENOMEM;
    goto drop;
}

> 
>>  	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
>>  					 * device driver specific header
>>  					 */
>> +	SKB_DROP_REASON_DEV_READY,	/* device is not ready */
> 
> What is ready? link is not up? peer not connected? can we expand?
> 

In this patchset, it is for either:

- tun->tfiles[txq] is not set, or

- !(tun->dev->flags & IFF_UP)

I want to make it very generic so that the sk_buff dropped due to any device
level data structure that is not up/ready/initialized/allocated will use this
reason in the future.


Thank you very much for suggestions!

Dongli Zhang
