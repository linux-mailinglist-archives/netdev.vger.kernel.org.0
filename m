Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C3B151BE
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfEFQfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:35:38 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34662 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfEFQfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:35:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id b3so7063944pfd.1;
        Mon, 06 May 2019 09:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=vsprXKYMuepEIEMsZfcfdZhuh/X5MIMuGXDVOD/tBIE=;
        b=fUvcuW/zcbdyS0NwPGDmV+r2C6T4ieb9otKBUbjUWi/+pdXzcIdpHhlnt+ToopkteU
         uZkErV7s9i1xWdVEoE5HSHDF7vkkVkwinqGSy4BeN8pBY1RSEw5lpDOhMQtEnRr6C3St
         vqsnDLotSgXOKc+kUnLcnrVC2EMn4MuRz6JHhQGr2kYo82Hade8TQReiIfAohLb7jGGj
         b9WrJ5s3iHssSPp8K4DvkRYJJ4jyQVjsSdwd0ywsPRTzsfztbr/mmqe4zKQNadcTG8pd
         xvl6jm6A91C7AzsxWIobjT4+XZH4vQAdqnxALwtr0gsv3XQXlHtWfrvq3kaXAjoZShsq
         7UWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vsprXKYMuepEIEMsZfcfdZhuh/X5MIMuGXDVOD/tBIE=;
        b=JcJWu6bEZ/Tf1ZMjx/ns1gxucWbD/FgFXJ2CpXgQ+LVz232YIhK4/8Af8mVP5kVhH9
         i5UU2krw2/tVnTipPZOHFWroRLOKsWsHBKTXLHUjfaN9fqwEnepVmn+bkpsf7FK5q59P
         jymu5iqCJfMRdR+GIUirB8WxtG05yxHqAaojfZMgdWx/Ay8Sm8VWKyWr8YDCeQr7o/P3
         jarxplmd5xjZHn++C4CVTka7mTQ8SaHn4RHtQNdYiOcKmauy0rwKGPTCuJTBXr/bJmpX
         zIDIThWh4Q3i+no5d8riSZ1WJK1PsypYkQ5jStefLTx8O2OuJwXUk4Xb/K7HXn8+ES0J
         PkJA==
X-Gm-Message-State: APjAAAXuvwQDWbPkwLRgls1Ql91wvMsQqMNBFGfEZeQMMKnKmKtI3zby
        G39DR54SKvezOTzHil5pFe8=
X-Google-Smtp-Source: APXvYqxtpzqbx31QR4OaMYVYd5JsRqiCX0c3ZU9bIyAvXqlroT+zv2cDeCMtns8OmVPK7aVbOy+wIg==
X-Received: by 2002:aa7:8e59:: with SMTP id d25mr33965721pfr.24.1557160536066;
        Mon, 06 May 2019 09:35:36 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:1919])
        by smtp.gmail.com with ESMTPSA id i75sm17457325pfj.80.2019.05.06.09.35.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 09:35:35 -0700 (PDT)
Date:   Mon, 6 May 2019 09:35:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v2 02/16] xsk: Add getsockopt XDP_OPTIONS
Message-ID: <20190506163532.4zythaxnndpcueqh@ast-mbp>
References: <20190430181215.15305-1-maximmi@mellanox.com>
 <20190430181215.15305-3-maximmi@mellanox.com>
 <CAJ+HfNid2hFN6ECetptT+pRQhvPpbdm39zQT9O9xVthadeqQWg@mail.gmail.com>
 <f00130ea-86a8-355c-76fb-bd0bea389e62@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f00130ea-86a8-355c-76fb-bd0bea389e62@mellanox.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 01:45:40PM +0000, Maxim Mikityanskiy wrote:
> On 2019-05-04 20:25, Björn Töpel wrote:
> > On Tue, 30 Apr 2019 at 20:12, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> >>
> >> Make it possible for the application to determine whether the AF_XDP
> >> socket is running in zero-copy mode. To achieve this, add a new
> >> getsockopt option XDP_OPTIONS that returns flags. The only flag
> >> supported for now is the zero-copy mode indicator.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> >> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> >> ---
> >>   include/uapi/linux/if_xdp.h       |  7 +++++++
> >>   net/xdp/xsk.c                     | 22 ++++++++++++++++++++++
> >>   tools/include/uapi/linux/if_xdp.h |  7 +++++++
> >>   3 files changed, 36 insertions(+)
> >>
> >> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> >> index caed8b1614ff..9ae4b4e08b68 100644
> >> --- a/include/uapi/linux/if_xdp.h
> >> +++ b/include/uapi/linux/if_xdp.h
> >> @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
> >>   #define XDP_UMEM_FILL_RING             5
> >>   #define XDP_UMEM_COMPLETION_RING       6
> >>   #define XDP_STATISTICS                 7
> >> +#define XDP_OPTIONS                    8
> >>
> >>   struct xdp_umem_reg {
> >>          __u64 addr; /* Start of packet data area */
> >> @@ -60,6 +61,12 @@ struct xdp_statistics {
> >>          __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
> >>   };
> >>
> >> +struct xdp_options {
> >> +       __u32 flags;
> >> +};
> >> +
> >> +#define XDP_OPTIONS_FLAG_ZEROCOPY (1 << 0)
> > 
> > Nit: The other flags doesn't use "FLAG" in its name, but that doesn't
> > really matter.
> > 
> >> +
> >>   /* Pgoff for mmaping the rings */
> >>   #define XDP_PGOFF_RX_RING                        0
> >>   #define XDP_PGOFF_TX_RING               0x80000000
> >> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> >> index b68a380f50b3..998199109d5c 100644
> >> --- a/net/xdp/xsk.c
> >> +++ b/net/xdp/xsk.c
> >> @@ -650,6 +650,28 @@ static int xsk_getsockopt(struct socket *sock, int level, int optname,
> >>
> >>                  return 0;
> >>          }
> >> +       case XDP_OPTIONS:
> >> +       {
> >> +               struct xdp_options opts;
> >> +
> >> +               if (len < sizeof(opts))
> >> +                       return -EINVAL;
> >> +
> >> +               opts.flags = 0;
> > 
> > Maybe get rid of this, in favor of "opts = {}" if the structure grows?
> 
> I'm OK with any of these options. Should I respin the series, or can I 
> follow up with the change in RCs if the series gets to 5.2?
> 
> Alexei, is it even possible to still make changes to this series? The 
> window appears closed.

The series were not applied.
Please resubmit addressing all feedback when bpf-next reopens.
Likely in ~2 weeks.

