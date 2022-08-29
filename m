Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65BD5A4EA9
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiH2N5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiH2N5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:57:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06837F0B0;
        Mon, 29 Aug 2022 06:57:30 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TClKYj020453;
        Mon, 29 Aug 2022 13:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Z39XGWxrVMnIIdmv9B+3ktyklH0w0l3gqW0VT6bQfxA=;
 b=ONJKv6pJJ/DwseHTwTBxBzciXFO6wFMH/B3I5oZFXLyklA4lX1xgNCn1EcSnjR43eCAC
 GOCgQQkUPsnguPWhag4f8jjKwx2K5JsTicGoXJHiJ8cA/JPpr6XH7lmO1FwYSDsp6dEQ
 oSLGPOJ4KajlvoFSHzjawrDVLE04dbDpXEt44xjQ5NTBL/ixfI7Ta4m8ezrqnfMQ2c95
 Uf5bWKJnkuecH+y7S8zb8CPtuHKrvaQ/h4Zccg991I79vI+apoJjCSXmRuqzQ0ZG7m/7
 M8QZCz4U5tAsdtcb/bZhzBG3UW878MOiOdrdsl3qdU7VOcbc5VFv/RC+OLab+N3/SoyC mQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a223gd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 13:57:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TAwfBi033494;
        Mon, 29 Aug 2022 13:57:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2csw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 13:57:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVXeO8dyUfC74TwnhFJ1RyFMVEkD3CeMzN+63J6Ry/MQLBLlN1FXHZfk136s/4qo/TdufzTp42kRL0eC1rxhA0P5nh64OHROBvgJwvOeZP544nO3nJbTCcx0mIqlDl92ouIjJ+CIz4qFBLNRELZ2rCgbxVui86TQxo+jxSj2I87ofKOZ1ipN8Sl5/eVIslv4YEg3OQXFX7SZrUyne8IRUGD1J8ZIDIpfB0JEB1lxVb9yl0V5wY4e8ZHTRhYIca/gdHVophkKftH5IcyyzRa2w3eG0IQASxwIYh7wNDwTA6N1xczzF+STQgYrCzuu5j1590+sH8gFZVABBrNJc/idgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z39XGWxrVMnIIdmv9B+3ktyklH0w0l3gqW0VT6bQfxA=;
 b=IibY1LJ5imJZQiLPNVpBLoTgVcY6SckQXiSPR09vyHChF6owU006KvkZIolconzdbAgyIAeD9DrvqjlQDONolbCU4FJzxlb8rAl0VpAgqyv0csR7ePXXsVQBbv8a3eqnKFoTDGNlQZuVfyDoeM3qNPsuANk2IXsmwrxuV0UeuS9KBhPtRM4LdtAVHGj9pHJvZGtYIavjVbAJDmLgTpW71F2A+rh+66QzBGqZ4IUR71GhAFu5XhOpK35BhQFoOWYCNbs25WQmHhK71BTyigTx6fjWBFSfQyAkZf+WaXAnDNhTse+XOMlCO6GB6g2gmx6H5EcgmloW0BlFZFuuNOn+Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z39XGWxrVMnIIdmv9B+3ktyklH0w0l3gqW0VT6bQfxA=;
 b=cGvpR07hdBcLnW7TeYX1RJr+XNhWz9tlrda1xJLwuL4V+ovgJ3FZdQOcfMVrkeCOUdvhHfefm6ks80zU6LhEPPfEjGNxlcSnd9D7ndoPHQDVoy3/30FEggyLQVZhfxoXvn7DM2W1xU4Ied5tCZIC6/A92yYwUyDMzfdZS9ErkP4=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MN2PR10MB3933.namprd10.prod.outlook.com (2603:10b6:208:1bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.16; Mon, 29 Aug
 2022 13:57:18 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::d0c6:fa96:addf:6112]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::d0c6:fa96:addf:6112%9]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 13:57:18 +0000
Message-ID: <93eca5ab-46ee-241a-b01c-a6131b28ba29@oracle.com>
Date:   Mon, 29 Aug 2022 08:57:11 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH nf] netfilter: ebtables: reject blobs that don't provide
 all entry points
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     syzkaller@googlegroups.com, george.kennedy@oracle.com,
        vegard.nossum@oracle.com, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
 <20220820173555.131326-1-fw@strlen.de>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20220820173555.131326-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:208:23e::15) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ba71ce-c7fa-4584-adaf-08da89c662af
