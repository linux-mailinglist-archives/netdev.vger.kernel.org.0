Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF9643AE8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiLFBn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiLFBnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:43:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4111BC00
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:43:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B61OAeT017363;
        Tue, 6 Dec 2022 01:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VZ04NvAJPCgaOHxj+srlaQ3WOK62zHSC+BlaECMFYJE=;
 b=k2/5mMEJJPRIaXjPxaIj+xsXtsFvEIz8i0qnAR/y/akM4/xQAXO5TCZrTTHbpkkq6CQN
 0tMeMh/GcrgiK/zddoZZwCv5rTY8x+8ZzM934UyT/+NUfmgwvsDa5YgZvsulosdDVi5P
 0V3crA0m57OUvYpvoH/m5rlHQchudIO8Dmi737/PTRLoKTqOkSsx5na52Po/y+rIqC3s
 ZTGSuu+FoGdQlne9yRTxJjHkD2r9kfjtov6hqgT0qBpalqNqEz6pwCZKKz+877QIeVMm
 r7oyfmmamBF1o1uMr4rfAiXHm1IdlhMqkzpody7kPYZH4HOVpkx6SnqbojAkrDvP+oit kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ydje33x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 01:43:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B5NCXos027839;
        Tue, 6 Dec 2022 01:43:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m8uaa3tcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 01:43:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeXQXGqwRzMcKxVqYVoX+X68ddB7A/hvVrx5S+ZOeuxLSRhy9VS75Vd0h5Kyl8dxM99OqkN8UbXgqoE0xrZvkRb02RGZMrcY9YbojZWAk3ATClO01ISXrY+lvpX4ii42/gmUqhwJ5tKIGzquZV+SaUtsjlPKcmC24N06lZWEJ4ic/nfy7biflWOi75XtFIEG5ZM5OxnXBeDxO0LjxtC2hb6pI37LMKJI4r5CGLapUsyq7VzINbk0vejpzF0cmXHUpWeJI7RPV4gqy2vybN812m/0/VC3u8CSlasgjnhMP55KPYMveESksxwmccDdJN5cPRDrfOX7vvJiTDGB+BAOyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZ04NvAJPCgaOHxj+srlaQ3WOK62zHSC+BlaECMFYJE=;
 b=MQfKv8uoM3/RPQ1CK0h3Hh4WMB0KkwisdH+Rzv5IM2wqjcHGSc+zDC2/HSkNhPq4HpTQQrDR1Wo4kxDOoNb6kdr0HdTccYGya5wRPeMtkrnDKpS3H3kjMKszWpkITAovLS4eP8RqaFFSCs8SLNpMOxU0TcG1qjttuonEaNWKvo27HWJVgguWTmSoQu23A3U2pz3ZCty6Q6UUCgDr9lFjUsiQj8HOOo8vR+8dhTQef/soLPnXtLXbcGfeaKOXGZSs5W5Jpo1kn2XPUGkSxYYHGlL+KHmjg13t1HSKP/wqR4+sfpTkeJI76Yl5ynlqrs5ywc3E2Ya/eke+Y6G4g1lxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZ04NvAJPCgaOHxj+srlaQ3WOK62zHSC+BlaECMFYJE=;
 b=qVH0YwjsYo3i5e+td0v67M9uT0R1dHPe15cFq37FseXYryNbAVn6M20vpSGqFubWbi31nYH8C0A9kW13JXc/pRfE4mlBsFhiPCNVc33bvxH2Y2sDuOgnvOJG6cD4CDaywk2/f4EyFnzXnpsqR103/27yJbOCPjzDB9tTKncBrfM=
