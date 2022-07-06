Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2B7569522
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbiGFWPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiGFWPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:15:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690D62AC73;
        Wed,  6 Jul 2022 15:15:51 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 266L6vpJ029040;
        Wed, 6 Jul 2022 15:15:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=nq673jiLCGKxqMKlPDssdruLVsV8nhHlX4TakCvLI6E=;
 b=ny1j86eAOd2mQqJ/CRFethNByWNXIWOrH1pwVTHPV2Q07P8g5I5TYRl9l6odyhWGB4Sf
 Qk19PyZr5bYtvrw7rgw9y0qso6tGaiirvyhh9wIGhdmyn1jGDgdaKs61JgpjoSIDVjpR
 q3ENuufo6zdcDab0nU+lGx7tOZaligQgx44= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h4ucm98cn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 15:15:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaPt4sRJlm7EMFFwQVqGShIMSovuY5K8k6KgeVY/sape5/HnohicKivh1v4c4xVl0FKN1mBFls1fq7Z1QPfn44Ng5yxdoD0D/iUbJrkFlEHu5qcwkF9GSAHr3MirJ7BCEOZI8i7eLh/vyDDUJ6ZoF+G1Dv4mgYYRQjekWYDKKy94k1aAa8iHf7rIGrCIoTLr3nqSJhojciFQZFsF8VUcF1DwrJuQbNHXaM+V3b+oWpbp5WccxDoMnuclo8ncmE4MSNFm/pi3ucnQo/ip4QydhrbEBT/u3fUFhNB5F3U1nv34LDx3zfTbrio4rEHdTr5jCbRmGn6abgZvAHgde6ZHAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nq673jiLCGKxqMKlPDssdruLVsV8nhHlX4TakCvLI6E=;
 b=kX3OhnKqL7FYnM6J8FkwLm8W38VVWdH6Rv658sCye0JKEfd0S16hgfrqZNaLPjdd5j9Y82MamqH2AIjkKtzDeftl3a0NVHc235rQf3sWaIsXsMIlFSgvsdLbzAVf9DtuKPVcbj/QOGXHUD3gO/7/0J9/nyApg4X6L6SpTubG3WPyM1AmNDYrtVSqjW/zd25V1CO0B2XklP8SftCVmKj7L240CSJ9jKEAmULihP6COvkPb1cLp5qxi4VEmVg5BJmHfkugTJynVAxdP7TlzNn8gGRsmGhwpYx1redpu+YSQaLDfCaWzdLATlee79L8Tbq3UfkzTwfPrYgzncImx25Uog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH2PR15MB3621.namprd15.prod.outlook.com (2603:10b6:610:11::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 22:15:47 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Wed, 6 Jul 2022
 22:15:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>
Subject: Re: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Topic: [PATCH v2 bpf-next 5/5] bpf: trampoline: support
 FTRACE_OPS_FL_SHARE_IPMODIFY
Thread-Index: AQHYdrj21zA3ifq/PEC7Yw0zyJbSw61x8o6AgAAhSYCAAADUgIAACcQA
Date:   Wed, 6 Jul 2022 22:15:47 +0000
Message-ID: <ECD336F1-A130-47BA-8FBB-E3573445380F@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
 <20220602193706.2607681-6-song@kernel.org>
 <20220706153843.37584b5b@gandalf.local.home>
 <DC04E081-8320-4A39-A058-D0E33F202625@fb.com>
 <20220706174049.6c60250f@gandalf.local.home>
In-Reply-To: <20220706174049.6c60250f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22d7418e-111f-4571-9d48-08da5f9d13ad
x-ms-traffictypediagnostic: CH2PR15MB3621:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uRawHwnzmSphBWBLP1fxk7g1NAT+1V2rbw/1E0BmvayGyPvjCSzxvxqJOF1wNZBz3guEEUC6Ki6W3vgrSnvvz5wc+VEWO+8x+81uaSlLZgT1gru9PjL/rZhYMcsLiGedmUjmDKcdmVdR3z+PdRQCBLW7zrPVd7UOZFJYU4bA2X+OSz2WrwrKM3r67il1n/9Ylv5FRJeMcwWk9NNKMidkyfrF8guqGYeiTti+3zBUS0TO5dtUdhv2Cqb1au5E53j7WHMuVOecGoVsVgdeK6lngwOl2BPfyW3t2yoHqJwarfncDIFvR52ewklrpSwPPnHbXUOocBQTI6odbUbI8cJ+pTiufEN1c9oGo37lYRDL18VlMHFmvhU0dctDzO3BbY3FoXhsLRS9TseLdvOcwcqOz2abQ56krKoiR2yC2G75OcZ36R4rzKonQ/98Ooq23jlgwwVQF1qfhgm86hY0xukHYOYxsrSWs7iGucKAWN2hkPyt6Kt/8h1zev8KBHsiaXjo9Tv1ueUPhjdX0e7gs93tGKNbfSzVJzV3TJ6z5y9qWHCRIFxHd76ViaMXEbHav8FH3AFpdPs0KVTg44CI86tBK3PezEIbTis6p3ge7vAsjV0Q8doD6F42pF2Env8v3h8ptOnP78IzD8tlErg+RNzNY3oy1+yqqzwBiRUs84PABQz0O8NgtNwntgdwZZZPVhFpJIly6gbtw8eLtuYLpLew2BcnpHoDV7sVVXhX93hGswrcG+7ea5Zgi6S+vxOnDsdFxBmkT+bBY6ZFEFo2zOA4eYfMsEfa3UKjZgoTueWzIIoe+sOnUJllSG2hf0Q6sbPeuWa0t109TQK0oZE9ed8q434OjhPjdEHjL/4+t/kwjOk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(71200400001)(36756003)(8936002)(2616005)(5660300002)(86362001)(478600001)(186003)(54906003)(6916009)(2906002)(6512007)(7416002)(122000001)(6486002)(316002)(53546011)(8676002)(91956017)(66476007)(76116006)(66556008)(66946007)(41300700001)(64756008)(4326008)(38100700002)(33656002)(38070700005)(6506007)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EjUl/Y+7Ynifbs4fNNIX09Ov5xMvep6T5x4x7MrlnWhp5JJq1fdxkG7kgnwo?=
 =?us-ascii?Q?u9SurUlVLa7HgOqPup3ZHpfzdo8qhUS2M+GABbPdSjugRJBRN6DZMm5pYBaX?=
 =?us-ascii?Q?OhE4twmt65HsaVarEZkgUjMDl8ZIOF5Z/N34ZBTcibvXW7iOL7+nEw5ubMU+?=
 =?us-ascii?Q?1ib/N9FkwjAYRcqIdeDWHG3CaenDonH3TDefvbrXBEXcSbnRSixdpRIy8kaw?=
 =?us-ascii?Q?32waNLdyS/LXWvqOS2JItccxTqBLGpg8Fk26bBGHX+s+baA1PkkI/mq9TBBb?=
 =?us-ascii?Q?eKFa1ZIv2l0tytLQ/x7LIJe5f03fZCfPg7HzgQ25zY55t7561R1LJh1erBEq?=
 =?us-ascii?Q?R3fdCh8V42tW8jKs003sg9Fc44erPqPV5UHvzep3hj9qM08W7N6Xo2yhGia3?=
 =?us-ascii?Q?wuY4CQitSJN8SWBULxQtHM81GXenolg9BayODLUt6/WACowfODKO4FeZTOu0?=
 =?us-ascii?Q?EZN080XAASqIohIWdbUtK1ZjiezsuWLp8++OySrowfhOeR9rtYIO2BKSSS1x?=
 =?us-ascii?Q?dKNsH9Dy/hvlLvfFXy8he7b5fjKcbDmf0X8DS7/qM31XpTZZRW42/pMyEVsF?=
 =?us-ascii?Q?kvNnx2eXKK7Km8kZhFb5r+QYZH9o3noWSvE9S/qSAodsrrqLCdTGAxwN9cz9?=
 =?us-ascii?Q?mNb36KJoevQfZI+3ZST+OswtvtO/KEuFIJJsD2geWwQoyp90PB2OWcTGVFR9?=
 =?us-ascii?Q?/0tIpfOcVdCOpv4I4jqOMZZRxEDzkCyxfqYz4ySxvUWDtXXmVCdF+px2ZppT?=
 =?us-ascii?Q?N5GzoFjo3qLSD1CKGCEBe01BQ/QZTLjo1nc7UGcFkTBG5f1M8VC7pOZ/O3/p?=
 =?us-ascii?Q?V0j1Rc0WgIOhDijmrEkW5Fi1cxm60TZtySnDL38ciKzZDH2rDI4+hmzAwhVf?=
 =?us-ascii?Q?bsfO2JZkyLrR3ZWSKCG00ud6FR2zto+fKTXiQMwW6HSLC6AIIJFQxkHrHgfR?=
 =?us-ascii?Q?Gr4BfYKWa+jPLyj8KuHwvW4tmTjDv4OWms2bmceqnJTi8DLm0NK5iQppyJDn?=
 =?us-ascii?Q?MQJ80bSWS9T1Is3xGh6a1x8euW/+H0nIyRXXgP/JuFv2KlsumH3zrBtuMZLX?=
 =?us-ascii?Q?ZckeRgPutbK54kmrneM3GLPYA0DB763B592WivPoNZC8nDlY8yf3XN2NPDox?=
 =?us-ascii?Q?uAY2Y0svSJ17UJ3GpCEEEFHYg7ki3Wy2mtK6DjEmAVRMaMbyup2bsBAK75XT?=
 =?us-ascii?Q?lPSRlUg1RaPoa+1294jrtlJdCYXMrQiQ/juip5xkbXdbUqIR4V7SJnTg5kGL?=
 =?us-ascii?Q?f5KBh/Qh8q5DveIAjVOBG3On6+qxIVJso8K65/onslGoWiK+e+cBc/RkCw+t?=
 =?us-ascii?Q?VAkzz/srd+/9m9ef/B+2i8f76A7j97NykuRtolgsnkHZOUFNt4Ld1NyLlozO?=
 =?us-ascii?Q?nSjTpe9SEG3NlD0bNP15k7q1m0++kVNm37+NMFMon/aoMf9tT52pWMJHfTgW?=
 =?us-ascii?Q?Dms7XC7NRnzXBJlwZfjSzILq2Dc5+c20Iy8uKjWafTa04WOi+t1pZJwJzVLM?=
 =?us-ascii?Q?n9MvCFQRBpHwtUcZJ40SBuu8fhFWyrC+fzm1ay1jRtqOBx10PxtxJSOGcLfi?=
 =?us-ascii?Q?LUBNh2IBBYklEOwReErBr5ood6ZKM6ZPUMdPfrCZ1SoyaRUqFSBhSabu1de5?=
 =?us-ascii?Q?QE1QtkrW7XDQxuiiv/KFdgg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1137F313C5ACA6449731E12E63700FD9@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d7418e-111f-4571-9d48-08da5f9d13ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 22:15:47.0526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ynCvYGVqBvOj6r5BczO0/GU2vT1gI+IKVeSXnjo5hHghP+CR6mFCVzLT6hzCTnQdI04te/+PIrHxvE5T02N3qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3621
X-Proofpoint-GUID: tbwnVVbSelYWqiorSYooPnGYS6UskxAd
X-Proofpoint-ORIG-GUID: tbwnVVbSelYWqiorSYooPnGYS6UskxAd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_12,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 6, 2022, at 2:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> On Wed, 6 Jul 2022 21:37:52 +0000
> Song Liu <songliubraving@fb.com> wrote:
> 
>>> Can you comment here that returning -EAGAIN will not cause this to repeat.
>>> That it will change things where the next try will not return -EGAIN?  
>> 
>> Hmm.. this is not the guarantee here. This conflict is a real race condition 
>> that an IPMODIFY function (i.e. livepatch) is being registered at the same time 
>> when something else, for example bpftrace, is updating the BPF trampoline. 
>> 
>> This EAGAIN will propagate to the user of the IPMODIFY function (i.e. livepatch),
>> and we need to retry there. In the case of livepatch, the retry is initiated 
>> from user space. 
> 
> We need to be careful here then. If there's a userspace application that
> runs at real-time and does a:
> 
> 	do {
> 		errno = 0;
> 		regsiter_bpf();
> 	} while (errno != -EAGAIN);

Actually, do you mean:

	do {
		errno = 0;
		regsiter_bpf();
	} while (errno == -EAGAIN);

(== -EAGAIN) here?

In this specific race condition, register_bpf() will succeed, as it already
got tr->mutex. But the IPMODIFY (livepatch) side will fail and retry. 

Since both livepatch and bpf trampoline changes are rare operations, I think 
the chance of the race condition is low enough. 

Does this make sense?

Thanks,
Song