X-MS-TrafficTypeDiagnostic: MN2PR10MB3933:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbuAdRdq4oFzDvNk/WNouZIMh1wiBGaVtk+FmIr++GiRsknwnRjVNVWtsqh+yW/4ZK7EDPOsogdfTeG+lYlDKDaalDGfRL3M8kwxFVAlZrUp4rMfAg/8m476P/ClBbnJ7c4ROco5Oj03SWtrEWQk5SlfdtoUNg+HRAuWoZ3V68nwxySGocWMQuYWg12uTfmgz1f89vq/WQENey/qJlFOqyRM05HDAbjsr9eCN1QAKMHatZ8+sXEpl+gaifFQF49gWhj2aTxoCWz3FZS1wbjEbWaxtVlvS11V4K3q4HR9dhZfjv5aUwy8Uolw+qBg9qOVpxtJUpd30+8jQNcfmpYH3n1i+Q0Qsobrl16qS3yl8JCgKFwJ6Mo1dK9d9+3bS5D5Xbv4Bx8vU63zdCncUonz//grVgzC1oMaccT0d3n+Dr/sRVr8Fw3iNNMbl7sPFbVoSoXhpb/BF8qS46qvPqBuJLHzUSjxnnvCPKFTxZ2PHOVwNgsIXC3s5qJIvwMXajav88sNVg8ytS0ZbXseOYSXS64y5TZz370xJMM7URmxxKFpvA1GsmZzYEciQrEYrz1kltFsQq6gmHOawQ4opxdOblIJUIOcd1D9CIfZHX0azPAQbJFRtUl+vmue94QADyDObLJUgeYKoXDcVx6NxHNZW0KTeJn8TJHCNf6yk3BNYVzFTYrc/tmT1/HEVJ1IVACUa9uQuoSN0T4bHqZNt/Cj05wcOgHIookg+ehf8+JDprzAlZm1xHm3T7+e8dihPKigfUqCnWKj4L3sHk7QHLe4qQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(136003)(346002)(376002)(366004)(31686004)(107886003)(2906002)(66946007)(4326008)(8676002)(66556008)(66476007)(53546011)(6512007)(6666004)(9686003)(6506007)(8936002)(316002)(26005)(478600001)(6486002)(41300700001)(86362001)(186003)(2616005)(83380400001)(5660300002)(36756003)(31696002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1VVRFBqMHdGYU82L3drcjhrd1MxZkZaUk5ZNXJVK3piVmV2ZnoyNE5VQVpj?=
 =?utf-8?B?azY4di9mSEFTZkw1UDBETXVFM0J4ZEhvMVh4QzVlZ3J6ZkpkZVpidjBKZU5R?=
 =?utf-8?B?blJHeUVzalN1bDNocnR3dzBRZ3pFOHVMRW1JdXFhKzRYTjJnQ2MvVnVDd1Fn?=
 =?utf-8?B?NWV5TzI4amNVTENMb0xDS2xpWitGQ3hhWFVRYVgvRmg5T2RodnpPNnZlWjVF?=
 =?utf-8?B?K2dFVTB5dG54c0ZpdEpFbllTc1JwRS9qQnZyZ0c0clRISkdoWVpoZHFvNStQ?=
 =?utf-8?B?OXl4RXBKaS90Um1lMlZDeGFKU3N1cmJDenEzRG9BNDdaeEdQV2pLZ0xyUy9T?=
 =?utf-8?B?czdrL0YrRlVuUUdkRjh0NDZrTHg3aUZscTFySDI5TDRnVEUvZFFnbk9MKzRM?=
 =?utf-8?B?WHBIbFc2NzNNKzJMM1hhZmc5WXoyM09NUVMwRU1CRkV6MmZWSExOV0FHUnVM?=
 =?utf-8?B?NTNnTEdKVzlRcWh2Q1c5Vkg3eUxyeUJXMmhGM0lJejFLQWtmN3JoaVRsV3kx?=
 =?utf-8?B?bk4xL0F4Q21Ya2ZobjQwUlRKV2tpcUlNZmU4MTYra3BUWHlobmZrZ2VjRWFq?=
 =?utf-8?B?UWtDWHp0R0JiVHJEK3F1ajI2N0tidlJUQWRTeXhRMk5QcEtxNnlFbmVaazlh?=
 =?utf-8?B?TTlwaWdHSENDMklMOGJ1ZFpKbnRaZmEwYnV2RGwrejBjNVU5cEY2cnNRMkd3?=
 =?utf-8?B?WkpPS1pSRVgxRzBYRXYvVWhLeHhzZjNkS3VmeWk0aXdvb3M5eFVwd1lOTGVt?=
 =?utf-8?B?Q2tSRGFZdjVtTXEzRDJDL0NRaUdwZzlsODJYOXJKcXBQa2pFb0VCcWpSMnh4?=
 =?utf-8?B?NkhrQjcydzkxSGM2WkVDUno3RGI4RGF6cmpBbko2YkxKeHNaY1YzQU1ZYjNw?=
 =?utf-8?B?SU8vMENxYzFJTGtMMVF6cmRqamNmU2Rpc2FNUlV2c1ZLU01hRkRUQVQ0RWNk?=
 =?utf-8?B?Z0dBUzlXRFcvWHVjcDhjbWFqZERrK0lDdFlXTEU0WFNBL2dqSWxuaTI0UmJD?=
 =?utf-8?B?Y2d2V3ltQm9RVWJmSzJHSVdZSGxXd24yeGFWd1RmVlVUb20xQS9iZnZyWEVO?=
 =?utf-8?B?aWhEV1lrbjh3SmJDcjBKdnRCYUZ4dTBTTXloY2RMbjI1U3NLbFkzNllqNy9M?=
 =?utf-8?B?WFZka1pqOEVwdXo1Y0hkZy9YbUQ0Yi9XN3cyaVpkc1RKYWxMZ2hYNTk2cGFX?=
 =?utf-8?B?WlQwMXBQZWZMdGpMd2xYK0JHR2hXNmtnRVN0UVF4NlE4a3ZJOVZ6YTUrNkd1?=
 =?utf-8?B?U0lQVlBqYzQ2YTBORkd0OG14T1lsTnlIWmkrODV3MW9tUlZUNjV1aWljcXp4?=
 =?utf-8?B?K201S0dCSlpvcTFNK3dlODRIQ2UwOGdvUHBrbnlYYUR5OFgyS1BBWER6dFRs?=
 =?utf-8?B?WjBKNmV5WWVJTW85OVgrSjdhN083YVFyZDNDMXNxUG5acWp0Y1lhTW1DTGFq?=
 =?utf-8?B?ZmdSeXlGd1YyNlV5T0pEa1M3aTFNZW13UWlVdzZoN0M2TUFGUXB5MloydDJB?=
 =?utf-8?B?NCtnc2Y5VnFyNmxGV1hpdTlNeHdYK0drM01yblpRdW9rRWM3OFd6eHZFc1Az?=
 =?utf-8?B?WHUzL3QvUGFoUnhWVElsSU1EWUt6NFBIWm9OakJNaTF1MEZCMTdTUE5lRHIr?=
 =?utf-8?B?NFk2cXJsTURxODBDVEZXSjlUekIyQkNQY0NVMUFsK0orc3pZcXp5UGJvR1ZS?=
 =?utf-8?B?azNyVTFsZjJCUnQ1d0tFckhHK2NpbWN3TFhVZlkzOHpGQ0FlbmgxOXUrcnBn?=
 =?utf-8?B?M2hxWnhJeUxlK3RkR2lLcEkzZit1Q3dZQW5DSi80OGFWQW1KSlgwdDU4WnZX?=
 =?utf-8?B?bk1qcWdyVkxHQW4xbzZ5Nit0dHpub0ZDMWdHRkRWMEE5YjhaZnl3WTBNVjg0?=
 =?utf-8?B?UW9OVEc0b1R4VHlScjgvK3laYVo4Q21QRDNMY3lwMXFHYmZQZWd5U2N5RS9U?=
 =?utf-8?B?NFYrQTlhU2NKWHRrUWxVN0hISXFvWVMrOTVDbUgzVGhsMzR1OG9zT3VxbnBM?=
 =?utf-8?B?NUF0WHFiYWNpdWdLcDBHR21pQnh6K1V1Z2FGZGtwRGFKTjg3Z0w4ZFNDeEND?=
 =?utf-8?B?dnNVTDNFMjdFaG9TTldCU2VuenloQTZuc2l6WUFIMWZDMFMzZFVJK1NlK1Mz?=
 =?utf-8?B?Q0JMSUdFL1I0OXN5eFVBZU4xdmJZeEtqS0NoVE5sbndFSC9iaFA1N2lIR2hi?=
 =?utf-8?B?WGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ba71ce-c7fa-4584-adaf-08da89c662af
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 13:57:18.1525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEDSjpvFEB8tf4/50fVTMFi6L7taeaCGI92qaf6/Z+wzRV9X20D3WDPaXhAxjU5r1mlGrVXtKYmyeJNst5wLpxTh5XbjK2KzcPIlSj+MEHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290064
X-Proofpoint-GUID: hAxZH9ZwAjPrR80uPkPdH-kzCZrJSI6a
X-Proofpoint-ORIG-GUID: hAxZH9ZwAjPrR80uPkPdH-kzCZrJSI6a
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/22 12:35 PM, Florian Westphal wrote:
> For some reason ebtables reject blobs that provide entry points that are
> not supported by the table.
> 
> What it should instead reject is the opposite, i.e. rulesets that
> DO NOT provide an entry point that is supported by the table.
> 
> t->valid_hooks is the bitmask of hooks (input, forward ...) that will
> see packets.  So, providing an entry point that is not support is
> harmless (never called/used), but the reverse is NOT, this will cause
> crash because the ebtables traverser doesn't expect a NULL blob for
> a location its receiving packets for.
> 
> Instead of fixing all the individual checks, do what iptables is doing and
> reject all blobs that doesn't provide the expected hooks.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Hi,

  Could you please add the panic stack mentioned above  and syzkaller 
