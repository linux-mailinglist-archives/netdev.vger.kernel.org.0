Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FEC60619D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJTN1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiJTN1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:27:03 -0400
Received: from sonic308-14.consmr.mail.ne1.yahoo.com (sonic308-14.consmr.mail.ne1.yahoo.com [66.163.187.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B781A045B
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1666272420; bh=7tWweWCqZEktHPjo0qF/Sd6RWYERru5Z/2TKvYyq9kI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=bdDhAFvfg78uryWeZMoNtJcd7LAKQGlehhN2UjbbUaTAglGppzDDUUjqT45+0eGESamkV0iPqafZDsFDPcaDdkn0axVIXq2LdiGuY5av+u6tDorgycHpxiCndVLRuxxinz+Xy5GIEx6sgPA+x1D3Jy54nSThNM4J7YAIOzAPAeDuc8llSyquhuk4uO/h6Ibjza/Bk26cpSf+W/VkNoaAB2H+zReX9g5kH9Mqmwwt8HZGadF02s1mY7MzLy/XZmhQxtgclvYukXBJ7YZ63IPstOR621WH2k3Z4swjqQ7FzNJRr/mV44r/Fb+n4931sSARIGHI04Y0mPlUxKQWkFdLxA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1666272420; bh=hq6/sjioGGr7fFRfuR54t3wj802DLtmQAfZQG3yvkA9=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=SRu0wbKWDGOLe+L6TPM9iX2DODKMw5xjHqp5pf4dw2xtk8SWJGgtMTjKzCw6pJqYOjcJn71yvb49qcEwKvIUdzeod6kugFfsx0ygWwYOnjDZ0mVsIdHqVX0dK16uG8paLLo7MaxjthgzhH0dC6CKRb+T6c5LBj6lvx8EMUpdQ0mfCzCaXatEGF+RUHTDf0yheAa1wCTd3KHlFejmofgfcfN0t8zFq2xlC+N63rs6bshut/4/3hDnOUtjLQip/rdUbx4zEe/P5JJR2Cw8iLq7bOOruE6oDaCiQKBr893T97P7mx08GpEQkOZaRcy9J4OiAin9VDd5RPC3v2sROMr2qQ==
X-YMail-OSG: G8rpqZAVM1mkWICFMlraiEZFGCbF7r5UIl09dmAKFoL3Ih_OYCghY6MGF.c8G0S
 p4EXZ9PvfvOD.w_DtBjU_gwICE5lrJespZ81TGoGOhubxuQ39HTZ9A2YmWsjA3BW10lElAyQceHI
 yqfmDKkQo64rzdt3aSOXVqEJVtrdLs3TflUELkjdiWr7k_oUpNPnixQ8uLX0pxu9JLpepLI8DCfq
 FrkW1Q.I8I9DylOJc2ZWe3pWSUSoEKYgYGa1zqYRlPrS1bsxsh.4b1EndRW1FZ9iZJBiTkYLP_uC
 nwhiaXAnV6XhhFW0WeQrV1Op91aZ8B_0flPhY2OrCoTFPT9xoT8MfBGOi1ndbja20GT3j4W6BH2I
 Hfg1TWNMRoiXzx5Pqwk92lXNWhZoGBRHZ5udM3bBTd4x8Tvcsi4m2WjLiiIYygr2H76_Jc8iPX27
 f1JVv1OquRcWreqaDgtyGj1DV5LnDEiX86u8ey1m9Owwcx5Gk34c1.8Q.MzvgsW3Eom5kfgEy3xv
 Cfa5j1UeznCC_1kpnNDThiWnvX0MzjCTayJMpK1Ym9cBndpoNzT7wxzBPBHYWrpeTPSXO4CzbZYD
 GYO8GZLhENK0qC8fwwCQCXNISNm8t9W4wDcZPyiuB06ilmsf5I6HMzY.A_lfwJLK_XlNQau7tGlf
 p7t_w1gCmpb9YMI4wRdpT5Rbe44ztHPk1i5Ly2b_Uhs_AuMr31aDxL8RUkX5eYJFZbKL143VqVYV
 V7ou.KNWjttp.D.KZEW5EAkLKBEwKKzCFmpdDVWpo85COhIGRVnn4lSIHXEYapHUeKlR28XUqaRT
 cttvuWZ5DfgpOkI8CgJx4MbKdgV8t3HVHfDyPwnH58QQTP0IKktvhaeTRuF6ctBQcsBttk5BK1PK
 TB5DQQ6ES8f5DTBz6NdBL0zeaYELr7_.6CQB6vD_T2_mcO7mDa5OPqgTDIp.qBq8b0SuuXT21lyv
 cBeJaCm_1OANRe_wRa6fpWdwhRDVb6zJRPpeItAq_tXT6n9UwlvwUofYKvGPxQcYPG2YDAE1cDRe
 wAiFEofvm_sHGnHqWT0VPTLHCVOxOYMtNZsX2gCCfCHypksdFQeMSsWaEi0nSRSZPaKwghMLZz0t
 46qL6ZcHnI4W0aaWfl54oEa_8P2.1mMa0nOI3KpH9GUKbfWgmruu1mW9Uu3ffNXffYEH.fjJashC
 A8LV0QlpudhSSF_lXwc4.FGIl7TYJhcNCcyblt71LiXupxf5KbEZUFYPykimYbfBtbB_TvWX1bTB
 zSAxZCkdEvHvN1_ne0CJl0pyQJLp.r2tgi9M4_vgasMhMeYoRc0cBA9GXoO8yEuKODURILI9pYBq
 D7Og6XrOJ8uZ38tEtMgjwFw_WVjbYT.nYfg5H4YhDBWDMd5_356ijfRJ0j7f9q3wb8yhSuZtU9JQ
 iXO_zcJA4lyq.tdiiSgS2AQ1bF0iUGXpyxRYvam6xTFvxNxqH_.cVYWNd1NI7oUfVVoh9l0CigAj
 FpOY1Hn92EvkUfXOKXGMKrITlFvQBatSLXtNK4JmpaRYln6Upi.TdTfm7erLuklLBLdQGqfN8PBk
 OByWhGKUbq3RZCX5m1XV9JbYbTuv1PEMVPwg5cJ89084lIGGwhoklVGVIk54ppvhwLaQT54ZXqva
 V_qKPtuZX5huRaoNzw.HFUAmSGWFzvAPf9PlBp2.iDTdiohjkpGGMFWqOQV8Jlah3G6akW3.VN1t
 HkVslzSZsyfmWzTkvBZKe6i_x33MshjGPU3TCpl7w7wByLIJAR34wO3PQXpo47REPtztwl_6QIhD
 4ihbk6kgPj0cWFHSyNMLsrXv_6Vr_awQX7X6RytjzthzKTgmCkWdMPlKds7TepvhvBaS3bRf5Jt6
 xKPiyFmHKK5ZzX0V6a4OA7HzHYXGp5RzeATF0dOl5wdLzWarTMkT944eGEMM6GRzMmXKV_8mvS8I
 GX1znL19tXRZ30yCzK1NIo5j0TwGgWEvFmF626BSbjK8vFRgiPCWjddNVs089e7a.R4U005tA3Vc
 Y2R9znIJ_hbJd90E.TKdH7QRyr5HQQnPIoF5WdO3NJocSQMy7KbhBwiEV6zXD9.07QveeejlWxXr
 zKgsQWnnkfnitEaRmiQOiJIpHdbzsgEz4Wq1y3Xs77h3qJaLpM_bPIVu3OFXC6aKcuBY7JboNOdV
 Wk7239jrT5uo.Nts3orsv.BjclIMYsHmBvJnBSjmXUCb.xjHwiqN7pLGFvlL4BxLLjLtl3eL6Tcm
 FOZlEgJ9kZ_L572kJkSk3EmsBnf9x4as8YGTKvBioiUc-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Thu, 20 Oct 2022 13:27:00 +0000
Received: by hermes--production-gq1-754cb59848-zdkt4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID f227043d9c28f9e6bf60558ba301e1c0;
          Thu, 20 Oct 2022 13:16:26 +0000 (UTC)
Message-ID: <68decac7-f8f7-1569-be84-8419a0e78417@schaufler-ca.com>
Date:   Thu, 20 Oct 2022 06:16:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] lsm: make security_socket_getpeersec_stream() sockptr_t
 safe
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        casey@schaufler-ca.com
References: <166543910984.474337.2779830480340611497.stgit@olly>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <166543910984.474337.2779830480340611497.stgit@olly>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20754 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/2022 2:58 PM, Paul Moore wrote:
> Commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> sockptr_t argument") made it possible to call sk_getsockopt()
> with both user and kernel address space buffers through the use of
> the sockptr_t type.  Unfortunately at the time of conversion the
> security_socket_getpeersec_stream() LSM hook was written to only
> accept userspace buffers, and in a desire to avoid having to change
> the LSM hook the commit author simply passed the sockptr_t's
> userspace buffer pointer.  Since the only sk_getsockopt() callers
> at the time of conversion which used kernel sockptr_t buffers did
> not allow SO_PEERSEC, and hence the
> security_socket_getpeersec_stream() hook, this was acceptable but
> also very fragile as future changes presented the possibility of
> silently passing kernel space pointers to the LSM hook.
>
> There are several ways to protect against this, including careful
> code review of future commits, but since relying on code review to
> catch bugs is a recipe for disaster and the upstream eBPF maintainer
> is "strongly against defensive programming", this patch updates the
> LSM hook, and all of the implementations to support sockptr_t and
> safely handle both user and kernel space buffers.
>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Smack part looks ok, I haven't had the opportunity to test it.
Will do so as I crunch through the backlog.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  include/linux/lsm_hook_defs.h |    2 +-
>  include/linux/lsm_hooks.h     |    4 ++--
>  include/linux/security.h      |   11 +++++++----
>  net/core/sock.c               |    3 ++-
>  security/apparmor/lsm.c       |   29 +++++++++++++----------------
>  security/security.c           |    6 +++---
>  security/selinux/hooks.c      |   13 ++++++-------
>  security/smack/smack_lsm.c    |   19 ++++++++++---------
>  8 files changed, 44 insertions(+), 43 deletions(-)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index ec119da1d89b4..6abde829b6e5e 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -302,7 +302,7 @@ LSM_HOOK(int, 0, socket_setsockopt, struct socket *sock, int level, int optname)
>  LSM_HOOK(int, 0, socket_shutdown, struct socket *sock, int how)
>  LSM_HOOK(int, 0, socket_sock_rcv_skb, struct sock *sk, struct sk_buff *skb)
>  LSM_HOOK(int, 0, socket_getpeersec_stream, struct socket *sock,
> -	 char __user *optval, int __user *optlen, unsigned len)
> +	 sockptr_t optval, sockptr_t optlen, unsigned int len)
>  LSM_HOOK(int, 0, socket_getpeersec_dgram, struct socket *sock,
>  	 struct sk_buff *skb, u32 *secid)
>  LSM_HOOK(int, 0, sk_alloc_security, struct sock *sk, int family, gfp_t priority)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 4ec80b96c22e7..883f0f252f062 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -962,8 +962,8 @@
>   *	SO_GETPEERSEC.  For tcp sockets this can be meaningful if the
>   *	socket is associated with an ipsec SA.
>   *	@sock is the local socket.
> - *	@optval userspace memory where the security state is to be copied.
> - *	@optlen userspace int where the module should copy the actual length
> + *	@optval memory where the security state is to be copied.
> + *	@optlen memory where the module should copy the actual length
>   *	of the security state.
>   *	@len as input is the maximum length to copy to userspace provided
>   *	by the caller.
> diff --git a/include/linux/security.h b/include/linux/security.h
> index ca1b7109c0dbb..0e419c595cee5 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -31,6 +31,7 @@
>  #include <linux/err.h>
>  #include <linux/string.h>
>  #include <linux/mm.h>
> +#include <linux/sockptr.h>
>  
>  struct linux_binprm;
>  struct cred;
> @@ -1411,8 +1412,8 @@ int security_socket_getsockopt(struct socket *sock, int level, int optname);
>  int security_socket_setsockopt(struct socket *sock, int level, int optname);
>  int security_socket_shutdown(struct socket *sock, int how);
>  int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb);
> -int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
> -				      int __user *optlen, unsigned len);
> +int security_socket_getpeersec_stream(struct socket *sock, sockptr_t optval,
> +				      sockptr_t optlen, unsigned int len);
>  int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid);
>  int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
>  void security_sk_free(struct sock *sk);
> @@ -1548,8 +1549,10 @@ static inline int security_sock_rcv_skb(struct sock *sk,
>  	return 0;
>  }
>  
> -static inline int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
> -						    int __user *optlen, unsigned len)
> +static inline int security_socket_getpeersec_stream(struct socket *sock,
> +						    sockptr_t optval,
> +						    sockptr_t optlen,
> +						    unsigned int len)
>  {
>  	return -ENOPROTOOPT;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index eeb6cbac6f499..70064415349d6 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1793,7 +1793,8 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		break;
>  
>  	case SO_PEERSEC:
> -		return security_socket_getpeersec_stream(sock, optval.user, optlen.user, len);
> +		return security_socket_getpeersec_stream(sock,
> +							 optval, optlen, len);
>  
>  	case SO_MARK:
>  		v.val = sk->sk_mark;
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index f56070270c69d..89e84ef54e8eb 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -1103,11 +1103,10 @@ static struct aa_label *sk_peer_label(struct sock *sk)
>   * Note: for tcp only valid if using ipsec or cipso on lan
>   */
>  static int apparmor_socket_getpeersec_stream(struct socket *sock,
> -					     char __user *optval,
> -					     int __user *optlen,
> +					     sockptr_t optval, sockptr_t optlen,
>  					     unsigned int len)
>  {
> -	char *name;
> +	char *name = NULL;
>  	int slen, error = 0;
>  	struct aa_label *label;
>  	struct aa_label *peer;
> @@ -1124,23 +1123,21 @@ static int apparmor_socket_getpeersec_stream(struct socket *sock,
>  	/* don't include terminating \0 in slen, it breaks some apps */
>  	if (slen < 0) {
>  		error = -ENOMEM;
> -	} else {
> -		if (slen > len) {
> -			error = -ERANGE;
> -		} else if (copy_to_user(optval, name, slen)) {
> -			error = -EFAULT;
> -			goto out;
> -		}
> -		if (put_user(slen, optlen))
> -			error = -EFAULT;
> -out:
> -		kfree(name);
> -
> +		goto done;
> +	}
> +	if (slen > len) {
> +		error = -ERANGE;
> +		goto done_len;
>  	}
>  
> +	if (copy_to_sockptr(optval, name, slen))
> +		error = -EFAULT;
> +done_len:
> +	if (copy_to_sockptr(optlen, &slen, sizeof(slen)))
> +		error = -EFAULT;
>  done:
>  	end_current_label_crit_section(label);
> -
> +	kfree(name);
>  	return error;
>  }
>  
> diff --git a/security/security.c b/security/security.c
> index 79d82cb6e4696..f27c885ee98db 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2267,11 +2267,11 @@ int security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(security_sock_rcv_skb);
>  
> -int security_socket_getpeersec_stream(struct socket *sock, char __user *optval,
> -				      int __user *optlen, unsigned len)
> +int security_socket_getpeersec_stream(struct socket *sock, sockptr_t optval,
> +				      sockptr_t optlen, unsigned int len)
>  {
>  	return call_int_hook(socket_getpeersec_stream, -ENOPROTOOPT, sock,
> -				optval, optlen, len);
> +			     optval, optlen, len);
>  }
>  
>  int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u32 *secid)
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f553c370397ee..0bdddeba90a6c 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5119,11 +5119,12 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  	return err;
>  }
>  
> -static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *optval,
> -					    int __user *optlen, unsigned len)
> +static int selinux_socket_getpeersec_stream(struct socket *sock,
> +					    sockptr_t optval, sockptr_t optlen,
> +					    unsigned int len)
>  {
>  	int err = 0;
> -	char *scontext;
> +	char *scontext = NULL;
>  	u32 scontext_len;
>  	struct sk_security_struct *sksec = sock->sk->sk_security;
>  	u32 peer_sid = SECSID_NULL;
> @@ -5139,17 +5140,15 @@ static int selinux_socket_getpeersec_stream(struct socket *sock, char __user *op
>  				      &scontext_len);
>  	if (err)
>  		return err;
> -
>  	if (scontext_len > len) {
>  		err = -ERANGE;
>  		goto out_len;
>  	}
>  
> -	if (copy_to_user(optval, scontext, scontext_len))
> +	if (copy_to_sockptr(optval, scontext, scontext_len))
>  		err = -EFAULT;
> -
>  out_len:
> -	if (put_user(scontext_len, optlen))
> +	if (copy_to_sockptr(optlen, &scontext_len, sizeof(scontext_len)))
>  		err = -EFAULT;
>  	kfree(scontext);
>  	return err;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index b6306d71c9088..2bd7fadf7fb4c 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -4006,12 +4006,12 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
>   * returns zero on success, an error code otherwise
>   */
>  static int smack_socket_getpeersec_stream(struct socket *sock,
> -					  char __user *optval,
> -					  int __user *optlen, unsigned len)
> +					  sockptr_t optval, sockptr_t optlen,
> +					  unsigned int len)
>  {
>  	struct socket_smack *ssp;
>  	char *rcp = "";
> -	int slen = 1;
> +	u32 slen = 1;
>  	int rc = 0;
>  
>  	ssp = sock->sk->sk_security;
> @@ -4019,15 +4019,16 @@ static int smack_socket_getpeersec_stream(struct socket *sock,
>  		rcp = ssp->smk_packet->smk_known;
>  		slen = strlen(rcp) + 1;
>  	}
> -
> -	if (slen > len)
> +	if (slen > len) {
>  		rc = -ERANGE;
> -	else if (copy_to_user(optval, rcp, slen) != 0)
> -		rc = -EFAULT;
> +		goto out_len;
> +	}
>  
> -	if (put_user(slen, optlen) != 0)
> +	if (copy_to_sockptr(optval, rcp, slen))
> +		rc = -EFAULT;
> +out_len:
> +	if (copy_to_sockptr(optlen, &slen, sizeof(slen)))
>  		rc = -EFAULT;
> -
>  	return rc;
>  }
>  
>
