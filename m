Return-Path: <netdev+bounces-4028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA95970A2B2
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 584222819F2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6551D18006;
	Fri, 19 May 2023 22:10:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5111317FF5
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 22:10:11 +0000 (UTC)
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3C6189;
	Fri, 19 May 2023 15:10:09 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-4572a528cefso316845e0c.0;
        Fri, 19 May 2023 15:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684534209; x=1687126209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyfmWjt1VTCSjEVbZNcL2tFnvyTBlxMVg1mjX07QoOk=;
        b=HuqVrHcIazlUiRSIb8fAEfdnHq/RzLyc/Altx4qWmXass7Tml/ynZuTYQt00iiZUhM
         BRGbiXN4KogjSr01b1jWtSks2+m/EJRNsWdhy3SP/PNG8D03BzTBIg/8A7AZ5mzf8MD+
         U5XuFtLvT8iuEexfhBYsri6fcGAulgnpVNMHUYoVfhBJkZxK9PdNwEVuHlLuvnBGs6OT
         hpz4njpSffhfS+tEBpCx+poGKyuG6uk+yyLvuZWYFa2jLCFSnTTbHymrUEIleI/lXNYp
         sqXslBL3PcxCesRRNsIsrdvsqd4VIVgJTneJNGHAjfimt3WT1kQhcnEiudtfwbrLAO4J
         dBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684534209; x=1687126209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyfmWjt1VTCSjEVbZNcL2tFnvyTBlxMVg1mjX07QoOk=;
        b=dTyaspIhvwp1fGGBGkzx93kaEaJ11UQocLKpF5G7KM7wWJ90s8WcSAO5A0a+/Aq96t
         KgXAa5jwHeI2Gjg2qmjomV5WZZkK2LQsL+9sb9mjn07E5qa3YzSh98Uk+AkVJY77hWvX
         51uj2PPyVlw3AcccrhirGbGjQCcPIbfZ2hdPYXoeN79JwEot5h+iT0w1ug+j7oyLFlnb
         91EmfsbXfQkEJMXRCPx/890H0dRtojbuSHq0SW1hz35hAocYFRgjTOJqT3w2TkWQ4n0/
         hCbjlDaqwosJbqnmMqU68TYhMvjWnijFQaI8ipST4lJMaS95nbGO+4NUvdgw8uMsBH1u
         Xt4w==
X-Gm-Message-State: AC+VfDwQsafApZds5Pm9bum/7jDQZhwwhYVzEGkMXy0mAWmYe8R4PHaa
	ZSvHUD/9aDRX19v4m8ykJfNiSUsD5R/lotccczk=
X-Google-Smtp-Source: ACHHUZ6udFa8fDirOYyi4r78zSwj7dD2Pe6HxOKp+hdVt7UaRlTAzbr80JAQ7Aig0vByD6RfXheFKqIBKauvLEZux/k=
X-Received: by 2002:a05:6102:cd:b0:42c:543a:ab2a with SMTP id
 u13-20020a05610200cd00b0042c543aab2amr272687vsp.35.1684534208774; Fri, 19 May
 2023 15:10:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518130713.1515729-1-dhowells@redhat.com> <20230518130713.1515729-17-dhowells@redhat.com>
In-Reply-To: <20230518130713.1515729-17-dhowells@redhat.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 19 May 2023 18:09:31 -0400
Message-ID: <CAF=yD-J8KGX5gjGBK6OO2SuoVa8s07Cm-oKxwmvBmRXY7XscBQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 16/16] unix: Convert udp_sendpage() to use MSG_SPLICE_PAGES
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Chuck Lever III <chuck.lever@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 9:08=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Convert unix_stream_sendpage() to use sendmsg() with MSG_SPLICE_PAGES
> rather than directly splicing in the pages itself.
>
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org

tiny nit: subject s/udp_sendpage/unix_stream_sendpage/

no other comments on this patch series from me