reproducer ID to the commit text ?



> ---
>   Harshit, can you check if this also silences your reproducer?
> 
>   Thanks!
> 
>   include/linux/netfilter_bridge/ebtables.h | 4 ----
>   net/bridge/netfilter/ebtable_broute.c     | 8 --------
>   net/bridge/netfilter/ebtable_filter.c     | 8 --------
>   net/bridge/netfilter/ebtable_nat.c        | 8 --------
>   net/bridge/netfilter/ebtables.c           | 8 +-------
>   5 files changed, 1 insertion(+), 35 deletions(-)
> 
> diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
> index a13296d6c7ce..fd533552a062 100644
> --- a/include/linux/netfilter_bridge/ebtables.h
> +++ b/include/linux/netfilter_bridge/ebtables.h
> @@ -94,10 +94,6 @@ struct ebt_table {
>   	struct ebt_replace_kernel *table;
>   	unsigned int valid_hooks;
>   	rwlock_t lock;
> -	/* e.g. could be the table explicitly only allows certain
> -	 * matches, targets, ... 0 == let it in */
> -	int (*check)(const struct ebt_table_info *info,
> -	   unsigned int valid_hooks);
>   	/* the data used by the kernel */
>   	struct ebt_table_info *private;
>   	struct nf_hook_ops *ops;
> diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
> index 1a11064f9990..8f19253024b0 100644
> --- a/net/bridge/netfilter/ebtable_broute.c
> +++ b/net/bridge/netfilter/ebtable_broute.c
> @@ -36,18 +36,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)&initial_chain,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~(1 << NF_BR_BROUTING))
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table broute_table = {
>   	.name		= "broute",
>   	.table		= &initial_table,
>   	.valid_hooks	= 1 << NF_BR_BROUTING,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
> index cb949436bc0e..278f324e6752 100644
> --- a/net/bridge/netfilter/ebtable_filter.c
> +++ b/net/bridge/netfilter/ebtable_filter.c
> @@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)initial_chains,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~FILTER_VALID_HOOKS)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table frame_filter = {
>   	.name		= "filter",
>   	.table		= &initial_table,
>   	.valid_hooks	= FILTER_VALID_HOOKS,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
> index 5ee0531ae506..9066f7f376d5 100644
> --- a/net/bridge/netfilter/ebtable_nat.c
> +++ b/net/bridge/netfilter/ebtable_nat.c
> @@ -43,18 +43,10 @@ static struct ebt_replace_kernel initial_table = {
>   	.entries	= (char *)initial_chains,
>   };
>   
> -static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
> -{
> -	if (valid_hooks & ~NAT_VALID_HOOKS)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>   static const struct ebt_table frame_nat = {
>   	.name		= "nat",
>   	.table		= &initial_table,
>   	.valid_hooks	= NAT_VALID_HOOKS,
> -	.check		= check,
>   	.me		= THIS_MODULE,
>   };
>   
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index f2dbefb61ce8..9a0ae59cdc50 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1040,8 +1040,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>   		goto free_iterate;
>   	}
>   
> -	/* the table doesn't like it */
> -	if (t->check && (ret = t->check(newinfo, repl->valid_hooks)))
> +	if (repl->valid_hooks != t->valid_hooks)
>   		goto free_unlock;
>   
>   	if (repl->num_counters && repl->num_counters != t->private->nentries) {
> @@ -1231,11 +1230,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
>   	if (ret != 0)
>   		goto free_chainstack;
>   
> -	if (table->check && table->check(newinfo, table->valid_hooks)) {
> -		ret = -EINVAL;
> -		goto free_chainstack;
> -	}
> -
>   	table->private = newinfo;
>   	rwlock_init(&table->lock);
>   	mutex_lock(&ebt_mutex);

