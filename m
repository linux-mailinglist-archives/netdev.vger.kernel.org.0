Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F16C62E5B6
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 21:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbiKQURX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 15:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiKQURV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 15:17:21 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC727EBEF;
        Thu, 17 Nov 2022 12:17:21 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id n21so7903285ejb.9;
        Thu, 17 Nov 2022 12:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=55YgtW2dMJrW7AwFItwqgAI16CPRs4yKm+bUdhCtkUQ=;
        b=nCp04v7sWKLKn615/jPd8VEMBxuFVEWvTogyYWLkiSNBFp05G2vvuKELsYtP8x1v1O
         g1zzw43ziLoWLElgZkQ4NSGFaIbjRfIN53astbdHu0L5uIEvqVZ2wYqZ9nxwv0qRnPr1
         9CuMjwEMj5zhfO2sDxTDulWKMXPKvzRXjNh6eGU3RaoaFybwGT468W3gA6sn1KjEP/2M
         mnoF7YmNxaJyrJfFup+QNMn8cw+CAdOyMP+zyDHekLqD+ZXK9bowlZMRyFNBIUlBWu7N
         5hXGfXbcNC9DNUrJFhWmfhHsbf5EI2v1S5CmJ/P2gA/wn+pESMJBs5F6jXUYQorRwa7m
         uqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55YgtW2dMJrW7AwFItwqgAI16CPRs4yKm+bUdhCtkUQ=;
        b=mJVcXvy59PAMbgfZcIWtSPwDdVu3SgQW+DspjPOrTMprm2j4qEsCZ/Nr6lzM+jMybO
         ypag7Mh8cwmbUwzrut/zwmMrAFQ6LrMI71cy7QR+rUcKuKVZ+x5VA3GQfn8AFSTBLsMU
         L+AOdkPE/uC7Q+8CCa5p/bhI04R1jC0LFAw3CbEq+lKkcbqLW38xn4vNpxaBeem/z9V/
         E8sAPMlHrH/P59CNHOazr5iAEYLsRYAxdn2GrOJs6w5jl9swRDlJh97AbdeU9/Hs2ACV
         hNAQna5xtj9vV8E17G/r2RvZjudS5rL+27fIeqy0iJmIpqq4D/1uRKrefefBTuoRKNzi
         eUOA==
X-Gm-Message-State: ANoB5pnTqjUBvsUZ0VsFnIhHW2x13ZKGyGwRq38xam/I4JThP4qeNXvL
        US319bjOy4DHLb5jc+7SxLlKGY0lP3izAZOsV+7QrQoG
X-Google-Smtp-Source: AA0mqf7DcM9g4bmq4StqwLg72HjwbQzsNljXj78/PgIZDmdK47iiwkm0j+r1NBwLrOXB/fG2UEqHhGGXdVBH3bITGQ4=
X-Received: by 2002:a17:906:1495:b0:7ad:d250:b904 with SMTP id
 x21-20020a170906149500b007add250b904mr3464534ejc.633.1668716239384; Thu, 17
 Nov 2022 12:17:19 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
 <CAADnVQLBPCh=80RKe_5sgCt02c2Zat4TG66+PNrVD1a2k=4UfA@mail.gmail.com>
 <CAKH8qBvD=mur1YHf1MLxdxqWXOfvZTor+C2LqNMsvp0p6OhM0A@mail.gmail.com>
 <6375dad15f11f_9c882208b5@john.notmuch> <CAKH8qBu6rejvUOX5r=6JP=NoG_3-VZvNXHyfp=gVbr7-OhMGaw@mail.gmail.com>
 <63768feaf1324_4101208cf@john.notmuch>
In-Reply-To: <63768feaf1324_4101208cf@john.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Nov 2022 12:17:07 -0800
Message-ID: <CAADnVQJkf9TcJwQd88dt-SF3RXtinW0GUOJzzHB-Jw3KvLeAPQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 11:47 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Yeah for timestamps I think a kfunc to either get the timestamp or could
> also be done with a kfunc to read hw clock. But either way seems hard
> to do that in BPF code directly so kfunc feels right to me here.
>
> By the way I think if you have the completion queue (rx descriptor) in
> the xdp_buff and we use Yonghong's patch to cast the ctx as a BTF type
> then we should be able to also directly read all the fields. I see
> you noted this in the response to Alexei so lets see what he thinks.

Fine with me.
Let's land something that is not uapi and then iterate on top.
