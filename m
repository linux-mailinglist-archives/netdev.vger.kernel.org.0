Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD321CAF2B
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgEHNPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730353AbgEHNPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 09:15:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45050C05BD43;
        Fri,  8 May 2020 06:15:12 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u16so10499365wmc.5;
        Fri, 08 May 2020 06:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8Im34sz2MzZUy2vtWd199LfDoA0OQ99AwGOktacYlCQ=;
        b=G+zQHhHp/Lch52oBnmNwRqF+r77FYljxyGT4Bz3cj5f4cD9bC/cbCls2J5pTnInPim
         LMw6xxY1TMY6AulvkLLIL3sXK0gRXhgLGQ+EPvqx33/+I9Ctq0DXL3yrXW0c3/sQwkR7
         pBJxhmjoeYN6AshrcGaEqiOObIiBPMBIwWMQsh8PPvYUmfMNNc4MysEzx41kknPnge7b
         tfjblZZ3RAg2QfmCiib3AojaNfmnsbVKZ/SIp7wak0/orcLcQlggI+2eXkguFGMd1Fnk
         9JhirZK1LDwLXKt9BD6Ym+1NR7IPFK1hN9oTkLRdmkvjX6PTi3CPMAaf7l/1HnWO3rBg
         eewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8Im34sz2MzZUy2vtWd199LfDoA0OQ99AwGOktacYlCQ=;
        b=A4lakkTTUdADUlSDyG3cZhhrSU5hFI7Nk97kZsuQNCpyD17OW0jCB4/ZVZSI5mNSLM
         xpgtd7Md83z0Gjwdq62R8MgEK3PDYVYc6JtmMHtegXIRgg/fxy5xpjUsMkD5Jaf+J5wl
         UyQJWtO2TqPnkLXV56tgL3rgtjwpMMaNZPGF4IvpIC2HYL3ICo1NuyeQfv0iFaZ1ciW9
         29Xd/T2kAjalCM6rcOp2IHnJKZxbbinMl8/Pq6J6sgjwZbSK+vClc4kyb5iEOzVfKpu4
         1gyvkTQHl0OJ70jk5MVrje5p52CpXz0ZTXgzIMTnrdMRQrKahRACQ53B/zdgAuy134iu
         MW/A==
X-Gm-Message-State: AGi0Puanwp6vUjlAP9gWm1e1drCN0dIHpxaRsDzwXSZyKsJptFhazO5w
        67GjKQwO31RfyHLwDB+8PROA8zFbNAc1DGrc+ec2S1HrG4qWaoAC
X-Google-Smtp-Source: APiQypKeqJU36Xt3HJIinO7n4tAowbPJwUpy+Xk+6KKid2/fFhckl1br871A0DkpN9EE8Yb4V73VXshPgJ7foYp8rvc=
X-Received: by 2002:a1c:3281:: with SMTP id y123mr16145026wmy.30.1588943711064;
 Fri, 08 May 2020 06:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-11-bjorn.topel@gmail.com> <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
 <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com> <cf65cc80-f16a-5b76-5577-57c55e952a52@mellanox.com>
 <CAJ+HfNiU8jyNMC1VMCgqGqz76Q8G1Pui09==TO8Qi73Y_2xViQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNiU8jyNMC1VMCgqGqz76Q8G1Pui09==TO8Qi73Y_2xViQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 8 May 2020 15:14:59 +0200
Message-ID: <CAJ+HfNiBuDWX77PbR4ZPR_vuUyOTLA5MOGfyQrGO3EtQC1WwJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 at 15:08, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
> On Fri, 8 May 2020 at 15:01, Maxim Mikityanskiy <maximmi@mellanox.com> wr=
ote:
> >
[]
>
> All zeros hints that you're probably putting in the wrong DMA address som=
ewhere.
>

Hmm, I can't see that you're using xsk_buff_xdp_get_dma() anywhere in
the code. Probably it?

Bj=C3=B6rn
