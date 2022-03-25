Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F94E6C5F
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 03:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357718AbiCYCL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 22:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357699AbiCYCLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 22:11:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4746A6E2E;
        Thu, 24 Mar 2022 19:06:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 65D7C1F38D;
        Fri, 25 Mar 2022 02:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648174001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GxpivvuiDhi8Meku7aRkDAE9Hjn1RoD/lKyyatBC6fo=;
        b=obmw/6322qvngpDQFN0rPsPxkFnxb6G3GDPd4Y8stBKBgAnLRzPUnssKBaaeaaY4YN0Ld8
        /GLE9kV0GtPKOFbh1JcPGubkXmAICloR3EeJYoceHsJOgI6qyed/tbN/ptkOXLSYjYNH7d
        7B3YUWMfgA4Xumllu+hptCqjdkUsElQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648174001;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GxpivvuiDhi8Meku7aRkDAE9Hjn1RoD/lKyyatBC6fo=;
        b=/uVC+exdBq+HN9CHeK1b2SpQB4QDXI0xJIp3USC1RfxXWuVF12YSe9zIbsTpqI/3Hu1AFT
        gmNzW5XJJ0T0N5Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38432132E9;
        Fri, 25 Mar 2022 02:06:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OB6sOK0jPWJ6eAAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 25 Mar 2022 02:06:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Haowen Bai" <baihaowen@meizu.com>
Cc:     trond.myklebust@hammerspace.com, anna@kernel.org,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Haowen Bai" <baihaowen@meizu.com>
Subject: Re: [PATCH] SUNRPC: Increase size of servername string
In-reply-to: <1648103566-15528-1-git-send-email-baihaowen@meizu.com>
References: <1648103566-15528-1-git-send-email-baihaowen@meizu.com>
Date:   Fri, 25 Mar 2022 13:06:34 +1100
Message-id: <164817399413.6096.7103093569920914714@noble.neil.brown.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022, Haowen Bai wrote:
> This patch will fix the warning from smatch:
>=20
> net/sunrpc/clnt.c:562 rpc_create() error: snprintf() chops off
> the last chars of 'sun->sun_path': 108 vs 48
>=20
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  net/sunrpc/clnt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index c83fe61..6e0209e 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -526,7 +526,7 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *arg=
s)
>  		.servername =3D args->servername,
>  		.bc_xprt =3D args->bc_xprt,
>  	};
> -	char servername[48];
> +	char servername[108];

It would be much nicer to use UNIX_PATH_MAX

NeilBrown


>  	struct rpc_clnt *clnt;
>  	int i;
> =20
> --=20
> 2.7.4
>=20
>=20
