Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BBA53B076
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 02:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiFBAag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiFBAaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:30:35 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A9B29B136
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 17:30:34 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id a9so2616262qvt.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 17:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+fbCm+AnOfO+n3smxUD9UMSVPGrkLZqz+ki49eORDbY=;
        b=BG07r9t2Wesj6/wRMAU3mlvNK5f3nazfVioSCxc21fRRMn3aZ5Ywx22DLP7JMT4gGv
         uTLjhl48TUXkx689xp+7Imdea3H12nEbprtdmDiuNjtY2p7N7qSlQBnCdEk1Gb5/UYym
         YDAkGJd4f82W0QSNlg1b1iNiT9LIXojNZZvM6wxuuOd68B7PcYp3dfkMMQk5QkpPQj+J
         uQ6jB8iQA3jBh7A/oggibMdfi9qf8sVz1thzlZCFaYYFT89e44gDgCDgSYdTtit4AKSN
         Sq1+O+yMazadrgkIZbOC+Mw8Kn/GWGUuwFULCy2JBrvOpHl8WteJCg9VOfiEuZ17IgDv
         dVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+fbCm+AnOfO+n3smxUD9UMSVPGrkLZqz+ki49eORDbY=;
        b=Y0+jTADsTTeQ1Zwsk9gKbkWKOf3Rjy0Pp13VTLSdvlfLPM9nskCiAvhcE3zG0V0wGh
         Iluridd6YRMNUX4Gq4vfv+DJgFPBQwAQT9vuSOsp0RNh7PBANezk9TblRDp/m6shhfgJ
         lJqytyRiwr2yuyY8PZVooLHCPBgzrx2mwtlMlnLMlFdcteISvDsno2bV973W0a19mUeF
         fhFwLZgkGtl7bXs2jjMEDE0YBlLcHtVfCjlTh53l0Rw514T04g3J5RCMI7/i+MRMn7Yl
         HbgtkYBSfcqoVSqapLKlltS2q0mRozvdbssHhkfPe8J0V0yBc+E4VKyDajO5O/3iW7pK
         GnSA==
X-Gm-Message-State: AOAM530Jzc+h5uPZ+T6PwqOOzwV93mBlWc4EIr0hnso75xVo4nzEDnZn
        e69hRjmJ9VPSFLU2B1dD3wLUOx3tsmA=
X-Google-Smtp-Source: ABdhPJzddZ04JabERK2nf5YS/RIDzzBROWFdk+PRm42V7xSVkddie/eoD1VFfgBBovTFDwpaIWqbcg==
X-Received: by 2002:a05:6214:5282:b0:443:e161:ef4a with SMTP id kj2-20020a056214528200b00443e161ef4amr56461615qvb.23.1654129833468;
        Wed, 01 Jun 2022 17:30:33 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id e123-20020a378281000000b0069fe1dfbeffsm2150082qkd.92.2022.06.01.17.30.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 17:30:32 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-30c2f288f13so35928847b3.7
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 17:30:32 -0700 (PDT)
X-Received: by 2002:a0d:cb50:0:b0:30c:22fe:f744 with SMTP id
 n77-20020a0dcb50000000b0030c22fef744mr2558258ywd.339.1654129831972; Wed, 01
 Jun 2022 17:30:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
 <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com> <Ypfvs+VsNHWQKT6H@fractal.lan>
In-Reply-To: <Ypfvs+VsNHWQKT6H@fractal.lan>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Jun 2022 20:29:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfCCiE9c8xNCBiKtSo53hfyS4Qn5y11eY-2gyEUWC3tOA@mail.gmail.com>
Message-ID: <CA+FuTSfCCiE9c8xNCBiKtSo53hfyS4Qn5y11eY-2gyEUWC3tOA@mail.gmail.com>
Subject: Re: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
To:     Frederik Deweerdt <frederik.deweerdt@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 7:03 PM Frederik Deweerdt
<frederik.deweerdt@gmail.com> wrote:
>
> Hi Willem,
>
> On Wed, Jun 01, 2022 at 09:24:32AM -0400, Willem de Bruijn wrote:
> > On Tue, May 31, 2022 at 10:48 PM Frederik Deweerdt
> > <frederik.deweerdt@gmail.com> wrote:
> > >
> > > Hi folks,
> > >
> > > Based on my understanding, retransmissions of zero copied buffers can
> > > happen after `close(2)`, the patch below amends the docs to suggest how
> > > notifications should be handled in that case.
> >
> > Not just retransmissions. The first transmission similarly may be queued.
> >
> > >
> [...]
> > > @@ -144,6 +144,10 @@ the socket. A socket that has an error queued would normally block
> > >  other operations until the error is read. Zerocopy notifications have
> > >  a zero error code, however, to not block send and recv calls.
> > >
> > > +For protocols like TCP, where retransmissions can occur after the
> > > +application is done with a given connection, applications should signal
> > > +the close to the peer via shutdown(2), and keep polling the error queue
> > > +until all transmissions have completed.
> >
> > A socket must not be closed until all completion notifications have
> > been received.
> >
> > Calling shutdown is an optional step. It may be sufficient to simply
> > delay close.
>
> Thank you for the feedback, that helps!
>
> What do you think of the attached patch?

Please always share patches inline.

> +++ b/Documentation/networking/msg_zerocopy.rst
> @@ -144,6 +144,11 @@ the socket. A socket that has an error queued would normally block
> other operations until the error is read. Zerocopy notifications have
> a zero error code, however, to not block send and recv calls.
>
> +For protocols like TCP, transmissions can occur after the application
> +has called close(2). In cases where it's undesirable to delay calling
> +close(2) until all notifications have been processed, the application
> +can use shutdown(2), and keep polling the error queue until all
> +transmissions have completed.

Sorry to nitpick, but calling close(2) is still delayed. You meant where it's
undesirable to delay closing the TCP connection?

Shutdown can be used then. But that is not unique to msg_zerocopy?
I don't feel strongly either way. Perhaps it would be helpful to describe
what makes it is undesirable to wait with calling close.

Btw, packets leaving the host after a socket is closed is not unique to
the TCP protocol, but an effect of queuing, such as in the qdisc layer.
