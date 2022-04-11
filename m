Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897824FC784
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343657AbiDKWUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiDKWUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:20:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748DE20BE4;
        Mon, 11 Apr 2022 15:18:21 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23BI8fXa000466;
        Mon, 11 Apr 2022 15:18:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=kg2+NaEsYn22vWoPROUweUtJiQ9f8A38Paah1GOVPq8=;
 b=L3eOt7Ikyx2cgSQ/66dF9P0mPWjbed8h3c7sTE+RfBmvw936TwZaDnY+iO+NJbCLdnzg
 i3JTRuu5cgXGvaXEnyYFuhtGZp8Kjfv5Z/SrWqnES64BWSPLryv8YAGmxCUwYMQZi5Ct
 ReJhp+WRYkuY3HCxfEXu9cEOFsnUxHlb2BM= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fb5fr4uu6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 15:18:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOe7cXkq6H5kdSEhsuMmoFXCGSLynqkMz18qggHN2Qhi3PEFAaJwc2UC8nUya4Oo8DkaHtGR76j3/MCBi4p3Yuvs2THbaMHCOGaL99UfAA/jYOKq+0y1hIe/73c9s6j9pzLYpel4f6DrbqSlaKm1ORMjqFzk/qEDhQt9v+YpnxVDW27DEdVoTgHYlLLznG2A9fyEEVRAWtBcqXsPmSU9M1C6UM2V0bt4LyuYa2ZZLO9Xisf3yqn1Lyd1wuY2ykk2DYf1QAzRO7n2IZRAU+VWmxxHYtFYIaJ0NypdPk7ID9U9/cQ2iBwmawoKKSLG6gPhEjKMdSuyIiB/YgX/Y5MooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXPu5O/uCp2unfrXwLTcXZ/bY4HKSs6Z4ERhm68PqJs=;
 b=NABScA3ORKeGjFIgHPUuqs5eayvznireg1iJHs236pWf4F/iCIEPvizVY5HGn3wqWyID2cMq/R/5MhdyEHMO4Yt6hntUZzGq9Zpf634XIk8Xa3AFKF8w5X2EIaCtSqbsBYis+ogoeDH53h81U6MOUtwFnPMtlRSNAL1QENKaMyruyVFCtz85KYE/zuaM4CDlmkyvxCP5yB3aWfpKwyZSQbafeNvv67UYryA+1ZVSaVy03e9Ec2iTvqcKeMeU9tPocH8GMjdPgJR0bGDVGZMEtNobgu6sUHacY44B1APNU68mp8jF6viYEbzDwVTXeP3mhE1Jz84Ss5pl2E/kogWK5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MWHPR15MB1790.namprd15.prod.outlook.com (2603:10b6:301:53::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 22:18:18 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::20d2:26a2:6cb1:3c4b%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 22:18:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Song Liu <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH bpf 2/2] bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 2/2] bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for
 bpf_prog_pack
Thread-Index: AQHYS5mtQh1GNVF2tku0imT819YdPaznDoGAgAFQoYCAAexPAIABAW4A
Date:   Mon, 11 Apr 2022 22:18:17 +0000
Message-ID: <87C3A212-AC47-4AC2-9A85-FD11F61715C0@fb.com>
References: <20220408223443.3303509-1-song@kernel.org>
 <20220408223443.3303509-3-song@kernel.org> <YlEZ1+amMITl7TaR@infradead.org>
 <B9CEF760-23C2-489A-8510-2CC6F6C3ECB8@fb.com>
 <YlPRNFpT1BF0+fB4@infradead.org>
