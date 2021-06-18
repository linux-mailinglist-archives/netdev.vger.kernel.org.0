Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E4E3ACE09
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbhFRO5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:57:14 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:11055 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbhFRO5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:57:14 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 77277520D59;
        Fri, 18 Jun 2021 17:55:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624028102;
        bh=4Ql2rRzdl8rVudC6sQhZlsTSCRCyLAPTeKvmUH4ZV68=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=CGmcPwOBQ7brMtIRE+8e/jXVot5m/l6FHoZJBXs8GGevSHPw5EWTweTolD7JdERZ+
         yXsVXQQ+ircs6P03VKuxCJqbNKs9A7aZqXv6PqIgFyBhSaxJ4ciD4C/PNuLhENYdmz
         PDWtiXPsehK6XCqkH6VlLxfcMBT6ePqC6LO3wcCmwaJH3CtCFwpNzNL+r2+Vzn5mDL
         +iKDMiQygHPhbdBhg6GxoiZRE5ibpc4R1Qz7GW8EWbid4fq9P9/Xn464GvrKkEVnjc
         ho629tHd7BBG02vZSRWPDba+EtmcU1pX0oARUcI8zr0lyFrLoIsGCAUfZ/uMKIENZG
         1govM/81gDcAA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 2B31E520D4E;
        Fri, 18 Jun 2021 17:55:02 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 18
 Jun 2021 17:55:01 +0300
Subject: Re: [PATCH net-next 3/3] vsock/virtio: remove redundant `copy_failed`
 variable
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210618133526.300347-1-sgarzare@redhat.com>
 <20210618133526.300347-4-sgarzare@redhat.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <22ee764c-ea35-7510-28c4-bccaf0ab7269@kaspersky.com>
Date:   Fri, 18 Jun 2021 17:55:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210618133526.300347-4-sgarzare@redhat.com>
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/18/2021 14:29:51
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164482 [Jun 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/18/2021 14:32:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 18.06.2021 12:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/18 13:10:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/18 12:17:00 #16756757
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.06.2021 16:35, Stefano Garzarella wrote:
> When memcpy_to_msg() fails in virtio_transport_seqpacket_do_dequeue(),
> we already set `dequeued_len` with the negative error value returned
> by memcpy_to_msg().
>
> So we can directly check `dequeued_len` value instead of using a
> dedicated flag variable to skip the copy path for the rest of
> fragments.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 23704a6bc437..f014ccfdd9c2 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -413,7 +413,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  	struct virtio_vsock_pkt *pkt;
>  	int dequeued_len = 0;
>  	size_t user_buf_len = msg_data_left(msg);
> -	bool copy_failed = false;
>  	bool msg_ready = false;
>  
>  	spin_lock_bh(&vvs->rx_lock);
> @@ -426,7 +425,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  	while (!msg_ready) {
>  		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
>  
> -		if (!copy_failed) {
> +		if (dequeued_len >= 0) {
>  			size_t pkt_len;
>  			size_t bytes_to_copy;
>  
> @@ -443,11 +442,9 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  
>  				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
>  				if (err) {
> -					/* Copy of message failed, set flag to skip
> -					 * copy path for rest of fragments. Rest of
> +					/* Copy of message failed. Rest of
>  					 * fragments will be freed without copy.
>  					 */
> -					copy_failed = true;
>  					dequeued_len = err;
>  				} else {
>  					user_buf_len -= bytes_to_copy;
LGTM
