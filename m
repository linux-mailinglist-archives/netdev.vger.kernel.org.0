Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66177654BE1
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 05:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235667AbiLWEHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 23:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiLWEHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 23:07:07 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E0A31DF3
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:07:00 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 17so3932676pll.0
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PxfXAv5q27nTofLigTAGSH2PVF7qlWOGss0Ti+Z1Ub0=;
        b=oDHOkGGEgMww7kayXKCPrPzJSTRPb3lPu7x+uOH54f7OUELE1HzG2a0dxFwQvzP8ia
         4Ycwd8R2ScrjL23rjjw8oDXkEFY5bj1GRy7rcIVCnNQUkFWI1UdBFiAWQSh25+GRCerq
         wWXd5BAPAgStJ1/sFSMoWDUOlKjUj1Kd8LC1HmLGzy/aJ9Jbrf3M0STdoQy3plvcjQJp
         0L7RNigF3fjtZJ0VmtVVM++RxHf1+NHF5TL3Zm7zHPjyKwWenpqipKrVJx6Qdl1UpIRk
         JxPwxakV1rstWOtoWSQEFK+BVd7Uox4/VVLuDf69CsCYEYnY2VjOLhkmCfOso0IIMjNg
         W2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PxfXAv5q27nTofLigTAGSH2PVF7qlWOGss0Ti+Z1Ub0=;
        b=DcxqNejK9LQ5+CWq8IjutkeIJynXTqOtrg/5cZkvBK4Ao7wXgQ2p91VW2djoQhAU9W
         HIx0JuNH+KJtohxoWPwyMzaJBznkUBbBvzH3b7EVwCOv0mY3BLdbBtQ0K3BNKF2NIAGM
         sRLu9IreTbKC0pd9H4tQaeMijXLViEo51gfSUdAQLV3RWvTnNAsPuUvj++WM7KA4j6AE
         BSXKrFQ4zULAJ4eVzA5+5Krk7IUogxEJaGU5K+RiPIahJoK/kGO/XdbnhVTROsb7RZ4M
         rOluZaFJX+weexOl/3AoAEFbfuunIJX44+1IB+athAqtV+TzZKj9uQxPwwlhJvjt3fkq
         Ik1Q==
X-Gm-Message-State: AFqh2kqihppLe9dS18MILdpBzWfdD/9At5eWoEjivhZTpc8UYmMluhBh
        Q9bB/nq1mfZJ7km8Hp5OPf2KyqrpHu1eT2gpw6s9AQ==
X-Google-Smtp-Source: AMrXdXvSjYReEzPVUPhyF/4VEVIBVTDrSyexDDsnlIlpIIrmhSoqVwLCujxOI9FOA37IbD2phTDW13z4gRFMrv2Ml8s=
X-Received: by 2002:a17:902:a506:b0:189:97e2:ab8b with SMTP id
 s6-20020a170902a50600b0018997e2ab8bmr763264plq.131.1671768419637; Thu, 22 Dec
 2022 20:06:59 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com> <20221220222043.3348718-12-sdf@google.com>
 <18bed458-0128-d434-8b7a-bf676a0ea863@linux.dev>
