Return-Path: <netdev+bounces-6589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7618D7170B0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0768E1C20D8B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F25134CC9;
	Tue, 30 May 2023 22:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94447200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:28:07 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA1FF7;
	Tue, 30 May 2023 15:27:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ED0192187B;
	Tue, 30 May 2023 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1685485670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18j5tvDaSV7ASsBeBkyrZ2rlsJmZg7DSojVFhv89dpY=;
	b=wehyXkwRpGMJYML5r49f7V+U/SzLmqJ/KAVFN7Xq+OjsdqBPJize1K2t44Nzy5DRxVpg6O
	20iLwewLOp05gvuvmILokAfctIoWmf+H5Xykz1w3ePQz6ACKcSI/ZJXfYaCg7OmQ8iwNa8
	idvYVycOqq67drFpxBnTwUbBTGRMyyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1685485670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=18j5tvDaSV7ASsBeBkyrZ2rlsJmZg7DSojVFhv89dpY=;
	b=FZ8v9KB0G9DsDm6MV0OJE9QBBCpcRZhcMVQCwb6Xx9X9YL78StXG1gCuT+xmaCDl5pKl9S
	TIh4+NpA6NzIJqBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D50E13478;
	Tue, 30 May 2023 22:27:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id PgUxDGN4dmS5VgAAMHmgww
	(envelope-from <neilb@suse.de>); Tue, 30 May 2023 22:27:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neilb@suse.de>
To: "Dan Carpenter" <dan.carpenter@linaro.org>
Cc: "Stanislav Kinsbursky" <skinsbursky@parallels.com>,
 "Chuck Lever" <chuck.lever@oracle.com>, "Jeff Layton" <jlayton@kernel.org>,
 "Trond Myklebust" <trond.myklebust@hammerspace.com>,
 "Anna Schumaker" <anna@kernel.org>, "J. Bruce Fields" <bfields@redhat.com>,
 linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] nfsd: fix double fget() bug in __write_ports_addfd()
In-reply-to: <9c90e813-c7fb-4c90-b52b-131481640a78@kili.mountain>
References: <9c90e813-c7fb-4c90-b52b-131481640a78@kili.mountain>
Date: Wed, 31 May 2023 08:27:43 +1000
Message-id: <168548566376.23533.14778348024215909777@noble.neil.brown.name>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 29 May 2023, Dan Carpenter wrote:
> The bug here is that you cannot rely on getting the same socket
> from multiple calls to fget() because userspace can influence
> that.  This is a kind of double fetch bug.
>=20
> The fix is to delete the svc_alien_sock() function and insted do
> the checking inside the svc_addsock() function.

Hi,
 I definitely agree with the change to pass the 'net' into
 svc_addsock(), and check the the fd has the correct net.

 I'm not sure I agree with the removal of the svc_alien_sock() test.  It
 is best to perform sanity tests before allocation things, and
 nfsd_create_serv() can create a new 'serv' - though most often it just
 incs the refcount.

 Maybe instead svc_alien_sock() could return the struct socket (if
 successful), and it could be passed to svc_addsock()???

 I would probably then change the name of svc_alien_sock()

Thanks,
NeilBrown


>=20
> Fixes: 3064639423c4 ("nfsd: check passed socket's net matches NFSd superblo=
ck's one")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> Based on static analysis and untested.  This goes through the NFS tree.=20
> Inspired by CVE-2023-1838.
>=20
>  include/linux/sunrpc/svcsock.h |  7 +++----
>  fs/nfsd/nfsctl.c               |  7 +------
>  net/sunrpc/svcsock.c           | 23 +++++------------------
>  3 files changed, 9 insertions(+), 28 deletions(-)
>=20
> diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsock.h
> index d16ae621782c..a7116048a4d4 100644
> --- a/include/linux/sunrpc/svcsock.h
> +++ b/include/linux/sunrpc/svcsock.h
> @@ -61,10 +61,9 @@ int		svc_recv(struct svc_rqst *, long);
>  void		svc_send(struct svc_rqst *rqstp);
>  void		svc_drop(struct svc_rqst *);
>  void		svc_sock_update_bufs(struct svc_serv *serv);
> -bool		svc_alien_sock(struct net *net, int fd);
> -int		svc_addsock(struct svc_serv *serv, const int fd,
> -					char *name_return, const size_t len,
> -					const struct cred *cred);
> +int		svc_addsock(struct svc_serv *serv, struct net *net,
> +			    const int fd, char *name_return, const size_t len,
> +			    const struct cred *cred);
>  void		svc_init_xprt_sock(void);
>  void		svc_cleanup_xprt_sock(void);
>  struct svc_xprt *svc_sock_create(struct svc_serv *serv, int prot);
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index e0e98b40a6e5..1489e0b703b4 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -698,16 +698,11 @@ static ssize_t __write_ports_addfd(char *buf, struct =
net *net, const struct cred
>  		return -EINVAL;
>  	trace_nfsd_ctl_ports_addfd(net, fd);
> =20
> -	if (svc_alien_sock(net, fd)) {
> -		printk(KERN_ERR "%s: socket net is different to NFSd's one\n", __func__);
> -		return -EINVAL;
> -	}
> -
>  	err =3D nfsd_create_serv(net);
>  	if (err !=3D 0)
>  		return err;
> =20
> -	err =3D svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cre=
d);
> +	err =3D svc_addsock(nn->nfsd_serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT=
, cred);
> =20
>  	if (err >=3D 0 &&
>  	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 46845cb6465d..e4184e40793c 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1474,22 +1474,6 @@ static struct svc_sock *svc_setup_socket(struct svc_=
serv *serv,
>  	return svsk;
>  }
> =20
> -bool svc_alien_sock(struct net *net, int fd)
> -{
> -	int err;
> -	struct socket *sock =3D sockfd_lookup(fd, &err);
> -	bool ret =3D false;
> -
> -	if (!sock)
> -		goto out;
> -	if (sock_net(sock->sk) !=3D net)
> -		ret =3D true;
> -	sockfd_put(sock);
> -out:
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(svc_alien_sock);
> -
>  /**
>   * svc_addsock - add a listener socket to an RPC service
>   * @serv: pointer to RPC service to which to add a new listener
> @@ -1502,8 +1486,8 @@ EXPORT_SYMBOL_GPL(svc_alien_sock);
>   * Name is terminated with '\n'.  On error, returns a negative errno
>   * value.
>   */
> -int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
> -		const size_t len, const struct cred *cred)
> +int svc_addsock(struct svc_serv *serv, struct net *net, const int fd,
> +		char *name_return, const size_t len, const struct cred *cred)
>  {
>  	int err =3D 0;
>  	struct socket *so =3D sockfd_lookup(fd, &err);
> @@ -1514,6 +1498,9 @@ int svc_addsock(struct svc_serv *serv, const int fd, =
char *name_return,
> =20
>  	if (!so)
>  		return err;
> +	err =3D -EINVAL;
> +	if (sock_net(so->sk) !=3D net)
> +		goto out;
>  	err =3D -EAFNOSUPPORT;
>  	if ((so->sk->sk_family !=3D PF_INET) && (so->sk->sk_family !=3D PF_INET6))
>  		goto out;
> --=20
> 2.39.2
>=20
>=20


