Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB094702C4
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhLJOaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:30:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239604AbhLJOaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:30:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639146394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=noxZ/W/0Xblh7NLRVhPVVF1MXLgMaduXPJ/ayJxQT44=;
        b=YSFJnZ1kfyt10dXunST5dxeGarAzCxjJO3nfVsgevh6IVkTVyBHhXG284tGj4ug8sAxmcv
        95uEj3Sej2vf0bH3gYUhAV6NKtVKQuOT4NXA5DouWlvqWsKm+NmL0zMjB9FY2GI3IL1Iue
        kRYXuL/XRHRvZM/VpZZMJheyln/WEao=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-276-4ZUbZRcTNxGhSLb6AMnLbw-1; Fri, 10 Dec 2021 09:26:33 -0500
X-MC-Unique: 4ZUbZRcTNxGhSLb6AMnLbw-1
Received: by mail-ed1-f69.google.com with SMTP id 30-20020a508e5e000000b003f02e458b17so8310070edx.17
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:26:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=noxZ/W/0Xblh7NLRVhPVVF1MXLgMaduXPJ/ayJxQT44=;
        b=SRg4V+UzI8sjNPxPhqy1Sd653aF1ehQOImiOWWSA07cu5GLlcsA0yxV4c5t7P5mmBW
         +lHA8uAyqSbxIXQbS2zTv8oTFEOxsMxqRhH3omeE0wYH5PC1Fq/mHpd7vYAgxL47ZIYa
         GAastpE2gMlHbq4/rGpnljweOG2lo9XVpaLozbtqGAqpfpo8+nkyKFP5pcGV2TEs/7qH
         RJE4YpQLdLGtaG3DIAUDo49ZGuOyaZaJi/Zn5DBY+4BVBkA5ItaFdkxUY8asDQlApzlK
         fVx67MCnPSDVE4NF0QoCyImtBlHhOLVz+lMri/XlkRPAMxZKvcRkUwP9BHWIqKaiWebH
         1kNQ==
X-Gm-Message-State: AOAM531zaw5UEsGuQuBCbXIxSj5Qvi7WXL5XCk+R10QMgP0oUNDHJCDk
        DQOZmnyFcVH0PmGgGEsRiw7N5eRfXBkyJ1lcQ+U05b0PnOtfa52bgmmDKGfPKgyexAznuowHiPI
        U6Sjj1s/By6cQCaWb
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr37679209edb.70.1639146391878;
        Fri, 10 Dec 2021 06:26:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTXnanOiDzBPfrU73QKrpktq3WDMTp3GvxqnQWsi3ADVa6J+V1WYizuPyjjSzVXe0txRMJtA==
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr37679166edb.70.1639146391541;
        Fri, 10 Dec 2021 06:26:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z22sm1567067edd.78.2021.12.10.06.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:26:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 52BAF180471; Fri, 10 Dec 2021 15:26:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Yihao Han <hanyihao@vivo.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: Re: [PATCH v2] samples/bpf: xdpsock: fix swap.cocci warning
In-Reply-To: <20211209092250.56430-1-hanyihao@vivo.com>
References: <20211209092250.56430-1-hanyihao@vivo.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Dec 2021 15:26:30 +0100
Message-ID: <877dccwn6x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yihao Han <hanyihao@vivo.com> writes:

> Fix following swap.cocci warning:
> ./samples/bpf/xdpsock_user.c:528:22-23:
> WARNING opportunity for swap()
>
> Signed-off-by: Yihao Han <hanyihao@vivo.com>

Erm, did this get applied without anyone actually trying to compile
samples? I'm getting build errors as:

  CC  /home/build/linux/samples/bpf/xsk_fwd.o
/home/build/linux/samples/bpf/xsk_fwd.c: In function =E2=80=98swap_mac_addr=
esses=E2=80=99:
/home/build/linux/samples/bpf/xsk_fwd.c:658:9: warning: implicit declaratio=
n of function =E2=80=98swap=E2=80=99; did you mean =E2=80=98swab=E2=80=99? =
[-Wimplicit-function-declaration]
  658 |         swap(*src_addr, *dst_addr);
      |         ^~~~
      |         swab

/usr/bin/ld: /home/build/linux/samples/bpf/xsk_fwd.o: in function `thread_f=
unc':
xsk_fwd.c:(.text+0x440): undefined reference to `swap'
collect2: error: ld returned 1 exit status


Could we maybe get samples/bpf added to the BPF CI builds? :)

-Toke

