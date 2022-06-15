Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D154C25A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 09:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244653AbiFOHHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 03:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiFOHHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 03:07:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD4926AE5;
        Wed, 15 Jun 2022 00:07:51 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s37so7944297pfg.11;
        Wed, 15 Jun 2022 00:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soRJj5PAvwtD6C6Wuh+Kv4gDLUo/zLewqp84GRyjMOk=;
        b=bA7toGFK9f6DVr5OEkoSGaYonvlzMb9IVzrxp4J0dfFFRxZcP/P+6ob1TKUkTi1nmm
         PLT8Tso70ijICyx+ePVzkK/kd88lMs0QupfG9nZH8wh8GeZ8xlEGbbkXn1gwtxqdo2jI
         dbRoPj7BCIgOXWoqnfcd5m4N/mrNsE3BArW2VJI/9DA53tsGb7TeCj7CKmloOgkJtgYi
         5d2hmCbAEyv/xZhXSVpL0V+7lW603PM4/z7aLgmCItkuIIG1zPbe8IikTttzsiqKp9DR
         5gCn0uK5wH0Isvkik3gZKuKtuBR1VjTzlus+3hla3eh84MrVGVOL3uJfGbbIVkPivu0A
         bfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soRJj5PAvwtD6C6Wuh+Kv4gDLUo/zLewqp84GRyjMOk=;
        b=eB4l3Sg2cNXqdIgDoH+PUijWjDM3DeSPO8x/DgkVsraXgvfPUQPkJwBiWGt+0tbOXr
         cVZ5oZ66mO0qZa5ISYWoCE4kCGkkWPvaoDRJpL7Jajuzbnfoj+TlfxLUhQm+z29Z7F/s
         oKlGYXzp8Bt/x07naaiQVSjp9DakeChJbyQUqXGPYR9QavCnabRWGqoDCqrkcfJAct0e
         FXj5m3U1tSenmcDUI5qW/cnVAakr54+QmVMciyrqaaj4QhoY5mqK+EhM9kbBAk91U7pB
         //Bj4fX1U3WhX0toeSz7eaLtGp+uJxe9s1mvAKp1Yl5YR+7WXa4YdMqyQgVmk0+f+10G
         1Q1g==
X-Gm-Message-State: AJIora+cPYUVg0N4xK5qQiGPaJwt8LTOb9MCSQS6g9mIDTaV0D9Xov3X
        keL6SX+dbgMJPRs0huNjKGy77A09hH3NKWeU1/o=
X-Google-Smtp-Source: AGRyM1tSvzlm5HLTm5FycUzCDk9i4zJKjj7uiHLp4ai2gyZhvTG+vYuvCANdK1HqRXL9UAmt44min63ShoImQICZQDs=
X-Received: by 2002:a62:1603:0:b0:522:c66b:70ac with SMTP id
 3-20020a621603000000b00522c66b70acmr1001435pfw.83.1655276870630; Wed, 15 Jun
 2022 00:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com> <20220614174749.901044-5-maciej.fijalkowski@intel.com>
In-Reply-To: <20220614174749.901044-5-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 15 Jun 2022 09:07:39 +0200
Message-ID: <CAJ8uoz3Z-BfXOnVZwFGMbXHMs=ob+PSx8OrHcAdungbRLr3krw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 04/10] selftests: xsk: query for native XDP support
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

On Tue, Jun 14, 2022 at 7:50 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Currently, xdpxceiver assumes that underlying device supports XDP in
> native mode - it is fine by now since tests can run only on a veth pair.
> Future commit is going to allow running test suite against physical
> devices, so let us query the device if it is capable of running XDP
> programs in native mode. This way xdpxceiver will not try to run
> TEST_MODE_DRV if device being tested is not supporting it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 36 ++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index e5992a6b5e09..a1e410f6a5d8 100644
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
> @@ -1605,10 +1607,37 @@ static void ifobject_delete(struct ifobject *ifobj)
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
> +       int err;
> +
> +       prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
> +       if (prog_fd < 0)
> +               return false;
> +
> +       err = bpf_xdp_attach(ifindex, prog_fd, flags, NULL);
> +       if (err)
> +               return false;
> +
> +       bpf_xdp_detach(ifindex, flags, NULL);
> +
> +       return true;
> +}
> +
>  int main(int argc, char **argv)
>  {
>         struct pkt_stream *pkt_stream_default;
>         struct ifobject *ifobj_tx, *ifobj_rx;
> +       int modes = TEST_MODE_SKB + 1;
>         u32 i, j, failed_tests = 0;
>         struct test_spec test;
>
> @@ -1636,15 +1665,18 @@ int main(int argc, char **argv)
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
