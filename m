Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A299FCAA1F
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389765AbfJCQTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:19:49 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51397 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389753AbfJCQTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570119585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AkcMZ0vXJw2fM4NbI74MKkqeiUornhUFHGHSjLzluk4=;
        b=Uoe260nfSplZyNYjH+8SOWy+XFmac8wgDhYVcFh7Ei/FTL0zPVZi9kE9nuimgaLZArq3YA
        qIA11v8vD+I35X7hDA0r0C0XwR2O9q9/6tuQJBA/7DyQSyWGer88rE4SpLuqHKOOEnGDni
        QghHzjBh2MxI5tF6IsiKs5z6zMFuDU0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-vj7dKT_UP5a61gHUkTfgVA-1; Thu, 03 Oct 2019 12:19:43 -0400
Received: by mail-wm1-f69.google.com with SMTP id o8so1341349wmc.2
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 09:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=eq/B97dVVGa05wBfdg3Irt1piSr2B9K1quPUW238cNk=;
        b=ckcZvnjKQ2bkhFXgXq/+lFwDzV+VFF+DIU3NbXyTIF4QTOzAxYyv6GU9rTyLYQPFB0
         /ncd4LZ5gE6HigYnqbxSC4bbNfdKcEj01bE46vscAgywXAlp1jkYKUOCWDS1m3cK0knf
         UckIfOqGk36TqaEkNuskXeRBf/peF+rmfj7dHT9JE2rs6NGMklSdA8eG9ezDAMtuzXvB
         946yQDBjFWkdrFIa5ZE+3cbH9YZtjGLo75tTkEdkRngz9fHqy+ZS0rVBnQZ2Luq0P7cQ
         E+xFa4Q5h0b8Tr/J0fGY4xYQyWNlX9+9BUl9h2sWfgNeeJO3HfbK/wwUSQ6I5q37Tl7M
         PM3Q==
X-Gm-Message-State: APjAAAWMnVOww4VfLh8GgtIiQz4/fd3+hapB2SliQ1j1EWUjuea2iTGt
        3BafvrNfZmtLsJPHS6QELSz88KWsh67PYV4S1pWKopoVu4rnsYNbepCfwSB0bUKMQnYwxaxP4Gg
        r646HyW4/3dupRzCu
X-Received: by 2002:a7b:cb08:: with SMTP id u8mr7985938wmj.6.1570119582594;
        Thu, 03 Oct 2019 09:19:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxT2JZqiia0R/m+IWVWcMMURfBr+zKVxKDqf4uyXTa8c4XEoAzj4fB2BVwN2oRoUtaWmLWETQ==
X-Received: by 2002:a7b:cb08:: with SMTP id u8mr7985923wmj.6.1570119582360;
        Thu, 03 Oct 2019 09:19:42 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id f13sm3884098wmj.17.2019.10.03.09.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 09:19:41 -0700 (PDT)
Date:   Thu, 3 Oct 2019 18:19:40 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Ease nsid allocation
Message-ID: <20191003161940.GA31862@linux.home>
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
 <20191001.212027.1363612671973318110.davem@davemloft.net>
 <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
MIME-Version: 1.0
In-Reply-To: <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: vj7dKT_UP5a61gHUkTfgVA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 10:46:03AM +0200, Nicolas Dichtel wrote:
> Le 02/10/2019 =E0 03:20, David Miller a =E9crit=A0:
> > From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > Date: Mon, 30 Sep 2019 18:02:12 +0200
> >=20
> >> The goal of the series is to ease nsid allocation from userland.
> >> The first patch is a preparation work and the second enables to receiv=
e the
> >> new nsid in the answer to RTM_NEWNSID.
> >=20
> > The new reply message could break existing apps.
> >=20
> > If an app only performs netnsid operations, and fills up the receive
> > queue because it isn't reading these new replies (it had no reason to,
> > they didn't exist previously), operations will start failing that
> > would not fail previously because the receive queue is full.
> Yes I see the problem. I was wondering if this was acceptable because the=
 nl ack
> is sent at the end. But nl ack are optional :/
>=20
> >=20
> > Given this, I don't see how we can make the change.
> >=20
> Is a new flag attribute ok to turn on this reply?
>=20
Why not using the existing NLM_F_ECHO mechanism?

IIUC, if rtnl_net_notifyid() did pass the proper nlmsghdr and portid to
rtnl_notify(), the later would automatically notify the caller with
updated information if the original request had the NLM_F_ECHO flag.

