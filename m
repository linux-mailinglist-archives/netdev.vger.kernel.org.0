Return-Path: <netdev+bounces-7439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A5F6720482
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95F311C20F08
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F1F1C74E;
	Fri,  2 Jun 2023 14:30:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD8D1C74B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:30:48 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F01AB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:30:46 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30c4c1fd511so1417179f8f.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 07:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685716245; x=1688308245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqpGP6eZWdKwE1n/jD+uG9LLcrNRd7Qa8Ms1Jjk9RN8=;
        b=fdSLUSq+5jaL/WZ+G1OZQFRHioy5+piJzx3BzOAH1xvOs6ncSz86/TmKyGeAt1NiBU
         UUVoYDFtWXNFCJ8FJ7mAzbn7AsFxycbmwzZiUl5+WULhL0GI274vYenzUJJc2odqboi0
         L7ohm+uyr6W6UC17kQ92yTzNc/9/KGB+5plNJ/ntLZmgotfUKwK7kAx67z/hifBUvglF
         IdHtKkXnIo2xALhOsjW5YCKChZmd3GeB6VM5ZxKR0XeScgDwTFVPaqUgC+EJuswVeu6e
         gFdOvtwWbK3VD0LIpxeLg3F4Ht3YAmwRIYK8t0rNHleT4BxxYSu9qicVabygZFZ2acPK
         G/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685716245; x=1688308245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqpGP6eZWdKwE1n/jD+uG9LLcrNRd7Qa8Ms1Jjk9RN8=;
        b=lKg2N1fvy1gjpi/tSwuMMvw1407FMesO2uRT+QdHev+33G/ZNyj4pRFPwZfJGALg3t
         aGjWNbFD6eI+ZSHu751y/t4cqH1WP1QiSsGNNT9yqlmaBcH0x6hFhvGar7fIowmAtJN8
         oLptsm5hPbDDC4TQSpV9kqg/KHsjmVW4LqIj4Hc6EbvgfOWHgwduokZZn4VLl9QygWal
         27IlhtIstvCBPQQrwPlxeLKq3EjR3QL61Y0SfMdY4WarQWBH3Z9EIqFZLx+WRBgPcWL2
         VGMOfRJ4SISMSOA2C6EB0YkFGAE4d8utFPneaiuhvWQv6JecEb5SlXprakm/pqGTuNka
         T0dQ==
X-Gm-Message-State: AC+VfDwkNSbDj4EEEXG8F75lZWUWsf2/eJR37cxeN3HwK9arfKASVmyc
	H3/tG5wr5HEoaZMBiQUqNhY=
X-Google-Smtp-Source: ACHHUZ7WKbsR9UXHly6GUxQ08SbDIWZOpCvBagX/q+am2zG1OwPbqAT8LtV6ATx02haMqbh1OPNsvQ==
X-Received: by 2002:adf:ef88:0:b0:306:2dd6:95d3 with SMTP id d8-20020adfef88000000b003062dd695d3mr123319wro.22.1685716244842;
        Fri, 02 Jun 2023 07:30:44 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c020400b003f4268f51f5sm2201135wmi.0.2023.06.02.07.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 07:30:44 -0700 (PDT)
Date: Fri, 2 Jun 2023 17:30:42 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: use xpcs_create_mdiodev()
Message-ID: <20230602143042.6df6tpndb75dlspd@skbuf>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
 <E1q55Ie-00Bp52-AA@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q55Ie-00Bp52-AA@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 02:58:40PM +0100, Russell King (Oracle) wrote:
> Use the new xpcs_create_mdiodev() creator, which simplifies the
> creation and destruction of the mdio device associated with xpcs.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

