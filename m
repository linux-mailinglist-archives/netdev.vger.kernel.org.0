Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE2BF9837
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 19:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKLSE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 13:04:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36918 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726738AbfKLSEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 13:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573581894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dWPZ+20bYMqLKSKdB7YzQ5ZolIRgFXxdk3R6ceGWss=;
        b=W7IGALZ+oWImB2wNH0L/JEpqWvIXST/Wt70ni38nTnW+H8rjIruSzN1u+eXwju1cfzOPrz
        JhmwWt41ytdDfHSIVoXjwdB5e98+aH8mL9wqWlGgZ4WFLkrj7hTxy26bb4/CZLE5C/FZjT
        Z65mqfWq7EyN933wGHMego9HqZuCZhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-Vux4wtG9Pkiops5abryKtg-1; Tue, 12 Nov 2019 13:04:53 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B2DF140180;
        Tue, 12 Nov 2019 18:04:52 +0000 (UTC)
Received: from ceranb (ovpn-204-115.brq.redhat.com [10.40.204.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17F332CE03;
        Tue, 12 Nov 2019 18:04:50 +0000 (UTC)
Date:   Tue, 12 Nov 2019 19:04:50 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/sched: actions: remove unused 'order'
Message-ID: <20191112190450.6b5786fb@ceranb>
In-Reply-To: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
References: <e50fe84bfbe3c6fa8c424a5a0af9074c2df63826.1573564420.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: Vux4wtG9Pkiops5abryKtg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 15:33:11 +0100
Davide Caratti <dcaratti@redhat.com> wrote:

> after commit 4097e9d250fb ("net: sched: don't use tc_action->order during
> action dump"), 'act->order' is initialized but then it's no more read, so
> we can just remove this member of struct tc_action.
>=20
> CC: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/net/act_api.h | 1 -
>  net/sched/act_api.c   | 1 -
>  2 files changed, 2 deletions(-)
>=20
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 0495bdc034d2..71347a90a9d1 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -23,7 +23,6 @@ struct tc_action_ops;
>  struct tc_action {
>  =09const struct tc_action_ops=09*ops;
>  =09__u32=09=09=09=09type; /* for backward compat(TCA_OLD_COMPAT) */
> -=09__u32=09=09=09=09order;
>  =09struct tcf_idrinfo=09=09*idrinfo;
> =20
>  =09u32=09=09=09=09tcfa_index;
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index bda1ba25c59e..7fc1e2c1b656 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1003,7 +1003,6 @@ int tcf_action_init(struct net *net, struct tcf_pro=
to *tp, struct nlattr *nla,
>  =09=09=09err =3D PTR_ERR(act);
>  =09=09=09goto err;
>  =09=09}
> -=09=09act->order =3D i;
>  =09=09sz +=3D tcf_action_fill_size(act);
>  =09=09/* Start from index 0 */
>  =09=09actions[i - 1] =3D act;

Reviewed-by: Ivan Vecera <ivecera@redhat.com>

