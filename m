Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D09643A88
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiLFBLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFBLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:11:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D74CDF6C;
        Mon,  5 Dec 2022 17:11:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B60Ills008770;
        Tue, 6 Dec 2022 01:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fvTQIjB8O81EdP3X5jxGp4zsfztZu208KRuo0TZm5J0=;
 b=KPfpRD3yLlbStYMoy7S47cLehfVXzw43HQd88FoVbGEp5CQuhwPZR720vSqaSgqOUD7V
 N3nAYKXpFAGIEzPrX227/kBEDYRSzA6U+CB18eM7xCuiIazy2Kzibzt0lukqwhY3LeFS
 cNGoDsDWeTnrjyOfALcvc7jDzZ4tS0B0ak7UqinWtBre8Rx6suWjLKzl7XX/+R5D4Xym
 4PNg931S+3EgA9pBFKZCusp21T1ZxK+VlC/u4vNevrRpzecVq4y9+egzWU+kvLsMZdpz
 BXL3OqtjFIEPNl22B+7AXkoZpC7YuSbCbLXQYSYl8thMDz3KqUjcj4rwSL6RvMYx+blW pg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqnmee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 01:10:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B5NJFrY028011;
        Tue, 6 Dec 2022 01:10:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m8uaa2wq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 01:10:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+gdz/UObGgMKNBSwdmVPlVh3/qZOgRohdaQ+2ZudBktUA2SWcALS0kF5MvzMjSSGZOA6ljr5YS/1zyb4kmLKsoVeOEM6ilCrQJnH+KUWCmwWnP32cTa+veREjfMEKb6XlayEgXicQxTEJWNzy3sstX+hhjrfpsGfWt9PhEbpMA6M8pAw9EIG+dTUyLvlazEFBv1AUYgj/4hvZ02+fw74cuRN36xC5Rbi+GWkNRULwPi1QpQwkrTbw2kC47BNrqKQcfNXiDK0+tEtlv8DCsgX07CjGjGiWfMv1lnNZIQ4QxFNn1ZstVTpMyjMqVwHoEAbuUzEBhI7mSk9GD5+DHyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvTQIjB8O81EdP3X5jxGp4zsfztZu208KRuo0TZm5J0=;
 b=e5hwLJpX99dCrOLyNxYDAPZyyxuxT4eIizSSrdaBVLOAhBEJ/rLrRKpyVlKcbS66zKSDxhLe5izEj/2cBtI6WreJd/By1+CVvCdIrTXtCyYJJv7oe0bUHwA5PSz/JIwXceEcgvWp4LdvQqAdEvIcqo1+dAepen1/PxPQ5ENGZOERLWzKK0uKJlnsAdxQQHKGXDFl29VefeWbGheXWXoU1AjWYTk0yvObU6vpvCGKGm/QYY//soQKcbexP6K3Fy31yOKwvHAiUD1PCtHPZEZIpoLDg/AnhPNvW7z53WKWQ7dethO+z8E9fsxSDv3w6IEUG1q9O/d5rlrlsAbdzOpU0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvTQIjB8O81EdP3X5jxGp4zsfztZu208KRuo0TZm5J0=;
 b=vyd/dtrZCAA51fEOQ0L0gQ3qES8HMrIg/GbZHz81XOM8UrxIMwEmXWQUt0CBUchOSJ3CzUYtKri9az0QvYQlimwOidPxW4a88gbGG02YzaJALw2Q6OSGomzp4f0nT7excJf8MuLfPUnjzgWU7aJh4auSRWyWx1gS/ug5VzVBJy8=
