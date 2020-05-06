Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBB11C680F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgEFGNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:13:13 -0400
Received: from mout.web.de ([212.227.17.12]:37245 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgEFGNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 02:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588745571;
        bh=b5tnY+lM147dsLwm/PdCM3Mf/kmM69l9CXBBPHqHx50=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=KaF//h9iz/Ebvp8ollZgOmzl/BdeSp3oh4PDoOnP0RsdA390R5mPX8O/o6nVBUlEa
         bIV35Xz8jXEk6RYw1KN4pjxAH+b/YxTQu2p4DlxwI2ipibvrfiNiXiCAuFUwhodvvr
         N31IxXXjrikCAm5IgmMMaGkwG7kK0pj4+yHEs4o4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.162.166]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lxwme-1j2b5j02nE-015K9d; Wed, 06
 May 2020 08:12:51 +0200
Subject: Re: [v3] nfp: abm: Fix incomplete release of system resources in
 nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, oss-drivers@netronome.com,
        Kangjie Lu <kjlu@umn.edu>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200503204932.11167-1-wu000273@umn.edu>
 <20200504100300.28438c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMV6ehFC=efyD81rtNRcWW9gbiD4t6z4G2TkLk7WqLS+Qg9X-Q@mail.gmail.com>
 <ca694a38-14c5-bb9e-c140-52a6d847017b@web.de>
 <CAMV6ehE=GXooHwG1TQ-LZqpepceAudX=P63o139UgKG7TMRxwQ@mail.gmail.com>
 <6f0e483f-95d8-e30b-6688-e7c3fa6051c4@web.de>
 <CAMV6ehEP-X+5bXj6VXMpZCPkr6YZWsB0Z_sTBxFxNpwa6D0Z0Q@mail.gmail.com>
 <956f4891-e85d-abfd-0177-2a175bf51357@web.de>
 <CAMV6ehE9YRxakbP9ahXkiZEPut8E3qYsN0cxiLqCWasfvLAWFw@mail.gmail.com>
 <e6989cd8-42b8-d1ab-1fe3-aad26840ae05@web.de>
 <CAMV6ehFCcSZtqpxonfbp6i_v5zzmnLJ9Gncx=5Y36R35wqTtDw@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <ce3917f4-8fd5-d9b6-e481-6118cdb504f2@web.de>
Date:   Wed, 6 May 2020 08:12:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAMV6ehFCcSZtqpxonfbp6i_v5zzmnLJ9Gncx=5Y36R35wqTtDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qP863087Hc+fAdJ5CoG5TTLm/yPnU5LJkc+LL5JNpRRZ8RFro0L
 jT1+ybwGV0NIipzwhLKV/zD3ncYqgffcUX9eobp9AExk9ZlhlsJOMtiEaEXnvdgiR0S2nKi
 /BHxzx1rwf0yYb55EnOzMWvb/9HXC98P79dKq7DBiROxDzi+w5QlaURVgeXadTI+mWwdTu7
 yyrLU6ulEJcmQEIrEhg0g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d6QJSTYqN1Y=:C2IsliRrFQnyUy4W0EpJZT
 eWYuuRjA+KYGqkj/9sVM1YBCQ8synpzc2uW6nXAtcgoroEANWmX4DRYunYUGhSRcA55ERyA30
 +ytHM4aPxLlJi21sgEXRe9IlauqmFhTA5putiW2agBqC6Xh1nlmGqjC2eCvytCiG+rNJRT1DM
 265bpTkkpF9N3gfi99kBOPYaqVT3mNAtSoblaikq+XVu1C10FZ+UOu5qIntOEN3OMsHcupZ6E
 a/mQzWf891pBCgyP8Sog2UvsVW+uHFJaIA2d5M3lv6wAiWc+tdUQAIHccCKoGer41J5NWguMF
 9nUJT/XaEqcbGzeZvPRvU+TskKZbWASwFFFSNwqdJkZGl/UeoO7q7akXs/WMeifI80xCQujTf
 aARYWYK1I6MmYQfykJs4tsjtwvJ6h6FQyph8BEqSfWOtxhD/sYDPiTY+FFVAp920uQqNT/6mC
 tg0mutYqA3t/k8fGF2ecazRl8tJjwqZVzc2MTa54iz11ynm+osX3FlkrsjDpF848EaNViViyy
 tbY0l67pUDtAk/XUU2O74nyV8ewT1Tz85GDc59219p7FT1t0aesRQ7LJbdXFOWFc3h6srRMAa
 LswhL/81e2gp+hbbTlxwBZwE079D+EWZQI2ZI0+knRQprXqc+ZsvZtfrxSSjeZAhKEijQnUYg
 y3fpVnFbuu93OEa5CotA3DrFVEvmRuOoQaXofRl0FD+UgHxi2bLtXqeH7ggMCjHDNeBY5biTu
 WIqmiDsbZ5BL2S/TzEpGcTVXNzYDaZ3FXyH2ETdzWuPmmCB+nw2HyFVioa/bWk4nLUFAL23mg
 KSbJnbZ7X+w7zgemebOrp8Ob2AALYZ8oww/tUPzvHPuD7JelLVst0r4n4EkqjaRSxnpifJh1o
 qD8JBuPgh8OQxwOD1Dzz7+bXP4KEkBLgG4r4fbRzjldUk1PhuMeVKG0a3X4bJA1LMn55I8jZv
 qrPCdo2nmdNg8vn2mUuIOaPjIUcTSOVY2is0mqfTM0bz+huMAQkmhd4vAvR/BBdoCIDaBJsGs
 VqM5CHgxsRki2o32IH9EuLKCMB0LGxLNjxJzTnBxL4LmjRsrcep5Kozxm6hlx4rNT9EqDIbQ+
 xxjgcPy5/MxK0mGgifKn/klUDRJ2O5veDCSjGkQeuzbFqm0TB77n9wPg5/Cz8pf1l+1nRM28Z
 z53Av1gjRsEDhPlDTpzLFT/HFwq0ZFpALDB4QY3e9y/UNSw2IYwLrkj3vGcSJN9HxyDhsna/o
 jzggjo+mMtT7NZiGD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm curious if I could still modify these commit message information for=
 the v1 patch,
> which has already been applied and queued up?

The maintainer found the provided information good enough.
Thus he committed the software correction with the subject
=E2=80=9Cnfp: abm: fix a memory leak bug=E2=80=9D on 2020-05-04.
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit=
/drivers/net/ethernet/netronome/nfp/abm/main.c?id=3Dbd4af432cc71b5fbfe4833=
510359a6ad3ada250d

So this change will probably be published =E2=80=9Cforever=E2=80=9D since =
then.

I got the impression that the corresponding patch review contains helpful =
information.
I am curious then if it might affect the adjustment of related patches.


>> Will such considerations become relevant for any subsequent
>> software development approaches?
>
> Sorry, I actually don't familiar=C2=A0with these.

I am informed in the way that you can participate in university research g=
roups.
Thus I assumed that you would like to add recent insights
from computer science areas.
I imagined that the bug report (combined with a patch) was triggered by
an evolving source code analysis approach which will be explained
in another research paper. Is such a view appropriate?
https://github.com/umnsec/cheq/

Regards,
Markus
