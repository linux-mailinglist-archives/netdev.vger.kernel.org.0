Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFF654FFE1
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348159AbiFQW1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245162AbiFQW1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:27:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BCE65BC;
        Fri, 17 Jun 2022 15:27:40 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HLj2Zo009236;
        Fri, 17 Jun 2022 15:27:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=30nun40zLu2E1UpRvQZ9KmWaiZLEmDUMhWLyWsgUUVk=;
 b=OznUtPKkJ/hPDOXcNiUHceLLb7mRzKKzFHiQfuv6Jt2IfifVg61wAzic22Ukf/5lASif
 gDDvnvA2Dq1prhS0VMeMMRPoCzvuj2ztvgu23TOrhbuWaEXV1zSNUMryj5JANefBbKfP
 emfVFUcABF9DzeN0nKF6BIp+2iTvuwP/A54= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3grf2g67c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 15:27:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiHPdWVKucZtWUJOtrJsOgGknKoPBITV0LUrN0dCvd9ae3wFj6G8iXbsKyl5FYV0pwSJccTlBnQg7Ij8/lRKwXYxploVLbmsTcUUaw+WYrgLX/JjxFLZKoe65T2nU7Y7XOyROXxi2wdC9xlafY4ied/ypiYQGKSw6aQpZA4vjnHrSARFgLQWhhGVMgm850MQi1IkIfFc2XKlltJFsKHvDQ6dWiG2GZFwFLoWa/V7m7ZvINj8U8JyVLGlAzvvsAoWWdzQqD0UEcjfXrUduIfnn14oack2to0PNONlgHTiifPpjuk7tQIYsdo1PQbn1d9C92NI7VGpKExSK4bxzPeMrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30nun40zLu2E1UpRvQZ9KmWaiZLEmDUMhWLyWsgUUVk=;
 b=Rl3ZYRhCpqyR9JqYEZjrEoWMRv9I+d6sYTk2ZVFbEyBM65kOPzdXf7twIt2/P8Hp9BjdiGZ+xertJ1bpcxwrxhttT0EiWqM3okMt0OMFz9wwQ2yZmY5Njju9wF0nhoHw6IbpL7jykA8mzTz74Arnq7ssP2gR5384bJFY5M+mOLBDpeKSh6A77A/+J1yvMDznsbBzhF7N2KZWGcmlj+kcG3xpJfwvh8tI9VFaYCel4CIQiAcMFEDCDu4TeZTn15hopaoRIPf0ksvKy2qpM2sljLDseb9yTKqfgZcSnxP4zE27ib5nin8pBnaGQGxaQMXBazrjy1zsxrq9mUtm9LeWKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MW5PR15MB5243.namprd15.prod.outlook.com (2603:10b6:303:1a0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 17 Jun
 2022 22:27:21 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 22:27:21 +0000
Date:   Fri, 17 Jun 2022 15:27:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 04/10] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220617222720.ygiptlctjlan473j@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-5-sdf@google.com>
 <20220617004321.4qbte4k5ftbcvivs@kafai-mbp>
 <CAKH8qBtQmS5R7AaXoqh0HWWSReh3CF0E7sdL3jCH=ZKRJehnKw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtQmS5R7AaXoqh0HWWSReh3CF0E7sdL3jCH=ZKRJehnKw@mail.gmail.com>
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7bdbc6d-9b23-4270-e6c7-08da50b08bda
X-MS-TrafficTypeDiagnostic: MW5PR15MB5243:EE_
X-Microsoft-Antispam-PRVS: <MW5PR15MB5243664A4337DFFFAEA4A94CD5AF9@MW5PR15MB5243.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+XkXxl4AN+9YP+nmFZ/qphd4WuroGmaRKxPrwj6jeZzViIbnZDb36ndl+hFNmhJ52HA7+/f1svPPJwasrGFbPQtuw/X9VWpGCEISna+KjdqHrH+YwS216XeNKCJHF0pmEPE++AFMbXp0+lsHFK2CkZj7ZIQ7lrTqGg66fgjUY2A+eqVMljPU+acxrRgtrMDWSJBPgOTDQRnlB09hjdZb4E4Bs7BEgCgYI8Xguabw7QtLjBP+CCZUUgO48v77B2iUGsRLJxqWJVMipjBQynL0B6hWxWQD2vl7Q00ZfgOen85qLU+x/kmMla973K7PoxynHrgesD9+YFyOJtIfHRcxjpjn4QFj1nQb1fGc3u0Nq13ngY2jpZdyOzZNIXgiH4nSbCUjN/v4PsoD7nBJtj0Vn++adpQyBy6roOPTFHgOSVrC5fQreuNKsb4+luRCNGJN31+MzMulH4n0C6j78CstaR/9yShDAU9vJNUHkqP6U+LQ7IAm4nVQa0WvYgjiEv61en+0j4r5ULgXC/lMpH4V9S3+peMrxvh5l1Wsup4+RyEmthheyYoGSDliHn7sJpppcDwzRzqL/0RmH+lOKs04D83S/5veX9vgzPk8+vmV1W2pxWma828cG4sIo1ACMaTC1xmceLo1MxqTkvO/pstag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(186003)(66556008)(1076003)(66946007)(6506007)(66476007)(9686003)(38100700002)(33716001)(4326008)(6512007)(2906002)(316002)(8676002)(86362001)(4744005)(8936002)(52116002)(6916009)(5660300002)(6486002)(498600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IdvzrdLCZod/0wYH2m6P+H9HKoznh+UTKh0By/BYo0Z6SZDZ3J08M1lYkVZX?=
 =?us-ascii?Q?2WVpy6PzhrPU4aQjkw9gIHWjS08e/KnVxDxX8bHzq1+GuPrrsj7X/HrkT+uk?=
 =?us-ascii?Q?fdUwDAbc/JE00E5XUoJnKAdq6Gntst9TaCWeplO/15qAzYVR5dtqzCR0/Mj6?=
 =?us-ascii?Q?yCYnc5jOihUel95Fl87pd4XLgkHjPBhYx07GqB8G8czHAjqXkCNFUbyUqDBr?=
 =?us-ascii?Q?bAFIoHzoC0/Gyb/iBQ6PLxw39bGcIrw2cyCn4oR9uIFkYtF07hIz4WH6Y3Wy?=
 =?us-ascii?Q?6ra3+82rBFBYBYVbTMEuVORfvsYFnNhXQxmCHcHSXVTxv4BB+VRLGKABNwG/?=
 =?us-ascii?Q?iGjvyRmkq1DNXBZNZaF7NMLT7sYgL8xrJ88h7EaoRXs36WSW70PcA0eot0R4?=
 =?us-ascii?Q?KWUDtF6DFKK77BiO0ovkBv7zIKvg4BcBSC3tntMKxfr3NDVMm2boFMsRWyt3?=
 =?us-ascii?Q?MEXsuQsg47Vh6jdLKF98VXmCGYLOEPB/XhP3r+W3Q5p0vPC9MuxdLIurovEQ?=
 =?us-ascii?Q?IfnIJr8i06PIHWUSZ90E0DV2GCVmkpJUuZc5GOwv/cy/sLWrpsKMvWrlObUS?=
 =?us-ascii?Q?D3W4FTn82SEzzPqnxxhefXMPTdz/pZ/oAbg21Z42d7VSydgtGa+baIBUMj6K?=
 =?us-ascii?Q?sVfY+vsnqUrMYFf19OK2ZNy8nQlpthXUtdzT5sxabKlsOKLh5PZGua/OxZ2h?=
 =?us-ascii?Q?qAJONuv58fYVAGyKMv0Q0gTYy9QPS+Ew71PadpeYZGjl7HIt0DimrjzgPhbw?=
 =?us-ascii?Q?QEux2sv0qEr94w4IarOBB+c2pL3dyrw07oQzzsYxxahLJizetDDHWQaCErAQ?=
 =?us-ascii?Q?4xzjVTCuqukK8LVzDAXYO/X1qF73Sc3//lkOcKeob0NqWa+rtiUEmmntelce?=
 =?us-ascii?Q?E/j+h8L5NaxEkivDTpFcRsO+5eawSnrk05JQUZEmyJWOXAGv6Yc3zO+Dv7J7?=
 =?us-ascii?Q?OnEXS4lOeksBdbuXkiVFs4MAv9Z15r0T2q/DkjS7yabxbO41kZ1AvB7Zi/c0?=
 =?us-ascii?Q?8CZr9CqUUbdYVYAnQPl743fq0IPh7Zn3SBItwQe/owqsAIYNSMtndCvVhmhl?=
 =?us-ascii?Q?zbyTSdEZzPn0J7k+r+z+8xuVTSWoPIEgNbqtMMamkZwpjO2AIBXatFeCxwip?=
 =?us-ascii?Q?34lEO6ILtDLBWo/TvQAb0xW/Flf8T4YLF9QM3+eY4PBK9p16VRMbFU9Ll6oj?=
 =?us-ascii?Q?SHz9/nqfpkhXaB+Zwxh+bC4hi7GrIJcWA4q0J6qjyJgBYd8PtmZZoxXXwdas?=
 =?us-ascii?Q?vd5cluRTzhQyIr3OFxG0q7rXXSbm1zAm9YGiji6BG2SivjNx655eTzn0bH6O?=
 =?us-ascii?Q?NG5qGWQZL/JJ+FdheGSCRZHkIk128TCpy4Cnh5WMoHv6xMZ8qBY19JhFBABH?=
 =?us-ascii?Q?HwK5cHPvnpZOCDIegJEpnKBW8wUAl0YWEDSsfVDzQk6XBIDNxfcgRm2l4VQj?=
 =?us-ascii?Q?EqlRmvPLMqv8mbjnf+pQybPKQM32kqvk7bu+wPnYd+KwP5XNl5xiwkv0nnH3?=
 =?us-ascii?Q?uGoZywTrYyH++yauQQYo7EkPV/b0bMyVQZVXuxqxc0jlcVu5LahdTpkTbaW8?=
 =?us-ascii?Q?yQaZ5K/Jba40leufmrB5zEglBRt2VgWlNm3NnnhAHXKU3YzYw55khHbgoNBO?=
 =?us-ascii?Q?R/tSX6jBOfY8xrm4mAUX364G4aC2LUAzMBrZtpHfPnDj6ckMqgrCo7CEyfHG?=
 =?us-ascii?Q?2S+UBoQx3Frgdr2CaUdIZMEAogJXfp5113HpbF5LMBqjuTlQ+vRr8s1Bt7Qz?=
 =?us-ascii?Q?Emrv+sRurX9Pp/a4QJ8QW7c+vXIMYV0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7bdbc6d-9b23-4270-e6c7-08da50b08bda
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 22:27:21.8750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkEzot0g4wyZV/t3/dOnu10beapmE4hieVKPpFC+BJoBdpf6xF3k8Z1CowF5TpM+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR15MB5243
X-Proofpoint-GUID: etPcaK4VHZ4218fF9uM4EcPK4sblxXIx
X-Proofpoint-ORIG-GUID: etPcaK4VHZ4218fF9uM4EcPK4sblxXIx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_14,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 11:28:18AM -0700, Stanislav Fomichev wrote:
> > > +void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype)
> > > +{
> > > +}
> > > +
> > > +void bpf_cgroup_atype_put(int cgroup_atype)
> > > +{
> > > +}
> > From the test bot report, these two empty functions may need
> > to be inlined in a .h or else the caller needs to have a CONFIG_CGROUP_BPF
> > before calling bpf_cgroup_atype_get().  The bpf-cgroup.h may be a better place
> > than bpf.h for the inlines but not sure if it is easy to be included in
> > trampoline.c or core.c.  Whatever way makes more sense.  Either .h is fine.
> 
> Yeah, I already moved them into headers after the complaints from the
> bot. Thanks for double checking!
> 
> Let's keep in bpf.h ?
ok.
