Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF35FDD9
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfGDUpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:45:43 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:41146 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfGDUpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:45:43 -0400
Received: by mail-pg1-f177.google.com with SMTP id q4so3308492pgj.8
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MTgTlD8QEypzUWrPqNXqRD/a6x1r6KEwC+90EfktXSE=;
        b=elJE7dy5KlaY/xEWONZ3nbuXz4GdNhvu8LFkRMecdQWHEeyoDAE/xlUyoAAeiVhOPI
         kphoy8ZY5uw5yVgsEl3S2Y0X7XudEaK6I2gRZi8gcNtywJqLsMDmSEy4I0R4O76mww+S
         0XLI0dQ2dvvO3GsuA0fmsQws9i8YpwJFHYCP0mqSeWorxJTCkc1GQ8WgkWwgGBVtHeum
         wE8s5mJwGfiXI3Rj9d/DzpvdrHojzFgZqoYtj5ouexL6IA0HjEQ0lenzvQxOKS/n3Q1G
         0GVXmprnRdlUOw3tTQZhCyHqQoiIoxVp5jYlIgw08ehecNwi+wrsV3yZEoBd/ejYxN2e
         Q4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MTgTlD8QEypzUWrPqNXqRD/a6x1r6KEwC+90EfktXSE=;
        b=OV5UA/Mo6nhBsJSe4jrKaKESp+3QUgCjaakUvWGxykKh/Wiob2y22dz1Rg+Qu8Cv/L
         5b1YdRKSUrH0rGsmdXRhksaK3xKl5V0XviN/U000MP8NlPpgkzJYZkSpm7U5LT9Ye6BB
         rLgiTsDgcJBOJ6hC08rpGH5xe+mt7axVg/3Ms2tec5Vg46yB2gVtR6N9bn31AfZuST1/
         zZOjlQOu6WKyuuXLDeQDdbsaGGx4WpFQjUs5v6586boUCSnquWxoYFrT99kzNWZZlSPr
         /XbXxQZkvi2iZ0ShkW9uww1kA08G4nRR4uFbt+3wmByQb+ZixSqtrx6FrW6g4aCLb3pN
         fgig==
X-Gm-Message-State: APjAAAV7BjGjifRNEqqnzfjETYSThi0TUwme1eIVZQP0fYUtcIWkB2mq
        lUUsNx5lzEfNfqjG7pdQLqdrIw==
X-Google-Smtp-Source: APXvYqza/Rs7lHZ3cdkc5hvObKfzlqktja1FkctgCNJpuLzL//yY0OxGFnivaUjsL7jlTZIwHhHTOQ==
X-Received: by 2002:a17:90a:4f0e:: with SMTP id p14mr1484710pjh.40.1562273142208;
        Thu, 04 Jul 2019 13:45:42 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id q10sm5645314pgg.35.2019.07.04.13.45.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 13:45:42 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:45:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Message-ID: <20190704134533.12cc6166@cakuba.netronome.com>
In-Reply-To: <CALzJLG_qF=Yv58_EpV0bRm8_=Kn2AtsOywDDMjhwxSUOW44EAQ@mail.gmail.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
        <20190704181235.8966-15-saeedm@mellanox.com>
        <20190704131237.239bfa56@cakuba.netronome.com>
        <CALzJLG_qF=Yv58_EpV0bRm8_=Kn2AtsOywDDMjhwxSUOW44EAQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 16:30:21 -0400, Saeed Mahameed wrote:
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_no_sync_data) },
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_bypass_req) },
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_bytes) },
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_packets) },
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_packets) },
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_bytes) },
> > > +     { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ctx) },
> > >  #endif
> > >
> > >       { MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },  
> >
> > Dave, please don't apply this, I will review in depth once I get
> > through the earlier 200 emails ;)  
> 
> Jakub can you please expedite ?

Sure thing!  Looking now..

> Dave if it is ok with you i will re-spin and push a  new pull request
> with  mlx5-next dependencies + 2 Devlink fw version patches,
> and independently, i will post the TLS series for Jakub to review ?
