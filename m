Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1054CD14
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345953AbiFOPeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346300AbiFOPeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:34:10 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE2822BCD
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:34:09 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id f1so12150882vsv.5
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 08:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JEk7BOZC8E1uVHkprfR97u1idKI8ThLFJkwwMW7vcpc=;
        b=o3D58cZRVUa7qt9h+A8DD2OzwqgVtjl5b0vmbzeFIV03z/b5BpmEr5aFHp0DJWXePb
         MdojiVN/HcjgiBNy/hdtuIlbctcvYwEbkaxGESygRuNhVBgRZ4NAany8biromKR6BIIu
         j2w7z3LCXgKhLFg7W0PLM+IwN9yGOwMjtOx/xW6wgp2D+VbQk1fxi0xEVg8JwXnI8/3B
         pO4SzlzeuNFnIFFR8Qz/3nh4POXYlRQhkHLIdB1PxC1fUk8PhzlyoWT8XNasezE3ft9B
         7TZjetwAYHpQwY+V89npCIm+QDkB86FITmLQIIGy5mUydIJFVTDj96vhhWL6JZYF0gSO
         IB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JEk7BOZC8E1uVHkprfR97u1idKI8ThLFJkwwMW7vcpc=;
        b=XodY4smtmWrBiP7hz0wSimBvktTH6DaLxoj6OF06ftyoTbH6XdoEEboAhEBH3VXbrn
         fqUj06dm/HwMO7EjU8nzGnrwNM+n2D1AiYdru2gS8Vn4F+vhgndYDHj4IIc/a4+0l1h/
         qVw7nWCCHDnDDYOBgCeCjDSGz0shh1OBEIHTqzsjgtsVc3KmX05bHsHlYeakRLIaHi5I
         ORDMuMEuKBDx1ffXYeXlv7LPwXcLbG2l+6UR2Y8Lv2+zGjQ/cFEtkVDP8vYBAczzgNQV
         8UFrbNXIH8NY7oZ2D2cHcfunXKllUELY9n6jHgTD9LAf6M7HkgUf0o8gloURzQb73exg
         Cv8A==
X-Gm-Message-State: AJIora9gv0k5YT1eicYDAt85qDGC4RJPhbINE22on+xSDMfTt4wsTP9n
        q4vWwJqaYQXDTAtc5VunTFmwtpdZ8UhUGoqONI4=
X-Google-Smtp-Source: AGRyM1v95NkzFyNnOn6Ju7NCBwXsUM96F+7vtkBvdAPabif0piRUaWg9M97875HMfk1qR8fbrdWTgMfiAu1LUglVSNw=
X-Received: by 2002:a67:f28d:0:b0:34b:a293:a6fe with SMTP id
 m13-20020a67f28d000000b0034ba293a6femr12587vsk.26.1655307248604; Wed, 15 Jun
 2022 08:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
 <20220609105725.2367426-3-wangyuweihx@gmail.com> <20220613230219.40372863@kernel.org>
In-Reply-To: <20220613230219.40372863@kernel.org>
From:   Yuwei Wang <wangyuweihx@gmail.com>
Date:   Wed, 15 Jun 2022 23:33:57 +0800
Message-ID: <CANmJ_FN2nPFmjdThSHvzMhCvhrujd_ZK0DyU-fGUFx2foQAGug@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net, neigh: introduce interval_probe_time
 for periodic probe
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>, roopa@nvidia.com,
        dsahern@kernel.org, =?UTF-8?B?56em6L+q?= <qindi@staff.weibo.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 at 14:02, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  9 Jun 2022 10:57:25 +0000 Yuwei Wang wrote:
> > commit ed6cd6a17896 ("net, neigh: Set lower cap for neigh_managed_work =
rearming")
> > fixed a case when DELAY_PROBE_TIME is configured to 0, the processing o=
f the
> > system work queue hog CPU to 100%, and further more we should introduce
> > a new option used by periodic probe
> >
> > Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
>
> The new sysctl needs to be documented in
> Documentation/networking/ip-sysctl

Oops=E2=80=A6=E2=80=A6I will fix the whitespace and add the doc in the next=
 version
