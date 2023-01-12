Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B240667C98
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 18:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjALRfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 12:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjALRe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 12:34:58 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3A0C973C;
        Thu, 12 Jan 2023 08:57:36 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d3so20799484plr.10;
        Thu, 12 Jan 2023 08:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=44uls0T5zLOmzt4WmcHXZuXUMffcgjhS26drNArBO9U=;
        b=cr/lss4Cy8hnfjXO8Ci33QjYnR/ITDvzc+wn6dmYxlv/OVhRQj4M1z/F4KogINRgCm
         hu+Z1ohC/TLeqKR0Yr1R10zoltGDOIlHu+eRbkZkZjcKONhkFvDwM/XsF26SzVmY4dJj
         ZM5WKuk1GPUGjIv9VqFyjCvczwIk4SNOsHlCMbi2eiqyv68y9H2zDQ9xDf97xq5mNB+w
         p3jFFs7H03illKXb+MaRQNxk972wWqavsNnDw/uGmvC+AE5VNxdBrkoFMaTFstGddlpw
         veeG4eKfHlio1bFBzvhlMFn9ZPcDiyeGg/VLlUZAI76hmV1fIdl5sOSRVsOnztILVN6R
         QgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=44uls0T5zLOmzt4WmcHXZuXUMffcgjhS26drNArBO9U=;
        b=vZYZZKEGoaTMoFuA1JxZgAAy46tD2gEY1BHW62Wz+ayj7K2xhjQ6z8tzxRG0psocSQ
         rx5YMRkdijbkPmf8Ipb3PljAl134P+YjW642sKo/eB45JkzU6L3g9cWFkNtL/OvCuolB
         kA6c4fYCYwOwU3AmGKmGOScBCc6iHeOCRJD+CIrNl2OMWqmqgny2iPLlOop0kMh64Q2X
         4TUxGBN2QgvHbc9u60CJAfmb4/sb3qzo9UDDjh0pwJTodctj3/0dRr2J/HfkeMKUJ/Sd
         NF0cR9/zWzhFogGm11A2NY8KP721iLrULl66f7rO0E7RBiNX7+GN8ewh6dSgIsBkPQ9O
         mtTw==
X-Gm-Message-State: AFqh2kpc5l3wKCjScAD+J66pIG8ROXV8ETlywR2yYhbivXPfGnCjM9Nc
        5Lmq21CpG6oQN4FFCopbgFI=
X-Google-Smtp-Source: AMrXdXuBdLKkht363ZE8WZGQemn7xBTJ9NHYsu8XrkyeHFn/bYgP03yWqKT8tRWqXpSnCcm/tDYt2A==
X-Received: by 2002:a05:6a20:8346:b0:a7:8ce5:6fc6 with SMTP id z6-20020a056a20834600b000a78ce56fc6mr72883015pzc.13.1673542631012;
        Thu, 12 Jan 2023 08:57:11 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id bb9-20020a170902bc8900b00192c4055e72sm12428823plb.173.2023.01.12.08.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 08:57:10 -0800 (PST)
Message-ID: <3e278fed9f59a4e325933d4a4ef4b02991fb2c17.camel@gmail.com>
Subject: Re: [PATCH net] rxrpc: Fix wrong error return in
 rxrpc_connect_call()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        Dan Carpenter <error27@gmail.com>,
        kernel test robot <lkp@intel.com>,
        syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 Jan 2023 08:57:09 -0800
In-Reply-To: <2438405.1673460435@warthog.procyon.org.uk>
References: <2438405.1673460435@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-11 at 18:07 +0000, David Howells wrote:
>    =20
> Fix rxrpc_connect_call() to return -ENOMEM rather than 0 if it fails to
> look up a peer.
>=20
> This generated a smatch warning:
>         net/rxrpc/call_object.c:303 rxrpc_connect_call() warn: missing er=
ror code 'ret'
>=20
> I think this also fixes a syzbot-found bug:
>=20
>         rxrpc: Assertion failed - 1(0x1) =3D=3D 11(0xb) is false
>         ------------[ cut here ]------------
>         kernel BUG at net/rxrpc/call_object.c:645!
>=20
> where the call being put is in the wrong state - as would be the case if =
we
> failed to clear up correctly after the error in rxrpc_connect_call().
>=20
> Fixes: 9d35d880e0e4 ("rxrpc: Move client call connection to the I/O threa=
d")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Reported-and-tested-by: syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail=
.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> Link: https://lore.kernel.org/r/202301111153.9eZRYLf1-lkp@intel.com/
> ---
>  net/rxrpc/call_object.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
> index 3ded5a24627c..f3c9f0201c15 100644
> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -294,7 +294,7 @@ static void rxrpc_put_call_slot(struct rxrpc_call *ca=
ll)
>  static int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
>  {
>  	struct rxrpc_local *local =3D call->local;
> -	int ret =3D 0;
> +	int ret =3D -ENOMEM;
> =20
>  	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
> =20

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
