Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7B1D0C10
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgEMJ3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:29:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41097 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728188AbgEMJ3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:29:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E9B6B5C0197;
        Wed, 13 May 2020 05:29:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 13 May 2020 05:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Nnc1pW
        TjTkjNb3onNAwQ3HdERtWsXu3adkfVGOqL1Bo=; b=3a3lD1sGRnX98/Yi4pS05P
        IKMIZvFVpXhUShZ3Y0+R8ElGxwJDJf0G59etYbD+TDkdTlAIY0cXLh5zoRV/1F6v
        NJXYwJHKugBfUONnBMJ2XcmXDz4DBYuTlmO6hbCCg61zIfY2N7Pg3O6T/98Ofudi
        Ua8Hrdml4xNJPVZf0VBFh27Zw3loW1ZqHmNDs/Rfd5W+lEJrf42gygdscTPXU2cc
        HobWOqWW9ZLRTq9ORdCwzW3Ve6EmC6LXEHXKkqGkkigk5t0jrlZYac0HJ0LbPa9y
        WNJi1eEGvzlxB4Kx6a/vfuz5CyjLhcJYDeyMCRXitrtBdvu9ar1aXNeeLdrZIT4A
        ==
X-ME-Sender: <xms:8b27XuhtFmvdvuai0MnW6T2GtIhd340XCeHGlLZjiCfmIY1iVUjF5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:8b27XvBXIYnHgSHOnb7vawGVYHlGMGKKgJJVRklbayKeUu7JTY8JlA>
    <xmx:8b27XmFp1IA0atja0OCjdYR1dwzPNqNsenb0Cspk9nHn_Zn3Dz1WiQ>
    <xmx:8b27XnRwbTmJu8B95O2FLWV7At9I98NUBU8jgphcL3TxAffQT7bIIQ>
    <xmx:8b27XpbxJiuWYETFScJ4oBNcw71HguTbevOT7XWEaQUxu8BZ8DAVxw>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AE7530662F8;
        Wed, 13 May 2020 05:29:21 -0400 (EDT)
Date:   Wed, 13 May 2020 12:29:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net/scm: cleanup scm_detach_fds
Message-ID: <20200513092918.GA596863@splinter>
References: <20200511115913.1420836-1-hch@lst.de>
 <20200511115913.1420836-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511115913.1420836-3-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 01:59:12PM +0200, Christoph Hellwig wrote:
> Factor out two helpes to keep the code tidy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Christoph,

After installing net-next (fb9f2e92864f) on a Fedora 32 machine I cannot
ssh to it. Bisected it to this commit [1].

When trying to connect I see these error messages in journal:

sshd[1029]: error: mm_receive_fd: no message header
sshd[1029]: fatal: mm_pty_allocate: receive fds failed
sshd[1029]: fatal: mm_request_receive_expect: buffer error: incomplete message
sshd[1018]: fatal: mm_request_receive: read: Connection reset by peer

Please let me know if more info is required. I can easily test a patch
if you need me to try something.

Thanks

[1]
git bisect start
# bad: [fb9f2e92864f51d25e790947cca2ac4426a12f9c] net: dsa: tag_sja1105: appease sparse checks for ethertype accessors
git bisect bad fb9f2e92864f51d25e790947cca2ac4426a12f9c
# good: [3242956bd610af40e884b530b6c6f76f5bf85f3b] Merge branch 'net-dsa-Constify-two-tagger-ops'
git bisect good 3242956bd610af40e884b530b6c6f76f5bf85f3b
# bad: [1b0cde4091877cd7fe4b29f67645cc391b86c9ca] sfc: siena_check_caps() can be static
git bisect bad 1b0cde4091877cd7fe4b29f67645cc391b86c9ca
# bad: [cba155d591aa28689332bc568632d2f868690be1] ionic: add support for more xcvr types
git bisect bad cba155d591aa28689332bc568632d2f868690be1
# bad: [97cf0ef9305bba857f04b914fd59e83813f1eae2] Merge branch 'improve-msg_control-kernel-vs-user-pointer-handling'
git bisect bad 97cf0ef9305bba857f04b914fd59e83813f1eae2
# bad: [2618d530dd8b7ac0fdcb83f4c95b88f7b0d37ce6] net/scm: cleanup scm_detach_fds
git bisect bad 2618d530dd8b7ac0fdcb83f4c95b88f7b0d37ce6
# good: [0462b6bdb6445b887b8896f28be92e0d94c92e7b] net: add a CMSG_USER_DATA macro
git bisect good 0462b6bdb6445b887b8896f28be92e0d94c92e7b
# first bad commit: [2618d530dd8b7ac0fdcb83f4c95b88f7b0d37ce6] net/scm: cleanup scm_detach_fds

