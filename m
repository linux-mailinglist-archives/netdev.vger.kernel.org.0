Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AC054547C
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345187AbiFIS42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237357AbiFIS40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:56:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99974F463;
        Thu,  9 Jun 2022 11:56:25 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259FPFpi000366;
        Thu, 9 Jun 2022 11:55:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=ken2hvn4XOTk/neU7dV4LMhHDgbYmlCZRizec+Bj/Mw=;
 b=aRUXUZrVX0tkn5k2CaACOsVkLteoDGp8L6vsjVutvqYoNdml9RDf8KRzhasn2HTIWbRn
 payN43nIGrWhviTrKytNDQ3bIRpJaoaPfxz10BBBr1PNJItRPt5+gvnrmKZoJs2qDfv3
 JfSEaG+crnqSfNz/8JvLyLaBV6x6utkBKss= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gke7v3cnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jun 2022 11:55:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PH0CdGhhw8sDYfTyCQA0rjs1M0yuY6F40O3V52fipMmqcxr5GoQQjh6HyfqxGvHbo5k4uvpC36BLm+24qdReGZ6PMl5GZnWreYt40urZQz9EQoWsGL2YkmqgTWx9gZoofl2ACYkF5TX/wLDufWhhX2q2XdSbMxCbS+xPn43m568wFAaDsgkXtrhN7yRU6x6kxsEChH31iJhwQxsEA8b31jOmei/Uqid1UCTli2eLdT95Sv52phnHkkx89QLbbqouPxOKe3UpJjIKkEzD69Ww92jjn/n+WmW1kKrihUwdxjJ5XkKd+5fk47/Ro29ebbZPGgNj7wtYX9WhVVTEYxjVbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ken2hvn4XOTk/neU7dV4LMhHDgbYmlCZRizec+Bj/Mw=;
 b=n+zb6HcNlUNebGcUM4uLEMU5WwqTU95o4pZWW46kHCIYiF5UlDZANLMcUgydjp/iWpJIkyZ07shOZxOlmTob57f5CFba1xHitxvk+m7T5oFjRohi4d9Ob/1eYm3J3poJBRCUKi2EuePkh+BXKuc9/oAPYl6TSpy/hbTkx6D3gaG1l0C7ziwEnC0v30iQkNe3dVgKKesxzX8o2u063BhEJRG38z0BRrw3RiP7T2uARCzIJX1DfWw2rB5cy+LBkg+gwKatFAolMc89L+8gNyrARW2FORLy2G+VOYfkuy7BBtnguxhjipRfFg8CbqzErcDJIcPc1kDcT2kB3RA8GJJFuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1685.namprd15.prod.outlook.com (2603:10b6:903:139::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Thu, 9 Jun
 2022 18:55:56 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 18:55:56 +0000
Date:   Thu, 9 Jun 2022 11:55:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] bpf: Require only one of cong_avoid() and
 cong_control() from a TCP CC
Message-ID: <20220609185551.ptn2htxmk4fsr5p2@kafai-mbp>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
 <20220608174843.1936060-3-jthinz@mailbox.tu-berlin.de>
 <20220608183356.6lzoxkrfskmvhod2@kafai-mbp>
 <f7ea082a99224e12e085e879e7c067f23844874c.camel@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7ea082a99224e12e085e879e7c067f23844874c.camel@mailbox.tu-berlin.de>
