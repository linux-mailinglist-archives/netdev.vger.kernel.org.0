Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8678196FB3
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 21:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgC2T05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 15:26:57 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40026 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbgC2T05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 15:26:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id c20so4946138pfi.7;
        Sun, 29 Mar 2020 12:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sPMPtXybkPRv6l8ijINpE3FkTaYU6QeaJDEhFXau+5k=;
        b=U+YnztsnFG2sbQF4zl4gDayWyHuH40rC7lYebX8lMvJy0/zk1q9b/jqPU1lJtXIf8c
         Oq3BAsuGD0UEb2FRMRr2B+WcNOmpEqbyHnO2NgM8RDtnYTb4pJR81PnO10A7bY+RrNZl
         u+hlvhVmOh/wCJl3KIRX1xosrlBPHRWYlJ6WQ2+2T8rfVVrwhzjSoAdeUTl0wn/wb1/I
         pmKgFtTPqdLXahU+zIdhGxYLcNUu9f+3oRMveR4q5tSX8u2n2DogPjWmyFBjRQuTAkk8
         Y9rK8xtf5rrsjlJTRH+sCFEmr94yZ5XS+e5lOnAg/8Fy8yEizV8ce52E/ifYPXtzjngc
         E/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sPMPtXybkPRv6l8ijINpE3FkTaYU6QeaJDEhFXau+5k=;
        b=qDGc7z3l8yPuDecy+UVQ7iMQnuSNMUJ40McOXS3TcUlT58QkB3i/28Ke1UsArT3xGs
         ClgzAud448IFd1wIWyE2GcXWTnowmGze9RcevaHRx6xo63shAnB6MrI6xGN/H5YJ3h1x
         nrX509Mbyt2s1dMdO40Cu9gVP7QpVDJldPVGA6t5JmbWJAZjxlpwhV/Ai3yYsB/TFpEd
         DY0YgKDrEKxBvE1yGxZcjZdSMHQMnV+GdXIW/qcNykPQjG4j8XhOX/3w4RMKtQ2kL8N4
         ehkWpHXwswdrAWvofvjg+I2kmMg9A7EOBDeb5IkTEYQhotthwQB/NjT7VvfOvVauIgBo
         RnuA==
X-Gm-Message-State: ANhLgQ00NFPVxr7Ps3Fpe6bdVqxqJBr/Xnip0fEZaTxBfTzlqaoahHqw
        ttLlqd54jb20S2JmhVn6T+s=
X-Google-Smtp-Source: ADFU+vvp5zyS/gNYDfgCCRxhpZ9A3QSRhN4OgGnmfr+hIa9HzMKOY356ND1aorjZkphGn/OkJjHLog==
X-Received: by 2002:a63:7416:: with SMTP id p22mr9853353pgc.32.1585510014330;
        Sun, 29 Mar 2020 12:26:54 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:6705])
        by smtp.gmail.com with ESMTPSA id g4sm8619136pfb.169.2020.03.29.12.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 12:26:53 -0700 (PDT)
Date:   Sun, 29 Mar 2020 12:26:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200329192650.w55hcof5ix6tb54s@ast-mbp>
References: <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
 <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk>
 <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk>
 <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk>
 <20200328233546.7ayswtraepw3ia2x@ast-mbp>
 <87369rla1y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87369rla1y.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 12:39:21PM +0200, Toke Høiland-Jørgensen wrote:
> 
> > I guess all that is acceptable behavior to some libxdp users.
> 
> I believe so.

Not for us. Sadly that's where we part ways. we will not be using your libxdp.
Existing xdp api was barely usable in the datacenter environment. replace_fd
makes no difference.

> exclusivity does come in handy. And as I said, I can live with there
> being two APIs as long as there's a reasonable way to override the
> bpf_link "lock" :)

I explained many times already that bpf_link for XDP is NOT a second api to do
the same thing. I understand that you think it's a second api, but when you
keep repeating 'second api' it makes other folks (who also don't understand the
difference) to make wrong conclusions that they can use either to achieve the
same thing. They cannot. And it makes my job explaining harder. So please drop
'second api' narrative.
