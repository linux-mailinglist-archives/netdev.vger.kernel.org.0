Return-Path: <netdev+bounces-11979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C78673592E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E9E71C206FD
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A76911C95;
	Mon, 19 Jun 2023 14:10:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1532010955
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:10:02 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAF59C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:09:58 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230619140956epoutp03f2743a0c441eff0c3447b0b6a387cb7d~qFLkzGK912620426204epoutp03h
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:09:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230619140956epoutp03f2743a0c441eff0c3447b0b6a387cb7d~qFLkzGK912620426204epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1687183796;
	bh=YvsgVpaZfpGJkiQI2ColLEmDJpDQ+dd1lzxFWfaUAjo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IMn1GN4jxMKbYipCzZnSt0/8tIXopbFS6xM3FEG+0eKocB+bfU8PSv0vV7C6cy9bc
	 7VyzxmWGkHkeYDPdNeNz8fK7i9QtOjSRuFgNusIotUMtBG64CgvKXufTRip2v71uu9
	 zGYrKH/vONGlfENfoKPSPv/j0T3fwRORjs4KIy+E=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20230619140955epcas5p3159e71a65610a46d52c23f10880066ca~qFLkBn4Lm0209302093epcas5p3b;
	Mon, 19 Jun 2023 14:09:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4QlBV94Bvlz4x9Pw; Mon, 19 Jun
	2023 14:09:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	05.B5.55522.1B160946; Mon, 19 Jun 2023 23:09:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20230619140952epcas5p2048459ecb5f40666fd5903986647174f~qFLhzlgkM0305803058epcas5p2f;
	Mon, 19 Jun 2023 14:09:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230619140952epsmtrp1ebd83c83652cefe3607b1d2db2cbad3f~qFLhxWGiZ1636116361epsmtrp1d;
	Mon, 19 Jun 2023 14:09:52 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-95-649061b19265
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F4.85.34491.0B160946; Mon, 19 Jun 2023 23:09:52 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20230619140947epsmtip2dd41727cf0f3c85379f785461b80a3cf~qFLcjFnLR1393313933epsmtip2S;
	Mon, 19 Jun 2023 14:09:47 +0000 (GMT)
Date: Mon, 19 Jun 2023 19:36:35 +0530
From: Kanchan Joshi <joshi.k@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Ahern <dsahern@kernel.org>, Breno Leitao <leitao@debian.org>,
	io-uring@vger.kernel.org, axboe@kernel.dk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, Matthieu Baerts
	<matthieu.baerts@tessares.net>, Mat Martineau <martineau@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
	<lucien.xin@gmail.com>, leit@fb.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, dccp@vger.kernel.org, mptcp@lists.linux.dev,
	linux-sctp@vger.kernel.org, ast@kernel.org, kuniyu@amazon.com,
	martin.lau@kernel.org, Jason Xing <kernelxing@tencent.com>, Joanne Koong
	<joannelkoong@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Willem de Bruijn
	<willemb@google.com>, Guillaume Nault <gnault@redhat.com>, Andrea Righi
	<andrea.righi@canonical.com>
Subject: Re: [RFC PATCH v2 1/4] net: wire up support for
 file_operations->uring_cmd()
