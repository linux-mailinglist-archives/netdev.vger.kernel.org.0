Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495F226F780
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgIRHzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 03:55:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38731 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726625AbgIRHzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 03:55:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AA355C031F;
        Fri, 18 Sep 2020 03:47:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 18 Sep 2020 03:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=7
        D2NCdie8lSKhVHC3+ynZJEVlEwnVVKdauhjkeHig+g=; b=RoJB7GWWlVnDkYt36
        NJmPkDouccbfrWbx9Y1cLUqxyF0NrzAhNaOJVCKGFI7De2bffwGuAQsgQWlv2gOG
        50T/6+256/HXYjFy5G9Vzs61LJIP5sr/CPustcLOFji4cb391WsKJTWMvQYYZrSV
        Z4TYzjcL5slnvfRGOEV8SWb7GDcSUPiAImn11ok1N9Mn+Vr1qWP8kZwCuwd/42nM
        6brMNSw4mgOckWDClYRgh8bT5WpO+fBb3tGGnTeOp1KPm9Fu471EXv8wUaVCIsLl
        NMvvLn7jTU4JxRnDaqqcYp/h+/C6iN76hK0IbZG1FQPWlkYcvvO+xr/8bL9Cq/8j
        uGBTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=7D2NCdie8lSKhVHC3+ynZJEVlEwnVVKdauhjkeHig
        +g=; b=syEKekqXl/tswfOEY1jHLeE4jKpPZApC9DS3AJUmWwUgvrJ8kxsuyJPxQ
        F459adMMg9+22ghoUJpmalgfChDgl8jC2xyvN3Tu9hEcWZEYTuLvU2kWD86H0HnA
        JK4Lzrn1uuqiOP6Nb1dNtJkWkdMiC5PbCZ0WhgVN1zU2qabOXC4VQcvQmTMqVG7b
        N/4s8ccPFATWEYX+q5/LmX/jFtvDdcMWkPH/yW+hMoTMDTdRPDDLiOsWVH47QGFo
        NW8XKM4WHoGxz2plgmBIW4gn9A7+uFMUlF4vuEG2ZYukcEDSU88SQr6pBixYqdCS
        PRJbQSdvFi04zrgbURx+jLDjFNixg==
X-ME-Sender: <xms:DWZkX1XTci81h75NQDlsVlC-mJ6kPaJgl9jIf7GAuDzMuoEeXFqZ0g>
    <xme:DWZkX1l1FC41_etlN1y57eiknaKsvSKBBb9O_bXXcA-QPIJvOS-zj6WjbRsKjTRSB
    5YSJy4sg8I9tA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdehgdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DWZkXxZFkFMyumDgWbxHeqbAhTlR6rI9qqOhypgX9RR_wLoqwLDwRQ>
    <xmx:DWZkX4WaqjvRUFGHpsiz7cJizK72BFiy25zEUe2O2NPWyr2hOUPlWQ>
    <xmx:DWZkX_kMV7PPIzxquJFRgF_roGYPlVx79ZOz9Uc_Oiv0s1rTyZkqYg>
    <xmx:DmZkX4CIkfsnfJyfjiCo5X6oJOo388mF5npPA_JwlMEUPh8VbZwVBg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3E3FF3064610;
        Fri, 18 Sep 2020 03:47:25 -0400 (EDT)
Date:   Fri, 18 Sep 2020 09:47:54 +0200
From:   Greg KH <greg@kroah.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, UNGLinuxDriver@microchip.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] rapidio: Remove set but not used variable 'rc'
Message-ID: <20200918074754.GA979569@kroah.com>
References: <20200918071844.19772-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200918071844.19772-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 03:18:44PM +0800, Zheng Yongjun wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/rapidio/rio_cm.c: In function rio_txcq_handler:
> drivers/rapidio/rio_cm.c:673:7: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]
> 
> rc is never used, so remove it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/rapidio/rio_cm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c
> index 50ec53d67a4c..545693bd86a3 100644
> --- a/drivers/rapidio/rio_cm.c
> +++ b/drivers/rapidio/rio_cm.c
> @@ -670,12 +670,11 @@ static void rio_txcq_handler(struct cm_dev *cm, int slot)
>  	 */
>  	if (!list_empty(&cm->tx_reqs) && (cm->tx_cnt < RIOCM_TX_RING_SIZE)) {
>  		struct tx_req *req, *_req;
> -		int rc;
>  
>  		list_for_each_entry_safe(req, _req, &cm->tx_reqs, node) {
>  			list_del(&req->node);
>  			cm->tx_buf[cm->tx_slot] = req->buffer;
> -			rc = rio_add_outb_message(cm->mport, req->rdev, cmbox,
> +			rio_add_outb_message(cm->mport, req->rdev, cmbox,
>  						  req->buffer, req->len);

That's not the only place in this file where this call is made, and the
return value is ignored.

It should be fixed up to properly check that return value, not ignore
it.  Can you do that instead for the places this is called?

thanks,

greg k-h
