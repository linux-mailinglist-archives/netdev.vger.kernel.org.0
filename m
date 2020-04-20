Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422EA1AFFA4
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDTCAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726007AbgDTB74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 21:59:56 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9914FC061A10
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 18:59:56 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id q73so3989812qvq.2
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 18:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vkFQlxjluaLtrudrML7Hdba6QFiTPAjUT4zOSRXEnfM=;
        b=o7wfvh8fln2uoxXmOPT2RWE19ikHtebxh63fRTVH7xEkORUZND3NErW0kJOV7KG7s0
         /Ddcb8FqV9ymRmuZSAnprVbF7b70k9N95KiG0eK5a4QJj2CckeXQRoYYCi7W3TcNl37s
         MohvOt/hPABYt7Ikozc3doiM2UYjqQrQ+ANUu6+d+giqPBpj+BWu9lwgVDzN7cveImIv
         0o8UIN5LRwukERcKXZ5Bv4HFW1aQI2+TH5oWqpsjkrHrHqiPWK1pV3zg+iEztPSrn/am
         8Kd3oOHfsPTCFJ38qRhr9mctMgIuojNJgQQiI9f/ZK9OtPTEtYC7IAOJzYUQXhz62GTy
         Zqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vkFQlxjluaLtrudrML7Hdba6QFiTPAjUT4zOSRXEnfM=;
        b=TXURxkrLIcnaFc7E7bSkM4y9SgwM+Kqb6udGuYaC1SJSK645ssbDdT1xpkjzapk9EA
         wP/Z5zlMVgpqkTpAhracXR3lKT4Vv8H0YAmY+cJUSL+EduyD0KGB6gex+h/ye4RgEYiW
         3uBILyQqU2iVXrJHeCpuyqzIxEymXe9uFoc5x6/RY8CCHs1Z61f6i8hBW5D+FqDE+4v/
         2W/ipS4Sk2hTvHM0Xi9261TeXlGggGBVkOsCvRInPp55sDSixxsdFGqKimL1x8UYYa09
         hx+byjMa0z5GwK7m1W4zkyiZ49SOrivAjkQcIDBWrSqnom2iqauQMACdFER4WNqyLoUs
         H+RQ==
X-Gm-Message-State: AGi0PuYsYHk9FSFytORHMNRgovZD+CmY+jshmR3XVew2Nf+zGFUHV3BF
        kQ3Yv9CfErrws7oxHiq4NNKyDQ==
X-Google-Smtp-Source: APiQypIxMDh4QJ9n6P2CvXw9d7499u5wg4jEK7Cnn3QicKR6bY7jLy5wcKE0IBi1MI1nlomxb5CCEA==
X-Received: by 2002:a0c:b90a:: with SMTP id u10mr12965104qvf.92.1587347994341;
        Sun, 19 Apr 2020 18:59:54 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id w10sm1228160qka.19.2020.04.19.18.59.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2020 18:59:53 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: linux-next test error: WARNING: suspicious RCU usage in
 ovs_ct_exit
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CACT4Y+YR5Y8OQ4MCdCA2eoQM=GdBXN39O4HahWtL0sdqwsB=mg@mail.gmail.com>
Date:   Sun, 19 Apr 2020 21:59:52 -0400
Cc:     syzbot <syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, dev@openvswitch.org,
        kuba@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A33114F-0173-4C12-8FD1-3F863318A4D3@lca.pw>
References: <000000000000e642a905a0cbee6e@google.com>
 <CACT4Y+YR5Y8OQ4MCdCA2eoQM=GdBXN39O4HahWtL0sdqwsB=mg@mail.gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 18, 2020, at 3:02 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
>=20
> On Sat, Mar 14, 2020 at 8:57 AM syzbot
> <syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com> wrote:
>>=20
>> Hello,
>>=20
>> syzbot found the following crash on:
>>=20
>> HEAD commit:    2e602db7 Add linux-next specific files for 20200313
>> git tree:       linux-next
>> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D16669919e00000
>> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dcf2879fc1055b886
>> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D7ef50afd3a211f879112
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>=20
>> Unfortunately, I don't have any reproducer for this crash yet.
>>=20
>> IMPORTANT: if you fix the bug, please add the following tag to the =
commit:
>> Reported-by: syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com
>=20
> +linux-next, Stephen for currently open linux-next build/boot failure
>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>> WARNING: suspicious RCU usage
>> 5.6.0-rc5-next-20200313-syzkaller #0 Not tainted
>> -----------------------------
>> net/openvswitch/conntrack.c:1898 RCU-list traversed in non-reader =
section!

Those should be fixed by,

=
https://lore.kernel.org/netdev/1587063451-54027-1-git-send-email-xiangxia.=
m.yue@gmail.com/


>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>> WARNING: suspicious RCU usage
>> 5.6.0-rc5-next-20200313-syzkaller #0 Not tainted
>> -----------------------------
>> net/ipv4/ipmr.c:1757 RCU-list traversed in non-reader section!!

and,

=
https://lore.kernel.org/netdev/20200222063835.14328-1-frextrite@gmail.com/=


It looks like both are waiting for David to pick up.=
