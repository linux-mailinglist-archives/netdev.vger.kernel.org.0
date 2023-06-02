Return-Path: <netdev+bounces-7441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD80720489
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE55F280D89
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538B0111A2;
	Fri,  2 Jun 2023 14:31:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478C8258F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:31:53 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF0FA3
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:31:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-30ae95c4e75so2171134f8f.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685716310; x=1688308310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kgRGxKJTkzZJB/BH2EsYvltFFFFXWiQe93iW4AT+nD8=;
        b=gr/M3ZOJt0G5fovoDVX8+K97FNnosjZDI9pSNcwIHoT2O12T26CWZR2Kh3fjmyCneZ
         WgmrJPeIXc7Lpw8ZZkYiprZpmZRjqmy6mhnQdRkc0zCjmIdC+M1z/KTVxWVT1+FkX983
         NvLubRjaEp2bCYxZzExDHFlXZZ9o3HeO9xqNrTpE1cbQgtUaWmvkptxuZALkVCwFyaRX
         ErWfV9SDUVxBT+b1fOyBwcMvcKeUB5CRWndtc1s5suntp8cQ35qzviceywRr74j9VX4c
         2QGGelKMS2WcWVVfk7fJzg0/1XpwyfGCRJ+4Ma0qapzMlyy8MBOtbcKE1MypziyvStV0
         SFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685716310; x=1688308310;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kgRGxKJTkzZJB/BH2EsYvltFFFFXWiQe93iW4AT+nD8=;
        b=RdIbZgq8059S2XVUdA5FrZm+uqdO7aTvQ8Dz0h2NBhVYMdGTV5bVvBhCtCruHIxibN
         AZ7q7T43kX6YiRnsusGFuoe80H8WakoweykSmznfgU+D7xebzZ6A7/fFQdol/X7KqpcC
         o+g7lv1wKmyTONAZLUxLFIrLbqajio/thxvKO/leJrnfCXj3iTBbof7SkqSPjPxm7zlX
         4JkVhtfUqoFLtwyoLBaxrVmmM+xaKaxCHTEThG4QHPwh5tmE7YbwWoARKD4Bf+lEt5dE
         WRyDcQAFALTUd7JTfiSU68xtygKHY2phUskcIFMjCv0u2wA5PDw+Ncf59OE4j/F+ec0d
         gk8Q==
X-Gm-Message-State: AC+VfDxsLruxcicLQN0gjeNraZFQY9RXILy9V3RZwGpFzrzk+JZ9wV5J
	WO3sysXKEcq5aVL9m/gC2bU=
X-Google-Smtp-Source: ACHHUZ7JehbX9kghp5s0NPX23QasZiBxBzMN1sbbuWyr7kr2T7yR92EsHF4MW3uqDksnJVyn+5lWrg==
X-Received: by 2002:a5d:5611:0:b0:306:45ff:b527 with SMTP id l17-20020a5d5611000000b0030645ffb527mr112873wrv.45.1685716310326;
        Fri, 02 Jun 2023 07:31:50 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id w1-20020a5d6081000000b0030adc30e9f1sm1842392wrt.68.2023.06.02.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 07:31:50 -0700 (PDT)
Date: Fri, 2 Jun 2023 17:31:47 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: pcs: xpcs: remove xpcs_create() from
 public view
Message-ID: <20230602143147.ze3y6fjye3bfzktj@skbuf>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
 <E1q55Ij-00Bp58-DW@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q55Ij-00Bp58-DW@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:58:45PM +0100, Russell King (Oracle) wrote:
> There are now no callers of xpcs_create(), so let's remove it from
> public view to discourage future direct usage.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

