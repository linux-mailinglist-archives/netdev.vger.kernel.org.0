Return-Path: <netdev+bounces-6835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C20D7185E8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABF9E1C20F2C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD45168A6;
	Wed, 31 May 2023 15:16:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A216F171AA
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:16:26 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1413107;
	Wed, 31 May 2023 08:16:24 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so60790665e9.0;
        Wed, 31 May 2023 08:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685546183; x=1688138183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SuL4u8NzTzbnlOrPBhBiIT/DZ/NXRnMhr+o5QeIpT0o=;
        b=aKr5dn2uRnABDYMBhkNLWSP4IaVFEeBUlJG0YdoJ15Qi5Q7YgV02NAJMJt+EE57M7R
         0+bPKa/R8dVdByRt3URoplMccb0IqfB/8uDb7Hu5XwvSpG9oSj5D+mov4wq5pTU57kZW
         lxXnBgbcCU7ykp6HREmXIo/Q3aH2nSMc33GH2RWgggJvNPaOVghUxCK3MzPii6nCDPq+
         zToAzyFfa2KMVPCGstkY/djAISeIMrhnsUwlgy3nFy0FnwqXsb+VOfCofpwPmpfvPP5v
         TJFWCo3Y88syuHPOf4jpz6RYn+327gZr/S9psN5pDbswstqv+RxGo4wKMUchtowpeWWk
         rqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685546183; x=1688138183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SuL4u8NzTzbnlOrPBhBiIT/DZ/NXRnMhr+o5QeIpT0o=;
        b=Xgn00WSOuLrQ78nkm7/jxD7/5T6zaPCGUABU8rYkCgOe3CYB3OlBhILo5OMSnlZpm0
         rkGk4DlS7oYpIP4febNeqvcirhgLqtVisNtATgs8Qn8gBUgWmXqgeigdj4jQNZ2/vSLX
         SEivzWr0iGJt99GUz9CjQQNT5hxhWcblqzjGusTU/8OJwPd8aXI4if8xHr2VSa+PQfiD
         QWw8DSiF+nxrgisjPM61XIIBePAv9oRQDjAibEMB2x7WKmk+RsKmZ6zro2UL13zUOYqt
         MEX2tF7yS3SxSz3KdTQnr0IsfC3tvOcxULERibS4a4/dCKAyjCJ8T6d5trarFhSGeqqO
         czew==
X-Gm-Message-State: AC+VfDxHsrVwp8nK7NXkYrhhjPADU+6tCKOdjYsWMfaZQGfuWhGdcRfU
	dUG7iw/jh1T7D8Qs0GSCDxTSGjxbMsSJpA==
X-Google-Smtp-Source: ACHHUZ7RQnmGF+ZZ+I9iWTtL6nVCnFLckZgRaav6zMIPHFFuiQJgj0ALtYiCT69UWnUbaYERevDwUw==
X-Received: by 2002:a7b:cd8a:0:b0:3f4:2255:8608 with SMTP id y10-20020a7bcd8a000000b003f422558608mr4403587wmj.31.1685546183139;
        Wed, 31 May 2023 08:16:23 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m23-20020a7bca57000000b003f5ffba9ae1sm21225612wml.24.2023.05.31.08.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 08:16:22 -0700 (PDT)
Date: Wed, 31 May 2023 18:16:20 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "A. Sverdlin" <alexander.sverdlin@siemens.com>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	linux-kernel@vger.kernel.org,
	Egil Hjelmeland <privat@egil-hjelmeland.no>
Subject: Re: [PATCH] net: dsa: lan9303: allow vid != 0 in port_fdb_{add|del}
 methods
Message-ID: <20230531151620.rqdaf2dlp5jsn6mk@skbuf>
References: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531143826.477267-1-alexander.sverdlin@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 04:38:26PM +0200, A. Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@siemens.com>
> 
> LAN9303 doesn't associate FDB (ALR) entries with VLANs, it has just one
> global Address Logic Resolution table [1].
> 
> Ignore VID in port_fdb_{add|del} methods, go on with the global table. This
> is the same semantics as hellcreek or RZ/N1 implement.
> 
> Visible symptoms:
> LAN9303_MDIO 5b050000.ethernet-1:00: port 2 failed to delete 00:xx:xx:xx:xx:cf vid 1 from fdb: -2
> LAN9303_MDIO 5b050000.ethernet-1:00: port 2 failed to add 00:xx:xx:xx:xx:cf vid 1 to fdb: -95
> 
> [1] https://ww1.microchip.com/downloads/en/DeviceDoc/00002308A.pdf
> 
> Fixes: 0620427ea0d6 ("net: dsa: lan9303: Add fdb/mdb manipulation")
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
> ---

Thanks for taking a look. Although it would probably be safer to add:

Fixes: 2fd186501b1c ("net: dsa: be louder when a non-legacy FDB operation fails")

since I'm not sure it has a reason to be backported beyond that. Anyway:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Yuck.

