Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB46133F33
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgAHKXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:23:49 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57049 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726252AbgAHKXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578479027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYTFZUh6du+Gz6t/z7W4n8/MYAr68zER/bUdAggvIsw=;
        b=IkAqKeJZ/GUtzk98sTXzDM72OH5rS3k7bWsHpdt0ZbJ844DUEvhTJbwEZF3EMD3HIqRgUI
        YY7Bi/Y2SIdmeWjExWNKnQjmIuRm7XW/xEqCArQJb7CWIrHGgmTx1TcbcSdNa2+20vxUZk
        ySwoFQ/+rgg4Evyr5y57HghWMCQhIzw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-JqfG69ODNAGoP0x8W7BUyg-1; Wed, 08 Jan 2020 05:23:44 -0500
X-MC-Unique: JqfG69ODNAGoP0x8W7BUyg-1
Received: by mail-wm1-f69.google.com with SMTP id y125so3873792wmg.1
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 02:23:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pYTFZUh6du+Gz6t/z7W4n8/MYAr68zER/bUdAggvIsw=;
        b=nTwQmcTcthxy1d/86+qgh8Ttp8N5ycGMq1+myJof9fLtE9/WcsjXYGP0W94gG58JTr
         z/F6qKRy388AwYNH6jEsSNrXQ6pSUszQrfdkD1R9m7zJizYtOn+6W7j3fXNk8h39Yr3h
         kFnIDf250urN+eilMOVe+W487soHLLKunDxwL2EDYPO7XIzjKHOb73rFvxDeXeEUJcMO
         45s+TJxErOV0Yn+BDtpF2vW9NNY/nnx5g/RQSBfferbJKrATFWjSHk7Pfh+a1zl+S4Hn
         KRTVwkLVmC9+PA10yB3EkDimBPGGVRBBNZrdiLzC3L3ZziIck8gFDolWsU1Zmxb9D+s2
         9+QA==
X-Gm-Message-State: APjAAAXRq0e0TSubNAthCTES6Oq0laMeMdEeNFSQ78seNzrSgDNHtSjx
        b6tEEAoDX85xUoejuF47IfKOr9XdIkGopahGbqcIr2GfEldLdpDXvVWS3JuLFzD5C2C4VE/5mu+
        hT4ZHT2HYgsLdvpJC
X-Received: by 2002:a05:600c:10cd:: with SMTP id l13mr3158411wmd.102.1578479023559;
        Wed, 08 Jan 2020 02:23:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUIZNNclF0SdFdxtPbsI9I5SbnKealXcVOejTCf6A0OXRL0VRe9MnBSxvx2aWufdwqYf9NAA==
X-Received: by 2002:a05:600c:10cd:: with SMTP id l13mr3158389wmd.102.1578479023381;
        Wed, 08 Jan 2020 02:23:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t1sm3243186wma.43.2020.01.08.02.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 02:23:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E2BA9180ADD; Wed,  8 Jan 2020 11:23:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] xdp: make devmap flush_list common for all map instances
In-Reply-To: <CAJ+HfNg2QFfhrwuEkZJjTKEYHhd1ByHgfmSp7wtwN_w2qB4rqA@mail.gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-6-bjorn.topel@gmail.com> <5e14c6b07e670_67962afd051fc5c05d@john-XPS-13-9370.notmuch> <CAJ+HfNg2QFfhrwuEkZJjTKEYHhd1ByHgfmSp7wtwN_w2qB4rqA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 08 Jan 2020 11:23:41 +0100
Message-ID: <874kx6i6vm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Tue, 7 Jan 2020 at 18:58, John Fastabend <john.fastabend@gmail.com> wr=
ote:
>>
> [...]
>> __dev_flush()?
>>
> [...]
>>
>> Looks good changing the function name would make things a bit cleaner IM=
O.
>>
>
> Hmm, I actually prefer the _map_ naming, since it's more clear that
> "entries from the devmap" are being flushed -- but dev_flush() works
> as well! :-) I can send a follow-up with the name change!

Or I can just change it at the point where I'm adding support for
non-map redirect (which is when the _map suffix stops being accurate)? :)

-Toke

