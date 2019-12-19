Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1C7127008
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLSVwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:52:54 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40444 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfLSVwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:52:53 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so4035515pfh.7;
        Thu, 19 Dec 2019 13:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+Tt5VMdTutx8xcQfJ7Y2xqvWLv/N+ZnUyZuugHTRwo=;
        b=JGlM6dc1L6WxY8/K3AC42tPsHQ1C/LFhRRUEUvtuGVHH+7mxz20r+D9gxjraIPwVCh
         BpQtkKaxnm4f++OiHzjU3zUVaTd8nJxEP9PWQ1U/oI+sWlnhKPgdluW9qnotye3wITyW
         HHOoHc1ms817No+t91gwVQ88DXbw9uidFXnSEfT9m2rsaRLNQKOWKxS2pycqCvbqvlcP
         BfiEgJ2vlsIj7wNFZsIWlX7tEuAjN8MELaoAxl7RMNZ0OOYsAZEU85WqdhhBopeo7rfZ
         f306+qgg9cdPOTeggqHaKKGYfcn6sspk30s3iG2wW82xw3VdQik80GFphvCnCqXKFuCv
         4B4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+Tt5VMdTutx8xcQfJ7Y2xqvWLv/N+ZnUyZuugHTRwo=;
        b=ILqcMQJhTHMM5Pk3+WSCQIt+DAhoaj1yaZ/jr5NoTj/sh2QEr17kg1n2Tpmkvllusd
         seowcXwEzBRtZOMGXHG4ruZ1/srxB5PgSBS/cXwCqdGGbya85ZKcDeaPZFSJG9SAhYcu
         rTkhA8LwEx9MWnJn3OU+jwaJgTU2BI8OuSaLXP7E/AWVteGwSn7OHJeNJZY54ddN8v88
         fN6N686IT40/ZCzAWjSxPYEUV9V8e9jj1Ov6AhawdDkLBCwSqoWFqV6wxaK20Dc3TBaM
         oE1LoIUAsfeWvOOfALMZEGXAk5c1rB6oAfZyJEbM0bru4uWGF64vUKmZ4LN2FtnJdMhq
         oK5Q==
X-Gm-Message-State: APjAAAWiI+Xm0ZGt+Ur52hCJDFvxv675Gk3rYHzwqU0tbKJ0zpX+auSl
        1F/0dI+uvlHDrNa0fv3CV+WX2NaYyGGyw/PKBUY=
X-Google-Smtp-Source: APXvYqw4xgFsNDlDDI0rRlLaQbPBJJUNi398HQ5nmpO4SdibadeC5PvTVSOvH5Ohe8AJz6fUfTQNFcSkXaWOSCh88U4=
X-Received: by 2002:aa7:98ca:: with SMTP id e10mr2249774pfm.24.1576792373160;
 Thu, 19 Dec 2019 13:52:53 -0800 (PST)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-8ffb055beae58574d3e77b4bf9d4d15eace1ca27@kernel.org>
 <CAMuHMdVgF0PVmqXbaWqkrcML0O-hhWB3akj8UAn8Q_hN2evm+A@mail.gmail.com>
 <CAM_iQpWOhXR=x10i0S88qXTfG2nv9EypONTp6_vpBzs=iOySRQ@mail.gmail.com> <CAMuHMdXL8kycJm5EG6Ubx4aYGVGJH9JuJzP-vSM55wZ6RtyT+w@mail.gmail.com>
