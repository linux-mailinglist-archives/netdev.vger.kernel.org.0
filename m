Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01BE418EAFE
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgCVRss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:48:48 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41676 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgCVRss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:48:48 -0400
Received: by mail-qk1-f195.google.com with SMTP id q188so7562646qke.8
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 10:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hiz4/+t3v9Jw8h+t7rdX+ICu/cqrIKmmO6zeCZF7/fw=;
        b=BCnC0wmh7a339V6RV70SLan2k02e4qDOFCIh4oex9+gEy7+Sx3Pj1ALG1Xghc/IoDi
         iJY+jGxUmkg6V4cI33TxGZucvxE4UMBl86B5i61Q7KkKZ3dpKxIBaND+m+c8NYg4+eNs
         6dnU/b2osjO2wy6DYGaArVheBna+MR5AJYZanOnlIuzQI5+l6YU+YbtEPo9+iY2oPhJz
         rK48HdvBYTna7LHVH+uGRhDXiKh0r0H05rU1JFSCQ+H2U3GKTPV6kxyLBzLWgPBTgo4s
         oOPv7UyaLbzjcpuO31iCZlQKmKyP+oMZL61XtbZcwifdd+H83XyvP0nbXtG68gs4C3Wx
         n+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hiz4/+t3v9Jw8h+t7rdX+ICu/cqrIKmmO6zeCZF7/fw=;
        b=hWWSkAP278rONb3UPv9bxhDJTRYm38QV2WfGmE2Bwn0lmtIvaDW3Jj9fIMba/30Vrz
         xSiXqyJdTrwE/r9PUO4CbCP+w/EMPhSKUk0W5BX3H9Kx0kzopcxauRYQsZTyeyw8YmMA
         a895Nxe4OR8ax7xFKx9M0kX7TCgPbKn+1Yf5HycD1GImFvtyDvE+wKAENmk0lm7Nbbh2
         dSWJwBawV7VekVcXtyndHnJLW4jjgXfzUjZEz+G1aCnesw7N/bLqXfpoeCTAXkRzBGB+
         fV9VDHkjDk/VwICe663gqCaFzOXTmy4AsZK9toYZ5S7BesihTX3XTHgWPW4KrZkN4Ts9
         duUg==
X-Gm-Message-State: ANhLgQ0Oz0PCRvzl+0uXzToy4EePfDZ0Dg0FFnBb6oaeDXMD9Q5zJfv5
        5uAlE1V2Nb9LiFq31WY7INUfxBJ2
X-Google-Smtp-Source: ADFU+vvxBYyKvWF0yoH+0tEuyfE1mnUtbQjjwjMjpyWbyxGLMuAxVy0v9rw72jnhfEmJPwb6h0jpeQ==
X-Received: by 2002:a37:4949:: with SMTP id w70mr13102271qka.38.1584899326569;
        Sun, 22 Mar 2020 10:48:46 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id w30sm10922969qtw.21.2020.03.22.10.48.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 10:48:45 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id f17so5722132ybp.4
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 10:48:45 -0700 (PDT)
X-Received: by 2002:a25:ef06:: with SMTP id g6mr27204661ybd.53.1584899324576;
 Sun, 22 Mar 2020 10:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200322160449.79185-1-willemdebruijn.kernel@gmail.com> <20200322162352.GT11481@lunn.ch>
In-Reply-To: <20200322162352.GT11481@lunn.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 22 Mar 2020 13:48:07 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfFPD52D8ghqeQ_VfiTsF8avJ1bN++bpOGL-0=tg7OqdA@mail.gmail.com>
Message-ID: <CA+FuTSfFPD52D8ghqeQ_VfiTsF8avJ1bN++bpOGL-0=tg7OqdA@mail.gmail.com>
Subject: Re: [PATCH net] macsec: restrict to ethernet devices
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 12:23 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Mar 22, 2020 at 12:04:49PM -0400, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Only attach macsec to ethernet devices.
> >
> > Syzbot was able able trigger a KMSAN warning in macsec_handle_frame
>
> able to
>
> Looks sensible otherwise.

Thanks! Will send a v2 right away.
