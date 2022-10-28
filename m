Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5646C611110
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiJ1MUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJ1MUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:20:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861AB2980D;
        Fri, 28 Oct 2022 05:19:56 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SBNwoi019014;
        Fri, 28 Oct 2022 12:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2022-7-12; bh=y8kuDvLLMwRb5c/gqskraZ4IPvhZhSqT7gDTORP/oMw=;
 b=cY4eXBncMTFwxtwfLa1qJsIYOvOTFUMBQ3Gd2TEHKO+XN3a7/g6vns5pfmMbEW9R5cvB
 1+FoHFWn39G2/4i//u8vCLfRrt+gyzYubwh47oA6nZ4qel+tQs6wwNGg3G7Bth0zED1i
 P6d3ShfguAjcsgdP+Yl5JR+bqJ+NZeEelcrBmirmCbh46x3EF/v9wiKMA3SiZNIl+INS
 yW1yaswQN6zeHPfozoikXizQwEVpcUPsYUhDcoYwGkUaaZjA+zElpXLAowAnRougw0Yh
 4ARbK1UjC9SVEQsrK0xWEFK5+1cJWll0jaP9ISqPWzRmr8MYKOe3Q4WypTTHUXdi7gh1 ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7vmff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 12:18:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SAhiGW009439;
        Fri, 28 Oct 2022 12:18:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagg0y4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 12:18:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AfxZcVXg6pwT4fc1A6JgilGarwvFWQ0GZ7wsf/EK/o0myvKanP10hHvl0hMWHIbYKtDOZkOp9ulGRHBq7EeMXl5WxGUCZkKFCyGgwvT9S7aypmhH//GlQJstP2RiVVh47ENO1mCrIg5LwOp9pfXstNE1XwqlmHYX3nTKAt6S4OwByb2sWlPeoZAEGcTEDh2m8KtccAZXWWQnYrRsbbFSX9FoBlSbZy+tGtxWXmzSsM8wjQ5Sxb0COLp0DZDa8/aW2Vgy2R70KHzA7XsYKzsGbwa05kBvxOB228WCa+EPFCVv8CgkxXM4UF8uItXvYZoo4E0MIROQCNjvHXR5r/+Gow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8kuDvLLMwRb5c/gqskraZ4IPvhZhSqT7gDTORP/oMw=;
 b=oabZFXkD6mngiw9gPoFfNj1tKlWQNxCPBbSP/GoOAl6DnXyKffdXYYCGQ2ChwsPb2LXrGXBtIuItGXnMzvEeFcsmpsKOZ5nse0PnLelNe0pQy8S6gmvSeNj2uQYpqnYiGAB4lQkrXUMnQEpE+/wHOx6BhifhOn2zTGtkUF9jmk0wr+3f8R4WSdxohGogpksxeecUoMRThqryhMLsU+zlPC3WBeu1JDpaBLdPE6PLMiA+5a5jUyT8zx4UkpIb+0KjUhnl0vqE0u5WfvKR+Pl+uvw65oUMlJqbd6Wx9+e0TsAhxLSFmDVIqNokGLoTKPXmxYb9udYDwIXh2W9pmSCAnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8kuDvLLMwRb5c/gqskraZ4IPvhZhSqT7gDTORP/oMw=;
 b=f36ytNRDysfdyINPqoNscbsAMFjvIvfU0+rbV3x0QWcgqIoLdnDWufPYY+MmWOMQDLaPX2JjcG+ccFyj6P0oCqQhITD3aMVaKyzAaMFiC80F1KOog5rLdXzxwyEzykuwldnlLHaf2IteNjXAqwOSTS98JGQhNJCkr53YT88x2kI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5547.namprd10.prod.outlook.com
 (2603:10b6:510:da::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Fri, 28 Oct
 2022 12:18:08 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 12:18:08 +0000
Date:   Fri, 28 Oct 2022 15:17:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     oe-kbuild@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org,
        martin.lau@linux.dev, yhs@fb.com, joe@wand.net.nz
Subject: Re: [PATCH net] bpf: Fix memory leaks in __check_func_call
Message-ID: <202210280529.TNxdtFjQ-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666866213-4394-1-git-send-email-wangyufen@huawei.com>
X-ClientProxiedBy: JNAP275CA0064.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::20)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|PH0PR10MB5547:EE_
X-MS-Office365-Filtering-Correlation-Id: ffcf22ab-7025-4c18-7863-08dab8de7916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IX9FpBblFvYW/kqz8NSzBa54gY643nu2y1o7co3LZ2zbLkbM5krindUNarGq+a1CTqusyyXj7Q1P86ytQERKEKxRkCkgIyD7yTCHyI7zx3AH7KOAdw7XRM7TPjDC6IWrGnCxY8P6ik2xNW/+2CniSYGQWB486kSE/JnrON8Nr8NFE3jL5pmpB6KJUY3WogiUpG/u0Asma+JQ2tHmVbDEis0ZLGC/qBAVEGNsNfArEeNSLuUJQhyPoscBiyW3Vtmzn4iwf0qCaPWqfjvPfAJTPjyZboSTKa4QbaxoVguTq6dGDPv+DF70+DJx/BDV0Xn90BXs7T0ClIKMlac6Zr5etV8C2xx8uTl8WJO4iZqZ9N59C809QV2aG+2gQuar9Phc54kUfgEhNi9OGl8lVesFhlVUeAdcC+jq3/rtYU2ea4R/kDDrXjVzcOg/j0va0hayTGlWtPeLjveqJz6dnq3HGQsy0V5w4YNqxo+J5Lk/5VSz3n3TMgOoJkbf3FaPbvlmHuEDD3B0KWf/WjrWXp1+g6Ab1ZdHzcc8HbXksB75+cx3urcoP/yv61fE77CKpCTA7QPc//Pqs/EGjNIwjFjkf832Imbnrl37sceBImE8F3P5IpACZ355KFigYlU/xsMOnxy5pPOffETqC3QZgWzlNLzOiKJEtKkpcNVWjNb/4GqpDcGR3/17I0yr4hjNPbE0sbadOTAb/iWlYVp5AM69zjmfTvt0dKrDibkUFmGFBJEgwzdPbXRSB56CYzlcFqBcNvL6lt6vpsXxJ77NIWqFCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199015)(1076003)(8676002)(478600001)(316002)(2906002)(7416002)(186003)(41300700001)(83380400001)(8936002)(38100700002)(44832011)(26005)(4326008)(5660300002)(66476007)(966005)(4001150100001)(6512007)(9686003)(66556008)(6666004)(86362001)(6506007)(66946007)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+8dhtpCzJGq8vFKTa65J/VAykeySH+1Y4SFPK9kRdqFwIGzFxydFpR5+m4ND?=
 =?us-ascii?Q?MJ83IXAHtBwqqlgtltaQ4bYqdcuY2jWTV5dhOVq48ftmcwpw6wowmNwsX+z7?=
 =?us-ascii?Q?3cI/nYjJ3fcjY7y5Xi6iknkIIlnMFZM/EzOVzmY/bGizppB3cH1e1h8imMr3?=
 =?us-ascii?Q?GJAZjv4inpizEldXMsU2m4EnvtX+V9IdS5oRdKjVsUfgDjyNkmJQ5lnDMKyP?=
 =?us-ascii?Q?3JDdkNSKn3HV8cKaIhTruqmxUooxXsvBgEJ+r2neNHboOUgFZ97EX9+CIuKp?=
 =?us-ascii?Q?9mbDPOgesbWvNJHXRhzWJLpGZQJb27GGlWFBM4dCgeYz5Z/0qha4UOEpKbgr?=
 =?us-ascii?Q?FF1vq6X9KC7DpmPzb7nwyW9l73osZXaBhxzXeepecr+cxPkariLxGh/RvAmN?=
 =?us-ascii?Q?sfdjH1irVnikO6jjDAySPvnq8KEgdWXHrd3kOFAem5VHfgLv/lSYBx+Da57B?=
 =?us-ascii?Q?lD0hQKrWLUOPgDrMz9P6F7dyXvTJ0tNz3pkrV4JzSuKjMzbLgrpKfhbTNWaR?=
 =?us-ascii?Q?324XGGUZ/vK6jN/1B/buoCW/Wo2aw5lwcxYw73XROFqhUbeK3Q/Z280eoGOn?=
 =?us-ascii?Q?8ljw1SM5CMEaAmrbYhj7JCCZZ+/z/tElmdYXKmEomONt7Jh6YpW1iRIchHqk?=
 =?us-ascii?Q?BTtxVJBrZeWMG+zIe6mJrWnEnz+ykx5b18R8A+9ENbIpzJyYj8ug7mBb8Ve8?=
 =?us-ascii?Q?l25yMniwyLMddeGsZDX5SuR/Wby7qB5mgW3wQ4D+1GfbClIjogAxB8PcFOWX?=
 =?us-ascii?Q?qLwrCELrVsATqm6uPrpjr/Dh7a04NJyLWHGBI86GyC5GJSD2JWHkLbbWdQU0?=
 =?us-ascii?Q?zhkKyPryPO4ucFXdxDJeGRlADMl2Hj8foPhVskn9MdHAebrZv0s3Xhh5CCNJ?=
 =?us-ascii?Q?tcg4/2EHqi8vrZ6xGHBF/icHO59ARrr+TZVdcCngiNMGJ/80KioArFY50zEi?=
 =?us-ascii?Q?Yk60Gq9jd/TIGn2d1SJsrHf3ZYi42UqX677NeDrDQ2jXz+svgj9MVf/5xXrY?=
 =?us-ascii?Q?SkLssTIlCPQSPewpOgV97JKylxQCuAaSONp8Ct5QAFvFJy+LhVKgnd4YH59i?=
 =?us-ascii?Q?Zb5qSaAuaRROKXziRw3Yvz/33KRwA+yqErltPevN71ruH4feFlL2LZkuvKTj?=
 =?us-ascii?Q?YqFOf4/FYdNHbO2Vq0VtuFgUJesY3PL/mWnFsc3KXiazHabpzIOkuV23somQ?=
 =?us-ascii?Q?qn5dW8jnTUR/wvTmveutIux9O1Khjs3BVoGcEGGze0nnmD/XXe+vp6+iZAgj?=
 =?us-ascii?Q?VS/B2AruTD8J6rcNSMwgxBy/XTtk5RfgnV7B6j4NIVtxQvZPkMlomVTPJ0oL?=
 =?us-ascii?Q?NvMjNHDsZ26r307SSs+VFhLHCZGPbiQhVZzQNQ8yb14RAWM40Wcn2UGVscQW?=
 =?us-ascii?Q?y5gL4ZmiOGsWS6KVEWCCUpmBTLxv5sFA5vab9El6/CZmqFbxR7RxDouFooSt?=
 =?us-ascii?Q?vSYJgXR9D7wxhynROv+qHLi49Y4t95nyJELudYosgXglCa7+kLON/nv1c06k?=
 =?us-ascii?Q?5ucC/ssdjPhS8bNX3luQlNNUba7In3BA2gjPP4UPUSpJlr6Vn24A7XIR/XTQ?=
 =?us-ascii?Q?pwFHRWbzpbNMD22T8H/pwlKl86NDlJ0o45LVHWzT2VoNLSd8nN1VwoG91DgR?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffcf22ab-7025-4c18-7863-08dab8de7916
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 12:18:08.7143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Sq+uJdi1HZUQn6YLiiRIns9Zv62Fkw1dOzeEj6SKdkQmaI1SlfdAwNyVk90IHHMjfs/reVYkDja+FY+w7c18SK+2bTBAYl72ZQOIA1uvmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5547
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_06,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280076
X-Proofpoint-GUID: vM1uiSlU1okJvVyFyf1aQZrCmgWBCSFC
X-Proofpoint-ORIG-GUID: vM1uiSlU1okJvVyFyf1aQZrCmgWBCSFC
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

