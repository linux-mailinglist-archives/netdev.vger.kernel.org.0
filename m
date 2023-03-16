Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BF26BDADE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjCPVXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCPVXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:23:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4B126C3C;
        Thu, 16 Mar 2023 14:23:29 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GKonMq037322;
        Thu, 16 Mar 2023 21:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Jh8ZAuaeF5aIaMaD9WJLz1qBSiDwjjRX3WwRGvOI3OQ=;
 b=I9ygiKPJWqrzVWcRd5HtBzN6snu9cC5FcsOViOioP2gl4iro9dAZkP/ppxRTNWcPYvFT
 VmLymnpXRJm9MHob53Zxhj7eb9N3UdBABI7zEWCgaf3/62qF2FdBzhI2+AqgcV/WZxlJ
 MM1YbveZRtMEvv0BRnatrEmCaKodOkQ7ULBT/gLzIsgGmxamZYKOJY+XLwWbKaIESg+J
 /Eizvq1KZtUO4nHFZRIv1oH89qnV/U2BGVF2XwQZhY5YvOouxTVdhwRErsaghhkjIq+Y
 TNPU/fMwpnObMBOQttGB/ZxaL4/PYM4qxVW+Czvyl5BOyGZb0dBLNnd09qY9GQgYI/hU 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcagh0mmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 21:21:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GKpFuN038453;
        Thu, 16 Mar 2023 21:21:11 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pcagh0mka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 21:21:11 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32GIBgup027506;
        Thu, 16 Mar 2023 21:21:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3pbsyxs0du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 21:21:08 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32GLL6Wg60424492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 21:21:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B79120043;
        Thu, 16 Mar 2023 21:21:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A891020040;
        Thu, 16 Mar 2023 21:21:05 +0000 (GMT)
Received: from [9.171.2.157] (unknown [9.171.2.157])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Mar 2023 21:21:05 +0000 (GMT)
Message-ID: <5d2f728944c4763dc0a010f72dc7a19cbb66a90d.camel@linux.ibm.com>
Subject: Re: [PATCH bpf-next 1/2] bpf, test_run: fix crashes due to XDP
 frame overwriting/corruption
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
Date:   Thu, 16 Mar 2023 22:21:05 +0100
In-Reply-To: <20230316175051.922550-2-aleksander.lobakin@intel.com>
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
         <20230316175051.922550-2-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WpSHdeVU_xNiXxnOBqXKxumusxkHLuzw
X-Proofpoint-ORIG-GUID: SjUTPrTd8R0Y46Z3m4xbS-eYzrmSIkTB
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-03-16 at 18:50 +0100, Alexander Lobakin wrote:
> syzbot and Ilya faced the splats when %XDP_PASS happens for
> bpf_test_run
> after skb PP recycling was enabled for
> {__,}xdp_build_skb_from_frame():
>=20
> BUG: kernel NULL pointer dereference, address: 0000000000000d28
> RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
> [...]
> Call Trace:
> =C2=A0<TASK>
> =C2=A0__finalize_skb_around net/core/skbuff.c:321 [inline]
> =C2=A0__build_skb_around+0x232/0x3a0 net/core/skbuff.c:379
> =C2=A0build_skb_around+0x32/0x290 net/core/skbuff.c:444
> =C2=A0__xdp_build_skb_from_frame+0x121/0x760 net/core/xdp.c:622
> =C2=A0xdp_recv_frames net/bpf/test_run.c:248 [inline]
> =C2=A0xdp_test_run_batch net/bpf/test_run.c:334 [inline]
> =C2=A0bpf_test_run_xdp_live+0x1289/0x1930 net/bpf/test_run.c:362
> =C2=A0bpf_prog_test_run_xdp+0xa05/0x14e0 net/bpf/test_run.c:1418
> [...]
>=20
> This happens due to that it calls xdp_scrub_frame(), which nullifies
> xdpf->data. bpf_test_run code doesn't reinit the frame when the XDP
> program doesn't adjust head or tail. Previously, %XDP_PASS meant the
> page will be released from the pool and returned to the MM layer, but
> now it does return to the Pool with the nullified xdpf->data, which
> doesn't get reinitialized then.
> So, in addition to checking whether the head and/or tail have been
> adjusted, check also for a potential XDP frame corruption. xdpf->data
> is 100% affected and also xdpf->flags is the field closest to the
> metadata / frame start. Checking for these two should be enough for
> non-extreme cases.
>=20
> Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from
> XDP frames")
> Reported-by: syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
> Link:
> https://lore.kernel.org/bpf/000000000000f1985705f6ef2243@google.com
> Reported-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Link:
> https://lore.kernel.org/bpf/e07dd94022ad5731705891b9487cc9ed66328b94.came=
l@linux.ibm.com
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
> =C2=A0net/bpf/test_run.c | 12 +++++++++++-
> =C2=A01 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 71226f68270d..8d6b31209bd6 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -208,6 +208,16 @@ static void xdp_test_run_teardown(struct
> xdp_test_data *xdp)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(xdp->skbs);
> =C2=A0}
> =C2=A0
> +static bool frame_was_changed(const struct xdp_page_head *head)
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* xdp_scrub_frame() zeroes th=
e data pointer, flags is the
> last field,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * i.e. has the highest chance=
s to be overwritten. If those
> two are
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * untouched, it's most likely=
 safe to skip the context
> reset.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return head->frm.data !=3D hea=
d->orig_ctx.data ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 head->frm.flags !=3D head->orig_ctx.flags;
> +}
> +
> =C2=A0static bool ctx_was_changed(struct xdp_page_head *head)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return head->orig_ctx.dat=
a !=3D head->ctx.data ||
> @@ -217,7 +227,7 @@ static bool ctx_was_changed(struct xdp_page_head
> *head)
> =C2=A0
> =C2=A0static void reset_ctx(struct xdp_page_head *head)
> =C2=A0{
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (likely(!ctx_was_changed(he=
ad)))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (likely(!frame_was_changed(=
head) &&
> !ctx_was_changed(head)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0head->ctx.data =3D head->=
orig_ctx.data;

With this test begins to work on s390x:

# ./test_progs -t xdp_do_redirect
IPv6: ADDRCONF(NETDEV_CHANGE): veth_dst: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): veth_src: link becomes ready
#290     xdp_do_redirect:OK
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Thanks!

Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
