Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000FA4D1ADA
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347621AbiCHOmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347618AbiCHOmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:42:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DED6443E5
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 06:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646750505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DI69tMMzlUqpESt59NcJuKSIbeHnPGzsNZYthyzr+S4=;
        b=ATk+ivhL2oE/ov+nX9BHACBs+jw6cVuZjIycGKRjfSiejLD2B7n79PNMCafaHu8YiWYmSm
        6Z2tkLDTwDTsia66ji2dBxtNm02n3R0ljfi5cwtJhpeJTmA9DE33tEs7GPqSx7FtXDhM+x
        OQVvlZK5dLRk1neqr7kNvwMlbdInNC8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-uU6sX8sEPWuaetmuWxU5oA-1; Tue, 08 Mar 2022 09:41:44 -0500
X-MC-Unique: uU6sX8sEPWuaetmuWxU5oA-1
Received: by mail-ej1-f70.google.com with SMTP id le4-20020a170907170400b006dab546bc40so5534913ejc.15
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 06:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DI69tMMzlUqpESt59NcJuKSIbeHnPGzsNZYthyzr+S4=;
        b=nDd+3JOj7ZNtk39nKJO12W/ykgInxwHz9APGyjXhE7G8dxsf4SZzuSX5yshRyteSbw
         NBLvyA3Lpry2Lv4tl1tRnedOK+nSY4XvTYd0iSNVxDQag9phhls3vvDScgbdDAaskCgW
         JpFRKKjIxA2WFfSFBjXXpCqGagHg3zDRZwtLPuhA70boFmqiup0ekphdSbS1YjAAwidq
         TCR5h2xDYZhoJbVqyadcBL5Thvw3BnZqLi4uZKMpBrIpxkvxv2WU37Gi/OuF7Dh+RFTT
         VLFtc0t1MW35UDrGjGQgyWlOjpgdLRQRhuFSmMzQrEWn3CLI6rEBwyQM95MNrnqJDE05
         1Nxw==
X-Gm-Message-State: AOAM531aVI5ZWodLkJhZF3PUJjN2MmKiJ5srUno4JinKKOcfE110605g
        lDI9fwFyANsig4jt/wLX6juTnP8IeuljDKfT50Ztw543cEK9gxkZTUzbxCY/pY8ALNYRtAekN8G
        pP+5YXuM1V6gDuYPj
X-Received: by 2002:a05:6402:1387:b0:416:2747:266e with SMTP id b7-20020a056402138700b004162747266emr14825892edv.409.1646750502841;
        Tue, 08 Mar 2022 06:41:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEw7uYlSUwUYv5j05uk4m3uD9fxgXLyRpkBcsSny7FYz7WuNyEszkwG5+eDyimCdr1fObNWA==
X-Received: by 2002:a05:6402:1387:b0:416:2747:266e with SMTP id b7-20020a056402138700b004162747266emr14825855edv.409.1646750502420;
        Tue, 08 Mar 2022 06:41:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id fq6-20020a1709069d8600b006db088ca6d0sm3414142ejc.126.2022.03.08.06.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 06:41:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6A2201928C9; Tue,  8 Mar 2022 15:41:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 5/5] selftests/bpf: Add selftest for
 XDP_REDIRECT in BPF_PROG_RUN
In-Reply-To: <20220308055959.ltrzq3kkq7joslv2@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-6-toke@redhat.com>
 <20220308055959.ltrzq3kkq7joslv2@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Mar 2022 15:41:41 +0100
Message-ID: <874k48y09m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Sun, Mar 06, 2022 at 11:34:04PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>
>> +#define NUM_PKTS 1000000
> It took my qemu 30s to run.
> Would it have the same test coverage by lowering it to something
> like 10000  ?

Yikes! Sure, that should be fine I think!

