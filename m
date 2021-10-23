Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7104381DA
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 06:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhJWE1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 00:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhJWE1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 00:27:40 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363C6C061764;
        Fri, 22 Oct 2021 21:25:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v17so322449wrv.9;
        Fri, 22 Oct 2021 21:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HsNjSpBddSv9tryQ9xzGDNEy8JXQU+rUy/MVLAwbRME=;
        b=jy5ZcIvP57WomXcMW60VI6TFTDtn3urDh07JqJaXBpHRnZKyXvsmwWkyPhVxDXQD6H
         7xThGP8oOCU6qLFUU2f0B0iQW/JBKsGbWQ0wKuaAZ12/2jWX7zu9I/EleWssjloJT8WL
         RE3zOvqMW5p82/Fw5OP68+HQdyVUudVKJDIrKniJ8HMRc0WWVDFRTBDpKVkHEC3w3EA1
         lTOy3f2DN+0/di7HKrW3zclOW3T0daInduw8dhXdxhCnex07CMzoKF/xEmX500Ar4vaP
         MUuMMdvAr9gU0Iit/DmHD2kqXmkLZAoyfrpA/xTPL4PFoal2snHTcAt0LKDIoRzo0Qa7
         3jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HsNjSpBddSv9tryQ9xzGDNEy8JXQU+rUy/MVLAwbRME=;
        b=S5ix9MuE0qWTjeVpmufilVdCOt59kXEndQtXIxZczuo86JQNMjUCAuhFT2AGq3xlK1
         js/BlrbwhpUF2iE91UQiyM4UTY03mSTgIB2VvU+SptOYVxGr82CXh4NLLVMARws7gBPU
         BVKcZD7zhey7LwMtER77v9UASdsEmJUNV+ToC3EdybsvnO7vvIxVN+M+Wtjnby0kZzgF
         ui/GmzE1erx1QBU0fs3Hang8tCE9/xYehbao9ZS4OkoodhcWFDE5ng7022DIkdqC+u+z
         LWK/LjscajR+l41GyLMVpEvYPJssa21EeeqUfis93j5d0CEf+ecTu1Pkoh3gJcLTjfTz
         UwDQ==
X-Gm-Message-State: AOAM530KQ61Z8DRMh4S9ppdRTaLC810KSaYokDeXvVFV1lOghzbmxsHj
        2VOv9+XOJfiyo+66/tLnf4qlNpID3Hn9AsGjWfU=
X-Google-Smtp-Source: ABdhPJybFKyxWXp+82TksZjNTriAlUdnqoRsE7BuqJVQi3gzwFEvSAsE9jR882WUUQXM1dLVKNOmwNOxyELOUiIOM5U=
X-Received: by 2002:adf:e689:: with SMTP id r9mr4916259wrm.426.1634963120548;
 Fri, 22 Oct 2021 21:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634884487.git.lucien.xin@gmail.com> <615570feca5b99958947a7fdb807bab1e82196ca.1634884487.git.lucien.xin@gmail.com>
 <20211022083558.5fce8039@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211022083558.5fce8039@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 23 Oct 2021 12:25:09 +0800
Message-ID: <CADvbK_cx_sSSp9SOeQjh-yBrrui38Otr8EiXC9O5=0mc1-kF1g@mail.gmail.com>
Subject: Re: [PATCH net 1/4] security: pass asoc to sctp_assoc_request and sctp_sk_clone
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        davem <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 11:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 22 Oct 2021 02:36:09 -0400 Xin Long wrote:
> > This patch is to move secid and peer_secid from endpoint to association,
> > and pass asoc to sctp_assoc_request and sctp_sk_clone instead of ep. As
> > ep is the local endpoint and asoc represents a connection, and in SCTP
> > one sk/ep could have multiple asoc/connection, saving secid/peer_secid
> > for new asoc will overwrite the old asoc's.
> >
> > Note that since asoc can be passed as NULL, security_sctp_assoc_request()
> > is moved to the place right after the new_asoc is created in
> > sctp_sf_do_5_1B_init() and sctp_sf_do_unexpected_init().
> >
> > Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
> > Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> missed one?
>
> security/selinux/netlabel.c:274: warning: Function parameter or member
> 'asoc' not described in 'selinux_netlbl_sctp_assoc_request'
> security/selinux/netlabel.c:274: warning: Excess function parameter 'ep' description in 'selinux_netlbl_sctp_assoc_request'
Yup, the function description also needs fixing:

@@ -260,11 +260,11 @@ int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,

 /**
  * selinux_netlbl_sctp_assoc_request - Label an incoming sctp association.
- * @ep: incoming association endpoint.
+ * @asoc: incoming association.
  * @skb: the packet.
  *
  * Description:
- * A new incoming connection is represented by @ep, ......
+ * A new incoming connection is represented by @asoc, ......
  * Returns zero on success, negative values on failure.
  *
  */

Thanks.