Received: from MW4PR10MB6535.namprd10.prod.outlook.com (2603:10b6:303:225::12)
 by SA2PR10MB4508.namprd10.prod.outlook.com (2603:10b6:806:11d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 01:43:09 +0000
Received: from MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5]) by MW4PR10MB6535.namprd10.prod.outlook.com
 ([fe80::d1e:40c4:40e3:e7b5%2]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 01:43:09 +0000
Message-ID: <153061e3-4623-38f5-c1b6-3177fc01fcec@oracle.com>
Date:   Mon, 5 Dec 2022 17:42:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
References: <20221117033303.16870-1-jasowang@redhat.com>
 <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
 <CACGkMEtLFTrqdb=MXKovP8gZzTXzFczQSmK0PgzXQTr0Dbr5jA@mail.gmail.com>
 <74909b12-80d5-653e-cd1c-3ea6bc5dbbde@oracle.com>
 <CACGkMEs7EGUsJ8wtZsj7GEMD9vD6vJNVRUu1fcwUWVYpLUQeZA@mail.gmail.com>
 <d4a85c3b-ab0b-a900-06a9-25abdf264e97@oracle.com>
 <CACGkMEsN7H4=DqyNWrwLhd+zdfhiYohyB7GmUi8iUH73Z9KxYA@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEsN7H4=DqyNWrwLhd+zdfhiYohyB7GmUi8iUH73Z9KxYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:806:f2::33) To MW4PR10MB6535.namprd10.prod.outlook.com
 (2603:10b6:303:225::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR10MB6535:EE_|SA2PR10MB4508:EE_
X-MS-Office365-Filtering-Correlation-Id: ef1cabe0-88fa-44d5-0b71-08dad72b394f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKpVam9ZGrsA8iCmg0m+ZuXGCI4aq19p5/uybtHFdZReKq/r0tObicJ/72yX7TSrqzV3qYwBPBcF5Lw5xALnID3FXtO1nFVJPvEaeKdKeqKfV54Wl5QZx37UskqFQ2bEyam1+uuuScFgI41vltBkEnO5V33nSJNcuJYpUQFaOiVoQ1Wk5KxiFZHrYI1ojlvEOjj8+n6V4kovcik1s8ajcxOjylUOZf7LcQUeqfsHF61z38mX6QGpekBC+9KRNIUNv+l4GdR0+LYy45CAyG072zi/y6h4QYtJsDhmx/Kmi+BEtlVfW6a3N9qeHYKze+t75eZchXvllUwMToo5aQe4t7plhryHdH6oqT71LaKxpmKd9DCAiyKUpLYXEO/RXgObYAp6YMVYiNDfXojl2i9OJ+DVdHDWZC0wqTn4MG6pLC7fZDZdGWtvNZLaUdI7RUlzQxN2ji6kMwHNb2an1ifK+xoYHEyTMfoV+s7y6FeS0tiFilHDDYqKipLO6tmbFz1IhSXNTjy8WbmzHW9gpeUHst2C2VpDG2DKodgDZ0r5J21dWbbxy+t2vUY9n8Eb9I0ggJfVZ7S3Rui4Rm/5fiU0R94nUIT2ATiTe2fYABtpyCeWMQs87cd2kxtHKUfCXUKbYVPX/PFu3faC3H0d9iXRByJ3EbX4cYxCN/WQf+KZuUKSnu1qpxim2Ve5/WvcHvslo9v/wq3KDPdmFBy8UsBbhAvWq0+g1Qqec7jLswXFpeIrmbozShi1d8K3ynmAlBCt+ISO4EWW/jBYAqzBzJ/MBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR10MB6535.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(83380400001)(26005)(186003)(6512007)(41300700001)(8936002)(38100700002)(2616005)(5660300002)(6506007)(30864003)(6916009)(36756003)(6486002)(966005)(4326008)(6666004)(2906002)(478600001)(53546011)(316002)(31686004)(66899015)(31696002)(86362001)(66946007)(36916002)(8676002)(66556008)(66476007)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjIzR2p4cGlxYld3ME8zV1JtU2I4MXVHNEkvcE1YL0JLNC8zaW1ENlJWdFhU?=
 =?utf-8?B?V3dyUi9ERzNPeHdSRHlTaUZFaGFoUGsxN3Z0MDNqOU1aQkhjUlVEQlpaUytJ?=
 =?utf-8?B?TG43ZUQ0d0J0SndXbmxXcG1HanRrS0dLd1pabllDdUIvZkdlK1dxMTF6TFpW?=
 =?utf-8?B?MjUwN09WRWlYSFVQV1JaTmpwSktWSkJ0OVZnblEwSlVhSnhzM2EvVlVQbjVj?=
 =?utf-8?B?ckRUR1JpRTd5VUhrblVFcGhSRmdGRzFuSzJQU1g1ckp6aURtYUV6NDNONXlT?=
 =?utf-8?B?YzVoSDRWb2xtR2RGdUd3NVN4dWkrS2Y1YVpZaGJxWUVTWXJFdWtwb1VIMzdu?=
 =?utf-8?B?MFNkQzIwL21ud1gwa2pxSUdSVk5nVElPVUEzZElHT0JkOEZzUUV6Y3VaMFI3?=
 =?utf-8?B?dllKVDRGRzUzbEZDNWNQL01GdDZab1BQTk9OTEYwMFg5b2IxTVp3S2VaVkRM?=
 =?utf-8?B?SGZLeWFGS0pEeTFqUjB5ODdHTDZCY0Znd1F4TStLTER2UlNOV3Nrck44alNH?=
 =?utf-8?B?RUtuUFhDbjFZaWpDYUZEY1BUWWpQQlRERmI1OXhtd3FleHR3dUxGbE9TcUVq?=
 =?utf-8?B?ZnpQUnVhWklNdjgyV0VtSGd1Q2htM2l6Q2cycEtZcGhwM0FGb0dBeU1Sak9K?=
 =?utf-8?B?dkVpeEdNT3drcHU2dGhUVlVJZ3kvWFovVTlYUzI4WWZsSEJmZTJ0S3Arb3NR?=
 =?utf-8?B?dGVwREVpTEJOWHIvZElpbDNxS2g3R0prdmxFRi9ZTWpuclp4eU05cDVpdlFv?=
 =?utf-8?B?d1ozSE1FcGhHem05aDVKNnIvYlNKajFKcUNlNTRoZnN1OURDcHFQY3Z1Nmtp?=
 =?utf-8?B?RHhZNnFneksyT2VOK1dOV0JSNGZiYWE3bkgwSkN0Vms0QXBoT0lBZmNteGhr?=
 =?utf-8?B?Q3MwZm9yalgwbTIzNXdHalRkRStTMjBzeEtPVnE0UjhPSnhoVGpWSW9nSWJj?=
 =?utf-8?B?ZktBa3M1TmZpcjhwc1hMSy9Ka2FaZzI3S2gwMXpXZGQ2VEQ5YXpiSHJWNFRh?=
 =?utf-8?B?T0RMSEp0dGdVQmd6bC9uY0Y0d0hWcVZ4YmNSM2FsNDBLaUduNmk2ZXBkZXBI?=
 =?utf-8?B?VnArRURDTmxVNGRKNVdRRkJLczlES2MzaEU3a1pWOFFiQTd5Q1pUNVpsMmQr?=
 =?utf-8?B?YUVPMkF6MkNmZUpRc285Mk5yVUdkL1pHLzBBM2xhZWM2ZVVnNE9HVWV4MU9s?=
 =?utf-8?B?YnBkNXV0MGUzY0V3eXRRMktqM00rWU84amVwRS93OGEwaU9XYUFQdWg5b3ow?=
 =?utf-8?B?Y0Q3RVVjVElVNFJtUlFCYktUR1RkVjh0WHd2Y3lrS1YwVXk4Yi9MZlNXL0N1?=
 =?utf-8?B?amtBV1M0Q2YreER2N28vYXNnNzdWZ0dXY0xMTUdoajIwVFYwdnN5NGFRazUx?=
 =?utf-8?B?SmNRdi9iY28rTTJ3RTI0VmtNSHNNTWQ1ZkFDUVFwQjV4OGN1WWovR2UwUUhT?=
 =?utf-8?B?dzlPUE0xSnZwTHV3RW85YkdpSlo2ek9LQUZxS1hoUHA1V0J4MUVKVUdrZ3JO?=
 =?utf-8?B?ZkRFY00zNU91VGhwVmZEdFNQUVhHOHU2Ym94NUpiUEQzSTFtaG0ySmF5cXNl?=
 =?utf-8?B?Ky82RkVCQlFUTmVmbUVta0VhbkVzUW9ZMWoyWGNySVV0UHhQWVBjUlk1T2NV?=
 =?utf-8?B?S1RxUHBnUEtqUllrTFM2ZGZVL29SVG5Cam9DTWFISXBRcmtnMkFGT1lDZ0NW?=
 =?utf-8?B?NXVzaFVmdFRXWWVlYjVmRklPdFpLUFR0aENKOXhMS0VhUkI0SS9kYUZKZEhS?=
 =?utf-8?B?cS80a2NOQTlwaUxwSmFMMGN4WmhweG1uYXkwak5NU3NBSmw2MEo1SG5JQWY5?=
 =?utf-8?B?bTVlREV0SE1yR1M5NFNhRXVKTmVVTXFRTGtPcjA1T3p4SkpJQ0xWY3NhMTJk?=
 =?utf-8?B?bGpCSG1OTkdJRlVQN1h5bG9najNHOXBHZ1ZDZzdNNnE3THFtWWY4OTY2ejZv?=
 =?utf-8?B?Z1o5NDZBaDJlSnBHVXdubjRtWStHdFFqWjRPN2RkUHlMdTJkU09VcGU2VnlF?=
 =?utf-8?B?TkRpZlhzd2YyT01UUmh6TGYxRnhGZmJqYjVHS3ZJU0NNQWlnc3g5QUNtdXlp?=
 =?utf-8?B?NTkwbStWOStHYTliS0I5MGVrMk5hdGVUeFBnSm9HcTlJSVU1QXN2bW9WTDBp?=
 =?utf-8?Q?4sf2Ca+fXdFY60mJ90towHZSL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Vzg0S3FYeVAzNnh5cGMvTms4aGNZQjAyMVFxQzlyTWcyeDBwcmRvR1Bucllw?=
 =?utf-8?B?MnYyaGRnUXBlSXUyNk5kRnBNUE5LbzUxNXZhTkxUaTlpS3p5RDBGU3VXaXhu?=
 =?utf-8?B?ZklTYXlURnBGTVNmbFpkSHoxdTk1eFA0cjl1dGt0V0lCYXE3MVZyT0tkSHJa?=
 =?utf-8?B?SnFLdlZtN1Y4V01TMWNDMEpYdmgyanRieEtPd2JVZCswQ3daY05mbXV5bXJJ?=
 =?utf-8?B?eDFtdkttNGQydTFWM0RUR2ZVZitpQk9sblo3NGVReVRKdXZtWGJxRUY4eEwy?=
 =?utf-8?B?d0V1M21vMTZSRmNwUTAvSkRPcGZoQy9jQnpYdEpDUU5OamIyRUNWZENGdGpC?=
 =?utf-8?B?YlJFYW1jZ3k1NE5PQTFtb2F0Uk4zbHV2NGtFVGxIRUlNeER6anpzYVEyR1cw?=
 =?utf-8?B?NHJYdmFFdCt0N29rQWx4MXJIMU9VWkcwei8zRCtyYXQvVmppVFo5ck5MdkZ0?=
 =?utf-8?B?Z1pHZGllMUdwUVZaRWhNK09hcWZHcG95S3VBNGFrUG5RckZLOXkydTAwUDV5?=
 =?utf-8?B?UXJRQWNZdUlDUjdjNFMwczZWMzFXQnNaVU9LQk5RbmhnS3BRSXFLSElVUWVM?=
 =?utf-8?B?cmxERC9CV2ZuQUhzRGNCdVB5dWJLM0liem0renI1WjJkQzN0cHBMdWcyRjZq?=
 =?utf-8?B?YUozdkU2YWZMY1FZU0ZUU1M5QnBBbDFhVE9yYzkxL0h3NHBKaGdKdHBLdFlC?=
 =?utf-8?B?a3luSTZFYjNLbzdEazFmcStxNEFGZXlqeW5WRzVPMjA3cnVsSEt0OUFTTDZM?=
 =?utf-8?B?N2RXbmEwVlEwVytvRlpta2cvVk0wRXp5WmkrUnBHTTk3YUs3ZC9yWkRvV1Uy?=
 =?utf-8?B?WjRmNVNjTXk1TFkrZ3VLRnZLalpOby82VmxUc3Q1bitNMjR5TWFlcXNCYzdF?=
 =?utf-8?B?VkhtM0ZOdTBDaDc5dHBZNndVeUsvdzZVdmdIU1VpK0hFTE5DQTdNM1JyOU5B?=
 =?utf-8?B?bzhPWnhjdW5IRWRkalp1eUFXNTRUOE12eExFemZxcGl1RnpNNUcrajNSaTNr?=
 =?utf-8?B?THBOVWNqd0tXR3lqRVhGVzRUamhQRDRSejJRaWxFV1hYVCtNMWhVUDZ4dWtQ?=
 =?utf-8?B?a21JWmhMdkdkVkJpZzdRVmlYY1A4cDk4MVZVS2haOWUvMmxQcXZxUm95V2xq?=
 =?utf-8?B?bzhCeXdYclNocGpHcDlLejFsRkZwOVAxalVyR3ZydzRSSEM0UXVGdjlIaENj?=
 =?utf-8?B?WGp1Ty9xOGRJUmEzOGRYZDVFTVVsaHR4L0tueU42bmxvZzltVWxmbkdvRGdZ?=
 =?utf-8?B?ak1HcnVUdTRtR3prdEM4bDdCZDAwZVR0VjN3YW5yaUlQaTBnRGpTQjA4WWRq?=
 =?utf-8?Q?Lc1RJk59EUAa+PuH1rPG8fDIrEknuCVcd0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1cabe0-88fa-44d5-0b71-08dad72b394f
X-MS-Exchange-CrossTenant-AuthSource: MW4PR10MB6535.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 01:43:08.9844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8eX5Qn7HOkSkt2/35yALkIre/CT6CiqqNx6O6MdfKtb71XVjHjE3ZPyLRlphYTBJGNbKt1UPNrmPGeD4LHZ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060009
X-Proofpoint-ORIG-GUID: EmZquzHPIhtUO3uCsKlBc3KHXSPx2Jlq
X-Proofpoint-GUID: EmZquzHPIhtUO3uCsKlBc3KHXSPx2Jlq
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/2022 10:46 PM, Jason Wang wrote:
> On Thu, Dec 1, 2022 at 8:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>> Sorry for getting back late due to the snag of the holidays.
> No worries :)
>
>> On 11/23/2022 11:13 PM, Jason Wang wrote:
>>> On Thu, Nov 24, 2022 at 6:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>
>>>> On 11/22/2022 7:35 PM, Jason Wang wrote:
>>>>> On Wed, Nov 23, 2022 at 6:29 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>>> On 11/16/2022 7:33 PM, Jason Wang wrote:
>>>>>>> This patch allows device features to be provisioned via vdpa. This
>>>>>>> will be useful for preserving migration compatibility between source
>>>>>>> and destination:
>>>>>>>
>>>>>>> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
>>>>>> Miss the actual "vdpa dev config show" command below
>>>>> Right, let me fix that.
>>>>>
>>>>>>> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
>>>>>>>           negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
>>>>>>>
>>>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>>>>>> ---
>>>>>>> Changes since v1:
>>>>>>> - Use uint64_t instead of __u64 for device_features
>>>>>>> - Fix typos and tweak the manpage
>>>>>>> - Add device_features to the help text
>>>>>>> ---
>>>>>>>      man/man8/vdpa-dev.8            | 15 +++++++++++++++
>>>>>>>      vdpa/include/uapi/linux/vdpa.h |  1 +
>>>>>>>      vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
>>>>>>>      3 files changed, 45 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
>>>>>>> index 9faf3838..43e5bf48 100644
>>>>>>> --- a/man/man8/vdpa-dev.8
>>>>>>> +++ b/man/man8/vdpa-dev.8
>>>>>>> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
>>>>>>>      .I NAME
>>>>>>>      .B mgmtdev
>>>>>>>      .I MGMTDEV
>>>>>>> +.RI "[ device_features " DEVICE_FEATURES " ]"
>>>>>>>      .RI "[ mac " MACADDR " ]"
>>>>>>>      .RI "[ mtu " MTU " ]"
>>>>>>>      .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
>>>>>>> @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
>>>>>>>      Name of the management device to use for device addition.
>>>>>>>
>>>>>>>      .PP
>>>>>>> +.BI device_features " DEVICE_FEATURES"
>>>>>>> +Specifies the virtio device features bit-mask that is provisioned for the new vdpa device.
>>>>>>> +
>>>>>>> +The bits can be found under include/uapi/linux/virtio*h.
>>>>>>> +
>>>>>>> +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit values.
>>>>>>> +
>>>>>>> +This is optional.
>>>>>> Document the behavior when this attribute is missing? For e.g. inherit
>>>>>> device features from parent device.
>>>>> This is the current behaviour but unless we've found a way to mandate
>>>>> it, I'd like to not mention it. Maybe add a description to say the
>>>>> user needs to check the features after the add if features are not
>>>>> specified.
>>>> Well, I think at least for live migration the mgmt software should get
>>>> to some consistent result between all vdpa parent drivers regarding
>>>> feature inheritance.
>>> It would be hard. Especially for the device:
>>>
>>> 1) ask device_features from the device, in this case, new features
>>> could be advertised after e.g a firmware update
>> The consistency I meant is to always inherit all device features from
>> the parent device for whatever it is capable of,
> This looks fragile. How about the features that are mutually
> exclusive? E.g FEATURE_X and FEATURE_Y that are both supported by the
> mgmt?
Hmmm, in theory, yes, it's a bit cumbersome. Is this for future proof, 
since so far as I see the virtio spec doesn't seem to define features 
that are mutually exclusive, and the way how driver should respond to 
mutually exclusive features in feature negotiation is completely undefined?

