Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7B4DA31A
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbfJQB1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:27:00 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44718 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbfJQB1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:27:00 -0400
Received: by mail-lf1-f65.google.com with SMTP id q12so434137lfc.11
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dXwGHNG0PMfzjMwCwhbxZZSodtXhVF8HfPNnchSkh3M=;
        b=RaZets2WCBFmNZCMpxhatC5XYP/5d2MpB2lloe/eQpOK0OPvnFZcXVjtgAAYORUR64
         Zyan8QYBoq8BnBp4mVbYGAVht3L7S7qKM0uVhuKI3X/e/qeRTar2PJQiJ3nPsR0A8rf/
         61ncx8Agnl8kVHjkQKWr7n3dTguu3VgAzwbmCfkrGKvlrxRGHB3awAS94cggbkEYeC7u
         l8yMy810E2BdZDvlxOTta5Bgj3AvmIPXv711Kr9ZUIvFqNqH8l5udnBC+9mJ4KB1gKRg
         +Bp3lpagKgsVTI6esj9YN8gygq/LbqlfDzmrE9pEQf4y34C1m7BHnY3Pm91kJk64E8dx
         OuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dXwGHNG0PMfzjMwCwhbxZZSodtXhVF8HfPNnchSkh3M=;
        b=enaj65VFT3VpG9TRneB9vulZv9cEKMQekVxymBssk7IJDj2lD83Ci1a1fpTLeYtf2p
         PlP/IfxpKhVTF36dXxQ5P8MjeQmNdd0Uiv1afCaSAPC7oKCO1xkVIaMKA9Etz+jN0w1I
         pjp9412EvTa/fTCkCgzUEuuU4O+LZ3W7hzX/eSZsINa8xQREO4g/hkkWmEK1OHA2neBC
         aNGYQjb0r7XLiNvo05I4FyjOIM65Md4fikYf2cRpsuDGbaPv1LgxSm1TqeesE8N7ULRf
         udLwhhlfDaJhdu9HyV5UxezsSc7WQLm6vEuFGQDXR2vW9tC431B9LMxcdTD3xLC5N38Q
         DpTg==
X-Gm-Message-State: APjAAAUtlpVPwPxQ+MoQgFWgJ6R1Lpv96vNk9C5KzW+om/O9n3t3OVWa
        qgjFaAiCNTPCe8PNJlJQilnJtA==
X-Google-Smtp-Source: APXvYqxpKuYVWGJgqKT7x/CbbHsLauXmroxJUxpbJeYLfxCVLz41SrjivlhAxdSa3FLSKoLDv/KoxA==
X-Received: by 2002:ac2:4830:: with SMTP id 16mr419697lft.2.1571275618170;
        Wed, 16 Oct 2019 18:26:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g3sm259411lja.61.2019.10.16.18.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:26:57 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:26:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 4/7] net: mvneta: add basic XDP support
Message-ID: <20191016182650.2989ddf4@cakuba.netronome.com>
In-Reply-To: <30b6fad4fe5411e092171bb825f7a6ce0041d63e.1571258793.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
        <30b6fad4fe5411e092171bb825f7a6ce0041d63e.1571258793.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 23:03:09 +0200, Lorenzo Bianconi wrote:
> Add basic XDP support to mvneta driver for devices that rely on software
> buffer management. Currently supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT
> - XDP_ABORTED
> 
> - iptables drop:
> $iptables -t raw -I PREROUTING -p udp --dport 9 -j DROP
> $nstat -n && sleep 1 && nstat
> IpInReceives		151169		0.0
> IpExtInOctets		6953544		0.0
> IpExtInNoECTPkts	151165		0.0
> 
> - XDP_DROP via xdp1
> $./samples/bpf/xdp1 3
> proto 0:	421419 pkt/s
> proto 0:	421444 pkt/s
> proto 0:	421393 pkt/s
> proto 0:	421440 pkt/s
> proto 0:	421184 pkt/s
> 
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

> +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct mvneta_port *pp = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +
> +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (netif_running(dev))
> +		mvneta_stop(dev);

Actually if pp->prog && prog you don't have to stop/start, right?
You just gotta restart if !!pp->prog != !!prog?

> +	old_prog = xchg(&pp->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	if (netif_running(dev))
> +		return mvneta_open(dev);
> +
> +	return 0;
> +}