X-ClientProxiedBy: MW4PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:303:b9::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9131a7b1-7f45-4d01-9d0d-08da4a49aec2
X-MS-TrafficTypeDiagnostic: CY4PR15MB1685:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB1685F00CF2AC3880FB23E539D5A79@CY4PR15MB1685.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ECaJdfPKeCIlrp+XIAteZWXJZLPwMRB4rSUaLJ11iq8uhTDFtR+aVAHG7IPMsGh7InonQ9+G6wtUkgSSy6gX8YOGWO3cNMsWD97llJrKyKABfCcP0X5jBLo/3ZJNtt4AXV6q1Wye5DWyNSatXU7daPd3NIR7r70DZdk5uwXkI7ppUhf48kTnvJHxlVc1bjyaEq9g81HIhnAfNcNVpZ74RGuQSjfv6qdVHAwaR/d/ETcfd0AEb1vnRh9yYw5xddcWP9JthuejcBfr0qjcddtS3OtwSAINM0hbAQXPesWY52rfHHfzClXRdPjGIVAbONGqtfq8sh8U5qjuVw73EFHpCYCcEt6w/SAhkv2id+g2uNHwrq7qWXq3Aa6b9EHxZmKxG6Mg+7fHiV6eDDuHopS76VBfTbv8ckutbwCMCC1mYsCenMrgwIolNM+Ijw5LJ0h8prq4509iReR45q3TXlyvZ//01cZ9ymzNAtw3A0LnsgUC9HSIFrFBs8XHVwQ8H6d4QZ3bYrXbFCiEEyUEGQDjUKJaLtK4U77FrUvUrFJz02CDkSA+7AU8ZTseBXjx0skJVmcLHR/sFhIyPe5sy0XVzTRw1Yzw5sLAs3YqvstszZH8xNWeF1q/zJEED7Mq46TxTALRCTaI/M+iZVitnuy+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(83380400001)(6666004)(2906002)(52116002)(66574015)(33716001)(6486002)(8936002)(5660300002)(9686003)(6512007)(508600001)(8676002)(4326008)(38100700002)(316002)(1076003)(186003)(66556008)(86362001)(66946007)(66476007)(54906003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VU5QdG5nSzVtWktuWmNSNVp2N1Nlbk9Od0pQY21IS3MwSXVGZ3lyVElBeWhj?=
 =?utf-8?B?QVB6UDhzQzViTGpuRHZyVkZnV1krdUdpZ1lVTjBrM2pIOG5MWXZRSDFnbHc1?=
 =?utf-8?B?TGYzREdhKzhrdnh0b05xMnprMkdMSlo0NnlDYWRmRkxyUjh2WmU5VlZqYVdH?=
 =?utf-8?B?YUFkNzg5cXB6MDhwWkhHa1I5Tkh1bVRJLzQ3WndsUUJUVjRwYVNjVllzZ2Yy?=
 =?utf-8?B?UFhEaldzaU9NQ0hERU9ISGJTcTF0YnNmdEVTY3BlbWhrcGNpalMxSXZkcUF0?=
 =?utf-8?B?UUtFQTlFZlJhaTN2Z2NIVU95MWNFbzBOYlRYKzh0Q2w0NkprN1hXUDJSNjBE?=
 =?utf-8?B?S1N1RU4rTkV2VzNzQ2lVNG50YzY2bnJzekRwa2pKTHlIbmUrOUVBSnVUaUNH?=
 =?utf-8?B?eUdzQW5pV2ZXTVdLL3Q5bC9KS0tCOVh2MUVYVTdJcE9leUxVem9pOXQ2Q3V0?=
 =?utf-8?B?eFJMSm9BSjA5TzhXdlZUdkQzMUdFRmNTUGxiT3pmQzB6VDNhWVBoeHh4emt2?=
 =?utf-8?B?N2xjWmtLM0dIUFNtaWZodDhadGFtQXR1YTAwc3RENnkwdE1vSUJyRnZib0VN?=
 =?utf-8?B?bmVDR1RidzhCNjd0Y0ZDV0V5Q0tMRzlWc3p2VzI1M3crQ1ZrZUd3ZVJ0cnRM?=
 =?utf-8?B?dUlheDdhMzIrZGNyTDJuRUp5d2VuSjVvWGdOU1JtT0lPZks4WWRCeVo4RlpH?=
 =?utf-8?B?ZTJEdUpnVXhGenZ5UmRHeUxVQWgzOUNLUHoyQjh0Qjk2WmtaU0lrN0g3KzM5?=
 =?utf-8?B?b3BsOE44QlZHQXVvdFJpSzNqdE9yM3VScDcvQ1d4VzJEMzU5Y0MyNHJ4STR3?=
 =?utf-8?B?dWQrQmRMRitkUmsvTGRFRlp5emQ1cTVuTGtIOVNJZXZERm9VaUFNWnhqYnpv?=
 =?utf-8?B?dU15N2VXOVJTL0Y0bmhYNGxXRWs5eUVsQUlPSHBseW9qZnBsSXozWFdZRlRh?=
 =?utf-8?B?clRpR1d2MzZsMlhRK2NpTFZZN0VTeVVwTEpYbkRIbUNCTWNBNk9IK00veUFp?=
 =?utf-8?B?M2dmS1p5ZFdLREY1UUNoVDJhUTBDQThHOU1ZRUphbnd1clcyVytCQm0zMkhv?=
 =?utf-8?B?b1NiMEI2OWl1aSt4b2w2RE5pNnJ5SGIvVVVmM0VnczNlS1NlcmYvdUlzdXlw?=
 =?utf-8?B?SUtCcDk2M1grdDFZMEtzVExhK0FkN2VGQllzd2NBcXJOODM4N2ZDQXUvYVdy?=
 =?utf-8?B?QTYySlRRcTRBR3lsekw4M3dYdUU3NHpUT0VrcEdJTTJWRFZJOUpCUE8yWGR3?=
 =?utf-8?B?SXlwVnZXN3NOWUswWGZCcEN5eVd2b1FUSE80NmdaaEl4M3pCSy9nMGcyb2pt?=
 =?utf-8?B?czVwQU9zVXUxRm03R2VaM01JTXpteVFudWlaUTJDNFpQTit5U0NKcCtKS0Q3?=
 =?utf-8?B?SzFmY1FNaklOTTkvUktSUnV5T25IOEY1STBJR29jbm1QcVBzQ1loeTJPWkhV?=
 =?utf-8?B?dUtoVnJFN09pZVNLZFZmanlmT2pmM25wMUZEa1N5dE9HRDdpVDNBQk5ZZHZ2?=
 =?utf-8?B?ZGhiTjl6MkNMN1NyYVhTd2lpYmpNRXZJeHlOQ1hUYmpBeU1LQ3BrekRGNVRV?=
 =?utf-8?B?WWpIRkl2SnVYc3Q3NlBlTGdZa2tUM05LaXFqdkVhdUpqbTcrMWdEOGNyaUdO?=
 =?utf-8?B?UXpkZGlONXpTc0piQkx5N2VhRlFra3Bua2ZVa04wUVFpL2VRVW44dmRZc0d3?=
 =?utf-8?B?S1kyQzBlaSs2dkJQZmtqaTEzR0h6RHljN3N3alJTNGJ4NUpRZ1d4VytQYnJB?=
 =?utf-8?B?V2xJb09pS0NVT21wRGMwUWJtUGpUSUxueGpuK2w0OFRjcE1CcVdDZjQ5aGdt?=
 =?utf-8?B?S2hkWGc2VTE1MVYxWEhHMFJST244Ti8yQ0I5cVZSWXcrRnlFVjNGRjBsZTdl?=
 =?utf-8?B?WE0rUXROZzVBaUxBMUR1UlNrMkVNb3c3NTNtQTZEZGRORkhYM1E5Tm1tZTNG?=
 =?utf-8?B?WU96ak1sQ2J1QkhvUTBGVnZ4eEZ0by82NDg2a1lYSWlXLzNCMFEwd0NKYkk0?=
 =?utf-8?B?MTIxamgzZFZRMzRsazhJMWlWays3UU9UY1FiZ3pSdmVUU0VuWXZ1L29vSFBO?=
 =?utf-8?B?aFVnUTdkUW9FaVBZNng5Y2sxb0l2d0tHNU9EMytGM3ROVGRKVjh0WVdwNW01?=
 =?utf-8?B?T0ExMThxd3laN1FDbGFPZUFSb3JvczRDOFUydVFkNGdVNCt3TXgwWGgrMFVw?=
 =?utf-8?B?Z0pFWlVCNU1zVTRXcmEwUW1WQzh1ZDY4eHBDYnRuaDhuZDlSVkg4OGJuR0cz?=
 =?utf-8?B?UzRtNXZPU01jT2ViSnc1RVdaUG0vUGRhODRjYmJDZERtTFpZK3lCL1diZzRO?=
 =?utf-8?B?UkZ5UGxGRVRQckpOZDh0bE94UkxvNENiUDZiQTVNQ2hQUDFVZUhiUGcrbzFh?=
 =?utf-8?Q?zvr0B9wvMJGPIDJY=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9131a7b1-7f45-4d01-9d0d-08da4a49aec2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 18:55:56.3940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xxATkKBH+SuCOC1oez7Uq4373S9YGR1kTFbV0pgMAMVpUBIU5OC89KtprkGs8i4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1685
