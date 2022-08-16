Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF53596531
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbiHPWJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiHPWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:09:54 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE475721C;
        Tue, 16 Aug 2022 15:09:53 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GL9IQf004831;
        Tue, 16 Aug 2022 22:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TOfezMn8tr2dDy7mAcOHMoGf4CABqA3hFF3L79NYj/A=;
 b=IHk6ypturmlwMaNhmc2jm4OwLR6n5ckzvUtcQmHzvfNbY5MPs5QR4P9+7rzBALpEJZHo
 DkO5AmTG67MEIj0qqRT93YRFwAduml/tCW8M3JywEXKRguZ4papQDIB6rXefhKQI7ClD
 oza73pgZonrAcfGJCJYpHVSioA4VgcIERIseveXe6IP5TZvTIpzuIaFmmVuhCmvMTyt7
 Sr0+3Z+SfKHyAaHP37efTxIkyNv/ACUL6/LY6q22apXAmZ27dGorkohPnMLnLrjNLpxB
 /6AIbDdV3U+rCtM+WUTO1Ps25zG7uMlVxpFwV2hDKxJSWqi66k8dD1x+zBw6MxZEeU2O 2Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx3ua75vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 22:09:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27GL98dd004273;
        Tue, 16 Aug 2022 22:09:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j0c2aewqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 22:09:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7JlFTV0Uv4/bgU7oI+wnotvSG7I2wWlQB6qcxNjsU19MJPEltDdY80VtJqSNopflQg3SOAv/WQcFyA/Oh3s77jFR5ieecRpjeT9OffFgY3CFD2RSyFQyEkLOY5Ux1aSEbVBz3r4VwIsq02AYpxX7nshHxzppcPw1jTmdM9WpCaxgPQ1T5okIBJcwXFbXDPiax5xJQlTOQtqZGXGvh8B6zizhV5uk7FRw5hf57hwWbfN7SvZzVfz2GWNc7oqXof/W0r2OBkIwvDgRrHqnvr2Yp4GtMUHSY1G/AbyetgK4rxdDqq8pjlSHe2UHYgO5ZJmkzPz1cena4YmCDmpe86PlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOfezMn8tr2dDy7mAcOHMoGf4CABqA3hFF3L79NYj/A=;
 b=Uw3ubaxuSHBmqv9DGzi4q8kgVTRJQahr+605Nc6Gaz+VKqNxX0VR3u7kVhz4GppeNDo4ak2O4d+OzeAP5SrhkislVjGyFE7ICVWVm26Tcq5D+HzymMiK8bS08RRcriQJUaDhZgsrJhGmxAAuXPsLpgct/Esdcm7SsZ7UnvihQ7D6IKh1ZP0wJHvkMormBavhbJE3trNRj/1zgJ7jwUEQ1GQkH8NmBBpGUFE5IhYJ6TtMybQDEHd1zYIQFYRGEpd0QJ/aNjeEVPxoNzYdXnJ1DkU+ExToeRK96Tk+U83e29pIn8m/Bc16UJNd/FlcZCPu6zMjzv5fYl1/AphuGP6Nmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOfezMn8tr2dDy7mAcOHMoGf4CABqA3hFF3L79NYj/A=;
 b=cWQ6HxZEy3C1V8xvUWF/F/ybErATHMlKuYaEn5r0TFY94/rRl+CEg5aa3bK58kL1BlR2djNvvxe9//JgzDJ/e99eoVWWfwlRsIJ7o2uXg8Bh+FkhZB7+a1QZSalbGdH1DreuB7SCOq/r3GFSBDC0CCYva8RNAI3u/QaCa1AY/cw=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 16 Aug
 2022 22:09:43 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 22:09:42 +0000
Message-ID: <a0675cf2-e711-9a2f-44fe-9bbd1ce27dba@oracle.com>
Date:   Tue, 16 Aug 2022 15:09:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
 <20220816171106-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220816171106-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0167.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::22) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29f8598d-8746-47e2-a9aa-08da7fd40547