In-Reply-To: <CAMuHMdXL8kycJm5EG6Ubx4aYGVGJH9JuJzP-vSM55wZ6RtyT+w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 19 Dec 2019 13:52:41 -0800
Message-ID: <CAM_iQpXJiiiFdEZ1XYf0v0CNEwT=fSmpxWPVJ_L2_tPSd8u+-w@mail.gmail.com>
Subject: Re: refcount_warn_saturate WARNING (was: Re: cls_flower: Fix the
 behavior using port ranges with hw-offload)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000498f96059a15956e"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000498f96059a15956e
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 19, 2019 at 1:01 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Cong,
>
> On Thu, Dec 19, 2019 at 9:50 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Thu, Dec 19, 2019 at 2:12 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > I still see the below warning on m68k/ARAnyM during boot with v5.5-rc2
> > > and next-20191219.
> > > Reverting commit 8ffb055beae58574 ("cls_flower: Fix the behavior using
> > > port ranges with hw-offload") fixes that.
> > >
> > > As this is networking, perhaps this is seen on big-endian only?
> > > Or !CONFIG_SMP?
> > >
> > > Do you have a clue?
> > > I'm especially worried as this commit is already being backported to stable.
> > > Thanks!
> >
> > I did a quick look at the offending commit, I can't even connect it to
> > any dst refcnt.
> >
> > Do you have any more information? Like what happened before the
> > warning? Does your system use cls_flower filters at all? If so, please
> > share your tc configurations.
>
> No, I don't use clf_flower filters.  This is just a normal old Debian boot,
> where the root file system is being remounted, followed by the warning.
>
> To me, it also looks very strange.  But it's 100% reproducible for me.
> Git bisect pointed to this commit, and reverting it fixes the issue.

Hmm, does the attached patch have any luck to fix it?

Thanks.

--000000000000498f96059a15956e
Content-Type: application/octet-stream; name="flow_dissector.diff"
Content-Disposition: attachment; filename="flow_dissector.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_k4d9gbf50>
X-Attachment-Id: f_k4d9gbf50

ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Zsb3dfZGlzc2VjdG9yLmMgYi9uZXQvY29yZS9mbG93X2Rp
c3NlY3Rvci5jCmluZGV4IGQ1MjRhNjkzZTAwZi4uMDg4NGY5ODdhY2QzIDEwMDY0NAotLS0gYS9u
ZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jCisrKyBiL25ldC9jb3JlL2Zsb3dfZGlzc2VjdG9yLmMK
QEAgLTE3NjYsNiArMTc2NiwxMCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZsb3dfZGlzc2VjdG9y
X2tleSBmbG93X2tleXNfZGlzc2VjdG9yX2tleXNbXSA9IHsKIAkJLmtleV9pZCA9IEZMT1dfRElT
U0VDVE9SX0tFWV9QT1JUUywKIAkJLm9mZnNldCA9IG9mZnNldG9mKHN0cnVjdCBmbG93X2tleXMs
IHBvcnRzKSwKIAl9LAorCXsKKwkJLmtleV9pZCA9IEZMT1dfRElTU0VDVE9SX0tFWV9QT1JUU19S
QU5HRSwKKwkJLm9mZnNldCA9IG9mZnNldG9mKHN0cnVjdCBmbG93X2tleXMsIHBvcnRzKSwKKwl9
LAogCXsKIAkJLmtleV9pZCA9IEZMT1dfRElTU0VDVE9SX0tFWV9WTEFOLAogCQkub2Zmc2V0ID0g
b2Zmc2V0b2Yoc3RydWN0IGZsb3dfa2V5cywgdmxhbiksCkBAIC0xODAxLDYgKzE4MDUsMTAgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBmbG93X2Rpc3NlY3Rvcl9rZXkgZmxvd19rZXlzX2Rpc3NlY3Rv
cl9zeW1tZXRyaWNfa2V5c1tdID0gewogCQkua2V5X2lkID0gRkxPV19ESVNTRUNUT1JfS0VZX1BP
UlRTLAogCQkub2Zmc2V0ID0gb2Zmc2V0b2Yoc3RydWN0IGZsb3dfa2V5cywgcG9ydHMpLAogCX0s
CisJeworCQkua2V5X2lkID0gRkxPV19ESVNTRUNUT1JfS0VZX1BPUlRTX1JBTkdFLAorCQkub2Zm
c2V0ID0gb2Zmc2V0b2Yoc3RydWN0IGZsb3dfa2V5cywgcG9ydHMpLAorCX0sCiB9OwogCiBzdGF0
aWMgY29uc3Qgc3RydWN0IGZsb3dfZGlzc2VjdG9yX2tleSBmbG93X2tleXNfYmFzaWNfZGlzc2Vj
dG9yX2tleXNbXSA9IHsK
--000000000000498f96059a15956e--
