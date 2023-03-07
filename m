Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC076AF256
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjCGSwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbjCGSwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:52:07 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC616ABB11
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 10:40:30 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t15so13122245wrz.7
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 10:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678214425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75Oc8UNwWD0jYPxP17Nj5SkV82ayeB1gYR6cINmhH1Q=;
        b=DzKJSGkIxNz2UWaUqVoky0eHIbRRra9KqHtCulCSFuXgxUYfaTzwqiGrtcbpFwJIGt
         vxgmD+FLpHhThGox88Vb5pCUA6OZ8/z+DVFeZKGf5j409W62I0y47v/r4EtOdBPFk9Tc
         RBlT1itiiJvSYuM3kHTwoNnIzYwQF41cRjJVyXQJ8vcZda8ExWHiKIcJUQTczhx2JVK/
         Fpwyy5wxw6t+Nf/bLnZc6v8PsnSAEfxSCCoJ0AtrRHqyzsoHqQLYAymn4gO4zONe2BGG
         cmCoSp2RCO5FLkxPK+IN0JbiM42w2p0JdfpSevuSd7a6iaLJs9egF6mWYjgndM86Fm7Y
         PYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678214425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75Oc8UNwWD0jYPxP17Nj5SkV82ayeB1gYR6cINmhH1Q=;
        b=bXDfAQBCWGV8CsVFYajvyUXa1TfTroEcV0A93ca2uVueirzYJTHnfa/qzReimrXYX7
         5Y2OCunQKY6oWJMXFKCFfpA+afJlhBx0jQjDgFfRk/pZP6P18IIbY37sZReKXJBrIlkN
         0Kl6hOlz7fnI7GQ16SzYB7SFTGTF6h56rbnfdxcOKGlF66iZvDJ5by+O0u2XMkYexiDa
         NZvzEe17TIn4Ia7xEeq5KA5DMqimFjqZo33DHZyWrJqUyusDegXWky4Zr+Jrlw5YoVM1
         VZmiAvsOG+lOehVVrPqfiorWHqt/xB7X643+p1bKoFqfjYEpXqtD9wmoAB1wX25Ol0q4
         prag==
X-Gm-Message-State: AO0yUKXRWHmdTSvF3tUy4UHi2TOnXAs/JTzjax0XwgNlybaEUNHYFok9
        yLK/PITrI4FD1lvmwTJqGG247+gsts0toVFDh5/0P/q0jXg8uu/g8Fg6KpkF
X-Google-Smtp-Source: AK7set9m1/qqH/9wDnJJWnQBo3huOpkDQCzDLDY2kiKPKKPBTUgzIGrPEfB+knMs/ozNgdaTX7lwaIJXzVCMYFxj7qI=
X-Received: by 2002:a5d:4b03:0:b0:2c5:3fcb:682b with SMTP id
 v3-20020a5d4b03000000b002c53fcb682bmr2872897wrq.2.1678214425596; Tue, 07 Mar
 2023 10:40:25 -0800 (PST)
MIME-Version: 1.0
References: <000000000000adec0205f5ffcaf4@google.com> <ZAISIS/h9UV6Ox+r@corigine.com>
 <20230303164456.603c2ebd@xps-13>
In-Reply-To: <20230303164456.603c2ebd@xps-13>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Tue, 7 Mar 2023 19:40:13 +0100
Message-ID: <CANp29Y6aaCVVg+3ezNzaw1nqvMbZhHooZ_DQRvv5YPbOmeprag@mail.gmail.com>
Subject: Re: [syzbot] [wpan?] general protection fault in nl802154_trigger_scan
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        syzbot <syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com>,
        alex.aring@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 4, 2023 at 9:16=E2=80=AFAM 'Miquel Raynal' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> > I believe this is fixed here:
> >
> > - [PATCH net] ieee802154: Prevent user from crashing the host
> >   https://lore.kernel.org/netdev/20230301154450.547716-1-miquel.raynal@=
bootlin.com/
> >
> > - pull-request: ieee802154 for net 2023-03-02
> >   https://lore.kernel.org/netdev/20230302153032.1312755-1-stefan@datenf=
reihafen.org/
>
> Hopefully, yes :)
>
> Thanks,
> Miqu=C3=A8l

Let's tell syzbot about the fix:

#syz fix: ieee802154: Prevent user from crashing the host
