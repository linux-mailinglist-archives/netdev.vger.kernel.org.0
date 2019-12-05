Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9B3113D92
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 10:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfLEJJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 04:09:05 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:48377 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfLEJJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 04:09:04 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M7rxE-1ihlDI3fAQ-0053U2; Thu, 05 Dec 2019 10:09:02 +0100
Received: by mail-lj1-f173.google.com with SMTP id z17so2589970ljk.13;
        Thu, 05 Dec 2019 01:09:02 -0800 (PST)
X-Gm-Message-State: APjAAAUU85VoQs/sar3CT2JhJxvP0uRgSFCcOtI8W3k8Us1mKpqiVgY6
        pyE+KqHWE0XCHeyRUVucsjraGlciDtQkwuO3D6M=
X-Google-Smtp-Source: APXvYqzGtpjRsvYhOdU68NUmIa/e9X8ki0UG0IcpbOcGgiqHGISxjpl72wMrhjllkh458C2mDVVxXqnz0zpKrVD54oA=
X-Received: by 2002:a2e:9095:: with SMTP id l21mr4627561ljg.175.1575536942283;
 Thu, 05 Dec 2019 01:09:02 -0800 (PST)
MIME-Version: 1.0
References: <000000000000cacc7e0592c42ce3@google.com> <20190928031510.GD1079@sol.localdomain>
 <20191205052220.GC1158@sol.localdomain>
In-Reply-To: <20191205052220.GC1158@sol.localdomain>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 5 Dec 2019 10:08:45 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3XLzm+zGmADUR3VYi4NziY-Aox7a8QG6VcGYQcAJiGnQ@mail.gmail.com>
Message-ID: <CAK8P3a3XLzm+zGmADUR3VYi4NziY-Aox7a8QG6VcGYQcAJiGnQ@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bpf_prog_create
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        syzbot <syzbot+eb853b51b10f1befa0b7@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ppp@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:TzSxX4hlV2bd52db674bnSiDd8ctBfgwNLqaetjuvInLKrenlCT
 D4h4hDB4gG2gJVJJ+yy2ml9B2/1nira/9D1eM4/jrjeZ2sdGdDjz6yOY/4uN1K1C+aRlDbf
 vHtdwa1LK46uMDePcxsT637DYwPZTO6sEDsu8n89QOucDlQfk+qQcURAdOSlbq16WGFYn/A
 N0TBS+0Oc/YbHY3dGPosA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MC/cWPxqk0k=:He1YZdt6C57pvAnrGferk4
 mfHZzHZ/KWMebipyXU+AX/0i9bgbUn3ClClHx5mPNdpwy6p1hvmZFklB4nBIX2HLqdHKAPyhR
 LOWXtUNw3lu/BPxnZFdFLLaEAA5kxno+8k/yYj7b4kTZbmXEJ1szaw65ZrQHCpBD8eZQQLMLV
 ER947nzwrYAKQYUdFQjwJMKdtJb/A+uDRdr90eFk4G6QGaTzjK6uJ3Al4jEiXjWSJvDkJtPkK
 KobB4YnLofpExfMrlzAT94gI1GauAG90RpALlbH4swXLE7CfYoHWq4ALPMi6PFPfizkvAI3d8
 5k3fkHOHPzKpWjnBa2Q0/dADZwc3XL5m0f7K9ONOWpQwWw0n0Xl1k5msPkv3iuTRGLz2ztQpf
 IcgB96lodbBxewG4aBDQv1lW1Ce3V68XNFsTXlwiqsgrkPB85CGvajMnpAo2b/3tAmKlqf9RB
 QaBJSvJW44tp+8Z3Rn615juYGYbCUuxYHOs5tWVITAY1jp3o4Z2VUJmOc+Gb2Wxw2Izu2pVxQ
 LXhMFu2NYPg3byIkSnLpDxOGZM7Z/xBsaeX2DzZGkwO7Vpc9PglCkBnG6pJPlPBtQhGeIwcvH
 18BqZPBiop73RCTjVDoRYWwfMmA5PrCVQjUYR7aA57p8jzMTpaq0lFaREQ5eRp6nT7v5wJDbS
 sf6V+7ChUZSEaUDardG/mO3xI+eCCl5yAaQh4YAlFYTdiPP7ln7yfedsgru416bMCRXbNRuoA
 Whsug/fVF0jUGrEhTmAjz07wbvPVIPDxvlQefB064noTDUngiy2Wx2sGjDlUvGpaRK369mSSI
 MGVtVNrBVFEEc/hJJHDDJmkcUNbyPIP79ehuppQWSmiNSkMTewb38hnwsQ5GOLcUh67giTrdN
 gBSc336Lhfqg5pytNFtA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 6:22 AM Eric Biggers <ebiggers@kernel.org> wrote:

> >
>
> Why did you ignore this and merge the buggy commit to mainline anyway?
> I even told you how to fix it...

I'm sorry about this, I completely missed the email about it originally.

      Arnd