>
>> since that was the only
>> reasonable behavior pre-dated the device_features attribute, even though
>> there's no mandatory check by the vdpa core. This way it's
>> self-descriptive and consistent for the mgmt software to infer, as users
>> can check into dev_features at the parent mgmtdev level to know what
>> features will be ended up with after 'vdpa dev add'. I thought even
>> though inheritance is not mandated as part of uAPI, it should at least
>> be mentioned as a recommended guide line (for drivers in particular),
>> especially this is the only reasonable behavior with nowhere to check
>> what features are ended up after add (i.e. for now we can only set but
>> not possible to read the exact device_features at vdpa dev level, as yet).
> I fully agree, but what I want to say is. Consider:
>
> 1) We've already had feature provisioning
> 2) It would be hard or even impossible to mandate the semantic
> (consistency) of the features inheritance.
>
> I'm fine with the doc, but the mgmt layer should not depend on this
> and they should use feature provisioning instead.
OK, if it's for future proof to not mandate feature inheritance I think 
I see the point.

>
>>> 2) or have hierarchy architecture where several layers were placed
>>> between vDPA and the real hardware
>> Not sure what it means but I don't get why extra layers are needed. Do
>> you mean extra layer to validate resulting features during add? Why vdpa
>> core is not the right place to do that?
> Just want to go wild because we can't expect how many layers are below vDPA.
>
> vDPA core is the right place but the validating should be done during
> feature provisioning since it's much more easier than trying to
> mandating code defined behaviour like inheritance.
OK, thanks for the clarifications.

