Return-Path: <netdev+bounces-6711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1783C717899
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:48:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69E101C20D1F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:48:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAD5AD53;
	Wed, 31 May 2023 07:48:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB038A945
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:48:19 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7063B122
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:48:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30aea656e36so2495128f8f.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685519296; x=1688111296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tRSEdxP8IM2jGH9SQvtWqET/153WHbcp/+/2iayQMU=;
        b=YXbMxXdWgXfUU0qf80s17Bl0IXn2Mnyry5L1rrzIdyXr3fLNdZCXDGRehczX0f16VP
         bRBIEGNElh8ih3eLiHyFGF1LIxYeY4J2BT+vd2c2CXwVadyYRWh/dpUmLwCAHeEuWB2H
         bgEEoFZ0XujkJfdKZbc61voLWN+nrcT2vxLK8lCAya/kyjZ+qcFpfUTLqg0MWZgt+pms
         r4I2n7bXr0impDYuk8TngNUPYJJtzBl7U2bTb7q9WIyqoBQMil7u+hQ2IV9O8oq/pCcC
         YQpcxb4Z9vSlB6kQa/jjczflaR+190dcR/sINyQ6iMmbDibLluP4TUjv40cGcbvreu8h
         CerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685519296; x=1688111296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tRSEdxP8IM2jGH9SQvtWqET/153WHbcp/+/2iayQMU=;
        b=cWVCPw7aHVy9l4OoHCJagYSDhtSiIU8kzrQB969sVznvrb5wQ+k+8h9Pk4GzyxLMcq
         OUwpPejHDJd+17lNT6b3IrOxqhbQwczyngWUL0vcw61OrGJWSzK4lHdkjW7j8c+l787x
         WwVV8I4fpVDwzkwlXZHZhk5AlLUdB0Mj3Ikui2iTOdo9lPg1OzSbgwzS3bTkDTMXOJ9K
         FES2l+wtbp95qFAzrh5uLia40aip60vKwtbGgU6YPq5CPh/AnoTh6B1njo+qcy947+xh
         oFNLt9Vie+XxPURkYdM4dC8x7c79IsZ76bfKUomyu94iKKLagv9jq2T3yuMG8eKXfsMa
         j5HA==
X-Gm-Message-State: AC+VfDw7eDMkzy39uvu9fAtoayxwdEAD3rC1ZIe7OiSn0vBcsRHdkhCr
	gUXFJjYbFZawpOpxPgnazWGJQg==
X-Google-Smtp-Source: ACHHUZ77exca1531RsIDO/3C7eTHQt1nH/831RLyq6v8yb3Cqd/T8FdVYe6PeAe+nlDYDJAtMNHy2Q==
X-Received: by 2002:a05:6000:1245:b0:306:297b:927f with SMTP id j5-20020a056000124500b00306297b927fmr3203075wrx.25.1685519295779;
        Wed, 31 May 2023 00:48:15 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b17-20020adff251000000b002c71b4d476asm5757981wrp.106.2023.05.31.00.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 00:48:13 -0700 (PDT)
Date: Wed, 31 May 2023 10:48:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>, linux-nfs@vger.kernel.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] nfsd: fix double fget() bug in __write_ports_addfd()
Message-ID: <58fd7e35-ba6c-432e-8e02-9c5476c854b4@kili.mountain>
References: <9c90e813-c7fb-4c90-b52b-131481640a78@kili.mountain>
 <168548566376.23533.14778348024215909777@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168548566376.23533.14778348024215909777@noble.neil.brown.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 08:27:43AM +1000, NeilBrown wrote:
> On Mon, 29 May 2023, Dan Carpenter wrote:
> > The bug here is that you cannot rely on getting the same socket
> > from multiple calls to fget() because userspace can influence
> > that.  This is a kind of double fetch bug.
> > 
> > The fix is to delete the svc_alien_sock() function and insted do
> > the checking inside the svc_addsock() function.
> 
> Hi,
>  I definitely agree with the change to pass the 'net' into
>  svc_addsock(), and check the the fd has the correct net.
> 
>  I'm not sure I agree with the removal of the svc_alien_sock() test.  It
>  is best to perform sanity tests before allocation things, and
>  nfsd_create_serv() can create a new 'serv' - though most often it just
>  incs the refcount.

That's true.  But the other philosophical rule is that we shouldn't
optimize for the failure path.  If someone gives us bad data they
deserve a slow down.

I also think leaving svc_alien_sock() is a trap for the unwary because
it will lead to more double fget() bugs.  The svc_alien_sock() function
is weird because it returns false on success and false on failure and
true for alien sock.

> 
>  Maybe instead svc_alien_sock() could return the struct socket (if
>  successful), and it could be passed to svc_addsock()???
> 
>  I would probably then change the name of svc_alien_sock()

Yeah, because we don't want alien sockets, we want Earth sockets.
Doing this is much more complicated...  The name svc_get_earth_sock()
is just a joke.  Tell me what name to use if we decide to go this
route.

To be honest, I would probably still go with my v1 patch.