url:    https://github.com/intel-lab-lkp/linux/commits/Wang-Yufen/bpf-Fix-memory-leaks-in-__check_func_call/20221027-180438
patch link:    https://lore.kernel.org/r/1666866213-4394-1-git-send-email-wangyufen%40huawei.com
patch subject: [PATCH net] bpf: Fix memory leaks in __check_func_call
config: openrisc-randconfig-m031-20221026
compiler: or1k-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
kernel/bpf/verifier.c:7021 prepare_func_exit() error: uninitialized symbol 'ret'.

vim +/ret +7021 kernel/bpf/verifier.c

f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6957  static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6958  {
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6959  	struct bpf_verifier_state *state = env->cur_state;
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6960  	struct bpf_func_state *caller, *callee;
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6961  	struct bpf_reg_state *r0;
7e03dd8c129a0d Wang Yufen              2022-10-27  6962  	int ret;
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6963  
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6964  	callee = state->frame[state->curframe];
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6965  	r0 = &callee->regs[BPF_REG_0];
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6966  	if (r0->type == PTR_TO_STACK) {
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6967  		/* technically it's ok to return caller's stack pointer
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6968  		 * (or caller's caller's pointer) back to the caller,
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6969  		 * since these pointers are valid. Only current stack
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6970  		 * pointer will be invalid as soon as function exits,
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6971  		 * but let's be conservative
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6972  		 */
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6973  		verbose(env, "cannot return stack pointer to the caller\n");
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6974  		return -EINVAL;
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6975  	}
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6976  
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6977  	state->curframe--;
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6978  	caller = state->frame[state->curframe];
69c087ba6225b5 Yonghong Song           2021-02-26  6979  	if (callee->in_callback_fn) {
69c087ba6225b5 Yonghong Song           2021-02-26  6980  		/* enforce R0 return value range [0, 1]. */
1bfe26fb082724 Dave Marchevsky         2022-09-08  6981  		struct tnum range = callee->callback_ret_range;
69c087ba6225b5 Yonghong Song           2021-02-26  6982  
69c087ba6225b5 Yonghong Song           2021-02-26  6983  		if (r0->type != SCALAR_VALUE) {
69c087ba6225b5 Yonghong Song           2021-02-26  6984  			verbose(env, "R0 not a scalar value\n");
7e03dd8c129a0d Wang Yufen              2022-10-27  6985  			ret = -EACCES;
7e03dd8c129a0d Wang Yufen              2022-10-27  6986  			goto out;
69c087ba6225b5 Yonghong Song           2021-02-26  6987  		}
69c087ba6225b5 Yonghong Song           2021-02-26  6988  		if (!tnum_in(range, r0->var_off)) {
69c087ba6225b5 Yonghong Song           2021-02-26  6989  			verbose_invalid_scalar(env, r0, &range, "callback return", "R0");
7e03dd8c129a0d Wang Yufen              2022-10-27  6990  			ret = -EINVAL;
7e03dd8c129a0d Wang Yufen              2022-10-27  6991  			goto out;
69c087ba6225b5 Yonghong Song           2021-02-26  6992  		}
69c087ba6225b5 Yonghong Song           2021-02-26  6993  	} else {
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6994  		/* return to the caller whatever r0 had in the callee */
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6995  		caller->regs[BPF_REG_0] = *r0;
69c087ba6225b5 Yonghong Song           2021-02-26  6996  	}
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  6997  
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  6998  	/* callback_fn frame should have released its own additions to parent's
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  6999  	 * reference state at this point, or check_reference_leak would
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  7000  	 * complain, hence it must be the same as the caller. There is no need
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  7001  	 * to copy it back.
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  7002  	 */
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  7003  	if (!callee->in_callback_fn) {
fd978bf7fd3125 Joe Stringer            2018-10-02  7004  		/* Transfer references to the caller */
7e03dd8c129a0d Wang Yufen              2022-10-27  7005  		ret = copy_reference_state(caller, callee);
7e03dd8c129a0d Wang Yufen              2022-10-27  7006  		if (ret)
7e03dd8c129a0d Wang Yufen              2022-10-27  7007  			goto out;
9d9d00ac29d0ef Kumar Kartikeya Dwivedi 2022-08-23  7008  	}

Not initialized on else path.

fd978bf7fd3125 Joe Stringer            2018-10-02  7009  
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7010  	*insn_idx = callee->callsite + 1;
06ee7115b0d174 Alexei Starovoitov      2019-04-01  7011  	if (env->log.level & BPF_LOG_LEVEL) {
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7012  		verbose(env, "returning from callee:\n");
0f55f9ed21f966 Christy Lee             2021-12-16  7013  		print_verifier_state(env, callee, true);
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7014  		verbose(env, "to caller at %d:\n", *insn_idx);
0f55f9ed21f966 Christy Lee             2021-12-16  7015  		print_verifier_state(env, caller, true);
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7016  	}
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7017  	/* clear everything in the callee */
7e03dd8c129a0d Wang Yufen              2022-10-27  7018  out:
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7019  	free_func_state(callee);
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7020  	state->frame[state->curframe + 1] = NULL;
7e03dd8c129a0d Wang Yufen              2022-10-27 @7021  	return ret;
f4d7e40a5b7157 Alexei Starovoitov      2017-12-14  7022  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
