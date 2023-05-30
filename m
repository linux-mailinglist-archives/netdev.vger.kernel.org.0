Return-Path: <netdev+bounces-6481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF42716849
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B50471C20C67
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3383D27214;
	Tue, 30 May 2023 15:58:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC2017AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:58:45 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1877124;
	Tue, 30 May 2023 08:58:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UE54Fx020898;
	Tue, 30 May 2023 15:58:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=2m/MgCMsdYczSES5hpw4cp3XdeJ2x243P8lrGJbG1lU=;
 b=eo8792vMN4dwREzrRswW2uI+77mgmT8J1NGIB80U7ssddzyCTUT2CmB+IESHwTeunxfL
 qhMWdAyhVBhgnXu0pFYM6kSNajNbstzCzxfddoB/2DPXJJZy/m/dQJvnbjT85N99dmjh
 r800a7YpPLEgKYQO/OhSvUAbQKIBcbvvc2jSAxqZzL7Roqz3V/gog2nuGC2ne8UwvBQy
 /LN8IVhtEe02EFSCrk5cyUHUPpVF5lhigvNtc3vnzLB69GCSPR4HO81s58xxnioAG1ar
 XV0KjsXLf3z+r/ivLKe3N9/sFRVe50Ky/EAugt29oX4ul73QYMO2c8fbHiEuYzLLE2SH Ng== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb936sh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 15:58:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UEqdX9003734;
	Tue, 30 May 2023 15:58:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ybp26d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 15:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2vkEXjHI+zB07MKhhIhia6T2Se8RgpS1F8JbnUnnjsBhDVZfF4EDJ0qDAfRT+uFIg5RkDQJP8KrwrrmySHVn00Ttsn1o/3IDVGdNxJVnNJ6xBz1+eV+2AE1YnFjyQFnBx/EIajHGlkjDlnnFuHidKE0wzuhiDmJC3rYhJwB2eMO1xMFLQIY1Ki13S4YWuMRPJXu5HQf2Lwl2OxDy7WYQyfdA0cVfsL2rCWjbrbaoUfKLKSYjijd1EOpmMWq6awJqn+RtrWaLqdef0lhYTEiDAqZNwykQtTIed9RUF0PrKmYZUEHBlqQH8J5gq1uoinXlN8hdoi1K0Uvt+LltNSa8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2m/MgCMsdYczSES5hpw4cp3XdeJ2x243P8lrGJbG1lU=;
 b=lpdt8oZbv4cTSp8uksjh9+W+cavLkxkk0uvQuOPekaFn3+9+WDWANkdrh2jaE4IByAAHh6Fg0klzUYmwL25x0MgfyUnzQPfIkY2NWMC+1tTJ0BUrz2Vhj79536S/BON30QUbq/5ZA4ESnvVqYd5Uy7wK4XrKqLgltJpKHL2MHd2DHWVVeQ5Cck0bNce8VlDiyGZG+7Eg3XSqIdt7ppUGY8un2wNadP4f2jSfne/5U6E6cQGW1226pcpjV2emIKNWiYMaE0lhdQJ7eZ8J2VoXyd+XZ6ryQAcOgM0Sx5iNiI8kOs2vR2HEkZOnbVLjWTsU6M+piIiVp2fOPKjqxY2p/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2m/MgCMsdYczSES5hpw4cp3XdeJ2x243P8lrGJbG1lU=;
 b=x155xRqWf/v/mmny5M4GZPrpVwcLRUziM1bqu36+IeTVhbl3wq4iShyqHjRysxQRY3ErJvBweUaGCz6B0H6k11JrXoSL3xTfRuKXmZ36+uiv+ct1zR9iSccUpfq86FYreLwuJwT2Fpz0hcnMitweLIW9GbACmXxTsZf5RQwXDis=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6222.namprd10.prod.outlook.com (2603:10b6:8:c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 15:58:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 15:58:14 +0000
Message-ID: <85836a9b-b30a-bdb6-d058-1f7c17d8e48e@oracle.com>
Date: Tue, 30 May 2023 10:58:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:5:bc::44) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6222:EE_
X-MS-Office365-Filtering-Correlation-Id: bde04e73-2a6a-4a3c-755a-08db6126acf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	t88s1iHrgDucmDHq85NTPukG3bKf5chlUIfsYcS09ong4XTsS5T/PTqFII4g05H6MIgU5NTmXeL1FRtS081ESRH/Ur2rhijx0MoGDttmGd0J7Ig3ORBeG5Ejs8G7PBN6JP/3xQpyIkDz0BSlBR1xo+kY1002NBm90Gn9QpBo8Yi+6wzkNgkkCo20uuZQYaT9/Kti2ZLPEFTsnu2lO1LRr+gj8VFkxMPoh2oeJZfMEw03rxLdWjgetX5jCA1dgHRZ2W+6Boe09Ha826MP10EgcgE+YVdE8DgDIEx0/xQESjeNZvLrYqGHk68XZbTJuJ0FDKU9OeCr/LFAhQox2XlDWmZUmDGrSRsMBqeH846FZK92ve5h0blq/X1R1Z4msfMD30FKPO1GhlMTsuI4ks6AxpQv29ZldpcDT70Ma7kYuIH76bmxukHG91qvJ6HqG/UQ3B1NjVUXtr+j/Etr9jQsRosFgq+IPE4zTqRnuMCoJjY9DCdIKs+8Rb+EkmJPu5w5SBiq4Gdw0s4/HQQFMmZpfWZG5omg2KQq/mR1kyfd+fxQa9Oi5Rxd9WNDXK9Ksx/7xPfffSblISQ2ioNI/mV+YTcw11nDhSmafJBvm1+GeHnCkVzAXMC5TCM6y45U746oiEleGMSCy7oxrIRWXcqLcQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(31686004)(478600001)(38100700002)(86362001)(66946007)(66556008)(66476007)(83380400001)(2616005)(110136005)(31696002)(4326008)(4744005)(2906002)(6506007)(53546011)(6486002)(186003)(26005)(6512007)(316002)(36756003)(41300700001)(7416002)(5660300002)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SThhRlg4V1hteGdPSEdpSEdST1dRMXFLck1OK1NMSjN0b2tJemhUWkJ6ekFv?=
 =?utf-8?B?U0tVNm5IVE0wU2dPOWltSUQ5VUtvY3RqN0NkcXQwWkJGM3lQUS8waGRZY0ZL?=
 =?utf-8?B?MDVxM0o2elYyQ1ppNThiVW03MllhRW9wc0VZd0NQMmF6VE5ZSElCaWszN3Fo?=
 =?utf-8?B?WkxTdmZHaHc5cHZqTTU1eWpDbmw5S3FtWlJzL2QyQzBPYjdXR0NtZkhDKzNC?=
 =?utf-8?B?d2RxMlQyTkJjYVVRWk1WRmFkWFlTRU9UeHIyc0o5UlRXWnVTcW42Ti93d3hP?=
 =?utf-8?B?WXEvOWZUSVlCbnZlK0tEWGJyTUthUVpqb1BVSFVGQWJwbUdkZ3pWKzRyL3Fs?=
 =?utf-8?B?eWZ3NlRJM3VjbmpINWlCbDJVK2Z3YWJubVBpNzZYWmVDemtDajBRWStsaWl5?=
 =?utf-8?B?RVlZWE9yMVgwLytnMDVwd1JkSXJYeVRPdEZ0WU1zSzhTbjdvQVJTMldHbm1y?=
 =?utf-8?B?YWptc3BkTGdTc1hXOUowVTlVZHhjMkNNRlUzYUcvRXpXUlNhWDZVZjQ1cXU0?=
 =?utf-8?B?R21qdkdOWUNmSE16M3ViQk8rTTlCbGFsU2ZNZVhHR2tKZ3U1UkxIeFlHN3Iy?=
 =?utf-8?B?QjE3am5oUWVMblBEOHdIekNpcTA2NkgwL0ltK2NTNGZtQVlOSHZFVy8ySVJ2?=
 =?utf-8?B?NWpPNThFUVE5cm5QVnRYdTZ5UEMyRXlvSEQ1d3VDN2k0S3IzTytQWTNNVlhV?=
 =?utf-8?B?Rm9RaUQvZm9YYVMxc29yRWdaOXJWOVVTL05rRVAvUGYycVBKWWFRSWF2MGRB?=
 =?utf-8?B?KzV0VmJRamZuWlZ6ck92aXhpMXl0ZnYzdzgzSzZhNVlFZ1BtSnI1ZFJBYldI?=
 =?utf-8?B?U2tFOCtvZGVRNFNLMWl2VjUxclJ6eFAvV3NtT25tTzZUWE1KZXVUcU9USGsv?=
 =?utf-8?B?UlJwUitma3ZMenpabSt2OGVXZElWVTVlMEVYZGJtU2h2K0tkRHdXTDVjVEF2?=
 =?utf-8?B?a2FzRkFVL0xXMFZWbEdueXEyNGU0dVBuc2szc1NSMEZkNkkwdGp3Y1p5R29L?=
 =?utf-8?B?K0IyZmhFWXNZYWgvamFFVnUvamxYN1c0Y3lZUitnNDI1aktKUFBxd3JPQ1hT?=
 =?utf-8?B?MENINE1DR1ZPU0NpNFZiMlBhL0xUVTBJWmk0NjExWHM5UDd1R0tVSkp3aFl2?=
 =?utf-8?B?bmN5ZWllYW9FbmJiTVdmMWljL2VFZzE2WE52ekZydE9TUHRITmxhSDhwT3JY?=
 =?utf-8?B?YVFYWDJhMm9rRVE5UWQ2MEdIMEo3L1VlMThaVFlBRDl0WEkzTFowbTc5VEl0?=
 =?utf-8?B?ZVpCcnNiMzdSamlRQkFjcDdDY3p4NVMzNHhLbXZVOXF6VzFRV2gxQ2x6MW90?=
 =?utf-8?B?dWhOWDdPYzBQR3M2QWFZZVlaT3N2bFQ5RGowVlJneVEwaDI2dTNFc0oxckM2?=
 =?utf-8?B?b0FNNXJGUms2UU9XV3VOcVZDVEtJK2MvMmJOZXFvVGRsUklvZlR5ZU1rU2Fi?=
 =?utf-8?B?cUt4T2lHalY2czYydEtFMG96QkJ1Z0IzcGx6NnJ5b2FkbW5SQkl2NkpGbjZS?=
 =?utf-8?B?aFpZT3VTd1VVaVdNK1c2K1VEMWpXdk93emlwZnorRGp3TFpBWENGaUNRWnpC?=
 =?utf-8?B?Y000QlJkUVAzNW1aV1dwdmI0Y1dkaDhyTmJlMjdjWGJ1eDRwcHI2dk9RUG9o?=
 =?utf-8?B?U2lobnFoVFNYMGdmazhTOGM1a3FDaFEwY2RPMTVPODl0SFVRUS8zQStFMENQ?=
 =?utf-8?B?dE5QRi9oekh3UkZ5dlFpak05OWFVUVhUVmJzR01Dc3M5b1VsZzJiWUc4K3V0?=
 =?utf-8?B?TjNTSFZqQ0JPc2Y5aWUrdjRuVjg4U1cyVHNiL0hudnA1VGUyUms3ckNKYlBZ?=
 =?utf-8?B?YndYcUxCQSs4Yy9acWljQi9lN05hem1NYVdrNXM1S2ltT2NnQUwwYWp0NFRL?=
 =?utf-8?B?czdlNklEN3IxNCtJTGF3UU9JOHF5Vmx1bHByZU95ejlVc2xFYmFicFUxYnE5?=
 =?utf-8?B?d2xtdnFwcVMySUc1VC9uUm9Bd01MbGdNMGxkd2NLdkFLQlRZK3prdExkN0Jp?=
 =?utf-8?B?ZDZhR0tOcVlSaEN3SjhQVnA2a3UxTWt5UkFLbFNIWDA5S1Bta3BkZUwza0xM?=
 =?utf-8?B?US9xTEhPT0pJRUd6Tks5Nnp2MzZFK0JRMlVyaFZVTGNLUlFlcURCRE1IMmxQ?=
 =?utf-8?B?bTZYY3NneTJyUW9mUnR4VjVMS3N6MHlXM21xWjloODYwWXVvTGJMWEpqN1Fj?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?TWtlQnhCQjFSaW9pdFdseExWQW11NllLUlBmSmx3L2dmSmVVbUxObitKUUM1?=
 =?utf-8?B?WW8ydWdwak92OGlyU1cwanpIcmJPRnlLa0ZFVHB1cEpFMmhmZ2dobGhKMW42?=
 =?utf-8?B?OGtRVTBvNytuNDcybnpWbTdVSW8rY3Z2MytiS0NQMEQ4WXpTTkNUWWF6K2Z6?=
 =?utf-8?B?Z1lKUlE3MldEcEtHSVRiK1ZqSWUySGZIWE5ld29NdW55SGdBeW9SNDJHRmlq?=
 =?utf-8?B?blR0Sk44K0tQWVYxY3hiaC9RbjIvUU9SbW5sVjJnTFFNbFFyczZZK01SdEtZ?=
 =?utf-8?B?ZzZNdUpsTEphUlFsV3RzSTUvYzhCd0k5VGd0K1YyZU41WlhCUnM4UkhsZ0h5?=
 =?utf-8?B?alVtNUhTZjdXdWlFTHU1MjQrdS9BQUdmelZody82eFJlNVkzSHdSQ2VtM2xV?=
 =?utf-8?B?K2E1YjVCQmFzYURPMTlWbTJ0cml2MkdDeEhpelc5R3JxOFhrY1B4WlJac1o2?=
 =?utf-8?B?c3lsNVJtcGF0a1JNSTVZQktMYW9QbUcxS21kYmlNYUVvczBwN241WU1OckxI?=
 =?utf-8?B?V2VOdnNRVHFrWTNhdURaQVA1a0JMZHlVejdRbXJSd0ZEVHlPQ0p0K3pkOG12?=
 =?utf-8?B?U2JISVZYcG1FU3lrUmVLeGNoczhicWtJeGh6RzRka2E2WTcrV3d4VlZta1Aw?=
 =?utf-8?B?T2piWVB1ZC9qNnNSNUpjQVN0UkVXeDhvSk5PeDNjMTI3bnNBdFY3SWxWL0oz?=
 =?utf-8?B?akxNUDgzaVc4cU1HYTM4eHNPQzhsL1VEeFFib2JRdGEvV1Y4Vk5FQm9TYWMv?=
 =?utf-8?B?R1lBK25uakJqazFwQVVoRjB4ZlR6STdYTzVpbXhCM05kZ292U0tzQ1ROanpB?=
 =?utf-8?B?U0xRNm1QSmNXM3V6VjRVZVVHYmwwZ0hBNVZCdlFza1hzTkVrbU9kaGFEbkFa?=
 =?utf-8?B?TFhHekNtSk1sM1p6aUF6eUc5M0hBckU3TEh0Q05lMmtqT25PTDRUalZVYmhV?=
 =?utf-8?B?Y3hXL0JIYTdYMnJHc003VGdkdFBZTy9UTm4wRkpTUmlYaUNEQlpMcVAzS1Yw?=
 =?utf-8?B?R0lxTk9uWktLaU9xUnV5YkxzcEkrNXJlYVpyWm9sSDJVcFhCbjZKR1hQK21R?=
 =?utf-8?B?M3NVaEljYU5iQzJ3ZU1XeEZxNmhkQ2Y5ajZLZ3dIWitUQU4vUEx0eUFRbkIy?=
 =?utf-8?B?dUNxNTRaa3FXYVNLbjIzbHl4SVJUZ1FmNlIrWkVGeXU5N2UvWXNwbHZNRVcw?=
 =?utf-8?B?cG14S0VWb0docHZJTTJVWmJmdEVvWDRibjJrVnB1emFMQ2grY0J2L1ZQUWQ4?=
 =?utf-8?B?SzBhOE53ZzMrV01qYSs1OGZVOXlidVc5SzJXZjJSdzFMd0ZEWWo0UTVNWmZl?=
 =?utf-8?Q?+/DBBPRel1UiY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde04e73-2a6a-4a3c-755a-08db6126acf9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 15:58:14.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAMN9lMr5BIAQWDQ7rOq4fP96RUg7W5KGoQLctWSB/SH9haJbukd4zgzqRv8M1gfjXg3ko89D2X1qyRsskmhqgssZ6+XxR4d9tkbNO5Q3ck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6222
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_12,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300127
X-Proofpoint-GUID: iGcSEkeR8yLKBI8rwWrGWoCmkgYWYbdp
X-Proofpoint-ORIG-GUID: iGcSEkeR8yLKBI8rwWrGWoCmkgYWYbdp
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 8:44 AM, Stefano Garzarella wrote:
> 
> From a first glance, it looks like an issue when we call vhost_work_queue().
> @Mike, does that ring any bells since you recently looked at that code?

I see the bug. needed to have set the dev->worker after setting worker->vtsk
like below:


diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a92af08e7864..7bd95984a501 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -564,7 +564,6 @@ static int vhost_worker_create(struct vhost_dev *dev)
 	if (!worker)
 		return -ENOMEM;
 
-	dev->worker = worker;
 	worker->kcov_handle = kcov_common_handle();
 	init_llist_head(&worker->work_list);
 	snprintf(name, sizeof(name), "vhost-%d", current->pid);
@@ -576,6 +575,7 @@ static int vhost_worker_create(struct vhost_dev *dev)
 	}
 
 	worker->vtsk = vtsk;
+	dev->worker = worker;
 	vhost_task_start(vtsk);
 	return 0;
 