regards,
dan carpenter

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index e0e98b40a6e5d..affcd44f03d6b 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -689,6 +689,7 @@ static ssize_t __write_ports_names(char *buf, struct net *net)
  */
 static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred *cred)
 {
+	struct socket *so;
 	char *mesg = buf;
 	int fd, err;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
@@ -698,22 +699,30 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
 		return -EINVAL;
 	trace_nfsd_ctl_ports_addfd(net, fd);
 
-	if (svc_alien_sock(net, fd)) {
+	so = svc_get_earth_sock(net, fd);
+	if (!so) {
 		printk(KERN_ERR "%s: socket net is different to NFSd's one\n", __func__);
 		return -EINVAL;
 	}
 
 	err = nfsd_create_serv(net);
 	if (err != 0)
-		return err;
+		goto out_put_sock;
 
-	err = svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
+	err = svc_addsock(nn->nfsd_serv, so, buf, SIMPLE_TRANSACTION_LIMIT, cred);
+	if (err)
+		goto out_put_net;
 
-	if (err >= 0 &&
-	    !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
+	if (!nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
 		svc_get(nn->nfsd_serv);
 
 	nfsd_put(net);
+	return 0;
+
+out_put_net:
+	nfsd_put(net);
+out_put_sock:
+	sockfd_put(so);
 	return err;
 }
 
diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsock.h
index d16ae621782c0..2422d260591bb 100644
--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -61,8 +61,8 @@ int		svc_recv(struct svc_rqst *, long);
 void		svc_send(struct svc_rqst *rqstp);
 void		svc_drop(struct svc_rqst *);
 void		svc_sock_update_bufs(struct svc_serv *serv);
-bool		svc_alien_sock(struct net *net, int fd);
-int		svc_addsock(struct svc_serv *serv, const int fd,
+struct socket	*svc_get_earth_sock(struct net *net, int fd);
+int		svc_addsock(struct svc_serv *serv, struct socket *so,
 					char *name_return, const size_t len,
 					const struct cred *cred);
 void		svc_init_xprt_sock(void);
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 46845cb6465d7..78f6ae9fa42d4 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1474,21 +1474,20 @@ static struct svc_sock *svc_setup_socket(struct svc_serv *serv,
 	return svsk;
 }
 
-bool svc_alien_sock(struct net *net, int fd)
+struct socket *svc_get_earth_sock(struct net *net, int fd)
 {
 	int err;
 	struct socket *sock = sockfd_lookup(fd, &err);
-	bool ret = false;
 
 	if (!sock)
-		goto out;
-	if (sock_net(sock->sk) != net)
-		ret = true;
-	sockfd_put(sock);
-out:
-	return ret;
+		return NULL;
+	if (sock_net(sock->sk) != net) {
+		sockfd_put(sock);
+		return NULL;
+	}
+	return sock;
 }
-EXPORT_SYMBOL_GPL(svc_alien_sock);
+EXPORT_SYMBOL_GPL(svc_get_earth_sock);
 
 /**
  * svc_addsock - add a listener socket to an RPC service
@@ -1502,36 +1501,27 @@ EXPORT_SYMBOL_GPL(svc_alien_sock);
  * Name is terminated with '\n'.  On error, returns a negative errno
  * value.
  */
-int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
+int svc_addsock(struct svc_serv *serv, struct socket *so, char *name_return,
 		const size_t len, const struct cred *cred)
 {
-	int err = 0;
-	struct socket *so = sockfd_lookup(fd, &err);
 	struct svc_sock *svsk = NULL;
 	struct sockaddr_storage addr;
 	struct sockaddr *sin = (struct sockaddr *)&addr;
 	int salen;
 
-	if (!so)
-		return err;
-	err = -EAFNOSUPPORT;
 	if ((so->sk->sk_family != PF_INET) && (so->sk->sk_family != PF_INET6))
-		goto out;
-	err =  -EPROTONOSUPPORT;
+		return -EAFNOSUPPORT;
 	if (so->sk->sk_protocol != IPPROTO_TCP &&
 	    so->sk->sk_protocol != IPPROTO_UDP)
-		goto out;
-	err = -EISCONN;
+		return -EPROTONOSUPPORT;
 	if (so->state > SS_UNCONNECTED)
-		goto out;
-	err = -ENOENT;
+		return -EISCONN;
 	if (!try_module_get(THIS_MODULE))
-		goto out;
+		return -ENOENT;
 	svsk = svc_setup_socket(serv, so, SVC_SOCK_DEFAULTS);
 	if (IS_ERR(svsk)) {
 		module_put(THIS_MODULE);
-		err = PTR_ERR(svsk);
-		goto out;
+		return PTR_ERR(svsk);
 	}
 	salen = kernel_getsockname(svsk->sk_sock, sin);
 	if (salen >= 0)
@@ -1539,9 +1529,6 @@ int svc_addsock(struct svc_serv *serv, const int fd, char *name_return,
 	svsk->sk_xprt.xpt_cred = get_cred(cred);
 	svc_add_new_perm_xprt(serv, &svsk->sk_xprt);
 	return svc_one_sock_name(svsk, name_return, len);
-out:
-	sockfd_put(so);
-	return err;
 }
 EXPORT_SYMBOL_GPL(svc_addsock);
 




