Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9952A11799C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLIWnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:43:47 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33811 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfLIWnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:43:46 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so17585960ljc.1;
        Mon, 09 Dec 2019 14:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D75YnJIPh5gmhaqqu7KhTD5iBcWNTLpDqbegImS59NU=;
        b=feasfb8N+dNU6r7zMLVw2UZUBJzvY3N+5u8UKI6a7VrU+78jZUjrtDxN8aNJYruMds
         9ZeAE6cZEtovG3GGCn51wngTQG0frqn4B8CIVgbQm8gDBli0jrhw9Mq07By72e8CTUBF
         aK6fBNIR+XrKjddlza95kmCJcMn/TfA8v7VF9b4GpLus5uEPzGkJcNLeAu7k3207nr74
         ez7jYJgM/QBbZveJrgilYodC6T3qbDxQKTjrMk7uvzEGNgoRBFvd5god/BQLX6Xc/wQC
         yySo6ZQaAN1VvJKJs1XuujTja/C32tcf6pGi3RNMLqVfzYCcd4QiYa5s4r+LWIAwlC7h
         8epQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D75YnJIPh5gmhaqqu7KhTD5iBcWNTLpDqbegImS59NU=;
        b=BPxRHe/DBdv2odaiHqV6Z8GwnTV2USxCHZSomETLCNMA/O3kptEXBaPnExP2Mdytfd
         O08zxWWZ9FM0WUPwSiMfOlvFxVpkoLyEa4GM2qr+ks2Uy4MxDStM0cq37G8zyYAXhiIJ
         ZUkgGuavh1yPaZCjxcLd0GVNFAmULINbzsXlMMOBd6X6ZPopEVxi/XNkctxEuQqmh+Ga
         LQY1hT0jT0f0yfZA4FlwDxQnk27X4+lwSaiXBLymQVb3IcsAjpxQfuBxKQaN8U/t3CcY
         7+NsxiU/MRup0+x5BE2hpqtl7WtWP6Mm8w2l5MnucpAJ1El8GfmHKoRs7q+R/uK1n5KT
         H8cQ==
X-Gm-Message-State: APjAAAWDeJIPQU7yU37xfNBahxAtndGjpK3bpVwVCuh4hxQmV78HAei1
        mUAGbftEGiu+du67qkzb/r6szJ5AH3pqnpLeuNk=
X-Google-Smtp-Source: APXvYqxCa2Dm5CV9kQG6sOpppHWVUmuv0nFK+4hTDfJ0yh3y7Q0vAutXkfTbb19pF91VqtJGFG94Aem0yiEf4Z6Qj20=
X-Received: by 2002:a2e:854c:: with SMTP id u12mr17407417ljj.135.1575931424324;
 Mon, 09 Dec 2019 14:43:44 -0800 (PST)
MIME-Version: 1.0
References: <20191127001313.183170-1-zenczykowski@gmail.com>
 <20191127131407.GA377783@localhost.localdomain> <CANP3RGePJ+z1t8oq-QS1tcwEYWanPHPargKpHkZZGiT4jMa6xw@mail.gmail.com>
 <20191127230001.GO388551@localhost.localdomain> <CAHo-OowLw93a8P=RR=2jXQS92d118L3bNmBrUfPSBP4CDq_Ctg@mail.gmail.com>
 <20191204182703.GA5057@localhost.localdomain>
In-Reply-To: <20191204182703.GA5057@localhost.localdomain>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 9 Dec 2019 23:43:33 +0100
Message-ID: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
Subject: Re: [PATCH] net: introduce ip_local_unbindable_ports sysctl
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since net-next is open, I'm resending, with just Cc/reviewed-by
updates - code is the same.
