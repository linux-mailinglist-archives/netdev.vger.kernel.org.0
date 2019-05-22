Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31082715E
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 23:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbfEVVHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 17:07:14 -0400
Received: from kadath.azazel.net ([81.187.231.250]:39524 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfEVVHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 17:07:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=loyIBpCBpYjNx+PxzllKAJdf5BD1L45wLQdGNF1bsPk=; b=RbyyoXlrLzJzaN58+An3fib+EL
        SoJLfKzIZZreHScXXjatp1Hv1Yv/lK+ZSwYRPIfgJEnx3ui8+eJxyGSBjZLLbsWBHK6gIhemO8q1L
        NNOzGo2iIxRgigLYTXAYWpgWMpJaSJ8JHC6von5zEjO0aMY+Yjjkx401GHBneApJbFKHGvPXsWeK0
        ReGO91uuf4mBmbaykOxK8EKxb8fUn+I8v/+6Dpzasjpo/MCR3rlvp7M2xaR3kYhPZqm5dZNGMQnNw
        VRldaB0GQ1cyKzdi/s0C/LBfhMSwnk8ho8OtO2iz1uNz3kTkBR5n7RmY+ukch0W5zrfek6EJFQhjr
        f2Z8Bp0w==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hTYRz-0000GD-TZ; Wed, 22 May 2019 22:07:03 +0100
Date:   Wed, 22 May 2019 22:07:02 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jason Baron <jbaron@akamai.com>
Cc:     davem@davemloft.net, edumazet@google.com, ycheng@google.com,
        ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: Re: [PATCH net-next 5/6] Documentation: ip-sysctl.txt: Document
 tcp_fastopen_key
Message-ID: <20190522210702.GA28231@azazel.net>
References: <cover.1558557001.git.jbaron@akamai.com>
 <aa4defa5f0f75908b140855e4495388468a94c01.1558557001.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <aa4defa5f0f75908b140855e4495388468a94c01.1558557001.git.jbaron@akamai.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-05-22, at 16:39:37 -0400, Jason Baron wrote:
> Add docs for /proc/sys/net/ipv4/tcp_fastopen_key
>
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> Signed-off-by: Jason Baron <jbaron@akamai.com>
> ---
>  Documentation/networking/ip-sysctl.txt | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 14fe930..e8d848e 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -648,6 +648,26 @@ tcp_fastopen_blackhole_timeout_sec - INTEGER
>  	0 to disable the blackhole detection.
>  	By default, it is set to 1hr.
>
> +tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
> +	The list consists of a primary key and an optional backup key. The
> +	primary key is used for both creating and validating cookies, while the
> +	optional backup key is only used for validating cookies. The purpose of
> +	the backup key is to maximize TFO validation when keys are rotated.
> +
> +	A randomly chosen primary key may be configured by the kernel if
> +	the tcp_fastopen sysctl is set to 0x400 (see above), or if the
> +	TCP_FASTOPEN setsockopt() optname is set and a key has not been
> +	previously configured via sysctl. If keys are configured via
> +	setsockopt() by using the TCP_FASTOPEN_KEY optname, then those
> +	per-socket keys will be used instead of any keys that are specified via
> +	sysctl.
> +
> +	A key is specified as 4 8-digit hexadecimal integers which are separted

"separated"

> +	by a '-' as: xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx. Leading zeros may be
> +	omitted. A primary and a backup key may be specified by separting them
> +	by a comma. If only one key is specified, it becomes the primary key and
> +	any previous backup keys are removed.
> +
>  tcp_syn_retries - INTEGER
>  	Number of times initial SYNs for an active TCP connection attempt
>  	will be retransmitted. Should not be higher than 127. Default value
> --
> 2.7.4
>
>

J.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAlzlue0ACgkQ0Z7UzfnX
9sOR+g/+M2NAgCva0b/E5h5qJ1wj1yeVHENtf/wGSSFd3JEJV06KxsOo3O2Wje//
bVsLmsENcbymAO9MRWK5u9eXfQyoe7uFwBXen3upuo12gNgo3iYD9pzeE1r3FatC
vqnJ+MUY5F0kPG4lAPFPbpyWBGt2LJOpcf6Z3gdd9phV8C/d7hwy1uikA9eFX9DJ
83jWFrjgHgA3A3oZ2H1ci3+z9YVMcZO+TU8D/rymNiXw1xOZKp2Q5Iu96HjRP29e
SbQgNV3yqCGjKP+7VqzljhwLoqW8y5lEN9ZU/YO0WcP2IMadfzerbc/jLGdWLJot
Tf9iJj0fD5Ghm/R/V/2HMv0BY8pBmwdSKe2ZDAkfeDNDdL4205QN9VVoYNOc6h5a
yxPK/DJOxRafrzAK1glti8EsKDHEMrMVgozPUDkNNSmEN+1f94GSIu+iWvE+XDjg
GBSe+XiVZZbJwNMUCXF7+Hir1MKeFwlUQqGCGM1P31/4danw08GXX4P3ldsa62HK
qt8IxLbkPv7ZxC5IyCDT8zLWMpxlhfAiwXalzFfXXLoRBp52U8MddO8aExo/9I0z
3UA1R8iiwfBhY+TtyWhZRM4pwUsuPzgrPF8jIMxiDZNnnL70w20QBgICma0CplSD
5o8PgWvJx//SZeW8L6E89vd7CeuwvoVoS0o3lfX1Jwsg0QQKESI=
=OwJJ
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
