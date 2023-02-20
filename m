Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF0669D3F7
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 20:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjBTTPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 14:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbjBTTPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 14:15:07 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C1830DA;
        Mon, 20 Feb 2023 11:14:39 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o4so2245072wrs.4;
        Mon, 20 Feb 2023 11:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=h2G8MngECsHzRoNNMvCe3AyTwuYcmDjYyCf7cYz5mro=;
        b=FiH+g/c3F+TK9/pTSWbaazdl0EjMRu4oWLJHOIVeiv8dixCeIrKhAeWTJH8ShXE6W2
         dPZLbuYov5gRflXDGfvx5xOBFVehL/BZ1N8PGZeqxDMEsfy+qAAOHCMxP7wXgsfkASND
         ul34d0snmd6kUn1Ekr1FTh8Dv/qEWqgAGcZYSR6RNXqdRG6iNnVgXL5xpUXXkmMdBa96
         TTE7Oq7KR7qB6n4DZGP2pEMcIDPX9599JYpREADFnD+1EG8QOj+fXVUueBNM7pHmzPxn
         gerWkPpuvWNu6gIU6eYgwy74TJ/Nu74KuQ45ZYTuV4cWaMtAaeekllkzoTFr6kh5g2kP
         628g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2G8MngECsHzRoNNMvCe3AyTwuYcmDjYyCf7cYz5mro=;
        b=pOYg63XlqmQ3Li4RGtw0d/ShFVNTk+I0tTSi6mpNEMZTln01vq3unBsksJpy8Sdw2e
         8RTrdl7mPROuQdCaq1zmxlVAV4qSx6Pby17Fk8E412uY5udt7K3G8yc9L1B5GLoRkyci
         mVr13z/24+PkJxU7tQ248TK3pnKJaNENEqn5mwygaRs1aqXKbsDN3RYzP3R11RetA1f0
         CqN7oqRmBnVg5aG6thaLtMYl3IzS/o47nPCvILorb6rS5/Em/p2KJagkbR/X0RbF6GNF
         LAF7pVqPl6aiCh89zCewM8wuCFXWZwKWMrdgBpmHhkW+rfKOVlRqLzEegcReYn1OkXPv
         PFAw==
X-Gm-Message-State: AO0yUKV3a3cmqybmpnnMegSPjTejA+Y9KLM7NXlw41RYP1kI6pw8ROha
        OnLhcDoCB5pxl9cSPaFj9Uk=
X-Google-Smtp-Source: AK7set988zUOPEqn4TkVkaUYPoBvug/eErlH7rGdBRWRxec5NZOC/O83RWRup2dzm+rGJooePAO5ZQ==
X-Received: by 2002:a5d:5306:0:b0:2c5:62c8:5f43 with SMTP id e6-20020a5d5306000000b002c562c85f43mr262102wrv.29.1676920472224;
        Mon, 20 Feb 2023 11:14:32 -0800 (PST)
Received: from Ansuel-xps. (93-34-91-73.ip49.fastwebnet.it. [93.34.91.73])
        by smtp.gmail.com with ESMTPSA id p14-20020a5d4e0e000000b002c5a790e959sm4921331wrt.19.2023.02.20.11.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 11:14:31 -0800 (PST)
Message-ID: <63f3c697.5d0a0220.8f9f5.c859@mx.google.com>
X-Google-Original-Message-ID: <Y/N6yWyzhc12zhvD@Ansuel-xps.>
Date:   Mon, 20 Feb 2023 14:51:05 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] wifi: ath11k: fix SAC bug on peer addition with sta band
 migration
References: <20230209222622.1751-1-ansuelsmth@gmail.com>
 <167688346963.21606.5485334408823363188.kvalo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167688346963.21606.5485334408823363188.kvalo@kernel.org>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 08:57:51AM +0000, Kalle Valo wrote:
> Christian Marangi <ansuelsmth@gmail.com> wrote:
> 
> > Fix sleep in atomic context warning detected by Smatch static checker
> > analyzer.
> > 
> > Following the locking pattern for peer_rhash_add lock tbl_mtx_lock mutex
> > always even if sta is not transitioning to another band.
> > This is peer_add function and a more secure locking should not cause
> > performance regression.
> > 
> > Fixes: d673cb6fe6c0 ("wifi: ath11k: fix peer addition/deletion error on sta band migration")
> > Reported-by: Dan Carpenter <error27@gmail.com>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> 
> I assume you only compile tested this and I'll add that to the commit log. It's
> always good to know how the patch was tested.
> 

Hi, I just got time to test this and works correctly on my Xiaomi
AX3600.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

-- 
	Ansuel
