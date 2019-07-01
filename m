Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886915B2DB
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 04:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfGACAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 22:00:31 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41609 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfGACAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 22:00:31 -0400
Received: by mail-yb1-f195.google.com with SMTP id y67so8101766yba.8
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 19:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z1ltI3+n+/F37JJP4EsgA2U550hB9+8Dbz+jn5lLG08=;
        b=RyJnSqWyMFFXWABnA/14NlHqZrEH1zx2LWxFfUd2mwTrOmyShw1F/Yhu5NynzB+E++
         IaQmqeTGdsZBLTygY10FyHmWg7amlrZTHUn98iIvdj/wYbxVwxZz5TGt/nRHg9uZnpHF
         Z3du++HeMUetaelFhUG4oYrx8XGWCpCVBwYB5rd3NkuoIptJK1vXnbLwpeI+UE0l54Wv
         RN9zhNEgH7sqXXi2wzZR9otgcLpDDyeIclI333BPRAmJCCNH0bwmNOb2D+al8L7aRzgh
         csw2P5QCyWYO3BD/XKSP3jSyKQC8v8ZrqnYnmztNSBG2K8V9cvhP5pn+LEC2yNn7ao+8
         c8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z1ltI3+n+/F37JJP4EsgA2U550hB9+8Dbz+jn5lLG08=;
        b=HBPM6WW5WlcNvnLpW0PPLUg2eqlxYTHz7EM5ioNAN5dCGfAgN3ksXD72dabsyEt+Yb
         SBcStQxZXup4pJYS+KMtmpN4bdb/YiViu+AjwvFSrWU71meiqXtVauSmQzWu2hp9lrjr
         2HQfOZGnaAmwSRMSVvqBRZuEzpsO44npJjWbdOmMeIyW8hAGk620LY5sz+KLNIUFP54+
         /kJr4sMPcBKxGGyEJBx20g9RKFUm6b9Z0wNPqX3dTPwym2Wa2kfMPP1mP8cghjWaZN3F
         7HnYit/VePr0ZFi6sH2knRXZmGsm5gCTXspSxjhyYOzdzKTNjrLLD6dYnsh8rP6BKpvB
         lKZA==
X-Gm-Message-State: APjAAAXQLvw/VO1uIVoc68CgKh0dZN9/2C1bGV3XTjC8cf4M8Pel+v1G
        tqBoc64k5IezAb3/QAcAmx4uLeEN
X-Google-Smtp-Source: APXvYqzu/+K4jwQrY7fTr32kMzWFueUuIHcl74B175+5yrpvepK04GRcZP3MuknuucmIMXKh0duC7A==
X-Received: by 2002:a25:950:: with SMTP id u16mr279237ybm.17.1561946429739;
        Sun, 30 Jun 2019 19:00:29 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id h7sm2256580ywh.60.2019.06.30.19.00.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 19:00:29 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id t10so1323091ybk.3
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 19:00:28 -0700 (PDT)
X-Received: by 2002:a25:7246:: with SMTP id n67mr13629378ybc.441.1561946428576;
 Sun, 30 Jun 2019 19:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <b10a63b0fb7be5a51de207198e0e6aa47dfda015.camel@domdv.de>
In-Reply-To: <b10a63b0fb7be5a51de207198e0e6aa47dfda015.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 30 Jun 2019 21:59:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTScas7enPCpE3SY7B-rzRUQi307saddo4Gs7k57sq7-WVw@mail.gmail.com>
Message-ID: <CA+FuTScas7enPCpE3SY7B-rzRUQi307saddo4Gs7k57sq7-WVw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] macsec: remove superfluous zeroing of skb reference
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Network Development <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 4:48 PM Andreas Steinmetz <ast@domdv.de> wrote:
>
> Remove superfluous zeroing of skb pointer for the RX_HANDLER_CONSUMED
> case, since in that case, __netif_receive_skb_core will simply ignore
> the value.
>
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>

Acked-by: Willem de Bruijn <willemb@google.com>
