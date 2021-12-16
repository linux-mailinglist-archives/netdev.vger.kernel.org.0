Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17F477FFD
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 23:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhLPWXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 17:23:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230462AbhLPWXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 17:23:54 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BGHP0LY023220;
        Thu, 16 Dec 2021 14:23:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=6C+8PU7a5i4Yh347KlG0lXRfTyLMDRzwekPmjHrqWso=;
 b=Qq15pA8/QezA0uBgXgoqscs7g22Lv80igXpCSKxrZc+Id1nWmxJTKYmdhkqqIwCvPqNE
 byuV9PSFwgpdK/bqnrNBT0kRFKjwZZKScqpjZgL9EmgpHOycx3QRDRKiadvYN/cNEchY
 O0P6BNybOUC0VUfdhM8loNF4WFWKLlyZZwg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3d00nn682b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Dec 2021 14:23:38 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 16 Dec 2021 14:23:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLjQ3YvanWnBWD01vsMbfXCzZIHbMo5xxgrh9JnsM2ZoZAFuOVx0qSUKeBWC/2l0DGsQR7V9nfxfVhUc28jXnGt6QI5SKPnoHKA9UWpV606CnARK1rdq8nLuxkH/r6HRJQ/Kea2I27fOnt2dwg64wwtZ1zJzu0B8vFo+8Pg/5tqooZMyAVTYcks5LlzbSjylV6eqlaY/GTofH/SJ3qEOQ0Erq8C+uXoFbmDI/H1p8nN48j9nmq9VXH0LNtNvAcqXleGKuL4Lzk6fjomGp99zVTjS89JAg9yVi2dtApod5CMU6Ca4WUByO5sJ7nxCLdidGGN6S5lySueYjIcmzivjJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6C+8PU7a5i4Yh347KlG0lXRfTyLMDRzwekPmjHrqWso=;
 b=X5K80L/l4EFIoq/sqhLCWVZkuOMjTANAW29bvdoxAVAn3BbN7Q4ilDuq94U1nJ0VQYgTeRUDB0+d3zPo/UOWXRT2aU8J5ptHBKKwLC1MG+LEHycxx83JwZIL8bHFu9zF44WkVVHAeZjm+00l65wPre/peWoEW63/u4oo+NGx7aogobVgsWp4eUTM/pRd9hPN9UPTHm3rGUWOlycEL5pFMytNh1ri9gAaNDgT78nsoFV41VC9cLKh9bdrz0pvZCm6rgvvpG9KviyDuV9uGL3/46mE1qVwvLb2m4Td2qBbpz0SJ2Uwpj5AUPaffNxbmHQfwUkxS9gM4FXG4jun4LQXmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4887.namprd15.prod.outlook.com (2603:10b6:806:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Thu, 16 Dec
 2021 22:23:35 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%8]) with mapi id 15.20.4801.015; Thu, 16 Dec 2021
 22:23:35 +0000
Date:   Thu, 16 Dec 2021 14:23:32 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Willem de Bruijn <willemb@google.com>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 net-next] net: Preserve skb delivery time during
 forward
Message-ID: <20211216222332.fltkclu4x3udpomr@kafai-mbp.dhcp.thefacebook.com>
References: <20211215201158.271976-1-kafai@fb.com>
 <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSdR0yPwXAZZjziGOeujJ_Ac19fX1DsqfRXX3Dsn1uFPAQ@mail.gmail.com>
X-ClientProxiedBy: MW2PR16CA0065.namprd16.prod.outlook.com
 (2603:10b6:907:1::42) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ed36ecd-7fe7-4caf-1ff9-08d9c0e2b322
