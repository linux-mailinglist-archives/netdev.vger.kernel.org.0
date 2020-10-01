Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E6D280206
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbgJAPAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:00:25 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:42215 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732346AbgJAPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:00:24 -0400
Received: from mail-qk1-f173.google.com ([209.85.222.173]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MuDLZ-1kgCk73nLB-00uc2i; Thu, 01 Oct 2020 17:00:23 +0200
Received: by mail-qk1-f173.google.com with SMTP id 16so5612946qkf.4;
        Thu, 01 Oct 2020 08:00:22 -0700 (PDT)
X-Gm-Message-State: AOAM5331+w8bgQrCxRMPqcOme7w6K1gGgLjLOSQJCy6De703+xLDX+Jw
        HsXC0qoJW46kUafEqNYyl9v98GBmt40Ftp4Kw5g=
X-Google-Smtp-Source: ABdhPJxUXkolZ9fkyZnoOE6+N9rQNNdvkpgtMVVCFkZvmQm6oj8Q44LcJPYHCsuwUgBq+y/DreAZeDMmeSJj+dRqpUk=
X-Received: by 2002:ae9:c30d:: with SMTP id n13mr8131383qkg.138.1601564421695;
 Thu, 01 Oct 2020 08:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200918120536.1464804-1-arnd@arndb.de> <20200918120536.1464804-2-arnd@arndb.de>
 <20200919054831.GN30063@infradead.org> <CAK8P3a0ht1c34K+4k3XxGvWA9cxWJSMNzQR2iYMcm98guMsj1A@mail.gmail.com>
 <20200929175255.GA2330@infradead.org>
In-Reply-To: <20200929175255.GA2330@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 1 Oct 2020 17:00:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2txp1_D8Mn3yHzreKBD0E2fnfrDgN9OOU+-stpzyUDLg@mail.gmail.com>
Message-ID: <CAK8P3a2txp1_D8Mn3yHzreKBD0E2fnfrDgN9OOU+-stpzyUDLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] dev_ioctl: split out SIOC?IFMAP ioctls
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jens Axboe <axboe@kernel.dk>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:r2f5IAT6FyggvoqpFdYQrXng6bOKyGAs/6TZM/Yz9/Kov2LlZVZ
 VLuVp8Of+nXz9FBot3eCym5rr0XTx/NSM15qiPu9ydBg6119V6oI+z8PE0QetKjOUtsN1w/
 9HQcFqBURe32r+17TJjoIaW6ovVFCHQiPS4Ri0y3ihiElNol98ZhcJUtct5s07x56KjQVoi
 Qhmmbv7c52DRUbIlza4OA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2M/x444AChQ=:p5N7YqCJrl7c+MTXtV3EOD
 JyHcgOgTeIYH98vgRR2K8J9e/OLT3cqKTzY5ZGttGNkTE5VeKw/GsrICRWRKsKylMqbz/fDBT
 JTSYW26+ljhn1q58pgviTbKiF3HSscg9pIZEAfXiJ/kqCJDN2F/dLREFP6JNnABh3rbpxxr//
 dRCO4eDX5k2VmKzp+GGmSNmtMimnTV3U8HfLUiBP3Og6KPUv8DXcQqk6POohVt3n8fGToA6vp
 Zccv89I3hfSOKppjkYfMN8lMMxkpJP1R7IFboEcezlN6j6zpTAvMgsEQJCl+7YNwTfCIRnKpM
 MPt5odRwLuURfo7wq0gsDiLZBMYujvBbl7wyK3J/i3fXaARKwCEO1Kbf02kdkCS8dBatdv90w
 XLWfBahZ1xEnIx9rVYvml2iYIMNPRFtw6vp8Dqx2stFNMnZ431fhjwvCvEZ6Ykjznq7VYASu2
 iz8d4A2C4ha0MZkpLnpWFuSxtKRsqQMYotv/kqj/EeCvDHVQ2Sqlfkh4+JMOdxupXd/pOPS0f
 QozhnUPQUxWc+Z6CcwHEp2WB2XmHRQGpFvJ0Sqt96CJ+pX9NPfiG4cabwjPqiZZ1sqO/DbyRx
 s2JDXi1Ss3sdQ/13CLoPnZxTQbHlap9WIE42EI4NBV1xPL16ULGZSRhmLaNBoFQqsTW54ycsX
 3rBB/yz56eSNgcqeZvQEehrSIBcbRB2u22dNwhLveCBvuCGKC50YTEyf87BOoj7ocrOtFpdes
 ITlbBLtEnY5Ng2PTnoZsnwk8Iy2i5uf/DJ8g5V6+/VyBbqdN3KA0tOvANNpNyLecl/LzK7HGO
 e39FSo130HzPzjsBReUKqusFORuNXUD3GrdLoSUOyjmfeFLzGKK8uumpYYR9YTc/Yxz2Inv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 7:53 PM Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Sep 25, 2020 at 02:28:29PM +0200, Arnd Bergmann wrote:

> > Do you mean we should check that the (larger) user space size
> > remains what it is for future changes, or that the (smaller)
> > kernel size remains the same on all kernels, or maybe both?
>
> I had something like:
>
>         BUILD_BUG_ON(sizeof(struct ifmap) >
>                      sizeof(struct ifreq) - IFNAMSIZ);
>
> plus a suitable comment in mind.

But that condition is true on all 64-bit architectures, which is the
fundamental issue I'm working around. I can try to capture that
better in the comment though.

My expectation here is that passing the smaller 'ifreq' structure
to ndo_do_ioctl() is safe as long as all drivers use only the
remaining members of ifr_ifru that all fit into the first 16 bytes.
Do you see a problem with that assumption?

      Arnd
