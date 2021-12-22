Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9328547DB8F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 00:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244792AbhLVXvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 18:51:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29036 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232471AbhLVXuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 18:50:55 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BMHwwGi030072;
        Wed, 22 Dec 2021 15:50:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nILiB0fdJXNJ4vg9L6e0THWV3LXVd4zqQISUV90fa74=;
 b=j0Ul0pPy9z+uC8vuw0m8f4dkKEJDoR1P6hpvVUwR+1RzyviEuD8a3nz/SPjIFLV/N+6D
 YkqxOaeL+JbZgdUAUU9PkEmSENbXpaEY5XWv2Q+np6Mtzge08v35QmiCdj0YLI/IiZ5K
 VFvrkDQM4r5SxqHObuk8FfVdL+RBm+VuKyg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d467yu3dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Dec 2021 15:50:51 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 15:50:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxMp82RsNgVlvFxpRA01FTnMlHkLO91wRHfaLlJxLb9H3fvNVjkiR7N6ETc1RrbLibEDQg/G0wsjW7NgcWHWIwOFDmFO/d+FqU6N1Aj9PzqkK3aqNWGh4ey2qOIztbaKxu/uqac1pn0nUJMoKEHhIjoYIACTNQoND3UCn4CrrdwQ6c6nQZAbYrz9u3hrfRYShEBFGE0wwnBGxf5887dHwAcme0slrStFqOk6TQAKjqi3FwjfPGJD6M7Xh66Kl5fhhqPRK/29VNqf8iPs7SrJWvBzHEWYYbCso1rLyeb8Uhy3R+9P0wt+jwPm99uYJDIfg1oxiZuQ367tnmTB9G3uzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nILiB0fdJXNJ4vg9L6e0THWV3LXVd4zqQISUV90fa74=;
 b=Bn0wfvcNBC1W154V9JEyGu910inkALzLpSokyZCBnqD005GUuT/Kb2bbE5GxiqycVNSb6Uu6g1ZF8GQdteaYPCbxfNAqmVDGR3Ih6pX9VkTsiOHF6LZKIVwlbz43F+O5/MZmjSHAnXX/rwtqNe44u27iH5vs1QQihfq83i/fyxA65uwQcbDmXQk1J1+II8qZF+7RZiGsudxEZLOjgClnMMqfE/Cv0WVNeXkFsQ8Z7m5wescFmbLzhUTaHQEjv6HcHqzdvhBweUIMDjo8RXDam+DlsLbkvqT8EIkZGQXK5v/jjEW8GtH7n/Al9GlEVPAjrEC8hlXbxl/5KbrOmrHGyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4174.namprd15.prod.outlook.com (2603:10b6:806:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 23:50:48 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 23:50:48 +0000
Date:   Wed, 22 Dec 2021 15:50:45 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tyler Wear <twear@quicinc.com>
CC:     Yonghong Song <yhs@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
Subject: Re: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Message-ID: <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
X-ClientProxiedBy: MW4PR03CA0306.namprd03.prod.outlook.com
 (2603:10b6:303:dd::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d2fec3b-543c-49ea-0870-08d9c5a5e0cb
X-MS-TrafficTypeDiagnostic: SN7PR15MB4174:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB417438BA111F23C0EC53BE26D57D9@SN7PR15MB4174.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IdqTTswkYbFPYCVE/aNMIkah94n88M+6KU7Azz3UVYzTnvLt1duvacWqZ9PunGVAmT1zqkqik3kntoxsNeyYSvIPR0geEPaFG3GNvHzkvg0ItHT2cE7NzMOLKE+DiwAGcoXXr8ao+SFtItQdomHgQUvPpa8MBHOE/Zd0Ab8LLBPmAgwuft/7BlRepJge7BSd24OMMWkwKJaeo7jWP9aJTjgLds78uNEZE4kPT5QH7H5jww5T70jkN6aMiniBoihfO7LITlKEeXYPdkFv7xYMBMmM9ZcA829SIBTlZ0+T7fGIG8XEwCIlpG5iznoSxvRG2Zd3wYRCmV6fzAyCvAhm56U8vDDpvlF4Af0YMG8iZ5utGBnKGOGwsKJxCCvMhLhbbiBNywnKwj4k1z2rE33xhECL/CdflJGLiZar5I6sxRXOuuya/b54dWZjiv1+A56oFDuyQRXzYR2DUUvQzzARFJjPHXUwfFGlR0oB8Iw0ixUHpmRkA+1TWGEZkJFy+8bCGaWDiLD1pEMDGDGjUvHQca8eOVnCvr804p2+/hWOIor4FwhnbpH+FAVacrgupjwTP/IopRCooR/nRVTuIRpUUkUD987igoDzbpljA9JPmaFGroXAnKk32iD5mAQj0GsZs8neoeAfQox+rLvSa2iWig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(83380400001)(6666004)(4326008)(54906003)(2906002)(38100700002)(316002)(6486002)(5660300002)(8676002)(66556008)(6916009)(9686003)(1076003)(6512007)(66476007)(66946007)(186003)(86362001)(53546011)(508600001)(6506007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zV2I6h8zHcaS786bmWSdTf5hdYHNNwqYdwNLWHYtWqoxf6/uK2DEftLVMGOy?=
 =?us-ascii?Q?7W85bWOqO316OgY/zDBNwdjy+4MZEnL808PA8BwzMBSqHQLDmG/oPOtNRAnC?=
 =?us-ascii?Q?4Gcbpt0+8T+N2hb7tLG7oUFx/2rSZl+uURKqjGPQW1xNVG3kLdYB2J28Ce3a?=
 =?us-ascii?Q?8NvTynsPO9puQADtlmhlTmY9CdJd/zAbCQLrpX0OQDB/yqa/xwzbx1J/6kap?=
 =?us-ascii?Q?UvNZ6TjWyrmjg6OZsTuiWjNpgX5oYknsTruPdRKbnihwRXF0KYsNaVD81InQ?=
 =?us-ascii?Q?FoNy+eIfIOLYg9GBpz2TpbfuMJpZX9ubGTHU9m9wZLr/1yccROFmvhc0hUa7?=
 =?us-ascii?Q?VqGhwVGJumgGVl3V1BXDeIHRZuYR20+Zdib/h/7SdjPjtIvDL8TP/KfJEKpP?=
 =?us-ascii?Q?kjs70EoGCo7FoTraJyxo9wlQyWBXzmmzPKWXYqQbOjVQ8DL/Ujq3lgJLY6c1?=
 =?us-ascii?Q?wCr/J0zCw0slSK3YjxLOckbrasnmGsLuqwnpx/JvN0n8a1NjOEGyTISy4HMr?=
 =?us-ascii?Q?NBdhHbobG0BaIg4egDv8qGrJ/MyCUcFTemo5b7n0ybxygsQe/ZMxMjUMapQL?=
 =?us-ascii?Q?iDQ9tkxb9rW4MKCgF1xFsuiik5p0TJEfzImRGYhgU6jgLMIsw73Q34kscKGZ?=
 =?us-ascii?Q?eOZHxZR4p5G/BmIo9absArZ8a3CzRWVJt1AuYrs2bB1upi7WRptLFPV8IJYu?=
 =?us-ascii?Q?jtk4sFJ5khwIp0cj3IfYcwFb56sSV5Cc2igSS2lsJl8rJB+dC88BlVqHBZji?=
 =?us-ascii?Q?HkoCpllL2m+BVCHtvjx0b5KnRBSdcaO8DD/uCfene5eLb7FkYLxW0gMD72j2?=
 =?us-ascii?Q?1+hTRRNCnbuamkoz/ChaPhgv7iOp+yowk5EWvVRO/YK8Dl1SR7GNF/66v/He?=
 =?us-ascii?Q?Wg9paVVuyW8PvwN/JWNj+DI69dlwh3tfmv71MXtf0DwaGnuNotXxlWBsgGZd?=
 =?us-ascii?Q?pNFFo/4cB9VzUkfkgcJzBIKpXZ7mj/pVe6TyiLprzpDi4HgPQTsi5pIevWDT?=
 =?us-ascii?Q?hxNB6QFRQDFEdDZ6n4Qm8ciSgFGcDUCuR+nUVo/0PpAB8wL5OBnUcr5aTg2O?=
 =?us-ascii?Q?m6dGOXWSNXguB6IcwalQEICWvz9vVtGEYrKGWVC04FVh5U2Rr4boXUJa3ocl?=
 =?us-ascii?Q?LKAWtfs5uR3GXzKhU0be9rKbJcl2ljkNJTumjXy09OJMYyu1N42Z5yejWYKD?=
 =?us-ascii?Q?g3FdqIaRU1U031SQ8drs3LdL2K1+2CEvTp5ry/jWStEjeZRxwo1QqNw6RJOM?=
 =?us-ascii?Q?tUDgu/TD+r/ea+iaQ5QJjZF4SZRyQuQ8+YE/Qwaaxu6ktFlgro7huLJVfwSC?=
 =?us-ascii?Q?g0fibkyh48GGhwHrdgk6LpERqbLKjVwj7tXCgj0xSxAWpjULdnacBX8ZS2Zy?=
 =?us-ascii?Q?XcdXt2hgaF8dbrFVEScCnkQDfDHNdJ5i6rqWRFww40ebVUS3Fx6LVY99xw/5?=
 =?us-ascii?Q?DxMwx5tHHy97Eme72tiNE0gHG991xfaaFMPlYgsEmethcMrx6pGc7mSSXWFN?=
 =?us-ascii?Q?agACAZNWNAD55axzDQNkBrV5sKI1x38vzRbsMT/W8smjpCwpLdAt1W6MajZY?=
 =?us-ascii?Q?TDsXhkYUmlamwBkaJwZdyOd36miv5Fawk4RO7EMD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2fec3b-543c-49ea-0870-08d9c5a5e0cb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 23:50:48.3384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LQzfNlyOSzewGsPdp1NAnfp16QoQ522MgWT3VvrHW7NpAyHEMRmr9xjjxQr4bS9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4174
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: KmvZlzbI5599z7vpNeEkknaINmNGo4qD
X-Proofpoint-GUID: KmvZlzbI5599z7vpNeEkknaINmNGo4qD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-22_09,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112220122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 10:49:45PM +0000, Tyler Wear wrote:
> > On 12/21/21 6:27 PM, Tyler Wear wrote:
> > > Need to modify the ds field to support upcoming Wifi QoS Alliance
> > > spec. Instead of adding generic function for just modifying the ds
> > > field, add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB. This allows
> > > other fields in the network and transport header to be modified in the
> > > future.
> > 
> > Could change tag from "[PATCH]" to "[PATCH bpf-next]"?
> > Please also indicate the version of the patch, so in this case, it should be "[PATCH bpf-next v2]".
> > 
> > I think you can add more contents in the commit message about why existing bpf_setsockopt() won't work and why
> > CGROUP_UDP[4|6]_SENDMSG is not preferred.
> > These have been discussed in v1 of this patch and they are valuable for people to understand full context and reasoning.
> > 
> > >
> > > Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> > > ---
> > >   net/core/filter.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c index
> > > 6102f093d59a..0c25aa2212a2 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -7289,6 +7289,8 @@ static const struct bpf_func_proto *
> > >   cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > >   {
> > >       switch (func_id) {
> > > +     case BPF_FUNC_skb_store_bytes:
> > > +             return &bpf_skb_store_bytes_proto;
> > 
> > Typically different 'case's are added in chronological order to people can guess what is added earlier and what is added later. Maybe
> > add the new helper after BPF_FUNC_perf_event_output?
> > 
> > >       case BPF_FUNC_get_local_storage:
> > >               return &bpf_get_local_storage_proto;
> > >       case BPF_FUNC_sk_fullsock:
> > 
> > Please add a test case to exercise the new usage of
> > bpf_skb_store_bytes() helper. You may piggy back on some existing cg_skb progs if it is easier to do.
> 
> Would it be sufficient to change the dscp value in tools/testing/selftests/bpf/progs/test_sock_fields.c via bpf_skb_store_bytes()
test_sock_fields focus on sk instead of skb, so it will not be a good fit.

load_bytes_relative.c may be a better fit.
The minimal is to write the dscp value by bpf_skb_store_bytes()
and be able to read it back at the receiver side (e.g.
by making a TCP connection like load_bytes_relative).
