Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15790366EA5
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243755AbhDUPBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:01:17 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:31497 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbhDUPBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 11:01:16 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id BB913767B3;
        Wed, 21 Apr 2021 18:00:39 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1619017239;
        bh=sU1nne6qBUrBDxRVKCmiRB8S7dcqMKBY8PPdtB0XIvc=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=tvVnvgWYLSxa1i9BDBLOeiz3ToEMgHlEVAJ7sT32Slcp0U5j7sANl7lORS7fciHGS
         PvDD8pbM4k3N8qMvRFTqqGZyBH/I5p6gRrhWta4lN18R2/mRe6WcuKnG5+s0xvseUm
         iMgIsLDJ/iTRFbJSjE0+lJy4TvTOsLTi9T3M65XSf6vzWarQ+T8ZTer/myogr6Naex
         zSjQDM1wL9k9MEloYl1RNSUQithjE7BkOltLLudBrWJgbwVipM/eihYLJC82Z4ffLb
         BEdDQ5nQosEjlM34vDVZpPDuMTlsdYf+y7av0IASWmc+psVL7h/yBtE1K06o47eW/C
         Pw5i805jq5+dw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 62098767D5;
        Wed, 21 Apr 2021 18:00:39 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 21
 Apr 2021 18:00:38 +0300
Subject: Re: [RFC PATCH v8 17/19] vsock_test: add SOCK_SEQPACKET tests
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
 <20210413124701.3407363-1-arseny.krasnov@kaspersky.com>
 <20210421093554.y45al5r7xhoo7dwh@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <83c2c9cb-b163-a6de-e00a-43c3c8def475@kaspersky.com>
