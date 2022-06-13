Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF95483D8
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 12:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239948AbiFMJrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 05:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbiFMJrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 05:47:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AB318364;
        Mon, 13 Jun 2022 02:47:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso7935437pjb.0;
        Mon, 13 Jun 2022 02:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tMhF7UpFyMXPAr4OwfDi4X/Mo5y4My8mdBCRAqnUwMU=;
        b=QyBkOmBNdFyl4YRcjSTNDoaa9Kdd9Oy2z9OfMbS28uuaXEQrUTMNT5LCmjR5Z3XX7n
         MXV2NI6+DzHW+9/05omSg7+etQo8QA7IRX4K0+8UHM6tpHRxicIzY5IZxDMFijbZkf9W
         BrkkcIBbT37V7tQMVEo3swWuh8wMNAdagEGPcQX7LfP7w2RZOeCbk4tuuzKscaSjos4Q
         GPiJ+mhqAhMb+s3nqL/QQ+DJe4T2wNBaCosKGSerA8YJYYSdFPimA14A1Kg0qIthHEzB
         6wRHvD8HF3RSBDGfqa90UYZI5FjTrRWO/TPEvKhsit2IQvC2n+YzN+xH3+pIrhb3CUyt
         sN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tMhF7UpFyMXPAr4OwfDi4X/Mo5y4My8mdBCRAqnUwMU=;
        b=P2ju/B2+fNRivXm/rl1hD1B7CdIL09Un8wLpYO/Ckp2lbtNGS/kIYduPObsm2CHTx/
         +YtrN7HYpzzwRKfGJ1v4k4J04DuEmxiF+lN/SDFoZKmmVPdFqms5zI99EDQXcJTUsXtB
         IRaHMh7W76tzBGX9KD7PwnlfyhNxi/TpfcUchohuzPtyP+VIB5BMQ8hoPR5V+lQrurKk
         weMiBeR0txt9U2YvZFC0puFo30uAt95XMPL25nRm9rgxLCXepZR+83FBebH1PbBXuuWP
         FdWYjdBi0qzFkc+hsnnDF8jOV4qNp8ir/sCwdweQGbkl4eg0Qw3H5OPZvfCSvwAMf8ZU
         SC5Q==
X-Gm-Message-State: AOAM533VwsAQLNV2luJN0qBd7MFdhI2Upb/22ejfbhZu4v6v5+VzmUxp
        HYf9uDxln2arc4kMSIfT8XcTCREjaogT9Sy5emU=
X-Google-Smtp-Source: ABdhPJxhOoHeUYbl3XkTh1JeIZv7cQH37VYq3JWfb0Ajsls1DMDxhUoRbSbphQDUwfu1e+bLB8m5RtM+lMdbiIXsm0A=
X-Received: by 2002:a17:90b:350d:b0:1e6:7780:6c92 with SMTP id
 ls13-20020a17090b350d00b001e677806c92mr14851809pjb.46.1655113648881; Mon, 13
 Jun 2022 02:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-5-maciej.fijalkowski@intel.com>
In-Reply-To: <20220610150923.583202-5-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Jun 2022 11:47:17 +0200
Message-ID: <CAJ8uoz3vd_Qhe9=oixMfq6zyuaHBwrQZvSQpU3OYA4Oh-9wmnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 04/10] selftests: xsk: query for native XDP support
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 5:15 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Currently, xdpxceiver assumes that underlying device supports XDP in
> native mode - it is fine by now since tests can run only on a veth pair.
> Future commit is going to allow running test suite against physical
> devices, so let us query the device if it is capable of running XDP
> programs in native mode. This way xdpxceiver will not try to run
> TEST_MODE_DRV if device being tested is not supporting it.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 38 ++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index e5992a6b5e09..da8098f1b655 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -98,6 +98,8 @@
>  #include <unistd.h>
>  #include <stdatomic.h>
>  #include <bpf/xsk.h>
> +#include <bpf/bpf.h>
> +#include <linux/filter.h>
>  #include "xdpxceiver.h"
>  #include "../kselftest.h"
>
> @@ -1605,10 +1607,39 @@ static void ifobject_delete(struct ifobject *ifobj)
>         free(ifobj);
>  }
>
> +static bool is_xdp_supported(struct ifobject *ifobject)
> +{
> +       int flags = XDP_FLAGS_DRV_MODE;
> +
> +       LIBBPF_OPTS(bpf_link_create_opts, opts, .flags = flags);
> +       struct bpf_insn insns[2] = {
> +               BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
> +               BPF_EXIT_INSN()
> +       };
> +       int ifindex = if_nametoindex(ifobject->ifname);
> +       int prog_fd, insn_cnt = ARRAY_SIZE(insns);
> +       bool ret = false;
> +       int err;
> +
> +       prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
> +       if (prog_fd < 0)
> +               return ret;
> +
> +       err = bpf_xdp_attach(ifindex, prog_fd, flags, NULL);
> +
> +       if (!err) {
> +               ret = true;
> +               bpf_xdp_detach(ifindex, flags, NULL);
> +       }
> +
> +       return ret;

Think it would be clearer if you got rid of the bool ret and just
wrote "return false" and "return true" where applicable.

> +}
> +
>  int main(int argc, char **argv)
>  {
>         struct pkt_stream *pkt_stream_default;
>         struct ifobject *ifobj_tx, *ifobj_rx;
> +       int modes = TEST_MODE_SKB + 1;

Why not keep it a u32? A nit in any way.

>         u32 i, j, failed_tests = 0;
>         struct test_spec test;
>
> @@ -1636,15 +1667,18 @@ int main(int argc, char **argv)
>         init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
>                    worker_testapp_validate_rx);
>
> +       if (is_xdp_supported(ifobj_tx))
> +               modes++;
> +
>         test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
>         pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
>         if (!pkt_stream_default)
>                 exit_with_error(ENOMEM);
>         test.pkt_stream_default = pkt_stream_default;
>
> -       ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
> +       ksft_set_plan(modes * TEST_TYPE_MAX);
>
> -       for (i = 0; i < TEST_MODE_MAX; i++)
> +       for (i = 0; i < modes; i++)
>                 for (j = 0; j < TEST_TYPE_MAX; j++) {
>                         test_spec_init(&test, ifobj_tx, ifobj_rx, i);
>                         run_pkt_test(&test, i, j);
> --
> 2.27.0
>
