Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100CB251AE4
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgHYOeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 10:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgHYOeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 10:34:07 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B737C061574;
        Tue, 25 Aug 2020 07:34:04 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w25so14038964ljo.12;
        Tue, 25 Aug 2020 07:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=00qy2pNCOtPFyED/8lG4zQs8PuaD2Zn8I4O/t5hQ9Bk=;
        b=OCecthoSt4bCALEoeE5FfEDKlZu18mvmEIdpPOsMkQ5l6lPkerHfErNgTJzfxxC+DX
         jhaZR5EuPhkh31XY0g0jK+LPX680HVNsA2kIljZpjMk+1n3MfNm5wKPpoUt1nXyEtUt7
         eL0iyv9JmUesw6rlTvZB1Gqvw11FLp/R3DwzQMEbFCgP2729nNW/+qm4hJ9PsDVCOvnD
         L7colNLXj6/HoHwIhEYWDRnco8YxdMGf1HIKfIVseTiFcMxZ7k/nR+EFcmtSluYoJAxT
         fEe9NtHotaJpCZA5OWmVGe4sMzX3w96kIgRVsV17UX+QyeohQny0JGGgVts1t39vQU01
         PZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=00qy2pNCOtPFyED/8lG4zQs8PuaD2Zn8I4O/t5hQ9Bk=;
        b=HfUCrM4henAikbdg7yu3gr8dtiloNlSB5rhz5ZAY/GN45IwKZKDkRibf8/bbiTrr3V
         G+UpdGrkWagW/qE35Ko3OAGLyOMZnWM1I/TIHhnCbqvUQ53QdTVAiAThV/p7JRSy+XdZ
         zjjOmI1YArLGlQHhPjnYCD37HxTDm1C40VZ/B+d8yUMlJoSv4vmN/R52pOctpVB4Lljo
         ot8j4gTqf4n0pjVo2u+Ysey5AZDEHWcWuWlZnmtxccDrjH2Bdv2tH+D6fkFWp7FB1hwy
         g2MNsYn+PmHUwVaIer+LKWZwKuMJJQF9IaX22tplg7O5EfMWoOw5gaugi7ia5aP4+LyO
         OkIw==
X-Gm-Message-State: AOAM532YjBWUG+lpIbZ3ssL733m4WwuPPfmymOvvvzZi/V3TY5uVX+UE
        ykGb6MjSGQaErwIqs0oFxCAP3wcjK4GY5KTkzn4=
X-Google-Smtp-Source: ABdhPJw+2PoMTt6hCpRQlUsK/fYGK+EZ00dHWuxY8Agb+bMR/IyI65ArPrD06xZaoIRR454ye1p7RW6pIp+aChjNGfM=
X-Received: by 2002:a2e:968c:: with SMTP id q12mr4759972lji.51.1598366042818;
 Tue, 25 Aug 2020 07:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200821111111.6c04acd6@canb.auug.org.au> <20200825112020.43ce26bb@canb.auug.org.au>
 <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com>
 <20200825130445.655885f8@canb.auug.org.au> <CAADnVQKGf7o8gJ60m_zjh+QcmRTNH+y1ha_B2q-1ixcCSAoHaw@mail.gmail.com>
 <20200825165029.795a8428@canb.auug.org.au>
In-Reply-To: <20200825165029.795a8428@canb.auug.org.au>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Aug 2020 07:33:51 -0700
Message-ID: <CAADnVQ+SZj-Q=vijGkoUkmWeA=MM2S2oaVvJ7fj6=c4S4y-LMA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 11:50 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Alexei,
>
> On Mon, 24 Aug 2020 20:27:28 -0700 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > I didn't receive the first email you've replied to.
> > The build error is:
> > "
> > No libelf found
> > make[5]: *** [Makefile:284: elfdep] Error 1
> > "
> > and build process stops because libelf is not found, right?
> > That is expected and necessary.
> > bpf_preload needs libbpf that depends on libelf.
> > The only 'fix' is to turn off bpf_preload.
> > It's off by default.
> > allmodconfig cannot build bpf_preload umd if there is no libelf.
> > There is CC_CAN_LINK that does feature detection.
> > We can extend scripts/cc-can-link.sh or add another script that
> > will do CC_CAN_LINK_LIBELF, but such approach doesn't scale.
> > imo it's cleaner to rely on feature detection by libbpf Makefile with
> > an error above instead of adding such knobs to top Kconfig.
> > Does it make sense?
>
> Sorry, but if this is not necessary to build the kernel, then an
> allmodconfig build needs to succeed so you need to do the detection and
> turn it off automatically.  Or you could make it so that it has to be
> manually enabled in all circumstances.

what do you suggest to use to make it 'manually enabled' ?
All I could think of is to add:
depends on !COMPILE_TEST
so that allmodconfig doesn't pick it up.