>
>>>> This inheritance predates the exposure of device
>>>> features, until which user can check into specific features after
>>>> creation. Imagine the case mgmt software of live migration needs to work
>>>> with older vdpa tool stack with no device_features exposure, how does it
>>>> know what device features are provisioned - it can only tell it from
>>>> dev_features shown at the parent mgmtdev level.
>>> The behavior is totally defined by the code, it would be not safe for
>>> the mgmt layer to depend on. Instead, the mgmt layer should use a
>>> recent vdpa tool with feature provisioning interface to guarantee the
>>> device_features if it wants since it has a clear semantic instead of
>>> an implicit kernel behaviour which doesn't belong to an uAPI.
>> That is going to be a slightly harsh requirement. If there's an existing
>> vDPA setup already provisioned before the device_features work, there is
>> no way for it to live migrate even if the QEMU userspace stack is made
>> live migrate-able. It'd be the best to find some mild alternative before
>> claiming certain setup unmigrate-able.
> It can still work in a passive way, mgmt layer check the device
> features and only allow the migration among the vDPA devices that have
> the same device_feature.
Right, that is the scenario in concern which I'd like to get support 
for, even though it's passive due to incompleteness in previous CLI 
design (lack of individual device feature provisioning). Once the tool 
is upgraded, vdpa features can be provisioned selectively on the 
destination node, matching those on the source.

