Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B6D6CCE7A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 02:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjC2AHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 20:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjC2AHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 20:07:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5861B0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:07:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a16so12451915pjs.4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680048428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95oOalITgfprQFCC8+m+Ju2257CFa9b2zeXfGuyW2XU=;
        b=aqrrfdJS4mAdimmndN3T04Zhg0AJMtQBFsa0b6to2GpL6u4a1AtsC4X+OflAVWtHqh
         /YJsEtDORVnnQbf41Kucx9TlTdMCQg6tMUIIFTA+t0jrEoZUVfU/esS82ewz8exQcEJ8
         v3cPDKUjtrbfcIYkHOO93bbwan+Eyw06kchbjUdpLsX7uZSB+yNUbmFiTdjB0VMCQawX
         24nwzUqT5fpC5bcKuzAeGm/sG5PLIbTYhu9qG/DzpzCH+8Y/S9KzQqeriWmTputE7ljf
         8IpPq8wnAQQ56hb/WCzlOGNl5IkYWDLGLSdgJb/mR6FG7/1rc+aUYu2KP/IWEXFOxhYg
         7C/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680048428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95oOalITgfprQFCC8+m+Ju2257CFa9b2zeXfGuyW2XU=;
        b=KSVrEBMJ8qn0tVSCdrRc3fLZ3vGfzPO/PCHL7SMQWWVb5bCLvc5iRntJbrLo/T/Kne
         bZS69JyXASNIMIKvJxrqfk3sNMjJxKEUB/Kmag91ogcQRhGopWRSBSVforGhl67hIWRV
         L6iXToy/h/t/LI6SDEePr/JqEnMI12EsqSp9P8R+AT31gKazUN8hcOtkPUr9oaZZUBiy
         CEsV3VuXAiEAoczGlgybynmFW4Ubx/tFb34M+jvXWjIDXqThB3PxIT7I5zRo+XL4lEjY
         eBH/BXMS5XfFjYjUZxZmUkcF8mC52199odDYbyGGjDtcY89E//K362zy91NybBheizzm
         c64Q==
X-Gm-Message-State: AAQBX9f9AhJkvp47LXgyrBnnZCd+kcqEBM+o2WX3JBB8cllmswo3SbZm
        4pUhAukLdoKEv8UOVHxa3CGrSQgS1j2Db5luk9KhjA==
X-Google-Smtp-Source: AKy350ZcchhiYc5mfbbMoSG7scAna95+vIXAy+yerISOHalXtsoIx2bCE9aqTSk639ohJKiouWBA1nn3CJbY5dqpA8Y=
X-Received: by 2002:a17:902:dace:b0:1a0:41ea:b9ba with SMTP id
 q14-20020a170902dace00b001a041eab9bamr6653612plx.8.1680048428320; Tue, 28 Mar
 2023 17:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230324225656.3999785-1-sdf@google.com> <20230324225656.3999785-5-sdf@google.com>
 <20230324203543.3998a487@kernel.org>
In-Reply-To: <20230324203543.3998a487@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 28 Mar 2023 17:06:57 -0700
Message-ID: <CAKH8qBsGotuK2brjmtZXmdXitbCJ532o18c4Rfhu_B993kcWGw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] tools: ynl: ethtool testing tool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 8:35=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 24 Mar 2023 15:56:56 -0700 Stanislav Fomichev wrote:
> > +def args_to_req(ynl, op_name, args, req):
> > +  """
> > +  Verify and convert command-line arguments to the ynl-compatible requ=
est.
> > +  """
> > +  valid_attrs =3D ynl.operation_do_attributes(op_name)
> > +  valid_attrs.remove('header') # not user-provided
> > +
> > +  if len(args) =3D=3D 0:
> > +    print(f'no attributes, expected: {valid_attrs}')
> > +    sys.exit(1)
>
> Could you re-format with 4 char indentation? To keep it consistent with
> the rest of ynl?

Sorry, I was somehow assuming that whatever my vim does is the right
way to go :-( Fixed my config and will reindent.
