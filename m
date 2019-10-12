Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D678D5085
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 16:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbfJLOwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 10:52:24 -0400
Received: from mout.web.de ([212.227.15.4]:50113 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfJLOwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 10:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570891913;
        bh=ESlHQBV8JuvnEeo7mqgxoWQxfM0SeeqJrmAt3/L4DFY=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=plA/EKeGWeFpCjBNw13WNY44JScTeBHR6e6vzr2h8Gxo+b80mJH1CSqlNw0ffUMg5
         qyqhuMRcU9nWqM3PanpRwXDDuyw2gd8K51IvBPv0yvfXWtLZWvZpe5Tk8Wz7lojTrJ
         ulwSWNOGaYxjFWqhO104y5fWQ0VbpFS5J0ITqAVE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.155.250]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LmLK6-1hkW9y3RTe-00Ztbs; Sat, 12
 Oct 2019 16:51:52 +0200
To:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: tcp: Checking a kmemdup() call in tcp_time_wait()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
Message-ID: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
Date:   Sat, 12 Oct 2019 16:51:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BmmvAVDI3sGZeOF3bm14iYNrRN0F0p4S3GVTbMcqz1SXRWNdLnd
 VHLpnwBcWWVIa6BAK36FHMi9UdAA1kIHJXtHmoWdvbtQXU2OgKLCLVDu1ysxATTNfAdIkCI
 SoVFOs8Q1ZH0HjZjA0dWE2RnczANck7jip+Jj8mupsGqS4MV2EJiYh++MTxD5pkoHTNnByc
 cmt/Yi6989WCs1I8H+ffQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Yx2tKkQjepE=:A4Cs7gjrQOHUYyZxEV7+r+
 cUakL1Vka95EryFqlDQAaAWbBkD2GEFxobNMLFy7qOL2FzhEYKs7gx7JX12CgAROcJbMcwBVv
 3PluW0Cr7kju0s953NULQtlMZyChVMUqJ5NPeBZgjk+odNrxwWF1ZC+BdxLbXG8sueYyq4wAg
 kM1ekW06ty7gipJsRn9Qyaxi4cMy5pRggy4E6cB0rrvyl8yFxh1U+VGnu5EZZtCY7vHPFsogt
 psSixRgOGom/MDf5r6bkfysmj5/4+PAyl66MB+9/trnCjxljQCEvvGon/Ip6xsX3n8u58828D
 DQFOt9czJ0zIeyc5Llo77ukTuhdzE38kc6+XX3chrizdonnpcK/NcHr9M+x35CrQJK07XpyBM
 Rb0ux6fl7PLp4ePXDMk5iSSUR1Mk/4jb6YBZCpVc+nme2zDbpuLno0sjfqK8+v+XMgRI14D9h
 j5FZT72QC9IQT+9O6F+9IIN73X4ekL7vaP8/S4xknhDc3eu3tXcUHhZB0kx1mqo45ecLj2yFX
 hGdzdWwaUTV93ABWylrMDYllmryrobAvYtpyt1fDaz42NgizIb52FaXQTYifZLSlgPI4tNTlh
 I1v9pozEzI07ykCSYpFAhbdh3F3kMLjzdLwcgx1MllDndP77pbzEdIV//R0LIPUFQKCSWB8k0
 kkLnZdEnl19oPxwkSawuBHtl/Cor69LvA8ncBDi2DvnFhv2rmFSnCYRxbOsRNGYKuVWM1ceRC
 /H+Ig3NJyL/O5+gBjTFN5oIBn67G5+1klzZ0pGqldFddnofN/JUvWAFQ3z2ZHWwyJKC9Qdv7p
 xAAMJqriRRfCbDjgBadTHqH/F2DDGXs0Ww6psfcHQtEZWUW7jSBmOL2zTHcck8Py38/T/nMQD
 XzzBm16V7oMxL0UcgmytAIgYOFrfZ1mbJrWs0GesGoSZ4vM1elwjkTTmqGeb8nqLm/ylIDmRx
 gRnTDOVI30/pcd2h/y5FZ+R3N0YAFtZtVN3xaSTy4qTxfMRIEE13Q+PukbGsG5GQgRIVaJFQu
 oav3eymhq1QlGgICJa04hE4Rc7/AI6Wbus/o7oK3gFJhPm1EF5QXf23/sXQOg85/GmJRhQ7lh
 pCPBuYJ1iByOrzrm2oClQSwRGrqbugzUTQCmgazTMF0iRxQ0qAAlvY+FNY9ELmasiZtuT8Oru
 NFMbSxXZmYYoaehqjw52gRQbdrxVLbY0OhtAdbDO/VJjkEAGywVtU/H1izvnMxLFw/ig0LSL1
 uqnwr5mwT4g534w4FL+690VlQH1t2jbLKyaWPVhFoURsCL87i6epQAD1RYI8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I tried another script for the semantic patch language out.
This source code analysis approach points out that the implementation
of the function =E2=80=9Ctcp_time_wait=E2=80=9D contains also a call of th=
e function =E2=80=9Ckmemdup=E2=80=9D.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/ne=
t/ipv4/tcp_minisocks.c?id=3D1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n306
https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/tcp_minisocks.c#=
L306

* Do you find the usage of the macro call =E2=80=9CBUG_ON=E2=80=9D still a=
ppropriate at this place?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
scripts/checkpatch.pl?id=3D1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n4080

* Is there a need to adjust the error handling here?

Regards,
Markus
