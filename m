Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1C86238F7
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 02:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbiKJBiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 20:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiKJBiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 20:38:06 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B90E20185;
        Wed,  9 Nov 2022 17:38:04 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9MIZkc010478;
        Wed, 9 Nov 2022 17:37:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=AsCy+BHYLGoYi3RWQ3OfoIFQJVilHOO0fsl9mo9vT3A=;
 b=keqYP8nU1IA+bSLOhHQkxhet8oBA7fCZw/XzZhB+VwxuqWQCC6iaYaMYSrqLYXJFjBBp
 R3rYdvLLi/smHTCNiQ1XsUVdE97/veB/2fKZCDOsuUsSF7A1yS/96MyklCJVx0YGGefu
 8S8qln+ziwo7oG5gQ/VN1a269LNtQy9uTH+dwO+161c7SQaiury8Rh9xFV0pRMP4C2os
 UHrBtLo3CQ2z26anMiGaizss4KtqwRA7iSGKv1ZGXp5X2QpqoSniNiwvU7Hbo32IeFhZ
 kaSDhiivNmzdEcScCbDvTIumCYdPfJQS8qW4KdgYxCVsxcIqZ7GSq4fwR1lMzJzBrcGV xw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3krm5q1jjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 17:37:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkelGIIVVa0h4aMnp6Q6Mvx9ON2LIfYqpTepUds9ulx1H6WExib8znPSUczxHr2Ca/BX9ojQvHGXSSePvaoYyDxsrQOFXvo4vZ6JVML+wuyQn/tqZ4JxmniqDCnmLB9hqFYpDvvFIUXf1nbrvoLabrtrzzuWSI43wif81WleijuoS/d3pumkdqCglN64pH+FD9+COfmRJaAIMaekvALNVIemTAOpOMIorNPjTlRghLGsl6RSoEKQBNlVAOEhQE3EDgNioIaaxy2nRGBPech0rh1fZKnfN3mzysxNSIIU4zntCzTq5SLBEfYjj83tAI6mfNMGUemWU52R+sVHKQyaIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AsCy+BHYLGoYi3RWQ3OfoIFQJVilHOO0fsl9mo9vT3A=;
 b=OTNGOhd4B256xmZYX3eGr51rFvbYRYZCLNGdsAJqKmHDWfxaTfPFC71MmEOJpQ8u902zpvkUWCQX9+0CIP4dquLE3TctM48OMsdSi/RGHOQ4X9gXnEI1VSWcf6XM9bLEucpf2HGd9m6wgxTU4YeE9sBRB/FkE4sju8hByxbTIWGK1q46B6m0WDBpoqrTDUlvrJyq+FKpRERgwIIoymcl1JDAzlEZwX8E850ckteFF5W6O5E4E17THou0NhQZqWiWJQCf9yJuJ3D7yZJkvTgRCyrINsbuU4NgmeFzWjc6t2wsMSy926/f3t/qdRRComOQ2xubD/VesnbK7LUpNhrESA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2080.namprd15.prod.outlook.com (2603:10b6:805:3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.12; Thu, 10 Nov
 2022 01:37:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 01:37:42 +0000
Message-ID: <0697cf41-eaa0-0181-b5c0-7691cb316733@meta.com>
Date:   Wed, 9 Nov 2022 17:37:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [1/2 bpf-next] bpf: expose net_device from xdp for metadata
Content-Language: en-US
To:     John Fastabend <john.fastabend@gmail.com>, hawk@kernel.org,
        daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, sdf@google.com
References: <20221109215242.1279993-1-john.fastabend@gmail.com>
 <20221109215242.1279993-2-john.fastabend@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221109215242.1279993-2-john.fastabend@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SN6PR1501MB2080:EE_
X-MS-Office365-Filtering-Correlation-Id: a4eff26c-0a38-467b-8474-08dac2bc28bf
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UritDmpaIJibKPl/kIwRPeSUrhIEZ7pHfVbiz+Behb2MssKjpHrElb4wqzZUc9E3R/KxEFVlPrrIXiFRButKhp3SUFUhdX3fSP01eA0naXde/2yxP6x/3IOChFqwlp1EkXa91u2D4dly+NWrW1buBYw+IQ0yXjQ8wL9wK+947ipm7SD9NyayUF9GZ20Oeub+8aBHHTQEeTNh/leDsp3DTWwmLtsEMDASuOGyvI04yGOrf+w28egvzrFKeb1rBRhXEkx6S8Y53dsM7LQ3ABXc4mCE37uOiaCnChewJkJf28xuG8wDLIyVsde1qO2xMIOe/eYgarLSLakXS5w8Sui16+XKhhtYuY4kIgygCrgdAhzUx5wT/suac8JdcT8Psysi0arNoQRozsfsaLqmPdH4Yga3GJZo3TXa408JLjtsOlMRzLMAMXBG/hnxx1sSNzKFj/1MQq1OYVKg5rhY0tQqgtuHL7/JUHYy9i8KHysiDZppRMUu4qsidijbt7TFis+KD/2tGv8FpTus78lUggKPTovzOTP5HPdVbmICctP1wyYfACLeXbDWwTCoURyVDG3ogRneSl2eTSXKxoZ84VxdtTxv4eNstDr/abkCVTRxjh6on1mPN+KQ2r2SSE43ZpD1Jz6RMQ0gAUJ/O5pS/w5rN0I6h2AXu/dJWRgG+7rUfZhbAQQNor6JqxRTy/nhKtsAyfeN8iZ+Ytb0BrfdZ8wkETByw9/vVbqfa8momMpSslH7ddqtasWqPK/iTfohZsfZfn97G8OBZzYem8WrI4RQGa2GfqX3EyBjPH5Ml4gDKoBTc7F+QvvAlue45Vya/EwCNMf/nF8iFmP8OYQJ29A4SjTUML4+lDisDHqsBkBkJYR40aoCsyO9QlBfegvad573
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199015)(478600001)(38100700002)(30864003)(6486002)(2906002)(966005)(2616005)(83380400001)(186003)(6666004)(6512007)(53546011)(36756003)(66556008)(66476007)(316002)(6506007)(4326008)(8676002)(31686004)(66946007)(86362001)(31696002)(8936002)(5660300002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGJ4YjNCSlpnZXBEM2RPcitwM05NK1JLUEkxdFN1aDU3MVhPM0RjVEZlR1px?=
 =?utf-8?B?T1h6SDBtdVY0NXJlSmJNSmRETDlmRDA4VmtvSEprcVUyeTNVMmIvdkdEY2E4?=
 =?utf-8?B?TTVvY2oxTy8xdDY2NkdCMm5OL1NjK1ErM2hrVFBiMFA5NldJMHQvUDlvR1M4?=
 =?utf-8?B?UGJJVjg1QVVXSitsL1dzUHlWREVqUExhSkZNWGlqNWdROWcxcTVZenMxV05R?=
 =?utf-8?B?enZpeW5aeFp6dkl3cGR6VXRqUUpFQ1BTazd6UFRSVmpsVndMeTY3MGQ3UDFO?=
 =?utf-8?B?aFRYQ3NZYUpuRmY1M3pTVFZjd1phZlpHVFdPOVVOTnJUOGxyem40aUpjcTRu?=
 =?utf-8?B?LzhoZk9MWHROMzl6SmVHeTQ0STN1TVk2NUNORURDSkZXYks3dE1lcmR4YjZO?=
 =?utf-8?B?RkRIbWc0WFh2VHhpRGxTcjNQNkxINHpxNmJ5aXY0Q0hqSFIxUGoxMTZaTWFP?=
 =?utf-8?B?eFpaakVKSUJpT3JVWkVRTTlrVEtXbDkwUDN5VUttbytkYzVyZDJYb0JYQjVt?=
 =?utf-8?B?RFJobnQvSmF2Q0ZiQ3BSMDcxRUErNG9tMjU1eGxCOVNlTW9GWDliUmV4SHFS?=
 =?utf-8?B?ZXI0UzNiSFhiMnY3VFFnbG9oeHA2WFZJRG9Iakxuc0dQMzJwV3loK0llMmFF?=
 =?utf-8?B?ZlQ5bzhNWktiZkFST2EweFpDTXBIK3lwaklKZUs1THJvcnRleEZJSTA2enFD?=
 =?utf-8?B?U3dCYVlqTFVtbWNKZVZ1NlEzWUJkTldSZTNLR1UvVE5McXpUUitxU3UzRGps?=
 =?utf-8?B?LzNXeWZXQ2cxRDlDN1lvaGx0bzN6RzYvY3FWdXZmZ0lzVFdTUlhMckQ1NjI4?=
 =?utf-8?B?RVdtN0QvazRUSzU0dFhRY3ByY1NQaHI5WUozMjBVckxvR2FGWUsyNkUxUk5Z?=
 =?utf-8?B?K1QzSGNpbGxySWxyelloWE1oNWt4SUV0eFBjelJFTjRUVlNCT0FYRGFzbExv?=
 =?utf-8?B?MWhQUHZ3QVE3MUJJVzZLWnpJRHNGNWRHYXQ4a1lGSE93WUxzSjFhc01TMVV4?=
 =?utf-8?B?aUdYTFlQYmpUbDViMk5UTG92bEpkT25nMEJRZmI5SmRvNm1Md1BXR01aSDZz?=
 =?utf-8?B?TlZ2VXA3NTBSN2o4WVE3dXdaS0NsVVBpbVBBcVdwR044YytXMUxaSXBxNEdH?=
 =?utf-8?B?R08yS0p5SkpmS2Q5NmNncWpNa2h0bkxwY2dpU2ZtNFZEL3piTXhZYVBiZTZv?=
 =?utf-8?B?QmhxZjdXbnFiTUFBVlJtMThIMVBwelE0TXpLSHBIOEZsZC9TaXo0dXZ0dHM1?=
 =?utf-8?B?R3oybHZUdHA5d05vMjJkNk1DcWJvdUg2VmFLVlBlMndYMnNYMnh2WVlNQkdT?=
 =?utf-8?B?eFNMWFZjbERJVUFJOWNXYjROdG1zQjVNYVhtVXViWXoxdHh6MERXVTdGV3FX?=
 =?utf-8?B?cG9HRWtBdXVNbXlhQlB2RXE3dEFGMzg3UkgxK3NoSE1La1U3RFgyN01DLzgr?=
 =?utf-8?B?S2sxQ0ZPR2U3VkV2L25hWWtyS3Rxb3hsbHhJVWtiMEJjRklmdGIvNkNUWFFq?=
 =?utf-8?B?MkpmcHl1TXhQbTFVc3Q5S1hTUWxzeDFseGZBWjYwM08yOCtiNy9vNEdJTG1u?=
 =?utf-8?B?MjJwaXUvckRQR2paUTBCWkRiVXFpcVl3WHBOTVh2d2FIRWdib2ZwcVVsZTlu?=
 =?utf-8?B?aEV2SnNpWmI1cDJTNVZVWUNiU1JaY3hiTzZ2UFpHU1J1RE5OYm1DWHZrQkdC?=
 =?utf-8?B?WS9jSWtFNHNNWUVmb2ZPY01hTTNwNFBIV0RtM0pKeWdaZmwyZzFjODAwakJt?=
 =?utf-8?B?S0VlYmpqQXp6ZWw5NXI2aEFxR2p3c3dlVDlTTVJDTXNzMEp3M3FHNzl3TDBr?=
 =?utf-8?B?SDEwekVZL1IzdjA2NFdpb2gvMEp5V2Y1RU9QOWxuZFh6RVZibTNyb0FLb0RB?=
 =?utf-8?B?WFpKSmlxb0JVVXRtYldaVjFIQnpCYUpEMG8wRVFkTUpZaHJ6dE1wMXQzYmpa?=
 =?utf-8?B?aGZOQ29laVp1UzkvRnB4V25BUm8wR2dXdXhPSnkydVMveEY4dzZYT1IwcHF3?=
 =?utf-8?B?cjRQNmxFaFhVU0VIU25kVUVVWHlwR2g5UkVVQUQwODNKdmord0twS1gxUnF4?=
 =?utf-8?B?UDN1eWJlQjk3dng5THJ2WEVPSWFrbXh0RXF0cndSYWYrSmt1UjRJWXE5bkxz?=
 =?utf-8?B?Y0wyb2tFKzluMnJObU5LakVOUmZQeTFWTnRXbzVJZ2pJNE9idWxlM1lVa1cv?=
 =?utf-8?B?VGc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4eff26c-0a38-467b-8474-08dac2bc28bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 01:37:42.1970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kt3Umg+27UizCjH8RJ42LnYPuRh+NJKNF9TkJdGAd5rKcednjbT2yhc+PlnKudFf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2080
X-Proofpoint-GUID: tF5ynhkaCKjtG9Ym31qaxEDpUg9-ZkwO
X-Proofpoint-ORIG-GUID: tF5ynhkaCKjtG9Ym31qaxEDpUg9-ZkwO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/22 1:52 PM, John Fastabend wrote:
> Allow xdp progs to read the net_device structure. Its useful to extract
> info from the dev itself. Currently, our tracing tooling uses kprobes
> to capture statistics and information about running net devices. We use
> kprobes instead of other hooks tc/xdp because we need to collect
> information about the interface not exposed through the xdp_md structures.
> This has some down sides that we want to avoid by moving these into the
> XDP hook itself. First, placing the kprobes in a generic function in
> the kernel is after XDP so we miss redirects and such done by the
> XDP networking program. And its needless overhead because we are
> already paying the cost for calling the XDP program, calling yet
> another prog is a waste. Better to do everything in one hook from
> performance side.
> 
> Of course we could one-off each one of these fields, but that would
> explode the xdp_md struct and then require writing convert_ctx_access
> writers for each field. By using BTF we avoid writing field specific
> convertion logic, BTF just knows how to read the fields, we don't
> have to add many fields to xdp_md, and I don't have to get every
> field we will use in the future correct.
> 
> For reference current examples in our code base use the ifindex,
> ifname, qdisc stats, net_ns fields, among others. With this
> patch we can now do the following,
> 
>          dev = ctx->rx_dev;
>          net = dev->nd_net.net;
> 
> 	uid.ifindex = dev->ifindex;
> 	memcpy(uid.ifname, dev->ifname, NAME);
>          if (net)
> 		uid.inum = net->ns.inum;
> 
> to report the name, index and ns.inum which identifies an
> interface in our system.

In
https://lore.kernel.org/bpf/ad15b398-9069-4a0e-48cb-4bb651ec3088@meta.com/
Namhyung Kim wanted to access new perf data with a helper.
I proposed a helper bpf_get_kern_ctx() which will get
the kernel ctx struct from which the actual perf data
can be retrieved. The interface looks like
	void *bpf_get_kern_ctx(void *)
the input parameter needs to be a PTR_TO_CTX and
the verifer is able to return the corresponding kernel
ctx struct based on program type.

The following is really hacked demonstration with
some of change coming from my bpf_rcu_read_lock()
patch set https://lore.kernel.org/bpf/20221109211944.3213817-1-yhs@fb.com/

I modified your test to utilize the
bpf_get_kern_ctx() helper in your test_xdp_md.c.

With this single helper, we can cover the above perf
data use case and your use case and maybe others
to avoid new UAPI changes.


diff --git a/include/linux/bpf.h b/include/linux/bpf.h 
 

index 798aec816970..da5e3f79f8a4 100644 
 

--- a/include/linux/bpf.h 
 

+++ b/include/linux/bpf.h 
 

@@ -2113,6 +2113,7 @@ bool bpf_prog_has_kfunc_call(const struct bpf_prog 
*prog); 

  const struct btf_func_model * 
 

  bpf_jit_find_kfunc_model(const struct bpf_prog *prog, 
 

                          const struct bpf_insn *insn); 
 

+void *bpf_get_kern_ctx(void *); 
 

  struct bpf_core_ctx { 
 

         struct bpf_verifier_log *log; 
 

         const struct btf *btf; 
 

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c 
 

index 5579ff3a5b54..cd2832e73de3 100644 
 

--- a/kernel/bpf/btf.c 
 

+++ b/kernel/bpf/btf.c 
 

@@ -199,6 +199,7 @@ DEFINE_IDR(btf_idr); 
 

  DEFINE_SPINLOCK(btf_idr_lock); 
 


  enum btf_kfunc_hook {
+       BTF_KFUNC_HOOK_GENERIC,
         BTF_KFUNC_HOOK_XDP,
         BTF_KFUNC_HOOK_TC,
         BTF_KFUNC_HOOK_STRUCT_OPS,
@@ -6428,6 +6429,10 @@ static int btf_check_func_arg_match(struct 
bpf_verifier_env *env,
                         return -EINVAL;
                 }

+               /* HACK: pointer to void, skip the rest of processing */
+               if (t->type == 0)
+                       continue;
+
                 ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
                 ref_tname = btf_name_by_offset(btf, ref_t->name_off);

@@ -7499,6 +7504,8 @@ static u32 *__btf_kfunc_id_set_contains(const 
struct btf *btf,
  static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
  {
         switch (prog_type) {
+       case BPF_PROG_TYPE_UNSPEC:
+               return BTF_KFUNC_HOOK_GENERIC;
         case BPF_PROG_TYPE_XDP:
                 return BTF_KFUNC_HOOK_XDP;
         case BPF_PROG_TYPE_SCHED_CLS:
@@ -7527,6 +7534,11 @@ u32 *btf_kfunc_id_set_contains(const struct btf *btf,
                                u32 kfunc_btf_id)
  {
         enum btf_kfunc_hook hook;
+       u32 *kfunc_flags;
+
+       kfunc_flags = __btf_kfunc_id_set_contains(btf, 
BTF_KFUNC_HOOK_GENERIC, kfunc_btf_id);
+       if (kfunc_flags)
+               return kfunc_flags;

         hook = bpf_prog_type_to_kfunc_hook(prog_type);
         return __btf_kfunc_id_set_contains(btf, hook, kfunc_btf_id);
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 283f55bbeb70..b18e3464acc3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1717,9 +1717,25 @@ static const struct btf_kfunc_id_set 
tracing_kfunc_set = {
         .set   = &tracing_btf_ids,
  };

+void *bpf_get_kern_ctx(void *ctx) {
+       return ctx;
+}
+
+BTF_SET8_START(generic_btf_ids)
+BTF_ID_FLAGS(func, bpf_get_kern_ctx)
+BTF_SET8_END(generic_btf_ids)
+
+static const struct btf_kfunc_id_set generic_kfunc_set = {
+       .owner = THIS_MODULE,
+       .set   = &generic_btf_ids,
+};
+
  static int __init kfunc_init(void)
  {
-       return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, 
&tracing_kfunc_set);
+       int ret;
+
+       ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, 
&tracing_kfunc_set);
+       return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC, 
&generic_kfunc_set);
  }

  late_initcall(kfunc_init);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d3b75aa0c54d..d8303abdb377 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7784,6 +7784,16 @@ static void mark_btf_func_reg_size(struct 
bpf_verifier_env *env, u32 regno,
         }
  }

+BTF_ID_LIST_SINGLE(bpf_get_kern_ctx_id, func, bpf_get_kern_ctx)
+BTF_ID_LIST_SINGLE(xdp_buff_btf_ids, struct, xdp_buff)
+
+static int get_kctx_btf_id(enum bpf_prog_type prog_type) {
+       if (prog_type == BPF_PROG_TYPE_XDP)
+               return *xdp_buff_btf_ids;
+       /* other program types */
+       return -EINVAL;
+}
+
  static int check_kfunc_call(struct bpf_verifier_env *env, struct 
bpf_insn *insn,
                             int *insn_idx_p)
  {
@@ -7853,7 +7863,20 @@ static int check_kfunc_call(struct 
bpf_verifier_env *env, struct bpf_insn *insn,
                 return -EINVAL;
         }

-       if (btf_type_is_scalar(t)) {
+       if (func_id == *bpf_get_kern_ctx_id) {
+               /* HACK: bpf_get_kern_ctx() kfunc */
+               int btf_id = get_kctx_btf_id(resolve_prog_type(env->prog));
+
+               if (btf_id > 0) {
+                       mark_reg_known_zero(env, regs, BPF_REG_0);
+                       regs[BPF_REG_0].btf = desc_btf;
+                       regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+                       regs[BPF_REG_0].btf_id = btf_id;
+               } else {
+                       verbose(env, "Cannot get kctx\n");
+                       return -EINVAL;
+               }
+       } else if (btf_type_is_scalar(t)) {
                 mark_reg_unknown(env, regs, BPF_REG_0);
                 mark_btf_func_reg_size(env, BPF_REG_0, t->size);
         } else if (btf_type_is_ptr(t)) {
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_md.c 
b/tools/testing/selftests/bpf/prog_tests/xdp_md.c
new file mode 100644
index 000000000000..facf3f3ab86f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_md.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_xdp_md.skel.h"
+
+void test_xdp_md(void)
+{
+       struct test_xdp_md *skel;
+       int err, prog_fd;
+       char buf[128];
+
+       LIBBPF_OPTS(bpf_test_run_opts, topts,
+               .data_in = &pkt_v4,
+               .data_size_in = sizeof(pkt_v4),
+               .data_out = buf,
+               .data_size_out = sizeof(buf),
+               .repeat = 1,
+       );
+
+       skel = test_xdp_md__open_and_load();
+       if (!ASSERT_OK_PTR(skel, "skel_open"))
+               return;
+
+       prog_fd = bpf_program__fd(skel->progs.md_xdp);
+       err = bpf_prog_test_run_opts(prog_fd, &topts);
+       ASSERT_OK(err, "test_run");
+       ASSERT_EQ(topts.retval, XDP_PASS, "xdp_md test_run retval");
+
+       ASSERT_EQ(skel->bss->ifindex, 1, "xdp_md ifindex");
+       ASSERT_EQ(skel->bss->ifindex, skel->bss->ingress_ifindex, 
"xdp_md ingress_ifindex");
+       ASSERT_STREQ(skel->bss->name, "lo", "xdp_md name");
+       ASSERT_NEQ(skel->bss->inum, 0, "xdp_md inum");
+
+       test_xdp_md__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_md.c 
b/tools/testing/selftests/bpf/progs/test_xdp_md.c
new file mode 100644
index 000000000000..c6a7686ec9c6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_md.c
@@ -0,0 +1,28 @@
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <string.h>
+
+#define        IFNAMSIZ 16
+
+int ifindex, ingress_ifindex;
+char name[IFNAMSIZ];
+unsigned int inum;
+
+extern void *bpf_get_kern_ctx(void *) __ksym;
+
+SEC("xdp")
+int md_xdp(struct xdp_md *ctx)
+{
+       struct xdp_buff *kctx = bpf_get_kern_ctx(ctx);
+       struct net_device *dev;
+
+       dev = kctx->rxq->dev;
+
+       inum = dev->nd_net.net->ns.inum;
+       memcpy(name, dev->name, IFNAMSIZ);
+       ingress_ifindex = dev->ifindex;
+       return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";

> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   include/uapi/linux/bpf.h       |  1 +
>   net/core/filter.c              | 19 +++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  1 +
>   3 files changed, 21 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 94659f6b3395..50403eb3b6cf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6123,6 +6123,7 @@ struct xdp_md {
>   	__u32 rx_queue_index;  /* rxq->queue_index  */
>   
>   	__u32 egress_ifindex;  /* txq->dev->ifindex */
> +	__bpf_md_ptr(struct net_device *, rx_dev); /* rxq->dev */
>   };
>   
>   /* DEVMAP map-value layout
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e7a8e4..d445ffbea8f1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8686,6 +8686,8 @@ static bool __is_valid_xdp_access(int off, int size)
>   	return true;
>   }
>   
> +BTF_ID_LIST_SINGLE(btf_xdp_get_netdev_id, struct, net_device)
> +
>   static bool xdp_is_valid_access(int off, int size,
>   				enum bpf_access_type type,
>   				const struct bpf_prog *prog,
> @@ -8718,6 +8720,15 @@ static bool xdp_is_valid_access(int off, int size,
>   	case offsetof(struct xdp_md, data_end):
>   		info->reg_type = PTR_TO_PACKET_END;
>   		break;
> +	case offsetof(struct xdp_md, rx_dev):
> +		info->reg_type = PTR_TO_BTF_ID;
> +		info->btf_id = btf_xdp_get_netdev_id[0];
> +		info->btf = bpf_get_btf_vmlinux();
> +	        if (IS_ERR_OR_NULL(info->btf))
> +			return false;
> +		if (size != sizeof(u64))
> +			return false;
> +		return true;
>   	}
>   
>   	return __is_valid_xdp_access(off, size);
> @@ -9808,6 +9819,14 @@ static u32 xdp_convert_ctx_access(enum bpf_access_type type,
>   		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
>   				      offsetof(struct net_device, ifindex));
>   		break;
> +	case offsetof(struct xdp_md, rx_dev):
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_buff, rxq),
> +				      si->dst_reg, si->src_reg,
> +				      offsetof(struct xdp_buff, rxq));
> +		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct xdp_rxq_info, dev),
> +				      si->dst_reg, si->dst_reg,
> +				      offsetof(struct xdp_rxq_info, dev));
> +		break;
>   	}
>   
>   	return insn - insn_buf;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 94659f6b3395..50403eb3b6cf 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -6123,6 +6123,7 @@ struct xdp_md {
>   	__u32 rx_queue_index;  /* rxq->queue_index  */
>   
>   	__u32 egress_ifindex;  /* txq->dev->ifindex */
> +	__bpf_md_ptr(struct net_device *, rx_dev); /* rxq->dev */
>   };
>   
>   /* DEVMAP map-value layout
