Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06CFA5B0B2
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfF3QpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:45:18 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35396 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfF3QpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:45:18 -0400
Received: by mail-lj1-f196.google.com with SMTP id x25so10620759ljh.2
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bMkhsOU5xWUEeLSpNeMw9nnDmgTIIe5IKfbMhQ6UdE8=;
        b=MtoQSqRkW+5pUKNtfMH5HPU6reOQ7rTTkPjK2fRuOFVwgVy2G+tKbhMB861b9ylLQe
         FjEY3HnD7MUYdhTTDEajyvdFAWHfVaZKBapxcP2CKLbUzj0aQrZiZ/v72y+Q3wxPJPGQ
         1trpL3b0DvemzmbOLVkSKuotkA0/ARTf+wP1Eh9oXyLLCi9vwwtEpiCk1BblyLyQrfBi
         dlhILwYdyvjqvj//RLC/76mdbIUQyqpl35tOsX3hLbqnue8JSQ/PSqDNtk87RbyG2Zel
         UU6hZYqq8s8jJR7Sgj4eLkzZ2RGpNj3vhxmlmzyC/VIlksgTN+Upx1htjCXkt4KLFAne
         R2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bMkhsOU5xWUEeLSpNeMw9nnDmgTIIe5IKfbMhQ6UdE8=;
        b=RH9edcnQT/e6oZ6JHQpIdT8Zdm8bWa1R44eGlTw0QWEIlFaucxouekJIE8UBLYsTLa
         g7jm3kjlA1wRuUQzSiUOS7Qb4qye7b8sPvtv4q+lGjUEctY6PeKwSmLd1P0lGVRZ6oNA
         XV2Lqt9sj143NPjeIgdB6cnC9emzjyjOeUA+WoYD5lLIA6LykSP1TLvrq7wbVZrMINt7
         cp3pIGzFH8ZVeveELz+4KueC+M5r5i0a7//33wWPnd2jEunzoebSXcYtcKsLEWRFMNaC
         e75icRSENrczQvUrqRVgn8FYr9xFBcwvzkBNVI1w64Ut8IbRnlYA576v9ii4g6CU/v3S
         KoLQ==
X-Gm-Message-State: APjAAAVqslN9wED6Jw58ufLuSwv4YgV/pXr/uXIWgIwAldo+OJA6NsZs
        jsMsiginjD4AdxoaTyu3yIjAuA==
X-Google-Smtp-Source: APXvYqzVRfMdstf2iXM7821DB6FBOOYvJbbAgig1OV30ojCsPVmb2IN9hEEUrcokarog+N1GlV8uLA==
X-Received: by 2002:a2e:91c5:: with SMTP id u5mr11679922ljg.65.1561913116196;
        Sun, 30 Jun 2019 09:45:16 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id t15sm2095363lff.94.2019.06.30.09.45.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 30 Jun 2019 09:45:15 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:45:13 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630164512.GD12704@khorivan>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162042.GA12704@khorivan>
 <20190630163417.GB10484@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190630163417.GB10484@apalos>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:34:17PM +0300, Ilias Apalodimas wrote:
>Hi Ivan,
>>
>> [...]
>>
>> >+
>> >+static int netsec_xdp(struct net_device *ndev, struct netdev_bpf *xdp)
>> >+{
>> >+	struct netsec_priv *priv = netdev_priv(ndev);
>> >+
>> >+	switch (xdp->command) {
>> >+	case XDP_SETUP_PROG:
>> >+		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
>> >+	case XDP_QUERY_PROG:
>> >+		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
>> xdp_attachment family to save bpf flags?
>Sure why not. This can always be added later though since many drivers are
>already doing it similarly no?
yes.
I can work w/o this ofc.
But netronome and cpsw (me) added this.
What I've seen it allows to prevent prog update if flag doesn't allow it.
Usually it doesn't allow, but can be forced with flag. In another case it can
be updated any time w/o reason...and seems like in your case it's sensitive.

>
>>
>> >+		return 0;
>> >+	default:
>> >+		return -EINVAL;
>> >+	}
>> >+}
>> >+
>> >static const struct net_device_ops netsec_netdev_ops = {
>> >	.ndo_init		= netsec_netdev_init,
>> >	.ndo_uninit		= netsec_netdev_uninit,
>> >@@ -1537,6 +1842,8 @@ static const struct net_device_ops netsec_netdev_ops = {
>> >	.ndo_set_mac_address    = eth_mac_addr,
>> >	.ndo_validate_addr	= eth_validate_addr,
>> >	.ndo_do_ioctl		= netsec_netdev_ioctl,
>> >+	.ndo_xdp_xmit		= netsec_xdp_xmit,
>> >+	.ndo_bpf		= netsec_xdp,
>> >};
>> >
>> >static int netsec_of_probe(struct platform_device *pdev,
>> >--
>> >2.20.1
>> >
>>
>> --
>> Regards,
>> Ivan Khoronzhuk
>
>Thanks
>/Ilias

-- 
Regards,
Ivan Khoronzhuk
