Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440EF6D27F4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjCaSjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjCaSjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:39:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7F649E9;
        Fri, 31 Mar 2023 11:39:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VHOI3e004934;
        Fri, 31 Mar 2023 18:38:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=J+QtOdUlrom+wGdUAduYH8kRoUPdULqO75UY40U0Q9E=;
 b=cBcJNZaBA2ARj/LobuleKOzK7SbAkrjMb0HhTckuf9ypzULHf/ml7fR7lgWCu98xDBjU
 ox+gcpEfdZ/J5JgRiaBosFYy8WB/9AdWirO9FBTMgnOgUS9Vm4lDlcqcAur3BRmn9q89
 5M/YGeYBDAnJrV9+xoaXetcZUCQ+h3qi8nKsy/coJjIxXk7Kj5QpUXiBZnsn/ZM9M6x+
 ZwiDohXAWEFNime8dR4xZc0xwhc94iqljcJ2YFqNhQd85dxZ5FGP1tuJJexAMwT74V6i
 k1YdiP0qsoxT0N7CWwifUFan+2EKJz5DL7UDhgqXgJT/STUPg1SfyD+syUz8so74pFVE Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq53eqsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 18:38:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32VHukpQ018577;
        Fri, 31 Mar 2023 18:38:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdj26xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 18:38:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWf2u+EtGnsaTfXYgh7BYmCPyqfYh7pLxd5mnAULS/YpIXAOvbBNSPTab54dfrYcycwThOK/6C2/QVde6KRoLHUliPX+pbT5LfGjQtvjXEDsltfNpEwei4+IbDTNeeTgOY8qoZm1O6+lr7aGSpplmV+QkSQY5hEzbRLd7ww6l/GVT04RCt3i4OlOMGNInXGHRykQoJItidvA6UXwYnLrk9Ybzjuxlri+TBYqHRo6CyDtTZKcHcqV6yxJM5PdonFXoNrrbyril2akv1qna4YWS7hjZ8tj1VLnDKxaq7UYRhYPJIGgowzvJ3liJwBGFVyLEAtmQlySrubyFToKkcp8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+QtOdUlrom+wGdUAduYH8kRoUPdULqO75UY40U0Q9E=;
 b=B3nJqHVDWQKR6AV8YT9HYrDNtqug+aIbJI+yPAPv63XCe3hy1iVH8V/h+eaWGL7vsQ6dzI6Py24pe5YoH5Yn/ez4WZ5QvjVCbVinNVm6kx9t11oHKVSGy4wjH+23jIiWaQUZ1Soc2TkCvah7IXOXhqH9tpaP9I+DM06t35FDtmQUEXAJu+q0KRR5rXL5HBWbr1CKit/SSyLa9GDkf//oU0X/6rrI2XrQx0aTXoJNcyoejPq01onbSERageYkZjtXvpkON56AMhk2ZMnDZMKE3Fqoz/rbts9CQBoTViVizvLRhTlESod6PJKrNELPFFg35s8nVM+y7yFKT+R2vl/uoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+QtOdUlrom+wGdUAduYH8kRoUPdULqO75UY40U0Q9E=;
 b=EGPsY5O6nB/aJhGsys3QP+5dbPpjwpxSpwqlAtMEZmzcQpWS5Nvs0gzjSdcejbLjAnbolXcnqs5Bc4CBHgtLSJ8FTDTW0FGDfH9vastBSZC5kjVuJyB+VEUYUvP/p+zwU70i+llM+OG3y3Q2n/7JRGhYTqohUlCbahLBChhzukQ=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by MW4PR10MB6678.namprd10.prod.outlook.com (2603:10b6:303:22c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 18:38:43 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 18:38:43 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] netlink: Add multicast group level permissions
Thread-Topic: [PATCH v3 6/7] netlink: Add multicast group level permissions
Thread-Index: AQHZYmvoV1sxO7snm0CxH2QmxW6asK8UckyAgACtcACAAAbWAIAABocAgAAHB4CAAAcQAA==
Date:   Fri, 31 Mar 2023 18:38:43 +0000
Message-ID: <60F08DFD-02AF-45CD-9B37-FFB04C444BD4@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
 <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
 <20230330233941.70c98715@kernel.org>
 <830EC978-8B94-42D6-B70F-782724CEC82D@oracle.com>
 <20230331102454.1251a97f@kernel.org>
 <F49500D6-203F-428C-920A-EA43468A4448@oracle.com>
 <20230331111325.5703499b@kernel.org>
