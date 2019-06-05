Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A91E35554
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFECiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:38:06 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:23777 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfFECiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:38:05 -0400
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x552bwqj023011;
        Wed, 5 Jun 2019 11:37:59 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x552bwqj023011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559702279;
        bh=rlXG4KafJ48SszDXPb9veQ1mChqnZopGbbSbM2AtzLc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=reRoC3LCODW2GBXW/hPCv4S/B7CVl9c+nRtJ4VY8VY6hzI24tWZrUHkGNWz420Nxm
         kA5XCPbqM+OcfHVU2VJwzQuuBHYJqAn1wVeQ72k4q/3g1jhzo46RQXCg/ukFh2Dox7
         LR1uj6rky7CyY6u4WR0us9bTjJZgclXEUPQxSVVG70hHPG2k8nOGylY2MysCZiL0iG
         YqMskldpLSmjYFpHCr5Tkh2Ifh48QY8xmg7TBMBkEF8jxDxwwerKaY9jc0GYh1EpfR
         eGmZCZ4253i7cIrBZj1Z1utua3uwfrvPlahSg5FCD/jXViNq2pL+e8DeNYjaabxd3l
         fbTOkdui/IHVw==
X-Nifty-SrcIP: [209.85.217.48]
Received: by mail-vs1-f48.google.com with SMTP id n21so9083325vsp.12;
        Tue, 04 Jun 2019 19:37:59 -0700 (PDT)
X-Gm-Message-State: APjAAAUJSf6uv3e8xz/lSHIFnG7yWBQ4EMyfIbvLeziXJe+cZWKe2PaA
        BHwSO3AdTPTTF1TIyYuLO8jAgWtqFiGJcWbl6Kk=
X-Google-Smtp-Source: APXvYqzyi/PN7usug5PnObKBoqJxKJtYCUFINZdd71aBKnjEu2CMU8+EOU/sdcKVYceeBvsBUi01Xqmwcp/M7j6Sefg=
X-Received: by 2002:a67:f495:: with SMTP id o21mr3047792vsn.54.1559702278042;
 Tue, 04 Jun 2019 19:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190604101409.2078-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190604101409.2078-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 5 Jun 2019 11:37:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ50Lnz+1hjHg2PK_h7DyfNkY7D1XGL5_VPDe5xLgx2Kw@mail.gmail.com>
Message-ID: <CAK7LNAQ50Lnz+1hjHg2PK_h7DyfNkY7D1XGL5_VPDe5xLgx2Kw@mail.gmail.com>
Subject: Re: [PATCH 00/15] kbuild: refactor headers_install and support
 compile-test of UAPI headers
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Song Liu <songliubraving@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Palmer Dabbelt <palmer@sifive.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        linux-riscv@lists.infradead.org,
        Vincent Chen <deanbo422@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yonghong Song <yhs@fb.com>,
        arcml <linux-snps-arc@lists.infradead.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Greentime Hu <green.hu@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-parisc@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 7:15 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
>
> Multiple people have suggested to compile-test UAPI headers.
>
> Currently, Kbuild provides simple sanity checks by headers_check
> but they are not enough to catch bugs.
>
> The most recent patch I know is David Howells' work:
> https://patchwork.kernel.org/patch/10590203/
>
> I agree that we need better tests for UAPI headers,
> but I want to integrate it in a clean way.
>
> The idea that has been in my mind is to compile each header
> to make sure the selfcontainedness.


For convenience, I pushed this series at

git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
uapi-header-test-v1

(13/15 was replaced with v2)


If you want to test it quickly, please check-out it, then

  $ make -j8 allmodconfig usr/

(As I noted in the commit log, you need to use
a compiler that provides <stdlib.h>, <sys/time.h>, etc.)


-- 
Best Regards
Masahiro Yamada