X-MS-TrafficTypeDiagnostic: SA1PR15MB4887:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4887A8068BB0C0A8DA3DFDFBD5779@SA1PR15MB4887.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+v5q3Ql4u3Rf4SlB8QSit81rReAOr/cCUxy1YPNIz2B0Fosz5fX6r8QEsyWiid4DB1Vbd1L0AHwZz0lZLbcXTeIMOEHpebFYBO3KIFQ2IpjrMO+jVYVfF9sxCPSF83ZkhxPd19Eao6EAUQT1V1MjigCPyLO2nApVP2zRqQGfscY7yoZKHMA7+yk39mNqxxVjuwJepF0zU5eGssL2rZrxSioT/c6REweqaff58GtnepiCta+8i9n8iAzkYPMkZ+UaBheQWqh9L068AkIWd8lT+jcoLkD0Dw/BkzCkbjLJ8ghKJ8KVzPMNDS8pXNK8jogU92apY6FLT2hGXHC4reSdKwFk2oChR6p44cd1JDgWPwJ0jSV88ABJ1qNP9Cu48eyDA9ymblslgXrpvmqKH45AU6Tm9aICgvCyOffpTGHDnU4ukkDF/R6BqqNDTOnKopvRgD5SKjDt7burAQ0bmVTqghi2/JZkhxYmELDqJTZpu2wkMlnPiSysxi3jes6qgM6/LWaWdBB3StuaGWRnNljTCsTvV/yJD+KO9WA7dqR6XJyyot+Qvn0KxaWJCIZMuOKe31kp9+bSz4rEPDLy2O78yTqRVNE4G26mFRT/quBu+oCt4VOqENDsjIHfbN7ck+sjVr3Shgax4vV4lIBihwHcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(186003)(1076003)(8936002)(9686003)(508600001)(5660300002)(6512007)(8676002)(52116002)(6486002)(54906003)(6506007)(38100700002)(4326008)(6916009)(66946007)(316002)(83380400001)(66556008)(6666004)(2906002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HLgEOzPeH63D3ltXtlxl3PLt1I0rbggC+BWHMNfBdyWJZTF3SgBhR6+bizAQ?=
 =?us-ascii?Q?ACGkuQzzkEvJWcUitRfqvLzV76MxJDVF9EaBa7euToFEWNjgoxgKVmLBKLo0?=
 =?us-ascii?Q?X6XnqcSEIrfS4/nQgMjyslu4vcYREzaMGc1picGK2rw214h4cSo95sJIpkQU?=
 =?us-ascii?Q?XLRYDQ1u5ICHRL7d0hC/DcAZ47zjr0Qrmr9Fzr49U3JdmySTpzceM/fmWc0b?=
 =?us-ascii?Q?nrdugCiRre6hfrpkvTdhdwPodAK3pTWHtkXmw0dCAq/c1WzL8oQ99MGDdA8m?=
 =?us-ascii?Q?6XTRFy3LW4ir+/DtU7GZAB42KG9I0RDnclRevsKgzuWHww9JjyvugmSykw25?=
 =?us-ascii?Q?nYa29NHDDq7Fx1NH0CSHmNtowxzxuxSrPlnM1V0P9nd2aShei8R6QD0zV8lZ?=
 =?us-ascii?Q?J16a7n6qoEHN5TbUxkeqarc8FU++MNyVeVjmIUqRTpo3CcrzDUkqVnFMLbGG?=
 =?us-ascii?Q?f0seClgWIEqLm+TEI6GNnmvzi78ev5blyEA0H+bm+HmFgIIcki2CRh5gYhVq?=
 =?us-ascii?Q?zgXJh0J/YDv7qDe6S5a6m9aiyxS7H9czxSSNCuf8R2ZLy8ydcLcsfiw8ygLM?=
 =?us-ascii?Q?bgcLkt9F72VYu0ZS3V+RJhF6O4XZN/O8h9R0IQT747+kOFQ2yakB8hpBwj2/?=
 =?us-ascii?Q?1NEF2tO+dCeMCGUMc5/BcEL+djNmSgmRi1zHfwLdpNvMwS7XreNs8Ie8e8cw?=
 =?us-ascii?Q?aAdqqUu8z+REPigT9rgEIhfQGb9EXoKLYLUdo23lztB9At7rye24furASrIW?=
 =?us-ascii?Q?smVcQBIEbubRjk8SdE5R8C2fcuqjNTV1uTC/X6GSXtFjfq0Y3ZzfAkFpvV/U?=
 =?us-ascii?Q?b4XXesCIphoZ9LoSJlcnSNVh8kp04x/wBdWwuucmwy54Dv4hgGxGZ7/aSICt?=
 =?us-ascii?Q?nWaC0z1WBcfRpnZzOas8iLjH2IJBJ9STCh15ORfXLgiBKJ+oui8r5mutdYGR?=
 =?us-ascii?Q?UI6Q27weOJkjM9NmedNceqRZZ5f8KGNaQc4G0uEB2JU2J7j0hzTeEy/2U7ls?=
 =?us-ascii?Q?rF83BEajnRcgyQKlxicsFH8rsiTlsv8dkMoCTiczfqhCTPAPLmKUUlZg9UB0?=
 =?us-ascii?Q?qIJMSzn6GUr7vkqUorRG1dqxpzCEITama4mxvhq6gbSHfwmxMhWQBnJRwRl5?=
 =?us-ascii?Q?71mxrn7exHMeeWg0VONWF1YtiPp+GtTt7C3oEXmu75khp21xv/MGfouKUtd0?=
 =?us-ascii?Q?AMBL1HENx2bL8n45fapX0z3fYCnxyxVVmacuQR9yWPpz+z8jN9FDePVLFKup?=
 =?us-ascii?Q?Bae9swLfea6b+aMb4OhEc1cHOa07A+6v1fuJ3Hx4ay5tCCqRG4HKXVY5LFUR?=
 =?us-ascii?Q?w/m7u3B5J2M39+Ycd8l4fPoa+21o4EnD965lCU4kBR8+RYk8CCw6/gJrDlp2?=
 =?us-ascii?Q?rugI7XNN0r/sekru+yJZNBqRQzu6iPeGQ+txTxByP0K2iLPm3u7RNnjvG/vS?=
 =?us-ascii?Q?A0TPymLXVPDQpF0iPcSCTujIbKW9VTloXhtX7f1QI2unHijvseof5z9qDsR1?=
 =?us-ascii?Q?fIOWrAVDsayW637Gwpw6pPEZ7JJXFC96SwVVy3oCV5KOaDtA26UdDcBDVRCp?=
 =?us-ascii?Q?ym2xauNAHwNrG63+T6DlWQX0OtmhulCkVxS52pVb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed36ecd-7fe7-4caf-1ff9-08d9c0e2b322
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 22:23:35.7154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U/X1DbcnCgbTAqpX7S5pv9EGzLr1kT/YhurgA7C3n39+Ix0UjGQ4DCq0v5QB7Cnb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4887
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ss-JArhBv645Rc5yTlFLS4OzcitVWoDU
X-Proofpoint-ORIG-GUID: ss-JArhBv645Rc5yTlFLS4OzcitVWoDU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-16_09,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 10:32:23AM -0500, Willem de Bruijn wrote:
[ ... ]

> >                                                                         (c: skb->tstamp = 0)
> >                                                                          vv
> > tcp-sender => veth@netns => veth@hostns(b: rx: skb->tstamp = real_clock) => fq@eth0
> >                          ^^
> >                         (a: skb->tstamp = 0)
> >
> > (a) veth@netns TX to veth@hostns:
> >     skb->tstamp (mono clock) is a EDT and it is in future time.
> >     Reset to 0 so that it won't skip the net_timestamp_check at the
> >     RX side in (b).
> > (b) RX (netif_rx) in veth@hostns:
> >     net_timestamp_check puts a current time (real clock) in skb->tstamp.
> > (c) veth@hostns forward to fq@eth0:
> >     skb->tstamp is reset back to 0 again because fq is using
> >     mono clock.
> >
> > This leads to an unstable TCP throughput issue described by Daniel in [0].
> >
> > We also have a use case that a bpf runs at ingress@veth@hostns
> > to set EDT in skb->tstamp to limit the bandwidth usage
> > of a particular netns.  This EDT currently also gets
> > reset in step (c) as described above.

[ ... ]

> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 6535294f6a48..9bf0a1e2a1bd 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -435,9 +435,17 @@ enum {
> >         /* device driver is going to provide hardware time stamp */
> >         SKBTX_IN_PROGRESS = 1 << 2,
> >
> > +       /* shinfo stores a future tx_delivery_tstamp instead of hwtstamps */
> > +       SKBTX_DELIVERY_TSTAMP = 1 << 3,
> > +
> >         /* generate wifi status information (where possible) */
> >         SKBTX_WIFI_STATUS = 1 << 4,
> >
> > +       /* skb->tstamp stored a future delivery time which
> > +        * was set by a local sk and it can be fowarded.
> > +        */
> > +       SKBTX_DELIVERY_TSTAMP_ALLOW_FWD = 1 << 5,
> > +
> >         /* generate software time stamp when entering packet scheduling */
> >         SKBTX_SCHED_TSTAMP = 1 << 6,
> >  };
> > @@ -530,7 +538,14 @@ struct skb_shared_info {
> >         /* Warning: this field is not always filled in (UFO)! */
> >         unsigned short  gso_segs;
> >         struct sk_buff  *frag_list;
> > -       struct skb_shared_hwtstamps hwtstamps;
> > +       union {
> > +               /* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
> > +                * tx_delivery_tstamp is stored instead of
> > +                * hwtstamps.
> > +                */
> 
> Should we just encode the timebase and/or type { timestamp,
> delivery_time } in th lower bits of the timestamp field? Its
> resolution is higher than actual clock precision.
In skb->tstamp ?

> > +               struct skb_shared_hwtstamps hwtstamps;
> > +               u64 tx_delivery_tstamp;
> > +       };
> >         unsigned int    gso_type;
> >         u32             tskey;
> >
> > @@ -1463,9 +1478,44 @@ static inline unsigned int skb_end_offset(const struct sk_buff *skb)
> >
> >  static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
> >  {
> > +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP)) {
> > +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP;
> > +               skb_shinfo(skb)->tx_delivery_tstamp = 0;
> > +       }
> >         return &skb_shinfo(skb)->hwtstamps;
> >  }
> >
> > +/* Caller only needs to read the hwtstamps as ktime.
> > + * To update hwtstamps,  HW device driver should call the writable
> > + * version skb_hwtstamps() that returns a pointer.
> > + */
> > +static inline ktime_t skb_hwtstamps_ktime(const struct sk_buff *skb)
> > +{
> > +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP))
> > +               return 0;
> > +       return skb_shinfo(skb)->hwtstamps.hwtstamp;
> > +}
> > +
> > +static inline void skb_scrub_tstamp(struct sk_buff *skb)
> 
> skb_save_delivery_time?
yep. ok.

