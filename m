Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B35683A3A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 00:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjAaXLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 18:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAaXLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 18:11:13 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D034863C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 15:11:11 -0800 (PST)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 38D783F194
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675206670;
        bh=od+H8iRL7U/hEgOt5OEJuPafvt2sARzXNu/6vCcYVbk=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=GHnj0KFRcFCJFOuGWnq5uP6ilExB6NWSbo0YbJFV6pz+Sg8+OkP5boBh008ppbjmE
         LdxOLGEOogm7/T4LsI7HIllTvUeFUYeH/rAqfdjSwvDJzQdoAXkZLGjdmrhqLyR0eX
         /x5f4OmRuxn4y9If3useAfdHv7aMCNAoZSOZZDjsX93hrq2QxLL7z/6L2ikTZSlnL8
         PXqslX1LGEVIug7fRIK0YC4D1TsEDZ7YbJdYh59mDJkYPrHAFhQL/I3CvgisFLPYDK
         t4VZXPVznIygVOU58isITzRjXR8g5WR9bdtb6U9xxUgIwN6oAqA58wRfddLyUnaup5
         s9Leym4zjZh/A==
Received: by mail-wm1-f72.google.com with SMTP id iz20-20020a05600c555400b003dc53fcc88fso90791wmb.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 15:11:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=od+H8iRL7U/hEgOt5OEJuPafvt2sARzXNu/6vCcYVbk=;
        b=cabqkz9nc6dassyS19Za5HcCQxO68S1I+4TEDHLOLnuKFoI5MZx2x0gMx7BtENeA7n
         wdHruuO6Zu/1idmtaxdC5L4f0p/yxK0t5QXDHUMZBeJvkkL137kQm3uXZJnY50w7nQIG
         PS2i7hjfmQIvod0wNhyNSZJiiaoIvo/btGXbSviigzyBcp/NtZzfVFhlkrateSr/cM2x
         dX3H7FLtygINvia46ddSbCo0YNJN7iXOhevfUWCV5WA/3CKm4xrrlSl9FPorAaIXoXqW
         /gKgyhnOWVDTcobAolF3ZPkaRX1xjPcW6dFQI5hToaBb8WISkY+9Axs9J2jyMOiiy1ar
         ll8Q==
X-Gm-Message-State: AO0yUKUm62n7+4zfSi70ruCNAQhoPHaitISFGDPtQ/Fo//PIM7K5ghrQ
        1jZJDKqHHxcqae9zpCNnR6OPteuczbu5PbDWSZXdVdaYDs6jVAq2t5u2OGgisl935Z4jBcGhD7B
        Qe8u/uawWuIKJ7tk0NPqxDdKT8gXsHZrQtA==
X-Received: by 2002:a05:6000:1561:b0:2bf:eb67:4774 with SMTP id 1-20020a056000156100b002bfeb674774mr957190wrz.11.1675206669953;
        Tue, 31 Jan 2023 15:11:09 -0800 (PST)
X-Google-Smtp-Source: AK7set+UghtwG5i6RKk6gUXdtXT/2iCWC9F9Q8LwQyUgDAkiThUw4PdcBKNkwWZzCmZP4Bi8M/VSCA==
X-Received: by 2002:a05:6000:1561:b0:2bf:eb67:4774 with SMTP id 1-20020a056000156100b002bfeb674774mr957170wrz.11.1675206669737;
        Tue, 31 Jan 2023 15:11:09 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id x7-20020a5d6b47000000b002bbed1388a5sm15947931wrw.15.2023.01.31.15.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 15:11:09 -0800 (PST)
Date:   Tue, 31 Jan 2023 23:11:07 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Willem de Bruijn <willemb@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Fred Klassen <fklassen@appneta.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] selftests: net: udpgso_bench_tx: Cater
 for pending datagrams zerocopy benchmarking
Message-ID: <Y9mgC7cEyRuS8UPg@qwirkle>
References: <20230131210051.475983-4-andrei.gherzan@canonical.com>
 <CA+FuTScJCaW+UL0dDDg-7nNdhdZV7Xs5MrfBkGAg-jR4az+DRQ@mail.gmail.com>
 <Y9mTRER69Z7BGqB5@qwirkle>
 <CA+FuTSfHtidA9zLZMpo+1AoVh=rN=nWyxfVtsUDuuJHmr9UFUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfHtidA9zLZMpo+1AoVh=rN=nWyxfVtsUDuuJHmr9UFUw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/31 05:28PM, Willem de Bruijn wrote:
> On Tue, Jan 31, 2023 at 5:16 PM Andrei Gherzan
> <andrei.gherzan@canonical.com> wrote:
> >
> > On 23/01/31 04:51PM, Willem de Bruijn wrote:
> > > On Tue, Jan 31, 2023 at 4:01 PM Andrei Gherzan
> > > <andrei.gherzan@canonical.com> wrote:
> > > >
> > > > The test tool can check that the zerocopy number of completions value is
> > > > valid taking into consideration the number of datagram send calls. This can
> > > > catch the system into a state where the datagrams are still in the system
> > > > (for example in a qdisk, waiting for the network interface to return a
> > > > completion notification, etc).
> > > >
> > > > This change adds a retry logic of computing the number of completions up to
> > > > a configurable (via CLI) timeout (default: 2 seconds).
> > > >
> > > > Fixes: 79ebc3c26010 ("net/udpgso_bench_tx: options to exercise TX CMSG")
> > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  tools/testing/selftests/net/udpgso_bench_tx.c | 34 +++++++++++++++----
> > > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > index b47b5c32039f..ef887842522a 100644
> > > > --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > @@ -62,6 +62,7 @@ static int    cfg_payload_len = (1472 * 42);
> > > >  static int     cfg_port        = 8000;
> > > >  static int     cfg_runtime_ms  = -1;
> > > >  static bool    cfg_poll;
> > > > +static int     cfg_poll_loop_timeout_ms = 2000;
> > > >  static bool    cfg_segment;
> > > >  static bool    cfg_sendmmsg;
> > > >  static bool    cfg_tcp;
> > > > @@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
> > > >         }
> > > >  }
> > > >
> > > > -static void flush_errqueue(int fd, const bool do_poll)
> > > > +static void flush_errqueue(int fd, const bool do_poll,
> > > > +               unsigned long poll_timeout, const bool poll_err)
> > >
> > > nit: his indentation looks off though
> >
> > This one I've missed but I couldn't find any guidelines on it. Could you
> > clarify to me what this should be or point me to soem docs? Happy to fix
> > otherwise. I'm currently using vim smartindent but it is definitely not
> > in line with what is here already.
> 
> It should align with the parameter above.

Found the roots of the issue - tab stop was 4 so it was rendered
confusing for me. I'll fix and resend including email prefix change (net
vs net next) and the CC footers (they should be Cc: not CC:).

> 
> https://www.kernel.org/doc/html/latest/process/coding-style.html#breaking-long-lines-and-strings

-- 
Andrei Gherzan
