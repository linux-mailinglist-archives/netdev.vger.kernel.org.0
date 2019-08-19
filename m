Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2414692837
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfHSPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:19:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45503 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfHSPTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 11:19:22 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so9116375wrj.12;
        Mon, 19 Aug 2019 08:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlE+GLnyzdb3Ga/cXVoFLzx8Nb0qIwr4u/H+CCiwIs4=;
        b=FEwXjjEa3SfrrrhnmtRDjG8yqD78V4xmXpCdvrddL8ofOO6ApV9n4wIZmoPu9X8iYt
         LhnOXqCbBJcvY7eiyDrxroJsQWs0knqB0EsnnDLaMeVIKhJOL4mTK4P8kxyJHYKDetFa
         MHcIeENT2n5mKEU7m7iR5Qz9ctCP1ZCVdf/8OkypJFnI9R7rWGhP2ysAq2PBavoKnDvT
         BbjL+pSM+YFu1uUbnm/przUFyUvvELxk5YpcdoHc687M3gG+cgbSNU/XKdGjG6TIe5IH
         IsbvBJpwcIdzMAc7wNNpxKsq0QaDkzwUWlOpucj5JKd0E32LqM+8Z5+jY/kT7GM5BC4v
         BuTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlE+GLnyzdb3Ga/cXVoFLzx8Nb0qIwr4u/H+CCiwIs4=;
        b=myJQ8CceiXU8e8iS71lGNsnmcJ9y+rEKXSBpWfINJzw6OgdcIIeTuBd6j5C8C4zXKa
         irPCIc9wlIINzmbSvY1aSNNE50qUdHpkd0j+ha5RnLwaRWyujKgrJOniAd6NJrf2emBu
         RfKW8rfgK4OlpwzSYGX8fsxq+G27PcBLmTVApfBSf4CUIwqmbNTBdEhrDU0mfeYKkm6P
         cJ2OAoZVWVfcqlBzgfR9TRksJGyQscklYYhmPD6jcxuaQN98XbNTDdMSfLxvZzNiaWjc
         tF31GKpTZgexN3rYqh0udJHTLI/LAsjQNZeeIHjWpy9kcwHpgDfwUACc+7Az+lgdWXgs
         eRDA==
X-Gm-Message-State: APjAAAUr6xnYfvDlfVbZb7gd4DZ3rcB2f8pA3uL2PJAzLwiERWl0sXEy
        uTKAbCtFhssZC3v6YxgeTb8ZmdyP66iGGeNuz+E=
X-Google-Smtp-Source: APXvYqyt/gb2F58YHOGpUpSXvcnfE3LIyurkP71qoWI0io2378KJqpUo8xrQYlG4cOviYrPG6WMwm5KDarBSxBBo8JU=
X-Received: by 2002:a5d:6392:: with SMTP id p18mr29598067wru.330.1566227961168;
 Mon, 19 Aug 2019 08:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1566223325.git.lucien.xin@gmail.com> <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <20190819145843.GE2870@localhost.localdomain>
In-Reply-To: <20190819145843.GE2870@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 19 Aug 2019 23:19:09 +0800
Message-ID: <CADvbK_c3Tv=O4D18w1N-8j_KXjQ-kVwKK0k2u8OPtpQhGoY7MQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 10:58 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Mon, Aug 19, 2019 at 10:02:46PM +0800, Xin Long wrote:
> > +static int sctp_setsockopt_asconf_supported(struct sock *sk,
> > +                                         char __user *optval,
> > +                                         unsigned int optlen)
> > +{
> > +     struct sctp_assoc_value params;
> > +     struct sctp_association *asoc;
> > +     struct sctp_endpoint *ep;
> > +     int retval = -EINVAL;
> > +
> > +     if (optlen != sizeof(params))
> > +             goto out;
> > +
> > +     if (copy_from_user(&params, optval, optlen)) {
> > +             retval = -EFAULT;
> > +             goto out;
> > +     }
> > +
> > +     asoc = sctp_id2assoc(sk, params.assoc_id);
> > +     if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
> > +         sctp_style(sk, UDP))
> > +             goto out;
> > +
> > +     ep = sctp_sk(sk)->ep;
> > +     ep->asconf_enable = !!params.assoc_value;
>
> Considering this will be negotiated on handshake, shouldn't it deny
> changes to Established asocs? (Same for Auth)
ep->asconf_enable is for 'furture' asocs, and furture
asoc->peer.asconf_capable will be negotiated according to
peer ep->asconf_enable (EXT chunk) and local ep->asconf_enable.

It won't affect the 'current'/Established asocs, and the Established
asocs have asoc->peer.asconf_capable, which can't be changed by sockopt.

>
> > +
> > +     if (ep->asconf_enable && ep->auth_enable) {
> > +             sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
> > +             sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
> > +     }
> > +
> > +     retval = 0;
> > +
> > +out:
> > +     return retval;
> > +}
