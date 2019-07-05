Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452C960BD8
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfGETn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:43:56 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:32889 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGETn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:43:56 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so8733028qkc.0
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 12:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ICDqm+cUkNiJav9ud7bm9rjg4/sfFiPyh7oJ8ejll/s=;
        b=GiDKjoZEsKl5OdjTWI0gAqbZyT/g1ih/Yg8et4vQYJsyoTPkXvGHuKmkRCChw1j/O+
         Aei1+WkzVLg6MH62HflZSSYtHjvkUUBFrMwhInv14ciEZjzJVg8N2fAzUT5aRRoqtw5L
         HSpLzABGENH5znwij1K4KsaNQTDZg4FOPBd0Hgtbtq2pfgxFJXrqU0RwmSsNX3lKTy3D
         Z+SCFZmdGZLltLaP3wT+CccPLmXF06danQjKLFcXZlzNPfDdNSCbNeA2Dz2npyx1bvqs
         az/CA30+FgueyrRv7fB3jL2u+6VE4fLM+rY7yXCy9pjiZ5/182ZCF2p6OP602b/jddVJ
         3j8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ICDqm+cUkNiJav9ud7bm9rjg4/sfFiPyh7oJ8ejll/s=;
        b=R9VWV+nIWEcQxF0/ZxbGm5RdXx2egLd0BME+Wbw+juzTNRI6gOzRFYYOCmZgpFWsSa
         JEzwEMbovn8T/TMR0XyChTTyXKjfaW+KLe36npAlK+X21QfEuLViKQiomJy+zFQmTA28
         AxrOfkOeOBLAPC9fFoRWhimODMOXgqKSRASktSfstSHk8Jnxh3infBhsnkGrQt+xj76F
         Tgg+N/VlKo6ukS1C5/iw0A3MkL1JRhw9zDnnqJgGa9mjZtAx10eylwzSBX6pbSUiE82T
         /be/qIfWQyAFF/mmlH2i8AWZO49PZW45UvMH8nh7Tzqh8f6HC1dHAdiQP8HOSE9RpsoL
         lu7A==
X-Gm-Message-State: APjAAAXKqReUUG4fsgeh+WfEv8cDhmGeq9b15Mr75eO2MFn0PwZ8m/f0
        ouVgwALJ2+yFtZQzlPem/zXNTA==
X-Google-Smtp-Source: APXvYqxyBpFijzDCSmFhTI+FANtP4Ndg3T6x4iZFGo1h1eGTEcyseln0sDkBeBn30nz4upC5EpkaFQ==
X-Received: by 2002:a37:4c92:: with SMTP id z140mr4480202qka.245.1562355835173;
        Fri, 05 Jul 2019 12:43:55 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f20sm3832319qkh.15.2019.07.05.12.43.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 12:43:55 -0700 (PDT)
Date:   Fri, 5 Jul 2019 12:43:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Message-ID: <20190705124351.4abfc7f3@cakuba.netronome.com>
In-Reply-To: <079d4170-d591-18c6-572e-dbec428f169e@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
        <20190704181235.8966-15-saeedm@mellanox.com>
        <20190704131237.239bfa56@cakuba.netronome.com>
        <079d4170-d591-18c6-572e-dbec428f169e@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Jul 2019 14:31:29 +0000, Tariq Toukan wrote:
> On 7/4/2019 11:12 PM, Jakub Kicinski wrote:
> > On Thu, 4 Jul 2019 18:16:15 +0000, Saeed Mahameed wrote:  
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> >> index 483d321d2151..6854f132d505 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> >> @@ -50,6 +50,15 @@ static const struct counter_desc sw_stats_desc[] = {
> >>   #ifdef CONFIG_MLX5_EN_TLS
> >>   	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
> >>   	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
> >> +
> >> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo) },  
> > 
> > Why do you call this stat tx_ktls_ooo, and not tx_tls_ooo (extra 'k')?
> > 
> > For nfp I used the stats' names from mlx5 FPGA to make sure we are all
> > consistent.  I've added them to the tls-offload.rst doc and Boris has
> > reviewed it.
> > 
> >   * ``rx_tls_decrypted`` - number of successfully decrypted TLS segments
> >   * ``tx_tls_encrypted`` - number of in-order TLS segments passed to device
> >     for encryption
> >   * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
> >     but did not arrive in the expected order
> >   * ``tx_tls_drop_no_sync_data`` - number of TX packets dropped because
> >     they arrived out of order and associated record could not be found
> > 
> > Why can't you use the same names for the stats as you used for your mlx5
> > FPGA?
> >   
> 
> Agree. Fixing.
> 
> What about having stats both for packets and bytes?
> tx_tls_encrypted_packets
> tx_tls_encrypted_bytes

Makes sense, I wasn't sure we want too many counters on the fastpath,
therefore I had no bytes counter. Renaming rx_tls_decrypted and
tx_tls_encrypted sounds like a good idea, though! We only have them in
the nfp, and there wasn't any kernel released with nfp TLS offload,
yet, so we can adjust.

Perhaps we should also make it clear in the doc that those counters
count "packets"/bytes on the wire, while the other counters count the
number of skbs, which may be TSO?

Would you be able to make those adjustments if you agree?
