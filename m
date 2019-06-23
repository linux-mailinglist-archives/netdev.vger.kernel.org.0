Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBAE4FC0B
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 16:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfFWO2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 10:28:53 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:40821 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFWO2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 10:28:52 -0400
Received: by mail-io1-f53.google.com with SMTP id n5so29017ioc.7
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 07:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZlYOdbh3obmv/vot/lTaBm3w3sBF7C2tNSrHrsQImvs=;
        b=m7ZVGhbaUt8qL+1F41y0cBzSyuIzVwSHVW0DMcKdie/dRasv704BZPBKmDoUnA06YU
         op/aFF5+1hthCYKeD4/jzIRmRGO4WzQGzPSa5At02S7Ub2C/dkO/6ZXF4fwbDLpk28Mi
         2A4GTssyo/RUJCJtKdInuiEgPL5LZZjMUtKrZYf3dTRzfkFD91P9/senEFUwcc1RyR03
         QStUjTEy0j/q8/23YNzHnfz3n75mX7zzZwuygou8qawiPpwKAvDGht2gJHNGvUdtOLWs
         N4Bmh2JsqjSNvpchrrg9dnKfrl7UnEBsoFtZGvUxK4cj//agRnmRonAzCH1shDdGd2ln
         XHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZlYOdbh3obmv/vot/lTaBm3w3sBF7C2tNSrHrsQImvs=;
        b=n/4LOmYZd4QUgNwoIdL9mTyoYq/BC07KbOn8gicbvxeN8Yu0b13WafTkb1HtMJirvR
         Hm/DfpmL666CMSJQWmUogZ4+bYMhA1Kbg3BzsWCkz2/9RwH2QMsqgfm5qFHGtjhspOQX
         O/dfrIhCj7WLIsyVocdU+oky8vIvQgNuyKiBS5ucJkf8UwlXu40JRRvGLH/8FjYXib7E
         duc2kiN+XJ58Usw/QWU6V5+PBDAsvrG+jNC2GoS65w2ircUpE3NfAhpn6ecrPN990PPw
         IOfI/zleP8md5gF4Fl4/oAO69VqbrQXoAWaJYn3jA7AE5tSzLqZfOtVn7ZP0spENK9G7
         8zfA==
X-Gm-Message-State: APjAAAWUs2agBuLZtvj0u3N8oSojc8mbGTF/5NXYBgGrzpYxdXEJeFih
        sIvaUbzVKz+wIQbIHdqxV74=
X-Google-Smtp-Source: APXvYqxKj3cfTpbh+OZbeoBaS64voZCYgG+9nO6+MqkKPtPwTI6VUuGe9NZrHtjknQLSUaPgcKfQvg==
X-Received: by 2002:a6b:da01:: with SMTP id x1mr37655361iob.216.1561300132039;
        Sun, 23 Jun 2019 07:28:52 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:28be:db34:c214:b74a? ([2601:284:8200:5cfb:28be:db34:c214:b74a])
        by smtp.googlemail.com with ESMTPSA id a2sm8076701iod.57.2019.06.23.07.28.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 07:28:51 -0700 (PDT)
Subject: Re: [RFC V1 net-next 1/1] net: ena: implement XDP drop support
To:     sameehj@amazon.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, akiyano@amazon.com
References: <20190623070649.18447-1-sameehj@amazon.com>
 <20190623070649.18447-2-sameehj@amazon.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c6bfd84e-6c40-ba86-0f3d-7efe10e0cab2@gmail.com>
Date:   Sun, 23 Jun 2019 08:28:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190623070649.18447-2-sameehj@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/19 1:06 AM, sameehj@amazon.com wrote:
> +static int ena_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *old_bpf_prog;
> +	int i;
> +
> +	if (ena_xdp_allowed(adapter)) {
> +		old_bpf_prog = xchg(&adapter->xdp_bpf_prog, prog);
> +
> +		for (i = 0; i < adapter->num_queues; i++)
> +			xchg(&adapter->rx_ring[i].xdp_bpf_prog, prog);
> +
> +		if (old_bpf_prog)
> +			bpf_prog_put(old_bpf_prog);
> +
> +	} else {
> +		netif_err(adapter, drv, adapter->netdev, "Failed to set xdp program, the current MTU (%d) is larger than the maximal allowed MTU (%lu) while xdp is on",
> +			  netdev->mtu, ENA_XDP_MAX_MTU);
> +		return -EFAULT;

unfortunate that extack has not been plumbed to ndo_bpf handler so that
message is passed to the user.

And EFAULT seems like the wrong return code.


> +	}
> +
> +	return 0;
> +}
> +
> +/* This is the main xdp callback, it's used by the kernel to set/unset the xdp
> + * program as well as to query the current xdp program id.
> + */
> +static int ena_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return ena_xdp_set(netdev, bpf->prog);
> +	case XDP_QUERY_PROG:
> +		bpf->prog_id = adapter->xdp_bpf_prog ?
> +			adapter->xdp_bpf_prog->aux->id : 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int ena_change_mtu(struct net_device *dev, int new_mtu)
>  {
>  	struct ena_adapter *adapter = netdev_priv(dev);
>  	int ret;
>  
> +	if (new_mtu > ENA_XDP_MAX_MTU && ena_xdp_present(adapter)) {
> +		netif_err(adapter, drv, dev,
> +			  "Requested MTU value is not valid while xdp is enabled new_mtu: %d max mtu: %lu min mtu: %d\n",
> +			  new_mtu, ENA_XDP_MAX_MTU, ENA_MIN_MTU);
> +		return -EINVAL;
> +	}

If you manage dev->max_mtu as an XDP program is installed / removed this
check is not needed. Instead it is handled by the core change_mtu logic
and has better user semanitcs: link list shows the new MTU and trying to
change it above the new max a message is sent to the user as opposed to
kernel log.

>  	ret = ena_com_set_dev_mtu(adapter->ena_dev, new_mtu);
>  	if (!ret) {
>  		netif_dbg(adapter, drv, dev, "set MTU to %d\n", new_mtu);

