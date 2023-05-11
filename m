Return-Path: <netdev+bounces-1968-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 597EA6FFBF2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 668A91C20F39
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C7317721;
	Thu, 11 May 2023 21:39:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597CB20691
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:39:04 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DDE5FD8;
	Thu, 11 May 2023 14:39:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f423521b10so40534605e9.0;
        Thu, 11 May 2023 14:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683841141; x=1686433141;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HjSZxJ1OCrOJjsx8zSdGmy+TGb8Q1mUA0B2cGHXhmJQ=;
        b=g4XIPathQ4QaGvodIhWMXw1gpSEQg1sLQw9ED1Z6g0iagZwZXzplqLV0Cq6Drxm4zr
         RP7T+i1a7ZQaDg/wL0v0doHQOZ11Ssx7Pj6Cxt9JeSbc9Gizu7ni1tzE78lqXzpjDy/R
         RoAsyaufThjl4G7SC8Kout8WE1+D9vAntq/0q0g9hKItB4ATAmDZOrH3jaD1JO2fWpfs
         y3dHZ0Bar1AMgshu0sGY99Z/8YQLj41fU+D4OkoD27CeQ2PBHD9N4A9Hdxmdqv/x7H0L
         7thj3E+iE+Mgu6w56IpunlTbu1YwLMc/MCRafJ2E3A34icQF1cxrCsi408PvY9jA+OMq
         itKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683841141; x=1686433141;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjSZxJ1OCrOJjsx8zSdGmy+TGb8Q1mUA0B2cGHXhmJQ=;
        b=eVurTbMYRsB/7/XekUMEDzew8jfN82rE1ObqI4awEvZvzaapQtfqfc60z6g6MAXXmX
         zmt8xhchXNDC4p4RTGwfLxkFHEUvQWqxXeNygXAgZgh0jo+ov2y3tM4Axhd6r1UWcxFz
         U0UMfdivGIHb9XyZ4XToGn7T4FqEFTIQ3U8yKvljB0NKIM61r8f4klRhaHqvSGsgJLLN
         Cpvlt5KGaQ9/5E7XhhPBEfk/4Dkhbup7Sqz9zuTsypA5Qgzf1bjzSXj6I9fJ5uW30Djb
         OwHvGwJP6JhKV99PdMDHEwKeLnHw3/nUjpRZP/nDOpbWFJQ6igU7T6XQilw0eVs+F53A
         mPgQ==
X-Gm-Message-State: AC+VfDzMHxKGLnGwmTd/hqCNVa9V52JjwUpaV2p/6n+XsvKPCV2cOeg+
	YR14qVaLBFaQtlFRB+6GFSDByamaXgjUTg==
X-Google-Smtp-Source: ACHHUZ5RtOOeDpznVkS+cqz0IGxbm1e0p+0/TbPVhYfuNhEHSQL88OMypoFgbi9LK91oRHyc2rXMbg==
X-Received: by 2002:a1c:f704:0:b0:3f1:9526:22be with SMTP id v4-20020a1cf704000000b003f1952622bemr15032505wmh.23.1683841141081;
        Thu, 11 May 2023 14:39:01 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l2-20020a1c7902000000b003f195d540d9sm26490561wme.14.2023.05.11.14.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 14:39:00 -0700 (PDT)
Date: Fri, 12 May 2023 00:38:58 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: alexis.lothore@bootlin.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	herve.codina@bootlin.com, miquel.raynal@bootlin.com,
	milan.stevanovic@se.com, jimmy.lalande@se.com,
	pascal.eberhard@se.com
Subject: Re: [PATCH net v2 3/3] net: dsa: rzn1-a5psw: disable learning for
 standalone ports
Message-ID: <20230511213858.jdrp7josynmzbwcp@skbuf>
References: <20230511170202.742087-1-alexis.lothore@bootlin.com>
 <20230511170202.742087-1-alexis.lothore@bootlin.com>
 <20230511170202.742087-4-alexis.lothore@bootlin.com>
 <20230511170202.742087-4-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511170202.742087-4-alexis.lothore@bootlin.com>
 <20230511170202.742087-4-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 07:02:02PM +0200, alexis.lothore@bootlin.com wrote:
> From: Clément Léger <clement.leger@bootlin.com>
> 
> When ports are in standalone mode, they should have learning disabled to
> avoid adding new entries in the MAC lookup table which might be used by
> other bridge ports to forward packets. While adding that, also make sure
> learning is enabled for CPU port.
> 
> Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

