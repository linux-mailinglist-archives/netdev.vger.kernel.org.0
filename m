Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0262D32149C
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBVK7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 05:59:11 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:18754 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhBVK7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 05:59:04 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 0A0997634E;
        Mon, 22 Feb 2021 13:58:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613991494;
        bh=SHYi7PV63WP4rrEl4a+UIz2wZejxCQTWp3Pmwar1YxU=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=XmsIZFekDth4nLp9WJTj3Z1tgj0NPMdWS9aUgF1iEYPKlze0dAZGlVPi3U+9ldjrI
         IiDy8D47/zFIlMo1kzsKxDHYAg32YGnwkUDFB1bYJzFTLEnkyxMJLC1kBGSoPJzbrO
         xe2ag0GpogpRgnlx7DZTNOEfA0WPQJKA2qZusyufteB4u12JTA71Qht6RAfQ55Q1O2
         M0Vzz/+xCk0pAIIutFkxmaDpy+2s7P0VUrDseTlUTvNykKWDGvHLsowN2LklXtoqDm
         qAv7uAH5gFW1YKWt389aiPHyyx+iX6ARYEpj9DWTlvjadFPC0WHmileGa5ZAo4RxKq
         gMdc0/A2YP5Gw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 38DCB76298;
        Mon, 22 Feb 2021 13:58:13 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 22
 Feb 2021 13:58:12 +0300
Subject: Re: [RFC PATCH v5 01/19] af_vsock: update functions for connectible
 socket
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053607.1066783-1-arseny.krasnov@kaspersky.com>
 <20210222105023.aqcu25irkeed6div@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <279059b2-4c08-16d4-3bca-03640c7932d9@kaspersky.com>
