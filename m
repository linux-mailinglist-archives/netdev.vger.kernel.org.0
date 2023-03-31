Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246F86D2892
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjCaTQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjCaTQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8349D22933;
        Fri, 31 Mar 2023 12:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31520B831F0;
        Fri, 31 Mar 2023 19:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4C3C433D2;
        Fri, 31 Mar 2023 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680290185;
        bh=67/RGvHHjDJru2OHFghr0M4JV0SNZ9LI/thmTUTVZmM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aNACXKQuDUI3+ZSSXDzQ9hXLgYS/6W4y1lJmYGI2AJCSAQ8gI9vK5YAaMB8YjWfP/
         WxGuNi/5prRbfRHJ0LhidgHqMFjXaxIdnQozGH7K21NYrdLAXP+9qfLPtx+gYg6xmq
         +zFk4DvuEQp6bd0mcn73ISpURphCWTxSfdCHgjN60tbEmU50HlnqBjc7jgSeOHIg8p
         HSRGQKxhzfS0gjSoDOEvJndbHRrOa1zeZ1IfRvLFmtk9oxsqCkvs09h0TaijHb57lp
         6792bIjh8vmBYuk6G9//dekKpnzDUNzXv64+Yw4y/LEQrIO6OC98qEN7xx92VF6c18
         kp5BsgidzrtsA==
Message-ID: <6a0e9fd260a9ef373b5a9f64af46974f73201760.camel@kernel.org>
Subject: Re: [PATCH v3 02/55] iov_iter: Remove last_offset member
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org
Date:   Fri, 31 Mar 2023 15:16:22 -0400
In-Reply-To: <20230331160914.1608208-3-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
         <20230331160914.1608208-3-dhowells@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-31 at 17:08 +0100, David Howells wrote:
> With the removal of ITER_PIPE, the last_offset member of struct iov_iter =
is
> no longer used, so remove it and un-unionise the remaining member.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: Alexander Viro <viro@zeniv.linux.org.uk>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: linux-nfs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> cc: linux-mm@kvack.org
> cc: netdev@vger.kernel.org
> ---
>  include/linux/uio.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 74598426edb4..2d8a70cb9b26 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -43,10 +43,7 @@ struct iov_iter {
>  	bool nofault;
>  	bool data_source;
>  	bool user_backed;
> -	union {
> -		size_t iov_offset;
> -		int last_offset;
> -	};
> +	size_t iov_offset;
>  	size_t count;
>  	union {
>  		const struct iovec *iov;


Reviewed-by: Jeff Layton <jlayton@kernel.org>
