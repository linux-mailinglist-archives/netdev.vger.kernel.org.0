Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB20B46742
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfFNSQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:16:53 -0400
Received: from durin.narfation.org ([79.140.41.39]:56764 "EHLO
        durin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfFNSQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:16:52 -0400
Received: from sven-edge.localnet (unknown [IPv6:2a00:1ca0:1480:f1fc::4065])
        by durin.narfation.org (Postfix) with ESMTPSA id E74BA1100D8;
        Fri, 14 Jun 2019 20:16:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1560536209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5G3VkvtYPSsd+sdBGqxQzxBtZnfYQhWTNcGK4IIYS8=;
        b=zvCw443YHixYI2GKxeo/ICf1shdEkrszewwJ0wQy3MqMj1G9sxtxqBFPejf3Zn/SBlD+l/
        mHwB+8E3jXVso9VhPzRNT8BT+3ywOBAYjFqDtQSexdv/bm+qQU0IXQwXKFRcckoGrvJEYP
        IcDTZrkZJSgy1igPvATIwRb4ODkuMtk=
From:   Sven Eckelmann <sven@narfation.org>
To:     b.a.t.m.a.n@lists.open-mesh.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] batman-adv: no need to check return value of debugfs_create functions
Date:   Fri, 14 Jun 2019 20:16:45 +0200
Message-ID: <2060405.LLBHa7GSGR@sven-edge>
In-Reply-To: <20190614071123.GA2922@kroah.com>
References: <20190614071123.GA2922@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3167038.yAbhmPq4Nh"; micalg="pgp-sha512"; protocol="application/pgp-signature"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1560536210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F5G3VkvtYPSsd+sdBGqxQzxBtZnfYQhWTNcGK4IIYS8=;
        b=IUKsaa8h0XvjmNwOTlHd54p6mqdKbV6MR6busA426ZPhcqPgbJPlafdmDJCi58kqHuKKh2
        eXkr8RX+2pznCLr3Q0lUqZAtZa2oGQ7w5XATC7fa7sf8iA1UH6Kmn6atXDI1VzilPv0JHT
        eufwiCL5/EwAJ9UoD6NQBJnCB1jBh3I=
ARC-Seal: i=1; s=20121; d=narfation.org; t=1560536210; a=rsa-sha256;
        cv=none;
        b=KWGS03Lwgp4oVX5sRdlKZ9YNpyo+amhy4sBvnuhZRNql23tsjT3Oz28EQo0HKVnJbe3xkm
        JOg7oBpZZvktD4UPdyVT0K9LFsbCcfPot6E4+io75wFX/PH+ynfZL0I9jdvtdQqIWdR4Oy
        XNf3qp1fEuNVK1win6TiaoP8KmKiHrU=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=sven smtp.mailfrom=sven@narfation.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3167038.yAbhmPq4Nh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, 14 June 2019 09:11:23 CEST Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Because we don't care if debugfs works or not, this trickles back a bit
> so we can clean things up by making some functions return void instead
> of an error value that is never going to fail.
> 
> Cc: Marek Lindner <mareklindner@neomailbox.ch>
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: Antonio Quartulli <a@unstable.cc>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Applied with minor modifications


>  /**
> @@ -333,42 +315,24 @@ void batadv_debugfs_destroy(void)
>   * batadv_debugfs_add_hardif() - creates the base directory for a hard interface
>   *  in debugfs.
>   * @hard_iface: hard interface which should be added.
> - *
> - * Return: 0 on success or negative error number in case of failure
>   */
> -int batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
> +void batadv_debugfs_add_hardif(struct batadv_hard_iface *hard_iface)
>  {
>  	struct net *net = dev_net(hard_iface->net_dev);
>  	struct batadv_debuginfo **bat_debug;
>  	struct dentry *file;


The file variable should be removed here (it is now unused).

> @@ -421,42 +382,28 @@ int batadv_debugfs_add_meshif(struct net_device *dev)
>         struct net *net = dev_net(dev);
>         struct dentry *file;


Same here

> --- a/net/batman-adv/log.c
> +++ b/net/batman-adv/log.c
> @@ -192,25 +192,16 @@ int batadv_debug_log_setup(struct batadv_priv *bat_priv)
>  {
>         struct dentry *d;

Same here

Thanks,
	Sven
--nextPart3167038.yAbhmPq4Nh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl0D5I0ACgkQXYcKB8Em
e0YXEhAAp0mV/u+w8uWC64czNeI7fb0U7mUY4n9g5uPWtnrRO7CMZv7y5Xvo2hUM
1oDKB8sP6vdP5QnKKMqBH7UDctB+YqsqzM8Fel3yjnVjaKtdftQMXc+pTgT4zflI
1IW4XWa8OfNlr7km5wRwnTM4cZtVpdV7mtuOtc2+QHKKjtqRjsElrdIw0HeRXX3u
vhdNGFRgFjW2ihYGrgFH1ZFBXU8Onx2bbZl8wc6M+BHLO/etbd87HlCNeAeEdjPd
/UIEvPGF4iI3IsKbt4yimXTn6kqA9q6VG+DkBLVwcLDTixEgYtt7rYWBAq9haSud
0yeltXJ1eeWSG392LVPp8+8ZCEKOTsbclSDYtQUEiJZLhPuTWy7brkbbgnU0aiBd
mfjVDZ7lyTWoM0jtahUDa5zezq+5aG8+80ZLZ+6Vcg0qln8dNT7cN00wSRX3C4Zc
A21eMvDx3YqpNC4svA3/ZIw1RnBea77F4xgZ/JXismLIwm4XbukoGgP9J2F4LK4G
U3wV5ea8IHLi2+Su0UKuGNg9QpgjHW5WwyJ2E7GoRug1t5f/jwDp0f1p3t1dGSuo
MwS+H2eWsD9BJdw6xc/c7uXbp8L1abE001aroi3zzLvUw0iUbfcbHOUVr1FvTfJr
i5Qy8gO9WgyOYhYpR1r5to92QuueKH/BQh53xVYKT/uMZNcZW0E=
=9ifG
-----END PGP SIGNATURE-----

--nextPart3167038.yAbhmPq4Nh--