>   Less flexible than feature provisioning.
>
>>> If we can mandate the inheriting behaviour, users may be surprised at
>>> the features in the production environment which are very hard to
>>> debug.
>> I'm not against an explicit uAPI to define and guard device_features
>> inheritance, but on the other hand, wouldn't it be necessary to show the
>> actual device_features at vdpa dev level if it's not guaranteed to be
>> the same with that of the parent mgmtdev?
> I think this is already been done ,or anything I miss?
The kernel patch is not merged yet, preventing the userspace patch from 
being posted. While the ideal situation is to allow query of 
device_features after adding a vdpa dev (for e.g. if not 100% inherited 
from the parent mgmtdev), followed by allowing selectively provision 
features individually.

>
>> That is even needed before
>> users are allowed to provision specific device_features IMO...
>>
>> (that is the reason why I urged Michael to merge this patch soon before
>> 6.1 GA:
>> https://lore.kernel.org/virtualization/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/,
>> for which I have a pending iproute patch to expose device_features at
>> 'vdpa dev show' output).
> Right.
>
>>>> IMHO it's not about whether vdpa core can or should mandate it in a
>>>> common place or not, it's that (the man page of) the CLI tool should set
>>>> user's expectation upfront for consumers (for e.g. mgmt software). I.e.
>>>> in case the parent driver doesn't follow the man page doc, it should be
>>>> considered as an implementation bug in the individual driver rather than
>>>> flexibility of its own.
>>> So for the inheriting, it might be too late to do that:
>>>
>>> 1) no facility to mandate the inheriting and even if we had we can't
>>> fix old kernels
>> We don't need to fix any old kernel as all drivers there had obeyed the
>> inheriting rule since day 1. Or is there exception you did see? If so we
>> should treat it as a bug to fix in driver.
> I'm not sure it's a bug consider a vDPA device have only a subset
> feature of what mgmt has.
For example, F_MQ requires F_CTRL_VQ, but today this validation is only 
done in individual driver. We should consider consolidating it to the 
vdpa core. But before that happens, if such validation is missing from 
driver, we should fix those in vendor drivers first.