In-Reply-To: <YlPRNFpT1BF0+fB4@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 212ff510-fb69-45a7-a620-08da1c092dd7
x-ms-traffictypediagnostic: MWHPR15MB1790:EE_
x-microsoft-antispam-prvs: <MWHPR15MB17903DD075AF55E3F44C81E1B3EA9@MWHPR15MB1790.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rNo8T86zl8SRX8dwTkuKR8XkgtJUWacsru1Te6czl21gN3g3tKH47ioZXS41GdKdzt32AF+kD4VLjIYZmsxJX9g0TerfYu39w54XXrCq2tLzDWXc0d/949woteliiiFiK+N2r1LqppMPFk2cORh15m/YZ3FbA8SJXsA9z+KYbUONc8yZQcQ76ohk+N3d055UfxQ4MizTnDJ93RINZZVROUCNeaQ8bx4c0WTSrcMZKtF7zwVgiFPdtWvz4RtgiqeShwMw94FIXzA7E05UATB+P9tK1xrPzErUgZw3WXYH8yf8kisousxUtis7oIBiFCmIodmFZ+mh1I2K4xA9MPSbLPwfn42SLF6KVYQszF6io3JoFahEq4kfj2FJYu5amAsYTHtTfcEevaMk+sqQmtclKKWsgnJtkBjUul8iEdUIQ/YGewfyiz37GngV+keL7YNvHFfMehNqLTrPPp0gfAu6L+pVtsZPcLPd3sAsi9R8xxIVFr4VG/yu2PCK1HJ/c317j7/KTyE83WYjWTwjffxs76Vt2tqdI6ytU9XOPDwZ18VL1N3x+bdScb6lO/zCNQKMtqY7lhwB0quiyXR1emvSNghvrG7LIxaXDsWxhPNK7EOTMuXcdyNrGkulfe8wC0sqOeaUF8eLMhbrZUYkLHFSDRZQrewxd8oyU5YlBYHxaOjE9dYiBqbDQdp1JLmPOVkoya0W94nlOvZ2ZJ4bIv4U7A647V08S+0lOANre2Q7LTvnc3RBmeJSQb80xAQVxc//we8O21kS0Vude1K5V3GKXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(76116006)(91956017)(64756008)(66476007)(66946007)(66446008)(4744005)(6506007)(316002)(6512007)(38100700002)(2906002)(4326008)(6486002)(508600001)(86362001)(8676002)(6916009)(38070700005)(7416002)(33656002)(186003)(122000001)(5660300002)(53546011)(36756003)(8936002)(2616005)(54906003)(71200400001)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5LcumMQtnrZymZIPZFmz77QQ/x1Z2UUJoJxSF0BqSkSWpNB4Gj5KxhWAU2cc?=
 =?us-ascii?Q?mrM5SE78z+t+NtdqNVxD8puAgCH9KorJ2mvudcNZtCY1nuA+vS2xrKKzPTFj?=
 =?us-ascii?Q?Xu5hhP4EnurrqwpZHXw5qI6OZasCiHbDu0c/ckyoxlDeuFWVU1z1d1FqHXAb?=
 =?us-ascii?Q?thE/U0BgIAqEkRdYrbAplS3Cm/xRhOO275Z470qBYuVVWM8t2V+kcyPJz/Dm?=
 =?us-ascii?Q?AFPo3/M9S8FPr1ywJUvABRcdyl6cLtCBQz/UaBBSiDpoeuRR4nLF3FyUuzPY?=
 =?us-ascii?Q?tnUjXzTgNeq/HO3CSMCarQNsUUuZXUUwBKgoUmhPT+tCSmAyikgDd6bNFSGN?=
 =?us-ascii?Q?P8IVplIfvsEIXutBO54m2gAhZAbHcpxmQMlZ6sFeINkJ3kcPeM6Whpy8HlPa?=
 =?us-ascii?Q?6XB9eEDNGpLd2gmft8sIWOnc1/sOpwMduM+26bvedn+cWFHZkIzlbKzpjq50?=
 =?us-ascii?Q?5IkFIg8S33GsTAsN4MExNk+soSQhsPssKfqz42UwXwsd/cLurWy5maWeFN/e?=
 =?us-ascii?Q?zPnoG7UwRMN8657opnQAhzl68TLTlF3OMNVdI6oYH/M+qe8Khh9jkbF0lq6z?=
 =?us-ascii?Q?ZZ0Oh1gXOpbJt1bBThYjGok2dHW8Eejd3LsJwtRqzgD1qqPwiIhOMXkCFYpK?=
 =?us-ascii?Q?1/08uuBNHunTGFAD1nfdowhpXBP2avFTGawPVFdJW/sAXe+ppBFEn+rk8P1c?=
 =?us-ascii?Q?Uk54hl9ol50hwEWXFKW/g8QZLRrCZzNRx7J8qoacGcArNZPwTjMzeaqqNnG8?=
 =?us-ascii?Q?RMlsy72W3IaFDKfbcDBWbb1yPtcj9VS24d4kRHgiUnA950eQHigXaTRh6O3Q?=
 =?us-ascii?Q?z5qGXoxJZFQz9DyCXZP20vub97yx/deS//n58FjAU2OMVvCRmp31+vQ6/XO7?=
 =?us-ascii?Q?Nx/U4MtuQXAKMMUZ13alN06RsEjHgUE+QpQIfIpgLfB6POfF3v0MFxJvJXRV?=
 =?us-ascii?Q?SQInAWscRNFWX3RynRGAU35IHVw407pvPrTBqF8Y0z+EFEutyoxcTHT2M2F/?=
 =?us-ascii?Q?9sZ9Z0cX1+j2hcM9eCb0gPDOlkmEfn7NdmrewM3pUL52LvSOOIHnXjS5VaYr?=
 =?us-ascii?Q?NyMOdEaCJJmA5V4bmwwNgFn9+27Emk9uYiN6IysTcWyLFzRscHI/cDNjoUzR?=
 =?us-ascii?Q?2Qjkoa/EWOEHchvAosjfVXLsBkMGaWPn0g9vEb75rbVmnCUEeYhYMatP652C?=
 =?us-ascii?Q?1CiA4otEfdFwtEL5uHFh9/69U1x/HRdcepaBgPbH3SB/wN6rubEDe7Hs5czh?=
 =?us-ascii?Q?UUCletZlB9Df3G+M92mLxiElZ7+S9x01Z6wpVvWnx85ZEx0XTEVpVFTLZGLJ?=
 =?us-ascii?Q?5AktMy8vTWkHdthNNb2ecXiAZpFtowusjc5A62/RxKSTqp+0crgcwNMRhDu5?=
 =?us-ascii?Q?4sLJ7FNME6BHOSkAJ0GU0ovy5tO6jRrBDf+U8VCxfBQiLhUEYA5tEGxW/skw?=
 =?us-ascii?Q?abCubp+rCz09qjBOLgvQpA2gATbB45NtYM86smXkAKW9hZveRHYNpE3ZIeKQ?=
 =?us-ascii?Q?UHRGOAP9vpExmVPVUt/kyNVvExZ4L6PqoodAkX2it8llcrYruCMEiOTk1YmK?=
 =?us-ascii?Q?f6TKUQ4LiJ+DVBqZXbaMEkL3VuZzLAKSvf22c/yAXAzj25c+W74vh6p0MeSz?=
 =?us-ascii?Q?+7CbEzkXbslEHF44akpqsQ0IOEIx8QBjwTiFS01XYZz+vIijf8DblXmOGmA3?=
 =?us-ascii?Q?DXayKF6ui3v2t+uQQYLOEgGXqOeql/HiQsEdWk3AW2H9b3rsgr3cnc5s94ZR?=
 =?us-ascii?Q?DHGHK4bQe6A701azGdBODPRs63si6C5JPkVqZ1Dz6zP+H1WMNfZx?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3DA050C381207D48BB8955C75A30C2BB@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212ff510-fb69-45a7-a620-08da1c092dd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2022 22:18:17.4956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: agmx2HNqYq8iOLz2J0yaOlA1mcPZMiUtAmKH8uIft76nm0QHBCl2Ir4iBKhXnJ8rBV8zcWmLqEmnOkV2h13pHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1790
X-Proofpoint-GUID: SCbAZmtOTMCZd0xYUDZdu-7Itl_p61Al
X-Proofpoint-ORIG-GUID: SCbAZmtOTMCZd0xYUDZdu-7Itl_p61Al
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_09,2022-04-11_01,2022-02-23_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 10, 2022, at 11:56 PM, Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Sun, Apr 10, 2022 at 01:34:50AM +0000, Song Liu wrote:
>> OTOH, it is probably beneficial for the modules to use something 
>> similar to bpf_prog_pack, i.e., put text from multiple modules to a 
>> single huge page. Of course, this requires non-trivial work in both 
>> mm code and module code.
>> 
>> Given that 1) modules cannot use huge pages yet, and 2) module may
>> use differently (with sharing), I think adding module_alloc_large()
>> doesn't add much value at the moment. So we can just keep this logic
>> in BPF for now. 
>> 
>> Does this make sense?
> 
> I'm not intending to say modules should use the new helper.  But I'd much
> prefer to keep all the MODULES_VADDR related bits self-contained in the
> modules code and not splatter it over random other subsystems.

Got it. Will add that in v2. 

Thanks,
Song