X-Proofpoint-ORIG-GUID: Ap6HK7d0MdxY4kWHncqshAW59_3Oyp3Z
X-Proofpoint-GUID: Ap6HK7d0MdxY4kWHncqshAW59_3Oyp3Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-09_12,2022-06-09_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 10:55:25AM +0200, Jörn-Thorben Hinz wrote:
> Thanks for the feedback, Martin.
> 
> On Wed, 2022-06-08 at 11:33 -0700, Martin KaFai Lau wrote:
> > On Wed, Jun 08, 2022 at 07:48:43PM +0200, Jörn-Thorben Hinz wrote:
> > > When a CC implements tcp_congestion_ops.cong_control(), the
> > > alternate
> > > cong_avoid() is not in use in the TCP stack. Do not force a BPF CC
> > > to
> > > implement cong_avoid() as a no-op by always requiring it.
> > > 
> > > An incomplete BPF CC implementing neither cong_avoid() nor
> > > cong_control() will still get rejected by
> > > tcp_register_congestion_control().
> > > 
> > > Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> > > ---
> > >  net/ipv4/bpf_tcp_ca.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> > > index 1f5c53ede4e5..37290d0bf134 100644
> > > --- a/net/ipv4/bpf_tcp_ca.c
> > > +++ b/net/ipv4/bpf_tcp_ca.c
> > > @@ -17,6 +17,7 @@ extern struct bpf_struct_ops
> > > bpf_tcp_congestion_ops;
> > >  static u32 optional_ops[] = {
> > >         offsetof(struct tcp_congestion_ops, init),
> > >         offsetof(struct tcp_congestion_ops, release),
> > > +       offsetof(struct tcp_congestion_ops, cong_avoid),
> > At least one of the cong_avoid() or cong_control() is needed.
> > It is better to remove is_optional(moff) check and its optional_ops[]
> > here.  Only depends on the tcp_register_congestion_control() which
> > does a similar check at the beginning.
> You mean completely remove this part of the validation from
> bpf_tcp_ca.c and just rely on tcp_register_congestion_control()? True,
Yes.

> that would be even easier to maintain at this point, make
> tcp_register_congestion_control() the one-and-only place that has to
> know about required and optional functions.
> 
> Will rework the second patch.
> 
> > 
> > Patch 1 looks good.  tcp_bbr.c also needs the sk_pacing fields.
> > 
> > A selftest is needed.  Can you share your bpf tcp-cc and
> > use it as a selftest to exercise the change in this patch
> > set ?
> I cannot do that just now, unfortunately. It’s still earlier work in
> progress. Also, it will have an additional, external dependency which
> might make it unfit to be included here/as a selftest. I will keep it
> in mind for later this year, though.
What is the external dependency ?  Could you share some high level
of the CC you are developing ?
The reason for this question is to see if there is something
missing from the kernel side to write the tcp-cc in bpf that you
are developing.

> In the meantime, I could look into adding a more naive/trivial test,
> that implements cong_control() without cong_avoid() and relies on
> sk_pacing_* being writable, if you would prefer that? Would that be
> fine as a follow-up patch (might take me a moment) or better be
> included in this series?
Yeah, it will do and the test should be submitted together in
this series.
