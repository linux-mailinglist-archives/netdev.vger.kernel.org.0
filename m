Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC41960ED
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgC0WRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:17:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49493 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727677AbgC0WRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:17:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585347419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RDh3LFZbbssgAdAbHWWA37QQoc8QtrlPd+JUjMAzmKQ=;
        b=Y2xd5G0cZub4bxPnKlUtwIIqpsXOHHU1J10x2uyqtUOuEGVX9LiRpjYJK+JXUzeos9xZzc
        U/xww2VGKZVZqCbAktqWELnfvdxfCatkom5i04QrgNF8HoWiOvh15zdSq91KVc8DFNWKOE
        JKYrkE5FgQHW8lHTI+VX75FVP0oGcNc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-QCj3J6pbO2uj1TA5LI7NJg-1; Fri, 27 Mar 2020 18:16:57 -0400
X-MC-Unique: QCj3J6pbO2uj1TA5LI7NJg-1
Received: by mail-lf1-f72.google.com with SMTP id i2so4319090lfe.7
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RDh3LFZbbssgAdAbHWWA37QQoc8QtrlPd+JUjMAzmKQ=;
        b=VLcxut7Q+M6UNuX+OnDTawh2kHrDkq7WLaI6fZTPJKbyR6cyOXe40l+FjjD+wsisfT
         F/rgBAgbeKFxITeSsKP3fBx1iNB2GY31iLMJD56M9RAVUUvLnroZi78wXAbYS0H7S6QQ
         P8n+Jqwy/+2BYbL3MYSY98+aXN5R4SdjjOj3sv3CBuU8CXudV5qjL1O76NCQnbC3aJd8
         q2VFQwYMT7fWn6DkXp7aRQVoZZW3yVx+0D6+fsFxLHJyN892De+Xe5z7vJX6TIQ5n+Db
         w0miLfjeTlRcpj9wBHDlJGDf/XFjSj2SENInvCpIRwEK3A1RQK71Q7eSsG/k0RqUEhgP
         cGOg==
X-Gm-Message-State: AGi0PuY3DhaBoaEV/5nifYFuLbvjQokcK911dDqMjIbeZuIi6t0H6jIp
        awDRSVVo2j4nCxL/gC8yL0Mv/IqlNVDKUTJTgjbukxqmrBRu1lxDehHXxGu7tTKzpGBbEBAP+wC
        D0jMxHdhTE3xikz+g
X-Received: by 2002:a2e:9757:: with SMTP id f23mr591945ljj.269.1585347415950;
        Fri, 27 Mar 2020 15:16:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJRZ1d05vO3Z/RzbY8b19DajZoaWjLHYIVLCDFq0EBcwPnbyppbDwdE6i2Ri8huW4taV+nkyA==
X-Received: by 2002:a2e:9757:: with SMTP id f23mr591922ljj.269.1585347415700;
        Fri, 27 Mar 2020 15:16:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d19sm3199247lji.95.2020.03.27.15.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:16:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D06518158B; Fri, 27 Mar 2020 23:16:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing program when attaching XDP
In-Reply-To: <CAEf4Bza7zQ+ii4SH=4gJqQdyCp9pm6qGAsBOwa0MG5AEofC2HQ@mail.gmail.com>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk> <158462359315.164779.13931660750493121404.stgit@toke.dk> <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk> <20200320103530.2853c573@kicinski-fedora-PC1C0HJN> <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch> <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com> <87tv2f48lp.fsf@toke.dk> <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com> <87h7ye3mf3.fsf@toke.dk> <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <87pncznvjy.fsf@toke.dk> <CAEf4BzaPQ6=h8a6Ngz638AtL4LmBLLVMV+_-YLMR=Ls+drd5HQ@mail.gmail.com> <87lfnmm35r.fsf@toke.dk> <CAEf4Bza7zQ+ii4SH=4gJqQdyCp9pm6qGAsBOwa0MG5AEofC2HQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Mar 2020 23:16:52 +0100
Message-ID: <87wo75l9yj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> Please stop dodging. Just like with "rest of the kernel", but really
> "just networking" from before.

Look, if we can't have this conversation without throwing around
accusations of bad faith, I think it is best we just take Ed's advice
and leave it until after the merge window.

-Toke

