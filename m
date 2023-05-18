Return-Path: <netdev+bounces-3579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5D5707EF5
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A2F028180F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B3819502;
	Thu, 18 May 2023 11:11:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4157918C22
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:11:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8162119
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684408245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2NcxE0RsPLg1062LoNjrlWE+UkODXkzpmwXqpBZxwM=;
	b=dwD0DssZ7+D9R0mwdOblfSDqlWTXZz2StCXP+4jfTHZku48o1s2k4d1lDllW8ZmLvF2ZmS
	6fj6OoV5J8T9mk+sryfc7LINMJtRn3tdmOfZits+3nIep7zgkQMxYTuvp51HiqjNf25pBE
	t208YixnAIDPE/cr5x+e29fZMTTsCtc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-yHUho95jOxWk41Gm2hpyZw-1; Thu, 18 May 2023 07:10:42 -0400
X-MC-Unique: yHUho95jOxWk41Gm2hpyZw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3f38280ec63so3678411cf.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684408242; x=1687000242;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f2NcxE0RsPLg1062LoNjrlWE+UkODXkzpmwXqpBZxwM=;
        b=YNgkFHpgkzQ5gbdvC4Aye/cXNZOiAYZe7ywKZTKwxZuBosv9rCwdhfNtrd/KIKKc/o
         CcSxG+cTnxvM6IcjJv9jCvNyYjLz2zIatgQr+14ybLcQePVjLjAt29VKNcwg5njzjF6u
         yG3qUyWTLSqAwuQBDdDMWpADPGBmJW9cCTAUPuSF3JbVGqK6OZ+4Reszam91LkiIBGBo
         WO53kHZDv7hRBj1KhLtFVb8VXuZcV2xNof/7jq0riFHyZ32QzXgw1Bc2nNtaaeXokCh0
         QfY04/nmYKha/zJ/jOGPAI7wU8p8P3cLvVABvzzbFB1oiyBc9EnvCWXFo7YpDI8vaeAk
         4gEw==
X-Gm-Message-State: AC+VfDypV3H38GBWuYiwMum4NHR0Olf3Q5eHH0vM/NejB5Cj+XMYOSNl
	9koKZKKw2UPbygQXr/mlC0ZRERdef1A11gN57GZ+6rooe3p8DR6Ci5wxgg+Fxq8K9y9oOXjnBE1
	9jW3pdq+fVMfrMbc0wZ+n8/gl
X-Received: by 2002:a05:622a:1896:b0:3f5:16af:17d6 with SMTP id v22-20020a05622a189600b003f516af17d6mr10872299qtc.3.1684408241962;
        Thu, 18 May 2023 04:10:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6/qnltyKsyZE/L1ktIzrQ0Ew9Hs0O55TEKxNZfIrmlEZhxbrHczL9qgtv+7D/SlwBQzv+leA==
X-Received: by 2002:a05:622a:1896:b0:3f5:16af:17d6 with SMTP id v22-20020a05622a189600b003f516af17d6mr10872258qtc.3.1684408241691;
        Thu, 18 May 2023 04:10:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-175.dyn.eolo.it. [146.241.239.175])
        by smtp.gmail.com with ESMTPSA id n7-20020a05620a152700b0075784a8f13csm318352qkk.96.2023.05.18.04.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 04:10:41 -0700 (PDT)
Message-ID: <78a9f2e83af3ab732e9cedd46c1265b7366cd91f.camel@redhat.com>
Subject: Re: [PATCH net-next v7 03/16] net: Add a function to splice pages
 into an skbuff for MSG_SPLICE_PAGES
From: Paolo Abeni <pabeni@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Jeff
 Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, Chuck
 Lever III <chuck.lever@oracle.com>, Linus Torvalds
 <torvalds@linux-foundation.org>,  linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 18 May 2023 13:10:36 +0200
In-Reply-To: <1348733.1684405935@warthog.procyon.org.uk>
References: <47caea363e844bf716867c6a128d374cae4a5772.camel@redhat.com>
	 <93aba6cc363e94a6efe433b3c77ec1b6b54f2919.camel@redhat.com>
	 <20230515093345.396978-1-dhowells@redhat.com>
	 <20230515093345.396978-4-dhowells@redhat.com>
	 <1347187.1684403608@warthog.procyon.org.uk>
	 <1348733.1684405935@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-18 at 11:32 +0100, David Howells wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> > Side node: we need the whole series alltogether, you need to repost
> > even the unmodified patches.
>=20
> Any other things to change before I do that?

I went through the series and don't have other comments.

Cheers,

Paolo