Date:   Wed, 21 Apr 2021 18:00:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210421093554.y45al5r7xhoo7dwh@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/21/2021 14:49:38
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163272 [Apr 21 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/21/2021 14:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 21.04.2021 11:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/21 14:24:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/21 11:31:00 #16604789
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21.04.2021 12:35, Stefano Garzarella wrote:
> On Tue, Apr 13, 2021 at 03:46:58PM +0300, Arseny Krasnov wrote:
>> This adds test of SOCK_SEQPACKET socket: it transfer data and
>> then tests MSG_TRUNC flag. Cases for connect(), bind(), etc. are
>> not tested, because it is same as for stream socket.
>>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> v7 -> v8:
>> - Test for MSG_EOR flags now removed.
> Why did we remove it?
Because MSG_EOR flag support was removed.
>
> Thanks,
> Stefano
>
>> tools/testing/vsock/util.c       | 32 +++++++++++++---
>> tools/testing/vsock/util.h       |  3 ++
>> tools/testing/vsock/vsock_test.c | 63 ++++++++++++++++++++++++++++++++
>> 3 files changed, 93 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>> index 93cbd6f603f9..2acbb7703c6a 100644
>> --- a/tools/testing/vsock/util.c
>> +++ b/tools/testing/vsock/util.c
>> @@ -84,7 +84,7 @@ void vsock_wait_remote_close(int fd)
>> }
>>
>> /* Connect to <cid, port> and return the file descriptor. */
>> -int vsock_stream_connect(unsigned int cid, unsigned int port)
>> +static int vsock_connect(unsigned int cid, unsigned int port, int type)
>> {
>> 	union {
>> 		struct sockaddr sa;
>> @@ -101,7 +101,7 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
>>
>> 	control_expectln("LISTENING");
>>
>> -	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>> +	fd = socket(AF_VSOCK, type, 0);
>>
>> 	timeout_begin(TIMEOUT);
>> 	do {
>> @@ -120,11 +120,21 @@ int vsock_stream_connect(unsigned int cid, unsigned int port)
>> 	return fd;
>> }
>>
>> +int vsock_stream_connect(unsigned int cid, unsigned int port)
>> +{
>> +	return vsock_connect(cid, port, SOCK_STREAM);
>> +}
>> +
>> +int vsock_seqpacket_connect(unsigned int cid, unsigned int port)
>> +{
>> +	return vsock_connect(cid, port, SOCK_SEQPACKET);
>> +}
>> +
>> /* Listen on <cid, port> and return the first incoming connection.  The remote
>>  * address is stored to clientaddrp.  clientaddrp may be NULL.
>>  */
>> -int vsock_stream_accept(unsigned int cid, unsigned int port,
>> -			struct sockaddr_vm *clientaddrp)
>> +static int vsock_accept(unsigned int cid, unsigned int port,
>> +			struct sockaddr_vm *clientaddrp, int type)
>> {
>> 	union {
>> 		struct sockaddr sa;
>> @@ -145,7 +155,7 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
>> 	int client_fd;
>> 	int old_errno;
>>
>> -	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
>> +	fd = socket(AF_VSOCK, type, 0);
>>
>> 	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
>> 		perror("bind");
>> @@ -189,6 +199,18 @@ int vsock_stream_accept(unsigned int cid, unsigned int port,
>> 	return client_fd;
>> }
>>
>> +int vsock_stream_accept(unsigned int cid, unsigned int port,
>> +			struct sockaddr_vm *clientaddrp)
>> +{
>> +	return vsock_accept(cid, port, clientaddrp, SOCK_STREAM);
>> +}
>> +
>> +int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>> +			   struct sockaddr_vm *clientaddrp)
>> +{
>> +	return vsock_accept(cid, port, clientaddrp, SOCK_SEQPACKET);
>> +}
>> +
>> /* Transmit one byte and check the return value.
>>  *
>>  * expected_ret:
>> diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>> index e53dd09d26d9..a3375ad2fb7f 100644
>> --- a/tools/testing/vsock/util.h
>> +++ b/tools/testing/vsock/util.h
>> @@ -36,8 +36,11 @@ struct test_case {
>> void init_signals(void);
>> unsigned int parse_cid(const char *str);
>> int vsock_stream_connect(unsigned int cid, unsigned int port);
>> +int vsock_seqpacket_connect(unsigned int cid, unsigned int port);
>> int vsock_stream_accept(unsigned int cid, unsigned int port,
>> 			struct sockaddr_vm *clientaddrp);
>> +int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
>> +			   struct sockaddr_vm *clientaddrp);
>> void vsock_wait_remote_close(int fd);
>> void send_byte(int fd, int expected_ret, int flags);
>> void recv_byte(int fd, int expected_ret, int flags);
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index 5a4fb80fa832..ffec985fd36f 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -14,6 +14,8 @@
>> #include <errno.h>
>> #include <unistd.h>
>> #include <linux/kernel.h>
>> +#include <sys/types.h>
>> +#include <sys/socket.h>
>>
>> #include "timeout.h"
>> #include "control.h"
>> @@ -279,6 +281,62 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>> 	close(fd);
>> }
>>
>> +#define MESSAGE_TRUNC_SZ 32
>> +static void test_seqpacket_msg_trunc_client(const struct test_opts *opts)
>> +{
>> +	int fd;
>> +	char buf[MESSAGE_TRUNC_SZ];
>> +
>> +	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>> +	if (fd < 0) {
>> +		perror("connect");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	if (send(fd, buf, sizeof(buf), 0) != sizeof(buf)) {
>> +		perror("send failed");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	control_writeln("SENDDONE");
>> +	close(fd);
>> +}
>> +
>> +static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
>> +{
>> +	int fd;
>> +	char buf[MESSAGE_TRUNC_SZ / 2];
>> +	struct msghdr msg = {0};
>> +	struct iovec iov = {0};
>> +
>> +	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>> +	if (fd < 0) {
>> +		perror("accept");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	control_expectln("SENDDONE");
>> +	iov.iov_base = buf;
>> +	iov.iov_len = sizeof(buf);
>> +	msg.msg_iov = &iov;
>> +	msg.msg_iovlen = 1;
>> +
>> +	ssize_t ret = recvmsg(fd, &msg, MSG_TRUNC);
>> +
>> +	if (ret != MESSAGE_TRUNC_SZ) {
>> +		printf("%zi\n", ret);
>> +		perror("MSG_TRUNC doesn't work");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	if (!(msg.msg_flags & MSG_TRUNC)) {
>> +		fprintf(stderr, "MSG_TRUNC expected\n");
>> +		exit(EXIT_FAILURE);
>> +	}
>> +
>> +	close(fd);
>> +}
>> +
>> static struct test_case test_cases[] = {
>> 	{
>> 		.name = "SOCK_STREAM connection reset",
>> @@ -309,6 +367,11 @@ static struct test_case test_cases[] = {
>> 		.run_client = test_stream_msg_peek_client,
>> 		.run_server = test_stream_msg_peek_server,
>> 	},
>> +	{
>> +		.name = "SOCK_SEQPACKET send data MSG_TRUNC",
>> +		.run_client = test_seqpacket_msg_trunc_client,
>> +		.run_server = test_seqpacket_msg_trunc_server,
>> +	},
>> 	{},
>> };
>>
>> -- 
>> 2.25.1
>>
>
