Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60E253D61E
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 10:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiFDI1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 04:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiFDI1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 04:27:31 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011453137E;
        Sat,  4 Jun 2022 01:27:29 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2543PvdZ013853;
        Sat, 4 Jun 2022 01:27:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=pPlX/qwi8r3rHkJgwS+wEDe6KIOC1JZgp7tRd7fryIM=;
 b=kCLdZJP9oyrUDM7YqXt5iDOftQaxq2LlJULd8CBtIJm3X4kgxKbCDtTwGar6QgW9IWUD
 iZCpqHTJY0RgEiqJn8sP77++IVy1CQlaV0Ui44woTxWOlvh4Pr2rsY0YMu+cQMzr1Cz7
 Qz/PJ+k0Agt1guzYo+QHUSQTFaHcA6yeKgg= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gfyek0pxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Jun 2022 01:27:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmKG4QV8BxCURKN9WkNEZkqpwtDhuvkiU8ke1vdU9YkB7M2PVrqwy36+rKPr+EGk348WZ2YZMjLy4RslMFpI38UW4Hvw4J6RomhgMSC07ammkfc4Xr6s0GuUZUz3PTTnGkqi7zb/nEczHSqiY0zXmXQCIJ2K1pqBJyuj1w07uzwBZee0clP7xv95+Z4KLGsBQoTk3KU5E+eHqgGwmd3sSLLd3d74dWie7xxAl3BWgPX0e9Qh3hQU76tpV87npatAc1WGuPtXa9WVuD2ha2Mo/7AdFis9nSVewIs1I+iTZ3k79iv5k/yA88cDS9JhlVz656PoSrm7toYL3nMeXlHwxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPlX/qwi8r3rHkJgwS+wEDe6KIOC1JZgp7tRd7fryIM=;
 b=iDPEgqsBJDZOeC9nLmGI9SOwArCWhUpxEyeJ5LpNoE2zd4Dhho2vBXcDDDfJ9c/Lne+J992iGS/6eGpKCLX5EqGmBFgnNw6vN04RZKYVsL6S96XB4+kkGBAzafWf47BcDeeQflStzd8Jm0oEF4LbdX0ukXMMC4R16D6EfcXJCNXbWPr6Yztfqm1RpjuXYw4B6vNsw+uxPLEf3j/EwzpyhrVUZMLTUoV59vK3shp4RO+Wxpora16SEjz/Z1H4T1Lzxzg8cCZfcNckEWomYx/WDiluf/fkXKR03RiGCdCt1kcVJfBvCXLaROEvMJzmwrWULxe9N8NRTADAZMoY5+uGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB2410.namprd15.prod.outlook.com (2603:10b6:5:85::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Sat, 4 Jun
 2022 08:27:09 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 08:27:09 +0000
Date:   Sat, 4 Jun 2022 01:27:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
Message-ID: <20220604082706.s3r42iwgi7ftiud7@kafai-mbp>
References: <20220601190218.2494963-1-sdf@google.com>
 <20220601190218.2494963-4-sdf@google.com>
 <20220604061154.kefsehmyrnwgxstk@kafai-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220604061154.kefsehmyrnwgxstk@kafai-mbp>
X-ClientProxiedBy: MW4PR03CA0303.namprd03.prod.outlook.com
 (2603:10b6:303:dd::8) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d29eda0-2564-4816-78c0-08da4604045b
X-MS-TrafficTypeDiagnostic: DM6PR15MB2410:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB2410ADF4D8474606008C4604D5A09@DM6PR15MB2410.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OEM7/8oNp+tmNzUn2kXV/UJY2P6/kOZtEdD7rfcXumC4+BEx6HM47ij4mT0tOzlta2AO/cJ9hPPXk7vk93zK07bUwevUB6rjCco4zABUdnhOOzAXvOAIa+rFpu4Mvv9QR6qZgBNTUabhwwm6hbeC/bL6FD7rvI+HWi0tGHZUIr+sPEw2Ia3bW2SstU13KznA54wP7mW1KlIF0+2CzkhDPynwI8jALlOJQUBefFDHr/LlSm28T7Xx+1SECnICTbCEq3nrP7NMT+VFuuAStBUPOTdrUfuZI1IBml/hxuw93YZYfWxSsClRPIHO0pHnW2Z6y5yXcBf7GZN+nJGuacfJMVAAuDc3aMqlP2i8N3xmkxn4ofXcprjaW/FhdfgqhnM6gPGTiWV4/qMShQp2FIcqRn1ZO+xiJcaiBxiHaTxPqJOleeo6OKN8Av3/MwO3bvhA5UgYjcZCW9cRzf3LZIzmcx6uMaV6lhHTAYgYDZWXpqraN4Qwa91Xk80ptUDzaaIyW2k0mA10g1u8eYu0tTx1uH5RTatoUEv4aGqwdWPKWi5kF64tprz+7L6GZoxmpd9X/SKhoinrfO4A/5yyU0gkTXEmev2c9GKs1OFfL1gWaaqe5H8G0B8dmxNtjWObOuKyk5giZWFTzMlsZpcFb7n8DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8936002)(316002)(1076003)(66946007)(6916009)(38100700002)(66556008)(4326008)(8676002)(66476007)(5660300002)(6512007)(52116002)(9686003)(6666004)(86362001)(6506007)(83380400001)(33716001)(186003)(6486002)(2906002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2w+Tzk9FWcwJf+lZuOlbN3kiUwY6v6kh8Dcelixn8sKnfsecNdbbtM4FU2zS?=
 =?us-ascii?Q?AEJA2HvV9AGI0HRMCAlPqqHZgSIRt9gX4m2jA2pwPj5ui5FtalTnWI64E+EH?=
 =?us-ascii?Q?xbvBPFC/jhVHppZCP29/i0oRJpMrlJa4kuV95VjxtTeOW9NiQips4bQzHPSn?=
 =?us-ascii?Q?h4jbuCy08CwJ/MTblJhbhOoP9bFcdebyH+oBLF/zuwdpIAek6kRSMjLKamLw?=
 =?us-ascii?Q?GxfuWvy04YCivr6nWVxWOyIHaqSywQYoC+glR8jxEuNW7ty5cla7GbbkIqn0?=
 =?us-ascii?Q?45F8YWpnKvc0HB/++dsKtIHJSFq9UdDuZtVmnxJxWkZIKPfe7WtFdWkb9pNZ?=
 =?us-ascii?Q?M4kVM2H8Z9woacyXFOgpRhGxkkqwRcwrPm5ICMKBK0QjFRDrBEgKmXZ5x9mN?=
 =?us-ascii?Q?jAowEMtzjHXV/C58jbc53rjrzXapQSR1omAM3cpA2nTFDrFjN6WkKoCeP9km?=
 =?us-ascii?Q?hu9jCFYa94EAZJJBWmIOC5Pcg/eVOTkKJK8EWhxbGVPuqPvgzCDAaTmEpUgZ?=
 =?us-ascii?Q?/Mv6gDCMME06MYQG01p7iO1I6IhA9lhO72zwWJeaZuzfHWwH7M2rAydSqgNF?=
 =?us-ascii?Q?/HgpKVeEIB8azEnHs0tF6p9mwl4MX1M4XMJPk4SPGKoxFfG+5cACq0133JQB?=
 =?us-ascii?Q?ZFSKFXuvzKAqeswyyJdQZxzQXnG7UqG6pSPxgtxRqt5ivVNw34OILC1o67sU?=
 =?us-ascii?Q?FuhJkPi6Y+T3SSZ0mX6Q7yVIoCqKj9Rx9f0VYccFD1AzwG7M87Ih5+eaug5B?=
 =?us-ascii?Q?j0g/w52JfWrVgJpFVKhkwJ+LGWwYY/AKAgoe9DAPFM1yzqc6k0YuSBUFKU1J?=
 =?us-ascii?Q?TS24nMM/m9xHBwhqY9IJuSIhyAD4gWVlw3morlEUmn/qm1fqkKZ84G/wK0Nu?=
 =?us-ascii?Q?2PjT2lNNuJiY61jMJmIlnuYhu04uf5UT7SRZoIe51LOjHLxec6yt3o+Ii3Py?=
 =?us-ascii?Q?fEchPRo9PoCs75GAl7JgVKxlwtGs8xuRcSPK2TLhf7VmEeB9zDvORahd0TIh?=
 =?us-ascii?Q?/I7yBGKWgovfYXsD+Y+1X5Tg2oGs6ZWdC00NijplD5JBA1o69h6TgrOyWOGZ?=
 =?us-ascii?Q?1LBI4iLdYieMz/trohshH40t+3QgtT+jWumRqlea9532Xy2meJr7TNPngC49?=
 =?us-ascii?Q?/Qz1fWgQCc+JKDngfMs95B3UgvoeUi+pMhl22+sj0lMd8KRs3OIsumQj9brm?=
 =?us-ascii?Q?g49oTK6YaHOth4H7TCjCUGIxMhplBlmiRSAIpdMn0KPIUAauMZuMEesRiqJk?=
 =?us-ascii?Q?FZDHZgbB8PVNdjckAKjSFglQEI1wQRllM4npx3ENDfvtHHmqTbl6ovCoU0+2?=
 =?us-ascii?Q?6Gcd5B/NMFIiYD28uOG2R6Z1DhRMyDh6iiPxAcR1lopjLxw//WusrW6R5te3?=
 =?us-ascii?Q?TKj1V1rajpIfp3Q3m7WiMS0t0lxljOf8+sxR/qlTTUkERzunoLE13RzpLWIF?=
 =?us-ascii?Q?VF1c9g5NzH54wyzb7AQwiL5IOHE2OFjjDR49pnqIqXBQ83N0DYejjL5YY4KT?=
 =?us-ascii?Q?BogIrW/9yOdx/RQTKOXzXezdjiCfKfbzZrB8uiE0S/JcGjMXe6W4DrUxRBdB?=
 =?us-ascii?Q?QhjyHhOLLGqW4CFexB66TXI0HKddkUHli+kDDNiFp62KSdssZ8UWjHwHyzAs?=
 =?us-ascii?Q?bUfa/x4bUeRIuwgQLaF+XB1mF/J/AHjk/sxS1Wa+BwN9uQRljdMN6S3TOnH5?=
 =?us-ascii?Q?iRfZbYgSZyIu2hSJ1sGmVPXzebMnHG40AWhiFxSmugTV4+FweqxVRZWOnd50?=
 =?us-ascii?Q?2B6LXO8xXGf24UzO4AY/CDnjTO4uloI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d29eda0-2564-4816-78c0-08da4604045b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 08:27:09.5294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkfZykE2mRlL8GF+lsu6Y/ok1nd6zg7cNdsRAMSMNtakI3GvCGL1+xAi8VHERhzN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2410
X-Proofpoint-GUID: v6ewbbbImetddaFG3ihThYbTfGfWI4XZ
X-Proofpoint-ORIG-GUID: v6ewbbbImetddaFG3ihThYbTfGfWI4XZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-04_01,2022-06-03_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 03, 2022 at 11:11:58PM -0700, Martin KaFai Lau wrote:
> > @@ -549,9 +655,15 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >  	bpf_cgroup_storages_assign(pl->storage, storage);
> >  	cgrp->bpf.flags[atype] = saved_flags;
> >  
> > +	if (type == BPF_LSM_CGROUP && !old_prog) {
> hmm... I think this "!old_prog" test should not be here.
> 
> In allow_multi, old_prog can be NULL but it still needs
> to bump the shim_link's refcnt by calling
> bpf_trampoline_link_cgroup_shim().
> 
> This is a bit tricky.  Does it make sense ?
I think I read the "!"old_prog upside-down.  I think I got the
intention here now after reading some latter patches.
It is to save a bpf_trampoline_link_cgroup_shim() and unlink
for the replace case ?  I would prefer not to do this.
It is quite confusing to read and does not save much.

> 
> > +		err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
> > +		if (err)
> > +			goto cleanup;
> > +	}
> > +
> >  	err = update_effective_progs(cgrp, atype);
> >  	if (err)
> > -		goto cleanup;
> > +		goto cleanup_trampoline;
> >  
> >  	if (old_prog)
> Then it needs a bpf_trampoline_unlink_cgroup_shim(old_prog) here.
> 
> >  		bpf_prog_put(old_prog);
> > @@ -560,6 +672,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >  	bpf_cgroup_storages_link(new_storage, cgrp, type);
> >  	return 0;
> >  
> > +cleanup_trampoline:
> > +	if (type == BPF_LSM_CGROUP && !old_prog)
> The "!old_prog" test should also be removed.
> 
> > +		bpf_trampoline_unlink_cgroup_shim(new_prog);
> > +
> >  cleanup:
> >  	if (old_prog) {
> >  		pl->prog = old_prog;
