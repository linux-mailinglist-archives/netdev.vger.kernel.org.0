Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D524E133F11
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgAHKRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:17:02 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43706 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgAHKRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:17:02 -0500
Received: by mail-qt1-f194.google.com with SMTP id d18so2307441qtj.10;
        Wed, 08 Jan 2020 02:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j1l/3YmY8cOPKY2kAlEBXs4uj2kbtX5hdAErR6P5rHg=;
        b=Meho3hOaSSuovx8T9Bg4jC+WqrXIunJm0lqrJ9onQRfWMK7UpbcWbyAd9yU74KHb/+
         6w7FtK8rM6ydvHywBhvDxz/zJhy/u25jly/fgLjuke3N3XwN0zcxdSpyBi0ZZFnYa83V
         52grHE4N/yil8eBq/nDYJwHCaENokFWjHXYmH51GN3CcbhbnaHw892WeK36rq5u2/esu
         IjbzA9fIBe2XL/O4sFtf5fiiF6KSaAmoDGrYOi0yG1h3AP9tVSN/CGB9uM39TvinPHtx
         mHzjZAK8qV0aZWWfQ+UQLyI7G4/BT4gwbWg/QFAk9t1riF5Z7xXNmyZ7g1++7t01SeZK
         srsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j1l/3YmY8cOPKY2kAlEBXs4uj2kbtX5hdAErR6P5rHg=;
        b=XsJVEryORQoFQXV8+2eoo8BgMqPls85GkJip/8G5I/JwE//cWlAwEaX51f2SDygyjB
         b3ht5CHczhbT8pmf8Ikvgzw3Ree//35D2SXP5ONtsabd0vPiVG8RZRApRoGZTTny7mJN
         cMkUB3DcnMajzQEvI4G+YPbg++VX5Cbgb/6u73EhvVExyDHMhi4n9AOOVO3rgYfgNAlZ
         FmGr24Xaajxm85Mvx8mR/Mu8MeAoCJOZWpZNjtuXzVw4II3ZMoqpgMrJepyPRi41qugo
         XxnOcD0qyMDnatjg8UOY3pJIJeGmzDctSmETFJVVrgM0q6KZJVP1osJ+wv+Z5JmrE2Yu
         LOaA==
X-Gm-Message-State: APjAAAVsnL0ip2k1tcgSQRqI/U5njQfYtyone4rTYOm4VBM3EujxYW4Z
        DRoWaVu6MrwpiSKLqxPc5p0p7G5PKgy/0a99ofw=
X-Google-Smtp-Source: APXvYqxLbdu9Jqs2g/nfUNNWZcGHy/KrJ6qtvV5BxKWtJsLpc3u3WjKBlpwSsS1zqz6RxuDX6Y909Db/apgOF18XONQ=
X-Received: by 2002:ac8:104:: with SMTP id e4mr2805748qtg.37.1578478621551;
 Wed, 08 Jan 2020 02:17:01 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-6-bjorn.topel@gmail.com>
 <5e14c6b07e670_67962afd051fc5c05d@john-XPS-13-9370.notmuch>
In-Reply-To: <5e14c6b07e670_67962afd051fc5c05d@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 8 Jan 2020 11:16:50 +0100
Message-ID: <CAJ+HfNg2QFfhrwuEkZJjTKEYHhd1ByHgfmSp7wtwN_w2qB4rqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] xdp: make devmap flush_list common for
 all map instances
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 at 18:58, John Fastabend <john.fastabend@gmail.com> wrot=
e:
>
[...]
> __dev_flush()?
>
[...]
>
> Looks good changing the function name would make things a bit cleaner IMO=
.
>

Hmm, I actually prefer the _map_ naming, since it's more clear that
"entries from the devmap" are being flushed -- but dev_flush() works
as well! :-) I can send a follow-up with the name change!


Thanks,
Bj=C3=B6rn
