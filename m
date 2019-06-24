Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B6A50E1D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfFXOcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:32:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38739 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFXOcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:32:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so3432615qtl.5;
        Mon, 24 Jun 2019 07:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ctFjDCzhggvVXefGJm4hCGvB8upg6mpaGEDe91Sd9LA=;
        b=kYJvjoQR7lhZe1qJG+X81nw9eg9atRS+11KNat1Arg+wqTqhqZlp1CRvz4RXseIRCa
         ZE3ZnwOdwsnWlc6n8qwdekXlvWzlm56cKNoQrVKbBrx1fbrDHjuy5YakndF46g+P8t3i
         4GYHiGsL4f8iUPT3PzkyN/L+QC6kE+umsIMYRG9nZa9EKL9I/nGARi8W1te4N3S3JmC/
         sTK0RjEUsXmRPLArIyIyQj7K066C6FYwh7bMzrBXn3exkt3HMh5h6Bmm/0/xUfc3oCya
         LFTZZhkn4FDcZufCQxyJ2qDs8nmNNMjng9zoDy21WdCa1eBj40Xh7saGtrvu2HhAiHWx
         zFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ctFjDCzhggvVXefGJm4hCGvB8upg6mpaGEDe91Sd9LA=;
        b=T43Euev24cul83aPLEs0/5fc6BrigPVf/fOw0hiqoNxXjH7UzGyLqAF5SyfYqoHRoM
         BVjkobBABTM2hLZ3fJNlGAIPtrVt68mUi6rNA2YuB76zu+WVt5bcwyXIdxadj7/NIa3/
         FRt0DBCUOrk0x2pLOwKBYVIDG8vEh3BA46eYtXuoo8XOLAFsh98KiVC+d/t+gMQJ6Z24
         v1R4vHJkUD/PNu+e6UOztteUEctKCouRLlLzftCnWj7YCcHS605WxGiBPB/tAMakZaLw
         bCLfZSG07aOKzlYb9916OaCybWlEKkHE6Dm1O2ocIN8Vt8h00hkgPIeIQipUMuHI35Je
         8tog==
X-Gm-Message-State: APjAAAUx8TC72DTbtY5OX3c50hECdiItyqfDZqiycEuqSFqoOnWX/TEl
        aUJ43ew4bjrIARMRPe82pWk/0hh4oRPnCXhhIFM=
X-Google-Smtp-Source: APXvYqz2ivGbven9zWTQ+Nqz8yp8WiF8tnns7upW8xDvZ3E0XTfPTmThwDw8gMBMvxG6UuEnNmFDPUjLb8X3lND95yE=
X-Received: by 2002:ac8:2f07:: with SMTP id j7mr118604479qta.359.1561386754593;
 Mon, 24 Jun 2019 07:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-5-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-5-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 16:32:23 +0200
Message-ID: <CAJ+HfNibp3x7dYav4Ps8USEDhWgxnm8o=DXVBz8qZTn3NDc_=Q@mail.gmail.com>
Subject: Re: [PATCH 04/11] i40e: add offset to zca_free
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch adds the offset param to for zero_copy_allocator to
> i40e_zca_free. This change is required to calculate the handle, otherwise=
,
> this function will not work in unaligned chunk mode since we can't easily=
 mask
> back to the original handle in unaligned chunk mode.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 8 ++++----
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h | 3 ++-
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.c
> index c89e692e8663..8c281f356293 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
> @@ -438,16 +438,16 @@ static void i40e_reuse_rx_buffer_zc(struct i40e_rin=
g *rx_ring,
>   * @alloc: Zero-copy allocator
>   * @handle: Buffer handle
>   **/
> -void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long hand=
le)
> +void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long hand=
le,
> +               off_t off)
>  {
>         struct i40e_rx_buffer *bi;
>         struct i40e_ring *rx_ring;
> -       u64 hr, mask;
> +       u64 hr;
>         u16 nta;
>
>         rx_ring =3D container_of(alloc, struct i40e_ring, zca);
>         hr =3D rx_ring->xsk_umem->headroom + XDP_PACKET_HEADROOM;
> -       mask =3D rx_ring->xsk_umem->chunk_mask;
>
>         nta =3D rx_ring->next_to_alloc;
>         bi =3D &rx_ring->rx_bi[nta];
> @@ -455,7 +455,7 @@ void i40e_zca_free(struct zero_copy_allocator *alloc,=
 unsigned long handle)
>         nta++;
>         rx_ring->next_to_alloc =3D (nta < rx_ring->count) ? nta : 0;
>
> -       handle &=3D mask;
> +       handle -=3D off;
>
>         bi->dma =3D xdp_umem_get_dma(rx_ring->xsk_umem, handle);
>         bi->dma +=3D hr;
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/eth=
ernet/intel/i40e/i40e_xsk.h
> index 8cc0a2e7d9a2..85691dc9ac42 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> @@ -12,7 +12,8 @@ int i40e_queue_pair_disable(struct i40e_vsi *vsi, int q=
ueue_pair);
>  int i40e_queue_pair_enable(struct i40e_vsi *vsi, int queue_pair);
>  int i40e_xsk_umem_setup(struct i40e_vsi *vsi, struct xdp_umem *umem,
>                         u16 qid);
> -void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long hand=
le);
> +void i40e_zca_free(struct zero_copy_allocator *alloc, unsigned long hand=
le,
> +               off_t off);
>  bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 cleaned_cou=
nt);
>  int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
>
> --
> 2.17.1
>