In-Reply-To: <18bed458-0128-d434-8b7a-bf676a0ea863@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 22 Dec 2022 20:06:48 -0800
Message-ID: <CAKH8qBst6==Rw1mQohjNimf5QZrPJ05d+XLjqyyT1W8fENNz4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 11/17] selftests/bpf: Verify xdp_metadata
 xdp->af_xdp path
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 4:40 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> > +static int open_xsk(const char *ifname, struct xsk *xsk)
> > +{
> > +     int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> > +     const struct xsk_socket_config socket_config = {
> > +             .rx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > +             .tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > +             .libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD,
> > +             .xdp_flags = XDP_FLAGS,
> > +             .bind_flags = XDP_COPY,
> > +     };
> > +     const struct xsk_umem_config umem_config = {
> > +             .fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > +             .comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
> > +             .frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE,
> > +             .flags = XDP_UMEM_UNALIGNED_CHUNK_FLAG,
> > +     };
> > +     __u32 idx;
> > +     u64 addr;
> > +     int ret;
> > +     int i;
> > +
> > +     xsk->umem_area = mmap(NULL, UMEM_SIZE, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
> > +     if (!ASSERT_NEQ(xsk->umem_area, MAP_FAILED, "mmap"))
> > +             return -1;
> > +
> > +     ret = xsk_umem__create(&xsk->umem,
> > +                            xsk->umem_area, UMEM_SIZE,
> > +                            &xsk->fill,
> > +                            &xsk->comp,
> > +                            &umem_config);
> > +     if (!ASSERT_OK(ret, "xsk_umem__create"))
> > +             return ret;
> > +
> > +     ret = xsk_socket__create(&xsk->socket, ifname, QUEUE_ID,
> > +                              xsk->umem,
> > +                              &xsk->rx,
> > +                              &xsk->tx,
> > +                              &socket_config);
> > +     if (!ASSERT_OK(ret, "xsk_socket__create"))
> > +             return ret;
> > +
> > +     /* First half of umem is for TX. This way address matches 1-to-1
> > +      * to the completion queue index.
> > +      */
> > +
> > +     for (i = 0; i < UMEM_NUM / 2; i++) {
> > +             addr = i * UMEM_FRAME_SIZE;
> > +             printf("%p: tx_desc[%d] -> %lx\n", xsk, i, addr);
>
> Do you still need this verbose printf which is in a loop?  Also, how about other
> printf in this test?

In case we'd ever need to debug this test, those printfs shouldn't
hurt, right? Or are you concerned about this test polluting the output
with something like 'test_progs -v -v' ?

> > +     }
> > +
> > +     /* Second half of umem is for RX. */
> > +
> > +     ret = xsk_ring_prod__reserve(&xsk->fill, UMEM_NUM / 2, &idx);
> > +     if (!ASSERT_EQ(UMEM_NUM / 2, ret, "xsk_ring_prod__reserve"))
> > +             return ret;
> > +     if (!ASSERT_EQ(idx, 0, "fill idx != 0"))
> > +             return -1;
> > +
> > +     for (i = 0; i < UMEM_NUM / 2; i++) {
> > +             addr = (UMEM_NUM / 2 + i) * UMEM_FRAME_SIZE;
> > +             printf("%p: rx_desc[%d] -> %lx\n", xsk, i, addr);
> > +             *xsk_ring_prod__fill_addr(&xsk->fill, i) = addr;
> > +     }
> > +     xsk_ring_prod__submit(&xsk->fill, ret);
> > +
> > +     return 0;
> > +}
> > +
>
> [ ... ]
>
> > +void test_xdp_metadata(void)
> > +{
> > +     struct xdp_metadata2 *bpf_obj2 = NULL;
> > +     struct xdp_metadata *bpf_obj = NULL;
> > +     struct bpf_program *new_prog, *prog;
> > +     struct nstoken *tok = NULL;
> > +     __u32 queue_id = QUEUE_ID;
> > +     struct bpf_map *prog_arr;
> > +     struct xsk tx_xsk = {};
> > +     struct xsk rx_xsk = {};
> > +     __u32 val, key = 0;
> > +     int retries = 10;
> > +     int rx_ifindex;
> > +     int sock_fd;
> > +     int ret;
> > +
> > +     /* Setup new networking namespace, with a veth pair. */
> > +
> > +     SYS("ip netns add xdp_metadata");
> > +     tok = open_netns("xdp_metadata");
> > +     SYS("ip link add numtxqueues 1 numrxqueues 1 " TX_NAME
> > +         " type veth peer " RX_NAME " numtxqueues 1 numrxqueues 1");
> > +     SYS("ip link set dev " TX_NAME " address 00:00:00:00:00:01");
> > +     SYS("ip link set dev " RX_NAME " address 00:00:00:00:00:02");
> > +     SYS("ip link set dev " TX_NAME " up");
> > +     SYS("ip link set dev " RX_NAME " up");
> > +     SYS("ip addr add " TX_ADDR "/" PREFIX_LEN " dev " TX_NAME);
> > +     SYS("ip addr add " RX_ADDR "/" PREFIX_LEN " dev " RX_NAME);
> > +
> > +     rx_ifindex = if_nametoindex(RX_NAME);
> > +
> > +     /* Setup separate AF_XDP for TX and RX interfaces. */
> > +
> > +     ret = open_xsk(TX_NAME, &tx_xsk);
> > +     if (!ASSERT_OK(ret, "open_xsk(TX_NAME)"))
> > +             goto out;
> > +
> > +     ret = open_xsk(RX_NAME, &rx_xsk);
> > +     if (!ASSERT_OK(ret, "open_xsk(RX_NAME)"))
> > +             goto out;
> > +
> > +     bpf_obj = xdp_metadata__open();
> > +     if (!ASSERT_OK_PTR(bpf_obj, "open skeleton"))
> > +             goto out;
> > +
> > +     prog = bpf_object__find_program_by_name(bpf_obj->obj, "rx");
> > +     bpf_program__set_ifindex(prog, rx_ifindex);
> > +     bpf_program__set_flags(prog, BPF_F_XDP_DEV_BOUND_ONLY);
> > +
> > +     if (!ASSERT_OK(xdp_metadata__load(bpf_obj), "load skeleton"))
> > +             goto out;
> > +
> > +     /* Make sure we can't add dev-bound programs to prog maps. */
> > +     prog_arr = bpf_object__find_map_by_name(bpf_obj->obj, "prog_arr");
> > +     if (!ASSERT_OK_PTR(prog_arr, "no prog_arr map"))
> > +             goto out;
> > +
> > +     val = bpf_program__fd(prog);
> > +     if (!ASSERT_ERR(bpf_map__update_elem(prog_arr, &key, sizeof(key),
> > +                                          &val, sizeof(val), BPF_ANY),
> > +                     "update prog_arr"))
> > +             goto out;
> > +
> > +     /* Attach BPF program to RX interface. */
> > +
> > +     ret = bpf_xdp_attach(rx_ifindex,
> > +                          bpf_program__fd(bpf_obj->progs.rx),
> > +                          XDP_FLAGS, NULL);
> > +     if (!ASSERT_GE(ret, 0, "bpf_xdp_attach"))
> > +             goto out;
> > +
> > +     sock_fd = xsk_socket__fd(rx_xsk.socket);
> > +     ret = bpf_map_update_elem(bpf_map__fd(bpf_obj->maps.xsk), &queue_id, &sock_fd, 0);
> > +     if (!ASSERT_GE(ret, 0, "bpf_map_update_elem"))
> > +             goto out;
> > +
> > +     /* Send packet destined to RX AF_XDP socket. */
> > +     if (!ASSERT_GE(generate_packet(&tx_xsk, AF_XDP_CONSUMER_PORT), 0,
> > +                    "generate AF_XDP_CONSUMER_PORT"))
> > +             goto out;
> > +
> > +     /* Verify AF_XDP RX packet has proper metadata. */
> > +     if (!ASSERT_GE(verify_xsk_metadata(&rx_xsk), 0,
> > +                    "verify_xsk_metadata"))
> > +             goto out;
> > +
> > +     complete_tx(&tx_xsk);
> > +
> > +     /* Make sure freplace correctly picks up original bound device
> > +      * and doesn't crash.
> > +      */
> > +
> > +     bpf_obj2 = xdp_metadata2__open();
> > +     if (!ASSERT_OK_PTR(bpf_obj2, "open skeleton"))
> > +             goto out;
> > +
> > +     new_prog = bpf_object__find_program_by_name(bpf_obj2->obj, "freplace_rx");
> > +     bpf_program__set_attach_target(new_prog, bpf_program__fd(prog), "rx");
> > +
> > +     if (!ASSERT_OK(xdp_metadata2__load(bpf_obj2), "load freplace skeleton"))
> > +             goto out;
> > +
> > +     if (!ASSERT_OK(xdp_metadata2__attach(bpf_obj2), "attach freplace"))
> > +             goto out;
> > +
> > +     /* Send packet to trigger . */
> > +     if (!ASSERT_GE(generate_packet(&tx_xsk, AF_XDP_CONSUMER_PORT), 0,
> > +                    "generate freplace packet"))
> > +             goto out;
> > +
> > +     while (!retries--) {
> > +             if (bpf_obj2->bss->called)
> > +                     break;
> > +             usleep(10);
> > +     }
> > +     ASSERT_GT(bpf_obj2->bss->called, 0, "not called");
> > +
> > +out:
> > +     close_xsk(&rx_xsk);
> > +     close_xsk(&tx_xsk);
> > +     if (bpf_obj2)
>
> nit. no need to test NULL.  xdp_metadata2__destroy() can handle it.

SG, thanks!

> > +             xdp_metadata2__destroy(bpf_obj2);
> > +     if (bpf_obj)
>
> Same here.
>
> > +             xdp_metadata__destroy(bpf_obj);
> > +     system("ip netns del xdp_metadata");
>
> didn't know netns can be deleted before close_netns(tok).  Can you double check?

Should probably work because 'ip netns del' just unlinks the netns fd?
But let's properly reoder.


> > +     if (tok)
> > +             close_netns(tok);
> > +}
>
>