>> +void test_xdp_do_redirect(void)
>> +{
>> +	int err, xdp_prog_fd, tc_prog_fd, ifindex_src, ifindex_dst;
>> +	char data[sizeof(pkt_udp) + sizeof(__u32)];
>> +	struct test_xdp_do_redirect *skel =3D NULL;
>> +	struct nstoken *nstoken =3D NULL;
>> +	struct bpf_link *link;
>> +
>> +	struct xdp_md ctx_in =3D { .data =3D sizeof(__u32),
>> +				 .data_end =3D sizeof(data) };
>> +	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
>> +			    .data_in =3D &data,
>> +			    .data_size_in =3D sizeof(data),
>> +			    .ctx_in =3D &ctx_in,
>> +			    .ctx_size_in =3D sizeof(ctx_in),
>> +			    .flags =3D BPF_F_TEST_XDP_LIVE_FRAMES,
>> +			    .repeat =3D NUM_PKTS,
>> +			    .batch_size =3D 64,
>> +		);
>> +	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
>> +			    .attach_point =3D BPF_TC_INGRESS);
>> +
>> +	memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
>> +	*((__u32 *)data) =3D 0x42; /* metadata test value */
>> +
>> +	skel =3D test_xdp_do_redirect__open();
>> +	if (!ASSERT_OK_PTR(skel, "skel"))
>> +		return;
>> +
>> +	/* The XDP program we run with bpf_prog_run() will cycle through all
>> +	 * three xmit (PASS/TX/REDIRECT) return codes starting from above, and
>> +	 * ending up with PASS, so we should end up with two packets on the dst
>> +	 * iface and NUM_PKTS-2 in the TC hook. We match the packets on the UDP
>> +	 * payload.
>> +	 */
>> +	SYS("ip netns add testns");
>> +	nstoken =3D open_netns("testns");
>> +	if (!ASSERT_OK_PTR(nstoken, "setns"))
>> +		goto out;
>> +
>> +	SYS("ip link add veth_src type veth peer name veth_dst");
>> +	SYS("ip link set dev veth_src address 00:11:22:33:44:55");
>> +	SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
>> +	SYS("ip link set dev veth_src up");
>> +	SYS("ip link set dev veth_dst up");
>> +	SYS("ip addr add dev veth_src fc00::1/64");
>> +	SYS("ip addr add dev veth_dst fc00::2/64");
>> +	SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb");
>> +
>> +	/* We enable forwarding in the test namespace because that will cause
>> +	 * the packets that go through the kernel stack (with XDP_PASS) to be
>> +	 * forwarded back out the same interface (because of the packet dst
>> +	 * combined with the interface addresses). When this happens, the
>> +	 * regular forwarding path will end up going through the same
>> +	 * veth_xdp_xmit() call as the XDP_REDIRECT code, which can cause a
>> +	 * deadlock if it happens on the same CPU. There's a local_bh_disable()
>> +	 * in the test_run code to prevent this, but an earlier version of the
>> +	 * code didn't have this, so we keep the test behaviour to make sure t=
he
>> +	 * bug doesn't resurface.
>> +	 */
>> +	SYS("sysctl -qw net.ipv6.conf.all.forwarding=3D1");
>> +
>> +	ifindex_src =3D if_nametoindex("veth_src");
>> +	ifindex_dst =3D if_nametoindex("veth_dst");
>> +	if (!ASSERT_NEQ(ifindex_src, 0, "ifindex_src") ||
>> +	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
>> +		goto out;
>> +
>> +	memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
>> +	skel->rodata->ifindex_out =3D ifindex_src; /* redirect back to the sam=
e iface */
>> +	skel->rodata->ifindex_in =3D ifindex_src;
>> +	ctx_in.ingress_ifindex =3D ifindex_src;
>> +	tc_hook.ifindex =3D ifindex_src;
>> +
>> +	if (!ASSERT_OK(test_xdp_do_redirect__load(skel), "load"))
>> +		goto out;
>> +
>> +	link =3D bpf_program__attach_xdp(skel->progs.xdp_count_pkts, ifindex_d=
st);
>> +	if (!ASSERT_OK_PTR(link, "prog_attach"))
>> +		goto out;
>> +	skel->links.xdp_count_pkts =3D link;
>> +
>> +	tc_prog_fd =3D bpf_program__fd(skel->progs.tc_count_pkts);
>> +	if (attach_tc_prog(&tc_hook, tc_prog_fd))
>> +		goto out;
>> +
>> +	xdp_prog_fd =3D bpf_program__fd(skel->progs.xdp_redirect);
>> +	err =3D bpf_prog_test_run_opts(xdp_prog_fd, &opts);
>> +	if (!ASSERT_OK(err, "prog_run"))
>> +		goto out_tc;
>> +
>> +	/* wait for the packets to be flushed */
>> +	kern_sync_rcu();
>> +
>> +	/* There will be one packet sent through XDP_REDIRECT and one through
>> +	 * XDP_TX; these will show up on the XDP counting program, while the
>> +	 * rest will be counted at the TC ingress hook (and the counting progr=
am
>> +	 * resets the packet payload so they don't get counted twice even thou=
gh
>> +	 * they are re-xmited out the veth device
>> +	 */
>> +	ASSERT_EQ(skel->bss->pkts_seen_xdp, 2, "pkt_count_xdp");
>> +	ASSERT_EQ(skel->bss->pkts_seen_tc, NUM_PKTS - 2, "pkt_count_tc");
>> +
>> +out_tc:
>> +	bpf_tc_hook_destroy(&tc_hook);
>> +out:
>> +	if (nstoken)
>> +		close_netns(nstoken);
>> +	system("ip netns del testns");
>> +	test_xdp_do_redirect__destroy(skel);
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/=
tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>> new file mode 100644
>> index 000000000000..d785f48304ea
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>> @@ -0,0 +1,92 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <vmlinux.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +#define ETH_ALEN 6
>> +#define HDR_SZ (sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + sizeof=
(struct udphdr))
>> +const volatile int ifindex_out;
>> +const volatile int ifindex_in;
>> +const volatile __u8 expect_dst[ETH_ALEN];
>> +volatile int pkts_seen_xdp =3D 0;
>> +volatile int pkts_seen_tc =3D 0;
>> +volatile int retcode =3D XDP_REDIRECT;
>> +
>> +SEC("xdp")
>> +int xdp_redirect(struct xdp_md *xdp)
>> +{
>> +	__u32 *metadata =3D (void *)(long)xdp->data_meta;
>> +	void *data_end =3D (void *)(long)xdp->data_end;
>> +	void *data =3D (void *)(long)xdp->data;
>> +
>> +	__u8 *payload =3D data + HDR_SZ;
>> +	int ret =3D retcode;
>> +
>> +	if (payload + 1 > data_end)
>> +		return XDP_ABORTED;
>> +
>> +	if (xdp->ingress_ifindex !=3D ifindex_in)
>> +		return XDP_ABORTED;
>> +
>> +	if (metadata + 1 > data)
>> +		return XDP_ABORTED;
>> +
>> +	if (*metadata !=3D 0x42)
>> +		return XDP_ABORTED;
>> +
>> +	*payload =3D 0x42;
> nit. How about also adding a pkts_seen_zero counter here, like
> 	if (*payload =3D=3D 0) {
> 		*payload =3D 0x42;
> 		pkts_seen_zero++;
> 	}
>
> and add ASSERT_EQ(skel->bss->pkts_seen_zero, 2, "pkt_count_zero")
> to the prog_tests.  It can better show the recycled page's data
> is not re-initialized.

Good idea, will add!

>> +
>> +	if (bpf_xdp_adjust_meta(xdp, 4))
>> +		return XDP_ABORTED;
>> +
>> +	if (retcode > XDP_PASS)
>> +		retcode--;
>> +
>> +	if (ret =3D=3D XDP_REDIRECT)
>> +		return bpf_redirect(ifindex_out, 0);
>> +
>> +	return ret;
>> +}
>> +
>> +static bool check_pkt(void *data, void *data_end)
>> +{
>> +	struct ipv6hdr *iph =3D data + sizeof(struct ethhdr);
>> +	__u8 *payload =3D data + HDR_SZ;
>> +
>> +	if (payload + 1 > data_end)
>> +		return false;
>> +
>> +	if (iph->nexthdr !=3D IPPROTO_UDP || *payload !=3D 0x42)
>> +		return false;
>> +
>> +	/* reset the payload so the same packet doesn't get counted twice when
>> +	 * it cycles back through the kernel path and out the dst veth
>> +	 */
>> +	*payload =3D 0;
>> +	return true;
>> +}
>> +
>> +SEC("xdp")
>> +int xdp_count_pkts(struct xdp_md *xdp)
>> +{
>> +	void *data =3D (void *)(long)xdp->data;
>> +	void *data_end =3D (void *)(long)xdp->data_end;
>> +
>> +	if (check_pkt(data, data_end))
>> +		pkts_seen_xdp++;
>> +
>> +	return XDP_DROP;
> nit.  A comment here will be useful to explain XDP_DROP from
> the xdp@veth@ingress will put the page back to the recycle
> pool, which will be similar to xmit-ing out of a real NIC.

Sure, can do.

-Toke

