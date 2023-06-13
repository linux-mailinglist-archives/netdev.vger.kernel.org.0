Return-Path: <netdev+bounces-10426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9989B72E690
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABD631C20C9C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69FC39240;
	Tue, 13 Jun 2023 15:03:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8758D23DB;
	Tue, 13 Jun 2023 15:03:50 +0000 (UTC)
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE982E62;
	Tue, 13 Jun 2023 08:03:45 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-19f8af9aa34so4049683fac.1;
        Tue, 13 Jun 2023 08:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686668625; x=1689260625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+NmzeiFZymtpxKfoYzuxJZI1v3B56y6fjjNRZHsSIM=;
        b=Tb8QiSOnzqYDDZzoP2MPTk9mMq8sNQ9ZmR0V3ilCGv9K9TwdyJHWIT3+VXlw3h9jzf
         JQ7faoJlnrmnbyoiN+YTW9ehJbqrSBVR+XWddneUm17gdpypBmTlbHpqoYdLATyEqthh
         LaTlMU1M8iaIMUud81TcGExl4eNxhYVoUdX3oouX0DYpar5ZSh/cpC9lTZKTUVmSyegc
         58GUNh+ybWMtw30vxlHyDcN4T2MUPXPutTsVxYBZD8k4L/QdunsGA2RkzcPzgSMQhiKl
         SqpVqYY/PQnNtGhD5hiKSRlno8gNjZ/ZTLjVT6nTaHoBTb4i/BpjY8VZL6iQTAN/z3FW
         5yFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686668625; x=1689260625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E+NmzeiFZymtpxKfoYzuxJZI1v3B56y6fjjNRZHsSIM=;
        b=BexhcPDiPbcM8dRFbq31KNR63xcQCdNMMKbUG8fnIHIhEa5FwMX+wCTL0kZhl/co/V
         hKAEn4aoK+4vjqk90GPNM5hjtMZvhYGaHNHIKnKc9IR8mnmli0GBDVOPVYWmN5TFWkpS
         dMjt0sNXJXlYv4uMaKQWEzruHz23CspaGaNGgm5Nl+oUm8IHo4dQD6/hdRcFeRN4fGFv
         Vm5uwvZEoGt2O5MuXw2bxM9xu+E7T8wWIuRQXqxRWyiTjVQgU5eFWQwDfrSRNlCOIg0Y
         ZI4DkPwI/hVFGFe/Vjh3ln3RplTQjsPA1SYiasVchmFyZQtvnlmBacMWe8cQmdJbQNiK
         zp9w==
X-Gm-Message-State: AC+VfDzXqNvVZqNriOqgmDveu1TfHxrmJQeO6vZvBStW9yIPX9cQxKig
	ufu0irmvOTG9z08jQGEYfQ7dLSiuBvOCe6tuifY=
X-Google-Smtp-Source: ACHHUZ5uGzWE2Q470MqvlhXdE/PRcOQ4sSKiMKOgCAaS/dkFE/X7g8YWNhfVhA/bGlRlmF77e9inCk3CAywA+6xnPFo=
X-Received: by 2002:a05:6808:a1b:b0:39b:8121:4e35 with SMTP id
 n27-20020a0568080a1b00b0039b81214e35mr6887087oij.1.1686668625010; Tue, 13 Jun
 2023 08:03:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-8-sdf@google.com>
In-Reply-To: <20230612172307.3923165-8-sdf@google.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 13 Jun 2023 17:03:08 +0200
Message-ID: <CAF=yD-LgMsmXgQkg=gTnknnppM7CrUVRD8Wg-9XcdvB3PY8wAg@mail.gmail.com>
Subject: Re: [RFC bpf-next 7/7] selftests/bpf: extend xdp_hw_metadata with
 devtx kfuncs
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 7:26=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> When we get packets on port 9091, we swap src/dst and send it out.
> At this point, we also request the timestamp and plumb it back
> to the userspace. The userspace simply prints the timestamp.
>
> Haven't really tested, still working on mlx5 patches...
>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>


> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> @@ -10,7 +10,8 @@
>   *   - rx_hash
>   *
>   * TX:
> - * - TBD
> + * - UDP 9091 packets trigger TX reply

This branch on port is missing?

> +static void ping_pong(struct xsk *xsk, void *rx_packet)
> +{
> +       struct ipv6hdr *ip6h =3D NULL;
> +       struct iphdr *iph =3D NULL;
> +       struct xdp_desc *tx_desc;
> +       struct udphdr *udph;
> +       struct ethhdr *eth;
> +       void *data;
> +       __u32 idx;
> +       int ret;
> +       int len;
> +
> +       ret =3D xsk_ring_prod__reserve(&xsk->tx, 1, &idx);
> +       if (ret !=3D 1) {
> +               printf("%p: failed to reserve tx slot\n", xsk);
> +               return;
> +       }
> +
> +       tx_desc =3D xsk_ring_prod__tx_desc(&xsk->tx, idx);
> +       tx_desc->addr =3D idx % (UMEM_NUM / 2) * UMEM_FRAME_SIZE;
> +       data =3D xsk_umem__get_data(xsk->umem_area, tx_desc->addr);
> +
> +       eth =3D data;
> +
> +       if (eth->h_proto =3D=3D htons(ETH_P_IP)) {
> +               iph =3D (void *)(eth + 1);
> +               udph =3D (void *)(iph + 1);
> +       } else if (eth->h_proto =3D=3D htons(ETH_P_IPV6)) {
> +               ip6h =3D (void *)(eth + 1);
> +               udph =3D (void *)(ip6h + 1);
> +       } else {
> +               xsk_ring_prod__cancel(&xsk->tx, 1);
> +               return;
> +       }
> +
> +       len =3D ETH_HLEN;
> +       if (ip6h)
> +               len +=3D ntohs(ip6h->payload_len);

sizeof(*ip6h) + ntohs(ip6h->payload_len) ?

> +       if (iph)
> +               len +=3D ntohs(iph->tot_len);
> +
> +       memcpy(data, rx_packet, len);
> +       swap(eth->h_dest, eth->h_source, ETH_ALEN);
> +       if (iph)
> +               swap(&iph->saddr, &iph->daddr, 4);

need to recompute ipv4 checksum?