> ---
>  net/core/scm.c | 94 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 51 insertions(+), 43 deletions(-)
> 
> diff --git a/net/core/scm.c b/net/core/scm.c
> index abfdc85a64c1b..168b006a52ff9 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -277,78 +277,86 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
>  }
>  EXPORT_SYMBOL(put_cmsg_scm_timestamping);
>  
> +static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
> +{
> +	struct socket *sock;
> +	int new_fd;
> +	int error;
> +
> +	error = security_file_receive(file);
> +	if (error)
> +		return error;
> +
> +	new_fd = get_unused_fd_flags(o_flags);
> +	if (new_fd < 0)
> +		return new_fd;
> +
> +	error = put_user(new_fd, ufd);
> +	if (error) {
> +		put_unused_fd(new_fd);
> +		return error;
> +	}
> +
> +	/* Bump the usage count and install the file. */
> +	sock = sock_from_file(file, &error);
> +	if (sock) {
> +		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> +		sock_update_classid(&sock->sk->sk_cgrp_data);
> +	}
> +	fd_install(new_fd, get_file(file));
> +	return error;
> +}
> +
> +static int scm_max_fds(struct msghdr *msg)
> +{
> +	if (msg->msg_controllen <= sizeof(struct cmsghdr))
> +		return 0;
> +	return (msg->msg_controllen - sizeof(struct cmsghdr)) / sizeof(int);
> +}
> +
>  void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  {
>  	struct cmsghdr __user *cm
>  		= (__force struct cmsghdr __user*)msg->msg_control;
> -
> -	int fdmax = 0;
> -	int fdnum = scm->fp->count;
> -	struct file **fp = scm->fp->fp;
> -	int __user *cmfptr;
> +	int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
> +	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
> +	int __user *cmsg_data = CMSG_USER_DATA(cm);
>  	int err = 0, i;
>  
> -	if (MSG_CMSG_COMPAT & msg->msg_flags) {
> +	if (msg->msg_flags & MSG_CMSG_COMPAT) {
>  		scm_detach_fds_compat(msg, scm);
>  		return;
>  	}
>  
> -	if (msg->msg_controllen > sizeof(struct cmsghdr))
> -		fdmax = ((msg->msg_controllen - sizeof(struct cmsghdr))
> -			 / sizeof(int));
> -
> -	if (fdnum < fdmax)
> -		fdmax = fdnum;
> -
> -	for (i=0, cmfptr =(int __user *)CMSG_USER_DATA(cm); i<fdmax;
> -	     i++, cmfptr++)
> -	{
> -		struct socket *sock;
> -		int new_fd;
> -		err = security_file_receive(fp[i]);
> +	for (i = 0; i < fdmax; i++) {
> +		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
>  		if (err)
>  			break;
> -		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & msg->msg_flags
> -					  ? O_CLOEXEC : 0);
> -		if (err < 0)
> -			break;
> -		new_fd = err;
> -		err = put_user(new_fd, cmfptr);
> -		if (err) {
> -			put_unused_fd(new_fd);
> -			break;
> -		}
> -		/* Bump the usage count and install the file. */
> -		sock = sock_from_file(fp[i], &err);
> -		if (sock) {
> -			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> -			sock_update_classid(&sock->sk->sk_cgrp_data);
> -		}
> -		fd_install(new_fd, get_file(fp[i]));
>  	}
>  
> -	if (i > 0)
> -	{
> -		int cmlen = CMSG_LEN(i*sizeof(int));
> +	if (i > 0)  {
> +		int cmlen = CMSG_LEN(i * sizeof(int));
> +
>  		err = put_user(SOL_SOCKET, &cm->cmsg_level);
>  		if (!err)
>  			err = put_user(SCM_RIGHTS, &cm->cmsg_type);
>  		if (!err)
>  			err = put_user(cmlen, &cm->cmsg_len);
>  		if (!err) {
> -			cmlen = CMSG_SPACE(i*sizeof(int));
> +			cmlen = CMSG_SPACE(i * sizeof(int));
>  			if (msg->msg_controllen < cmlen)
>  				cmlen = msg->msg_controllen;
>  			msg->msg_control += cmlen;
>  			msg->msg_controllen -= cmlen;
>  		}
>  	}
> -	if (i < fdnum || (fdnum && fdmax <= 0))
> +
> +	if (i < scm->fp->count || (scm->fp->count && fdmax <= 0))
>  		msg->msg_flags |= MSG_CTRUNC;
>  
>  	/*
> -	 * All of the files that fit in the message have had their
> -	 * usage counts incremented, so we just free the list.
> +	 * All of the files that fit in the message have had their usage counts
> +	 * incremented, so we just free the list.
>  	 */
>  	__scm_destroy(scm);
>  }
> -- 
> 2.26.2
> 
