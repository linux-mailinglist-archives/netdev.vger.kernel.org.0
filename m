Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132811E8893
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgE2UJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbgE2UJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:09:14 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2739A2074D;
        Fri, 29 May 2020 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590782954;
        bh=0gbYham9OiBOiDErQiKZY2IiVzbjduZmK9wbI2JouTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJ5oAf6pcfsZcD6FZmfoofYLJRpzIgWzDsf/Ikg7XPFnW0xJaNQ4+TF6uV+hMaMwI
         jelMlrR4gUfIXbNLti/kdN2MUyzMMWvYzkk+ZeLkI2oJENVUWVFTfkz8I6jfj/oyhl
         dlvyq++lNqtPfLMDW2Vf8hvtnswiqPx1bzd8P208=
Date:   Fri, 29 May 2020 13:09:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 09/11] net/mlx5e: kTLS, Add kTLS RX stats
Message-ID: <20200529130912.4da4f596@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529194641.243989-10-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
        <20200529194641.243989-10-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 12:46:39 -0700 Saeed Mahameed wrote:
> diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
> index f914e81fd3a64..44c4b19647746 100644
> --- a/Documentation/networking/tls-offload.rst
> +++ b/Documentation/networking/tls-offload.rst
> @@ -428,6 +428,14 @@ by the driver:
>     which were part of a TLS stream.
>   * ``rx_tls_decrypted_bytes`` - number of TLS payload bytes in RX packets
>     which were successfully decrypted.
> + * ``rx_tls_ctx`` - number of TLS RX HW offload contexts added to device for
> +   decryption.
> + * ``rx_tls_ooo`` - number of RX packets which were part of a TLS stream
> +   but did not arrive in the expected order and triggered the resync procedure.
> + * ``rx_tls_del`` - number of TLS RX HW offload contexts deleted from device
> +   (connection has finished).
> + * ``rx_tls_err`` - number of RX packets which were part of a TLS stream
> +   but were not decrypted due to unexpected error in the state machine.
>   * ``tx_tls_encrypted_packets`` - number of TX packets passed to the device
>     for encryption of their TLS payload.
>   * ``tx_tls_encrypted_bytes`` - number of TLS payload bytes in TX packets

Stack already has stats for some of these in /proc/net/tls_stat. 
Does this really need to be per device?