Received: from PH0PR10MB5895.namprd10.prod.outlook.com (2603:10b6:510:14c::22)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 01:10:56 +0000
Received: from PH0PR10MB5895.namprd10.prod.outlook.com
 ([fe80::5900:4c18:5b47:6a9e]) by PH0PR10MB5895.namprd10.prod.outlook.com
 ([fe80::5900:4c18:5b47:6a9e%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 01:10:55 +0000
Message-ID: <ae736328-56de-7985-8a9a-0279a123544f@oracle.com>
Date:   Mon, 5 Dec 2022 20:10:50 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] net: check for dev pointer being NULL in
 dev_hard_header() to avoid GPF
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        harshit.m.mogalapalli@oracle.com
References: <1669817512-4560-1-git-send-email-george.kennedy@oracle.com>
 <CALs4sv2ZfT1SAYY0oOYhrBBCjsG_th5g=QtSsbKJnPbW8faQ+w@mail.gmail.com>
 <CANn89iL9obgd==tdp9DgdxXk78UvzF6D4J1OeihB1kx9_U4oZw@mail.gmail.com>
 <99adf483-ae89-8010-4689-fd50a77ff023@oracle.com>
 <CANn89iL18gPus7YWMMX_UFg9PSxAv0SkWTjLYCPhncOCEKrWuQ@mail.gmail.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CANn89iL18gPus7YWMMX_UFg9PSxAv0SkWTjLYCPhncOCEKrWuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0064.namprd04.prod.outlook.com
 (2603:10b6:806:121::9) To PH0PR10MB5895.namprd10.prod.outlook.com
 (2603:10b6:510:14c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5895:EE_|SJ0PR10MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: 889e2cfd-73d5-4b09-8aa9-08dad726b90d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xhsvk5mJnSdtJ8tJ9fyJR7eZT1epDMBPHZ4f0yi+pCVeuWD8RICYhLQHqGHh7KjhpEMg7cVHp2/VLhIGAfYuzu8hCphOFuWgy6INtKUrF434WRVd6jYNaY9P0yxSrS2MkIQdryk1Inm61RCBo1gBu+wU5jUvTGHQfZnLqCqnEDTe1E7PiXOZz524Z3RQR/zs3uN77sktdo+001wApVPYym0PtknvBJPrV1Z/xrslIfp73MaMaIcMmxKItebZBO/cYVpPb5SdWOFJi75O0xIEFcN8xRlxAu/ELAuMXgq5MWivvCKEH9Xf178ahX/4cKzFctALgVlpRc6B3T+aaOnEyJ9kod/I/3M1+1AA4FjPLke0ArhAs+0egsYCog3Y1Vi+yXpjkgyOGZDrGheHnnQWECvlj/s12He14dwtdnwjWjmtsVxl91ZQJzpTh1F+FxtYhbumRnxkwK0wX28au7V0eBa3MLKYEAfmvHidkaQBHDKlN9Izw8NOczsS2vsdbiOIXt1WpVnH+KaDLl2Gbb/HqxknOLwOoUmnuWW+Ll0WfUVsLhIE6Y9qCm33vKdn5IIJR0h3pspQkPt+hvY1Wmp7F9t59uaYcN+nxscZgRzdu6opeCGpu/Tyu3hLO6mDxraTJmqa9+ahSADHeQmdOFD9TYfgdpiwvKXFNs8IWoK6iF5qzYMRnCHkevaVFEzUWZHP2rFiM9kBLRLJzlGg86PIw5QqFON+P7hwQBkU7ZMMx2k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5895.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199015)(36756003)(31686004)(31696002)(86362001)(2906002)(4326008)(66476007)(41300700001)(66946007)(8936002)(8676002)(66556008)(44832011)(38100700002)(83380400001)(478600001)(6916009)(2616005)(316002)(36916002)(6486002)(45080400002)(5660300002)(186003)(6666004)(107886003)(6506007)(53546011)(26005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1RxeGZsdS9WK204QkNtNFZrQU9tV3FMRGhIdEZ0VzBldVlSeWUzY25sQytB?=
 =?utf-8?B?dzkwaVVub0d6OUNYWXM5eGRiSWVQaVJVTDFvL0gvbHZ3YTl3RklMY0VBbzNL?=
 =?utf-8?B?VHRBTCtkVk9lZXcrT0k2dTJLd3dWSGhMNHZzSUI2MWtFaXV6VmExbFVuL2xs?=
 =?utf-8?B?ZG9rTU1sdkRYV044dWZLTnhacithWmNtcWFobDdYa2xWQWN6QWh6MER5RE8x?=
 =?utf-8?B?VUhyUHNVZ3hjc2tnOFg0eVBTbm1CUUFMdGVMbE5QZkpYSjYyeE1rSmxEdGVC?=
 =?utf-8?B?bFI4M2tFU2Z0ckszM0pxM1hyMTlmTFp6aGpIQnFFOCtFL1F2SjQ4Q21teSto?=
 =?utf-8?B?QkpmeVRZZ2s3aGhZaEh4WDJONzJISUhyOEd6TGVidzFCNjJHUEVwbWpTamNR?=
 =?utf-8?B?Y3YwcWhjMGJPRDQyMXZhbXkwQjBuMTl1bEdITWsyRzBTRnExTEpCTzhUYVNN?=
 =?utf-8?B?QnFpMXA4WFgzbFpIWHdNTDJlK1BsSXFJQ0haSHNLNkhVMzE5Q2tOMTdPWDFt?=
 =?utf-8?B?UmZYelJFbC9MWlR6ZHg1ZitZWnhDaCs4a0FzTHNzOCtDN1RvbUhNTzcxMFow?=
 =?utf-8?B?aHpMd0o3UUdqL1l6clBqeWhudCtvRWxmbE13Mk5XQjJuZFJuL2g5bzMwcjdO?=
 =?utf-8?B?R2gvMGxCbzZpcnduRklHYjNXTTJkNTFDQVNqMERDYjFhRmE0c1owMlFmSzVH?=
 =?utf-8?B?dWM4MXh3R0x5RFZhRllSV1Zub0ZDVlUyRm9LMEZHalQ5Y3p4SHRPTjhZaG10?=
 =?utf-8?B?dUJaUlg3MTJYbUdtZW5rK2tQMUJsaGh5bnY2SnhkT0ZiRUVJY3NHL1ZyWWFZ?=
 =?utf-8?B?OENCazk0VDZYRXU5MGxtWno3NENTd3dyajNuK3NwdGhsVHluR3IyWjZSMnB5?=
 =?utf-8?B?Yk91eUZMcmdtdHpCVzRqTkMyeHdFZ3l4NnovYWxjVXpoWEU5VkF5TzJCaGQ0?=
 =?utf-8?B?S3ZTcFBqSWhuVmRLZkhzUExDYU5yTHNtdUxhczZBUTM2eXVJa3g3WEVGUnFN?=
 =?utf-8?B?S1FqM2wrQytzM1FaZzVEa3FJVHhpTGw0RFhpTUNkTWZvc0g5VjJBR3R3aXhY?=
 =?utf-8?B?UmduckNNbStmSXFmZmVCUXI5aldTcWNaWmlpSFZvK0EwUElncEovb3BFcjNQ?=
 =?utf-8?B?VW9OeXgxU2hiN0E0bGZXSmlPTy9rZlZwaEpYZzVNc2RRS0pzbHM5bklweFEr?=
 =?utf-8?B?RVlYaDJuRzE0OW1LRHY3REtPMFZJY3VVTDNXd2NNa2hjSHZvK3FCUTE3ZDJV?=
 =?utf-8?B?RS8yenAwdUtNRGdGamJvNTdseHBCNGtYK0tYQzdWaVY5S1k5QVRkQndHOGM0?=
 =?utf-8?B?cE5vN0JIZUNEZ0pNVUdtWUlKSlZDNnpGMVk0NE9hcDVJeGNZWklzM3BTam0z?=
 =?utf-8?B?YjhLc0h6dis4VWZSV29mQWxZZlArZW14bmcwOEVvdjBiL0VJd2p1U0EvNE8v?=
 =?utf-8?B?VlFZZEZQOWpHdHROUkZCTVhnZ2dUM3ZLT2JIa2l4cEkvcWg1clR6SThPNFA1?=
 =?utf-8?B?M3RVRFFMZTdjbW5tNk1PQ2NzNFZBWXBTQ20zS3l5SGhEVk94eHVPMlFUdTJu?=
 =?utf-8?B?V0dpL24yUE1KN0NaU1l5eC9ITGNJVmZyMmwxVENmTUpTMG9IOEU5bThvc0c4?=
 =?utf-8?B?bUFlOEdldUxpclBZN2hJdjMra1pyYWI1K2pSZEFSaTZUZGt5dTJ5RFB2KzVV?=
 =?utf-8?B?K0YyNVNkNmhiandTMy9VQy8zYk5acGg5c2g5OXY4ZVFqL1JKQ3dtcExieHVr?=
 =?utf-8?B?Wm9POFRnWGROMUdMbll0bXVTVitPUWZyckZ3a3Q4ajQ0NWJtaXQ0SzZBWnJ4?=
 =?utf-8?B?NitOMXRLYWNrUE1jNWdFM1hPVjRQK1RvUll6QUZkSzZoNkxXTTVYTGtJVllq?=
 =?utf-8?B?RXJQNGpzMnJhaUdqYWJjWjVySzFqUzNYU0dvd1ExVzRwc205a3JxVGx5Z1hN?=
 =?utf-8?B?ZHFFN1RjaXJKQXdCSGt1VExVNXdsaDFmTDgzdWdhb3NheGZTTmxxK2xwNjRB?=
 =?utf-8?B?VmJVandkYllDcFdLNVRuQXVtRW5xdTdLMEV6SHNUK1dGMFlLUWtyMmZ5dHJa?=
 =?utf-8?B?UTdxRzNRQzI3UndwYU42M3Y1NEwwYzZkTU9tS3BvelNPY0dxVndpL2w0K1J1?=
 =?utf-8?B?dWlxSVFEUWtOeTgzZTNqYUduc1Qrb01iMk9oN2hLQ1ZReW82T0VKN2dLa2tk?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eENOMEprdnNkbVFUdVk1TGEvMDd3VjF4S0VEdzRVZHZ4QTNEa1ZyOFFSMmJD?=
 =?utf-8?B?RjcyNWlUUG40S3RVOE9TV3JDUFJyV1oxK1pxR2k0Ymx4YVppdUs1ZGNJZFV6?=
 =?utf-8?B?VXh3THdEazFvOXJxanNUU1E4cnYvdC9rOW9XL1dCWHZINGJ6WXhUN2N5NmxZ?=
 =?utf-8?B?bnVWcHY2cFljOG5YVHZjOU03MmVSQUlZbFN5UVdJc0p6a3RkT2RZZnFQandW?=
 =?utf-8?B?TnoxV0g4UGlBRkxyTWRWYlhEM09LNTdUZ2pUOEhpR3U2Sy8rK1UvRzBqdTBG?=
 =?utf-8?B?RzJ4ekFTMndqb0ZwQzhxYWtOQVJtS05pTWlMOHFMWm9yeTVhakYrYUo3dUdu?=
 =?utf-8?B?VTJYcHByODhBbGtSZzh3NisrMlNmUGdqRWpTd0JBdVRucjB0WFZPVUlzSWxM?=
 =?utf-8?B?N3MzR1owbm1tb1BpN0RZWjJHN0Z3R0NDSVFpSDZOTnRzQlFIM1JrSEhPWnpv?=
 =?utf-8?B?cm44VGI5VVpqV09Kd2tWeFpsdkRHQ3F3TmxXRVM3by9hS2JrSkNTUkwxZjJR?=
 =?utf-8?B?Z1hnMXBidndlUmJYNXRVckVpbkF1RkJMTVhkRHpzajk3ZzJEa1dNMHhPRExi?=
 =?utf-8?B?TjZaRlFabmhjUUxmQzJxeFpnKzljYU1mVTJUd1dvREhGclFhZDZ3YW9SeGQr?=
 =?utf-8?B?QnJPdXN0UlluM0p0ZmlLYlRFampDd0Erc2ltc2MwYW9kS0hsRUFHcHNGRm9k?=
 =?utf-8?B?cXB5OHAyQXU0MUhIV0FwY2lXb1RKdHZwWndQV094T0dzeXVTNFQ4eU5qUkNY?=
 =?utf-8?B?ZkU0dk1HbkdwTmV2TnB0OGVoUzI0Vjg1WWZ5d0FRMGFqajFtaVNhVitYY1Nl?=
 =?utf-8?B?Vyt5eEhxYVpyTDVoNHpIQjNKaWhnVXZBdlhObDVLam1nTHlaRFRvZ25Eakxx?=
 =?utf-8?B?QnJ4dWZHWElQSElWYlhodTlzMXZ4MWl5VmtRM0VuS3dlQnlaQXlvN0xucnJs?=
 =?utf-8?B?ZUdHdHZycU9aSGR6VEF2ajEvbEFJR2pndVpWb3U5RU5JS253YVduTzhQNUZv?=
 =?utf-8?B?dEhPcVhsRnNTV0RQRnAzWkpKaEFjaWZpTFU1RnFwdmVLUW56V2txcWRpa2VQ?=
 =?utf-8?B?QXhIaTBxRnRvVEhnZ2FDWTlXSkh1UC9ycWNGVXdkUzZOcHpUYWt4ZDk0dUN1?=
 =?utf-8?B?b1RYVGJteGNMb0o4L0t2QkdQVUdBQm9XME9nR29haTJyVVlOVjNDeExBbmtn?=
 =?utf-8?B?QysreVFJQmUvdm04dnR2R3UrV3ByUGtHWnkwQkMzNDZLVDlMcCtOKzNMN0xT?=
 =?utf-8?B?MUZFZVlURTZHdE1DTmMzRjd2YlZESk9JOExPdE9KWjBSUjJEL2pRcm5CS0Yr?=
 =?utf-8?Q?uUxtHUxlSeOPgrYpYSQnpa/0O9H0CWxOfm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889e2cfd-73d5-4b09-8aa9-08dad726b90d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5895.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 01:10:55.5171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBmiRGt4qdPGdvFy/FRbU5/dTAUeGBmlN8Q1ojz+kmUTslTQ0bOWD1rfpXAfwV4zvhQrzKg2G7hcS7Y2Skp1fa7GSaFVzjRADmJqZ5y16lE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060004
X-Proofpoint-GUID: nYf1pjF6kHL6Z8RbuZTQzJCYCD14Bqqq
X-Proofpoint-ORIG-GUID: nYf1pjF6kHL6Z8RbuZTQzJCYCD14Bqqq
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

More info...

On 12/1/2022 11:11 PM, Eric Dumazet wrote:
> On Thu, Dec 1, 2022 at 9:44 PM George Kennedy <george.kennedy@oracle.com> wrote:
>>
>>
>> On 12/1/2022 2:25 PM, Eric Dumazet wrote:
>>> On Thu, Dec 1, 2022 at 2:16 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>>>> On Wed, Nov 30, 2022 at 7:43 PM George Kennedy
>>>> <george.kennedy@oracle.com> wrote:
>>>>> The dev pointer can be NULL in dev_hard_header(). Add check for dev being
>>>>> NULL in dev_hard_header() to avoid GPF.
>>>>>
>>>>> general protection fault, probably for non-canonical address
>>>>>       0xdffffc0000000046: 0000 [#1] PREEMPT SMP KASAN NOPTI
>>>>> KASAN: null-ptr-deref in range [0x0000000000000230-0x0000000000000237]
>>>>> CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.1.0-rc7+ #2
>>>>> Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+20659+3dcf7c70
>>>>> Workqueue: mld mld_ifc_work
>>>>> RIP: 0010:macvlan_hard_header (./include/linux/netdevice.h:3057
>>>>>       (discriminator 4) drivers/net/macvlan.c:594 (discriminator 4))
>>>>> RSP: 0018:ffff888103d377d0 EFLAGS: 00010212
>>>>> RAX: dffffc0000000000 RBX: ffff88801cf1a000 RCX: 0000000000000000
>>>>> RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000230
>>>>> RBP: ffff88801e8ef328 R08: 0000000000000000 R09: 0000000000000060
>>>>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88801f0497c0
>>>>> R13: 0000000000000000 R14: ffff888045187c98 R15: 0000000000000060
>>>>> FS:  0000000000000000(0000) GS:ffff888106c80000(0000)
>>>>>       knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>> CR2: 00007fbf3f1c1840 CR3: 0000000014e36000 CR4: 00000000000006e0
>>>>> Call Trace:
>>>>>    <TASK>
>>>>> neigh_connected_output (./include/linux/netdevice.h:3060
>>>>>       net/core/neighbour.c:1595)
>>>>> ip6_finish_output2 (./include/net/neighbour.h:546
>>>>>       net/ipv6/ip6_output.c:134)
>>>>> ip6_finish_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206)
>>>>> ip6_output (./include/linux/netfilter.h:291 net/ipv6/ip6_output.c:227)
>>>>> NF_HOOK.constprop.0 (./include/net/dst.h:445
>>>>>       ./include/linux/netfilter.h:302)
>>>>> mld_sendpack (net/ipv6/mcast.c:1824)
>>>>> mld_send_cr (net/ipv6/mcast.c:2122)
>>>>> mld_ifc_work (net/ipv6/mcast.c:2655)
>>>>> process_one_work (kernel/workqueue.c:2294)
>>>>> worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
>>>>> kthread (kernel/kthread.c:376)
>>>>> ret_from_fork (arch/x86/entry/entry_64.S:312)
>>>>>    </TASK>
>>>>> Modules linked in:
>>>>> Dumping ftrace buffer:
>>>>>      (ftrace buffer empty)
>>>>> ---[ end trace 0000000000000000 ]---
>>>>>
>>>>> Fixes: 0c4e85813d0a ("[NET]: Wrap netdevice hardware header creation.")
>>>>> Reported-by: syzkaller <syzkaller@googlegroups.com>
>>>>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
>>>>> ---
>>>>>    include/linux/netdevice.h | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>>> index eddf8ee270e7..9b25a6301fa5 100644
>>>>> --- a/include/linux/netdevice.h
>>>>> +++ b/include/linux/netdevice.h
>>>>> @@ -3054,7 +3054,7 @@ static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
>>>>>                                     const void *daddr, const void *saddr,
>>>>>                                     unsigned int len)
>>>>>    {
>>>>> -       if (!dev->header_ops || !dev->header_ops->create)
>>>>> +       if (!dev || !dev->header_ops || !dev->header_ops->create)
>>> Do  you have a repro ?
>> See syzkaller repros attached.
>>
>>> This patch will not prevent a crash later I think.
>> The repro ran overnight without failure with the patch applied.
> Yes, but the patch is hiding a potential bug that might show up with
> other 'repros'
The repro fails when these devices are configured (seem like small mtu):

20: vxcan0@vxcan1: <NOARP,UP,LOWER_UP> mtu 72 qdisc noqueue state UP group default qlen 1000
     link/can
     inet 172.20.20.38/24 scope global vxcan0
        valid_lft forever preferred_lft forever
21: vxcan1@vxcan0: <NOARP,UP,LOWER_UP> mtu 72 qdisc noqueue state UP group default qlen 1000
     link/can
     inet 172.20.20.39/24 scope global vxcan1
        valid_lft forever preferred_lft forever


# diff ../config.fail .config
3325c3325
< CONFIG_CAN_VXCAN=y
---
> # CONFIG_CAN_VXCAN is not set

Thanks,
George

>>> Please fix the root cause, thanks !
>> Will try.
> Thanks, having a repro definitely should help to find the real bug.
>
> I took a look at macvlan , and could not see how vlan->lowerdev  could
> be NULL in the first place.
>
>> Thanks,
>> George
>>>>>                   return 0;
>>>> net_device being NULL during eth header construction? seems like a
>>>> more serious issue?
>>>> If it indeed is a genuine scenario I think a better description is needed...
>>>>
>>>>>           return dev->header_ops->create(skb, dev, type, daddr, saddr, len);
>>>>> --
>>>>> 2.31.1
>>>>>

