Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6886B317
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 03:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfGQBSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 21:18:04 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41126 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfGQBSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 21:18:03 -0400
Received: by mail-lf1-f65.google.com with SMTP id 62so10218753lfa.8;
        Tue, 16 Jul 2019 18:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cGIrD8hmFJN1O8PXvtPzZbs27wrTnDcmi4staxVd3OI=;
        b=qAb4kIaPKdgexPaSXtzjYxWmilrDzboXMzAQ75KtpRLYXailuTWRPOkerE8fyK2CE8
         QYFImlF3YoVD5qiSxrCBTBzjTHkekfY2gcaZrxL4r/BTxH2oczbZ+dk9L1GwtzscHeDg
         98p6wKF3je75O+8s0IGmHoGeX5nt20RXcP2Hm5wf+7+mi0Te7O52ra2Fsa6HCYqYb+3Y
         zX2TMFcslGRuoHPc2y115AADgTt6gqswC9AMDQzdiKH3eGPM9N3cJFpTtTWF5ec7aaJ0
         mmUBXZIQTnJWjJ5Xtl6LuIdsmvwqqop0Thh/Oc7KAh9pV2r9UL/LjXB1lojJR1mHfQG8
         GaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cGIrD8hmFJN1O8PXvtPzZbs27wrTnDcmi4staxVd3OI=;
        b=gCCJGab19141hNaWmPKVtcBmIp1R8zS/KKoSIMrr87wgpa/zqtWzV4PqM0g6qGtGi2
         +5P5kLXtbpPh8cV7C0K2ucNu7F+mZmG5a4nPEP67f68Urm9nTASqhzlVpymQRhK1VHVp
         eZCA4Vz/xZL4lA2QgBJYh6MbHPlsUYRkYEYc82HKJWx4lAtMYKccwVAmQ94hkGr/U2l5
         Z4/xfSRKMY9FW+JJceEzPAB86XrUNW0zdgeDcyyxP2bnab/wR25pVmwi1HUFCdiuOQoS
         9zKRRppwl2QaHihmwMre8Y/y1fIIS+9DCTOjyRHl0hjA5LySmtbtcauseE5mBvMSyGue
         RF3g==
X-Gm-Message-State: APjAAAWMFrdUOmwGalO2p3eftDIbySYr9dS3g6cJQX6U2XvdgEeb2n8Z
        6n0uqsj/oQwvEBYOBbcSw/O1nHwFYNUqgvrZWSA=
X-Google-Smtp-Source: APXvYqzIUUcr4f0vfvtcm3leALHR2jLLCZsjwSgpnOid53MDmvyhMH9vJ45jDJt0oRiAo8ecibzdGvlu+hgkVhvU6Z4=
X-Received: by 2002:ac2:465e:: with SMTP id s30mr2156488lfo.19.1563326281722;
 Tue, 16 Jul 2019 18:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
 <CAEf4BzavePpW-C+zORN1kwSUJAWuJ3LxZ6QGxqaE9msxCq8ZLA@mail.gmail.com>
 <87r26w24v4.fsf@netronome.com> <CAEf4BzaPFbYKUQzu7VoRd7idrqPDMEFF=UEmT2pGf+Lxz06+sA@mail.gmail.com>
 <87k1cj3b69.fsf@netronome.com> <CAEf4BzYDAVUgajz4=dRTu5xQDddp5pi2s=T1BdFmRLZjOwGypQ@mail.gmail.com>
 <87wogitlbi.fsf@netronome.com> <20190716161701.mk5ye47aj2slkdjp@ast-mbp.dhcp.thefacebook.com>
 <20190716151223.7208c033@cakuba.netronome.com>
In-Reply-To: <20190716151223.7208c033@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jul 2019 18:17:49 -0700
Message-ID: <CAADnVQLQtDLQRXY+MuSRzpxZdnE0BZiU7O6eayGttyt-vpErqg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiong Wang <jiong.wang@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, oss-drivers@netronome.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 3:12 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 16 Jul 2019 09:17:03 -0700, Alexei Starovoitov wrote:
> > I don't think we have a test for such 'dead prog only due to verifier walk'
> > situation. I wonder what happens :)
>
> FWIW we do have verifier and BTF self tests for dead code removal
> of entire subprogs! :)

Thanks! Indeed.
