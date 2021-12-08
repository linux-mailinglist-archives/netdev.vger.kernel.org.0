Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC91A46D5E7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhLHOmk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Dec 2021 09:42:40 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38934 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhLHOmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:42:39 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id DAF2ACED27;
        Wed,  8 Dec 2021 15:39:05 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH net-next] net: bluetooth: clean up harmless false
 expression
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211208024732.142541-4-sakiwit@gmail.com>
Date:   Wed, 8 Dec 2021 15:39:05 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0A76D564-1A23-4FCE-BA8D-578C161475BF@holtmann.org>
References: <20211208024732.142541-4-sakiwit@gmail.com>
To:     =?utf-8?Q?J=CE=B5an_Sacren?= <sakiwit@gmail.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jean,

> scid is u16 with a range from 0x0000 to 0xffff.  L2CAP_CID_DYN_END is
> 0xffff.  We should drop the false check of (scid > L2CAP_CID_DYN_END).
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
> net/bluetooth/l2cap_core.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 4f8f37599962..fe5f455646f6 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4118,7 +4118,7 @@ static struct l2cap_chan *l2cap_connect(struct l2cap_conn *conn,
> 	result = L2CAP_CR_NO_MEM;
> 
> 	/* Check for valid dynamic CID range (as per Erratum 3253) */
> -	if (scid < L2CAP_CID_DYN_START || scid > L2CAP_CID_DYN_END) {
> +	if (scid < L2CAP_CID_DYN_START) {
> 		result = L2CAP_CR_INVALID_SCID;
> 		goto response;
> 	}

so I realize that this might be a pointless check, but I rather keep it. It
really doesn’t do any harm.

Regards

Marcel