Message-ID: <20230619140635.GA4046@green245>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d9c9bd5f-b17e-fbd8-5646-4f51b927cc6b@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfzBcVxTHc9/bfW+ls+Z1CTdbVFYzGQS7yuZKaNOSeKEaTdvRkWlkx75Y
	xdruD01MO6M0UhrxIxFhaFfSQf2IEKERJERWs1UMIYMyqpYQQVUlZWh3s9tO/vucc7/fOeee
	M4eD86pJPidWrmaUckm8gNjKarzr6upRJ8mRCmfTHNHsd2MsVFzZCNDK36MkqhrLJlBx71cs
	tPHwGwJdbT6NIYNukkSXlutIlHallkALp3tYaGKQj5629+Goa/g+C/U1nmOjsrM1BKosGsfQ
	k5wGgAaaiwlk0D5mo8naRQytVXSx0UbmAol6sv7BUUX3NIa6a1NJpNPaodWf5wFaaOgk9zvS
	FX2ZbLooJYugG34Yxui19BKczk1bIOmbRWMkra3X0AO/aOj6ygyCvl1STdKPrhcCerFtkKC/
	zB8i6F9TC3D6z3on+vyGAQ+nIuP8ZYxEyiidGXl0ojRWHhMgCH0/KjDKVywUeYj80B6Bs1yS
	wAQIgt4J9zgYG2+ck8A5SRKvMabCJSqVwOsNf2WiRs04yxJV6gABo5DGK3wUnipJgkojj/GU
	M+q9IqHQ29coPB4nS8mcZysm+Cerc4UpIMsuE3A4kPKBNU2HM8FWDo+6BWBp3SOWOVgG8Gpq
	oTGwMgarAOry3U1sMtycTQVmUSuAYyN5Fsc0gB1lM8CkYlE7oX6tCjOVIChX2HdeY0rbUu7w
	8cMO0qTHKQMB8/P0hOnBhoqA9xa1uEnPpXbDuZKDpjSXehneL5x63oQVFQDz6gowE2+jXOCd
	xi7M3NCyFRzSeZs5CI5uPCXNbAPnuhoszIez2ekWjob9hT0Wrxr+3tJu4TfhaX02bmKckkFD
	Z5uFrWHW+hRmnhYXfp3OM8t3wPE8A9vM9vC3S99bmIbNjXrLfC5jsHf+AjsHOBW98J2iF0qY
	eS/MWEplFxlL4NQrsHyTY0ZXWNvspQXsSrCdUagSYhiVr0IkZz77f8HRiQn14PnZuB36EYxN
	LHl2AIwDOgDk4AJb7pHWc1IeVyo5lcwoE6OUmnhG1QF8jdvJxfnbohONdydXR4l8/IQ+YrHY
	x+91sUhgz73bnSXlUTESNRPHMApG+Z8P41jxU7Co41/I1GeTdDXPqtodViPz/cOSu7wy5EdW
	C7v1DrxPVzzuvXpmI9upv1N9OGH0sovn8h8gweG9gmf7Qjkl+4YuBI+Kr3tc43m0zlWUH/34
	RJo24lhe/kXffkd77mZTdOStkV3BK9af6GU708vfVoXZCd0rGd9gjPx26kZSy5561Y3Y0ICf
	gre3jZCDuhBwNCjlwYF6l9deqqT8ws40HaLvfDj1Qd8uw/gp5vNx2mpzR+DihM/6g7Kllr9E
	H9msu9YemNYt7p+5HbGMU3HqNrTFbcamdPwt26hkpycuKD93sjdkS+DF3c5XZmMiTriXDmeu
	NrQfy3j32sk1a8HcTIiY3+o9IGCpZBKRG65USf4Flu+GQL8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTZxzG895d744mNSeofcGgS7ea6BjaKexN0GXESU6XGWc0LM4B1V7w
	BwXW2omKS0uVaJUfgxLGrWijhpWCMGpXBKI41FYQsMYBI1BFI0K1tlPZHBXQtMTof988n8/z
	/PWl8cgZIobenb2PU2XLsySkkHBclSz+5Hd5qWLFKasUeU97CGSyOgCamByiUJ2nhESmW0cI
	ND1wgkQNrUcxNOp8QKFfnjdRSH+2kUT+o70EGumLQS//dOPINdhJILejWIBqTp4nkZW/i6Gn
	pXaA7rSaSDRqfiJADxoDGApaXAI0bfBTqLfoNY4s3Y8w1N1YQCGneQH676YPIL/9GvVFLGtx
	GwQsry0iWXvtIMYGC6tx9me9n2JbeA/Fmm0a9k6PhrVZj5Nse3U9xY5fqAJs4HIfyeoq+kl2
	uKASZ1/YFrHl06P4JmabcLWCy9r9I6da/nmGcBc/YaRyy2Ce6cptgRYMRhlABA2ZVbDFWwAM
	QEhHMm0A9lkCglkghvr+/6nZOwrWzoxRs9JDAP3HekAIEIwUdgXrMAOgaZJZCt3lmlA8j/kY
	PhnoCPs485SEUw49EQJRTCq8HjDjIV/ExMHH1Smzm2cwOO31YiFHxMyFnVUPwz7OJMJTF+6H
	fZxZCH+boUNxBLMGljVVhvX5zIfwisOFlYK5/Htt/r02/65tBrgVRHO5amWmUi3LlWVz++PV
	cqVak50ZvzNHaQPhF1m29CJotv4T3wEwGnQASOOSeaLNl4oVkSKF/MBBTpWTrtJkceoOsJAm
	JGKReLxIEclkyvdxezkul1O9pRgdEaPFir8fkqbA4eR2obf+gzHx3wt6DFfHnZVHkmNfX5yK
	vSx8ue4H9GrM9UyxNmd12zffpS0ZjM7/KOJVM0DcYeXKhMmV/47ofF3lztoa6xzbihO/puYl
	Oc5t3d5WoxIPDCe573kq0n9Cwr82rnEdmOzvLs7v/8ypmLze3tK5PbWzcPmiM/Tt5A1ld7fJ
	LEVjXwW+pge+fBx3yPhIShyyT2CW001KXXTQWPIsI5F/PiSVTRTqtKWfmrb40vjxPXhFQ8Li
	Kar12x1xvvmNDUnrz1JzDpek5Qm7PBn5KaZ0WlN3PnVz754NB0e064/nGO1/lFyzvajXpe/1
	XdpfcCOzO6g3HmuWEOpdctkyXKWWvwGYOeVpkQMAAA==