Date:   Mon, 22 Feb 2021 13:58:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222105023.aqcu25irkeed6div@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_content_type, plain}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_c_tr_enc, eight_bit}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/22 09:47:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/22 04:39:00 #16312882
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22.02.2021 13:50, Stefano Garzarella wrote:
> On Thu, Feb 18, 2021 at 08:36:03AM +0300, Arseny Krasnov wrote:
>> This prepares af_vsock.c for SEQPACKET support: some functions such
>> as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
>> shared between both types of sockets, so rename them in general
>> manner.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
>> 1 file changed, 34 insertions(+), 30 deletions(-)
> IIRC I had already given my R-b to this patch. Please carry it over when 
> you post a new version.
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>
> Thanks,
> Stefano
Ack, sorry, didn't know that
>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 5546710d8ac1..656370e11707 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -604,8 +604,8 @@ static void vsock_pending_work(struct work_struct *work)
>>
>> /**** SOCKET OPERATIONS ****/
>>
>> -static int __vsock_bind_stream(struct vsock_sock *vsk,
>> -			       struct sockaddr_vm *addr)
>> +static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> +				    struct sockaddr_vm *addr)
>> {
>> 	static u32 port;
>> 	struct sockaddr_vm new_addr;
>> @@ -685,7 +685,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
>> 	switch (sk->sk_socket->type) {
>> 	case SOCK_STREAM:
>> 		spin_lock_bh(&vsock_table_lock);
>> -		retval = __vsock_bind_stream(vsk, addr);
>> +		retval = __vsock_bind_connectible(vsk, addr);
>> 		spin_unlock_bh(&vsock_table_lock);
>> 		break;
>>
>> @@ -767,6 +767,11 @@ static struct sock *__vsock_create(struct net *net,
>> 	return sk;
>> }
>>
>> +static bool sock_type_connectible(u16 type)
>> +{
>> +	return type == SOCK_STREAM;
>> +}
>> +
>> static void __vsock_release(struct sock *sk, int level)
>> {
>> 	if (sk) {
>> @@ -785,7 +790,7 @@ static void __vsock_release(struct sock *sk, int level)
>>
>> 		if (vsk->transport)
>> 			vsk->transport->release(vsk);
>> -		else if (sk->sk_type == SOCK_STREAM)
>> +		else if (sock_type_connectible(sk->sk_type))
>> 			vsock_remove_sock(vsk);
>>
>> 		sock_orphan(sk);
>> @@ -947,7 +952,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
>> 	lock_sock(sk);
>> 	if (sock->state == SS_UNCONNECTED) {
>> 		err = -ENOTCONN;
>> -		if (sk->sk_type == SOCK_STREAM)
>> +		if (sock_type_connectible(sk->sk_type))
>> 			goto out;
>> 	} else {
>> 		sock->state = SS_DISCONNECTING;
>> @@ -960,7 +965,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
>> 		sk->sk_shutdown |= mode;
>> 		sk->sk_state_change(sk);
>>
>> -		if (sk->sk_type == SOCK_STREAM) {
>> +		if (sock_type_connectible(sk->sk_type)) {
>> 			sock_reset_flag(sk, SOCK_DONE);
>> 			vsock_send_shutdown(sk, mode);
>> 		}
>> @@ -1015,7 +1020,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>> 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
>> 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
>>
>> -	} else if (sock->type == SOCK_STREAM) {
>> +	} else if (sock_type_connectible(sk->sk_type)) {
>> 		const struct vsock_transport *transport;
>>
>> 		lock_sock(sk);
>> @@ -1262,8 +1267,8 @@ static void vsock_connect_timeout(struct work_struct *work)
>> 	sock_put(sk);
>> }
>>
>> -static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
>> -				int addr_len, int flags)
>> +static int vsock_connect(struct socket *sock, struct sockaddr *addr,
>> +			 int addr_len, int flags)
>> {
>> 	int err;
>> 	struct sock *sk;
>> @@ -1413,7 +1418,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
>>
>> 	lock_sock(listener);
>>
>> -	if (sock->type != SOCK_STREAM) {
>> +	if (!sock_type_connectible(sock->type)) {
>> 		err = -EOPNOTSUPP;
>> 		goto out;
>> 	}
>> @@ -1490,7 +1495,7 @@ static int vsock_listen(struct socket *sock, int backlog)
>>
>> 	lock_sock(sk);
>>
>> -	if (sock->type != SOCK_STREAM) {
>> +	if (!sock_type_connectible(sk->sk_type)) {
>> 		err = -EOPNOTSUPP;
>> 		goto out;
>> 	}
>> @@ -1534,11 +1539,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
>> 	vsk->buffer_size = val;
>> }
>>
>> -static int vsock_stream_setsockopt(struct socket *sock,
>> -				   int level,
>> -				   int optname,
>> -				   sockptr_t optval,
>> -				   unsigned int optlen)
>> +static int vsock_connectible_setsockopt(struct socket *sock,
>> +					int level,
>> +					int optname,
>> +					sockptr_t optval,
>> +					unsigned int optlen)
>> {
>> 	int err;
>> 	struct sock *sk;
>> @@ -1616,10 +1621,10 @@ static int vsock_stream_setsockopt(struct socket *sock,
>> 	return err;
>> }
>>
>> -static int vsock_stream_getsockopt(struct socket *sock,
>> -				   int level, int optname,
>> -				   char __user *optval,
>> -				   int __user *optlen)
>> +static int vsock_connectible_getsockopt(struct socket *sock,
>> +					int level, int optname,
>> +					char __user *optval,
>> +					int __user *optlen)
>> {
>> 	int err;
>> 	int len;
>> @@ -1687,8 +1692,8 @@ static int vsock_stream_getsockopt(struct socket *sock,
>> 	return 0;
>> }
>>
>> -static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>> -				size_t len)
>> +static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>> +				     size_t len)
>> {
>> 	struct sock *sk;
>> 	struct vsock_sock *vsk;
>> @@ -1827,10 +1832,9 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>> 	return err;
>> }
>>
>> -
>> static int
>> -vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> -		     int flags)
>> +vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>> +			  int flags)
>> {
>> 	struct sock *sk;
>> 	struct vsock_sock *vsk;
>> @@ -2006,7 +2010,7 @@ static const struct proto_ops vsock_stream_ops = {
>> 	.owner = THIS_MODULE,
>> 	.release = vsock_release,
>> 	.bind = vsock_bind,
>> -	.connect = vsock_stream_connect,
>> +	.connect = vsock_connect,
>> 	.socketpair = sock_no_socketpair,
>> 	.accept = vsock_accept,
>> 	.getname = vsock_getname,
>> @@ -2014,10 +2018,10 @@ static const struct proto_ops vsock_stream_ops = {
>> 	.ioctl = sock_no_ioctl,
>> 	.listen = vsock_listen,
>> 	.shutdown = vsock_shutdown,
>> -	.setsockopt = vsock_stream_setsockopt,
>> -	.getsockopt = vsock_stream_getsockopt,
>> -	.sendmsg = vsock_stream_sendmsg,
>> -	.recvmsg = vsock_stream_recvmsg,
>> +	.setsockopt = vsock_connectible_setsockopt,
>> +	.getsockopt = vsock_connectible_getsockopt,
>> +	.sendmsg = vsock_connectible_sendmsg,
>> +	.recvmsg = vsock_connectible_recvmsg,
>> 	.mmap = sock_no_mmap,
>> 	.sendpage = sock_no_sendpage,
>> };
>> -- 
>> 2.25.1
>>
>