X-MS-TrafficTypeDiagnostic: CY8PR10MB6443:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPTzkVz6E7eb7V3RAmoUzeDKfaMqfKVUV/59rljXP4ce/2L4Bd8l7VpSc7QrEPKBMWU6M8RIALEipGtxwzjIWSwAUQRS9mIuNe3z/lm8booPhmePAIYBeTJsS3MhWjjbLvsSHb7DaJCyJZVLvBFLZfc2AQ6rhbM7FzmzwcwACTfEIeEruA0AD8DYRTO0FtJmMNZ72bLnZH7lEWjVl8Z4x8xPLYYNw1ROsWSttR4+RoroA9aKzi+rvA7pfarXq5W/ea1Sh1zQzi9sozCxKq++pS5LU8ZzORUPC9J0jE7lvX+VhnE0fIflVT9QLTE/k1ILZQbfrtGU+zRHVmMV2X4GMhadHWwFJVQQbbLzTLv7gzoah0I+QPs+4/w19xYQRKgJ3Jx26bnXz+tc6Qyy/pRnz7Dwpsb5aURGEyO86w7Q+/0MXxqs10wR0G1EFR4evNy2u1nqc9FKLJ3BRzB0YwHdONwS+yGZ6XLS7SPoJjV1SxTbJyHyDXiEZbUmAv/rmg6OeyV9th4pQ9WVNYC3kIa2l8KJ1HVUKwiPbCGUjt5y0FVABxg4nhMdTcMUhbJZI0Z/V5Mnz5wN/BgpgaQX1iCPdMLf8VlCR4+QJ3ZzVQk77q4API4OTGGihBxDf1niQFcqXgk6TsYFU1r7MYTLKcqRPBoYsZFMF/WJF9NqOxtX+bYjkQOJywsJPQKeMgHa+1tOttmpRNZvpbRZcMdTGymww6tvmhLQsvOsR6GGglZDCg+z9eA9fJBYatJyIIRVRX1F/tPTTnP1waukCSB9v6aXsl99uxtCCpD24T2JhgX7qSMlFPEpCk7VNDYhabRkPD1PO7Ja3rJwo/Sn2awbPpCu/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(136003)(376002)(396003)(39860400002)(66476007)(31686004)(6916009)(6486002)(66946007)(66556008)(5660300002)(4326008)(8676002)(36756003)(36916002)(478600001)(6666004)(53546011)(2616005)(26005)(8936002)(6506007)(6512007)(186003)(2906002)(31696002)(86362001)(41300700001)(83380400001)(316002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0x0VHpIa3FFREE1elJtR2xtVGlEd1dmRlFLMGZlSTU4cEZrL3hjelFiS0dt?=
 =?utf-8?B?K01SRGl2emhuaHc3WW9hTWlxc2IranFkR1lNSzIzY1RwKzdqS21LMWVUUmNU?=
 =?utf-8?B?VEs4blpGY0RqSUZDUGV0dkl4L1luSWh4clVGV0tpOXV6TmlsdlF2ZDU3NEZO?=
 =?utf-8?B?QjFLdkFYTW5NS0RZb3FHQUszWC80WWF0dW9OeTZRSFNTVFR5WThENWdWdzFt?=
 =?utf-8?B?dVNEL0djQXRMV1dwaGg4dXlSUlArbXErT25YSE92eUtmMzhQMTIwbDhKU1FE?=
 =?utf-8?B?bTdXMXR4TkhSejRLOGFnTXhUTlh0cVdrRXRXY3RaRTFFakMvcGRaOVJ0WFIv?=
 =?utf-8?B?eW9WS21hNU00MlFET2VmaEprRjRoRkVKbGV6aDVvWHlFTXJjaU1Ba0l6Wk5H?=
 =?utf-8?B?RmZUTHZSMUFkWUg3cmlmQ2VLOUxrZkV5MytWWkp3ZE1oTXRJeWRqZUxkd0hZ?=
 =?utf-8?B?UEtYRVR6akJ3ZEo2dHdmWVpQN1NnZjh2dU9UOFpoWFIyUWtqMVpYQTJrcXUz?=
 =?utf-8?B?L2U5TktTZC9QaU92QTRscXdiWW1rMVEzeUovNEp2MEk4c0VacEtMVVgzVXJI?=
 =?utf-8?B?Q1dyUXptR1NRM0tjZm5mYldBdWRrdzdQd1dpcE91NlZxUWVTdnltMzZUaG9L?=
 =?utf-8?B?YmZzZjAvek5EVS96RVlJMkdGUFZid1ZDcmFiaTlYWUJGM1FBUHpNeDVraC9t?=
 =?utf-8?B?aEJRY252SDVIZUcyU2JMaEVKNklNMHZRdm50Y3I5bjVFdll5aDVpaTV5eHBP?=
 =?utf-8?B?Q0xoMGkwNlNPN0hYVkdHVFQ0Z2daM3pqMXlBWWtzVlVuSTl5emNld1l1eFdl?=
 =?utf-8?B?S1BOVXZLc0srVkdjLy9GeTF6S1ZXUTltc1V4ZGRJM3dJSXpQTytNMFlYb0Yx?=
 =?utf-8?B?SDByL2tQQlVDNHliM3d0a0RmVXl5djJIR0hkekwzcitsK1dkWGFlNnFEME9i?=
 =?utf-8?B?Q3pXeVBWdEpXRmxvd1IyNnVwYU1BU1IzeVZ4aWNKNkVIclVJZHZNc0FrditW?=
 =?utf-8?B?TmlzSTZrNWpTYzEvcWhYdGNRNGd5dkg2ZjhCUnVla1ZKY0lmWEFJREd1MkF6?=
 =?utf-8?B?RjE1MHpFZWdSeWgvZU5GYVExVWlybENFSjBURmpVV0ZyZlNEV1hlckl2KzlO?=
 =?utf-8?B?YVRVUWNLamhHd2NtMUhTMDc1a0NjS1JuYnBYNGE5Vmh6cWEzTm0vM3ZxdnlZ?=
 =?utf-8?B?WWNhKys2NHpJdzkrenNFaFY1WUszQkxRd01Sb1VQamR0Kys0RzNVUjJDQ0d3?=
 =?utf-8?B?cGhFSkkzcGJ2ZWhkUTlsSTF0emt2ODJBLzRMOUFScm9HYkFLWlFEWFUyV3hk?=
 =?utf-8?B?bnEzZjQ1dlBrNGpMcS9wc0RreW5GVWE3ZHpMbVlUYTI3VVUvNTROR1hRWndy?=
 =?utf-8?B?dUhlb091RExRMUtIeGFEL2h5aGJ1WDJ0UmZWVUE1T3cxbEV6bkZyR29sUjIr?=
 =?utf-8?B?c1AwS04yVFUxeVZnV2FlYUE3S0p4Qm5XV2NkdjJCK2NJZ09ha2x1eXdkNm91?=
 =?utf-8?B?MkhoU3A4a1o1UjlVOWxnTjduUUdTN21KZ1JkSGkwOWMyUVZkNDJaQzAzbjQ4?=
 =?utf-8?B?bS8zK3pKZGVuTU41SWhDaDFRZ3dkZU94aTZYQ0YwaUt2dC9UMnJGajIyNzdH?=
 =?utf-8?B?UkY1ZzVtdkprenVRNSszN3l3M0tQbHRrRTlKUnU0Y09XeFFJb0FGSEl5TTZv?=
 =?utf-8?B?YU9yQXNmZHJxbEp5dWcvQ2RzNSs1TzVqODlod2ZpVWxhMmthaVZVL1N0cVAr?=
 =?utf-8?B?eFBiTlB2WVh0NHFDWVdteEc0RUpNNUtHZG15M2JLcFVqWW1ha3ZhNlRoNnNR?=
 =?utf-8?B?bzJjaVUycnVybjdxTzNQNWc2OGoxRGMrRGlNU0lRS2Ird2dSK3llZENoNVZL?=
 =?utf-8?B?RHVxT2pKaFJWNTg1MzNKd0p3ZnQ3UTY1QiszRHhnVWRNTHdqTGMzL3JIVkZ2?=
 =?utf-8?B?Q2VZcHVXRW5uVnk3UDIzaHNBWVRIWWxYeVg1azF0YVBjendobmIza2FSUXZp?=
 =?utf-8?B?K3pFUXV3UmpKN0dxMVVwTFBwakhrSDZlN2UzVmR6bGRiS1lEVXF2Z3NSTWFW?=
 =?utf-8?B?d3N3cENoMG9LSm1Lc3lnMmkwVFRUSWF3NTIzbnhOaHRFa044YXIwSW11emZp?=
 =?utf-8?Q?SLDfXd/jjK90Qi92OqE3w4yv1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Z1dMYmRYZHptcmorc1laVTA2dzRUMnlNT3BZYjk2cldyMDFoWG9mQjNJWVgx?=
 =?utf-8?B?cnl1bDRlcHBNM2ZvMmRUVFZXaEhvRGYwYUM0b1Y2WWhqK2dpZFluMVljZnRh?=
 =?utf-8?B?Sk16aS9JaEtEcEFhb3J1OTUwKzZDV29DSnl5WG9GNGtoTDZ1enoxYU9mLzRG?=
 =?utf-8?B?K0NoMkRuUThNTkcrUC9GVE5QSkpFcWo4akwvTnZ2UTRWZHJNcHBXVzBqZXFQ?=
 =?utf-8?B?QVkrUGNFeTVoV1IxdFMxUjVvL0VxVDZlTkphMEwvRVZ3T0swajA4dXhTcUhT?=
 =?utf-8?B?Y2kwSDVDVzI5bzVTMnhKK29UM0pxRi9DSjY2blNBMVdjbjlMMkpmcGUzeENC?=
 =?utf-8?B?dk5na2E3aDNCTVdYQTNXRU5xRjZEWXp0Z2haNDJzY0ZKcW0yU0dJdGNqcnNn?=
 =?utf-8?B?N0QvLzNyelc2cFpHV1pFTklaajhXMzBKWUNjSURsSU50ZWs0VlN1bTBPQVVp?=
 =?utf-8?B?S3ZZc0lnMEJvdmkxZnhpckxDS0s1SmxNdHF1bjlTNWwvSzRVVitybnhlT0FC?=
 =?utf-8?B?TFlRNnVncEJ0NWFsK1BBbHIwamx6blhpdy8xb1FYRTdGbjN4d2JHb3VaWmw3?=
 =?utf-8?B?OHNCbWlTVGR3SHBla2hJYW9Hb3ZGQ0poOTdWQVZWdGM0SnZmQXg5M3BSNU12?=
 =?utf-8?B?Z21wYW9vcHBveG0xM1grV1FqQkNDYjlzYXk1TXNjN053VE15TmtVeEtwY3Rv?=
 =?utf-8?B?QXJGRWhwNzlKU1A1blBDczVJNmNpeUtSRFhza1I0MjNCZVNOK2l4WFJ6SE8r?=
 =?utf-8?B?NXAwRU1EUEJhMzB2LzR0aHdmVVYrVzd0a1F0RDlwNEdZa1JaMFhJbS9nQVFv?=
 =?utf-8?B?aFFLZG9taGFLSDR4cXVkeGw0a0xrNWxDcFV0ZGdMVnNKbmhyU1ZPU28yT3Vv?=
 =?utf-8?B?a0I1ZG5UWjdIVk1VWGtnRDlJTUxUYmRpT1N5WFQzUDduSXVXLzVBdUk1QWZ6?=
 =?utf-8?B?NVo3VUc0MHdjQnJ3U040cFFGS0lFWVM3dGpoYkorR2s3bG1qYThtNFhWeTZy?=
 =?utf-8?B?K0I1alVma3c5NXhsMVJ2UHlaTnFZMDIwTFJQam94T0tkZUNaZmhSeDl2dWJl?=
 =?utf-8?B?YjBjOFhNMU1nME5ub1puSGNES3ZLbkEwVGhkbkJwYlBUUDMrVmlRMy9uVnVa?=
 =?utf-8?B?WENPMGVZWHhlZm1saVUwbExvWUdYQkpwVExlb25yS2hjSXlqUEJ4RU53ZWJw?=
 =?utf-8?B?MjJ4czBrQzExUUZQWU9BL2hMdzlWbGhQalJ4RExiTnBlZWhCWHJvMFpsRE5E?=
 =?utf-8?B?cFhQTGVheDd1L2hhb09zb29sQXpsc2lLbmNOQlRTQzhtL1ZmRzQ4cWs3SlRN?=
 =?utf-8?B?SGpMLzV3NFdvMHNlWGtOMkhwUVdlQlZERXcybVVDMHFmWDRZUGFlUzlNY3VS?=
 =?utf-8?B?blJDbnJKdlE3UE9KMXUvS1ZHdVQrQldmNTAzMDRKYlVMWXVqNStMa1JvbGk1?=
 =?utf-8?B?bGw0d0QrUVhVam5SVGoxc2VocE56ajdESW94RUxKckV0a1lqRjJYbFFhYjVa?=
 =?utf-8?B?S3VhM1JHZHBYQm9yY0N5U0oybHlSR3poa1VFQW43Z1FaZjcyL3c3eGVxaWFs?=
 =?utf-8?Q?2gLBho5Qdgbha+h1AMyGy+nkDUUosNZYeM62PuyntMq1/K?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f8598d-8746-47e2-a9aa-08da7fd40547
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:09:42.6754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzOP6j2gFnAAIAtTEtm4v5M529Xvwelo9QagFlUvrWH3FhyVMMVSwY4RUPoh39ctovIzooiJ2iakGDjJS+/J4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208160080
X-Proofpoint-ORIG-GUID: UhIVuG5d49nvB0xdnxLqibsQA6fEmRbD
X-Proofpoint-GUID: UhIVuG5d49nvB0xdnxLqibsQA6fEmRbD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 2:13 PM, Michael S. Tsirkin wrote:
> On Tue, Aug 16, 2022 at 12:41:21AM -0700, Si-Wei Liu wrote:
>> Hi Michael,
>>
>> I just noticed this patch got pulled to linux-next prematurely without
>> getting consensus on code review, am not sure why. Hope it was just an
>> oversight.
>>
>> Unfortunately this introduced functionality regression to at least two cases
>> so far as I see:
>>
>> 1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently exposed and
>> displayed in "vdpa dev config show" before feature negotiation is done.
>> Noted the corresponding features name shown in vdpa tool is called
>> "negotiated_features" rather than "driver_features". I see in no way the
>> intended change of the patch should break this user level expectation
>> regardless of any spec requirement. Do you agree on this point?
>>
>> 2. There was also another implicit assumption that is broken by this patch.
>> There could be a vdpa tool query of config via
>> vdpa_dev_net_config_fill()->vdpa_get_config_unlocked() that races with the
>> first vdpa_set_features() call from VMM e.g. QEMU. Since the S_FEATURES_OK
>> blocking condition is removed, if the vdpa tool query occurs earlier than
>> the first set_driver_features() call from VMM, the following code will treat
>> the guest as legacy and then trigger an erroneous
>> vdpa_set_features_unlocked(... , 0) call to the vdpa driver:
>>
>>   374         /*
>>   375          * Config accesses aren't supposed to trigger before features
>> are set.
>>   376          * If it does happen we assume a legacy guest.
>>   377          */
>>   378         if (!vdev->features_valid)
>>   379                 vdpa_set_features_unlocked(vdev, 0);
>>   380         ops->get_config(vdev, offset, buf, len);
>>
>> Depending on vendor driver's implementation, L380 may either return invalid
>> config data (or invalid endianness if on BE) or only config fields that are
>> valid in legacy layout. What's more severe is that, vdpa tool query in
>> theory shouldn't affect feature negotiation at all by making confusing calls
>> to the device, but now it is possible with the patch. Fixing this would
>> require more delicate work on the other paths involving the cf_lock
>> reader/write semaphore.
>>
>> Not sure what you plan to do next, post the fixes for both issues and get
>> the community review? Or simply revert the patch in question? Let us know.
>>
>> Thanks,
>> -Siwei
>>
> I'm not sure who you are asking. I didn't realize this is so
> controversial. If you feel it should be reverted I suggest
> you post a revert patch with a detailed motivation and this
> will get the discussion going.
Leave it around then, until the next person shout out aloud. I don't 
mind taking personal time to help, though my impression of the past 
conversation is that this is less productive way of cooperation and 
collaboration.

Please safely ignore me from now on.

-Siwei


> It will also help if you stress whether you describe theoretical
> issues or something observed in practice above
> discussion does not make this clear.
>