X-CMS-MailID: 20230619140952epcas5p2048459ecb5f40666fd5903986647174f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_7a99d_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230619092935epcas5p26ad065e6c9d339687802b9c26a4f0fbc
References: <20230614110757.3689731-1-leitao@debian.org>
	<20230614110757.3689731-2-leitao@debian.org>
	<6b5e5988-3dc7-f5d6-e447-397696c0d533@kernel.org>
	<CGME20230619092935epcas5p26ad065e6c9d339687802b9c26a4f0fbc@epcas5p2.samsung.com>
	<d9c9bd5f-b17e-fbd8-5646-4f51b927cc6b@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_7a99d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Jun 19, 2023 at 10:28:30AM +0100, Pavel Begunkov wrote:
>On 6/14/23 16:15, David Ahern wrote:
>>On 6/14/23 5:07 AM, Breno Leitao wrote:
>>>diff --git a/include/linux/net.h b/include/linux/net.h
>>>index 8defc8f1d82e..58dea87077af 100644
>>>--- a/include/linux/net.h
>>>+++ b/include/linux/net.h
>>>@@ -182,6 +182,8 @@ struct proto_ops {
>>>  	int	 	(*compat_ioctl) (struct socket *sock, unsigned int cmd,
>>>  				      unsigned long arg);
>>>  #endif
>>>+	int		(*uring_cmd)(struct socket *sock, struct io_uring_cmd *cmd,
>>>+				     unsigned int issue_flags);
>>>  	int		(*gettstamp) (struct socket *sock, void __user *userstamp,
>>>  				      bool timeval, bool time32);
>>>  	int		(*listen)    (struct socket *sock, int len);
>>>diff --git a/include/net/sock.h b/include/net/sock.h
>>>index 62a1b99da349..a49b8b19292b 100644
>>>--- a/include/net/sock.h
>>>+++ b/include/net/sock.h
>>>@@ -111,6 +111,7 @@ typedef struct {
>>>  struct sock;
>>>  struct proto;
>>>  struct net;
>>>+struct io_uring_cmd;
>>>  typedef __u32 __bitwise __portpair;
>>>  typedef __u64 __bitwise __addrpair;
>>>@@ -1259,6 +1260,9 @@ struct proto {
>>>  	int			(*ioctl)(struct sock *sk, int cmd,
>>>  					 int *karg);
>>>+	int			(*uring_cmd)(struct sock *sk,
>>>+					     struct io_uring_cmd *cmd,
>>>+					     unsigned int issue_flags);
>>>  	int			(*init)(struct sock *sk);
>>>  	void			(*destroy)(struct sock *sk);
>>>  	void			(*shutdown)(struct sock *sk, int how);
>>>@@ -1934,6 +1938,8 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>>>  			int flags);
>>>  int sock_common_setsockopt(struct socket *sock, int level, int optname,
>>>  			   sockptr_t optval, unsigned int optlen);
>>>+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
>>>+			  unsigned int issue_flags);
>>>  void sk_common_release(struct sock *sk);
>>>diff --git a/net/core/sock.c b/net/core/sock.c
>>>index 1df7e432fec5..339fa74db60f 100644
>>>--- a/net/core/sock.c
>>>+++ b/net/core/sock.c
>>>@@ -3668,6 +3668,18 @@ int sock_common_setsockopt(struct socket *sock, int level, int optname,
>>>  }
>>>  EXPORT_SYMBOL(sock_common_setsockopt);
>>>+int sock_common_uring_cmd(struct socket *sock, struct io_uring_cmd *cmd,
>>>+			  unsigned int issue_flags)
>>>+{
>>>+	struct sock *sk = sock->sk;
>>>+
>>>+	if (!sk->sk_prot || !sk->sk_prot->uring_cmd)
>>>+		return -EOPNOTSUPP;
>>>+
>>>+	return sk->sk_prot->uring_cmd(sk, cmd, issue_flags);
>>>+}
>>>+EXPORT_SYMBOL(sock_common_uring_cmd);
>>>+
>>
>>
>>io_uring is just another in-kernel user of sockets. There is no reason
>>for io_uring references to be in core net code. It should be using
>>exposed in-kernel APIs and doing any translation of its op codes in
>>io_uring/  code.
>
>That callback is all about file dependent operations, just like ioctl.
>And as the patch in question is doing socket specific stuff, I think
>architecturally it fits well. 

I also feel that it fits well.
Other users of uring-cmd (nvme, ublk) follow the same model.

------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_7a99d_
Content-Type: text/plain; charset="utf-8"


------PcSJ1RlEyPKfjXIiTsweH-7MCPtMf9v3nlMrb72LWO-fIHxy=_7a99d_--