>>> 2) no uAPI so there no entity to carry on the semantic
>> Not against of introducing an explicit uAPI, but what it may end up with
>> is only some validation in a central place, right?
> Well, this is what has been already done right now before the feature
> provisioning, the kernel for anyway needs to validate the illegal
> input from userspace.
Right. What I meant is the kernel validation in vdpa_core should be done 
anyway regardless of any new uAPI (for feature inheritance for e.g). I 
guess we are in the same page here.

Thanks,
-Siwei

>
>> Why not do it now
>> before adding device features provisioning to userspace. Such that it's
>> functionality complete and correct no matter if device_features is
>> specified or not.
> So as discussed before, the kernel has already tried to do validation,
> if there's any bug, we can fix that. If you meant userspace
> validation, I'm not sure it is necessary:
>
> 1) kernel should do the validation
> 2) hard to keep forward compatibility, e.g features supported by the
> mgmt device might not be even known by the userspace.
>
> Thanks
>
>> Thanks,
>> -Siwei
>>
>>> And this is one of the goals that feature provisioning tries to solve
>>> so mgmt layer should use feature provisioning instead.
>>>
>>>>>> And what is the expected behavior when feature bit mask is off but the
>>>>>> corresponding config attr (for e.g. mac, mtu, and max_vqp) is set?
>>>>> It depends totally on the parent. And this "issue" is not introduced
>>>>> by this feature. Parents can decide to provision MQ by itself even if
>>>>> max_vqp is not specified.
>>>> Sorry, maybe I wasn't clear enough. The case I referred to was that the
>>>> parent is capable of certain feature (for e.g. _F_MQ), the associated
>>>> config attr (for e.g. max_vqp) is already present in the CLI, but the
>>>> device_features bit mask doesn't have the corresponding bit set (e.g.
>>>> the _F_MQ bit). Are you saying that the failure of this apparently
>>>> invalid/ambiguous/conflicting command can't be predicated and the
>>>> resulting behavior is totally ruled by the parent driver?
>>> Ok, I get you. My understanding is that the kernel should do the
>>> validation at least, it should not trust any configuration that is
>>> sent from the userspace. This is how it works before the device
>>> provisioning. I think we can add some validation in the kernel.
>>>
>>> Thanks
>>>
>>>> Thanks,
>>>> -Siwei
>>>>
>>>>>> I think the previous behavior without device_features is that any config
>>>>>> attr implies the presence of the specific corresponding feature (_F_MAC,
>>>>>> _F_MTU, and _F_MQ). Should device_features override the other config
>>>>>> attribute, or such combination is considered invalid thus should fail?
>>>>> It follows the current policy, e.g if the parent doesn't support
>>>>> _F_MQ, we can neither provision _F_MQ nor max_vqp.
>>>>>
>>>>> Thanks
>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>>>
>>>>>>> +
>>>>>>>      .BI mac " MACADDR"
>>>>>>>      - specifies the mac address for the new vdpa device.
>>>>>>>      This is applicable only for the network type of vdpa device. This is optional.
>>>>>>> @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
>>>>>>>      Add the vdpa device named foo on the management device vdpa_sim_net.
>>>>>>>      .RE
>>>>>>>      .PP
>>>>>>> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
>>>>>>> +.RS 4
>>>>>>> +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
>>>>>>> +.RE
>>>>>>> +.PP
>>>>>>>      vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
>>>>>>>      .RS 4
>>>>>>>      Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
>>>>>>> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
>>>>>>> index 94e4dad1..7c961991 100644
>>>>>>> --- a/vdpa/include/uapi/linux/vdpa.h
>>>>>>> +++ b/vdpa/include/uapi/linux/vdpa.h
>>>>>>> @@ -51,6 +51,7 @@ enum vdpa_attr {
>>>>>>>          VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>>>>>>          VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>>>>>>>          VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>>>>>>> +     VDPA_ATTR_DEV_FEATURES,                 /* u64 */
>>>>>>>
>>>>>>>          /* new attributes must be added above here */
>>>>>>>          VDPA_ATTR_MAX,
>>>>>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
>>>>>>> index b73e40b4..d0ce5e22 100644
>>>>>>> --- a/vdpa/vdpa.c
>>>>>>> +++ b/vdpa/vdpa.c
>>>>>>> @@ -27,6 +27,7 @@
>>>>>>>      #define VDPA_OPT_VDEV_MTU           BIT(5)
>>>>>>>      #define VDPA_OPT_MAX_VQP            BIT(6)
>>>>>>>      #define VDPA_OPT_QUEUE_INDEX                BIT(7)
>>>>>>> +#define VDPA_OPT_VDEV_FEATURES               BIT(8)
>>>>>>>
>>>>>>>      struct vdpa_opts {
>>>>>>>          uint64_t present; /* flags of present items */
>>>>>>> @@ -38,6 +39,7 @@ struct vdpa_opts {
>>>>>>>          uint16_t mtu;
>>>>>>>          uint16_t max_vqp;
>>>>>>>          uint32_t queue_idx;
>>>>>>> +     uint64_t device_features;
>>>>>>>      };
>>>>>>>
>>>>>>>      struct vdpa {
>>>>>>> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
>>>>>>>          return get_u32(result, *argv, 10);
>>>>>>>      }
>>>>>>>
>>>>>>> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
>>>>>>> +                          uint64_t *result)
>>>>>>> +{
>>>>>>> +     if (argc <= 0 || !*argv) {
>>>>>>> +             fprintf(stderr, "number expected\n");
>>>>>>> +             return -EINVAL;
>>>>>>> +     }
>>>>>>> +
>>>>>>> +     return get_u64(result, *argv, 16);
>>>>>>> +}
>>>>>>> +
>>>>>>>      struct vdpa_args_metadata {
>>>>>>>          uint64_t o_flag;
>>>>>>>          const char *err_msg;
>>>>>>> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>>>>>>>                  mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>>>>>>>          if (opts->present & VDPA_OPT_QUEUE_INDEX)
>>>>>>>                  mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
>>>>>>> +     if (opts->present & VDPA_OPT_VDEV_FEATURES) {
>>>>>>> +             mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
>>>>>>> +                             opts->device_features);
>>>>>>> +     }
>>>>>>>      }
>>>>>>>
>>>>>>>      static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>>>>>>> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>>>>>>>
>>>>>>>                          NEXT_ARG_FWD();
>>>>>>>                          o_found |= VDPA_OPT_QUEUE_INDEX;
>>>>>>> +             } else if (!strcmp(*argv, "device_features") &&
>>>>>>> +                        (o_optional & VDPA_OPT_VDEV_FEATURES)) {
>>>>>>> +                     NEXT_ARG_FWD();
>>>>>>> +                     err = vdpa_argv_u64_hex(vdpa, argc, argv,
>>>>>>> +                                             &opts->device_features);
>>>>>>> +                     if (err)
>>>>>>> +                             return err;
>>>>>>> +                     o_found |= VDPA_OPT_VDEV_FEATURES;
>>>>>>>                  } else {
>>>>>>>                          fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>>>>>>>                          return -EINVAL;
>>>>>>> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
>>>>>>>      static void cmd_dev_help(void)
>>>>>>>      {
>>>>>>>          fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
>>>>>>> -     fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
>>>>>>> -     fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
>>>>>>> +     fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
>>>>>>> +     fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
>>>>>>> +     fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
>>>>>>>          fprintf(stderr, "       vdpa dev del DEV\n");
>>>>>>>          fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
>>>>>>>          fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
>>>>>>> @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>>>>>>>          err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>>>>>>>                                    VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
>>>>>>>                                    VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
>>>>>>> -                               VDPA_OPT_MAX_VQP);
>>>>>>> +                               VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
>>>>>>>          if (err)
>>>>>>>                  return err;
>>>>>>>