In-Reply-To: <20230331111325.5703499b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|MW4PR10MB6678:EE_
x-ms-office365-filtering-correlation-id: 93643c2f-7e7a-441d-e40a-08db321727ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ql9j21Xqktd1WLpi6KGJ5X6Tiv5S5f05BxeTU38ECodHR7Fit44wpKKr2T1Y8NxizQmcJo/NC/7X0hHudYMf40m7Au7KKh3ARZnI4AdWxQBrARNeu+WCx0QDVZZRrfz615zyDSmr3bxuiu7r/PC9c+RNEleB1zl24EU3Rtr5QgaRlFa9wktZZFGEEi9d7H5nQ1Qu2mz+GYbYOeiiMG0ijM3oAWUx2dclzQprm5ebGoRw1ghxUXWZt9scnFFeIp6U/Sf3m4J6Ru2iJdI1oKbmkyl8xtTWox1G7ZD0zURMk3uhJfZd8lC0MFqdDtjuCzZFQQdNL//BXefYcU72q1m2mu3ZdABGRfBXgPSqfG2s9IXxzwaK6Xd77JVviMF1xTcW+XyqR0cJr5NCqfkHlMB1YZVznW81qU7qDGOyT+O9DjsMF3pgiETnsQukzInNEQxWcBa7Wn144MaWgUH2ty9N56HkzBeei9cbL3nn2WCHEnLT67tPAtBZZAY3qxj7KVv394NeLEh9Xqo440HQaIQYzGEPFRNalVnNkPV1hpcYEfZBYnpAA5ZjsxOxXN2LKJUV8MuCKN+aF5jPQHKYuyAiYZMboKks9UW0jWbTrHdnRf5ES4VY6SmLNBJ39iSS0Gnfgobof/sGB1yk4nAM7NoHhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(39860400002)(346002)(396003)(451199021)(66946007)(186003)(76116006)(66476007)(66446008)(91956017)(66556008)(64756008)(4326008)(478600001)(8676002)(6506007)(54906003)(316002)(33656002)(53546011)(6512007)(86362001)(6916009)(8936002)(38100700002)(71200400001)(36756003)(7416002)(5660300002)(2906002)(83380400001)(6486002)(38070700005)(41300700001)(122000001)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjE2Z0lETjljZll5dURpVEQ1bFFhVmx2MmFic1pEelBOcTFmS2p2RkRZbFA5?=
 =?utf-8?B?TWU2Vm80SEs5MlRTNnBjWk03ajJGL1FWQkJnbHR0L25BQnlMNFp2NStWRXJs?=
 =?utf-8?B?aFVQOSs5K2Zvak5teEYzeWY2LzBTa1BCaWhDUlU2RU5RMTY0dVJsUkNTOUlw?=
 =?utf-8?B?V2NQeTRzZGpYTHVzOENMYlFXMVZyeEZsZ2NEUnZqVkJEd3NPOVE0cXJXczlM?=
 =?utf-8?B?RGhLSXlLSWY4dDZ4Y3UvU3hUL3pUdzRKWENWbENMRmVremp2VVRERTZIMFBC?=
 =?utf-8?B?RFBVNDJKaUUrTW9mZVBGUG9pUkxJYzZnbElqVk0vTHAweXRiODJoaDJnTGVC?=
 =?utf-8?B?enI0S1VFb20rR2JiZGNldlh4V1NuamVXSDdNdVJTWnNPeHhMNk8rQUdlZnZF?=
 =?utf-8?B?S2xsU1VnZ0pLaEhLNmhUNWZqQVB0MTZWRDlxUTN1ait0MXRLakxQL0o3S2NW?=
 =?utf-8?B?WWFrZ1E4eGo2eWRnY28zbHJnMWhKbDhvRWNmcTJQMVl5QU1ESGFHbTdHRDlq?=
 =?utf-8?B?ZHk0dVlqMndtcVBrdVRYSUR6dFQxdXRGNkx6c2RkNE93aWNGVncyc1FEQWU2?=
 =?utf-8?B?WHBHNFVLY1hFaUUxT0tQWi9MOFhzRWF3alBRSk96cnp0YzhwN2ZrUWtSVzdu?=
 =?utf-8?B?YTRIZUZZNVlxMUFCZHltcXlpWVNMTVMzdkkwUmphRDFsaHBtSG9ld2RjR0tD?=
 =?utf-8?B?Smd2Rm1WZ2R2SXBXR1JicHRuVmd0ZG41dVBHM2tXdXNwRnBkRFlSV2w4R3dI?=
 =?utf-8?B?YVZQNGpuNjBXUUxXRTdQWngrSFlVQk5qejNMNjhOUDJIUFk4YkNjNE13RmNz?=
 =?utf-8?B?aW43MC9ETGdzY1VFRXJhZzYveW45RXdKSUR1bGp3R2dXZW1rSmNnZzdwMmNq?=
 =?utf-8?B?YVpQRndvSDgrU1l5ZkVDWHFiN2pMRjQwSERaaS9hem5zR0RWZGQ2VFdjOW9v?=
 =?utf-8?B?WGduZnBhZmtsQ0Y3ZkU0U2lKcm5NM3hjTk5kb2pIdmZyQk1hQkpPRlFmRDZs?=
 =?utf-8?B?TlMwWHBVUkpSdWs2aEZDN040a2g2SWwrQVErcm5lUEUxMVc0SVFXWUJERW1Y?=
 =?utf-8?B?eVB1THllVFlqRFZVYnhGZWNRQVJoZTNmK0FsYlhSSHdIaHpNSGJMeDUrd2hm?=
 =?utf-8?B?V1BRVkE0NWRTM285cXNCTUt2OUhkYWV6aTA4Wk9pa1ZyVGVBQlgrRTVKNzI2?=
 =?utf-8?B?L09WekFMR1RXM05uZWlCaDJBWmF4b05OdGxEenUzNHh2c3BKNnAyR0pwRUZI?=
 =?utf-8?B?Ry8xMk0vYTdzZ3dJdVRVMDdTVVlWZXB1M252bjdpbExJc0F6emdWZklJa29j?=
 =?utf-8?B?cm40ZVFKNWJFNVpUS1NzUWpHbS9rVGNVenA0cWVtdlJFb1pLTGwyNG0rb1kv?=
 =?utf-8?B?YlZQZi9mWTZORnhDTkRNalNqTU14blRSMTNEa2xDSHcwMXB6cmFVNnVzWVhG?=
 =?utf-8?B?MWRsUFVMUWsxTnNMK0IzSUxvSk1zcWswNzhLUml1ODh5QkZpRU14SmdvRitB?=
 =?utf-8?B?WnhBaEgwek9pZXhlTkJCM2NhR3g3RlZJWDUzZ0JGc25ReWtiQlVhQnc4WXZQ?=
 =?utf-8?B?bnZSVEJMdmV2cGcySjVLRmszVlZOdUhkVEFyYzFrZ1dmQWpOU2Q5eURIWWta?=
 =?utf-8?B?Z0VXTTJ5QTJFUW0vN3Y2MHdJQ216K3B0bnZlaHZ6V2lIb2JBMldRVENmMzlu?=
 =?utf-8?B?bGJGOVd6L0xJcUc4V3BvdWNsR0JEZy9iUkZpMS94RXZDTi9rTUkvZ3luaUpr?=
 =?utf-8?B?c0tmUXZpaXl5VlowL0FBby9FRnRPemtGVy94Z1dDZzdWZFMyUHZpdzlpRnBT?=
 =?utf-8?B?bGJLY3RrTUduYVBQeXhQSW5OTVI1TC9rN21HTUc1YklGZU5hZFRQeklWQWEv?=
 =?utf-8?B?c01oMjZZd3F6Qll1WVhQb0RaT244Sjk2YmRsendLZnJwS0svTjZ2RG1jbzhW?=
 =?utf-8?B?cDBuMVdhY3RkU1dIUmFjWTN2Rnl2MHR1NG9RRUNmWHl6TnBlS0RxZ1c0NjVY?=
 =?utf-8?B?VE9rd2daSDg4TFpsaWowSHlNZ1IvZ0ZDQ0JySFUrQ2lad3VjbTlLVHFtNXFn?=
 =?utf-8?B?TjJKSGx6Ynd2YTBGS2Q5TFVwT3pKSU1UVko2cStPZmNuTXdhNEdRSmRKSVJT?=
 =?utf-8?B?dnFvSDlwVG5MbStmdlV6SU5RQVQ4RUpGQ0hkZ3FHbENMMGdQekR6NnViaGJG?=
 =?utf-8?Q?x0YERthR6PSKWfqb7t8NV7e6Kes9tm0lbhUX0eyVZfmm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63B94E257AA127489F0C1260E2CF8EFA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SFBWeDN6YVloSjhGWHJQdURJU2kxamRSVE1oaVY0ckhjOUdJZCtHR1NmVEs5?=
 =?utf-8?B?V0gyMkkvNzcwNWZDR1VSL2F2YUVRU3dyVk13UEJ3RDBXNGFjVGdsZGF6RDNz?=
 =?utf-8?B?eWc3eTEzYzZmeU5xSnUwY3JnWGNSZVFiK1NDWmtuaUw5TXByeTh1MzV2MFNu?=
 =?utf-8?B?RC9sYlRUOTgrSjZKeFFiMDVycGp6VU9IUnBmQXdReGJhUjRlcXVVU3Y5MG43?=
 =?utf-8?B?czlTZjZuN0JDMUU5VGF5VHpXSjJCSTV3b1RjZGRjWWFMbFlScS9namwrZnQ3?=
 =?utf-8?B?aUdoQk0xM0ZCTytPZXNpQXRLb1VoS0dsQkliVTh3Yi9pdGZpK2lMNHRXQyt2?=
 =?utf-8?B?L2NtNktrTHU5enp5cCtJTVFDZEd4K2lhZFYvbVVMMjg0WEJaYkJJN1d1cksy?=
 =?utf-8?B?T3psRjRRUlc1S1owQm1LWU8xdVUzT2p0eTBDemh2U1Jtem1tY1pSelFja2M2?=
 =?utf-8?B?emZsbE9WRWtBUkM3SGk2VHZCZVozS3BlcDNaUzlVUzlzNnFRUWlOeHNBWkc2?=
 =?utf-8?B?YUZtUkhRaldTTml3WmxEMnFjR0pyY1Juam5wTHJRN0hLYWRyRjVaNFpOYjRB?=
 =?utf-8?B?enBEWS96QnBWaVZYdUN1enpoM3pUN2pOb1Y3SVpCbnhzODVHajZEbHFWK3Zj?=
 =?utf-8?B?dkxwUFVhL0NjRzV4cFU4amw0UWpjOUV1YnJSazR2Yll1QXJKTE5jSkxNZlU1?=
 =?utf-8?B?K2xNdXkwRnNBNlVXd0hHODd3c2tyOVlRYlN5cEt4RHFPd00zVW5lUVFaQzdV?=
 =?utf-8?B?Q0ZVV0hCOXhweXQrSDhPaWdRYnR2eCtnSzRRQ1E5a2xZa2prcXFUc2laRm1s?=
 =?utf-8?B?c3J1K0cxYmo4MkVSTm0vTTZWeGx0V0k5SWF0Y3NDV015TzU4eEcvTEsvWEVN?=
 =?utf-8?B?OVR6cHV2TmVvZ3RteEg3ekhJWCs2MVdURFp0V2ZONnkySXp1QmxlQlYrdXRG?=
 =?utf-8?B?aHhUUGplekNtSTZ3bTBsTy9SdnVHZ1pMWGlJOVgzMXZxc1VSckhqU0NXalR0?=
 =?utf-8?B?ZkJ0VEJnK1BFUW1USGI5bk5IVEtDbXRoRlZTNDFsbEdqRktweXo1TFFaOVNa?=
 =?utf-8?B?VUt1dHBQR0dSQW5yekxQMVNEeTdCYzZhY0RHYUpDNnRVeld6ZXpEejdDTWEz?=
 =?utf-8?B?KzBQMGplKzJwQWFpWVJnTmpoVXM4TWgvaWZjTXNnRURNcCtNb3NjM3B0Tk4r?=
 =?utf-8?B?R2RFWXYvV0VMN09kZDJWSVVreFRpNHo2RkNiQXM4VmQ4NWRXcGNTN2d2WTJT?=
 =?utf-8?B?bkQ2TWxSeUhNQkdVSndTZXhlMitoUlozQlFXWGZFNGJxakNBVXFWckV0dGFr?=
 =?utf-8?B?WEV4WWgrSWoyUXNWcVlDem9jUms4UzQ5RnBsTmYzc2gwQjNzdmNWZzRibDB2?=
 =?utf-8?B?b1VZQzM3ekJRejJ1U2ZnWnEwdG5XTDU4bCtucEN5WUtvcFpRNTFGSG42N1hX?=
 =?utf-8?B?TG51ZGZscGRObDlwSlN2VHBRS2RMVmIxVmZWQ1NnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93643c2f-7e7a-441d-e40a-08db321727ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 18:38:43.4232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KmTb9odeS/JtWvwtocdwNDwrpge7eeauvdp0Shuzbyr80YqWZDD2yxea4znpxK7FJqxLyVVXKR8El0yxT9DDuZ2mq/rpBjdRu0KX43nadOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6678
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303310150
X-Proofpoint-GUID: Z2grr_LTq2WZiWofMDxWyXM6NbtGbW20
X-Proofpoint-ORIG-GUID: Z2grr_LTq2WZiWofMDxWyXM6NbtGbW20
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDMxLCAyMDIzLCBhdCAxMToxMyBBTSwgSmFrdWIgS2ljaW5za2kgPGt1YmFA
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIDMxIE1hciAyMDIzIDE3OjQ4OjE4ICsw
MDAwIEFuamFsaSBLdWxrYXJuaSB3cm90ZToNCj4+PiBPbiBNYXIgMzEsIDIwMjMsIGF0IDEwOjI0
IEFNLCBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPiB3cm90ZToNCj4+PiBPbiBGcmks
IDMxIE1hciAyMDIzIDE3OjAwOjI3ICswMDAwIEFuamFsaSBLdWxrYXJuaSB3cm90ZTogIA0KPj4+
PiBBcmUgeW91IHN1Z2dlc3RpbmcgYWRkaW5nIHNvbWV0aGluZyBsaWtlIGEgbmV3IHN0cnVjdCBw
cm90b19vcHMgZm9yDQo+Pj4+IHRoZSBjb25uZWN0b3IgZmFtaWx5PyBJIGhhdmUgbm90IGxvb2tl
ZCBpbnRvIHRoYXQsIHRob3VnaCB0aGF0IHdvdWxkDQo+Pj4+IHNlZW0gbGlrZSBhIGxvdCBvZiB3
b3JrLCBhbmQgYWxzbyBJIGhhdmUgbm90IHNlZW4gYW55IGluZnJhIHN0cnVjdHVyZQ0KPj4+PiB0
byBjYWxsIGludG8gcHJvdG9jb2wgc3BlY2lmaWMgYmluZCBmcm9tIG5ldGxpbmsgYmluZD8gIA0K
Pj4+IA0KPj4+IFdoZXJlIHlvdSdyZSBhZGRpbmcgYSByZWxlYXNlIGNhbGxiYWNrIGluIHBhdGNo
IDIgLSB0aGVyZSdzIGEgYmluZA0KPj4+IGNhbGxiYWNrIGFscmVhZHkgdGhyZWUgbGluZXMgYWJv
dmUuIFdoYXQgYW0gSSBtaXNzaW5nPyAgDQo+PiBBaCB5ZXMsIHRoYXQgb25lIGlzIGFjdHVhbGx5
IG1lYW50IHRvIGJlIHVzZWQgZm9yIGFkZGluZyhiaW5kKSBhbmQNCj4+IGRlbGV0aW5nKHVuYmlu
ZCkgbXVsdGljYXN0IGdyb3VwIG1lbWJlcnNoaXBzLiBTbyBpdCBpcyBhbHNvIGNhbGxlZA0KPj4g
ZnJvbSBzZXRzb2Nrb3B0KCkgLSBzbyBJIHRoaW5rIGp1c3QgY2hlY2tpbmcgZm9yIHJvb3QgYWNj
ZXNzDQo+PiBwZXJtaXNzaW9uIGNoYW5nZXMgdGhlIHNlbWFudGljcyBvZiB3aGF0IGl0IGlzIG1l
YW50IHRvIGJlIHVzZWQgZm9yPw0KPj4gQmVzaWRlcyB3ZSB3b3VsZCBuZWVkIHRvIGNoYW5nZSBz
b21lIG9mIHRoYXQgb3JkZXJpbmcgdGhlcmUgKGNoZWNrDQo+PiBmb3IgcGVybWlzc2lvbnMgJiBu
ZXRsaW5rX2JpbmQgY2FsbCkgYW5kIGNoYW5naW5nIGl0IGZvciBhbGwgdXNlcnMgb2YNCj4+IG5l
dGxpbmsgbWlnaHQgbm90IGJlIGEgZ29vZCBpZGVh4oCmPw0KPiANCj4gQUZBSUNUIGdlbmV0bGlu
ayB1c2VzIHRoYXQgY2FsbGJhY2sgaW4gdGhlIHdheSBJJ20gc3VnZ2VzdGluZyBhbHJlYWR5DQo+
IChzZWUgZ2VubF9iaW5kKCkpIHNvIGlmIHlvdSBjYW4gc3BvdCBhIGJ1ZyBvciBhIHByb2JsZW0g
LSB3ZSBuZWVkIHRvDQo+IGZpeCBpdCA6Uw0KT2ssIEkgd2lsbCB0YWtlIGEgbG9vayBhbmQgbWFr
ZSB0aGUgY2hhbmdlLg0KQW5qYWxpDQoNCg==
