Return-Path: <netdev+bounces-7159-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DB2771EF1C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:33:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53E392817FC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDC213AC3;
	Thu,  1 Jun 2023 16:33:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F2B6B3A3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:33:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CACC13E;
	Thu,  1 Jun 2023 09:33:35 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4UIM021342;
	Thu, 1 Jun 2023 16:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=s6ryvar9YU9CNBCR1TwGSQ80/eQ0OlwZI1pKsPxhyy8=;
 b=GnTC3lOGYglhL7fLKvEAiKhU5Z4JbAtQAmlKcVAcpD76YttstSwkErBlE6b45UFbHSIx
 PZeqmBPl+0er/0/yZ1DCl8wRLf/cYjLTYOnhfjMB32vpi7yEUCqgminGCe7UO5Yv1T19
 YTiFwJEVtvbG+Et2sFf/TZL6wJbVyInWqrUwndfpHhMhbqsDvNwPYqHXRKoQ3bVYIixE
 K7L6yV1cXwxG2uZZbQUXt0lgmTc5kveiuxnZu2UL6qIyP9m7sZh7+rCNmmRT8tpZxHJU
 Z75fC7cQTfWykyTuHwtWQdi7ZTjNwPTdVewt30AIwRmVp8HNdnwzuJwf1E92qrybIevq LA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb997f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:33:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351FnTgJ014722;
	Thu, 1 Jun 2023 16:33:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7eb0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:33:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abfRnqrwEomqE8ohlXTD/ibs1cFCySYj452X0RR8U1CNjeE+5s4a/GymJcoIaw5bH581HFiXPfFlAtUNlkE/iswGswnCO9QqkG3ZIuUqCHs/ST1T+jaqaT67Oa8HPm4beejje6Ja+WZgQKD4hbq8uwZLNiyBY2vdK3oby8p45l5xSMs29/cDPxoUgJelfNqJWX+Z3phiEoZOzC6GKS9SZ71c9of9J3wGKhPDdC8GAaUHw+JBVe5P+Ysb5IR+ydE6VI3Wb4AFGbvtTgyjSo9xG1ea9W6WNwCKQ4VfW/09TpQIUZzwtq1TpNEeqf+9z4UZeRkeUmQYBvtQZHf+Hp39UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6ryvar9YU9CNBCR1TwGSQ80/eQ0OlwZI1pKsPxhyy8=;
 b=Klq+UA+1+slszxDqqnH2pssB2CFOh0BK6RR50BSfXnI/e+9b9Qyx0I9NwzBCMcmM4FgsMmuBgopOwvXgI/q1bqOz1FPLfC2ySq07wK7URDT+FotjjKtRSKRm/mWFczVYFgqyggO85W6MQBf7NhL5jVj+ReB4ivBND0SQtV2JRpytqtFTi+GU8+vJ8h8E+I8yNU56WXoCaD/Kyihw0yHG50xq3stD/tpYR/HTChzDZ2BPJoMk0KWGCOU2Cue5qSv28ejc3ftQj4Ecqr2z9ktjX25DDS7asqk+KTbUOoBv4AtMSpAke8CWgEIJrIdye3/BFF5Unj3QFsccePLGfaD+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6ryvar9YU9CNBCR1TwGSQ80/eQ0OlwZI1pKsPxhyy8=;
 b=wX/vzCyy377YQbjrIR5NpBQqo7HxgW8BerwkRdztiwL0evt16/xXGnJnaFi0tliJnXZRrsU4/0WK6VYcRwXAFdQr+FtOZp5ucModlnmakKvyJjPfH2J37VDXX4KZLD8rZEn4HKnipgg/5C83NaPLEKs+ZtbHNpWT19+dCbz01/8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6725.namprd10.prod.outlook.com (2603:10b6:8:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 16:33:11 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 16:33:11 +0000
Message-ID: <b5a845e9-1fa0-ea36-98c4-b5da989c44c6@oracle.com>
Date: Thu, 1 Jun 2023 11:33:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
 <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
 <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
 <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
 <43f67549-fe4d-e3ca-fbb0-33bea6e2b534@oracle.com>
 <bbe697b6-dd9e-5a8d-21c5-315ab59f0456@oracle.com>
 <7vk2uizpmf4fi54tmmopnbwwb7fs2xg6vae6ynrcvs26hjmshb@hpjzu4jfj35i>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <7vk2uizpmf4fi54tmmopnbwwb7fs2xg6vae6ynrcvs26hjmshb@hpjzu4jfj35i>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::20) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6725:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c90095-a072-41f4-a938-08db62bde3b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Mhif9NguuubHf+C1MWA0vmsvPJNIis8Xwex9mFt3bx1StOxPUsog7MbPvXqSAfXR1/8oramdpInPL76pCCVAK1MpddeCNyxKzhK5N5eQtpVlW43KEmmtxOPFzl2Pe90Kh17XAITYgJW+417cFAqd4BVYAjUFEu4IgU8y2PTN1Km64lWsMqzbQtSes1OblEoovJohy3TtFNSTLFd65pVBSg35/BlQtcHFcAorx2l+U1orhm7PRBMDxr0ug3K26hWrUaXdXBxiNNQcgqnoEeiEl2gsS0eXVFh0rf+evnft3/jjawO0pIahPFRzjAicwB47YRzqxYSZleJc0H3s5cRiZa2QX9sZ1i6E6h+qvLB/bpcQpq208u1bcLZhNrsLO5jsk31n5VdPHrV2G+vo6qpxobTsU0ppniAxBx04ujWDs548laJEApGoeTtg9+zWojkuLhOyCzoQlz5ziu0bLEoWtF05r0M+Y33QMUn4yw+nd1swNRvA29qV50tmJ/oucFri8M2LSIVU3oDSIdAtadvNQiyfxYMSUI9XH4uLSLmAGPhOTRNuMNf0metMBhR/mkbw7yaAY6Xi1C90CAjTe8O4xmsUvwIBLochYrn/BoXlKLrl/BLBIaUYx7Ne6c6w+5jKwiViJmIojxMbMutlHCG0TQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199021)(2906002)(186003)(38100700002)(6506007)(6512007)(26005)(83380400001)(53546011)(54906003)(2616005)(478600001)(7416002)(31686004)(5660300002)(8936002)(8676002)(6486002)(4326008)(6916009)(66476007)(36756003)(86362001)(31696002)(316002)(66556008)(41300700001)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SkVkNXlZWWh3VTg4Z2hrM0xsNGRqaGdnMFN3ZVdKZ3h1Ni83a1lNeUlCOGpO?=
 =?utf-8?B?bHUzZDF6bWFVTDlWU0N3ZEs5M3VRVE1zZ1E2MFVwR3RpcnpNNVpBZmhaQytz?=
 =?utf-8?B?WCszZ1RTV24wenQxd0hXUGZiZE0xMHZoZzh4TU5iZ3Flb3BDTVlOU2Nrellk?=
 =?utf-8?B?QTVvM0tZa2tPZGVGTGdKOGNOdjNScktrWTY2Y1BycFhhK1BYSlh4aFQ0OEFq?=
 =?utf-8?B?N2tLOFJYK3A2bW5OWGFLOE1pekM2Lzc4SFRPaVlBWkRqcTVRMVZGaTY3Y2NF?=
 =?utf-8?B?aWVEbEN5M2tSb3ZialdaaHJ6ZzhyWXJGdlQxVkJMd0hrYWJRTElhdjhNTHdT?=
 =?utf-8?B?NTJRVGdrLy9EU3dtTk02TWhma3g5QUN6ZnFpY3FjellJUHpHbk1DRDFGODZ5?=
 =?utf-8?B?RHEzNldKWU9WTHk4K1gyZU1UVkpybC8zN0NCWEFmaFh4Rk0xdGQ2TFdZQ2Fa?=
 =?utf-8?B?U2RsQUJFQUNvRm5STmNMM0Z4bU52bG5OdUlWY2tCcGJyMm9GUW44SEhEQzVx?=
 =?utf-8?B?RnRkVnljdHVKbVo4ZmdkWWpyZ0lzbUc2dXZLWnBIS25ReWZFN1hJelNFaElJ?=
 =?utf-8?B?RjdYN3dRZnUwY1BmdVduczI0V002R1AzSlZjb1VOTVpMc3RlYVUzUXV0bm4x?=
 =?utf-8?B?OUR1OTU5ZUZuSWE4WVYxU0FIV3lsV2E1dDVUanhKZGZadFZpNkc0VjhEVkVB?=
 =?utf-8?B?VnV4V2FBdzNERTdjdXlkK2RKTEdzSWVBZ3h0U3pqallCWU5GWDJvVXllMmIz?=
 =?utf-8?B?R3gwdCtjZUdNT3Z5OUxHbUFhSFhkNlRUQ25ySTNrT0NTb2RveGRqdVB6TUsr?=
 =?utf-8?B?aVpBdFc4L1FxWDFJL1dPUm1zM216NGZJcmpsT0FtZU0yN0JROWc3eWN5WW8z?=
 =?utf-8?B?U0crOW1SN0laS0ZiMWVGeGJueHlWOXp4ODhycmFsT05BMjV2UDJoWHVqOGhB?=
 =?utf-8?B?eFVzTUJDT1M1QmhEcFJRM0tWVTRlcGRsR2hocHN0RzZ5MnQxOU9GbmZiMXJ5?=
 =?utf-8?B?d3lvODVRd3V5a2grcFVlYlMwcjU1QWNIUEUyYVg1c3FXcEJ6Yy80L1hNS1Rq?=
 =?utf-8?B?bGFRQWtVOGhST0dmYTVORERQTDVGYzlGZVNBeG1UR3JTTEZGZGhrc1VPWng5?=
 =?utf-8?B?bWNydEdXekVzSzNnbmNwVUIySjBPM1pmNzBVYlkvT3ZSRFJBeFZxODU0SERs?=
 =?utf-8?B?SjVzZjlYWUh1ZnVKbDR6UXNkZ1JyV2haVkMzQ0FQY1EweGQ1TGhrMFRjWHZl?=
 =?utf-8?B?UzdJMG1ubkVaeTRSWFVEUzZyZzZwTEhCUDZrZ3VSenpWMGxJaE9jWjlWVTlS?=
 =?utf-8?B?YkRBMjFBczRJN09OYnVSVmFBb1R5MDlGakZraGQyK25KRVhaU3NnblU1VkJz?=
 =?utf-8?B?WTZLZERVZGNYa3Zyd0RLS2g3ZXNtbVp5b3JDSjNDK1JEUVlGd1p4c0NiMitY?=
 =?utf-8?B?UGJ6Smw5WG9CUmR5S0ZBQjdoV2UvNUQ5V2l5RjFsQVFLcmN2ZGY3aU5pekNN?=
 =?utf-8?B?S1lqNm9hR0pqUU9rL2tnOHNYSmlhbTl5dE1sNnVsOCtmT2U5VWhFMS9lYlJr?=
 =?utf-8?B?c2xGUGxJdjhrQ3lGOGdwSnB3Ym5SN2lZaVNWZWQ2eUY0ZlVuVmg1RE9OSXZR?=
 =?utf-8?B?R01DSlV1NVoyUWk1cThCejBibW04Tlk4V2tyRHlBNlh5djU5TkNhdzdsc08v?=
 =?utf-8?B?OWg5bHZVVENwU2NRa0hxLzdBNW5PNnFEK3AvMlJ6emVrcS80aUVwcGJXandC?=
 =?utf-8?B?cHVsV3BpeWlnU2xHdUFsVFFqc2lML2RiUzJkcVNUS0RnUmRUZGoyQkdDTVQy?=
 =?utf-8?B?OXpKR2lUeGVROHk0NGp1cWhVeml3NVIrWjZZRHdXRGxjeU1UdFlreCtYYlRJ?=
 =?utf-8?B?R2RKMFpPd2hIVTRaaEgwWlM0ZFR5MmljV0FlaWJFNlRtWkFYWWtBOXJ3OENL?=
 =?utf-8?B?R2M2RzBlS0hzVnNtWXlvcGd3MmZsNVJqYWlWYkM4ejRuTE82RzRaUEswVU5W?=
 =?utf-8?B?ZXJRVExXZEpyOWRxZTY3aDlCREsvMCtHTVY2bFRMVmxvTER3YVFiWExKSEFK?=
 =?utf-8?B?eWtid0NURVQ5Vm5RMjNXSTRmeldoU0ZBOWlBUmlmT0J3elNUTHErOFNoNGoz?=
 =?utf-8?B?ZnpKb0FIMkU2TmNoSUlDTW9VTEp3NE1LY0xtU2c5WFR5bGR4TUhidm10c3FV?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?NC9ZTFQ4WkZUcyt5aUNHcGYrZUNVeWl1NW0yaVdua3JTa2x2RkIwWktPZFA0?=
 =?utf-8?B?REY3UlFUczJwZmZKY3VzZm10Z0pvZEhZK0EwTkpkS2FBczdSV0FzQVdiQUZ1?=
 =?utf-8?B?WWNxNWZ2cjRsR3k1YVlKMWJpWnhrR2JINGQxOXlvNTZvblB3QVhFWW8vNXBN?=
 =?utf-8?B?NCtnNGhRem9uTVhWSElrN0k5S3FZZzdIWXhxQ0ttS1NCVnN1MXduTVZGdXp5?=
 =?utf-8?B?LytCaTN2dWZxd3o4YUpDMmVCZVlJbDFDWGZPdjZCQ2JuWE9MREpidTdmMi81?=
 =?utf-8?B?cmJoaGRidGdRaWJ2VXVYUnpRTGo0aTA0VnZ6aVhGYnJ2OGVpMC95K2M5UWxO?=
 =?utf-8?B?d3R3NkVnUUJxVUJ5SnNtTVNBa3NFS0UrdER1ZWZQdXdZVk9WZXBFN24wYldS?=
 =?utf-8?B?VlJNZiszKzRWTXE4M1BLMjdvMGdFRmhodzJNUG9nbGJKMnhYeTBuVVBaUkEy?=
 =?utf-8?B?VzY4bE5OYWNhbGpMRmpHNUFTTGcrMnVBcFpLVGpxeVM5Z1ZqN1E1SE5MUUk0?=
 =?utf-8?B?aSthTmNwc0xwYnpZc0xzWXAreU0vYjR2T2lWbmpCZFU4eHBaZEpZOUJqWFZz?=
 =?utf-8?B?dHFkTFpwakhzNlNtOS96M2VDT2UzakRzbXhKNy9xN1hOVGRaTVlCZURWbjQ4?=
 =?utf-8?B?NDRJd3VMRmVuaHd1SkNuMVBqZlJTQnl2NU1ENFZOUGY2MEFhZU5JTGJ3THhl?=
 =?utf-8?B?NGVPMUhQcS92MWtFYXNOOFNHR2xHNkI4UWJndCtkbU1jRTlSR0xJT3E0Mzlx?=
 =?utf-8?B?ZWVUd1NBOTZMRytTYjh3Vi9RUkhnRVdKa0xYbms0bmFHREhNdEpxdHRoOERH?=
 =?utf-8?B?YjBVV1VMZ3p4SVNReFVyNGNEblBqNytPekcrYXMxckx4Nk1RQk51cHdQZlZ1?=
 =?utf-8?B?SkR4SEhhN2cvU00vQjlVQXdDa0R0RzNTcDB0Y1VVVTY1czI0UmdVMlg4Z1Ar?=
 =?utf-8?B?MkNvZlJxVW9oMlVsUS9iZGpQTkcxNEUvZ2NnTHdlU2JxSU53SUlMdytuZkFi?=
 =?utf-8?B?VE5zT3hOVHNqTHRaeHFhUkh3bkNiV1VMTm1GbkJLM01wL1BGeXJ4QU9wQjhF?=
 =?utf-8?B?VG5DT2cwdTFobXdYMHFMWm5vS002TTZTS1FhUDVEVXA1aDRpWWIvNXNlK1ha?=
 =?utf-8?B?enkrTTMvV0s2NStyb2dzcXRNQ2xTTHYwby9WS21Jb0JrNk5rQjB4ZzFmaFpV?=
 =?utf-8?B?MmtyQXhNSFh4Wmd5M21jL044V2RDVWs2VFhuNTZxY3c4Y2Myb3JCRG5DZmpQ?=
 =?utf-8?B?S1p1dUVBQk5LdDZXY3lUeERmM3V6U0tKLzJnUXMreEUwdUdZUExHY3lGa05i?=
 =?utf-8?Q?qrB1jKUqVrRYc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c90095-a072-41f4-a938-08db62bde3b0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 16:33:11.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vyV/1I0GbyPJtDwvI2I1LaTjnSlZvuycNqFZTQHWWtFBBfSVhsubWFFPn7QadUVFz7wXBH6+amPN1uQNo1hBiWL53otWEei4jSDmitw4AHI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=770 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010144
