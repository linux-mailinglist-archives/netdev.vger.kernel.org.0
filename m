Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC66EB54F2
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 20:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfIQSLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 14:11:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40059 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbfIQSLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 14:11:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so2423448pgj.7
        for <netdev@vger.kernel.org>; Tue, 17 Sep 2019 11:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7eMuc3DFVGqc5wIBgnpyU0/P0KHdVF14u6P2PX1Ul64=;
        b=z5+Ft6n6ABuSaQkYPk7fZaV68A9BmoGF503VR9JiuGmhx5TT61pkYojxRyTHyXgAIK
         AEsMeti3pBVoHG4tzft71gWPQBd8ooS3L1ilWbwI9fkSGcMhG19Zb8YnuJSRw1K/wCCm
         EXol5FElqpiq+e1/qBfn3BEcqRpQPzmoUvzdylVLNi6cFLt3T4N5DEEnmfT6oF8NUHUa
         UE52pbJWiQ+YHVIQwIlQe0/MBiUqsB5zlTR6AZCCatfWesGD6zLuz+HcIvpbAI8h4lfd
         +4+IJ9oErbrEt4VP0tzPnaamIU3VPjv87amm5IXs/fEj7Xnv7vOj9nIZai1j0rBsnacZ
         FANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7eMuc3DFVGqc5wIBgnpyU0/P0KHdVF14u6P2PX1Ul64=;
        b=YrIkIeQNrrOtbg8RZYe1Rth8HYi6V6jWJaySFaEnqkQa3VpVGqp91So5LipXCs7INw
         iBaTQ8/CfcvqTuY/uGL2LJHi+1jIDbsENdKuBUZLwd7A+O2UAngVWdaCEs+5BTRE7b3v
         T9krtLa7tJ8WtGnfkW2XZ5HIBd5JjbCUKTU/tKdPMVQWMUbkLbTNo+abHaYJc66TXDne
         qwPdOE1V8qLSOzQkLoLtdETb/ZDEJNwudRP1f9eq9Th1AeYWMsjgNcy3T+XGBA9voFbs
         7KC9ertdxD7Ew6HyqWcqDcflHbKyjyhfxR3yMzJ6c1JdebRAMcj4iLxv2fL4LpVG/WRy
         aheQ==
X-Gm-Message-State: APjAAAWlcOp7XXShHDT4w4BomTrpSiUGT9PamoMqj2q5MNGSacBOfEG/
        SFfOeZ5X8BdLuTKUOpoG9Tp9LXsA/AI=
X-Google-Smtp-Source: APXvYqwwLfWjlNuYTBxRz1Vvl3AXA0dIQfCn8ze4R9VpcBJIlbAqohtw1BmZ3/IMHzOywOdhjUkEcg==
X-Received: by 2002:a62:7c14:: with SMTP id x20mr5724989pfc.228.1568743870494;
        Tue, 17 Sep 2019 11:11:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i16sm1339960pfa.184.2019.09.17.11.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 11:11:10 -0700 (PDT)
Date:   Tue, 17 Sep 2019 11:11:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <anna.schumaker@netapp.com>,
        <trond.myklebust@hammerspace.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESENT PATCH v2] ixgbe: Use memzero_explicit directly in
 crypto cases
Message-ID: <20190917111107.307295c6@cakuba.netronome.com>
In-Reply-To: <1568731462-46758-1-git-send-email-zhongjiang@huawei.com>
References: <1568731462-46758-1-git-send-email-zhongjiang@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Sep 2019 22:44:22 +0800, zhong jiang wrote:
> It's better to use memzero_explicit() to replace memset() in crypto cases.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Thank you for the follow up! Your previous patch to use kzfree() 
has been applied on its own merit, could you rebase this one on top 
of current net-next/master?

> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index 31629fc..7e4f32f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -960,10 +960,10 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>  	return 0;
>  
>  err_aead:
> -	memset(xs->aead, 0, sizeof(*xs->aead));
> +	memzero_explicit(xs->aead, sizeof(*xs->aead));
>  	kfree(xs->aead);
>  err_xs:
> -	memset(xs, 0, sizeof(*xs));
> +	memzero_explicit(xs, sizeof(*xs));
>  	kfree(xs);
>  err_out:
>  	msgbuf[1] = err;
> @@ -1049,7 +1049,7 @@ int ixgbe_ipsec_vf_del_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
>  	ixgbe_ipsec_del_sa(xs);
>  
>  	/* remove the xs that was made-up in the add request */
> -	memset(xs, 0, sizeof(*xs));
> +	memzero_explicit(xs, sizeof(*xs));
>  	kfree(xs);
>  
>  	return 0;

