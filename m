Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0728F35E09C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346195AbhDMNvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:51:46 -0400
Received: from mail-co1nam11on2050.outbound.protection.outlook.com ([40.107.220.50]:26976
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346187AbhDMNvp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:51:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laPpahyo7QADbzbhVp87nd16w8ZMgh59/GMIUCUSqfgpBDN4MTgH4wLN+HqM2rR6uJglz8hgyQU7fTNOjp8Z0PdxpPFCZEXjlZGzqI+zfoFePdL9cKZlnihthXYGkxeJ5Q//NNnLYFhHsqOml+CyQnRFH6Holt17DCu6ulEnHX/yAk0C3SdpZxTYB0hfB3Y/98S5xu7bq3zkrscF/+EmJoyC7jpVlbs6gXlNdu7LoXcG/m9bVkoziP1zmUVDBX0FOhtT6RQQ6Oaxd3Lbh/18Dts4lkDNORIAEn5TYj75oZffyTtrXULt+xlW/8T4BipA4ma+A4LXrae+3RfO8FNJ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyY2zMBE7enM7irQrTCHHwCilyDTmYBG+ysAXtVccyA=;
 b=iCEqqjqJWJ6Y9ipaIePY/jPyvKVzdGf1fL/4wDA6eQsh2apknrNRGEoHYXl16BleKpNFvmNcALKPDu2iMfuTk7ZQ9lPe1l2OLbfwQypgpV0YQYpZyEE3nxjrrxd4GySW10GKItfYfI6l8wIkYdM3JY1Cjc80+FwUlv19p8cASF5IwWsInTUMSKASwMp1jfgq548Vr1KWjW5r+xkLkQEMWA4cY7GG4ZfdtGKxkiQ+lsYhmXtk7GBErdyHv2Fmuwv9l+2Pq7oUeKy9CguTqqJqt6cEgE6H7mzigQZXZ+5CwcJfWKuAg5lhmJJnpjOxwAlmviouYYZsqAFkNzoNdNM7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyY2zMBE7enM7irQrTCHHwCilyDTmYBG+ysAXtVccyA=;
 b=VAkwitD/oYUqDVFm6P4RsZn0EqTJKxebFNn5KevB4YEhH7uFYaAAK9Ef3H0OM6fUDvvnrgrgr8Z6EUl6CzXrQjZbStmoxvKUzMVTasyx5f2BB1TreXed+P/SA0YO2g3cbR895zFEY7JlI2oCRtEuOYleTR/K3dLVw7a0aW66BLOAkWSpV90DpLScjUmwLQFtYlk5jok0EaJdwFOXrWGCJCTzmzQZeL6Ivu580BCpD7LWsLipPn1vNtY1SdJgLE/67ENgHWFH/9VJh0i+SXyWLDzcFe7xL177I4cw9QrYoKy5oDN8KHTmB6jCk0kmpx3YeWGK91iYiWsRvsKTHyawog==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2488.namprd12.prod.outlook.com (2603:10b6:3:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 13:51:22 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 13:51:22 +0000
Date:   Tue, 13 Apr 2021 10:51:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Message-ID: <20210413135120.GT7405@nvidia.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <20210412225847.GA1189461@nvidia.com>
 <YHU6VXP6kZABXIYA@unreal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YHU6VXP6kZABXIYA@unreal>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:208:32e::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0147.namprd03.prod.outlook.com (2603:10b6:208:32e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 13:51:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lWJRo-005HcI-RV; Tue, 13 Apr 2021 10:51:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d71bb45d-0b72-412e-b275-08d8fe8338f7
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2488:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB248851BB4DEEB0AAAF4FF834C24F9@DM5PR1201MB2488.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xAIZRUSa6I+21dqdRPmLuAwCr6MRoA+rIpMx2rtJgxipBQOJ/ubrhXSEpIeZT6LUNua0P+LRp2LcNmKqIz21YtDDK7fD7Guro+Ri4Dh/FhKyGmm5CBB8C8NHFbJkMPwJmdBbm3QnIw+dmXTJW3J+m37jge1YS9tbvdJYJbVmoYH1+BDWL1JhtaQ91iZghEb3MQgz2v10G/Niir5h6oZKwoCbuVNTDJ4SECjeHOETnQQc8LbUZq7dEr6LZx8PGmJ75jMWulqRjR/ptHk6+cBcJxECRVaoLT2Kt8XenlC0kfuCgeFnSLDfvqAJ51TetseO7KPwOFqByH4zWWxLVB3gcOQZB3Mka5KYVhArXFcnsVHb+q2ATZdZag581OdUC89YLmn/xo5QNbyog+FhBiRDqPwd8jXkjEO5sh82ZDfsNCx0zaEmF5s38l+J5CIL5JfcX7AKc42/ZRsRXKaVNhSPATSm03Ta3OJWJGr8UEoeq27gCgrvxDcMmCM399tEce2Nlc5Kfrd7BYvu2qtO4UbJQeu426yftiTIRkg5MuqNKd6rND4vn8I4/uQ7cgyId7rlo56h5Tkx2w4O1wZkt4QmRXjrKXVDfFW/IbjIUhFJOw4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(26005)(186003)(66556008)(86362001)(38100700002)(4744005)(4326008)(36756003)(66946007)(33656002)(66476007)(478600001)(2616005)(426003)(9746002)(9786002)(8676002)(2906002)(6916009)(316002)(8936002)(1076003)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bWNpQUhpVVkrYk5iWnl3diszTnY0YkJ3MWN5SUhHTW1vSHpwL1JxMlV2L3NC?=
 =?utf-8?B?anVjMW5HMS9wc3VxaExWdXlSK1RuUnJkelRjR2l6RlM1ZjdPbXFYU0ZsNXNa?=
 =?utf-8?B?dDVKSk92cHpLQ3lVb2lPMUlCVGI1K0ZUZXR1Vm9qR2xPbSs2Uzg0Q1AzOXJD?=
 =?utf-8?B?UzdSUWpIbGU5UmxmbnZkdmlaMGV2RmxRak9ob1hmWGlpTlFaV2pzdXcwcTUv?=
 =?utf-8?B?ZFlpTEk0ZlpTYjVKTmFUWDRHb2JxN29wWUlZR24vaUJ2TlErYlNscGJaOUQr?=
 =?utf-8?B?TmhVK042QUdpSzZnR1BNYUg0RTE4R1ZZb00vT2g2cGlFU0h6QVJPeFpPaU9W?=
 =?utf-8?B?SkpFaU9TMXFoTHBnMGx2T29FZENXQ0dSK21XRE5idnBoV1IxMTlpUU5TTXlm?=
 =?utf-8?B?SGtvSGtiRER2azBXRXBEUDY5NTY0bU9ObTd3TTJIUldZOTQ0TmN2M2hSQzI2?=
 =?utf-8?B?UitKT09ENG5wa1JnY0tON0I5R2Jyem9ZdDNSd1FENFo5U05kYkJlbEd2WHpi?=
 =?utf-8?B?RUJXK0tidGlPV3pRK1hjVFlGaE50cXA1T1ZNYlFjTFhMNWh5T1NXbGViVjhT?=
 =?utf-8?B?VmlNdnoweGovaFFWcko2NVN4U0pxdElTVHQxbzd3eXFTK2pueDVHVGtud3du?=
 =?utf-8?B?RnlkSFdyTGI2blpFc25JeHMraUQ0OW0ydHphamw4cmZFSm14cE5ab0QzU1J5?=
 =?utf-8?B?STdsYStGMXJSV0c1M2lIMmR1YUpXcDk3bGpQNTBBQWhHRmt4UXExR3JZc2RQ?=
 =?utf-8?B?cm40eFd6Nk5kYzVkd1A4aHZBeGV1US9FWFNEMitRcHVMK3VkMXJIYlByUjd3?=
 =?utf-8?B?UU42dzJyaXRha3R2blY3NjlHakNrNVNqcGZiQ3VicEhuREs0M0thdml1OGFD?=
 =?utf-8?B?a2FwSytlVG95cmpSdTl2eEx0NVc1MmlFV3JZbHJFeGF0V1FrTnc3M2FGZ3pO?=
 =?utf-8?B?bkhwNjdEb3dWVm5GMEJMNEFMSlJuTUYraVNNRnVYNjN6bXA2bFlBMU96Q1Fm?=
 =?utf-8?B?MW1JWFVOWFVVckxPbTQxcEh6Q1QwV1pVUFd0NnQ5M1Z0bEVrYkdkekYzN0p1?=
 =?utf-8?B?cUFVUzZ2NXRvZEI5dXg4enVrWW1EeCtvOFNRT2tNSEtrSkU1NWlEbE5JRU5m?=
 =?utf-8?B?TEMyTmQ5NCtmSWp5ajUzVXJTSFYwaE44cGgvSlJBSWwxZEMrRVFkM2ZGOFRB?=
 =?utf-8?B?OU5LVmxQY0R6NXc3d1lYdGZLbFkyWXBHSnJpTWxHSk9aUzFxWnJ0UmdIYXEz?=
 =?utf-8?B?Q3QyTWlXN0cyc0FnUWh2dlhCZkZpcmFVaXBocHNIOGhSd2Y3WW1IVEZMd3dk?=
 =?utf-8?B?SUtaeWRlTVQxMCtCTlpqelZSVzFId2Z0REgrS0JGVWxUeFdITkY2ZjZKVFhu?=
 =?utf-8?B?MjRUM0ZvaTl5NFJFY0VCdEZxZWM4dHIvV2hIS3JQSjBNM0hUZCtPMzhJbzZo?=
 =?utf-8?B?U0dlM1JpYUkvNE5rd1ZuT3A4dXpaWU5rVm83bWV2RWxIcDYraWV6ZjZqMS8r?=
 =?utf-8?B?MFg3OHV5c29yRWYyZ253NE1jZ0ptM2h3TmxHQXRXdW9xc1Q5NmNSTzhLTFVq?=
 =?utf-8?B?NGlhNzZFa2ozZjNWQW1LdmE3VmpiYlFLNVZXMGQ0czNaNEdkRDFRMHBGRTRv?=
 =?utf-8?B?ak52dXlZS3FFb3NFSytORWFXVlVHRTFsVXNacmxvbjh6eVFpcGVUWlEzVWR3?=
 =?utf-8?B?ZURVV09uaDA0UUhQcUxDLzhhYzVzcWdYV2oxVHMrbUR0WGtKRUdqdlQ3dUVm?=
 =?utf-8?B?Z2c4QkhuaUhjcUlHKzBYTmVRU2ZUMHNCR3pvNTA3NGJBbjIxbVlZS0N3Ky9m?=
 =?utf-8?B?YWlDMmtzTFJzR28zOE5iZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71bb45d-0b72-412e-b275-08d8fe8338f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 13:51:22.4172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNtL6jYUjKGeO7xh4ACLO8fdcaKtiwqgjphsnqdwqZb43VmarjMeyIcJ89ZA9N7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2488
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 09:29:41AM +0300, Leon Romanovsky wrote:
> On Mon, Apr 12, 2021 at 07:58:47PM -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 31, 2021 at 08:43:12PM +0200, Håkon Bugge wrote:
> > > ib_modify_qp() is an expensive operation on some HCAs running
> > > virtualized. This series removes two ib_modify_qp() calls from RDS.
> > > 
> > > I am sending this as a v3, even though it is the first sent to
> > > net. This because the IB Core commit has reach v3.
> > > 
> > > Håkon Bugge (2):
> > >   IB/cma: Introduce rdma_set_min_rnr_timer()
> > >   rds: ib: Remove two ib_modify_qp() calls
> > 
> > Applied to rdma for-next, thanks
> 
> Jason,
> 
> It should be 
> +	WARN_ON(id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT);
> 
> and not
> +	if (WARN_ON(id->qp_type != IB_QPT_RC && id->qp_type != IB_QPT_XRC_TGT))
> +		return -EINVAL;

Unless we can completely remove the return code the if statement is a
reasonable way to use the WARN_ON here

Jason