X-Proofpoint-GUID: yHHNFO-IelSXUJKehf1SO_Cg8l3LWYB_
X-Proofpoint-ORIG-GUID: yHHNFO-IelSXUJKehf1SO_Cg8l3LWYB_
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/1/23 2:47 AM, Stefano Garzarella wrote:
>>
>> static void vhost_worker_free(struct vhost_dev *dev)
>> {
>> -    struct vhost_worker *worker = dev->worker;
>> +    struct vhost_task *vtsk = READ_ONCE(dev->worker.vtsk);
>>
>> -    if (!worker)
>> +    if (!vtsk)
>>         return;
>>
>> -    dev->worker = NULL;
>> -    WARN_ON(!llist_empty(&worker->work_list));
>> -    vhost_task_stop(worker->vtsk);
>> -    kfree(worker);
>> +    vhost_task_stop(vtsk);
>> +    WARN_ON(!llist_empty(&dev->worker.work_list));
>> +    WRITE_ONCE(dev->worker.vtsk, NULL);
> 
> The patch LGTM, I just wonder if we should set dev->worker to zero here,

We might want to just set kcov_handle to zero for now.

In 6.3 and older, I think we could do:

1. vhost_dev_set_owner could successfully set dev->worker.
2. vhost_transport_send_pkt runs vhost_work_queue and sees worker
is set and adds the vhost_work to the work_list.
3. vhost_dev_set_owner fails in vhost_attach_cgroups, so we stop
the worker before the work can be run and set worker to NULL.
4. We clear kcov_handle and return.

We leave the work on the work_list.

5. Userspace can then retry vhost_dev_set_owner. If that works, then the
work gets executed ok eventually.

OR

Userspace can just close the device. vhost_vsock_dev_release would
eventually call vhost_dev_cleanup (vhost_dev_flush won't see a worker
so will just return), and that will hit the WARN_ON but we would
proceed ok.

If I do a memset of the worker, then if userspace were to retry
VHOST_SET_OWNER, we would lose the queued work since the work_list would
get zero'd. I think it's unlikely this ever happens, but you know best
so let me know if this a real issue.