> 
> is non-zero skb->tstamp test not sufficient, instead of
> SKBTX_DELIVERY_TSTAMP_ALLOW_FWD.
>
> It is if only called on the egress path. Is bpf on ingress the only
> reason for this?
Ah. ic.  meaning testing non-zero skb->tstamp and then call
skb_save_delivery_time() only during the veth-egress-path:
somewhere in veth_xmit() => veth_forward_skb() but before
skb->tstamp was reset to 0 in __dev_forward_skb().

Keep *_forward() and bpf_out_*() unchanged (i.e. keep skb->tstamp = 0)
because the skb->tstamp could be stamped by net_timestamp_check().

Then SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is not needed.

Did I understand your suggestion correctly?

However, we still need a bit to distinguish tx_delivery_tstamp
from hwtstamps.

> 
> > +{
> > +       if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
> > +               skb_shinfo(skb)->tx_delivery_tstamp = skb->tstamp;
> > +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP;
> > +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> > +       }
> 
> Is this only called when there are no clones/shares?
No, I don't think so.  TCP clone it.  I also started thinking about
this after noticing a mistake in the change in  __tcp_transmit_skb().

There are other places that change tx_flags, e.g. tcp_offload.c.
It is not shared at those places or there is some specific points
in the stack that is safe to change ?

> 
> > +       skb->tstamp = 0;
> > +}
> > +
> > +static inline void skb_restore_delivery_time(struct sk_buff *skb)
> > +{
> > +       if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP)) {
> > +               skb->tstamp = skb_shinfo(skb)->tx_delivery_tstamp;
> > +               skb_shinfo(skb)->tx_delivery_tstamp = 0;
> > +               skb_shinfo(skb)->tx_flags &= ~SKBTX_DELIVERY_TSTAMP;
> > +               skb_shinfo(skb)->tx_flags |= SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
> > +       }
> > +}
> > +
> >  static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
> >  {
> >         bool is_zcopy = skb && skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
> > diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> > index ec646656dbf1..a3ba6195f2e3 100644
> > --- a/net/bridge/br_forward.c
> > +++ b/net/bridge/br_forward.c
> > @@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(br_dev_queue_push_xmit);
> >
> >  int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
> >  {
> > -       skb->tstamp = 0;
> > +       skb_scrub_tstamp(skb);
> >         return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING,
> >                        net, sk, skb, NULL, skb->dev,
> >                        br_dev_queue_push_xmit);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index a855e41bbe39..e9e7de758cba 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
